@Teams = new Mongo.Collection('teams')
Teams.allow
  insert: (userId, team) -> userId && team.ownerId == userId
  update: (userId, team) -> team.ownerId == userId
  remove: (userId, team) -> team.ownerId == userId

Meteor.methods
  teamUpdate: (teamId, newName) ->
    check(Meteor.userId(), String)
    check(teamId, String)
    check(newName, String)

    team = Teams.findOne(teamId)

    if team?
      Teams.update(teamId, $set: {name: newName})
      games = Games.find({_id: {$in: team.games}}).fetch()

      # Update games this team is a part of
      if games.length
        _(games).each (game) ->
          updatedTeam = _(game.teams).findWhere({id: teamId})
          if updatedTeam?
            updatedTeam.name = newName
            Games.update({_id: game._id}, {$set: {teams: game.teams}})
      return teamId
    else
      throw new Meteor.Error("team-does-not-exist", "This team doesn't exist in the database")

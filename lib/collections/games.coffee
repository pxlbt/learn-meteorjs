@Games = new Meteor.Collection('games')
Games.allow
  insert: (userId, game) -> userId && (game.ownerId == userId)
  update: (userId, game) -> game.ownerId == userId
  remove: (userId, game) -> game.ownerId == userId

Meteor.methods
  gamesInsert: (teamOneId, teamTwoId) ->

    # Check user is signed in
    check(Meteor.userId(), String)

    # Check that our IDs are strings
    check(teamOneId, String)
    check(teamTwoId, String)

    # Make sure the two teams exist
    teamOne = Teams.findOne({_id: teamOneId})
    teamTwo = Teams.findOne({_id: teamTwoId})

    if teamOne && teamTwo
      teamOneData = {
        id: teamOne._id
        name: teamOne.name
        score: 0
      }

      teamTwoData = {
        id: teamTwo._id
        name: teamTwo.name
        score: 0
      }
    else
      throw new Meteor.Error("team-does-not-exist", "One of the teams doesn't exist in the database");

    game = {
      ownerId: Meteor.userId()
      created_at: new Date()
      teams: [teamOneData, teamTwoData]
      completed: false
    }

    gameId = Games.insert(game)

    # Update each team's cached array of game ids
    Teams.update({_id: teamOneData.id}, {$addToSet: { games: gameId}})
    Teams.update({_id: teamTwoData.id}, {$addToSet: { games: gameId}})

    {_id: gameId}

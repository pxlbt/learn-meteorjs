# client/views/games.coffee

Template.games.helpers
  teams: Teams.find()
  games: Games.find()
  creating: -> Session.get 'creating-game'

Template.games.events
  "click .create": (e, tpl) ->
    e.preventDefault()
    Session.set 'creating-game', true

  "click .cancel": (e, tpl) ->
    e.preventDefault()
    Session.set 'creating-game', null

  "submit form.form-create": (e, tpl) ->
    e.preventDefault()

    teamOneId = tpl.$("select[name='teamOne']").val()
    teamTwoId = tpl.$("select[name='teamTwo']").val()

    Meteor.call 'gamesInsert', teamOneId, teamTwoId, (error, response) ->
      e.preventDefault()

    teamOneId = tpl.$("select[name='teamOne']").val()
    teamTwoId = tpl.$("select[name='teamTwo']").val()

    Meteor.call 'gamesInsert', teamOneId, teamTwoId, (error, response) ->

      # Display the error to the user and abort
      if error
        return alert(error.reason)

      Session.set 'creating-game', false

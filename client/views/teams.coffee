Template.teams.helpers
  teams: -> Teams.find()
  creating: -> Session.get 'creating'

Template.teams.events
  "click .create": (e, tpl) ->
    e.preventDefault()
    Session.set 'creating', true

  "click .cancel": (e, tpl) ->
    Session.set 'creating', false

  "submit form.form-create": (e, tpl) ->
    e.preventDefault()
    team = {ownerId: Meteor.userId(), name: tpl.$("input[name='name']").val()}
    if team.name.length
      Teams.insert team
      Session.set 'creating', false

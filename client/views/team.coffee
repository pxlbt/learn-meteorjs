Template.team.helpers
  editing: -> Session.get('editing') == @_id

Template.team.events
  "click .edit": (e, tpl) ->
    e.preventDefault()
    Session.set('editing', @_id)

  "submit form.form-edit": (e, tpl) ->
    e.preventDefault()

    teamName = tpl.$("input[name='name']").val()
    Meteor.call 'teamUpdate', @_id, teamName, (error, resposne) ->
      Session.set('editing', null)

  "click .cancel": (e, tpl) ->
    e.preventDefault()
    Session.set('editing', null)

  "click .remove": (e, tpl) ->
    e.preventDefault()
    Teams.remove(@_id)

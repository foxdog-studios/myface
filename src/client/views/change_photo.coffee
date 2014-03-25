Template.changePhoto.events
  'click [name="change-photo"]': (event) ->
    event.preventDefault()
    Meteor.users.update Meteor.userId(),
      $unset:
        'profile.image': null


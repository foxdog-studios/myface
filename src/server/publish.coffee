Meteor.publish 'userProfiles', ->
  Meteor.users.find {}, fields: 'profile': 1

Meteor.publish 'cells', ->
  Cells.find()


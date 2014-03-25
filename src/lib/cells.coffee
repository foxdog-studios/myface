@GRID_WIDTH = 4
@GRID_HEIGHT = 4

@Cells = new Meteor.Collection 'cells'
@Cells.allow
  update: (userId, doc) ->
    return userId


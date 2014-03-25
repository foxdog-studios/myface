Template.grid.helpers
  cells: ->
    cursor = Cells.find {},
      fields:
        x: 1
        y: 1
      reactive: false
      sort: [['y', 'asc'], ['x', 'asc']]
    flatCells = cursor.fetch()
    for y in [0...GRID_HEIGHT]
      for x in [0...GRID_WIDTH]
        flatCells[y * GRID_WIDTH + x]

  disabled: ->
    unless Meteor.user()
      'disabled'


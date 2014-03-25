Template.grid.helpers
  gridRow: ->
    # Ensure they come out sorted
    cells = Cells.find({}, sort: [['y', 'asc'], ['x', 'asc']]).fetch()
    rows = []
    for i in [0...GRID_HEIGHT]
      columns = for j in [0...GRID_WIDTH]
        cells[i * GRID_HEIGHT + j]
      rows.push
        column: columns
    rows

  ownerImage: ->
    owner = Meteor.users.findOne @ownerId
    return unless owner
    owner.profile.image

Template.grid.events
  'click button': (event) ->
    event.preventDefault()
    id = $(event.target).val()
    Cells.update id,
      $set:
        owner: Meteor.user().username
        ownerId: Meteor.userId()


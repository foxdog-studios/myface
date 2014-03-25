Template.grid.helpers
  disabled: ->
    unless Meteor.user()
      'disabled'

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
    owner.profile.cellImages[@y][@x].image

Template.grid.events
  'click button': (event) ->
    user = Meteor.user()
    return unless user?
    event.preventDefault()
    id = $(event.target).val()
    Cells.update id,
      $set:
        owner: user.username
        ownerId: Meteor.userId()


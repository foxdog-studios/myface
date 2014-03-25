Template.gridCell.helpers
  style: ->
    cell = Cells.findOne @_id, fields: ownerId: 1
    return unless cell?.ownerId?
    owner = Meteor.users.findOne cell.ownerId,
      fields:
        'profile.cellImages': 1
    image = owner.profile?.cellImages[@y]?[@x]?.image
    return unless image?
    """
    background: url(#{ image });
    background-size: 100% 100%;
    """

Template.gridCell.events
  'click button': (event, template) ->
    event.preventDefault()
    Cells.update template.data._id,
      $set:
        ownerId: Meteor.userId()


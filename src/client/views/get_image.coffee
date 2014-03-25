@IMAGE_WIDTH = 640
@IMAGE_HEIGHT = 480

Template.getImage.rendered = ->
  # Make sure this is only run once per template instance.
  return if @_alreadyCalled?
  @_alreadyCalled = true

  @_video = @find 'video'
  @_stream = null

  # Create a canvas to use a place to resize the user's photograph.
  canvas = document.createElement 'canvas'
  canvas.width
  ctx = canvas.getContext '2d'

  img = @find 'img'

  @_takePhotograph = (event) =>
    event.preventDefault()
    return unless @_stream?
    ctx.drawImage @_video, 0, 0, canvas.width, canvas.height
    Session.set 'photograph', canvas.toDataURL 'image/jpeg'

  @_video.addEventListener 'click', @_takePhotograph, false

  successCallback = (stream) =>
    @_stream = stream
    @_video.src = window.URL.createObjectURL stream

  errorCallback = (error) ->
    console.warn "Failed to start video stream: #{ error }"
    Session.set 'hasGetUserMedia', false

  navigator.getUserMedia video: true, successCallback, errorCallback

  $video = $(@_video)
  @_hideVideo = Deps.autorun ->
    if Session.get('photograph')?
      $video.hide()
    else
      $video.show()

Template.getImage.helpers
  hasGetUserMedia: ->
    Session.get 'hasGetUserMedia'

  photograph: ->
    Session.get 'photograph'

  videoClass: ->
    console.log Session.get 'photograph'
    if Session.get('photograph')?
      'hidden'

Template.getImage.events
  'click [name="ok"]': (event) ->
    event.preventDefault()
    Meteor.users.update Meteor.userId(),
      $set:
        'profile.image': Session.get 'photograph'

  'click [name="retake"]': (event) ->
    event.preventDefault()
    Session.set 'photograph'

Template.getImage.destroyed = ->
  # Make sure the user's webcam is deactivated.
  if @_stream?
    @_stream.stop()
    delete @_stream

  # Remove the click listener from the video element.
  @_video.removeEventListener 'click', @_takePhotograph, false
  delete @_video


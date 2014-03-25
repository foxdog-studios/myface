@IMAGE_WIDTH = 640
@IMAGE_HEIGHT = 480

Template.getImage.rendered = ->
  # Make sure this is only run once per template instance.
  return if @_alreadyCalled?
  @_alreadyCalled = true

  @_video = @find 'video'
  @_stream = null

  # Create a canvas to use a place to resize the user's photograph.
  @_canvas = document.createElement 'canvas'
  @_canvas.width = IMAGE_WIDTH
  @_canvas.height = IMAGE_HEIGHT
  ctx = @_canvas.getContext '2d'

  # Take a photograph when the user clicks the video stream.
  @_takePhotograph = (event) =>
    event.preventDefault()
    return unless @_stream?
    ctx.drawImage @_video, 0, 0, @_canvas.width, @_canvas.height
    Session.set 'photograph', @_canvas.toDataURL 'image/jpeg'
  @_video.addEventListener 'click', @_takePhotograph, false

  # Request and, if allowed, start streaming the user's webcam.
  options =
    video: true,
    audio: false
  successCallback = (stream) =>
    @_stream = stream
    @_video.src = window.URL.createObjectURL stream
  errorCallback = (error) ->
    console.warn "Failed to start video stream: #{ error }"
    Session.set 'hasGetUserMedia', false
  navigator.getUserMedia options, successCallback, errorCallback


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
  'click [name="ok"]': (event, template) ->
    event.preventDefault()
    Meteor.users.update Meteor.userId(),
      $set:
        'profile.image': Session.get 'photograph'

  'click [name="retake"]': (event, template) ->
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

  # Make the canvas can be garabage collected.
  delete @_canvas

updateUserImage = (canvas) ->
  console.log canvas


@IMAGE_WIDTH = 640
@IMAGE_HEIGHT = 480

Template.getImage.rendered = ->
  # 1) Make sure this is only run once per template instance.
  return if @_alreadyCalled?
  @_alreadyCalled = true

  # 2) Create a canvas to use as a place to resize the user's
  #    photograph.
  @_canvas = document.createElement 'canvas'
  @_canvas.width = IMAGE_WIDTH
  @_canvas.height = IMAGE_HEIGHT
  ctx = @_canvas.getContext '2d'

  # 3) Video element to show the user their webcam strem.
  @_video = @find 'video'

  # 4) Hide the webcam stream once the user has taken a photograph and
  #    we're waiting for the user to accept it.
  $video = $(@_video)
  @_hideVideo = Deps.autorun ->
    if Session.get('photograph')?
      $video.hide()
    else
      $video.show()

  # 5) Take a photograph when the user clicks the video stream.
  @_stream = null
  @_takePhotograph = (event) =>
    event.preventDefault()
    return unless @_stream?
    ctx.drawImage @_video, 0, 0, @_canvas.width, @_canvas.height
    Session.set 'photograph', @_canvas.toDataURL 'image/jpeg'
  @_video.addEventListener 'click', @_takePhotograph, false

  # 6) Request and, if allowed, start streaming the user's webcam.
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

Template.getImage.helpers
  hasGetUserMedia: ->
    Session.get 'hasGetUserMedia'

  photograph: ->
    Session.get 'photograph'

Template.getImage.events
  'click [name="ok"]': (event, template) ->
    event.preventDefault()
    updateUserImage template._canvas

  'click [name="retake"]': (event, template) ->
    event.preventDefault()
    Session.set 'photograph'

Template.getImage.destroyed = ->
  # Clear session variables used by only this template
  Session.set 'photograph'

  # Desctruct everything we did in rendered in reverse order.

  # 6) Make sure the user's webcam is deactivated.
  if @_stream?
    @_stream.stop()
    delete @_stream

  # 5) Remove the click listener from the video element an
  @_video.removeEventListener 'click', @_takePhotograph, false

  # 4) Stop hiding and showing the webcam stream.
  @_hideVideo.stop()
  delete @_hideVideo

  # Allow objects referenced in 3, 2, and 1 to be garabage collected.
  delete @_video
  delete @_canvas
  delete @_alreadyCalled

updateUserImage = (canvas) ->
  Meteor.users.update Meteor.userId(),
    $set:
      'profile.image': Session.get 'photograph'


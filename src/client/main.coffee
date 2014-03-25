Meteor.startup ->
  navigator.getUserMedia = navigator.getUserMedia \
    || navigator.webkitGetUserMedia \
    || navigator.mozGetUserMedia \
    || navigator.msGetUserMedia

  Session.set 'hasGetUserMedia', navigator.getUserMedia?


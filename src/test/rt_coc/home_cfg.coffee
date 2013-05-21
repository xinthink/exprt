# configure exprt
exports.exprt =
  basePath: '/'

exports.index = (req, res) ->
  res.send 'Hello World!'

exports.welcome = (req, res) ->
  res.send 'Welcome!'

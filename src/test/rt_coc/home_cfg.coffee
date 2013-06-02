# configure exprt
exports.exprt =
  basePath: '/'

exports.index = (req, res) ->
  res.send 'Hello World!'

exports.welcome = (req, res) ->
  res.send 'Welcome!'


# --------------------------------
# /user
#
exports.listUser = (req, res) ->
  res.send 'list all users'

exports.listUser.exprt =
  route: '/user/list'

exports.rmUser = (req, res) ->
  res.send 'Displaying user #' + req.params.id

exports.rmUser.exprt =
  route: '/user/remove'
  method: 'post'
  routeParams:
    id: /\d+/

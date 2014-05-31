
exports.ls = (req, res) ->
  res.send 'Displaying user #' + req.params.id

exports.ls.exprt =
  route: '/user/list'


exports.show = (req, res) ->
  res.send 'Displaying user #' + req.params.id

exports.show.exprt =
  routeParams:
    id: /\d+/


exports.remove = (req, res) ->
  res.send 'Removed user #' + req.params.id

exports.remove.exprt =
  method: 'post'
  routeParams:
    id: /\d+/


exports.vars = (req, res) ->
  res.send 'Show item of user: ' + req.params.user + req.params.item

exports.vars.exprt = routeParams: ['user', 'item']


exports.varMappings = (req, res) ->
  res.send 'Show item of user: ' + req.params.user + req.params.item

exports.varMappings.exprt = routeParams:
  user: ((req, res, next, id) -> req.user = findUser(id); next())
  item: null

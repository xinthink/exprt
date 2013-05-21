
exports.index = (req, res) ->
  res.render 'login'

exports.logout = (req, res) ->
  res.send 'logout!'

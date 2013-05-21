
exports.index = (req, res) ->
  res.render 'login'

exports.index_post = (req, res) ->
  res.render 'login'

exports.logout = (req, res) ->
  res.send 'logout!'

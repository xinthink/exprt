###

exprt
https://github.com/xinthink/exprt

Copyright (c) 2013 xinthink
Licensed under the MIT license.

###

'use strict'


# filtering name with inclusion/exclusion rules
exports.acceptsName = (name, filter) ->
  not filter or (->
    inc = filter.include or /.*/
    exc = filter.exclude or /\0/
    (name.match inc) and not name.match exc
  )()


# merge a with b
exports.merge = (a, b) ->
  result = {}
  pushAll result, a
  pushAll result, b


# push all props of values into target
exports.pushAll = pushAll = (target, values) ->
  target[k] = v for k, v of values if values?
  target

###

exprt
https://github.com/xinthink/exprt

Copyright (c) 2013 xinthink
Licensed under the MIT license.

###

'use strict'

fs     = require 'fs'
path   = require 'path'
assert = require 'assert'


#
# app  -
# opts -
# void
module.exports = (app, opts={}) ->
  assert opts.path, 'routes path is required'
  baseDir = path.resolve opts.path

  (fs.readdirSync baseDir).forEach (f) ->
    # console.log 'scanning ' + f
    accepted = acceptsName f, opts.fileFilter
    registerRoutes app, baseDir, f, opts if accepted


acceptsName = (name, filter) ->
  not filter or (->
    inc = filter.include or /.*/
    exc = filter.exclude or /\0/
    (name.match inc) and not name.match exc
  )()


registerRoutes = (app, baseDir, f, opts) ->
  baseName = path.basename f, path.extname f  # url base path of these routes
  file     = path.join baseDir, baseName

  console.log "loading routes from #{file}"
  routes = require file

  basePath = determinePath baseName
  registerRoute app, basePath, name, fn, opts for name, fn of routes


determinePath = (name) ->
  '/' + (('/' if name.match /^index(_.*)?$/) or name)


registerRoute = (app, basePath, name, fn, opts) ->
  accepted = fn instanceof Function and acceptsName name, opts.ftFilter
  if accepted
    p = determinePath name
    doRegisterRoute app, 'get', (path.join basePath, p), fn


doRegisterRoute = (app, method, rt, fn) -> app[method] rt, fn


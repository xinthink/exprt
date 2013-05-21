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


# Scan route definitions, and register them to Express app
# app  - the Express app
# opts - Options
#   path: the dir under which route handlers can be found, required
#   fileFilter: regexp filtering handler files, optional
#   handlerFilter: regexp filtering handler functions, optional
# void
module.exports = (app, opts={}) ->
  assert opts.path, 'routes path is required'
  baseDir = path.resolve opts.path

  (fs.readdirSync baseDir).forEach (f) ->
    # console.log 'scanning ' + f
    accepted = acceptsName f, opts.fileFilter
    registerRoutes app, baseDir, f, opts if accepted


# filtering file/handler name
acceptsName = (name, filter) ->
  not filter or (->
    inc = filter.include or /.*/
    exc = filter.exclude or /\0/
    (name.match inc) and not name.match exc
  )()


# looks for routes defined in the given file
registerRoutes = (app, baseDir, f, opts) ->
  baseName = path.basename f, path.extname f
  fullPath = path.join baseDir, baseName

  # console.log "loading routes from #{fullPath}"
  routes = require fullPath

  basePath = determineBasePath baseName, routes
  registerRoute app, basePath, name, fn, opts for name, fn of routes


# convert a name into URL part
determineBasePath = (name, routes) ->
  routes.exprt?.basePath or
    '/' + (('/' if name.match /^index(_.*)?$/) or name)


# check and register a single handler
registerRoute = (app, basePath, name, fn, opts) ->
  accepted = fn instanceof Function and acceptsName name, opts.handlerFilter
  doRegisterRoute app, basePath, name, fn if accepted


doRegisterRoute = (app, basePath, name, fn) ->
  [rt, method] = determineRoute name
  rt = path.join basePath, rt
  console.log "route: #{method}, '#{rt}', #{name}"
  app[method] rt, fn


# find url part and http method of the given handler
determineRoute = (name) ->
  rt     = ''
  method = 'get'

  m = /^([^_]*)(?:_(\w*))?$/.exec name
  if m
    rt     = m[1]
    method = m[2].toLowerCase() if m[2]?
  rt = '' if rt is 'index'
  [rt, method]

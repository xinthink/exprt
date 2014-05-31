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

fns = require './common'


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
    accepted = fns.acceptsName f, opts.fileFilter
    registerRoutes app, baseDir, f, opts if accepted


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
  accepted = fn instanceof Function and fns.acceptsName name, opts.handlerFilter
  doRegisterRoute app, basePath, name, fn if accepted


doRegisterRoute = (app, basePath, name, fn) ->
  rt = determineRoute app, basePath, name, fn
  console.log "route: #{rt.method}, '#{rt.route}', #{name}"
  app[rt.method] rt.route, fn


# find url part and http method of the given handler
determineRoute = (app, basePath, name, fn) ->
  convention = determineConventionalRoute basePath, name
  configure  = getConfiguredRoute fn
  processRoute app, fns.merge convention, configure  # override convention with configure


getConfiguredRoute = (fn) -> fn.exprt or {}


determineConventionalRoute = (basePath, name) ->
  rt     = ''
  method = 'get'

  m = /^([^_]*)(?:_(\w*))?$/.exec name
  if m
    rt     = m[1]
    method = m[2].toLowerCase() if m[2]?
  rt = '' if rt is 'index'

  route:  path.join basePath, rt
  method: method


processRoute = (app, rt) ->
  return rt unless rt.routeParams

  if typeof rt.routeParams is 'string' or rt.routeParams instanceof String
    rt.route = path.join rt.route, ":#{rt.routeParams}"
  else if rt.routeParams.length
    rt.route = path.join rt.route, ":#{v}" for v in rt.routeParams
  else
    for name, callback of rt.routeParams
      rt.route = path.join rt.route, ":#{name}" if name
      app.param name, callback if name and callback

  return rt

'use strict'

path = require 'path'

exprt = require '../lib/exprt.js'

describe 'express route generator', ->
  app =
    get:   (args...) ->
    post:  (args...) ->
    param: (args...) ->

  beforeEach ->
    spy app, 'get'
    spy app, 'post'
    spy app, 'param'

  afterEach ->
    app.get.restore()
    app.post.restore()
    app.param.restore()


  it 'scans all files under a dir', ->
    exprt app,
      path: __dirname + '/rt_simple'

    app.get.callCount.should.eql 4
    app.post.should.not.called


  it 'scans filtered files under a dir', ->
    exprt app,
      path: __dirname + '/rt_simple'
      fileFilter:
        include: /i/
        exclude: /^index\./

    app.get.callCount.should.eql 2  # 2 routes in login
    app.post.should.not.called


  it 'scans all files under a dir, with handler filter', ->
    exprt app,
      path: __dirname + '/rt_simple'
      handlerFilter:
        include: /i/
        exclude: /^logout\./

    app.get.callCount.should.eql 3  # 3 'index' methods
    app.post.should.not.called


  it 'registers routes with basic COC rules', ->
    exprt app,
      path: __dirname + '/rt_coc'
      fileFilter: exclude: /_\w+\./

    app.get.should.calledWith '/', sinon.match.func

    app.get.should.calledWith '/home', sinon.match.func
    app.get.should.calledWith '/home/welcome', sinon.match.func

    app.get.should.calledWith '/login', sinon.match.func
    app.post.should.calledWith '/login', sinon.match.func
    app.get.should.calledWith '/login/logout', sinon.match.func

    app.get.callCount.should.eql 5
    app.post.callCount.should.eql 1


  it 'registers routes overriding conventions', ->
    exprt app,
      path: __dirname + '/rt_coc'
      fileFilter: include: /^home_cfg\./

    # home_cfg
    app.get.should.calledWith '/', sinon.match.func
    app.get.should.calledWith '/welcome', sinon.match.func

    # /user
    app.get.should.calledWith '/user/list', sinon.match.func
    app.post.should.calledWith '/user/remove/:id', sinon.match.func
    app.param.should.calledWith 'id', sinon.match.regexp

    app.get.callCount.should.eql 3
    app.post.callCount.should.eql 1


  it 'registers routes mixed conventions with configurations', ->
    exprt app,
      path: __dirname + '/rt_coc'
      fileFilter: include: /^user_mixed\./

    # user_mixed
    app.get.should.calledWith '/user/list', sinon.match.func

    app.get.should.calledWith '/user_mixed/show/:id', sinon.match.func
    app.param.should.calledWith 'id', sinon.match.regexp

    app.post.should.calledWith '/user_mixed/remove/:id', sinon.match.func
    app.param.should.calledWith 'id', sinon.match.regexp

    app.get.should.calledWith '/user_mixed/vars/:user/:item', sinon.match.func
    app.param.should.not.calledWith 'user', sinon.match.any
    app.param.should.not.calledWith 'item', sinon.match.any

    # app.get.should.calledWith '/user_mixed/varMappings/:user', sinon.match.func
    # app.param.should.calledWith 'user', sinon.match.func
    # app.param.should.not.calledWith 'item', sinon.match.any

    app.get.callCount.should.eql 3
    app.post.callCount.should.eql 1


  it 'supports custom route parameter mappings', ->
    exprt app,
      path: __dirname + '/rt_coc'
      fileFilter: include: /^user_map\./

    # user_map
    app.get.should.calledWith '/user_map/varMappings/:user/:item', sinon.match.func
    app.param.should.calledWith 'user', sinon.match.func
    app.param.should.not.calledWith 'item', sinon.match.any

    app.get.callCount.should.eql 1
    app.post.callCount.should.eql 0

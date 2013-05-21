'use strict'

path = require 'path'

exprt = require '../lib/exprt.js'

describe 'express route generator', ->
  app =
    get:  (args...) ->
    post: (args...) ->

  beforeEach ->
    spy app, 'get'
    spy app, 'post'

  afterEach ->
    app.get.restore()
    app.post.restore()


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
      fileFilter: exclude: /_cfg\./

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
      fileFilter: include: /_cfg\./

    app.get.should.calledWith '/', sinon.match.func
    app.get.should.calledWith '/welcome', sinon.match.func

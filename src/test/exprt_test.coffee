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
      path: __dirname + '/rt_simple',
      fileFilter:
        include: /i/
        exclude: /^index\./

    app.get.callCount.should.eql 2  # 2 routes in login
    app.post.should.not.called


  it 'registers routes with basic COC rules', ->
    exprt app,
      path: __dirname + '/rt_coc',
      fileFilter:
        exclude: /^login\./

    app.get.should.calledWith '/', sinon.match.func
    app.get.should.calledWith '/home/', sinon.match.func
    app.get.callCount.should.eql 2
    app.post.should.not.called

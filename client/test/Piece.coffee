'use strict'

requirejs = require('requirejs')
assert = require('chai').assert

Piece = null

requirejs ['./coffee/Piece.js']
, (Piece_) =>
  Piece = Piece_

suite 'Piece', ->
  test '.colors', ->
    colors = Piece.colors
    assert.lengthOf colors, 5
    assert.includeMembers colors, ['red', 'blue', 'green', 'yellow', 'purple']

  test 'constructor', ->
    colors = Piece.colors

    colors.forEach (c) ->
      assert.doesNotThrow -> new Piece(c)

    colors.forEach (c) ->
      p = new Piece(c)
      assert.equal p.color, c


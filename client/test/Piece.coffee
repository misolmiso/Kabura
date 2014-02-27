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

  test '.R', ->
    assert.ok Piece.R.toString() == 'red'

  test '.B', ->
    assert.ok Piece.B.toString() == 'blue'

  test '.G', ->
    assert.ok Piece.G.toString() == 'green'

  test '.Y', ->
    assert.ok Piece.Y.toString() == 'yellow'

  test '.P', ->
    assert.ok Piece.P.toString() == 'purple'

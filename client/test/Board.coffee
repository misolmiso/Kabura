'use strict'

requirejs = require('requirejs')
assert = require('chai').assert

Board = null
Piece = null

requirejs ['./coffee/Board.js', './coffee/Piece.js']
, (Board_, Piece_) =>
  Board = Board_
  Piece = Piece_

suite 'Board', ->
  board_array = null

  setup ->
    P = Piece
    @board_array = [
      [P.R, P.R, P.R, P.Y, P.Y, P.Y]
      [P.R, P.R, P.R, P.Y, P.Y, P.Y]
      [P.R, P.R, P.R, P.Y, P.Y, P.Y]
      [P.R, P.R, P.R, P.Y, P.Y, P.Y]
      [P.R, P.R, P.R, P.Y, P.Y, P.Y]
    ]
  
  test '.width', ->
    assert.equal Board.width, 6
  
  test '.height', ->
    assert.equal Board.height, 5
  
  test '#array', ->
    b = new Board(@board_array)
    h = b.array
    
    assert.instanceOf h, Array
    assert.lengthOf h, Board.height
  
    h.forEach (w) ->
      assert.instanceOf w, Array
      assert.lengthOf w, Board.width

      w.forEach (p) ->
        assert.instanceOf p, Piece


'use strict';

requirejs = require('requirejs')
assert = require('chai').assert

Board = null
Piece = null

requirejs ['./coffee/Board.js', './coffee/Piece.js']
, (Board_, Piece_) =>
  Board = Board_
  Piece = Piece_

suite 'Board', ->
  test '.width', ->
    assert.equal Board.width, 6
  
  test '.height', ->
    assert.equal Board.height, 5
  
  test '#array', ->
    board = new Board()
    w = board.array
    
    assert.instanceOf w, Array
    assert.lengthOf w, Board.width
  
    w.forEach (h) ->
        assert.instanceOf h, Array
        assert.lengthOf h, Board.height
  
        h.forEach (p) ->
            assert.instanceOf p, Piece

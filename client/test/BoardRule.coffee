'use strict'

requirejs = require('requirejs')
assert = require('chai').assert

Board = null
Piece = null
BoardRule = null

requirejs ['./coffee/Board.js', './coffee/Piece.js', './coffee/BoardRule.js']
, (Board_, Piece_, BoardRule_) =>
  Board = Board_
  Piece = Piece_
  BoardRule = BoardRule_

suite 'BoardRule', ->
  board = null

  setup ->
    P = Piece
    @board = new Board [
      [P.R, P.R, P.R, P.Y, P.Y, P.Y],
      [P.B, P.B, P.B, P.Y, P.B, P.Y],
      [P.B, P.B, P.Y, P.B, P.Y, P.B],
      [P.B, P.Y, P.B, P.Y, P.B, P.Y],
      [P.B, P.B, P.Y, P.B, P.Y, P.B],
    ]

  test 'findLinedUpPieces', ->
    r = BoardRule.findLinedUpPieces(@board)

    console.log(r)
    console.log({length:4, color:Piece.B.color, col:0, row:1, isHorizontal:false})
    
    assert.lengthOf r, 4


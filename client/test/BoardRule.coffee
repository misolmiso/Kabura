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
    lines = BoardRule.findLinedUpPieces(@board)

    assert.lengthOf lines, 4

    for line in lines
      assert.operator line.length, '>=', 3

      if line.isHorizontal
        for col in [(line.col)...(line.col + line.length)]
          assert.equal @board.get(line.row, col).color, line.color
      else
        for row in [(line.row)...(line.row + line.length)]
          assert.equal @board.get(row, line.col).color, line.color

  test 'markToDeletePieces', ->
    to_delete_pieces_expected = [
      [true, true, true, true, true, true],
      [true, true, true, false, false, false],
      [true, false, false, false, false, false],
      [true, false, false, false, false, false],
      [true, false, false, false, false, false]
    ]

    BR = BoardRule

    lines = BR.findLinedUpPieces(@board)
    actual = BR.markToDeletePieces(lines, @board)

    assert.deepEqual(actual, to_delete_pieces_expected)
    

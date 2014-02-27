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
    
  test 'calcNumberOfToGeneratePicesForColumns', ->
    BR = BoardRule

    board = @board
    lines = BR.findLinedUpPieces(board)
    delete_pieces = BR.markToDeletePieces(lines, board)

    actual = BR.calcNumberOfPicesToGenerateForColumns(delete_pieces)
    expected = [5, 2, 2, 1, 1, 1]

    assert.deepEqual(actual, expected)

  test 'generatePieces', ->
    BR = BoardRule

    board = @board
    lines = BR.findLinedUpPieces(board)
    delete_pieces = BR.markToDeletePieces(lines, board)
    ns = BR.calcNumberOfPicesToGenerateForColumns(delete_pieces)

    actual_array = BR.generatePieces(ns)

    expected = [5, 2, 2, 1, 1, 1]

    for col, i in actual_array
      assert.lengthOf col, expected[i]
    
  test 'calcPieceMovings', ->
    BR = BoardRule
    P = Piece

    board = new Board [
      [P.R, P.B, P.R, P.B, P.Y, P.B]
      [P.B, P.B, P.R, P.Y, P.Y, P.Y],
      [P.B, P.Y, P.B, P.Y, P.B, P.Y],
      [P.B, P.B, P.Y, P.B, P.Y, P.B],
      [P.Y, P.B, P.B, P.Y, P.B, P.Y],
    ]

    lines = BR.findLinedUpPieces(board)
    delete_pieces = BR.markToDeletePieces(lines, board)
    ns = BR.calcNumberOfPicesToGenerateForColumns(delete_pieces)
    actual = BR.calcPieceMovings(delete_pieces, ns)

    expected = [
      {from:{row:  0, col: 0}, to:{row: 3, col: 0}},
      {from:{row: -1, col: 0}, to:{row: 2, col: 0}},
      {from:{row: -2, col: 0}, to:{row: 1, col: 0}},
      {from:{row: -3, col: 0}, to:{row: 0, col: 0}},
      {from:{row:  0, col: 3}, to:{row: 1, col: 3}},
      {from:{row:  0, col: 4}, to:{row: 1, col: 4}},
      {from:{row:  0, col: 5}, to:{row: 1, col: 5}},
      {from:{row: -1, col: 3}, to:{row: 0, col: 3}},
      {from:{row: -1, col: 4}, to:{row: 0, col: 4}},
      {from:{row: -1, col: 5}, to:{row: 0, col: 5}}
    ]

    assert.equal actual.length, expected.length

    compare = (a, b) ->
      if a.from.row < b.from.row || a.from.col < b.from.col
        return -1
      else
        return 1

    sorted_actual = actual.sort(compare)
    sorted_expected = expected.sort(compare)

    for i in [0...expected.length]
      assert.deepEqual sorted_actual[i], sorted_expected[i]
      
      
  test 'makeBoardMove', ->
    BR = BoardRule
    P = Piece
    
    board = new Board [
      [P.R, P.B, P.R, P.B, P.Y, P.B]
      [P.B, P.B, P.R, P.Y, P.Y, P.Y],
      [P.B, P.Y, P.B, P.Y, P.B, P.Y],
      [P.B, P.B, P.Y, P.B, P.Y, P.B],
      [P.Y, P.B, P.B, P.Y, P.B, P.Y],
    ]

    to_gen_pieces = [
      [P.Y, P.R, P.B], [], [], [P.B], [P.P], [P.P]
    ]

    expected = new Board [
      [P.B, P.B, P.R, P.B, P.P, P.P]
      [P.R, P.B, P.R, P.B, P.Y, P.B],
      [P.Y, P.Y, P.B, P.Y, P.B, P.Y],
      [P.R, P.B, P.Y, P.B, P.Y, P.B],
      [P.Y, P.B, P.B, P.Y, P.B, P.Y],
    ]

    lines = BR.findLinedUpPieces(board)
    delete_pieces = BR.markToDeletePieces(lines, board)
    ns = BR.calcNumberOfPicesToGenerateForColumns(delete_pieces)
    movings = BR.calcPieceMovings(delete_pieces, ns)
    
    actual = BR.makeBoardMove(board, movings, to_gen_pieces)

    assert.deepEqual actual.array, expected.array

'use strict'


  
define ["coffee/Piece.js", "coffee/Board.js", "underscore"]
, (Piece, Board, _) ->
  class BoardRule
    class @LinedUp
      constructor: (@length, @color, @col, @row, @isHorizontal) ->

    @findLinedUpPieces: (board) ->
      group = (line) ->
        ret = [{index:0, length:1, color:line[0].color}]
        for p, i in line[1..]
          if p.color == _.last(ret).color
            _.last(ret).length += 1
          else
            ret.push {index:i + 1, length:1, color:p.color}
        return ret
     
      array = board.array
      ret = []

      LinedUp = BoardRule.LinedUp
     
      ret = ret.concat _.flatten(array.map((row, row_index) ->
        return group(row).map((g) ->
          new LinedUp(g.length, g.color, g.index, row_index, true)
        ).filter((g) -> g.length >= 3)
      ))

      ret = ret.concat _.flatten(_.zip.apply(_, array).map((col, col_index) ->
        return group(col).map((g) ->
          new LinedUp(g.length, g.color, col_index, g.index, false)
        ).filter((g) -> g.length >= 3)
      ))

      return ret

    @markToDeletePieces: (lines, board) ->
      array = board.array
      ret_board = ((false for p in row) for row in array)

      for line in lines
        if line.isHorizontal
          for c in [0...line.length]
            ret_board[line.row][line.col + c] = true
        else
          for r in [0...line.length]
            ret_board[line.row + r][line.col] = true
      return ret_board

    @calcNumberOfPicesToGenerateForColumns: (mark_array) ->
      sum = (array) -> array.reduce(((sum, c) -> sum + c), 0)
      column_sum = (column) ->
        sum((1 for r in [0...Board.height] when mark_array[r][column]))
       
      return (column_sum(c) for c in [0...Board.width])

    @generatePieces: (number_for_columns) ->
      gen = () -> new Piece(_.sample(Piece.colors))
      return ((gen() for p in [0...n]) for n in number_for_columns)

    
  return BoardRule



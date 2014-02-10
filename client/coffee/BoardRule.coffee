'use strict'


  
define ["underscore"], (_) ->
  class BoardRule
    class @LinedUp
      constructor: (@length, @color, @col, @row, @isHorizontal) ->

    @findLinedUpPieces = (board) ->
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
  return BoardRule



'use strict'


  
define ["underscore"], (_) ->
  class BoardRule
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
     
      ret = ret.concat _.flatten(array.map((row, row_index) ->
        return group(row).map((g) ->
          return {
            length:g.length, color:g.color,
            col:g.index, row:row_index, isHorizontal:true
            }
        ).filter((g) -> g.length >= 3)
      ))

      ret = ret.concat _.flatten(_.zip.apply(_, array).map((col, col_index) ->
        return group(col).map((g) ->
          return {
            length:g.length, color:g.color,
            col:col_index, row:g.index, isHorizontal:false
            }
        ).filter((g) -> g.length >= 3)
      ))

      return ret
  return BoardRule



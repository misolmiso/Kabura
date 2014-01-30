'use strict'

define ['./Piece.js'], (Piece) ->
  class Board
    @height = 5
    @width = 6

    constructor: ->
      @array = [0...6].map (h) ->
        [0...5].map (p) -> new Piece()

  return Board



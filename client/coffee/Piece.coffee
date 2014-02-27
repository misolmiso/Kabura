'use strict'

define [], ->
  class Piece
    @colors = ['red', 'blue', 'green', 'yellow', 'purple']
    [@R, @B, @G, @Y, @P] = @colors.map (n) ->
      new Piece(n)

    toString: ->
      return Piece.colors[@color]

    constructor: (color) ->
      @color = Piece.colors.indexOf(color)

  return Piece


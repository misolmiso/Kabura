'use strict'

define [], () ->
  class Board
    @height = 5
    @width = 6

    get: (row, col) ->
      return @array[row][col]

    constructor: (array) ->
      @array = array

  return Board



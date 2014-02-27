'use strict'

setTimer = (eventTarget, waitTime, onTimeEvent, waitTimeEvent = ->) ->
  targetTime = waitTime + Date.now()
  event = ->
    now = Date.now()
    if now > targetTime
      eventTarget.removeEventListener 'enterframe', event
      onTimeEvent(now)
    else
      waitTimeEvent(targetTime - now)
      
  eventTarget.on 'enterframe', event

require ["coffee/Board", "coffee/BoardRule", "enchant", "underscore"]
, (Board, BoardRule, e, _) =>
  enchant('')

  game = new Core(window.innerWidth, window.innerHeight)

  game.fps = 30

  class Piece extends Sprite
    @imageUri = "client/material/piece.png"
    @color = ['red', 'blue', 'green', 'yellow', 'purple']
    @colorToIndex = _.object(@color, _.range(@color.length))
    
    constructor: (color) ->
      super(128, 128)
      @color = color
      @image = game.assets[Piece.imageUri]
      @frame = Piece.colorToIndex[color]

    resetColor: (color) ->
      @color = color
      @frame = Piece.colorToIndex[color]
      
  game.preload(Piece.imageUri)

  touch = null

  game.onload = ->
    label = new Label('')
    game.rootScene.addChild(label)
    
    setTimer game, 100000, (now) ->
      label.text = "0"
      game.stop()
    , (left) ->
      label.text = left
    
    pieces = _.flatten((_.keys(Piece.colorToIndex)
    .map((k) -> new Piece(k)) for c in [0...6]))

    delete_pieces = (pieces) ->
      board_array = ((null for c in [0...6]) for r in [0...5])
      
      for p in pieces
        board_array[p.row][p.col] = p
      
      board = new Board(board_array)
      lines = BoardRule.findLinedUpPieces(board)
      marked = BoardRule.markToDeletePieces(lines, board)
      ns = BoardRule.calcNumberOfPicesToGenerateForColumns(marked)
      movings = BoardRule.calcPieceMovings(marked, ns)

      to_add_pieces = ([] for c in [0...6])

      for rs, row in board.array
        for p, col in rs
          if marked[row][col]
            to_add_pieces[col].push(p)

      new_board = BoardRule.makeBoardMove(board, movings, to_add_pieces)

      for moving in movings
        {from:from, to:to} = moving
        p = new_board.array[to.row][to.col]
        p.moveTo(from.col * 128, from.row * 128)
        p.resetColor(_.sample(Piece.color))
        p.row = to.row
        p.col = to.col
        p.tl.exec(-> @moving = on)
        p.tl.moveTo(to.col * 128, to.row * 128, 10).exec(-> @moving = off)

      pieces = _.flatten(new_board.array)

      if marked.filter((f) -> f).length != 0
        game.rootScene.tl.delay(10).exec ->
          delete_pieces(pieces)

    for p, n in pieces
      p.col = (n % 6)
      p.row = Math.floor(n / 6)

      p.moveTo(p.col * 128, p.row * 128)
      
      game.rootScene.addChild(p)

      p.moving = no
      
      p.org_x = null
      p.org_y = null
   
      p.on 'touchstart', (evt) ->
        if touch isnt null
          return

        touch = this
        
        for op in pieces
          op.touchEnabled = off

        game.rootScene.removeChild(this)
        game.rootScene.addChild(this)

        
        @org_x = evt.x
        @org_y = evt.y
        @opacity -= 0.7
   
      p.on 'touchmove', (evt) ->
        if touch isnt this
          return

        for op in _.reject(pieces, (p) => p is this)
          if not op.moving and @within(op, 70)
            op.moving = yes
            [op.col, op.row, @col, @row] = [@col, @row, op.col, op.row]
            op.tl.moveTo(op.col * 128, op.row * 128, 10).exec -> @moving = no
            
        @x += evt.x - @org_x
        @y += evt.y - @org_y
        @org_x = evt.x
        @org_y = evt.y
   
      p.on 'touchend', (evt) ->
        delete_pieces(pieces)

        if @x != @col * 128 and @y != @row * 128
          @tl.moveTo(@col * 128, @row * 128, 10)
        
        if touch isnt this
          return
        touch = null
        
        for op in pieces
          op.touchEnabled = on

        @org_x = evt.x
        @org_y = evt.y
        @opacity = 1


  game.start()


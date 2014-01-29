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

require ["enchant", "underscore"], (e, _) =>
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
      for p in pieces
        p.del = off

      for r, cs of _.groupBy(pieces, (p) -> p.row)
        sorted = _.sortBy(cs, (c) -> c.col)
        temp = [[_.first(sorted)]]
        for c in _.rest(sorted)
          if _.first(_.last(temp)).color is c.color
            _.last(temp).push(c)
          else
            temp.push [c]
        for ts in temp when ts.length >= 3
          for t in ts
            t.del = on for t in ts

      for r, cs of _.groupBy(pieces, (p) -> p.col)
        sorted = _.sortBy(cs, (c) -> c.row)
        temp = [[_.first(sorted)]]
        for c in _.rest(sorted)
          if _.first(_.last(temp)).color is c.color
            _.last(temp).push(c)
          else
            temp.push [c]
        for ts in temp when ts.length >= 3
          for t in ts
            t.del = on for t in ts

      for r, cs of _.groupBy(pieces, (p) -> p.col)
        {true:dels, false:lefs} = _.groupBy(cs, (p) -> p.del)

        for p, i in _.sortBy(lefs, (p) -> -p.row)
          p.row = (4 - i)

        if dels?
          for p, i in dels
            p.resetColor(_.sample(_.keys(Piece.colorToIndex)))
            p.moveTo(p.x, (-i - 1) * 128)
            p.row = 4 - lefs.length - i
        
      for p in pieces
        p.tl.exec(-> @moving = on)
        p.tl.moveTo(p.col * 128, p.row * 128, 10).exec(-> @moving = off)

      if pieces.filter((p) -> p.del).length != 0
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
        
        if touch isnt this
          return
        touch = null
        
        for op in pieces
          op.touchEnabled = on

        @org_x = evt.x
        @org_y = evt.y
        @opacity = 1


  game.start()


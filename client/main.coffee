'use strict'

setTimer = (eventTarget, waitTime, onTimeEvent, waitTimeEvent = ->) ->
    targetTime = waitTime + Date.now()
    event = =>
        now = Date.now()
        if now > targetTime
            eventTarget.removeEventListener 'enterframe', event
            onTimeEvent(now)
        else
            waitTimeEvent(now)
            
    eventTarget.on 'enterframe', event

require ["lib/enchant"], =>
    enchant('')

    game = new Core(window.innerWidth, window.innerHeight)

    game.fps = 30

    class Piece extends Sprite
        @imageUri = "client/material/piece.png"
        @colorToIndex = {
            red: 0, blue: 1, green: 2, yellow: 3, purple: 4
            }
        
        constructor: (color) -> 
            super(128, 128)
            @image = game.assets[Piece.imageUri]
            @frame = Piece.colorToIndex[color]
    game.preload(Piece.imageUri)
    
    game.onload = =>
        red = new Piece('red')
        game.rootScene.addChild(red)
                        
        org_x = null
        org_y = null

        red.on 'touchstart', (evt) ->
            console.log 'red touchstart'
            org_x = evt.x
            org_y = evt.y
            this.opacity -= 0.7

        red.on 'touchmove', (evt) ->
            console.log 'red touchmove'
            this.x += evt.x - org_x
            this.y += evt.y - org_y
            org_x = evt.x
            org_y = evt.y

        red.on 'touchend', (evt) ->
            console.log 'red touchend'
            org_x = evt.x
            org_y = evt.y
            this.opacity += 0.7

    game.start()


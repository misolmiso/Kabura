'use strict'

require ["lib/enchant"], =>
    enchant('')

    game = new Core(window.innerWidth, window.innerHeight)

    game.fps = 30
    
    game.onload = =>
        red = new Sprite(120, 120)
        red.backgroundColor = 'red'
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

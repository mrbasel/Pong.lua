require('constants')
require('player')
require('ball')
require('game')

math.randomseed(os.time())

if arg[2] == "debug" then
    require("lldebugger").start()
end

function love.load()
    game = Game:create()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
end

function love.update(dt)
    game:loop(dt)
end

function love.draw()
    love.graphics.rectangle("fill", game.ball.x, game.ball.y, BALL_WIDTH, BALL_HEIGHT)
    love.graphics.rectangle("fill", game.player1.x, game.player1.y, PLAYER_WIDTH, PLAYER_HEIGHT)
    love.graphics.rectangle("fill", game.player2.x, game.player2.y, PLAYER_WIDTH, PLAYER_HEIGHT)
    love.graphics.print(game.player1.score .. ' - ' .. game.player2.score)
end

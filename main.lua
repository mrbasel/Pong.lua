require('constants')
require('player')
require('ball')
require('game')

font = love.graphics.newFont(64)
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
    love.graphics.rectangle("fill", game.player1.x, game.player1.y, PLAYER_WIDTH, PLAYER_HEIGHT)
    love.graphics.rectangle("fill", game.player2.x, game.player2.y, PLAYER_WIDTH, PLAYER_HEIGHT)

    -- dont draw ball if game is paused (pause after goal is scored)
    if game.pauseTime == 0 then
        love.graphics.rectangle("fill", game.ball.x, game.ball.y, BALL_WIDTH, BALL_HEIGHT)
    end
    
    love.graphics.print(tostring(game.player1.score), font, WINDOW_WIDTH / 4, 50, 0)
    love.graphics.print(tostring(game.player2.score), font, WINDOW_WIDTH - WINDOW_WIDTH / 4, 50, 0)

    -- dotted line
    love.graphics.setLineWidth(10)
    local i = 0
    while i < WINDOW_HEIGHT do
        love.graphics.line(WINDOW_WIDTH / 2, i, WINDOW_WIDTH / 2, i + 40)
        i = i + 70
    end
end

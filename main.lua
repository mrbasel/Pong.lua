require('constants')
require('player')
require('ball')

if arg[2] == "debug" then
    require("lldebugger").start()
end

math.randomseed(os.time())

function getStartingAngle()
    return math.random(0, 20)
end

function resetGame()
    local angle = getStartingAngle()
    if lastScoreBy == 2 then
        angle = 180 - angle
    end
    ball.x = WINDOW_WIDTH / 2
    ball.y = WINDOW_HEIGHT / 2

    ball.vx = INTIAL_BALL_SPEED * math.cos(math.rad(angle))
    ball.vy = INTIAL_BALL_SPEED * math.sin(math.rad(angle))
end

function love.load()
    pauseTime = 0
    lastScoreBy = nil

    player1 = Player:create(20)
    player2 = Player:create(WINDOW_WIDTH - 40)
   
    angle = getStartingAngle()
    if math.random(0, 1) == 1 then
        angle = 180 - angle
    end
    ball = Ball:create(angle)
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
end

function love.update(dt)
    if pauseTime > 0 then
        pauseTime = pauseTime - dt
        return
    end
    if ball.x < 0 or ball.x > WINDOW_WIDTH then
        if ball.x < 0 then
            player2:updateScore()
            lastScoreBy = 2
        else
            player1:updateScore()
            lastScoreBy = 1
        end
        resetGame()
        pauseTime = 1
        return
    end

    ball:move(dt)

    if love.keyboard.isDown('down') then
        player1:move('down', dt)
    elseif love.keyboard.isDown('up') and player1.y > 0 then
        player1:move('up', dt)
    end

    if ball.y - ((player2.y + player2.y + PLAYER_HEIGHT) / 2) > 10 and player2.y < WINDOW_HEIGHT - PLAYER_HEIGHT then
        player2:move('down', dt)
    elseif ball.y - ((player2.y + player2.y + PLAYER_HEIGHT) / 2) < -10 and player2.y > 0 then
        player2:move('up', dt)
    end

    if player1:isColliding(ball, 1) then
        ball:onCollision(player1)
    end

    if player2:isColliding(ball, 2) then
        ball:onCollision(player2)
    end
end

function love.draw()
    love.graphics.rectangle("fill", ball.x, ball.y, BALL_WIDTH, BALL_HEIGHT)
    love.graphics.rectangle("fill", player1.x, player1.y, PLAYER_WIDTH, PLAYER_HEIGHT)
    love.graphics.rectangle("fill", player2.x, player2.y, PLAYER_WIDTH, PLAYER_HEIGHT)
    love.graphics.print(player1.score .. ' - ' .. player2.score)
end

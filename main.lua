if arg[2] == "debug" then
    require("lldebugger").start()
end

WINDOW_HEIGHT = 600
WINDOW_WIDTH = 800
PLAYER_WIDTH = 20
PLAYER_HEIGHT = 80
BALL_WIDTH = 10
BALL_HEIGHT = 10
INTIAL_BALL_SPEED = 350
BALL_SPEED = 700
INTIAL_ANGLE = 20

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
    player1 = {
        x = 20,
        y = WINDOW_HEIGHT / 2,
        score = 0
    }
    player2 = {
        x = WINDOW_WIDTH - 40,
        y = WINDOW_HEIGHT / 2,
        score = 0
    }
    angle = getStartingAngle()
    if math.random(0, 1) == 1 then
        angle = 180 - angle
    end
    ball = {
        x = WINDOW_WIDTH / 2,
        y = WINDOW_HEIGHT / 2,
        vx = INTIAL_BALL_SPEED * math.cos(math.rad(angle)),
        vy =
            INTIAL_BALL_SPEED * math.sin(math.rad(angle))
    }
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
end

function love.update(dt)
    if pauseTime > 0 then
        pauseTime = pauseTime - dt
        return
    end
    if ball.x < 0 or ball.x > WINDOW_WIDTH then
        if ball.x < 0 then
            player2.score = player2.score + 1
            lastScoreBy = 2
        else
            player1.score = player1.score + 1
            lastScoreBy = 1
        end
        print("score : " .. player1.score .. " - " .. player2.score)
        resetGame()
        pauseTime = 1
        return
    end
    ball.x = ball.x + ball.vx * dt
    ball.y = ball.y + ball.vy * dt

    if ball.y > WINDOW_HEIGHT or ball.y < 0 then
        ball.vy = -ball.vy
    end

    if love.keyboard.isDown('down') and player1.y < WINDOW_HEIGHT - PLAYER_HEIGHT then
        player1.y = player1.y + 300 * dt;
    elseif love.keyboard.isDown('up') and player1.y > 0 then
        player1.y = player1.y - 300 * dt;
    end

    if ball.vx > 0 then
        if ball.y - ((player2.y + player2.y + PLAYER_HEIGHT) / 2) > 10 and player2.y < WINDOW_HEIGHT - PLAYER_HEIGHT then
            player2.y = player2.y + 300 * dt;
        elseif ball.y - ((player2.y + player2.y + PLAYER_HEIGHT) / 2) < -10 and player2.y > 0 then
            player2.y = player2.y - 300 * dt;
        end
    end

    if (checkCollisionPlayer1(player1)) then
        local y = player1.y
        local yh = player1.y + PLAYER_HEIGHT
        local center = (y + yh) / 2
        local relativeYIntersect = ball.y - center
        local normalizedRelativeYIntersect = relativeYIntersect / (PLAYER_HEIGHT / 2)
        local angle = normalizedRelativeYIntersect * math.rad(50)
        ball.vx = BALL_SPEED * math.cos(-angle)
        ball.vy = BALL_SPEED * -math.sin(-angle)
    end


    if (checkCollisionPlayer2(player2)) then
        local y = player2.y
        local yh = player2.y + PLAYER_HEIGHT
        local center = (y + yh) / 2
        local relativeYIntersect = ball.y - center
        local normalizedRelativeYIntersect = relativeYIntersect / (PLAYER_HEIGHT / 2)
        local angle = normalizedRelativeYIntersect * math.rad(50)
        ball.vx = BALL_SPEED * -math.cos(-angle)
        ball.vy = BALL_SPEED * math.sin(-angle)
    end
end

function checkCollisionPlayer1(player)
    if ball.y >= player.y and (ball.y + BALL_HEIGHT) <= (player.y + PLAYER_HEIGHT) and (player.x + PLAYER_WIDTH) >= ball.x then
        return true
    end
    return false
end

function checkCollisionPlayer2(player)
    if ball.y >= player.y and (ball.y + BALL_HEIGHT) <= (player.y + PLAYER_HEIGHT) and ball.x >= player.x then
        return true
    end
    return false
end

function love.draw()
    love.graphics.rectangle("fill", ball.x, ball.y, BALL_WIDTH, BALL_HEIGHT)
    love.graphics.rectangle("fill", player1.x, player1.y, PLAYER_WIDTH, PLAYER_HEIGHT)
    love.graphics.rectangle("fill", player2.x, player2.y, PLAYER_WIDTH, PLAYER_HEIGHT)
    love.graphics.print('1')
end

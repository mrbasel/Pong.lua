require('constants')

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
    self = {
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
            self.score = self.score + 1
            lastScoreBy = 1
        end
        print("score : " .. self.score .. " - " .. player2.score)
        resetGame()
        pauseTime = 1
        return
    end
    ball.x = ball.x + ball.vx * dt
    ball.y = ball.y + ball.vy * dt

    if ball.y > WINDOW_HEIGHT or ball.y < 0 then
        ball.vy = -ball.vy
    end

    if love.keyboard.isDown('down') and self.y < WINDOW_HEIGHT - PLAYER_HEIGHT then
        self.y = self.y + 300 * dt;
    elseif love.keyboard.isDown('up') and self.y > 0 then
        self.y = self.y - 300 * dt;
    end

    if ball.y - ((player2.y + player2.y + PLAYER_HEIGHT) / 2) > 10 and player2.y < WINDOW_HEIGHT - PLAYER_HEIGHT then
        player2.y = player2.y + 300 * dt;
    elseif ball.y - ((player2.y + player2.y + PLAYER_HEIGHT) / 2) < -10 and player2.y > 0 then
        player2.y = player2.y - 300 * dt;
    end

    if (checkCollisionPlayer1(self)) then
        local y = self.y
        local yh = self.y + PLAYER_HEIGHT
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
    love.graphics.rectangle("fill", self.x, self.y, PLAYER_WIDTH, PLAYER_HEIGHT)
    love.graphics.rectangle("fill", player2.x, player2.y, PLAYER_WIDTH, PLAYER_HEIGHT)
    love.graphics.print(self.score .. ' - ' .. player2.score)
end

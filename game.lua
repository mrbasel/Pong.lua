
Game = {}
Game.__index = Game

function Game:create()
    local angle = getStartingAngle()
    -- Random direction
    if math.random(0, 1) == 1 then
        angle = 180 - angle
    end

    local game = {
        pauseTime = 0,
        lastScoreBy = nil,
        player1 = Player:create(20),
        player2 = Player:create(WINDOW_WIDTH - 40),
        ball = Ball:create(angle)
    }
    setmetatable(game, Game)
    return game
end

function Game:loop(dt)
    if love.keyboard.isDown('down') then
        self.player1:move('down', dt)
    elseif love.keyboard.isDown('up') and self.player1.y > 0 then
        self.player1:move('up', dt)
    end

    if self.ball.y - ((self.player2.y + self.player2.y + PLAYER_HEIGHT) / 2) > 10 and self.player2.y < WINDOW_HEIGHT - PLAYER_HEIGHT then
        self.player2:move('down', dt)
    elseif self.ball.y - ((self.player2.y + self.player2.y + PLAYER_HEIGHT) / 2) < -10 and self.player2.y > 0 then
        self.player2:move('up', dt)
    end

    if self.pauseTime > 0 then
        self.pauseTime = self.pauseTime - dt
        return
    end
    if self.ball.x < 0 or self.ball.x > WINDOW_WIDTH then
        if self.ball.x < 0 then
            self.player2:updateScore()
            self.lastScoreBy = 2
        else
            self.player1:updateScore()
            self.lastScoreBy = 1
        end
        self:onScore()
        self.pauseTime = 1
        return
    end

    self.ball:move(dt)
    if self.player1:isColliding(self.ball, 1) then
        self.ball:onCollision(self.player1)
    end

    if self.player2:isColliding(self.ball, 2) then
        self.ball:onCollision(self.player2)
    end
end

function Game:onScore()
    local angle = getStartingAngle()
    if self.lastScoreBy == 2 then
        angle = 180 - angle
    end
    self.ball.x = WINDOW_WIDTH / 2
    self.ball.y = WINDOW_HEIGHT / 2

    self.ball.vx = INTIAL_BALL_SPEED * math.cos(math.rad(angle))
    self.ball.vy = INTIAL_BALL_SPEED * math.sin(math.rad(angle))
end
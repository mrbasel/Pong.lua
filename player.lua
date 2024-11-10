Player = {}
Player.__index = Player

function Player:create(x)
    local player = {
        x = x,
        y = WINDOW_HEIGHT / 2,
        score = 0
    }
    setmetatable(player, Player)
    return player
end

function Player:move(direction, dt)
    if direction == 'up' and player1.y > 0 then
        self.y = self.y - 300 * dt;
    elseif direction == 'down' and player1.y < WINDOW_HEIGHT - PLAYER_HEIGHT then
        self.y = self.y + 300 * dt;
    end
end

function Player:isColliding(ball, player)
    if player == 1 then -- theres a better way to do this but i keep running into issues :/
        return ball.y >= self.y and (ball.y + BALL_HEIGHT) <= (self.y + PLAYER_HEIGHT) and (self.x + PLAYER_WIDTH) >= ball.x
    else
        return ball.y >= self.y and (ball.y + BALL_HEIGHT) <= (self.y + PLAYER_HEIGHT) and ball.x >= self.x
    end
end

function Player:updateScore()
    self.score = self.score + 1
end

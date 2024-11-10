require('helpers')

Ball = {}
Ball.__index = Ball

function Ball:create(angle)
    local ball = {
        x = WINDOW_WIDTH / 2,
        y = WINDOW_HEIGHT / 2,
        vx = INTIAL_BALL_SPEED * math.cos(math.rad(angle)),
        vy = INTIAL_BALL_SPEED * math.sin(math.rad(angle))
    }
    setmetatable(ball, Ball)
    return ball
end

function Ball:move(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    if self.y > WINDOW_HEIGHT or self.y < 0 then
        self.vy = -self.vy
    end
end

function Ball:onCollision(player)
    local y = player.y
    local yh = player.y + PLAYER_HEIGHT
    local center = (y + yh) / 2
    local relativeYIntersect = ball.y - center
    local normalizedRelativeYIntersect = relativeYIntersect / (PLAYER_HEIGHT / 2)
    local angle = normalizedRelativeYIntersect * math.rad(50)
    local oldVx = ball.vx
    ball.vx = BALL_SPEED * math.cos(-angle)
    ball.vy = BALL_SPEED * math.sin(-angle)
    if oldVx < 0 then
        ball.vy = -ball.vy
    else 
        ball.vx = -ball.vx
    end
end

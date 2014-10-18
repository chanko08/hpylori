local Utils = require('utils')

local Class = require('hump.class')
local Vector = require('hump.vector')

local Player = Class({
    MAX_TURN_SPEED = 10,
    MAX_THRUST = 10
    })



function Player:init(state, initial_x, initial_y, beginning_radius)

    local body = love.physics.newBody(state.physics_world, initial_x, initial_y, 'dynamic')
    local shape = love.physics.newCircleShape(beginning_radius)

    self.level_state = state
    self.physics = love.physics.newFixture(body, shape, density)

    self.thrust = 0

    local register = Utils.make_registration_func(self, state.registry)

    register('keypressed', self.keypressed)
    register('update', self.update)
end

function Player:pos()
    return self.physics:getBody():getPosition()
end

function Player:angle()
    return self.physics:getBody():getAngle()
end

function Player:radius()
    return self.physics.getShape():getRadius()
end

function Player:keypressed(key)
    print('key pressed', key)
    if key == 'w' then
        self.thrust = Player.MAX_THRUST
    elseif key == 'a' then

    elseif key == 's' then

    elseif key == 'd' then

    end

end


function Player:update(dt)

    --self:update_player_orientation
    -- point player in direction of mouse
    local p = Vector(love.mouse.getPosition()) - Vector(self:pos())

    --calculate angle between up and the line made by mouse and player pos
    local current_angle = Vector(0, 1):angleTo(p)
    local a = self:angle()

    local pbody = self.physics:getBody()

    if a - current_angle > 1 then
        local sign = -1
        if a - current_angle > math.pi then
            sign = -1
        end
        --pbody:setAngularVelocity(sign * Player.MAX_TURN_SPEED)

        --print('turning...', pbody:getAngularVelocity())
        --print(current_angle, a)
    else
        --pbody:setAngularVelocity(0)
        --print('no turn...')
    end
end

return Player
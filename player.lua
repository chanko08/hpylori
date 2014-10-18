local Utils = require('utils')

local Class = require('hump.class')
local Vector = require('hump.vector')

local Player = Class({
    MAX_TURN_SPEED = 10,

    MAX_THRUST_ACCELERATION = 1,
    

    MAX_STRAFE_ACCELERATION = 0.1,
    
    MAX_MOVEMENT_SPEED = 10,
    })



function Player:init(state, initial_x, initial_y, beginning_radius)

    local body = love.physics.newBody(
        state.physics_world,
        initial_x,
        initial_y, 
        'dynamic')
    body:setLinearDamping(0.5)

    local shape = love.physics.newCircleShape(beginning_radius)

    self.level_state = state
    self.physics = love.physics.newFixture(body, shape, density)

    self.thrust = 0
    self.strafe = 0

    local register = Utils.make_registration_func(self, state.registry)

    register('keypressed', self.keypressed)
    register('keyreleased', self.keyreleased)
    register('update', self.update)
end

function Player:pos()
    return self.physics:getBody():getPosition()
end

function Player:angle()
    return self.physics:getBody():getAngle()
end

function Player:radius()
    return self.physics:getShape():getRadius()
end

function Player:keypressed(key)
    print('key pressed', key)
    if key == 'w' then
        self.thrust = Player.MAX_THRUST_ACCELERATION
    elseif key == 'a' then
        self.strafe = -1 * Player.MAX_STRAFE_ACCELERATION
    elseif key == 's' then
        self.thrust = -1 * Player.MAX_THRUST_ACCELERATION
    elseif key == 'd' then
        self.strafe = Player.MAX_STRAFE_ACCELERATION
    end
end


function Player:keyreleased( key )
    -- body
    if key == 'w' and self.thrust > 0 then
        self.thrust = 0
    elseif key == 'a' and self.strafe < 0 then
        self.strafe = 0
    elseif key == 's' and self.thrust < 0 then
        self.thrust = 0
    elseif key == 'd' and self.strafe > 0 then
        self.strafe = 0
    end
end


function Player:update(dt)

    self:update_orientation()
    self:update_movement()
end


function Player:update_orientation()
    -- point player in direction of mouse
    local p = Vector(love.mouse.getPosition()) - Vector(self:pos())

    --calculate angle between up and the line made by mouse and player pos
    local current_angle = Vector(r0, 1):angleTo(p)
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


function Player:update_movement()
    -- body
    local p = self.thrust * Vector(0, 1):rotated(self:angle())
    p = p + self.strafe * Vector(1, 0):rotated(self:angle())

    
    self.physics:getBody():applyLinearImpulse(p:unpack())


    --print(Vector(self:pos()))
    --print(Vector(self.physics:getBody():getLinearVelocity()):len())

    --cap linear veloctity
    local lin_vel = Vector(self.physics:getBody():getLinearVelocity())

    if lin_vel:len() > Player.MAX_MOVEMENT_SPEED then
        lin_vel = Player.MAX_MOVEMENT_SPEED * lin_vel:normalized()
        self.physics:getBody():setLinearVelocity(lin_vel:unpack())
    end

end

return Player
local Class = require('hump.class')
local Vector = require('hump.vector')

local Utils = require('utils')
local Direction = Utils.Direction

local default_conf = {
    MAX_TURN_SPEED = 10,

    MAX_THRUST_ACCELERATION = 1,
    

    MAX_STRAFE_ACCELERATION = 0.5,
    
    MAX_MOVEMENT_SPEED = 10,

    MOVEMENT_DAMPING_COEFF = 1,

    DENSITY = 1,

    FIRE_DELAY = 1,
    }

local Moveable = Class({})



function Moveable:init( state, initial_x, initial_y, beginning_radius, conf )
    self.conf = conf or default_conf

    local body = love.physics.newBody(
        state.physics_world,
        initial_x,
        initial_y, 
        'dynamic')

    body:setLinearDamping(self.conf.MOVEMENT_DAMPING_COEFF)

    local shape = love.physics.newCircleShape(beginning_radius)

    self.physics = love.physics.newFixture(body, shape, self.conf.DENSITY)

    self.thrust = 0
    self.strafe = 0
end

function Moveable:pos()
    return self.physics:getBody():getPosition()
end

function Moveable:angle()
    return self.physics:getBody():getAngle()
end

function Moveable:radius()
    return self.physics:getShape():getRadius()
end

function Moveable:move( direction )
    if direction == Direction.FORWARD then
        self.thrust = self.conf.MAX_THRUST_ACCELERATION

    elseif direction == Direction.BACKWARD then
        self.thrust = -1 * self.conf.MAX_THRUST_ACCELERATION

    elseif direction == Direction.STRAFE_LEFT then
        self.strafe = -1 * self.conf.MAX_STRAFE_ACCELERATION

    elseif direction == Direction.STRAFE_RIGHT then
        self.strafe = self.conf.MAX_STRAFE_ACCELERATION
    end
end

function Moveable:stop_move( direction )

    if direction == Direction.FORWARD and self.thrust > 0 then
        self.thrust = 0

    elseif direction == Direction.STRAFE_LEFT and self.strafe < 0 then
        self.strafe = 0

    elseif direction == Direction.BACKWARD and self.thrust < 0 then
        self.thrust = 0

    elseif direction == Direction.STRAFE_RIGHT and self.strafe > 0 then
        self.strafe = 0
    end


end

function  Moveable:update( dt )
    self:update_movement()
end

function Moveable:update_orientation( dir_x, dir_y )
    -- point Moveable in direction of mouse
    local p = Vector(dir_x, - dir_y) - Vector(self:pos())

    --calculate angle between up and the line made by mouse and Moveable pos
    local current_angle = Vector(1, 0):angleTo(p)

    local a = self:angle()

    local pbody = self.physics:getBody()
    pbody:setAngle(current_angle)

end


function Moveable:update_movement()
    -- body
    local p = self.thrust * Vector(1, 0):rotated(self:angle())

    p = p + self.strafe * Vector(1, 0):rotated(self:angle() + math.pi / 2)

    
    self.physics:getBody():applyLinearImpulse(p:unpack())
    
    --cap linear veloctity
    local lin_vel = Vector(self.physics:getBody():getLinearVelocity())

    if lin_vel:len() > self.conf.MAX_MOVEMENT_SPEED then
        lin_vel = self.conf.MAX_MOVEMENT_SPEED * lin_vel:normalized()
        self.physics:getBody():setLinearVelocity(lin_vel:unpack())
    end
end

return Moveable
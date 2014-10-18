local Utils = require('utils')
local Direction = Utils.Direction

local Class = require('hump.class')
local Vector = require('hump.vector')

local Player = Class({
    MAX_TURN_SPEED = 10,

    MAX_THRUST_ACCELERATION = 1,
    

    MAX_STRAFE_ACCELERATION = 0.5,
    
    MAX_MOVEMENT_SPEED = 10,

    MOVEMENT_DAMPING_COEFF = 1,

    DENSITY = 1
    })



function Player:init( state, initial_x, initial_y, beginning_radius )

    local body = love.physics.newBody(
        state.physics_world,
        initial_x,
        initial_y, 
        'dynamic')

    body:setLinearDamping(Player.MOVEMENT_DAMPING_COEFF)

    local shape = love.physics.newCircleShape(beginning_radius)

    self.level_state = state
    self.physics = love.physics.newFixture(body, shape, Player.DENSITY)

    self.thrust = 0
    self.strafe = 0
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

function Player:move( direction )
    if direction == Direction.FORWARD then
        self.thrust = Player.MAX_THRUST_ACCELERATION

    elseif direction == Direction.BACKWARD then
        self.thrust = -1 * Player.MAX_THRUST_ACCELERATION

    elseif direction == Direction.STRAFE_LEFT then
        self.strafe = -1 * Player.MAX_STRAFE_ACCELERATION

    elseif direction == Direction.STRAFE_RIGHT then
        self.strafe = Player.MAX_STRAFE_ACCELERATION
    end


    if key == ' ' then
        self.fire_bullets = true
    end
end


function Player:stop_move( direction )
    -- body
    print('stop', '')
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

function Player:update_orientation( mouse_world_x, mouse_world_y )
    -- point player in direction of mouse
    local p = Vector(mouse_world_x, -mouse_world_y) - Vector(self:pos())

    --calculate angle between up and the line made by mouse and player pos
    local current_angle = Vector(1, 0):angleTo(p)

    local a = self:angle()

    local pbody = self.physics:getBody()
    pbody:setAngle(current_angle)

end


function Player:update_movement()
    -- body
    local p = self.thrust * Vector(1, 0):rotated(self:angle())

    p = p + self.strafe * Vector(1, 0):rotated(self:angle() + math.pi / 2)

    
    self.physics:getBody():applyLinearImpulse(p:unpack())
    
    --cap linear veloctity
    local lin_vel = Vector(self.physics:getBody():getLinearVelocity())

    if lin_vel:len() > Player.MAX_MOVEMENT_SPEED then
        lin_vel = Player.MAX_MOVEMENT_SPEED * lin_vel:normalized()
        self.physics:getBody():setLinearVelocity(lin_vel:unpack())
    end
end

return Player
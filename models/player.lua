local Utils = require('utils')
local Direction = Utils.Direction
local Moveable = require('models.moveable')
local Bullet   = require('models.bullet')

local Class = require('hump.class')
local Vector = require('hump.vector')
local inspect = require('inspect')


local PLAYER_CONF = {
    MAX_TURN_SPEED = 10,

    MAX_THRUST_ACCELERATION = 10,
    

    MAX_STRAFE_ACCELERATION = 5,
    
    MAX_MOVEMENT_SPEED = 100,

    MOVEMENT_DAMPING_COEFF = 1,

    DENSITY = 1,

    FIRE_DELAY = 0.25,
    RADIUS = 64
    }

local Player = Class({})
Player:include(Moveable)


function Player:init( state, initial_x, initial_y)
    Moveable.init(self, state, initial_x, initial_y, PLAYER_CONF.RADIUS, PLAYER_CONF)


    self.is_firing_bullets = false
    self.fire_bullet_delay = PLAYER_CONF.FIRE_DELAY
    self.bullets = {}
end

function Player:fire_bullets( is_firing )
    self.is_firing_bullets = is_firing
end

function  Player:update( dt )
    Moveable.update(self, dt)


    for i,bullet in ipairs(self.bullets) do
        bullet:update(dt)
    end

    if self.is_firing_bullets == false then
        return
    end

    self.fire_bullet_delay = self.fire_bullet_delay - dt

    if self.fire_bullet_delay <= 0 then
        --spawn bullets
        self.fire_bullet_delay = PLAYER_CONF.FIRE_DELAY

        --print(self:angle())
        local bpos = Vector(self:pos()) + Vector(PLAYER_CONF.RADIUS + 25, 0):rotated(self:angle())
        local x,y = bpos:unpack()
        local bullet = Bullet(self.state, x, y, self:angle())
        table.insert(self.bullets, bullet)
    end
    
    
end


function Player:fired_bullets()
    return self.bullets
end

return Player
local Utils = require('utils')
local Direction = Utils.Direction
local Moveable = require('models.moveable')

local Class = require('hump.class')
local Vector = require('hump.vector')


local PLAYER_CONF = {
    MAX_TURN_SPEED = 10,

    MAX_THRUST_ACCELERATION = 1,
    

    MAX_STRAFE_ACCELERATION = 0.5,
    
    MAX_MOVEMENT_SPEED = 10,

    MOVEMENT_DAMPING_COEFF = 1,

    DENSITY = 1,

    FIRE_DELAY = 1,
    }

local Player = Class({})
Player:include(Moveable)


function Player:init( state, initial_x, initial_y, beginning_radius )
    Moveable.init(self, state, initial_x, initial_y, beginning_radius, PLAYER_CONF)


    self.is_firing_bullets = false
    self.fire_bullet_delay = Player.FIRE_DELAY
end

function Player:fire_bullets( is_firing )
    self.is_firing_bullets = is_firing
end

function  Player:update( dt )
    Moveable.update(self, dt)

    if self.is_firing_bullets == false then
        return
    end

    self.fire_bullet_delay = self.fire_bullet_delay - dt
    if self.fire_bullet_delay <= 0 then
        --spawn bullets
    end

end

return Player
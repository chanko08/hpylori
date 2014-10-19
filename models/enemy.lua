local Class = require('hump.class')
local Vector = require('hump.vector')

local Moveable = require('models.moveable')
local Direction = require('utils').Direction

local ENEMY_CONF = {
    MAX_TURN_SPEED = 10,

    MAX_THRUST_ACCELERATION = 1000,
    

    MAX_STRAFE_ACCELERATION = 0.5,
    
    MAX_MOVEMENT_SPEED = 1000,

    MOVEMENT_DAMPING_COEFF = 0,

    DENSITY = 1,

    RADIUS = 5,
    }

local Enemy = Class({})
Enemy:include(Moveable)

function Enemy:init( state, initial_x, initial_y)
    --print(initial_x, initial_y, angle)
    Moveable.init(self, state, initial_x, initial_y, ENEMY_CONF.RADIUS, ENEMY_CONF)
end

return Enemy
local Class = require('hump.class')

local Player = Class({})

function Player:init(state, initial_x, initial_y, beginning_radius)

    local body = love.physics.newBody(state.physics_world, initial_x, initial_y)
    local shape = love.physics.newCircleShape(beginning_radius)

    self.physics = love.physics.newFixture(body, shape, density)
end



return Player
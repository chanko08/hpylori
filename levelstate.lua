local Class  = require('hump.class')
local Signal = require('hump.signal')

local Player = require('player')


local LevelState = Class({})
local registry = nil
local physics_world = nil

function LevelState:init()
    self.registry = Signal.new()
    self.registry:emit('state_init', key)
    

    love.physics.setMeter(64)
    self.physics_world = love.physics.newWorld(0, 0, true)

    self.player = Player(self, 0, 0, 64)
end

function LevelState:enter( prev, ... )
    self.registry:emit('state_enter', key)
end

function LevelState:leave()
    self.registry:emit('state_leave', key)
end

function LevelState:update( dt )
    -- body
    self.physics_world:update(dt)
    self.registry:emit('update', key)
end

function LevelState:draw()
    -- body
    self.registry:emit('draw', key)

end

function LevelState:keypressed( key )
    -- body
    if key == 'escape' then
        love.event.quit()
    end

    self.registry:emit('keypressed', key)
end

function LevelState:keyreleased( key )
    -- body
    self.registry:emit('keyreleased', key)
end

function LevelState:mousepressed( x, y, button )
    -- body
    self.registry:emit('mousepressed', x, y, button)
end

function LevelState:mousereleased( x, y, button )
    -- body
    self.registry:emit('mousereleased', x, y, button)
end

return LevelState
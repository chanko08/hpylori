local Class  = require('hump.class')
local Signal = require('hump.signal')

local Player = require('models.player')
local PlayerController = require('controllers.playercontroller')
local Renderer = require('renderer')


local LevelState = Class({})
local registry = nil
local physics_world = nil

function LevelState:init()
    self.registry = Signal.new()
    self.registry:emit('state_init', key)
    

    love.physics.setMeter(64)
    self.physics_world = love.physics.newWorld(0, 0, true)

    self.player = Player(self, 0, 0, 64)

    self.controllers = {}
    self.controllers.Player = PlayerController(self, self.player)

    self.renderer = Renderer(self)
end

function LevelState:enter( prev, ... )
    self.registry:emit('state_enter', prev, ...)
end

function LevelState:leave()
    self.registry:emit('state_leave')
end

function LevelState:update( dt )
    -- bodys
    self.registry:emit('mousemove', self.renderer:world_coords(love.mouse.getPosition()))
    self.physics_world:update(dt)
    self.registry:emit('update', dt)
end

function LevelState:draw()
    -- body
    self.registry:emit('draw')

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
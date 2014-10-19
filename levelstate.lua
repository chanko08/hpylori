local Class  = require('hump.class')
local Signal = require('hump.signal')

local PlayerController = require('controllers.playercontroller')
local EnemySpawnController = require('controllers.enemyspawncontroller')
local Renderer = require('renderer')


local LevelState = Class({})
local registry = nil
local physics_world = nil

function LevelState:init()
    self.registry = Signal.new()
    self.registry:emit('state_init', key)
    

    love.physics.setMeter(64)
    self.physics_world = love.physics.newWorld(0, 0, true)

    --these are attached later by the controllers for these models
    self.player = {}
    self.enemies = {}

    self.controllers = {}
    self.controllers.Player = PlayerController(self, 0, 0)
    self.controllers.enemies = {}
    self.controllers.EnemySpawner = EnemySpawnController(self, self.controllers.enemies)

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
    local mx, my = self.renderer:world_coords(love.mouse.getPosition())

    self.registry:emit('mousemove', self.renderer.camera:mousepos())
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
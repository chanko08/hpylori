local Utils = require('utils')
local Direction = Utils.Direction

local Class = require('hump.class')
local Vector = require('hump.vector')
local Timer = require('hump.timer')

local Enemy = require('models.enemy')

local EnemyController = Class({})


function EnemyController:init( state, initial_x, initial_y )
    self.state = state
    self.enemy = Enemy( state, initial_x, initial_y)
    table.insert(state.enemies, self.enemy)
   
    local register = Utils.make_registration_func(self, state.registry)

    register('update', self.update)
end


function EnemyController:update( dt )
    self.enemy:update(dt)
end

return EnemyController
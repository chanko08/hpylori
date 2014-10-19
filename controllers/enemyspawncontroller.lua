local Utils = require('utils')
local Direction = Utils.Direction

local Class = require('hump.class')
local Vector = require('hump.vector')
local Timer = require('hump.timer')

local EnemyController = require('controllers.enemycontroller')

ENEMY_SPAWN_CONF = {
    SPAWN_DELAY = 1
}


local EnemySpawnController = Class({})


function EnemySpawnController:init( state, enemy_controllers )
    self.state = state
    self.enemy_controllers = enemy_controllers

    self.wrap = Utils.self_wrapper(self)

    self.enemy_spawn_timer = Timer()
    self.enemy_spawn_timer:add(ENEMY_SPAWN_CONF.SPAWN_DELAY, self.wrap(self.spawn))

    local register = Utils.make_registration_func(self, state.registry)

    register('update', self.update)
end


function EnemySpawnController:update( dt )
    self.enemy_spawn_timer:update(dt)
end

function EnemySpawnController:spawn()
    self.enemy_spawn_timer:add(ENEMY_SPAWN_CONF.SPAWN_DELAY, self.wrap(self.spawn))
    
    local d = math.random(80, 120)
    local a = math.random() * math.pi * 2
    local bpos = Vector(self.state.player:pos()) + Vector(d, 0):rotated(a)

    local enemy = EnemyController(self.state, bpos.x, bpos.y)

    table.insert(self.enemy_controllers, enemy)
    print('SPAWNING')
end

return EnemySpawnController
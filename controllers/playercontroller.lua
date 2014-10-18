local Utils = require('utils')
local Direction = Utils.Direction

local Class = require('hump.class')
local Vector = require('hump.vector')


local PlayerController = Class({})



function PlayerController:init( state, player )

    self.player = player

    local register = Utils.make_registration_func(self, state.registry)

    register('keypressed', self.keypressed)
    register('keyreleased', self.keyreleased)
    register('update', self.update)
    register('mousemove', self.mousemove)
end


function PlayerController:keypressed( key )
    if key == 'w' then
        self.player:move(Direction.FORWARD)
    elseif key == 'a' then
        self.player:move(Direction.STRAFE_LEFT)

    elseif key == 's' then
        self.player:move(Direction.BACKWARD)

    elseif key == 'd' then
        self.player:move(Direction.STRAFE_RIGHT)
    end


    if key == ' ' then
        self.player.fire_bullets()
    end
end


function PlayerController:keyreleased( key )
    -- body
    if key == 'w' then
        self.player:stop_move(Direction.FORWARD)

    elseif key == 'a' then
        self.player:stop_move(Direction.STRAFE_LEFT)

    elseif key == 's' then
        self.player:stop_move(Direction.BACKWARD)
        
    elseif key == 'd' then
        self.player:stop_move(Direction.STRAFE_RIGHT)
    end
end


function PlayerController:update( dt )
    self.player:update_movement()
end

function PlayerController:mousemove( x, y )
    self.player:update_orientation(x, y)
end

return PlayerController
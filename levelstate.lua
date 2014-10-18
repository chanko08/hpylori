local LevelState = {}

function LevelState:init()
end

function LevelState:enter( prev, ... )
end

function LevelState:leave()
end

function LevelState:update( dt )
    -- body
end

function LevelState:draw()
    -- body
end

function LevelState:keypressed( key )
    -- body
    if key == 'escape' then
        love.event.quit()
    end
end

function LevelState:keyreleased( key )
    -- body
end

function LevelState:mousepressed( x, y, button )
    -- body
end

function LevelState:mousereleased( x, y, button )
    -- body
end

return LevelState
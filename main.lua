local GameState = require 'hump.gamestate'
local LevelState = require 'levelstate'

function love.load()
    GameState.registerEvents()
    GameState.switch(LevelState)
end
local Camera = require 'hump.camera'
local Class  = require 'hump.class'
local Utils  = require 'utils'

local Renderer = Class({})


function Renderer:init(level_state)
    love.mouse.setVisible(false)
    
    self.level_state      = level_state
    self.player           = self.level_state.player
    
    local register        = Utils.make_registration_func(self,self.level_state.registry)
    
    register('draw',   self.draw)
    register('update', self.update)
    
    
    self.camera           = Camera( self.player:pos() )
    self.hud_canvas       = love.graphics.newCanvas()

    self.background_color = {0x1d, 0xaf, 0xe0}
end

function Renderer:draw()
    love.graphics.setBackgroundColor(unpack(self.background_color))
    
    self.camera:attach()
    self:draw_world()
    self:draw_mouse()
    self.camera:detach()

    self:draw_hud()
end


function Renderer:draw_world()
    local r,b,g,a = love.graphics.getColor()
    love.graphics.setColor(255,255,255)
        local x,y = self.player:pos()
        local r   = self.player:radius()
        local angle = self.player:angle()
        
        love.graphics.circle('line',x,y,r,50)
    love.graphics.setColor(r,g,b,a)
end

function Renderer:draw_mouse()
    local r,b,g,a = love.graphics.getColor()
        love.graphics.setColor(0x0c,0xe0,0x48)
    
        local mx,my = self.camera:mousepos()
        love.graphics.circle('fill', mx,my, 7, 20)
    love.graphics.setColor(r,g,b,a)
end

function Renderer:draw_hud()
    love.graphics.setCanvas(self.hud_canvas)
    self.hud_canvas:clear()
    love.graphics.setBlendMode('alpha')

    local r,b,g,a = love.graphics.getColor()
        love.graphics.setColor(100,100,100,125)
        local W,H = love.graphics.getDimensions()
        love.graphics.rectangle('fill', 0, H - 50, W, 50)
    love.graphics.setColor(r,g,b,a)
    love.graphics.setCanvas()
    love.graphics.draw(self.hud_canvas)



    local r,b,g,a = love.graphics.getColor()
        love.graphics.setColor(255,255,255,255)
        love.graphics.print('1,000,000',25,H-30,0,1,1)
    love.graphics.setColor(r,g,b,a)

end

function Renderer:world_coords(x,y)
    return self.camera:worldCoords(x,y)
end

function Renderer:update(dt)
    local px, py = self.player:pos()
    local dx = self.camera.x - px
    local dy = self.camera.y - py

    self.camera:move(4*dx*dt,4*dy*dt)
end



return Renderer
local Camera = require 'hump.camera'
local Class  = require 'hump.class'
local Vector = require 'hump.vector'
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

function Renderer:draw_moveable(m, color)
    local col = color or {r=255,g=255,b=255}

    local r,b,g,a = love.graphics.getColor()
    love.graphics.setColor(col.r,col.g,col.b)
        -- local x,y = self.camera:cameraCoords(m:pos())
        local x,y = m:pos()
        --print('moveable',x,y)
        local r   = m:radius()
        local angle = m:angle()
        look_x, look_y = Vector(r,0):rotated(angle):unpack()
        
        love.graphics.circle('line',x,y,r,50)
        love.graphics.line(x,y,x+look_x,y+look_y)
    love.graphics.setColor(r,g,b,a)
end

function Renderer:draw_world()
    local width,height = love.graphics.getDimensions()
    local px, py       = self.player:pos()
    --  r,g,b,a = love.graphics.getColor!
    -- love.graphics.setColor 100, 100, 100

    -- for y = 1, model.height
    --     for x = 1, model.width
    --         love.graphics.circle( 'fill', 32*x, 32*y, 2 )
    
    -- love.graphics.setColor r,g,b,a

    local r,b,g,a = love.graphics.getColor()
    love.graphics.setColor(0x04,0x64,0xe0)
        for y=-height/50-1,height/50 + 1 do
            for x = -height/50-1,width/50 + 1 do
                love.graphics.circle('fill',50*(x-px/50)+5*(math.random()-.5),50*(y-py/50)+5*(math.random()-.5),2)
            end
        end
    love.graphics.setColor(r,g,b,a)

    self:draw_moveable(self.player)

    local bcolor = {r=0, g=0, b=255}
    for i,bullet in ipairs(self.player:fired_bullets()) do
        self:draw_moveable(bullet, bcolor)
    end

    local ecolor = {r=255, g=0, b=255}
    for i,enemy in ipairs(self.level_state.enemies) do
        self:draw_moveable(enemy, ecolor)
    end
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
    --print('player', px, py)
    --print('camera', self.camera.x, self.camera.y)
    local dx = px - self.camera.x
    local dy = py - self.camera.y

    self.camera:move(4*dx*dt,4*dy*dt)
end



return Renderer
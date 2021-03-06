Brick = Entity:extend('Brick')

function Brick:new(x, y, w, h)
    Brick:super().new(self, x, y, 1)
    self.w = w
    self.h = h
    self.sine = Sinewave(1, 3, 3)
    self.cx = fn() return self.x + self.w/2 end
    self.cy = fn() return self.y + self.y/2 end
end

function Brick:init()
    self.sine:stop()
    self.timer:after({0, 2}, function() self.sine:play() end)
end

function Brick:update(dt)
    Brick:super().update(self, dt)
    self.sine:update(dt)
end

function Brick:draw()
    local r,g,b,a = lg.getColor()
    lg.setColor(0,1,0)
    lg.rectangle('line', self.x - self.sine:value(), self.y - self.sine:value(), self.w + self.sine:value()* 2, self.h + self.sine:value()* 2)
    lg.setColor(r, g, b, a)
end
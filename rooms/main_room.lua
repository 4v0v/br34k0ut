Main_Room = Room:extend("Main_Room")

-------------------------------
-------------------------------

function Main_Room:new(roomMgr, tag)
    self.__super.new(self, roomMgr, tag)

    Pad(self, "pad", 300, 550, 200, 20)
    Ball(self, "ball", 300, 530, 20, 20)
    Wall(self, "left", 1, 0, 10, lg.getHeight() - 1)
    Wall(self, "right", lg.getWidth() - 10, 0, 10, lg.getHeight() - 1)
    Wall(self, "top", 0, 0, lg.getWidth(), 10)
    Wall(self, "bottom", 0, lg.getHeight()-11, lg.getWidth(), 10)
    for i = 1, 5 do for j = 1, 10 do Brick(self, _, 70 * j, 40 * i, 60, 30) end end
end

function Main_Room:update(dt)
    self.__super.update(self, dt)

    local pad = self:get("pad")
    local ball = self:get("ball")

    if down("left") then pad:moveLeft(500, dt) end
    if down("right") then pad:moveRight(500, dt) end
    if pressed("space") then ball:launch(500, -500)  end

    self:foreach({"Wall", "Pad", "Brick"}, function(entity) 
        local coll, dir = self:collision(ball, entity)
        
        if coll and ball.state ~= "init" then
            if entity.__class == "Brick" then 
                camera:shake(50)
                Trail(self, _, entity.x, entity.y)
                Trail(self, _, entity.x, entity.y)
                Trail(self, _, entity.x, entity.y)
                entity:kill() 
            end

            if dir == "bottom" then ball:setYSpeed(-500) end
            if dir == "top"    then ball:setYSpeed(500)  end
            if dir == "left"   then ball:setXSpeed(500)  end
            if dir == "right"  then ball:setXSpeed(-500) end

            if self:count("Brick") == 0 then 
                for i = 1, 5 do for j = 1, 10 do Brick(self, _, 70 * j, 40 * i, 60, 30) end end
            end
        end
    end)

    self:foreach("Trail", function(entity)
        entity:set_target(pad.x + pad.w/2 , pad.y - pad.h/ 2)
    end)
end

function Main_Room:draw()
    self.__super.draw(self)
end

function Main_Room:collision(r1, r2)
    if not (r1.x + r1.w >= r2.x and   
            r1.x <= r2.x + r2.w and   
            r1.y + r1.h >= r2.y and   
            r1.y <= r2.y + r2.h) then 
        return false 
    end 

    local b_col = r2.y + r2.h - r1.y
    local t_col = r1.y + r1.h - r2.y
    local l_col = r1.x + r1.w - r2.x
    local r_col = r2.x + r2.w - r1.x
    
    if     t_col < b_col and t_col < l_col and t_col < r_col then return true, "bottom"
    elseif b_col < t_col and b_col < l_col and b_col < r_col then return true, "top"
    elseif l_col < r_col and l_col < t_col and l_col < b_col then return true, "right"
    elseif r_col < l_col and r_col < t_col and r_col < b_col then return true, "left" end
end
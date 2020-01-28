Room = Class:extend("Room")

-------------------------------
-------------------------------

function Room:new(roomMgr, tag)
    self.id    = tools.uuid()
    self.tag   = tag or self.id
    self.roomMgr = roomMgr
    self.timer = Timer()
    self.entities = {}
    
    self.roomMgr.rooms[self.tag] = self
end

function Room:update(dt)
    self.timer:update(dt)

    for tag, entity in pairs(self.entities) do
        entity:update(dt)
        if entity.dead then
            entity:on_death()
            entity.timer:destroy()
            entity = {}
            self.entities[tag] = nil
        end
    end
end

function Room:draw()
    --Sort entities by z / creation_time / id 
    local sort_table = {}
    for _, entity in pairs(self.entities) do table.insert(sort_table, entity) end
    table.sort(sort_table, function(a, b) if a.z == b.z then return a.id < b.id else return a.z < b.z end end)
    for _, entity in pairs(sort_table) do entity:draw() end
end

function Room:get(tag) return self.entities[tag] end
function Room:is_entity(tag) return not not self.entities[tag] end

function Room:foreach(entity_filter, func)
    for _, entity in pairs(self.entities) do
        for _, className in pairs(entity_filter) do 
            if entity.__class == className then func(entity) end
        end
    end
end

function Room:count(class)
    local count = 0
    self:foreach({class}, function() count = count + 1 end)
    return count
end
function love.run()
    lg = love.graphics
    local _DT, _F_DT, _ACC = 0, 1/60, 0
    local _INPUT = {_CUR = {}, _PRE = {}}
    function pressed(key)  return _INPUT._CUR[key] and not _INPUT._PRE[key] end
    function released(key) return _INPUT._PRE[key] and not _INPUT._CUR[key] end
    function down(key) if key=='mouse_1'or key=='mouse_2'or key=='mouse_3'then return love.mouse.isDown(tonumber(key:sub(7))) end; return love.keyboard.isDown(key) end  

    Timer   = require('core/libraries/timer')
    Class   = require('core/libraries/class')
    Camera  = require('core/libraries/camera')
    vec2    = require('core/libraries/vector')
    Physics = require('core/libraries/physics')
    require('core/libraries/tools')
    tools.require('core/classes')
    tools.require('rooms')
    tools.require('entities')
    tools.require('entities/particles')
    
    lg.setDefaultFilter('nearest', 'nearest')
    lg.setLineStyle('rough')
    love.keyboard.setKeyRepeat(true)
    fixedsys = lg.newFont('assets/fonts/fixedsys.ttf', 18, 'mono')
    lg.setFont(fixedsys)

    MAIN_CANVAS = lg.newCanvas(lg.getWidth(), lg.getHeight())

    love.load()
    love.timer.step()
    
    return function()
        -- EVENTS --
        love.event.pump() 
        for name,a,b,c,d,e,f in love.event.poll() do 
            if name == 'quit'          then if not love.quit or not love.quit() then return a or 0 end end
            if name == 'mousepressed'  then _INPUT._CUR['mouse_'.. c] = true            end
            if name == 'mousereleased' then _INPUT._CUR['mouse_'.. c] = false           end
            if name == 'keypressed'    then _INPUT._CUR[a]            = true if c == true then _INPUT._PRE[a] = false  end end -- isRepeat
            if name == 'keyreleased'   then _INPUT._CUR[a]            = false           end
            love.handlers[name](a,b,c,d,e,f)
        end
		-- UPDATE --
		_DT = love.timer.step()
        if _DT > 0.2 then return end -- prevent screen grabbing
        _ACC = _ACC + _DT
        while _ACC >= _F_DT do 
            love.update(_F_DT); _ACC=_ACC-_F_DT 
            for k,v in pairs(_INPUT._CUR) do _INPUT._PRE[k] = v end -- input update
        end
        -- DRAW --
		if lg.isActive() then lg.origin(); lg.clear(lg.getBackgroundColor()); love.draw(); lg.present() end
		love.timer.sleep(0.001)
    end
end

function love.load()
    switch_sound = love.audio.newSource('assets/sounds/switch.wav', 'static')
    back_sound = love.audio.newSource('assets/sounds/back.wav', 'static')
    bg_calm = love.audio.newSource('assets/sounds/bg_calm.mp3', 'static')
    forest_bg = love.graphics.newImage('assets/images/forest.png')

    shockwave = Shockwave()
    chroma = Chroma()
    shake = Shake()
    camera = Camera(0, 0, 800, 600)
    camera:setPosition(400, 300)
    room_mgr = RoomMgr()
    room_mgr:add('menu_room', Menu_Room())
    room_mgr:add('option_room', Option_Room())
    room_mgr:add('seeyou_room', Seeyou_Room())
    room_mgr:add('highscore_room', Highscore_Room())
    room_mgr:add('play_room', Play_Room())
    room_mgr:change_room('menu_room')
end

function love.update(dt)
    camera:update(dt)
    shockwave:update(dt)
    shake:update(dt)
    room_mgr:update(dt)

    if pressed('escape') then love.load() end
end

function love.draw()
    lg.setCanvas(MAIN_CANVAS)
    lg.clear()
        room_mgr:draw()
    lg.setCanvas()

    MAIN_CANVAS = shockwave:get_canvas(MAIN_CANVAS)
    MAIN_CANVAS = chroma:get_canvas(MAIN_CANVAS)
    MAIN_CANVAS = shake:get_canvas(MAIN_CANVAS)
    MAIN_CANVAS = camera:get_canvas(MAIN_CANVAS)
    
    lg.draw(MAIN_CANVAS, 0, 0)
end


function love.mousepressed(x, y)
    shockwave:add_shockwave(x, y)
end

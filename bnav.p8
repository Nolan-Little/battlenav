pico-8 cartridge // http://www.pico-8.com
version 16
__lua__


grid_unit = 8
turn_length = 5
turn_buffer_val = 2

--initial state

function _init()
    debugclear()
    game_timer = timer()
    start_pos = create_pos(65, 64)
    ship = create_player_ship(start_pos)
    turn = create_turn()
    start_countdown = 5
    game_active = false
    turn_buffer_active = false
    turn_buffer = turn_buffer_val
    top_left_move_display = create_pos(85, 90)
    bottom_right_move_display = create_pos(104, 126)
    move_display_color = 6
    move_pos = {
        _1 = create_pos(91, 91),
        _2 = create_pos(91, 100),
        _3 = create_pos(91, 109),
        _4 = create_pos(91, 118)
    }
    cannons = {
        l = {
            pos = {
                _1 = create_pos(85, 91),
                _2 = create_pos(85, 100),
                _3 = create_pos(85, 109),
                _4 = create_pos(85, 118)
            },
            active = {
                _1 = false,
                _2 = false,
                _3 = false,
                _4 = false
            }

        },
        r  = {
            pos = {
                _1 = create_pos(97, 91),
                _2 = create_pos(97, 100),
                _3 = create_pos(97, 109),
                _4 = create_pos(97, 118)
            },
            active = {
                _1 = false,
                _2 = false,
                _3 = false,
                _4 = false
            }
        }
    }
    moves = {
        _1 = 0,
        _2 = 0,
        _3 = 0,
        _4 = 0
    }
end


--main functions

function _update()
    update_timer(game_timer)

    if game_timer.time % 1 == 0 then

        if game_active == false then
            start_countdown = start_countdown - 1
        elseif game_active and turn_buffer_active then
            turn_buffer = turn_buffer - 1
        end

        if turn_buffer == 0 then
            turn_buffer_active = false
        end

        if turn_buffer_active == false then
            update_turn(turn)
        end
    end
    if game_active and turn.active == false and turn_buffer_active == false then
        start_turn(turn, game_timer)
    end
    if turn.time_remaining == 0 and turn.active then
        stop_turn(turn)
        execute_turn(turn)
    end
    if start_countdown == 0 then
        game_active = true
    end
end


function _draw()
    rectfill(0,0,128,128,12)
    draw_grid()
    draw_hud()
    for k,v in pairs(moves) do
        if v == 0 then
            spr(8, move_pos.k.x, move_pos.k.y)
        elseif v == 1 then
            spr(5, move_pos.k.x, move_pos.k.y)
        elseif v == 2 then
            spr(6, move_pos.k.x, move_pos.k.y)
        elseif v == 3 then
            spr(7, move_pos.k.x, move_pos.k.y)
        end
    end

    spr(10, cannons.l.pos._1.x, cannons.l.pos._1.y)
    spr(10, cannons.l.pos._2.x, cannons.l.pos._2.y)
    spr(10, cannons.l.pos._3.x, cannons.l.pos._3.y)
    spr(10, cannons.l.pos._4.x, cannons.l.pos._4.y)
    spr(10, cannons.r.pos._1.x, cannons.r.pos._1.y)
    spr(10, cannons.r.pos._2.x, cannons.r.pos._2.y)
    spr(10, cannons.r.pos._3.x, cannons.r.pos._3.y)
    spr(10, cannons.r.pos._4.x, cannons.l.pos._4.y)


    spr(0, ship.pos.x, ship.pos.y)
end


function create_player_ship(pos)
    return {
        pos = pos,
        heading = 0
    }
end

--end main functions

--turn functions
function create_turn()
    return {
        time_remaining = turn_length,
        active = false,
        num_turns = 0,
    }
end

function start_turn(turn, timer)
    turn.time_remaining = turn_length
    turn.active = true
end

function update_turn(turn)
    turn.time_remaining = turn.time_remaining - 1
end

function stop_turn(turn)
    turn.active = false
    turn.time_remaining = turn_length
end

function execute_turn(turn)
    turn_buffer = turn_buffer_val
    turn_buffer_active = true
    turn.num_turns = turn.num_turns + 1
end

--end turn functions


--draw functions

function hor_grid()
    -- fillp(0b0111111111111111.1)
    for i=8, 120, 8
    do
        line(i, 0, i, 120, 1)
    end
    -- fillp()
end

function vert_grid()
    -- fillp(0b0111111111111111.1)
    for i=8, 128, 8
    do
        line(0, i, 128, i, 1)
    end
    -- fillp()
end

function draw_grid()
    hor_grid()
    vert_grid()
end

function draw_hud()
    rectfill(0, 89, 128, 128, 4)
    display_timer(game_timer)
    draw_movement_display(top_left_move_display, bottom_right_move_display, move_display_color)
end

function draw_movement_display(top_left, bottom_right, move_display_color)
    rectfill(top_left.x, top_left.y, bottom_right.x, bottom_right.y, 0)
    line(top_left.x, top_left.y, bottom_right.x, top_left.y, move_display_color) --top
    line(bottom_right.x, top_left.y, bottom_right.x, bottom_right.y, move_display_color) --right
    line(bottom_right.x, bottom_right.y, top_left.x, bottom_right.y, move_display_color) --bottom
    line(top_left.x, bottom_right.y, top_left.x, top_left.y, move_display_color) --left
    line(top_left.x, top_left.y+9, bottom_right.x, top_left.y+9, move_display_color) --divider 1
    line(top_left.x, top_left.y+18, bottom_right.x, top_left.y+18, move_display_color) --divider 2
    line(top_left.x, top_left.y+27, bottom_right.x, top_left.y+27, move_display_color) --divider 3
end

--end draw functions


---helper functions

function create_pos(x, y)
    pos = {}
    pos.x = x
    pos.y = y
    return pos
end

function debugclear()
    printh("", "bnav_log", true)
end

function debuglog(label, obj)
    printh(label .. ': '.. obj, "bnav_log")
end

----end helpers

-- start timers code
function timer()
    return {
        time = time()
    }
end

function update_timer(timer)
    timer.time = time()
end

function display_timer(timer)
    if turn.active then
        print(flr(turn.time_remaining), 10, 100, 7)
    end
    if game_active == false then
        print('game begins in '.. start_countdown, 10, 110, 7)
    end
    if turn_buffer_active then
        print(' turn begins in ' .. turn_buffer, 10, 120, 7)
    end
end


-- end timers code

__gfx__
0000000000000000000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000000000000000000000000000
0004000000000000000000000440000000000000eaa0aaaeeccc0ccee330033ee777777e00000000000000000000000000000000000000000000000000000000
0044400000000000000000000444077000000000ea00aaaeeccc00cee300003ee777777e00077000000770000000000000000000000000000000000000000000
0777770000000000000000000044700000000000e00000aeec00000ee000000ee777777e00788700007007000000000000000000000000000000000000000000
7044407000000000000000000007f40000000000ea00a0aeec0c00cee330033ee777777e00788700007007000000000000000000000000000000000000000000
004f4000000000000000000000704f4000000000eaa0a0aeec0c0ccee330033ee777777e00077000000770000000000000000000000000000000000000000000
004f400000000000000000000070040000000000eaaaa0aeec0ccccee330033ee777777e00000000000000000000000000000000000000000000000000000000
0044400000000000000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee00000000000000000000000000000000000000000000000000000000

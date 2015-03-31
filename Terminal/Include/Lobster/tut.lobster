include "std.lobster"
include "vec.lobster"
include "color.lobster"
include "blt.lobster"

light_gray :== [0.9, 0.9, 0.9, 1.0]:color
bright_red :== [1.0, 0.25, 0.2, 1.0]:color
player := [10,10]:xy
dungeon := vector_reserve(80)
for(80) column:
    dungeon.push(vector_reserve(40))
    for(40) row:
        if(column == 0 | row == 0 | column == 80 - 1 | row == 40 - 1):
            dungeon[column].push('#')
        else:
            dungeon[column].push('.')

fatal(blt_open())

blt_set("window: title=\'Tutorial 1\', size=80x40;")
input := 0
while(input != blt_closed & input != blt_escape & input != blt_q):
    blt_layer(0)
    blt_bkcolor(light_gray)
    blt_color(color_black)
    
    forxy([80,40]:xy) p:
        if(p.x == player.x & p.y == player.y):
            blt_color(bright_red)
            blt_put(player.x, player.y, '@')
            blt_color(color_black)
        else:
            blt_put(p.x, p.y, dungeon[p.x][p.y])
    blt_refresh()
    blt_clear()
    if(blt_has_input()):
        input = blt_read()
        if(input == blt_left | input == blt_a | input == blt_h):
            if(dungeon[player.x - 1][player.y] != '#'): player += [-1, 0]:xy
        if(input == blt_right | input == blt_d | input == blt_l):
            if(dungeon[player.x + 1][player.y] != '#'): player += [1, 0]:xy
        if(input == blt_up | input == blt_w | input == blt_k):
            if(dungeon[player.x][player.y - 1] != '#'): player += [0, -1]:xy
        if(input == blt_down | input == blt_s | input == blt_j):
            if(dungeon[player.x][player.y + 1] != '#'): player += [0, 1]:xy
        
        


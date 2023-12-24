function map_remove_desert_top_wall()
    for celx = 20, 27 do
        mset(celx, 15, 64)
    end
end

function map_add_desert_town_square_wall()
    map_add_wall_y(48, 22, 25, 65)
end

function map_add_jungle_town_square_wall()
    map_add_wall_y(63, 18, 30, 100)
end

function map_add_py_wall()
    map_add_wall_y(96, 7, 9, 114)
end

function map_add_wall_y(celx, cely_from, cely_to, snum)
    for cely = cely_from, cely_to do
        mset(celx, cely, snum)
    end
end
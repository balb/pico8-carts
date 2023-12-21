-- todo: del_wall func?

function map_remove_desert_top_wall()
    mset(20, 15, 64)
    mset(21, 15, 64)
    mset(22, 15, 64)
    mset(23, 15, 64)
    mset(24, 15, 64)
    mset(25, 15, 64)
    mset(26, 15, 64)
    mset(27, 15, 64)
end

function map_add_desert_town_square_wall()
    mset(48, 22, 65)
    mset(48, 23, 65)
    mset(48, 24, 65)
    mset(48, 25, 65)
end

function map_add_jungle_town_square_wall()
    for cely = 18, 30 do
        mset(63, cely, 100)
    end
end
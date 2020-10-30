local grid_settings = {}


-----------------------------------------------
--SETTINGS--

--Number of tiles in each direction
grid_settings.tiles_x = 30
grid_settings.tiles_y = 30
grid_settings.tiles_total = grid_settings.tiles_x * grid_settings.tiles_y
--Size of each tile in studs
grid_settings.brick_size_x = 5
grid_settings.brick_size_y = 5
--Additional space between each tile
local brick_offset = 0
--Starting position, bottom left corner
grid_settings.start_pos = Vector3.new(0, 4, 0)
--Whether visual effects play(costs time)
grid_settings.visualize = false
--Tile Colors
grid_settings.bomb_color = BrickColor.new("Really red")
grid_settings.clear_color = BrickColor.new("Brick yellow")
grid_settings.flagged_color = BrickColor.new("Really blue")
grid_settings.base_color = BrickColor.new("Medium stone grey")
--Mine Settings
grid_settings.mines_total = grid_settings.tiles_total/3
grid_settings.mine_chance = 0.2



-----------------------------------------------
--DATA--

--Holds the final offset for tile positions
grid_settings.dist_x = grid_settings.brick_size_x + brick_offset
grid_settings.dist_y = grid_settings.brick_size_y + brick_offset

-- Stats
grid_settings.mines_made = 0
grid_settings.tiles_revealed = 0
grid_settings.mines_flagged = 0
grid_settings.mines_revealed = 0

--Table to hold the position of all mines
grid_settings.minepos = {}
--Set up the table
for i = 0, grid_settings.tiles_x do
	grid_settings.minepos[i] = {}
	for k = 0, grid_settings.tiles_y do
		grid_settings.minepos[i][k] = 0
	end
end

return grid_settings

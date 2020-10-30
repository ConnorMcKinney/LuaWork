local gs = require(workspace.Modules.grid_settings)
local gf = require(workspace.Modules.grid_functions)
local uf = require(workspace.Modules.useful_functions)

local tiles_x = gs.tiles_x
local tiles_y = gs.tiles_y

local brick_size_x = gs.brick_size_x
local brick_size_y = gs.brick_size_y

local minestotal = gs.mines_total
local minechance = gs.mine_chance

local start = gs.start_pos

for i = 1, tiles_y do
	for k = 1, tiles_x do
		if gs.mines_made < gs.mines_total then
			if math.random(0, 100)/100 <= minechance then
				gs.minepos[k][i] = 1
				gs.mines_made = gs.mines_made + 1
				print(gs.mines_made)
			else
				gs.minepos[k][i] = 0
			end
		end
		
		--print("i = " .. tostring(i) ..", k = " .. tostring(k) .. ", x = " .. tostring(x) .. ", (i-1)*x+k = " .. tostring((i-1)*x+k))
		
		local p = Instance.new("Part", workspace.Bricks)
		p.Shape = "Block"
		p.Size = Vector3.new(brick_size_x, 2, brick_size_y)
		p.Anchored = true
		p.Position = start + Vector3.new(-gs.dist_x*i, 0, -gs.dist_y*k)
		p.Name = tostring((i-1)*tiles_x+k)
		
		local sg = Instance.new("SurfaceGui", p)
		sg.Adornee = p
		sg.Face = "Top"
		
		local tl = Instance.new("TextLabel", sg)
		tl.Size = UDim2.new(1, 0, 1, 0)
		tl.TextScaled = true
		tl.BackgroundTransparency = 1
		tl.Text = "( " .. tostring(k) .. ", " .. tostring(i) .. ")"
		
		local isbomb = Instance.new("BoolValue", p)
		isbomb.Name = "isbomb"
		if gs.minepos[k][i] == 1 then
			--tl.Text = tl.Text .. "\nBomb"
			isbomb.Value = true
		else
			isbomb.Value = false
		end
		
		local revealed = Instance.new("BoolValue", p)
		revealed.Name = "revealed"
		revealed.Value = false
		
		local flagged = Instance.new("BoolValue", p)
		flagged.Name = "flagged"
		flagged.Value = false
		
		
		local v = Instance.new("NumberValue", p)
		v.Name = "BombValue"
		v.Value = 0
		
		local pos = Instance.new("Vector3Value", p)
		pos.Name = "RowColumn"
		pos.Value = Vector3.new(k, 0, i)
	end
	wait(0.0000001)
end

--(i, k+1), (i, k-1), (i+1, k), (i-1, k), (i+1, k+1), (i+1, k-1), (i-1, k+1), (i-1, k-1)

--(yp-1)*x+xp
function getadjacent(row, column, brick)
	local bricks = {}
	local values = {}
	for i = -1, 1 do
		for k = -1, 1 do
			if i+row >= 1 and k+column >= 1 and i+row <= tiles_x and k+column <= tiles_y then
				--print(minepos[i+row][k+column])
				--print(tostring((k+column)*x+(i+row)))
				local newbrick = workspace.Bricks[tostring((k+column-1)*tiles_x+(i+row))]
				if newbrick ~= brick then
					--newbrick.Position = newbrick.Position + Vector3.new(0, 2, 0)
					bricks[#bricks+1] = newbrick
					values[#values+1] = gs.minepos[i+row][k+column]
					--wait(.5)
					--newbrick.Position = newbrick.Position + Vector3.new(0, -2, 0)
				end
			end
		end
	end
	return bricks, values
end

-------------------------------------------------------

for i = 1, tiles_y do
	for k = 1, tiles_x do
		if workspace.Bricks:FindFirstChild(tostring((i-1)*tiles_x+k)) then
			local brick = workspace.Bricks[tostring((i-1)*tiles_x+k)]
			local orig_color = 0
			if gs.visualize then
				orig_color = brick.BrickColor
				brick.BrickColor = BrickColor.new("Navy blue")
			end
			
			local count = 0
			
			local newbricks = gf.getadjacent(brick)
			
			for m = 1, #newbricks do
				if gs.visualize then
					newbricks[m].Position = newbricks[m].Position + Vector3.new(0, 2, 0)
				end
				
				if newbricks[m].isbomb.Value then
					count = count + 1
					--print("Bomb")
				--else
					--print(newbricks[m].Name .. " has a value of " .. tostring(newbricks[m].isbomb.Value))
				end
			end
			
			if gs.visualize then
				wait(.01)
			end
			
			if gs.visualize then
				for m = 1, #newbricks do
					newbricks[m].Position = newbricks[m].Position + Vector3.new(0, -2, 0)
				end
				brick.BrickColor = orig_color
			end
			
			brick.BombValue.Value = count
		end
	end
	wait(0.0000001)
end

print(gs.mines_made)
gf.update_gui()
print(gs.mines_made)
workspace.Bricks['1'].BrickColor = BrickColor.new("New Yeller")



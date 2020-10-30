local player = game.Players.LocalPlayer
local character = player.Character
local mouse = player:GetMouse()

local UserInputService = game:GetService("UserInputService")
local gs = require(workspace.Modules.grid_settings)
local gf = require(workspace.Modules.grid_functions)
local uf = require(workspace.Modules.useful_functions)

local bomb_color = gs.bomb_color
local clear__color = gs.clear_color
local flag_color= gs.flag_color

local x = gs.tiles_x
local y = gs.tiles_y

--Have option to spend a long time to auto-flag or reveal tile.

-- A sample function providing one usage of InputBegan
local function onInputBegan(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local target = mouse.target
		if target then
			if target.Parent == workspace.Bricks then
				reveal(target)
			end
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		local target = mouse.target
		if target then
			if target.Parent == workspace.Bricks then
				flag(target)
			end
		end
	elseif input.UserInputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode.Name
		if key == "R" then
			local target = mouse.target
			if target then
				if target.Parent == workspace.Bricks then
					turnmine(target)
				end
			end
		end
	end
end
 
UserInputService.InputBegan:Connect(onInputBegan)


--[[ 
	
	(1, 4)
	(1, 3)
	(1, 2)
	(1, 1)
	(1, 0) (2, 1) (3, 2) (4, 3) (5, 4)
--]]
function flag(target)
	if target.flagged.Value == false then
		if target.revealed.Value == false then
			target.flagged.Value = true
			target.BrickColor = gs.flagged_color
		end
	else
		target.flagged.Value = false
		target.BrickColor = gs.base_color
	end
	gf.update_gui()
end

function turnmine(target)
	if target.isbomb.Value == false then
		target.isbomb.Value = true
		gs.mines_made = gs.mines_made + 1
		local column, row = target.RowColumn.Value.X, target.RowColumn.Value.Z
		--print(column, row)
		gs.minepos[column][row] = 1
		local bricks = gf.getadjacent(target)
		for i = 1, #bricks do
			bricks[i].BombValue.Value = bricks[i].BombValue.Value + 1
		end
		target.BrickColor = gs.base_color
		target.revealed.Value = false
		gf.update_adjacent(target)
		gf.update_gui()
	else
		print(target.Name .. " is already a bomb.")
	end
end

function reveal(target)
	if not target.flagged.Value then
		if target.revealed.Value == false then
			target.revealed.Value = true
	--		print("revealed: ", target.RowColumn.Value)
			
			if target.isbomb.Value == true then
				target.BrickColor = bomb_color
			else
				target.BrickColor = gs.clear_color
				target.SurfaceGui.TextLabel.Text = target.SurfaceGui.TextLabel.Text .. "\n" .. tostring(target.BombValue.Value)
				local adjacents = gf.getadjacent(target)
				if target.BombValue.Value == 0 then
					for i = 1, #adjacents do
						reveal(adjacents[i])
					end
				end
			end
	--	else
	--		print("Was already revealed: ", target.RowColumn.Value)
		end
		gs.tiles_revealed = gs.tiles_revealed + 1
		gf.update_gui()
	else
		print(target.Name .. " is flagged!")
	end
end
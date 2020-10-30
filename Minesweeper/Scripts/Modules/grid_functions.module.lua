local gf = {}

local gs = require(script.Parent.grid_settings)
local uf = require(script.Parent.useful_functions)


function gf.getadjacent(brick)
	local bricks = {}
	
	local pos = brick:FindFirstChild("RowColumn")
	
	local row = pos.Value.X
	local column = pos.Value.Z
	
	for i = -1, 1 do
		for k = -1, 1 do
			if i+row >= 1 and k+column >= 1 and i+row <= gs.tiles_x and k+column <= gs.tiles_y then
				local newbrick = workspace.Bricks[tostring((k+column-1)*gs.tiles_x+(i+row))]
				if newbrick ~= brick then
					bricks[#bricks+1] = newbrick
				end
			end
		end
	end
	return bricks
end

function gf.update_adjacent(brick)
	local adjacents = gf.getadjacent(brick)
	for i,v in pairs(adjacents) do
		if v.revealed.Value then
			--Update the text label to the new value
			if v.isbomb.Value == false then
				v.SurfaceGui.TextLabel.Text = "( " .. tostring(v.RowColumn.Value.X) .. ", " .. tostring(v.RowColumn.Value.Z) .. ")"
				v.SurfaceGui.TextLabel.Text = v.SurfaceGui.TextLabel.Text .. "\n" .. tostring(v.BombValue.Value)
			end
			--target.SurfaceGui.TextLabel.Text = target.SurfaceGui.TextLabel.Text .. "\n" .. tostring(target.BombValue.Value)
			--tl.Text = "( " .. tostring(k) .. ", " .. tostring(i) .. ")"
		end
	end
end

function gf.update_gui(arg)
	local percent_revealed = gs.tiles_revealed/gs.tiles_total
	local mines_made = gs.mines_made
	local mines_left = mines_made - gs.mines_flagged - gs.mines_revealed
	print(percent_revealed, mines_made, mines_left)
	
	for i,v in pairs(game.Players:GetChildren()) do
		local gui = v.PlayerGui.Board.Frame
		gui.mines_total.TextLabel.Text = "Total mines = " .. tostring(mines_made)
		gui.cleared.TextLabel.Text = "%Cleared = " .. tostring((uf.round(percent_revealed, 2)*100))
		gui.mines_left.TextLabel.Text = "Mines left: " .. tostring(mines_left)
	end
end

return gf

local map = {}

local objects = workspace.Bricks:GetChildren()
local names = {}

map.distance = 100

for i = 0, 100, 10 do
	names[tostring(i)] = true
end

function map.update(character)
	local player = game.Players:GetPlayerFromCharacter(character)
	local background = player.PlayerGui.ScreenGui.Background
	
	local to_draw = {}
	
	for i,v in pairs(objects) do
		if (character.Head.Position - v.Position).magnitude <= map.distance then
			if names[v.Name] then
				table.insert(to_draw, v, true)
			end
		end
	end
	
	local drawn = {}
	
	for i,v in pairs(background:GetChildren()) do
		if to_draw[v.Belongs_To.Value] then
			--
		else
			v:Destroy()
		end
	end
end



return map

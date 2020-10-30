wait(2)
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

local bricks = workspace.Bricks:GetChildren()
local torso = player.Character.HumanoidRootPart

local size = 200
local scroll_change = 10

local screen = script.Parent
local background = screen:WaitForChild("Background")
local labelfolder = background:WaitForChild("Labels")

local playerlabel = background.PlayerLabel:Clone()
playerlabel.ObjectReference.Value = torso 
playerlabel.Parent = labelfolder
playerlabel.Visible = true 

local labels = {}

for i,v in pairs(bricks) do
	local bricklabel = background.ObjectLabel:Clone()
	bricklabel.Parent = labelfolder
	bricklabel.ObjectReference.Value = v
	bricklabel.Size = UDim2.new(v.Size.X/size, 0, v.Size.Z/size, 0)
	bricklabel.BackgroundColor3 = v.Color
	table.insert(labels, bricklabel)
end


local count = 0

function update(step)
	--Vector1
	local lookv = camera.CFrame.lookVector
	local lookv_2 = Vector3.new(lookv.X, 0, lookv.Z)
	local angle1 = math.deg(math.atan2(lookv_2.X, lookv_2.Z))
	
	--Position 2
	local char_pos = torso.Position
	local char_pos_2 = Vector3.new(char_pos.X, 0, char_pos.Z)
	
	for i,v in pairs(labels) do
		local brick = v.ObjectReference.Value
		if count == 5 then
			v.BackgroundColor3 = brick.Color
			v.Size = UDim2.new(brick.Size.X/size, 0, brick.Size.Z/size, 0)
		end
		--Position 1
		local brick_pos = brick.CFrame.p
		local brick_pos_2 = Vector3.new(brick_pos.X, 0, brick_pos.Z)
		local brick_v2 = Vector3.new(brick.CFrame.lookVector.X, 0, brick.CFrame.lookVector.Z)
		
		--Vector 2
		local v2 = (brick_pos_2 - char_pos_2).unit
		
		local angle2 = math.deg(math.atan2(v2.X, v2.Z))
		local angle3 = math.deg(math.atan2(brick_v2.X, brick_v2.Z))
		
		local final = angle1-angle2-90
		local rotation = angle1-angle3-90
	
		local distance = (char_pos_2-brick_pos_2).magnitude

		if distance < size/2 then
			v.Visible = true
			local x = math.cos(math.rad(final))*distance/size
			local y = math.sin(math.rad(final))*distance/size

			v.Position = UDim2.new(0.5+x, 0, 0.5+y, 0)
			v.Rotation = rotation
		else
			v.Visible = false
		end
	end
	count = count + 1
	if count == 6 then
		count = 0
	end
end

function zoom_in()
	size = size - scroll_change
end

function zoom_out()
	size = size + scroll_change
end

function stop_camera()
	camera.CameraType = Enum.CameraType.Scriptable
	print("Fixed")
end

function start_camera()
	camera.CameraType = Enum.CameraType.Custom
	print("Custom")
end

background.MouseEnter:connect(stop_camera)
background.MouseLeave:connect(start_camera)

background.MouseWheelForward:connect(zoom_in)
background.MouseWheelBackward:connect(zoom_out)
--game:GetService("RunService").RenderStepped:Connect(update)
game:GetService("RunService").Heartbeat:Connect(update)

-- @ScriptType: Script
local hat = script.Parent           -- Accessory
local handle = hat:WaitForChild("Handle")

-- ensure interactables live on the handle
local prompt = handle:FindFirstChildOfClass("ProximityPrompt") or Instance.new("ProximityPrompt")
prompt.ActionText = "Pick Up"
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.HoldDuration = 0
prompt.Parent = handle

local clickDetector = handle:FindFirstChildOfClass("ClickDetector") or Instance.new("ClickDetector", handle)

local selectionBox = handle:FindFirstChildOfClass("SelectionBox")
if not selectionBox then
	selectionBox = Instance.new("SelectionBox")
	selectionBox.Adornee = handle
	selectionBox.SurfaceColor3 = Color3.fromRGB(255,255,255)
	selectionBox.LineThickness = 0.08
	selectionBox.Visible = false
	selectionBox.Parent = handle   -- parent to handle, not the hat
end

clickDetector.MouseHoverEnter:Connect(function()
	selectionBox.Visible = true
end)
clickDetector.MouseHoverLeave:Connect(function()
	selectionBox.Visible = false
end)

prompt.Triggered:Connect(function(player)
	local tool = Instance.new("Tool")
	tool.Name = hat.Name
	tool.RequiresHandle = true
	tool.CanBeDropped = true

	local clonedHandle = handle:Clone()
	clonedHandle.Name = "Handle"
	clonedHandle.Anchored = false
	clonedHandle.CanCollide = false

	-- remove only the interactables from the clone (keep meshes/textures!)
	for _,v in ipairs(clonedHandle:GetDescendants()) do
		if v:IsA("ProximityPrompt") or v:IsA("ClickDetector") or v:IsA("SelectionBox") then
			v:Destroy()
		end
	end

	clonedHandle.Parent = tool
	tool.Parent = player:WaitForChild("Backpack")

	hat:Destroy()
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local function GetClosest(Fov)
    local Target, Closest = nil, math.huge
    
    for i,v in pairs(Players:GetPlayers()) do
        if (v.Name ~= LocalPlayer.Name and v.Character and v.Character.HumanoidRootPart) then
            local ScreenPos, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
            local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            
            if (Distance < Closest) then
                Closest = Distance
                Target = v
            end
        end
    end
    
    return Target
end

local Target
local CircleInline = Drawing.new("Circle")
local CircleOutline = Drawing.new("Circle")
RunService.Stepped:Connect(function()
    CircleInline.Radius = 200
    CircleInline.Thickness = 2
    CircleInline.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    CircleInline.Transparency = 1
    CircleInline.Color = Color3.fromRGB(255, 255, 255)
    CircleInline.Visible = true
    CircleInline.ZIndex = 2

    CircleOutline.Radius = 200
    CircleOutline.Thickness = 4
    CircleOutline.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    CircleOutline.Transparency = 1
    CircleOutline.Color = Color3.new()
    CircleOutline.Visible = false
    CircleOutline.ZIndex = 1
    
    Target = GetClosest(Fov)
end)

local mt = getrawmetatable(game)
	local namecall = mt.__namecall
	setreadonly(mt,false)

	mt.__namecall = function(self,...)
		local args = {...}
		local method = getnamecallmethod()

		if tostring(self) == "HitPart" and method == "FireServer" then
			print("so?")
			args[1] = GetClosest().Character.Head
			args[2] = GetClosest().Character.Head.Position
			return self.FireServer(self, unpack(args))
		end
	return namecall(self,...)
end

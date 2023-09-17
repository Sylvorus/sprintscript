local user_input_server = game:GetService("UserInputService")
local replicated_storage = game:GetService("ReplicatedStorage")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local runMode = 0
local isRunning = false
local lasTapped = tick()

local animationTrack = nil

local rE = replicated_storage.RemoteEvent

local function animation()

	local aTrack = humanoid:LoadAnimation(script.runAnimation)
	aTrack.Priority = Enum.AnimationPriority.Action
	return aTrack
end

user_input_server.InputBegan:Connect(function(input, gpe)
	if not gpe then
		-- For when a key is pressed		
		if input.KeyCode == Enum.KeyCode.W then
			if runMode == 0 then
				runMode += 1
			else
				if tick() - lasTapped < .4 then
					runMode+= 1
					if runMode > 2 then
						runMode = 2
					end
				end
			end
			if runMode == 2 then
				animationTrack = animation()
				animationTrack:Play()
				isRunning = true
			end
			lasTapped = tick()
			rE:FireServer(isRunning, runMode)
		end
	end	
end)

user_input_server.InputEnded:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.W then
		if not gpe then

			if isRunning then
				runMode= 0
				isRunning = false
				if animationTrack then
					animationTrack:Stop()
					animationTrack = nil
				end
			end
			if tick() - lasTapped > .4 then
				runMode = 0
				isRunning = false
				if animationTrack then
					animationTrack:Stop()
					animationTrack = nil
				end
			end
			rE:FireServer(isRunning,runMode)
		end	
	end
end)


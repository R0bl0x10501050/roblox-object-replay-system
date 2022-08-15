-- ThePhantomReplay
-- Version 1

-- SOURCE CODE

-- // Globals
local TIME_PASSED = 0; -- Time passed since recording started
local CASHE = {}; -- All our replays will go here
local RECORDING = false; -- boolean stating if we are recording or not
local REPLAYING = false; -- boolean stating if we are replaying or not
local FRAME = 0; -- number representing what frame we are on
local INDEX = 1; -- number representing waht index we are on (STEP)
local REGISTERED_OBJECTS = {}; -- models/parts that will be recorded
local ACTIVE_RECORDING = {}; -- All objects that are being recorded will go here
local NUMBER_OF_REPLAYS = 0; -- keeping track of the amount of replays we have
local THREADS = 0; -- seperate threads replaying frames of each object
local NAME = ""; -- the name of the replay to be recorded
local REPLAY_TYPE = "NORMAL";
local LAST = 0; -- error handling
local STEP_CONNECTION = "";

-- // Services
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");

-- // Events
local RecordConnection = nil;

-- Bindables
local Step = Instance.new("BindableEvent");
local FrameStep = Instance.new("BindableEvent");
local OnRecord = Instance.new("BindableEvent");
local OnStop = Instance.new("BindableEvent");
local OnReplay = Instance.new("BindableEvent");
local OnReplayStop = Instance.new("BindableEvent");
local StepReplay = Instance.new("BindableEvent");
local Move = Instance.new("BindableEvent");


-- Our classs
local Module = {};

Module.Register = function(object)
	assert(object ~= nil, "Please provide an object to register");
	if (table.find(REGISTERED_OBJECTS,object) == nil) then
		table.insert(REGISTERED_OBJECTS,object);
		
		if (object.ClassName == "Part") then
			object:Clone().Parent = ReplicatedStorage;
			ReplicatedStorage[object.Name].Material = Enum.Material.Neon;
		elseif (object.ClassName == "Model") then
			local character = ReplicatedStorage.Dummy:Clone();
			character.Name = object.Name;
			character.Parent = ReplicatedStorage;
			
			for i,e in next, character:GetChildren() do
				if (e.ClassName == "MeshPart") then
					e.Transparency = 0.5;
					e.CanCollide = false;
				end
			end
			
		end
		print(object,"was registered");
	end
end

Module.Unregister = function(object)
	assert(object ~= nil, "Please provide an object to register");
	if (table.find(REGISTERED_OBJECTS,object) ~= nil) then
		table.remove(REGISTERED_OBJECTS,table.find(REGISTERED_OBJECTS,object));
		print(object,"was unregistered");
	end
end

Module.Record = function(name)
	if (RECORDING == true and REPLAYING == false and RecordConnection ~= nil) then
		warn("You are already recording");
	else
		assert(name ~= nil and typeof(name) == "string" and #name ~= 0, "Please provide a name of the replay to be recorded");
		NAME = name;
		RECORDING = true;
		
		for index, entry in next, REGISTERED_OBJECTS do
			ACTIVE_RECORDING[entry] = {};
		end
		
		OnRecord:Fire(name);
		
		RecordConnection = RunService.Heartbeat:Connect(function(deltaTime)
			for index, entry in next, REGISTERED_OBJECTS do
				local key = tostring(TIME_PASSED);
				if (entry.ClassName == "Model") then
					ACTIVE_RECORDING[entry][key] = entry.PrimaryPart.CFrame;
				elseif (entry.ClassName == "Part") then
					ACTIVE_RECORDING[entry][key] = entry.CFrame;
				end
			end
			Step:Fire(TIME_PASSED);
			TIME_PASSED += deltaTime;
		end)
	end
end

Module.Stop = function()
	if (RECORDING == false and RecordConnection == nil) then
		warn("You are not recording");
	else
		RECORDING = false;
		RecordConnection:Disconnect();
		RecordConnection = nil;
		
		NUMBER_OF_REPLAYS += 1;
		TIME_PASSED = 0;
		
		CASHE[NAME] = ACTIVE_RECORDING;
		
		ACTIVE_RECORDING = {};
		
		OnStop:Fire(NAME);
		
		NAME = "";
	end
end

Module.Replay = function(name)
	if (REPLAYING == true) then
		warn("Already replaying");
	else
		
		assert(name ~= nil and typeof(name) == "string" and #name ~= 0, "Please provide a name of the replay to be watched");
		
		for i,e in next, workspace.ThePhantomReplay:GetChildren() do
			e:Destroy();
		end
		
		OnReplay:Fire(name);
		
		REPLAYING = true;
		
		local temp = {};
		
		local replayTable = CASHE[name];
		
		for k, tab in next, replayTable do
			temp[k] = {};
			
			for num, v in next, tab do
				temp[k][#temp[k]+1] = tonumber(num);
			end
			
			table.sort(temp[k], function(a,b)
				return a < b;
			end)
		end
		
		for key,value in next, temp do
			THREADS += 1;
			local thread;

			thread = function()
				local part = ReplicatedStorage[key.Name]:Clone();

				if (part.ClassName == "Part") then
					part.Anchored = true;
					part.CanCollide = false;
					part.Transparency = 0.9;
				end

				part.Parent = workspace.ThePhantomReplay;

				for frame, timestamp in next, value do
					FRAME = frame;

					if (part.ClassName == "Model") then
						part.PrimaryPart.CFrame = CASHE[name][key][tostring(timestamp)];
					else
						part.CFrame = CASHE[name][key][tostring(timestamp)];
					end

					RunService.Heartbeat:Wait();
				end

				THREADS -= 1;
			end

			coroutine.resume(coroutine.create(thread));

		end
		
		repeat
			FrameStep:Fire(FRAME);
			RunService.Heartbeat:Wait();
		until THREADS == 0;
		
		print("no threads running");
		REPLAYING = false;
	end
end

Module.Events = {
	STEP = Step,
	ON_RECORD = OnRecord,
	ON_STOP = OnStop,
	ON_REPLAY = OnReplay,
	ON_REPLAY_STOP = OnReplayStop,
	FRAME_STEP = FrameStep
}

return Module;

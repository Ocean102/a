--==[[ Statics functions ]]==--

local core = game.CoreGui
local gsv = game:GetService("GuiService")
local rs = game.ReplicatedStorage
local ts = game.TweenService

local bool = Instance.new("BoolValue")

local antiAFK, guiState, partState, fcframe
local frozen = false

function b()return(bool:Clone())end
function isRod(i:Tool)return i:FindFirstChild("rod/client") and true or false end
function abc()
   rs.bindable_reel_finished:Fire(true)
   rs.reelfinished:FireServer(100, true)
end

--==[[ HUB SETTINGS ]]==--

local hubDat = {
   name = "Tide Hub",
   rf = false,

   key = {
      enabled = false,
      val = {}
   }
}

hubDat.notifyPrefix = '<font color="#4a8fff"><b>' .. hubDat.name .. '</b></font> - '

local vim = game:GetService('VirtualInputManager')
function send(key)
   vim:SendKeyEvent(true, key, false, nil)
   task.wait(0)
   vim:SendKeyEvent(false, key, false, nil)
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local boomed = false

local hubCore = hubDat.name .. (hubDat.rf and " - RayField" or "")
local hub = core:FindFirstChild(hubCore)

--==[[ Player/Chacracter ]]==--

local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui
local bp = plr.Backpack

local died = false
local char = plr.Character
local hum = char.Humanoid
local hrp = char.HumanoidRootPart
local rod
local rodEvent
local rodVal

--==[[ idk what to put here lol ]]==--

local val = {
   -- Farming
   AutoCast = b(),
   SpamShake = b(),
   FastReel = b(),

   -- Player
   Freeze = b(),
   AntiAFK = b()
}


local fischEvent = {
   rod = function(rodName: string?)
      local rod
      local finished = false
      local holding = char:FindFirstChildWhichIsA("Tool")
      local name = rodName or plr:GetAttribute("CurrentRod")

      if holding and isRod(holding) then
         rod = holding
         finished = true
      end

      if name and not finished then
         local tool = bp:FindFirstChild(name) or char:FindFirstChild(name)
         if tool and tool:IsA("Tool") then
               if holding then hum:UnequipTools() end
               rod = tool
               hum:EquipTool(tool)
               finished = true
         end
      end

      if not finished then
         for _, v in ipairs(bp:GetChildren()) do
               if isRod(v) then
                  if char:FindFirstChildWhichIsA("Tool") then hum:UnequipTools() end
                  rod = v
                  hum:EquipTool(v)
                  finished = true
                  break
               end
         end
      end

      rodEvent = rod.events
      rodVal = rod.values
   end,

   notify = function(msg: string, pref: boolean?)
      if not pref then pref = false end
      if pref then msg = hubDat.notifyPrefix .. msg end

      local hud = gui.hud
      local announces = hud.safezone.announcements
      local announcer = announces.announcer

      local stats = workspace:WaitForChild("PlayerStats"):FindFirstChild(plr.Name)
      if not stats then return end

      local localPlayerSettings = stats.T:FindFirstChild(plr.Name)
      if not localPlayerSettings then return end

      if plr:GetAttribute("StopBottomAnnounces") then return end

      local settings = localPlayerSettings:FindFirstChild("Settings")
      if not settings then return end

      local announcesbottom = settings:FindFirstChild("announcesbottom")
      if announcesbottom and not announcesbottom.Value then return end

      local thought = announcer.thought:Clone()
      thought.Main.TextTransparency = 1
      thought.Main.TextStrokeTransparency = 1
      thought.Shine.ImageTransparency = 1
      thought.Main.Position = UDim2.new(0.5, 0, -0.3, 0)
      thought.Main.Text = msg
      thought.Parent = announces
      thought.Visible = true

      rs.resources.sounds.sfx.ui.popup2:Play()

      ts:Create(thought.Icon, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
         ImageTransparency = 0.1
      }):Play()

      ts:Create(thought.Main, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
         TextTransparency = 0,
         TextStrokeTransparency = 0.58,
         Position = UDim2.new(0.5, 0, 0, 0)
      }):Play()

      ts:Create(thought.Shine, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
         ImageTransparency = 0.1
      }):Play()

      -- Fade-out after 5 seconds
      task.delay(5, function()
         local fadeOutMain = ts:Create(thought.Main, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
               TextTransparency = 1,
               TextStrokeTransparency = 1,
               Position = UDim2.new(0.5, 0, -0.3, 0)
         })
         fadeOutMain:Play()

         ts:Create(thought.Icon, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
               ImageTransparency = 1
         }):Play()

         ts:Create(thought.Shine, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
               ImageTransparency = 1
         }):Play()

         fadeOutMain.Completed:Once(function()
               thought:Destroy()
         end)
      end)
   end
}

if hub then
   fischEvent.notify("Đang tắt hack cũ...", true)
   hub:Fire()
   hub:Destroy()
   hub = nil
   task.wait(1)
   
   for _,v in ipairs(core.HiddenUI:GetChildren()) do
      if v:IsA("ScreenGui") and v.Name == "Rayfield-Old" then v:Destroy() end
   end
end

hub = Instance.new("BindableEvent", core)
hub.Name = hubCore

-- # Main stuff
--==[[ Rayfield stuff ]]==--

function tog(label, tab, callback) 
   tab:CreateToggle({
      Name = label,
      Callback = not callback and nil or function(v)
         local suc,res = pcall(function()callback(v)end)

         if not suc then
               warn("\n\nLỗi callback nè bro: \n\n" .. res .. "\n\n<[ End ]> \n\n")
               fischEvent.notify("<font color=\"#ff3333\"><b>lỗi callback</b></font>: " .. "f9 + kéo xuống cùng + gửi qua discord = bug fix", true)
         end
      end
   })
end

local MainWindow = Rayfield:CreateWindow({
   Name = hubCore,
   LoadingTitle = "Loading script for Fisch...\n[✔] Solara supported!\nBy @Ocean10230 (Youtube)",
   LoadingSubtitle = hubDat.name,
   ShowText = hubDat.name,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = hubDat.name
   },
})

fischEvent.notify("đã load xong", true)

--==[[ Main UIs System ]]==--

local tabs = {
   farm = MainWindow:CreateTab("🎣 Hack Chính"),
   user = MainWindow:CreateTab("Người chơi", "user"),
   teleport = MainWindow:CreateTab("🇨🇳 Pháp sư")
}

local fisch = {
   cast = function()
      fischEvent.rod()
      task.wait(0.1)

      function cast()
         rodEvent.castAsync:InvokeServer(100,1)
         task.delay(0.5, function()
               if not rodVal.casted.Value and isRod(char:FindFirstChildWhichIsA("Tool")) then
                  cast()
               end
         end)
      end
      
      cast()
      
      fischEvent.cast = rodVal.bobberzone_object:GetPropertyChangedSignal("Value"):Connect(function()
         task.wait(0.2)
         cast()
      end)
   end,

   reel = function()
      fischEvent.rod()
      task.wait(0.1)

      fischEvent.reel = rodVal.bite:GetPropertyChangedSignal("Value"):Connect(function()
         if rodVal.bite.Value then                
               task.wait(1)

               local att = 0
         
               function retry()
                  local suc, _ = pcall(function()
                     r = gui.reel.bar
                     l = r.fish:GetPropertyChangedSignal("Position"):Connect(function()
                           r.fish.Position = r.playerbar.position
                     end)
                  end)

                  if not suc then
                     if att >= 15 then return end
                     att += 1
                     task.delay(0.1, retry)
                  end
               end

               retry()

               task.wait(2.051)
               abc()

               ez = gui.ChildRemoved:Connect(function(c)
                  if c.Name == "Reel" then
                     l:Disconnect()
                     ez:Disconnect()
                  end
               end)
         end
      end)
   end,

   shake = function()
      function spam() 
         gsv.GuiNavigationEnabled = true
         gsv.SelectedObject = gui.shakeui.safezone.button
         send(Enum.KeyCode.Return) 
      end

      fischEvent.shakes = game:GetService("RunService").RenderStepped:Connect(function()
         if gui:FindFirstChild("shakeui") and not rodVal.bite.Value and rodVal.casted.Value then
               if not gui:FindFirstChild("shakeui").safezone:FindFirstChild("button") then return end
               spam()
         end
      end)
   end
}

local ui = {
   farm = {
      tabs.farm:CreateLabel("AFK câu cá", "fish-symbol"),

      AutoCast = tog("Thả câu tự động", tabs.farm, function(v) val.AutoCast.Value = v ; if v then fisch.cast() elseif fischEvent.cast then fischEvent.cast:Disconnect() end end),
      SpamShake = tog("Spam Shake", tabs.farm, function(v) val.SpamShake.Value = v ; if v then fisch.shake() elseif fischEvent.shakes then fischEvent.shakes:Disconnect() end end),
      FastReel = tog("Skip kéo cá", tabs.farm, function(v) val.FastReel.Value = v ; if v then fisch.reel() else if fischEvent.reel then fischEvent.reel:Disconnect() end end end),
      
      tabs.farm:CreateLabel("Người chơi", "user"),
      Freeze = tog("Đóng băng nhân vật", tabs.farm, function(v) val.Freeze.Value = v ; local cf = hrp.CFrame ; if v then fischEvent.freeze = game:GetService("RunService").Heartbeat:Connect(function() if val.Freeze.Value then hrp.CFrame = cf end end) elseif fischEvent.freeze then fischEvent.freeze:Disconnect() end end),

      AntiAFK = tog("Anti AFK", tabs.farm, function(v)
         val.AntiAFK.Value = v
         local vu = game:GetService('VirtualUser')

         fischEvent.antiAFKrunsAfterTicks = 10000
         fischEvent.antiAFKticks = 0

         --[[
               for _, gui in ipairs(gui:GetChildren()) do
               if gui:IsA("ScreenGui") then
                  savedGUIState[gui] = gui.Enabled
                  gui.Enabled = false
               end
         end

         for _, obj in ipairs(workspace:GetDescendants()) do
               if obj:IsA("BasePart") or  obj:IsA("Decal") then
                  savedPartsState[obj] = obj.Transparency
                  obj.Transparency = 1
               end

               if obj:IsA("BillboardGui") or obj:IsA("Light") then
                  savedPartsState[obj] = obj.Enabled
                  obj.Enabled = false
               end
         end
         ]]
         
         if v then
               fischEvent.antiAFK = game:GetService("RunService").RenderStepped:Connect(function()
                  fischEvent.antiAFKticks += 1
                  if fischEvent.antiAFKticks >= fischEvent.antiAFKrunsAfterTicks then
                     vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                     task.wait(0.05)
                     vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                     --[[
                     for _, gui in ipairs(gui:GetChildren()) do
                           if gui:IsA("ScreenGui") then
                              gui.Enabled = false
                           end
                     end

                     for _, obj in ipairs(workspace:GetDescendants()) do
                           if obj:IsA("BasePart") or  obj:IsA("Decal") then
                              obj.Transparency = 1
                           end

                           if obj:IsA("BillboardGui") or obj:IsA("Light") then
                              obj.Enabled = false
                           end
                     end]]
                  end
               end)
         elseif fischEvent.antiAFK then
               fischEvent.antiAFK:Disconnect()
               --[[
               for _, gui in ipairs(gui:GetChildren()) do
                  if gui:IsA("ScreenGui") then
                     gui.Enabled = savedGUIState[gui]
                  end
               end

               for _, obj in ipairs(workspace:GetDescendants()) do
                  if obj:IsA("BasePart") or  obj:IsA("Decal") then
                     obj.Transparency = savedPartsState[obj]
                  end

                  if obj:IsA("BillboardGui") or obj:IsA("Light") then
                     obj.Enabled = savedPartsState[obj]
                  end
               end]]
         end
      end),
   },

   user = {
      Catch = tabs.user:CreateButton({
         Name = "Bắt cá",
         Callback = abc
      }),

      SellAll = tabs.user:CreateButton({
         Name = "Bán sạch hết cá",
         Callback = function(t)
               rs.events.SellAll:InvokeServer()
         end,
      }),

      Reset = tabs.user:CreateButton({
         Name = "Đột quỵ",
         Callback = function() if not died then hum.Health = 0 else Rayfield:Notify({ Title = "Nghẻo rồi bro 🥀", Content = "Chết hoài không vui đâu", Duration = 5, Image = "x", }) end end
      }),
   },

   teleport = {
      tabs.teleport:CreateLabel("Teleport", "map-pin"),
      tabs.teleport:CreateLabel("Đang dang dở chưa làm xong, đợi trăm năm nữa có", "x")
   }
}

--==[[ no one gonna notice teehee ]]==--

hub.Event:Connect(function()
   boom = true

   _G.antiAFK = {
      enabled = val.AntiAFK.Value,
      partState = savedPartsState,
      guiState = savedGUIState
   }

   for k,_ in pairs(val)do a=val[k];a.Value=false;a:Destroy()end
   for v,_ in pairs(fischEvent)do t=fischEvent[v];if typeof(t)=="RBXScriptConnection"then t:Disconnect();fischEvent[v]=nil end end
   val=nil;fischEvent=nil;ui=nil;fisch=nil;tabs=nil;plr=nil;bp=nil;died=nil;char=nil;hum=nil;hrp=nil;rod=nil;rodEvent=nil;rodVal=nil;core=nil;bool=nil;
   script:Destroy()
end)

plr.CharacterAdded:Connect(function(c)
   print("Respawned btw")
   task.wait(1.5)
   died = false
   char = c
   hum = c.Humanoid
   hrp = c.HumanoidRootPart
   fischEvent.rod()
end)

rs.events.anno_equip.OnClientEvent:Connect(function(e)
   task.wait(0)
   fischEvent.rod(e)
end)
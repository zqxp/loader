-- Arctis Hook v3.0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local StatsService = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local MarketplaceService = game:GetService("MarketplaceService")
local TelemetryService = game:GetService("TelemetryService")
local ScriptContext = game:GetService("ScriptContext")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local waitStart = tick(); repeat task.wait(0.1) until (LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) or tick() - waitStart > 10
local HAS_CLONEREF = pcall(cloneref, game)
local HAS_CHECKCALLER = type(checkcaller) == "function"
local HAS_NEWCClOSURE = pcall(newcclosure, function() end)
local HAS_DRAWING = type(Drawing) == "table"
local HAS_WRITEFILE = pcall(function() return type(writefile) == "function" end)
local HAS_READFILE = pcall(function() return type(readfile) == "function" end)
local HAS_GETRAWMT = pcall(function() return type(getrawmetatable) == "function" end)
local HAS_SETREADONLY = pcall(function() return type(setreadonly) == "function" end)
local HAS_GETNAMECALL = pcall(function() return type(getnamecallmethod) == "function" end)
local HAS_ISFILE = pcall(function() return type(isfile) == "function" end)
local HAS_DELFILE = pcall(function() return type(delfile) == "function" end)
local HAS_GETGENV = pcall(function() return type(getgenv) == "function" end)
local HAS_SETCLIPBOARD = pcall(function() return type(setclipboard) == "function" end)
if not HAS_DRAWING then
    return error("Arctis Hook requires a Drawing-capable executor")
end
pcall(setfpscap, 999)
local Vector2_new = Vector2.new
local Vector3_new = Vector3.new
local Color3_RGB = Color3.fromRGB
local CFrame_new = CFrame.new
local CFrame_lookAt = CFrame.lookAt
local CFrame_angles = CFrame.Angles
local math_clamp = math.clamp
local math_abs = math.abs
local math_floor = math.floor
local math_ceil = math.ceil
local math_rad = math.rad
local math_cos = math.cos
local math_sin = math.sin
local math_min = math.min
local math_max = math.max
local math_random = math.random
local math_sqrt = math.sqrt
local math_huge = math.huge
local math_atan2 = math.atan2
local math_acos = math.acos
local math_pi = math.pi
local tick = tick
local task_wait = task.wait
local task_spawn = task.spawn
local task_delay = task.delay
local string_format = string.format
local string_upper = string.upper
local string_lower = string.lower
local string_gsub = string.gsub
local string_find = string.find
local string_sub = string.sub
local string_byte = string.byte
local table_insert = table.insert
local table_remove = table.remove
local table_sort = table.sort
local table_find = table.find
local table_concat = table.concat
local type = type
local typeof = typeof
local ipairs = ipairs
local pairs = pairs
local next = next
local pcall = pcall
local setmetatable = setmetatable
local getmetatable = getmetatable
local tostring = tostring
local tonumber = tonumber
local Instance_new = Instance.new
local Drawing_new = Drawing.new
local Drawing_newSquare = function() return Drawing_new("Square") end
local Drawing_newText = function() return Drawing_new("Text") end
local Drawing_newLine = function() return Drawing_new("Line") end
local Drawing_newCircle = function() return Drawing_new("Circle") end
local Drawing_newTriangle = function() return Drawing_new("Triangle") end
local Drawing_newImage = function() return Drawing_new("Image") end
local U = {}
function U.IsAlive(entity)
    local success, result = pcall(function()
        if typeof(entity) == "Instance" then
            if entity:IsA("Player") then
                local char = entity.Character
                if not char then return false end
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                return hum ~= nil and hrp ~= nil and hum.Health > 0
            elseif entity:IsA("Model") then
                local hum = entity:FindFirstChildOfClass("Humanoid")
                local hrp = entity:FindFirstChild("HumanoidRootPart")
                return hum ~= nil and hrp ~= nil and hum.Health > 0
            end
        end
        return false
    end)
    return success and result or false
end
function U.IsPlayerAlive(player)
    if typeof(player) ~= "Instance" or not player:IsA("Player") then return false end
    if player == LocalPlayer then return U.IsAlive(player) end
    return U.IsAlive(player)
end
function U.W2S(pos)
    if not pos then return nil end
    local success, result = pcall(function()
        local sp, on = Camera:WorldToViewportPoint(pos)
        if on then return Vector2_new(sp.X, sp.Y) end
        return nil
    end)
    return success and result or nil
end
function U.WorldToScreen(pos)
    return U.W2S(pos)
end
function U.DistanceFrom(pos)
    local char = LocalPlayer.Character
    if not char then return math_huge end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return math_huge end
    return (pos - root.Position).Magnitude
end
function U.DistanceFromCamera(pos)
    if not Camera then return math_huge end
    return (pos - Camera.CFrame.Position).Magnitude
end
function U.GetBoundingBox(char)
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local head = char:FindFirstChild("Head")
    local size = root.Size
    local topY = head and head.Position.Y + 0.5 or root.Position.Y + size.Y * 0.6
    local botY = root.Position.Y - size.Y * 0.6
    local top = Vector3_new(root.Position.X, topY, root.Position.Z)
    local bottom = Vector3_new(root.Position.X, botY, root.Position.Z)
    return top, bottom, size
end
function U.HealthColor(health, maxHealth)
    local ratio = math_clamp(health / math_max(maxHealth or 100, 1), 0, 1)
    return Color3.fromHSV(ratio * 0.33, 1, 0.85)
end
function U.TeamColor(player)
    if player.Team and player.Team.TeamColor then
        return player.Team.TeamColor.Color
    end
    return Color3_RGB(200, 200, 200)
end
function U.LerpColor(c1, c2, t)
    return Color3_RGB(
        c1.R + (c2.R - c1.R) * t,
        c1.G + (c2.G - c1.G) * t,
        c1.B + (c2.B - c1.B) * t
    )
end
function U.Rainbow(speed)
    return Color3.fromHSV((tick() * (speed or 1)) % 1, 0.8, 1)
end
function U.AnimateColor(colors, speed)
    if not colors or #colors < 2 then return Color3_RGB(255, 255, 255) end
    local t = (tick() * (speed or 1)) % #colors
    local i = math_floor(t) + 1
    local ni = (i % #colors) + 1
    local f = t - math_floor(t)
    local c1, c2 = colors[i], colors[ni]
    return Color3_RGB(
        c1.R + (c2.R - c1.R) * f,
        c1.G + (c2.G - c1.G) * f,
        c1.B + (c2.B - c1.B) * f
    )
end
function U.GetTool(player)
    player = player or LocalPlayer
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Tool")
end
function U.FireTool(tool)
    tool = tool or U.GetTool()
    if not tool then return false end
    local remote = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
    if remote then
        return pcall(function()
            if remote:IsA("RemoteEvent") then remote:FireServer()
            else remote:InvokeServer() end
        end)
    end
    return false
end
function U.GetWeaponName(player)
    local tool = U.GetTool(player or LocalPlayer)
    return tool and tool.Name or "None"
end
function U.IsOnScreen(pos)
    if not pos then return false end
    local sp, on = Camera:WorldToViewportPoint(pos)
    local ss = Camera.ViewportSize
    return on and sp.X >= -50 and sp.X <= ss.X + 50 and sp.Y >= -50 and sp.Y <= ss.Y + 50
end
function U.ClosestPointOnScreen(pos)
    local ss = Camera.ViewportSize
    local cx, cy = ss.X / 2, ss.Y / 2
    local sp = U.W2S(pos)
    if sp then
        if sp.X >= 0 and sp.X <= ss.X and sp.Y >= 0 and sp.Y <= ss.Y then
            return sp
        end
    end
    local dir = (pos - Camera.CFrame.Position).Unit
    local screenDir = Vector2_new(dir.X, -dir.Y).Unit
    if screenDir.Magnitude < 0.01 then screenDir = Vector2_new(0, -1) end
    local scale = math_min(ss.X, ss.Y) * 0.45
    local x = cx + screenDir.X * scale
    local y = cy + screenDir.Y * scale
    return Vector2_new(math_clamp(x, 10, ss.X - 10), math_clamp(y, 10, ss.Y - 10))
end
function U.IsBehindWall(from, to, ignoreList)
    ignoreList = ignoreList or {}
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = ignoreList
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local ray = Workspace:Raycast(from, (to - from).Unit * (to - from).Magnitude, params)
    return ray ~= nil
end
function U.IsKeyDown(key)
    if typeof(key) == "EnumItem" then
        if key.EnumType == Enum.UserInputType then
            return UserInputService:IsMouseButtonPressed(key)
        else
            return UserInputService:IsKeyDown(key)
        end
    end
    return false
end
function U.GetFPS()
    local perfStats = StatsService:FindFirstChild("PerformanceStats")
    if perfStats then
        local fps = perfStats:FindFirstChild("FPS")
        if fps then return math_floor(fps.Value) end
    end
    return 60
end
function U.FormatKeyName(key)
    if not key then return "None" end
    local str = tostring(key)
    str = str:gsub("Enum%.KeyCode%.", ""):gsub("Enum%.UserInputType%.", "")
    str = str:gsub("MouseButton2", "RMB"):gsub("MouseButton1", "LMB")
    str = str:gsub("MouseButton3", "M3"):gsub("Unknown", "?")
    return str
end
function U.GetCharacterParts(char)
    local names = {"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot","HumanoidRootPart"}
    local parts = {}
    for _, name in ipairs(names) do
        local part = char:FindFirstChild(name)
        if part then table_insert(parts, part) end
    end
    return parts
end
function U.GetSkeletonConnections()
    return {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    }
end
function U.LerpVector2(a, b, t)
    return Vector2_new(a.X + (b.X - a.X) * t, a.Y + (b.Y - a.Y) * t)
end
function U.LerpVector3(a, b, t)
    return Vector3_new(a.X + (b.X - a.X) * t, a.Y + (b.Y - a.Y) * t, a.Z + (b.Z - a.Z) * t)
end
function U.DeepCopy(t)
    if type(t) ~= "table" then return t end
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = type(v) == "table" and U.DeepCopy(v) or v
    end
    return copy
end
function U.MergeTables(target, source)
    for k, v in pairs(source) do
        if type(v) == "table" and type(target[k]) == "table" then
            U.MergeTables(target[k], v)
        else
            target[k] = v
        end
    end
    return target
end
function U.PlaySound(soundId, volume)
    volume = volume or 1
    task_spawn(function()
        local sound = Instance_new("Sound")
        sound.SoundId = soundId
        sound.Volume = volume
        sound.Parent = Workspace
        sound:Play()
        local s = sound
        sound.Ended:Connect(function() if s and s.Parent then s:Destroy() end end)
        task_delay(5, function() if sound and sound.Parent then sound:Destroy() end end)
    end)
end
function U.Raycast(from, dir, maxDist, filter)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = filter or {}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    return Workspace:Raycast(from, dir.Unit * (maxDist or 1000), params)
end
function U.IsMoving(player)
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    return hrp.Velocity.Magnitude > 5
end
function U.GetVelocityMagnitude(player)
    local char = player.Character
    if not char then return 0 end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return hrp and hrp.Velocity.Magnitude or 0
end
local Config = {
    settings = {
        uiKey = Enum.KeyCode.RightShift,
        theme = "Midnight",
        watermark = true,
        notifications = true,
        keybindDisplay = true,
        configName = "default",
        menuScale = 1.0,
        fpsUnlocker = false,
        fpsTarget = 240,
    },
    combat = {
        aimbot = {
            enabled = false, mode = "Toggle", key = Enum.UserInputType.MouseButton2,
            smoothing = 50, fov = 150, fovEnabled = true,
            prediction = 0.15, aimPart = "Head", teamCheck = false, wallCheck = false,
            autoShoot = false, autoScope = false, visibilityCheck = true,
            silentAim = false, flickbot = false, scrollTargets = false,
            targetSwitching = false, switchDelay = 0.5, recoilControl = false,
        },
        silentAim = {
            enabled = false, mode = "Toggle", key = Enum.KeyCode.F,
            hitChance = 80, fov = 200, wallCheck = false,
            aimPart = "Head", prediction = 0.12,
        },
        recoilControl = {
            enabled = false, mode = "Always", key = Enum.UserInputType.MouseButton1,
            pitchCompensation = 0.5, yawCompensation = 0.3,
            recoverySpeed = 0.85, verticalScale = 1.0, horizontalScale = 0.6,
        },
        ragebot = {
            enabled = false, mode = "Toggle", key = Enum.KeyCode.R,
            hitChance = 85, targetSelection = "Closest",
            autoFire = true, autoStop = true, autoScope = true,
            resolver = true, resolverMode = "Auto",
            wallCheck = false, maxDistance = 2500,
            prediction = 0.18, baimAfterShots = 2, preferHead = true,
            multiPoint = true, backtrackTicks = 12,
            antiAimCorrection = true, autoWall = false,
            autoWallMinDamage = 30, minHitChance = 30,
            bodyAimMode = "AfterShots", forceBodyAim = false,
            predictionMethod = "Velocity", extrapolationTicks = 3,
            hitboxPriority = {"Head","UpperTorso","LowerTorso","HumanoidRootPart"},
            safetyCheck = true, minShotInterval = 0.08,
        },
        triggerbot = {
            enabled = false, key = Enum.UserInputType.MouseButton2,
            delay = 0, fovCheck = true, fov = 150,
            teamCheck = false, wallCheck = false, aimPart = "Head",
        },
        antiKatana = {
            enabled = false, mode = "Always",
            pushForce = 15, pushHeight = 10, predictivePush = true,
        },
        autoParry = {
            enabled = false, mode = "Always",
            reactionTime = 0.1, parryRange = 20,
        },
    },
    esp = {
        enabled = false, mode = "Always",
        box = true, boxColor = nil, boxThickness = 1,
        boxType = "2D", cornerBox = false, cornerSize = 6,
        name = true, nameSize = 13, nameColor = Color3_RGB(255, 255, 255),
        nameOutline = true, nameBold = true,
        health = true, healthBar = true, healthText = true,
        distance = true, distanceColor = Color3_RGB(200, 200, 200),
        weapon = true, weaponColor = Color3_RGB(200, 200, 200),
        tracer = false, tracerOrigin = "Bottom", tracerThickness = 1, tracerColor = nil,
        skeleton = false, skeletonColor = Color3_RGB(255, 255, 255), skeletonThickness = 2,
        chams = false, chamsColor = Color3_RGB(0, 150, 255),
        headDot = false, headDotColor = Color3_RGB(255, 255, 255), headDotRadius = 4,
        offscreen = false, offscreenColor = Color3_RGB(255, 255, 50), offscreenArrow = true,
        glow = false, glowColor = Color3_RGB(0, 150, 255),
        flags = false, flagList = {"Health","Distance","Weapon","Scoped"},
        maxDistance = 2000, teamCheck = false, visibleOnly = false,
        healthBarWidth = 3, snapLines = false,
    },
    visuals = {
        crosshair = {
            enabled = true, gap = 4, length = 8, thickness = 2,
            color = Color3_RGB(255, 255, 255), dot = false,
            outline = true, dynamic = false, T = false,
            recoilBased = false, gapMin = 2, gapMax = 20,
            colorMode = "Static", animationSpeed = 1,
        },
        fovCircle = {
            enabled = false, radius = 150, color = Color3_RGB(255, 255, 255),
            thickness = 1, filled = false, transparency = 1,
        },
        fovChanger = { enabled = false, value = 90 },
        noFog = false, noADS = false, noScope = false,
        noGrass = false, noEffects = false,
        bulletTracers = {
            enabled = false, color = Color3_RGB(66, 135, 245),
            lifetime = 0.3, thickness = 2, rainbow = false,
        },
        animatedColors = { enabled = false, speed = 1 },
        watermark = {
            enabled = true, showFPS = true, showTime = false,
            color = Color3_RGB(66, 135, 245),
            outline = true, size = 14, position = "TopLeft",
        },
        hitMarker = {
            enabled = true, type = "Cross",
            color = Color3_RGB(255, 50, 50), size = 10,
            duration = 0.3, showOnKill = true,
        },
        damageIndicator = {
            enabled = true, color = Color3_RGB(255, 200, 50),
            riseSpeed = 50, fadeTime = 1.5, fontSize = 16,
        },
        spectatorList = { enabled = false },
    },
    movement = {
        fly = { enabled = false, mode = "Toggle", key = Enum.KeyCode.G, speed = 50, smooth = true },
        noclip = { enabled = false, mode = "Toggle", key = Enum.KeyCode.N },
        speed = { enabled = false, value = 16, max = 200 },
        jumpPower = { enabled = false, value = 50, max = 300 },
        infiniteJump = { enabled = false, mode = "Toggle", key = Enum.KeyCode.Space },
        bhop = { enabled = false, mode = "Toggle", key = Enum.KeyCode.Space },
        autoStrafe = { enabled = false, mode = "Toggle", key = Enum.KeyCode.Z, strafeStrength = 2 },
        edgeJump = { enabled = false, checkDistance = 2.5, rayLength = 6 },
        longJump = { enabled = false, mode = "Toggle", key = Enum.KeyCode.LeftControl, power = 100, height = 20, smoothness = 0.5 },
        hover = { enabled = false, mode = "Toggle", key = Enum.KeyCode.V, height = 10 },
        wallJump = { enabled = false, pushOut = 15, pushUp = 20, forwardBoost = 10, autoClimb = true },
        climb = { enabled = false, climbSpeed = 20, autoDetect = false },
        autoFenceJump = { enabled = false, detectHeight = 3, checkDistance = 2.5 },
        dolphinDive = { enabled = false },
        airStrafing = { enabled = false },
        noFallDamage = false, noStamina = false, instantRespawn = false,
    },
    cosmetics = {
        skinChanger = { enabled = false },
        unlockAll = false,
    },
    misc = {
        autoQueue = { enabled = false },
        autoBan = { enabled = false },
        nameSpoofer = { enabled = false, name = "" },
        chatSpam = { enabled = false, message = "Arctis Hook on top!", interval = 3, messages = {}, randomMode = false },
        autoLoadout = { enabled = false },
        safezone = { enabled = false, key = Enum.KeyCode.Y, size = 50 },
        damageNotifications = { enabled = true },
        killNotifications = { enabled = true },
        modDetector = { enabled = false },
        hackerDetector = { enabled = false },
        killSay = { enabled = false, message = "Get good." },
        autoGG = { enabled = false },
        pingDisplay = { enabled = false },
        clockDisplay = { enabled = false },
        sessionStats = { enabled = false },
    },
    audio = {
        hitSound = { enabled = true, sound = "AmongUs", volume = 1 },
        killSound = { enabled = true, sound = "MLG", volume = 1 },
        headshotSound = { enabled = true, sound = "Ding", volume = 1 },
        globalVolume = 1,
    },
}
local HIT_SOUNDS = {
    AmongUs = "rbxassetid://4483345998",
    MLG = "rbxassetid://1843546661",
    Ding = "rbxassetid://9120385353",
    Bruh = "rbxassetid://5569757631",
    Bone = "rbxassetid://5884231248",
    Click = "rbxassetid://161006583",
    Coin = "rbxassetid://9073186058",
    Echo = "rbxassetid://138023163",
    Metal = "rbxassetid://143235821",
    Ping = "rbxassetid://3249102095",
    Pop = "rbxassetid://2644745557",
    Punch = "rbxassetid://169380632",
    Sword = "rbxassetid://156664962",
    Bell = "rbxassetid://9120389465",
}
local function T(r, g, b) return Color3_RGB(r, g, b) end
local Bypass = {}
Bypass.__index = Bypass
function Bypass.new()
    return setmetatable({
        hooked = false,
        origNamecall = nil,
        origIndex = nil,
        origNewIndex = nil,
        connections = {},
    }, Bypass)
end
function Bypass:Start()
    if self.hooked then return end
    self.hooked = true
    pcall(function()
        if TelemetryService and TelemetryService.Report then
            TelemetryService.Report = function() end
        end
    end)
    pcall(function()
        ScriptContext.Error:Connect(function() end)
    end)
    if not HAS_GETRAWMT or not HAS_NEWCClOSURE or not HAS_GETNAMECALL then return end
    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end
        setreadonly(mt, false)
        self.origNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(...)
            local method = getnamecallmethod()
            if method == "Kick" then return end
            if method == "FireServer" or method == "InvokeServer" then
                local args = {...}
                local selfObj = args[1]
                if selfObj and typeof(selfObj) == "Instance" and selfObj:IsA("RemoteEvent") then
                    local nm = selfObj.Name
                    if nm:find("Report") or nm:find("AntiCheat") or nm:find("Detection") or nm:find("Telemetry") or nm:find("Analytics") or nm:find("AC") then
                        return
                    end
                end
            end
            return self.origNamecall(...)
        end)
        self.origIndex = mt.__index
        mt.__index = function(t, k)
            if k == "WalkSpeed" or k == "JumpPower" or k == "JumpHeight" then
                if HAS_CHECKCALLER and checkcaller then
                    if not checkcaller() then return nil end
                end
            end
            return self.origIndex and self.origIndex(t, k) or t[k]
        end
        setreadonly(mt, true)
    end)
    pcall(function()
        local mt = getrawmetatable(LocalPlayer)
        if mt then
            setreadonly(mt, false)
            local oi = mt.__index
            mt.__index = function(t, k)
                if k == "UserId" then return 1 end
                return oi and oi(t, k) or t[k]
            end
            setreadonly(mt, true)
        end
    end)
end
function Bypass:Destroy()
    if self.hooked and self.origNamecall and HAS_GETRAWMT then
        pcall(function()
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            if self.origNamecall then mt.__namecall = self.origNamecall end
            if self.origIndex then mt.__index = self.origIndex end
            setreadonly(mt, true)
        end)
    end
    for _, conn in ipairs(self.connections) do
        pcall(conn.Disconnect, conn)
    end
    self.hooked = false
end
local DrawPool = {}
DrawPool.__index = DrawPool
function DrawPool.new()
    return setmetatable({ active = {}, pools = {}, maxSize = 300 }, DrawPool)
end
function DrawPool:Get(dtype, key)
    if key and self.active[key] then return self.active[key] end
    if not self.pools[dtype] then self.pools[dtype] = {} end
    local pool = self.pools[dtype]
    local obj = #pool > 0 and table_remove(pool) or Drawing_new(dtype)
    if key then self.active[key] = obj end
    return obj
end
function DrawPool:Release(key)
    local obj = self.active[key]
    if obj then
        self.active[key] = nil
        pcall(function() obj.Visible = false end)
        local dtype = tostring(obj):match("Drawing (.+)") or "Square"
        if not self.pools[dtype] then self.pools[dtype] = {} end
        if #self.pools[dtype] < self.maxSize then table_insert(self.pools[dtype], obj) end
    end
end
function DrawPool:ReleaseAll()
    for key in pairs(self.active) do self:Release(key) end
end
function DrawPool:Destroy()
    self:ReleaseAll()
    for _, pool in pairs(self.pools) do
        for _, obj in ipairs(pool) do pcall(function() obj:Remove() end) end
    end
    self.pools = {}
end
local Notifications = {}
Notifications.__index = Notifications
function Notifications.new()
    return setmetatable({
        notes = {}, conn = nil, pool = {},
        maxVisible = 5, noteHeight = 56, animSpeed = 0.12,
        enterDur = 0.25, exitDur = 0.4,
    }, Notifications)
end
function Notifications:GetObjs(idx)
    while #self.pool < idx + 3 do
        table_insert(self.pool, Drawing_newSquare())
        table_insert(self.pool, Drawing_newSquare())
        table_insert(self.pool, Drawing_newText())
        table_insert(self.pool, Drawing_newText())
    end
    return self.pool[idx], self.pool[idx+1], self.pool[idx+2], self.pool[idx+3]
end
function Notifications:Send(title, msg, dur, color)
    local note = {
        title=title, msg=msg, duration=dur or 3,
        color=color or T(66,135,245), start=tick(),
        alpha=0, state="entering", targetY=0, y=-56,
    }
    table_insert(self.notes, note)
    if #self.notes > self.maxVisible then table_remove(self.notes, 1) end
    local yy = 12
    for i = #self.notes, 1, -1 do self.notes[i].targetY = yy; yy = yy + self.noteHeight + 4 end
    if not self.conn then
        self.conn = RunService.RenderStepped:Connect(function() self:Update() end)
    end
end
function Notifications:SendInfo(t, m) self:Send(t, m, 3, T(66,135,245)) end
function Notifications:SendSuccess(t, m) self:Send(t, m, 3, T(40,200,80)) end
function Notifications:SendError(t, m) self:Send(t, m, 4, T(220,40,40)) end
function Notifications:SendWarning(t, m) self:Send(t, m, 3.5, T(255,180,50)) end
function Notifications:Update()
    if #self.notes == 0 then
        if self.conn then self.conn:Disconnect(); self.conn = nil end
        for _, obj in ipairs(self.pool) do pcall(function() obj.Visible = false end) end
        return
    end
    local now = tick()
    for i = #self.notes, 1, -1 do
        local n = self.notes[i]
        if now - n.start > n.duration + self.exitDur then table_remove(self.notes, i) end
    end
    local yy = 12
    for i = #self.notes, 1, -1 do self.notes[i].targetY = yy; yy = yy + self.noteHeight + 4 end
    local ss = Camera.ViewportSize
    local needed = #self.notes * 4
    for i, note in ipairs(self.notes) do
        local elapsed = now - note.start
        local alpha = 1
        if elapsed < self.enterDur then alpha = elapsed / self.enterDur; note.state = "entering"
        elseif elapsed > note.duration then alpha = 1 - (elapsed - note.duration) / self.exitDur; note.state = "exiting"
        else alpha = 1; note.state = "active" end
        alpha = math_clamp(alpha, 0, 1)
        note.y = note.y + (note.targetY - note.y) * self.animSpeed
        local y = note.y; local w = 300; local x = ss.X - w - 12
        local entry = (i-1)*4+1
        local bg, line, titleT, msgT = self:GetObjs(entry)
        if bg then bg.Color=T(14,14,18); bg.Filled=true; bg.Position=Vector2_new(x,y); bg.Size=Vector2_new(w,self.noteHeight); bg.Transparency=0.85*alpha; bg.Visible=alpha>0.01 end
        if line then line.Color=note.color; line.Filled=true; line.Position=Vector2_new(x,y); line.Size=Vector2_new(3,self.noteHeight); line.Transparency=1*alpha; line.Visible=alpha>0.01 end
        if titleT then titleT.Text=note.title; titleT.Size=14; titleT.Color=note.color; titleT.Outline=true; titleT.Position=Vector2_new(x+14,y+6); titleT.Transparency=alpha; titleT.Visible=alpha>0.01 end
        if msgT then msgT.Text=note.msg; msgT.Size=11; msgT.Color=T(180,180,190); msgT.Position=Vector2_new(x+14,y+26); msgT.Transparency=alpha; msgT.Visible=alpha>0.01 end
    end
    for i = needed+1, #self.pool do if self.pool[i] then pcall(function() self.pool[i].Visible = false end) end end
end
function Notifications:Destroy()
    if self.conn then self.conn:Disconnect(); self.conn = nil end
    for _, obj in ipairs(self.pool) do pcall(function() obj:Remove() end) end
    self.pool = {}; self.notes = {}
end
local ESP = {}
ESP.__index = ESP
function ESP.new()
    return setmetatable({
        enabled = false, conn = nil, playerData = {}, connections = {},
        drawPool = DrawPool.new(), lastRender = tick(),
    }, ESP)
end
function ESP:SetEnabled(enabled)
    self.enabled = enabled
    if self.enabled then
        self:SetupTracking()
        if not self.conn then
            self.conn = RunService.RenderStepped:Connect(function() self:OnRender() end)
        end
    else
        if self.conn then self.conn:Disconnect(); self.conn = nil end
        for p in pairs(self.playerData) do self:HideAll(p) end
    end
end
function ESP:SetupTracking()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then self:TrackPlayer(player) end
    end
    local conn1 = Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then self:TrackPlayer(p) end end)
    table_insert(self.connections, conn1)
    local conn2 = Players.PlayerRemoving:Connect(function(p) self:UntrackPlayer(p) end)
    table_insert(self.connections, conn2)
end
function ESP:TrackPlayer(player)
    if self.playerData[player] then return end
    local data = {
        player = player, char = nil, objs = {},
        lastHealth = 100, lastMaxHealth = 100, smoothedPos = Vector3_new(0,0,0),
    }
    self.playerData[player] = data
    local function setupChar(char)
        if not char then return end; data.char = char
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then data.lastHealth = hum.Health; data.lastMaxHealth = hum.MaxHealth; data.smoothedPos = hrp.Position end
        self:CreatePlayerObjs(player)
    end
    if player.Character then setupChar(player.Character) end
    local c1 = player.CharacterAdded:Connect(function(char)
        self:RemovePlayerObjs(player); data.char = char; task_wait(0.3); setupChar(char)
    end)
    table_insert(self.connections, c1)
    local c2 = player.CharacterRemoving:Connect(function() self:RemovePlayerObjs(player); data.char = nil end)
    table_insert(self.connections, c2)
end
function ESP:UntrackPlayer(player)
    self:RemovePlayerObjs(player); self.playerData[player] = nil
end
function ESP:CreatePlayerObjs(player)
    local data = self.playerData[player]
    if not data then return end
    local keys = {"Box","BoxBg","Name","Dist","Weapon","Tracer","HD","Off","HBg","HFill","HTxt"}
    for _, key in ipairs(keys) do
        local k = "esp_" .. player.UserId .. "_" .. key
        if key == "Tracer" then data.objs[key] = self.drawPool:Get("Line", k)
        elseif key == "HD" then data.objs[key] = self.drawPool:Get("Circle", k); if data.objs[key] then data.objs[key].NumSides = 12 end
        elseif key == "Off" then data.objs[key] = self.drawPool:Get("Text", k)
        elseif key == "Box" or key == "BoxBg" or key == "HBg" or key == "HFill" then data.objs[key] = self.drawPool:Get("Square", k)
        else data.objs[key] = self.drawPool:Get("Text", k); if data.objs[key] then data.objs[key].Outline = true end end
    end
    data.objs.Skel = {}
    for i = 1, 14 do
        data.objs.Skel[i] = self.drawPool:Get("Line", "esp_" .. player.UserId .. "_sk" .. i)
    end
end
function ESP:RemovePlayerObjs(player)
    local data = self.playerData[player]
    if not data then return end
    for _, obj in pairs(data.objs) do
        if type(obj) == "table" then for _, o in ipairs(obj) do if typeof(o) == "userdata" then pcall(function() o:Remove() end) end end
        elseif typeof(obj) == "userdata" then pcall(function() obj:Remove() end) end
    end
    data.objs = {}
end
function ESP:HideAll(player)
    local data = self.playerData[player]
    if not data then return end
    for _, obj in pairs(data.objs) do
        if type(obj) == "table" then for _, o in ipairs(obj) do pcall(function() o.Visible = false end) end
        else pcall(function() obj.Visible = false end) end
    end
end
function ESP:OnRender()
    if not self.enabled then return end
    local cfg = Config.esp
    if not cfg.enabled then
        for p in pairs(self.playerData) do self:HideAll(p) end; return end
    for _, p in ipairs(Players:GetPlayers()) do
    if p == LocalPlayer then
        if self.playerData[p] then self:HideAll(p) end
    else
        self:RenderPlayer(p, cfg)
    end
end
function ESP:RenderPlayer(player, cfg)
    local data = self.playerData[player]
    if not data then return end
    local char = player.Character
    if not char or not U.IsAlive(player) then self:HideAll(player); return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then self:HideAll(player); return end
    if cfg.teamCheck and player.Team == LocalPlayer.Team then self:HideAll(player); return end
    local dist = U.DistanceFrom(hrp.Position)
    if dist > cfg.maxDistance then self:HideAll(player); return end
    if cfg.visibleOnly then
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = { LocalPlayer.Character, char }
        params.FilterType = Enum.RaycastFilterType.Blacklist
        if Workspace:Raycast(Camera.CFrame.Position, (hrp.Position - Camera.CFrame.Position).Unit * dist, params) then
            self:HideAll(player); return end
    end
    local top, bottom = U.GetBoundingBox(char)
    if not top or not bottom then self:HideAll(player); return end
    local ts = U.W2S(top); local bs = U.W2S(bottom)
    if not ts or not bs then self:HideAll(player); return end
    local bh = math_abs(ts.Y - bs.Y); local bw = bh * 0.55
    local bx = ts.X - bw/2; local by = ts.Y
    local head = char:FindFirstChild("Head")
    local hp = data.lastHealth; local mhp = math_max(data.lastMaxHealth, 1)
    local hpRatio = math_clamp(hp / mhp, 0, 1)
    local boxColor = cfg.boxColor or U.TeamColor(player)
    local hColor = U.HealthColor(hp, mhp)
    data.smoothedPos = data.smoothedPos + (hrp.Position - data.smoothedPos) * 0.3
    local objs = data.objs; if not objs or not next(objs) then return end
    if objs.BoxBg and objs.Box then
        objs.BoxBg.Position = Vector2_new(bx-2, by-2); objs.BoxBg.Size = Vector2_new(bw+4, bh+4)
        objs.BoxBg.Color = T(0,0,0); objs.BoxBg.Transparency = 0.3; objs.BoxBg.Filled = false
        objs.BoxBg.Thickness = cfg.boxThickness + 2; objs.BoxBg.Visible = cfg.box
        objs.Box.Position = Vector2_new(bx, by); objs.Box.Size = Vector2_new(bw, bh)
        objs.Box.Color = boxColor; objs.Box.Transparency = 1; objs.Box.Filled = false
        objs.Box.Thickness = cfg.boxThickness; objs.Box.Visible = cfg.box
    end
    if objs.HBg and objs.HFill then
        local hx = bx - 6; local hw = cfg.healthBarWidth or 3
        objs.HBg.Position = Vector2_new(hx, by); objs.HBg.Size = Vector2_new(hw, bh)
        objs.HBg.Color = T(20,20,25); objs.HBg.Transparency = 0.7; objs.HBg.Visible = cfg.healthBar
        objs.HFill.Position = Vector2_new(hx, by + bh*(1-hpRatio)); objs.HFill.Size = Vector2_new(hw, bh*hpRatio)
        objs.HFill.Color = hColor; objs.HFill.Transparency = 1; objs.HFill.Visible = cfg.healthBar
    end
    if objs.HTxt then
        objs.HTxt.Text = string_format("%.0f", hp); objs.HTxt.Size = 11; objs.HTxt.Color = hColor
        objs.HTxt.Position = Vector2_new(bx+bw+4, by+2); objs.HTxt.Transparency = 1; objs.HTxt.Visible = cfg.healthText
    end
    if objs.Name then
        local n = cfg.nameBold and string_upper(player.DisplayName or player.Name) or (player.DisplayName or player.Name)
        objs.Name.Text = n; objs.Name.Size = cfg.nameSize or 13; objs.Name.Color = cfg.nameColor or T(255,255,255)
        objs.Name.Position = Vector2_new(bx+bw/2-#n*(cfg.nameSize or 13)*0.3, by-(cfg.nameSize or 13)-4)
        objs.Name.Transparency = 1; objs.Name.Visible = cfg.name
    end
    if objs.Dist then
        objs.Dist.Text = string_format("[%.0fm]", dist); objs.Dist.Size = 11
        objs.Dist.Color = cfg.distanceColor or T(200,200,200)
        objs.Dist.Position = Vector2_new(bx+bw/2-25, by+bh+2); objs.Dist.Transparency = 1; objs.Dist.Visible = cfg.distance
    end
    if objs.Weapon then
        local wn = U.GetWeaponName(player)
        objs.Weapon.Text = wn; objs.Weapon.Size = 11; objs.Weapon.Color = cfg.weaponColor or T(200,200,200)
        objs.Weapon.Position = Vector2_new(bx+bw/2-#wn*3.5, by+bh+16); objs.Weapon.Transparency = 1; objs.Weapon.Visible = cfg.weapon
    end
    if objs.Tracer then
        local ss = Camera.ViewportSize
        local origin = cfg.tracerOrigin == "Top" and Vector2_new(ss.X/2,0) or cfg.tracerOrigin == "Crosshair" and UserInputService:GetMouseLocation() or Vector2_new(ss.X/2,ss.Y)
        objs.Tracer.From = origin; objs.Tracer.To = Vector2_new(bx+bw/2, by+bh)
        objs.Tracer.Color = cfg.tracerColor or boxColor; objs.Tracer.Thickness = cfg.tracerThickness or 1
        objs.Tracer.Transparency = 1; objs.Tracer.Visible = cfg.tracer
    end
    if objs.HD and head then
        local hs = U.W2S(head.Position + Vector3_new(0,0.3,0))
        if hs then
            objs.HD.Position = hs; objs.HD.Radius = cfg.headDotRadius or 4
            objs.HD.Color = cfg.headDotColor or T(255,255,255); objs.HD.Filled = true
            objs.HD.Transparency = 1; objs.HD.Visible = cfg.headDot
        end
    end
    if objs.Skel then
        local conns = U.GetSkeletonConnections()
        local pts = {}
        for _, n in ipairs({"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}) do
            local p = char:FindFirstChild(n); if p then pts[n] = p.Position end
        end
        for i, c in ipairs(conns) do
            local p1, p2 = pts[c[1]], pts[c[2]]
            if p1 and p2 then
                local s1 = U.W2S(p1); local s2 = U.W2S(p2)
                if s1 and s2 and objs.Skel[i] then
                    objs.Skel[i].From = s1; objs.Skel[i].To = s2
                    objs.Skel[i].Color = cfg.skeletonColor or T(255,255,255)
                    objs.Skel[i].Thickness = cfg.skeletonThickness or 2
                    objs.Skel[i].Transparency = 1; objs.Skel[i].Visible = cfg.skeleton
                end
            end
        end
        for i = #conns + 1, #objs.Skel do if objs.Skel[i] then objs.Skel[i].Visible = false end end
    end
    if objs.Off then
        local on = U.IsOnScreen(hrp.Position)
        if not on then
            local ss = Camera.ViewportSize; local cx, cy = ss.X/2, ss.Y/2
            local dir = (hrp.Position - Camera.CFrame.Position).Unit
            local sd = Vector2_new(dir.X, -dir.Y).Unit
            if sd.Magnitude < 0.01 then sd = Vector2_new(0,-1) end
            local x = cx + sd.X * math_min(ss.X, ss.Y) * 0.4
            local y = cy + sd.Y * math_min(ss.X, ss.Y) * 0.4
            x = math_clamp(x, 50, ss.X-50); y = math_clamp(y, 50, ss.Y-50)
            objs.Off.Text = cfg.offscreenArrow and ">" or "!"; objs.Off.Size = 18
            objs.Off.Color = cfg.offscreenColor or T(255,255,50)
            objs.Off.Position = Vector2_new(x,y); objs.Off.Transparency = 1; objs.Off.Visible = cfg.offscreen
        else objs.Off.Visible = false end
    end
end
function ESP:Destroy()
    if self.conn then self.conn:Disconnect(); self.conn = nil end
    for _, conn in ipairs(self.connections) do pcall(conn.Disconnect, conn) end
    self.connections = {}
    for p in pairs(self.playerData) do self:RemovePlayerObjs(p) end
    self.playerData = {}
    if self.drawPool then self.drawPool:Destroy() end
end
local Aimbot = {}
Aimbot.__index = Aimbot
function Aimbot.new()
    return setmetatable({
        enabled = false, conn = nil, heartConn = nil,
        currentTarget = nil, targetIndex = 0, targetList = {},
        fovCircle = nil, toggled = false, lastSwitchTime = 0,
        silentAimHook = nil, scrollConn = nil, targetHistory = {},
        recoilData = { lastShot = 0, compensation = Vector2_new(0,0), recoilPitch = 0, recoilYaw = 0 },
        predictionCache = {}, targetScores = {},
        lastFrameTime = 0,
    }, Aimbot)
end
function Aimbot:SetEnabled(enabled)
    self.enabled = enabled
    if self.enabled then
        if not self.conn then
            self.conn = RunService.RenderStepped:Connect(function()
                self:RenderFovCircle()
                self:OnRender()
            end)
        end
        self:SetupScrollWheel()
        self:SetupSilentAim()
    else
        if self.conn then self.conn:Disconnect(); self.conn = nil end
        if self.fovCircle then pcall(function() self.fovCircle:Remove() end); self.fovCircle = nil end
        self.currentTarget = nil; self.targetIndex = 0; self.predictionCache = {}
        self.targetScores = {}; self.recoilData = { lastShot=0, compensation=Vector2_new(0,0), recoilPitch=0, recoilYaw=0 }
    end
end
function Aimbot:SetupScrollWheel()
    if self.scrollConn then return end
    self.scrollConn = UserInputService.InputChanged:Connect(function(input, gpe)
        if gpe then return end
        if Config.combat.aimbot.scrollTargets and input.UserInputType == Enum.UserInputType.MouseWheel then
            local dir = input.Position.Z > 0 and 1 or -1
            self:CycleTarget(dir)
        end
    end)
end
function Aimbot:CycleTarget(dir)
    local targets = self:GetValidTargets()
    if #targets == 0 then return end
    self.targetIndex = (self.targetIndex + dir - 1) % #targets + 1
    if self.targetIndex < 1 then self.targetIndex = #targets end
    self.currentTarget = targets[self.targetIndex]
    self.lastSwitchTime = tick()
end
function Aimbot:ApplyRecoilControl(cframe)
    local cfg = Config.combat.recoilControl
    if not cfg or not cfg.enabled then return cframe end
    local now = tick()
    local delta = now - self.recoilData.lastShot
    if delta < 0.5 then
        self.recoilData.recoilPitch = self.recoilData.recoilPitch + (cfg.pitchCompensation or 0.5) * math_clamp(1-delta, 0, 1)
        self.recoilData.recoilYaw = self.recoilData.recoilYaw + (cfg.yawCompensation or 0.3) * math_clamp(1-delta, 0, 1)
    end
    local decay = 0.85
    self.recoilData.recoilPitch = self.recoilData.recoilPitch * decay
    self.recoilData.recoilYaw = self.recoilData.recoilYaw * decay
    if math_abs(self.recoilData.recoilPitch) > 0.001 or math_abs(self.recoilData.recoilYaw) > 0.001 then
        local rightVec = cframe.RightVector
        local upVec = cframe.UpVector
        local lookVec = cframe.LookVector
        local adjustedDir = (lookVec + rightVec * self.recoilData.recoilYaw + upVec * (-self.recoilData.recoilPitch)).Unit
        return CFrame_lookAt(cframe.Position, cframe.Position + adjustedDir)
    end
    return cframe
end
function Aimbot:SetupSilentAim()
    if not HAS_GETRAWMT or not HAS_NEWCClOSURE then return end
    if self.silentAimHook then return end
    self.silentAimHook = true
    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end
        setreadonly(mt, false)
        local orig = mt.__namecall
        self.silentAimHookOrig = orig
        mt.__namecall = newcclosure(function(...)
            local method = getnamecallmethod()
            if method == "FireServer" or method == "InvokeServer" then
                local args = {...}
                local selfObj = args[1]
                if selfObj and typeof(selfObj) == "Instance" and (selfObj:IsA("RemoteEvent") or selfObj:IsA("RemoteFunction")) then
                    local silentCfg = Config.combat.silentAim
                    local aim = aimbot_instance
                    if silentCfg.enabled and aim and aim.currentTarget then
                        local target = aim.currentTarget
                        if target and target.char then
                            local hrp = target.char:FindFirstChild("HumanoidRootPart")
                            local ap = target.char:FindFirstChild(silentCfg.aimPart or "Head") or hrp
                            if ap and hrp then
                                local aimPos = ap.Position
                                if silentCfg.prediction and silentCfg.prediction > 0 then
                                    local vel = hrp.Velocity
                                    local dist = (ap.Position - Camera.CFrame.Position).Magnitude
                                    local predAdj = silentCfg.prediction * math_clamp(dist/300, 0.5, 2)
                                    aimPos = aimPos + vel * predAdj
                                end
                                if silentCfg.recoilControl and Config.combat.recoilControl and Config.combat.recoilControl.enabled then
                                    local dist = (aimPos - Camera.CFrame.Position).Magnitude
                                    local pitchOffset = aim.recoilData.recoilPitch * dist * 0.001
                                    local yawOffset = aim.recoilData.recoilYaw * dist * 0.001
                                    aimPos = aimPos + Camera.CFrame.UpVector * pitchOffset + Camera.CFrame.RightVector * yawOffset
                                end
                                for i = 2, #args do
                                    if typeof(args[i]) == "CFrame" then
                                        args[i] = CFrame_lookAt(args[i].Position, aimPos)
                                    elseif typeof(args[i]) == "Vector3" then
                                        local d = (args[i] - Camera.CFrame.Position).Magnitude
                                        if d > 1 and d < 5000 then args[i] = aimPos end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return orig(...)
        end)
        setreadonly(mt, true)
    end)
end
function Aimbot:GetValidTargets()
    local cfg = Config.combat.aimbot
    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        repeat
            if p == LocalPlayer then break end
            if cfg.teamCheck and p.Team == LocalPlayer.Team then break end
            local c = p.Character; if not c or not U.IsAlive(p) then break end
            local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then break end
            local dist = U.DistanceFrom(hrp.Position); if dist > 1000 then break end
            local sp = U.W2S(hrp.Position); if not sp then break end
            if cfg.visibilityCheck then
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = { LocalPlayer.Character, c }
                params.FilterType = Enum.RaycastFilterType.Blacklist
                if Workspace:Raycast(Camera.CFrame.Position, (hrp.Position-Camera.CFrame.Position).Unit*dist, params) then break end
            end
            local hum = c:FindFirstChildOfClass("Humanoid")
            table_insert(targets, { player=p, char=c, hrp=hrp, dist=dist, sp=sp, health=hum and hum.Health or 30 })
        until true
    end
    return targets
end
function Aimbot:ScoreTarget(t, mp)
    local cfg = Config.combat.aimbot
    local ap = t.char:FindFirstChild(cfg.aimPart or "Head") or t.hrp
    local pos = ap.Position
    local vel = t.hrp.Velocity
    local distFactor = math_clamp(U.DistanceFromCamera(pos)/200, 0.5, 3)
    if cfg.prediction and cfg.prediction > 0 then
        pos = pos + vel * cfg.prediction * distFactor
    end
    local as = U.W2S(pos); if not as then return nil end
    local sd = (as-mp).Magnitude; local fov = cfg.fov or 150
    if sd > fov then return nil end
    local score = sd
    if vel.Magnitude > 30 then score = score * 0.85 end
    if t.health and t.health < 30 then score = score * 0.7 end
    if t.dist < 50 then score = score * 0.6 end
    if self.targetHistory[t.player] then
        local lastSeen = self.targetHistory[t.player].time or 0
        if tick() - lastSeen < 1 then score = score * 0.9 end
    end
    return score, pos
end
function Aimbot:GetBestTarget()
    local cfg = Config.combat.aimbot
    local targets = self:GetValidTargets()
    if #targets == 0 then return nil end
    local mp = UserInputService:GetMouseLocation()
    local best, bestScore, bestPos = nil, math_huge, nil
    for _, t in ipairs(targets) do
        local score, aimPos = self:ScoreTarget(t, mp)
        if score and score < bestScore then bestScore = score; best = t; bestPos = aimPos end
    end
    if best then self.targetScores[best.player] = bestScore end
    return best, bestPos
end
function Aimbot:GetAimPoint(target)
    if not target then return nil end
    local cfg = Config.combat.aimbot
    local ap = target.char:FindFirstChild(cfg.aimPart or "Head") or target.hrp
    local pos = ap.Position
    if cfg.prediction and cfg.prediction > 0 then
        local vel = target.hrp.Velocity
        local dist = U.DistanceFromCamera(pos)
        local adj = cfg.prediction * math_clamp(dist/200, 0.5, 3)
        if vel.Magnitude > 50 then adj = adj * (vel.Magnitude/16) end
        pos = pos + vel * adj
    end
    return pos
end
function Aimbot:IsAimbotActive()
    local cfg = Config.combat.aimbot
    if not cfg.enabled then return false end
    if cfg.mode == "Always" then return true end
    if cfg.mode == "Toggle" then return self.toggled end
    if cfg.mode == "Hold" then return U.IsKeyDown(cfg.key) end
    return false
end
function Aimbot:RenderFovCircle()
    local cfg = Config.combat.aimbot
    if cfg.fovEnabled then
        if not self.fovCircle then self.fovCircle = Drawing_newCircle(); self.fovCircle.NumSides = 64 end
        local mp = UserInputService:GetMouseLocation()
        self.fovCircle.Position = mp; self.fovCircle.Radius = cfg.fov or 150
        self.fovCircle.Color = T(255,255,255); self.fovCircle.Thickness = 1
        self.fovCircle.Filled = false; self.fovCircle.Transparency = self:IsAimbotActive() and 1 or 0.4
        self.fovCircle.Visible = true
    elseif self.fovCircle then self.fovCircle.Visible = false end
end
function Aimbot:OnRender()
    local cfg = Config.combat.aimbot
    if not cfg.enabled then self.currentTarget = nil; return end
    if not self:IsAimbotActive() then self.currentTarget = nil; return end
    if cfg.scrollTargets and self.currentTarget then
        local t = self.currentTarget
        if t and t.player.Character and U.IsAlive(t.player) then
            local ap = self:GetAimPoint(t)
            if ap then
                local smooth = cfg.smoothing or 50
                local cf = Camera.CFrame
                local recoilCfg = Config.combat.recoilControl
                if recoilCfg and recoilCfg.enabled then cf = self:ApplyRecoilControl(cf) end
                local td = (ap - cf.Position).Unit
                local cd = cf.LookVector; local tFactor = math_clamp(1-(smooth/100), 0.01, 0.99)
                if tFactor > 0.95 then tFactor = 0.95 end
                local ld = cd:Lerp(td, tFactor); if ld.Magnitude < 0.01 then ld = td end
                Camera.CFrame = CFrame_lookAt(cf.Position, cf.Position+ld.Unit)
                if cfg.autoShoot then U.FireTool() end
            end
        else self.currentTarget = nil end
        return
    end
    local target, aimPoint = self:GetBestTarget()
    if target and aimPoint then
        self.currentTarget = target
        if not self.targetHistory[target.player] then self.targetHistory[target.player] = { time = 0, count = 0 } end
        self.targetHistory[target.player].time = tick()
        self.targetHistory[target.player].count = (self.targetHistory[target.player].count or 0) + 1
        local ap = self:GetAimPoint(target)
        if ap then
            local smooth = cfg.smoothing or 50
            local cf = Camera.CFrame
            local recoilCfg = Config.combat.recoilControl
            if recoilCfg and recoilCfg.enabled then cf = self:ApplyRecoilControl(cf) end
            local td = (ap - cf.Position).Unit
            local cd = cf.LookVector; local tFactor = math_clamp(1-(smooth/100), 0.01, 0.99)
            if tFactor > 0.95 then tFactor = 0.95 end
            local ld = cd:Lerp(td, tFactor); if ld.Magnitude < 0.01 then ld = td end
            Camera.CFrame = CFrame_lookAt(cf.Position, cf.Position+ld.Unit)
            if cfg.autoShoot then U.FireTool() end
        end
    else self.currentTarget = nil end
end
function Aimbot:GetTargetPlayer() return self.currentTarget and self.currentTarget.player or nil end
function Aimbot:OnShotFired()
    self.recoilData.lastShot = tick()
end
function Aimbot:Destroy()
    if self.conn then self.conn:Disconnect(); self.conn = nil end
    if self.heartConn then self.heartConn:Disconnect(); self.heartConn = nil end
    if self.scrollConn then self.scrollConn:Disconnect(); self.scrollConn = nil end
    if self.fovCircle then pcall(function() self.fovCircle:Remove() end); self.fovCircle = nil end
    if self.silentAimHookOrig and HAS_GETRAWMT then
        pcall(function()
            local mt = getrawmetatable(game); setreadonly(mt, false)
            mt.__namecall = self.silentAimHookOrig; setreadonly(mt, true)
        end)
    end
end
local Ragebot = {}
Ragebot.__index = Ragebot
function Ragebot.new()
    return setmetatable({
        enabled = false, conn = nil, animConn = nil,
        currentTarget = nil,
        backtrackBuffer = {}, backtrackMaxTicks = 64, backtrackTickRate = 0.025,
        lastBacktrackTick = 0,
        resolverIdx = 1, resolverAngles = {0,45,90,135,180,225,270,315},
        lastResolveTick = 0, resolveInterval = 0.2,
        shotsFired = 0, lastShotTime = 0, baimMode = false,
        lastTargetPlayer = nil, targetLockTime = 0, lockDelay = 0.08,
        lastScanTick = 0, scanInterval = 0.033,
        animStateCache = {}, hitboxCache = {},
        missCounter = 0, hitCounter = 0,
        lastTargetVelocities = {},
    }, Ragebot)
end
function Ragebot:Set(enabled)
    self.enabled = enabled
    if self.enabled then
        if not self.conn then
            self.conn = RunService.Heartbeat:Connect(function() self:OnHeartbeat() end)
        end
    else
        if self.conn then self.conn:Disconnect(); self.conn = nil end
        self.currentTarget = nil; self.backtrackBuffer = {}
        self.shotsFired = 0; self.baimMode = false; self.animStateCache = {}
        self.hitboxCache = {}; self.lastTargetVelocities = {}
    end
end
function Ragebot:GetAnimState(player)
    local char = player.Character
    if not char then return "unknown" end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return "unknown" end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return "unknown" end
    local vel = hrp.Velocity.Magnitude
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
        return "air"
    elseif state == Enum.HumanoidStateType.Running then
        if vel > 30 then return "sprinting" end
        return "walking"
    elseif state == Enum.HumanoidStateType.Climbing then
        return "climbing"
    elseif vel < 1 then
        return "standing"
    end
    return "unknown"
end
function Ragebot:RecordBacktrack(player)
    local now = tick()
    if now - self.lastBacktrackTick < self.backtrackTickRate then return end
    self.lastBacktrackTick = now
    local char = player.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); local head = char:FindFirstChild("Head")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local rec = {
        tick=now, hrpPos=hrp.Position, hrpCF=hrp.CFrame,
        headPos=head and head.Position or hrp.Position,
        vel=hrp.Velocity, accel=Vector3_new(0,0,0),
        health=hum and hum.Health or 100,
        animState = self:GetAnimState(player),
    }
    if not self.backtrackBuffer[player] then self.backtrackBuffer[player] = {} end
    local buf = self.backtrackBuffer[player]
    if #buf > 0 then rec.accel = (rec.vel - buf[#buf].vel) / (now - buf[#buf].tick + 0.001) end
    table_insert(buf, rec)
    while #buf > self.backtrackMaxTicks do table_remove(buf, 1) end
end
function Ragebot:GetBacktrackPos(player, ticksBack)
    local buf = self.backtrackBuffer[player]
    if not buf or #buf == 0 then return nil end
    local idx = math_clamp(#buf - (ticksBack or 0), 1, #buf)
    local rec = buf[idx]
    if not rec then return nil end
    local age = tick() - rec.tick
    if age > 0.5 then return nil end
    if idx < #buf and age > 0.03 then
        local nextRec = buf[idx + 1]
        if nextRec then
            local frac = (tick() - rec.tick) / (nextRec.tick - rec.tick + 0.001)
            frac = math_clamp(frac, 0, 1)
            local ip = rec.hrpPos:Lerp(nextRec.hrpPos, frac)
            local iv = rec.vel:Lerp(nextRec.vel, frac)
            return { hrpPos=ip, headPos=rec.headPos:Lerp(nextRec.headPos, frac), vel=iv, tick=rec.tick, animState=rec.animState }
        end
    end
    return rec
end
function Ragebot:ResolveTarget(player)
    local cfg = Config.combat.ragebot
    if not cfg or not cfg.resolver then return nil end
    local char = player.Character; if not char then return nil end
    local head = char:FindFirstChild("Head")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not head or not hrp then return nil end
    local now = tick()
    local animState = self:GetAnimState(player)
    if now - self.lastResolveTick > self.resolveInterval then
        if animState == "standing" then
            self.resolverIdx = (self.resolverIdx % (#self.resolverAngles)) + 1
        elseif animState == "air" then
            local vel = hrp.Velocity; local hDir = vel * Vector3_new(1,0,1)
            if hDir.Magnitude > 1 then
                local lookAngle = math_deg(math_atan2(-hDir.Unit.X, -hDir.Unit.Z))
                local bestAngle, bestDiff = 0, 360
                for _, a in ipairs(self.resolverAngles) do
                    local diff = math_abs((a - lookAngle + 540) % 360 - 180)
                    if diff < bestDiff then bestDiff = diff; bestAngle = a end
                end
                for i, a in ipairs(self.resolverAngles) do
                    if math_abs(a - bestAngle) < 5 then self.resolverIdx = i; break end
                end
            else
                self.resolverIdx = (self.resolverIdx % (#self.resolverAngles)) + 1
            end
        else
            self.resolverIdx = (self.resolverIdx % (#self.resolverAngles)) + 1
        end
        if self.missCounter > 3 and self.hitCounter < 2 then
            self.resolverIdx = (self.resolverIdx + 2) % #self.resolverAngles + 1
        end
        self.lastResolveTick = now
    end
    local vel = hrp.Velocity
    if vel.Magnitude > 5 then
        local vd = vel.Unit; local bf = hrp.CFrame.LookVector; local dot = bf:Dot(vd)
        if animState == "sprinting" then
            if dot < -0.3 then return head.Position + Vector3_new(0,0.15,0) - bf * 1.2
            elseif dot > 0.3 then return head.Position + Vector3_new(0,0.15,0) + bf * 0.8
            else return head.Position + Vector3_new(0,0.15,0) end
        elseif animState == "air" then
            return head.Position + Vector3_new(0,0.1,0)
        end
        if dot < -0.3 then return head.Position + Vector3_new(0,0.2,0) - bf * 1.5
        elseif dot < 0.3 then return head.Position + Vector3_new(0,0.2,0)
        else return head.Position + Vector3_new(0,0.2,0) + bf * 0.5 end
    end
    local angle = self.resolverAngles[self.resolverIdx]
    local lv = hrp.CFrame.LookVector; local rad = math_rad(angle)
    local rx = lv.X*math_cos(rad) - lv.Z*math_sin(rad)
    local rz = lv.X*math_sin(rad) + lv.Z*math_cos(rad)
    local rd = Vector3_new(rx, 0, rz).Unit
    local tt = (Camera.CFrame.Position - hrp.Position).Unit
    local dot = rd:Dot(tt)
    if animState == "standing" then
        if math_abs(dot) > 0.7 then return head.Position + Vector3_new(0,0.25,0) end
        return head.Position + rd*0.3 + Vector3_new(0,0.2,0)
    end
    if dot > 0.3 then return head.Position + Vector3_new(0,0.3,0)
    elseif dot < -0.3 then
        local ut = char:FindFirstChild("UpperTorso")
        return ut and ut.Position or hrp.Position
    else return head.Position + rd*0.5 + Vector3_new(0,0.2,0) end
end
function Ragebot:AutoWall(targetPos, targetPlayer)
    local cfg = Config.combat.ragebot
    if not cfg or not cfg.autoWall then return true, 100 end
    local char = LocalPlayer.Character; if not char then return true, 100 end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return true, 100 end
    local params = RaycastParams.new()
    local filter = { char }; if targetPlayer and targetPlayer.Character then table_insert(filter, targetPlayer.Character) end
    params.FilterDescendantsInstances = filter; params.FilterType = Enum.RaycastFilterType.Blacklist
    local dir = (targetPos - hrp.Position).Unit; local dist = (targetPos - hrp.Position).Magnitude
    local ray = Workspace:Raycast(hrp.Position, dir*dist, params)
    if ray then
        local hd = (ray.Position - hrp.Position).Magnitude; local pen = (dist-hd)/dist
        local dmg = 100 * pen
        if dmg > 50 then dmg = 50 + (dmg-50)*0.3 end
        if dmg < (cfg.autoWallMinDamage or 30) then return false, 0 end
        return true, dmg
    end
    return true, 100
end
function Ragebot:GetHitboxPoints(hitboxName, char, count)
    local part = char:FindFirstChild(hitboxName)
    if not part then return {} end
    local pos = part.Position
    if hitboxName == "Head" then
        local sz = part.Size; local r = math_max(sz.X, sz.Z) * 0.4
        local pts = { pos + Vector3_new(0,0.3,0) }
        if count >= 3 then table_insert(pts, pos + Vector3_new(r*0.6, 0.1, r*0.6))
            table_insert(pts, pos + Vector3_new(-r*0.6, 0.1, -r*0.6)) end
        if count >= 5 then table_insert(pts, pos + Vector3_new(r*0.6, -0.1, -r*0.6))
            table_insert(pts, pos + Vector3_new(-r*0.6, -0.1, r*0.6)) end
        if count >= 9 then
            table_insert(pts, pos + Vector3_new(0, -r*0.3, r*0.7))
            table_insert(pts, pos + Vector3_new(0, -r*0.3, -r*0.7))
            table_insert(pts, pos + Vector3_new(r*0.7, -r*0.3, 0))
            table_insert(pts, pos + Vector3_new(-r*0.7, -r*0.3, 0))
        end
        return pts
    elseif hitboxName == "UpperTorso" or hitboxName == "LowerTorso" or hitboxName == "HumanoidRootPart" then
        local sz = part.Size; local hw = sz.X * 0.35; local hh = sz.Z * 0.35
        local pts = { pos }
        if count >= 3 then
            table_insert(pts, pos + Vector3_new(hw, 0, hh))
            table_insert(pts, pos + Vector3_new(-hw, 0, -hh))
        end
        if count >= 5 then
            table_insert(pts, pos + Vector3_new(hw, 0, -hh))
            table_insert(pts, pos + Vector3_new(-hw, 0, hh))
        end
        return pts
    end
    return { pos }
end
function Ragebot:MonteCarloHitChance(target, aimPos)
    local cfg = Config.combat.ragebot
    if not cfg or not cfg.hitChance then return true end
    local reqChance = cfg.hitChance
    local char = target.char; if not char then return true end
    local hrp = target.hrp; if not hrp then return true end
    local weapon = U.GetTool()
    if not weapon then return true end
    local spread = 0.02
    local handle = weapon:FindFirstChild("Handle")
    if handle then
        local spreadVal = handle:FindFirstChild("Spread")
        if spreadVal then spread = spreadVal.Value * 0.001 end
    end
    local dist = U.DistanceFromCamera(aimPos)
    local spreadMultiplier = 1 + dist * 0.0001
    spread = spread * spreadMultiplier
    local samples = 32
    local hits = 0
    local targetParts = {}
    if cfg.multiPoint then
        local mpCount = cfg.multiPointCount or 3
        local hitboxes = {"Head","UpperTorso","LowerTorso","HumanoidRootPart"}
        local vel = hrp.Velocity.Magnitude
        if vel > 30 and cfg.preferHead then hitboxes = {"Head"}
        elseif vel > 30 then hitboxes = {"UpperTorso","LowerTorso","Head","HumanoidRootPart"} end
        for _, hb in ipairs(hitboxes) do
            local pts = self:GetHitboxPoints(hb, char, mpCount)
            for _, pt in ipairs(pts) do table_insert(targetParts, pt) end
        end
        if #targetParts == 0 then table_insert(targetParts, aimPos) end
    else
        table_insert(targetParts, aimPos)
    end
    local dir = (aimPos - Camera.CFrame.Position).Unit
    for i = 1, samples do
        local spreadX = (math_random() - 0.5) * 2 * spread
        local spreadY = (math_random() - 0.5) * 2 * spread
        local rightVec = Camera.CFrame.RightVector
        local upVec = Camera.CFrame.UpVector
        local spreadDir = (dir + rightVec * spreadX + upVec * spreadY).Unit
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = { LocalPlayer.Character }
        params.FilterType = Enum.RaycastFilterType.Blacklist
        local ray = Workspace:Raycast(Camera.CFrame.Position, spreadDir * dist, params)
        if ray then
            local hitChar = ray.Instance and ray.Instance:IsA("BasePart") and ray.Instance:FindFirstAncestorOfClass("Model")
            if hitChar and hitChar:FindFirstChild("Humanoid") then
                for _, pt in ipairs(targetParts) do
                    if (ray.Position - pt).Magnitude < 3 then hits = hits + 1; break end
                end
            end
        end
    end
    local actualChance = (hits / samples) * 100
    if actualChance >= reqChance then return true end
    if cfg.multiPoint and actualChance < reqChance * 0.5 then
        return false
    end
    return actualChance >= reqChance * 0.7
end
function Ragebot:GetTargets()
    local cfg = Config.combat.ragebot; local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        repeat
            if p == LocalPlayer then break end
            if cfg.teamCheck and p.Team == LocalPlayer.Team then break end
            local c = p.Character; if not c or not U.IsAlive(p) then break end
            local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then break end
            local dist = U.DistanceFrom(hrp.Position)
            if dist > (cfg.maxDistance or 2500) then break end
            if cfg.wallCheck then
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = { LocalPlayer.Character, c }
                params.FilterType = Enum.RaycastFilterType.Blacklist
                if Workspace:Raycast(Camera.CFrame.Position, (hrp.Position-Camera.CFrame.Position).Unit*dist, params) then break end
            end
            local hum = c:FindFirstChildOfClass("Humanoid")
            table_insert(targets, { player=p, char=c, hrp=hrp, dist=dist, health=hum and hum.Health or 100 })
        until true
    end
    return targets
end
function Ragebot:SelectTarget(targets)
    if #targets == 0 then return nil end
    local cfg = Config.combat.ragebot
    local sel = cfg.targetSelection or "Closest"
    if sel == "Closest" or sel == "Distance" then table_sort(targets, function(a,b) return a.dist < b.dist end)
    elseif sel == "Health" then table_sort(targets, function(a,b)
        return (a.health or 100) < (b.health or 100)
    end)
    elseif sel == "Crosshair" then
        local lv = Camera.CFrame.LookVector
        table_sort(targets, function(a,b)
            local da = (a.hrp.Position-Camera.CFrame.Position).Unit; local db = (b.hrp.Position-Camera.CFrame.Position).Unit
            return lv:Dot(da) > lv:Dot(db)
        end)
    elseif sel == "Damage" then
        table_sort(targets, function(a,b)
            local dA = U.DistanceFrom(a.hrp.Position); local dB = U.DistanceFrom(b.hrp.Position)
            return (1/dA) * (a.health or 100) > (1/dB) * (b.health or 100)
        end)
    end
    return targets[1]
end
function Ragebot:GetHitboxPosition(target)
    local cfg = Config.combat.ragebot; local char = target.char
    if not char then return target.hrp.Position end
    if self.baimMode or cfg.forceBodyAim then
        local ut = char:FindFirstChild("UpperTorso")
        if ut then return ut.Position + Vector3_new(0,0.5,0) end
        return target.hrp.Position
    end
    local priority = cfg.hitboxPriority or {"Head","UpperTorso","LowerTorso","HumanoidRootPart"}
    local vel = target.hrp.Velocity.Magnitude
    local animState = self:GetAnimState(target.player)
    for _, pn in ipairs(priority) do
        repeat
            if pn == "Head" and vel > 30 and not cfg.preferHead then break end
            if pn == "Head" and animState == "air" and cfg.preferHead then break end
            local part = char:FindFirstChild(pn)
            if part then
                if pn == "Head" then return part.Position + Vector3_new(0,0.3,0)
                elseif pn == "UpperTorso" then return part.Position + Vector3_new(0,0.3,0)
                else return part.Position end
            end
        until true
    end
    return target.hrp.Position
end
function Ragebot:GetPredictedPosition(target, hitboxPos)
    local cfg = Config.combat.ragebot
    local predTime = cfg.prediction or 0.18
    local vel = target.hrp.Velocity
    local dist = U.DistanceFromCamera(hitboxPos)
    local travelTime = dist / 2000
    predTime = math_clamp(predTime + travelTime, 0.05, 0.6)
    if not self.lastTargetVelocities[target.player] then self.lastTargetVelocities[target.player] = {} end
    local velBuf = self.lastTargetVelocities[target.player]
    table_insert(velBuf, vel)
    if #velBuf > 5 then table_remove(velBuf, 1) end
    if cfg.predictionMethod == "Velocity" or not cfg.predictionMethod then
        if vel.Magnitude > 50 then predTime = predTime * (vel.Magnitude/16) end
        return hitboxPos + vel * predTime
    elseif cfg.predictionMethod == "Adaptive" then
        local avgVel = vel
        if #velBuf >= 2 then
            local total = Vector3_new(0,0,0)
            for _, v in ipairs(velBuf) do total = total + v end
            avgVel = total / #velBuf
        end
        local accel = Vector3_new(0,0,0)
        if #velBuf >= 3 then
            local v1 = velBuf[#velBuf]; local v2 = velBuf[#velBuf-2]
            accel = (v1 - v2) * 0.5
        end
        local predicted = hitboxPos + avgVel * predTime + accel * predTime * predTime * 0.5
        return predicted
    else
        local ext = cfg.extrapolationTicks or 3
        local avgVel = vel
        local buf = self.backtrackBuffer[target.player]
        if buf and #buf >= 3 then
            local v1 = buf[#buf].vel; local v2 = buf[math_max(1,#buf-2)].vel
            avgVel = v1 + (v1-v2)*0.5
        end
        return hitboxPos + avgVel * predTime * ext
    end
end
function Ragebot:OnHeartbeat()
    local cfg = Config.combat.ragebot
    if not cfg or not cfg.enabled then return end
    if not self.enabled then return end
    local now = tick()
    if now - self.lastScanTick < self.scanInterval then return end
    self.lastScanTick = now
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then self:RecordBacktrack(p) end
    end
    local targets = self:GetTargets()
    local target = self:SelectTarget(targets)
    if not target then self.currentTarget = nil; return end
    if target.player ~= self.lastTargetPlayer then
        self.lastTargetPlayer = target.player; self.targetLockTime = now
        self.shotsFired = 0; self.baimMode = false
        self.missCounter = 0; self.hitCounter = 0
    end
    if now - self.targetLockTime < self.lockDelay then return end
    self.currentTarget = target.player
    local aimPos = self:GetHitboxPosition(target)
    if cfg.resolver then
        local rp = self:ResolveTarget(target.player)
        if rp then aimPos = rp end
    end
    local wallResult = { hit = true, dmg = 100, wasBacktrack = false }
    if cfg.autoWall then
        local canHit, dmg = self:AutoWall(aimPos, target.player)
        if not canHit then
            local bestBt, bestDmg = nil, 0
            for btOffset = 1, 12 do
                local bt = self:GetBacktrackPos(target.player, btOffset)
                if bt then
                    local bCan, bDmg = self:AutoWall(bt.hrpPos, target.player)
                    if bCan and bDmg > bestDmg then bestDmg = bDmg; bestBt = bt end
                end
            end
            if bestBt then aimPos = bestBt.hrpPos; wallResult.dmg = bestDmg; wallResult.wasBacktrack = true
            else return end
        else wallResult.dmg = dmg end
    end
    aimPos = self:GetPredictedPosition(target, aimPos)
    if cfg.baimAfterShots and cfg.baimAfterShots > 0 and self.shotsFired >= cfg.baimAfterShots then
        self.baimMode = true; aimPos = self:GetHitboxPosition(target)
    end
    local dir = (aimPos - Camera.CFrame.Position).Unit
    Camera.CFrame = CFrame_lookAt(Camera.CFrame.Position, Camera.CFrame.Position + dir)
    if cfg.autoFire then
        local hitChanceOk = true
        if cfg.hitChance and cfg.hitChance > 0 then
            hitChanceOk = self:MonteCarloHitChance(target, aimPos)
        end
        if hitChanceOk and now - self.lastShotTime >= (cfg.minShotInterval or 0.08) then
            U.FireTool(); self.lastShotTime = now; self.shotsFired = self.shotsFired + 1
        end
    end
end
function Ragebot:Destroy()
    if self.conn then self.conn:Disconnect(); self.conn = nil end
    if self.animConn then self.animConn:Disconnect(); self.animConn = nil end
    self.backtrackBuffer = {}; self.currentTarget = nil; self.animStateCache = {}
    self.hitboxCache = {}; self.lastTargetVelocities = {}
end
local Triggerbot = {}
Triggerbot.__index = Triggerbot
function Triggerbot.new()
    return setmetatable({ enabled = false, conn = nil, lastTrigger = 0 }, Triggerbot)
end
function Triggerbot:Set(enabled)
    self.enabled = enabled
    if self.enabled then
        if not self.conn then self.conn = RunService.Heartbeat:Connect(function() self:Update() end) end
    else if self.conn then self.conn:Disconnect(); self.conn = nil end end
end
function Triggerbot:Update()
    local cfg = Config.combat.triggerbot
    if not cfg.enabled then return end
    if not U.IsKeyDown(cfg.key) then return end
    local now = tick()
    if now - self.lastTrigger < (cfg.delay or 0) then return end
    local mp = UserInputService:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        repeat
            if p == LocalPlayer then break end
            if cfg.teamCheck and p.Team == LocalPlayer.Team then break end
            local c = p.Character; if not c or not U.IsAlive(p) then break end
            local ap = c:FindFirstChild(cfg.aimPart or "Head") or c:FindFirstChild("HumanoidRootPart")
            if not ap then break end
            local sp = U.W2S(ap.Position); if not sp then break end
            if cfg.fovCheck and (sp-mp).Magnitude > (cfg.fov or 150) then break end
            if cfg.wallCheck then
                local char = LocalPlayer.Character
                if char then
                    local params = RaycastParams.new()
                    params.FilterDescendantsInstances = { char, c }
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    if Workspace:Raycast(Camera.CFrame.Position, (ap.Position-Camera.CFrame.Position).Unit*1000, params) then break end
                end
            end
            U.FireTool(); self.lastTrigger = now; break
        until true
    end
end
function Triggerbot:Destroy() if self.conn then self.conn:Disconnect(); self.conn = nil end end
local AntiKatana = {}
AntiKatana.__index = AntiKatana
function AntiKatana.new()
    return setmetatable({ enabled = false, conn = nil }, AntiKatana)
end
function AntiKatana:Set(enabled)
    self.enabled = enabled
    if self.enabled then
        if not self.conn then self.conn = RunService.Heartbeat:Connect(function() self:Update() end) end
    else if self.conn then self.conn:Disconnect(); self.conn = nil end end
end
function AntiKatana:Update()
    local cfg = Config.combat.antiKatana
    if not cfg.enabled then return end
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    for _, p in ipairs(Players:GetPlayers()) do
        local pushed = false
        repeat
            if p == LocalPlayer then break end
            local pc = p.Character; if not pc then break end
            local ph = pc:FindFirstChild("HumanoidRootPart"); if not ph then break end
            local dist = (ph.Position - hrp.Position).Magnitude
            if dist < (cfg.pushForce or 15) then
                local pd = (hrp.Position - ph.Position).Unit
                if cfg.predictivePush then
                    local pv = ph.Velocity
                    if pv.Magnitude > 0 then pd = (pd + pv.Unit*0.3).Unit end
                end
                hrp.CFrame = hrp.CFrame + pd * (cfg.pushForce or 15) + Vector3_new(0, cfg.pushHeight or 10, 0)
                pushed = true
            end
        until true
        if pushed then break end
    end
end
function AntiKatana:Destroy() if self.conn then self.conn:Disconnect(); self.conn = nil end end
local Movement = {}
Movement.__index = Movement
function Movement.new()
    return setmetatable({
        enabled = false, conn = nil, flyData = nil, hoverData = nil,
        wallJumpData = { lastJump = 0, cooldown = 0.3, wallDir = nil },
        strafeData = { lastTime = 0, direction = 1, lastKeys = {}, optimalDir = 0 },
        climbData = { active = false, lastCheck = 0, wallNormal = nil },
    }, Movement)
end
function Movement:SetEnabled(enabled)
    self.enabled = enabled
    if self.enabled then
        if not self.conn then self.conn = RunService.Heartbeat:Connect(function() self:OnHeartbeat() end) end
    else if self.conn then self.conn:Disconnect(); self.conn = nil end; self:DisableAll() end
end
function Movement:DisableAll()
    self:StopFly(); self:StopHover(); self:StopClimb()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false; hum.WalkSpeed = 16; hum.JumpPower = 50 end
    end
end
function Movement:SetupFly()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    self:StopFly()
    local bv = Instance_new("BodyVelocity"); bv.Name = "FlyBV"; bv.MaxForce = Vector3_new(math_huge,math_huge,math_huge); bv.P = 10000; bv.Parent = hrp
    local att = Instance_new("Attachment"); att.Name = "FlyAtt"; att.Parent = hrp
    local al = Instance_new("AlignPosition"); al.Name = "FlyAL"; al.Attachment0 = att; al.MaxForce = math_huge; al.MaxVelocity = math_huge; al.Responsiveness = 50; al.Parent = hrp
    local ao = Instance_new("AlignOrientation"); ao.Name = "FlyAO"; ao.Attachment0 = att; ao.RigidityEnabled = true; ao.MaxTorque = math_huge; ao.Parent = hrp
    self.flyData = { bv=bv, att=att, al=al, ao=ao }
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end
end
function Movement:StopFly()
    if self.flyData then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, n in ipairs({"FlyBV","FlyAtt","FlyAL","FlyAO"}) do
                    local c = hrp:FindFirstChild(n); if c then c:Destroy() end
                end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        self.flyData = nil
    end
end
function Movement:FlyUpdate()
    local cfg = Config.movement.fly
    if not cfg.enabled then self:StopFly(); return end
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if not self.flyData then self:SetupFly(); if not self.flyData then return end end
    local speed = cfg.speed or 50; local md = Vector3_new()
    local cf = Camera.CFrame
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then md = md + cf.LookVector*Vector3_new(1,0,1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then md = md - cf.LookVector*Vector3_new(1,0,1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then md = md - cf.RightVector*Vector3_new(1,0,1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then md = md + cf.RightVector*Vector3_new(1,0,1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then md = md + Vector3_new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then md = md - Vector3_new(0,1,0) end
    if md.Magnitude > 0 then md = md.Unit * speed
        local animSpeed = math_clamp(1 - 10/speed, 0.3, 1)
        md = md * animSpeed
    end
    if self.flyData.bv then self.flyData.bv.Velocity = md end
end
function Movement:StopHover()
    if self.hoverData then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bp = hrp:FindFirstChild("HoverBP")
                if bp then bp:Destroy() end
            end
        end
        self.hoverData = nil
    end
end
function Movement:StopClimb()
    if self.climbData and self.climbData.active then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local gv = hrp:FindFirstChild("ClimbGV"); if gv then gv:Destroy() end
                local att = hrp:FindFirstChild("ClimbAtt"); if att then att:Destroy() end
            end
        end
        self.climbData.active = false
    end
end
function Movement:WallJumpCheck(char, hrp, hum)
    local cfg = Config.movement.wallJump
    if not cfg or not cfg.enabled then return end
    local now = tick()
    if now - self.wallJumpData.lastJump < self.wallJumpData.cooldown then return end
    if not hum:GetStateEnabled(Enum.HumanoidStateType.Freefall) and not hum:GetStateEnabled(Enum.HumanoidStateType.Jumping) then return end
    local moveDir = hum.MoveDirection
    if moveDir.Magnitude < 0.1 then return end
    local checkDirs = { Camera.CFrame.RightVector, -Camera.CFrame.RightVector, Camera.CFrame.LookVector*Vector3_new(1,0,1), -Camera.CFrame.LookVector*Vector3_new(1,0,1) }
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = { char }
    params.FilterType = Enum.RaycastFilterType.Blacklist
    for _, dir in ipairs(checkDirs) do
        local ray = Workspace:Raycast(hrp.Position, dir * 4, params)
        if ray and ray.Normal then
            local wallNormal = ray.Normal
            local jumpDir = wallNormal * cfg.pushOut or 15
            jumpDir = jumpDir + Vector3_new(0, cfg.pushUp or 20, 0)
            if moveDir.Magnitude > 0 then jumpDir = jumpDir + moveDir.Unit * (cfg.forwardBoost or 10) end
            hrp.Velocity = jumpDir
            self.wallJumpData.lastJump = now
            if cfg.autoClimb then self:AutoClimb(char, hrp, ray) end
            break
        end
    end
end
function Movement:AutoClimb(char, hrp, wallRay)
    local cfg = Config.movement.climb
    if not cfg or not cfg.enabled then return end
    if self.climbData.active then return end
    local wallNormal = wallRay and wallRay.Normal
    if not wallNormal then return end
    local gv = Instance_new("BodyVelocity"); gv.Name = "ClimbGV"
    gv.MaxForce = Vector3_new(math_huge, 0, math_huge); gv.P = 5000
    gv.Velocity = Vector3_new(0, cfg.climbSpeed or 20, 0); gv.Parent = hrp
    self.climbData.active = true; self.climbData.wallNormal = wallNormal
end
function Movement:StrafeOptimizer(char, hrp, hum)
    local cfg = Config.movement.autoStrafe
    if not cfg or not cfg.enabled then return end
    local now = tick()
    local state = hum:GetState()
    if state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Jumping then
        self.strafeData.lastTime = now; return end
    local moveDir = hum.MoveDirection
    if moveDir.Magnitude < 0.1 then
        local dir = hum.MoveDirection
        if dir.Magnitude < 0.1 then
            local vel = hrp.Velocity * Vector3_new(1,0,1)
            if vel.Magnitude > 5 then
                local accelDir = vel.Unit
                local normal = Vector3_new(-accelDir.Z, 0, accelDir.X)
                local right = Camera.CFrame.RightVector
                local dot = right:Dot(normal)
                local strafeDir = (dot > 0 and 1 or -1)
                hrp.Velocity = hrp.Velocity + normal * (strafeDir * 0.3) + Vector3_new(0, cfg.strafeStrength or 2, 0)
            end
        end
    end
end
function Movement:OnHeartbeat()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local cfg = Config.movement
    if cfg.fly.enabled then self:FlyUpdate() else self:StopFly() end
    if cfg.noclip.enabled then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false
            elseif part:IsA("Model") then
                for _, sub in ipairs(part:GetChildren()) do
                    if sub:IsA("BasePart") then sub.CanCollide = false end
                end
            end
        end
    end
    if cfg.speed.enabled then hum.WalkSpeed = cfg.speed.value or 16 end
    if cfg.jumpPower.enabled then hum.JumpPower = cfg.jumpPower.value or 50; hum.JumpHeight = cfg.jumpPower.value or 50 end
    if cfg.infiniteJump.enabled then
        if hum:GetState() == Enum.HumanoidStateType.Freefall or hum:GetState() == Enum.HumanoidStateType.Running then
            hum.Jump = true
        end
    end
    if cfg.bhop.enabled and hum.MoveDirection.Magnitude > 0 and hum:GetState() == Enum.HumanoidStateType.Running then
        hum.Jump = true
    end
    if cfg.autoStrafe.enabled and hum.MoveDirection.Magnitude > 0 then
        local mv = hum.MoveDirection; local tv = Vector3_new(mv.X*50, hrp.Velocity.Y, mv.Z*50)
        hrp.Velocity = hrp.Velocity:Lerp(tv, 0.3)
    end
    if cfg.edgeJump.enabled and hum.MoveDirection.Magnitude > 0 and not hum:GetStateEnabled(Enum.HumanoidStateType.Climbing) then
        if hum:GetState() == Enum.HumanoidStateType.Running then
            local ahead = hrp.Position + hum.MoveDirection.Unit * (cfg.edgeJump.checkDistance or 2.5)
            local eParams = RaycastParams.new()
            eParams.FilterDescendantsInstances = { char }; eParams.FilterType = Enum.RaycastFilterType.Blacklist
            if not Workspace:Raycast(ahead, Vector3_new(0,-cfg.edgeJump.rayLength or 6,0), eParams) then
                hum.Jump = true
            end
        end
    end
    if cfg.longJump.enabled then
        local key = cfg.longJump.key or Enum.KeyCode.LeftControl
        if U.IsKeyDown(key) then
            local mv = hum.MoveDirection
            if mv.Magnitude > 0 then
                local ljPower = cfg.longJump.power or 100; local ljHeight = cfg.longJump.height or 20
                local ljTarget = Vector3_new(mv.X*ljPower, hrp.Velocity.Y+ljHeight, mv.Z*ljPower)
                hrp.Velocity = hrp.Velocity:Lerp(ljTarget, cfg.longJump.smoothness or 0.5)
            end
        end
    end
    if cfg.hover.enabled then
        local hh = cfg.hover.height or 10
        if not self.hoverData then
            if hrp:FindFirstChild("HoverBP") then hrp:FindFirstChild("HoverBP"):Destroy() end
            local bp = Instance_new("BodyPosition"); bp.Name = "HoverBP"
            bp.MaxForce = Vector3_new(0, math_huge, 0); bp.P = 5000; bp.D = 500
            bp.Position = hrp.Position - Vector3_new(0, hh, 0); bp.Parent = hrp
            self.hoverData = { bp = bp }
        end
        if self.hoverData and self.hoverData.bp then
            local ray = Workspace:Raycast(hrp.Position, Vector3_new(0,-hh*2,0)*2)
            local targetY = ray and ray.Position.Y + hh or hrp.Position.Y
            self.hoverData.bp.Position = Vector3_new(hrp.Position.X, targetY, hrp.Position.Z)
        end
    else self:StopHover() end
    if cfg.airStrafing.enabled and hum.MoveDirection.Magnitude > 0 and hum:GetState() == Enum.HumanoidStateType.Freefall then
        local sp = hrp.Velocity.Magnitude; local d = hum.MoveDirection.Unit * sp
        hrp.Velocity = Vector3_new(d.X, hrp.Velocity.Y, d.Z)
    end
    if cfg.noFallDamage then
        if hum:GetState() == Enum.HumanoidStateType.FallingDown then
            hrp.Velocity = Vector3_new(hrp.Velocity.X, math_min(hrp.Velocity.Y, 0), hrp.Velocity.Z)
        end
    end
    if cfg.noStamina then hum.WalkSpeed = math_max(hum.WalkSpeed, 16) end
    if cfg.wallJump and cfg.wallJump.enabled then self:WallJumpCheck(char, hrp, hum) end
    if cfg.climb and cfg.climb.enabled then
        if self.climbData.active then
            local now = tick()
            if now - self.climbData.lastCheck > 0.1 then
                self.climbData.lastCheck = now
                local ray = Workspace:Raycast(hrp.Position, hrp.CFrame.LookVector*Vector3_new(1,0,1) * 3)
                if not ray then
                    self:StopClimb()
                else
                    local gv = hrp:FindFirstChild("ClimbGV")
                    if gv then
                        local climbSpeed = cfg.climb.climbSpeed or 20
                        local vel = Vector3_new(0, climbSpeed, 0)
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - hrp.CFrame.RightVector * climbSpeed * 0.5 end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + hrp.CFrame.RightVector * climbSpeed * 0.5 end
                        gv.Velocity = vel
                    end
                end
            end
        end
    else self:StopClimb() end
    if cfg.autoFenceJump and cfg.autoFenceJump.enabled then
        if hum.MoveDirection.Magnitude > 0 and hum:GetState() == Enum.HumanoidStateType.Running then
            local ahead2 = hrp.Position + hum.MoveDirection.Unit * 2.5
            local fRay = Workspace:Raycast(Vector3_new(ahead2.X, hrp.Position.Y-1, ahead2.Z), Vector3_new(0, 3, 0))
            if fRay then
                local hitPart = fRay.Instance
                if hitPart and hitPart:IsA("BasePart") and hitPart.CanCollide and (hitPart.Size.Y < 3) then
                    hum.Jump = true
                end
            end
        end
    end
    if cfg.instantRespawn and hum.Health <= 0 then
        local rep = ReplicatedStorage:FindFirstChild("RespawnEvent") or ReplicatedStorage:FindFirstChild("Respawn")
        if rep then pcall(function() rep:FireServer() end) end
    end
end
function Movement:Destroy() self:SetEnabled(false); self:DisableAll() end
local Visuals = {}
Visuals.__index = Visuals
function Visuals.new()
    return setmetatable({
        enabled = false, conn = nil,
        crosshairObjs = {}, fovCircleObj = nil,
        watermarkObj = nil, waterAccentObj = nil,
        hitMarkerObjs = {}, damageIndicators = {},
        pool = {},
    }, Visuals)
end
function Visuals:SetEnabled(enabled)
    self.enabled = enabled
    if self.enabled then
        if not self.conn then
            self.conn = RunService.RenderStepped:Connect(function() self:OnRender() end)
        end
        self:CreateCrosshair()
    else
        if self.conn then self.conn:Disconnect(); self.conn = nil end
        self:DestroyCrosshair()
        if self.fovCircleObj then pcall(function() self.fovCircleObj:Remove() end); self.fovCircleObj = nil end
        if self.watermarkObj then pcall(function() self.watermarkObj:Remove() end); self.watermarkObj = nil end
        if self.waterAccentObj then pcall(function() self.waterAccentObj:Remove() end); self.waterAccentObj = nil end
    end
end
function Visuals:CreateCrosshair()
    local cfg = Config.visuals.crosshair
    if #self.crosshairObjs > 0 then return end
    local gap = cfg.gap or 4; local len = cfg.length or 8; local thick = cfg.thickness or 2
    local color = cfg.color or T(255,255,255)
    local dirs = { Vector2_new(0,-1), Vector2_new(0,1), Vector2_new(-1,0), Vector2_new(1,0) }
    for _, dir in ipairs(dirs) do
        local l = Drawing_newLine(); l.Thickness = thick; l.Color = color; l.Transparency = 1
        table_insert(self.crosshairObjs, { draw=l, dir=dir, gap=gap, len=len, isDot=false, isOutline=false })
        if cfg.outline then
            local ol = Drawing_newLine(); ol.Thickness = thick+2; ol.Color = T(0,0,0); ol.Transparency = 0.5
            table_insert(self.crosshairObjs, { draw=ol, dir=dir, gap=gap-0.5, len=len+1, isDot=false, isOutline=true })
        end
    end
    if cfg.dot then
        local dot = Drawing_newCircle(); dot.Radius = 2; dot.Filled = true; dot.Color = color; dot.Transparency = 1; dot.NumSides = 12
        table_insert(self.crosshairObjs, { draw=dot, isDot=true })
    end
    if cfg.T then
        local tl = Drawing_newLine(); tl.Thickness = thick; tl.Color = color; tl.Transparency = 1
        table_insert(self.crosshairObjs, { draw=tl, dir=Vector2_new(-1,-1), gap=gap, len=len, isT=true })
        local tl2 = Drawing_newLine(); tl2.Thickness = thick; tl2.Color = color; tl2.Transparency = 1
        table_insert(self.crosshairObjs, { draw=tl2, dir=Vector2_new(1,-1), gap=gap, len=len, isT=true })
        local tl3 = Drawing_newLine(); tl3.Thickness = thick; tl3.Color = color; tl3.Transparency = 1
        table_insert(self.crosshairObjs, { draw=tl3, dir=Vector2_new(0,1), gap=gap, len=len*0.7, isT=true })
    end
end
function Visuals:DestroyCrosshair()
    for _, obj in ipairs(self.crosshairObjs) do pcall(function() obj.draw:Remove() end) end
    self.crosshairObjs = {}
end
function Visuals:ShowHitMarker()
    local cfg = Config.visuals.hitMarker
    if not cfg.enabled then return end
    local mp = UserInputService:GetMouseLocation(); local sz = cfg.size or 10
    local entry = { start=tick(), duration=cfg.duration or 0.3, color=cfg.color or T(255,50,50), objs={} }
    if cfg.type == "Cross" then
        local l1 = Drawing_newLine(); l1.Thickness=2; l1.Color=entry.color; l1.Transparency=1
        l1.From=mp-Vector2_new(sz,sz); l1.To=mp+Vector2_new(sz,sz); l1.Visible=true
        local l2 = Drawing_newLine(); l2.Thickness=2; l2.Color=entry.color; l2.Transparency=1
        l2.From=mp+Vector2_new(sz,-sz); l2.To=mp-Vector2_new(sz,-sz); l2.Visible=true
        entry.objs = {l1,l2}
    elseif cfg.type == "Circle" then
        local c = Drawing_newCircle(); c.Radius=sz; c.Filled=false; c.Color=entry.color; c.Thickness=2; c.NumSides=32; c.Position=mp; c.Transparency=1; c.Visible=true
        entry.objs = {c}
    end
    table_insert(self.hitMarkerObjs, entry)
end
function Visuals:ShowDamageIndicator(pos, dmg)
    local cfg = Config.visuals.damageIndicator
    if not cfg.enabled then return end
    local sp = U.W2S(pos); if not sp then return end
    local entry = { start=tick(), duration=cfg.fadeTime or 1.5, pos=sp, text=tostring(math_floor(dmg)), color=cfg.color or T(255,200,50), font=cfg.fontSize or 16, rise=(cfg.riseSpeed or 50), objs={} }
    local t = Drawing_newText(); t.Text=entry.text; t.Size=entry.font; t.Color=entry.color; t.Outline=true; t.Transparency=1; t.Visible=true
    entry.objs = {t}; table_insert(self.damageIndicators, entry)
end
function Visuals:OnRender()
    if not self.enabled then return end
    local cfg = Config.visuals
    if cfg.crosshair.enabled then
        local mp = UserInputService:GetMouseLocation(); local cc = cfg.crosshair
        for _, obj in ipairs(self.crosshairObjs) do
            if obj.isDot then obj.draw.Position = mp; obj.draw.Color = cc.color or T(255,255,255); obj.draw.Visible = true
            elseif obj.isOutline then obj.draw.From = mp+Vector2_new(obj.dir*(obj.gap-0.5)); obj.draw.To = mp+Vector2_new(obj.dir*(obj.gap+obj.len)); obj.draw.Visible = true
            elseif obj.isT then obj.draw.From = mp+Vector2_new(obj.dir*obj.gap); obj.draw.To = mp+Vector2_new(obj.dir*(obj.gap+obj.len)); obj.draw.Color = cc.color or T(255,255,255); obj.draw.Thickness = cc.thickness or 2; obj.draw.Visible = true
            else obj.draw.From = mp+Vector2_new(obj.dir*obj.gap); obj.draw.To = mp+Vector2_new(obj.dir*(obj.gap+obj.len)); obj.draw.Color = cc.color or T(255,255,255); obj.draw.Thickness = cc.thickness or 2; obj.draw.Visible = true end
        end
    else for _, obj in ipairs(self.crosshairObjs) do obj.draw.Visible = false end end
    if cfg.fovCircle and cfg.fovCircle.enabled then
        if not self.fovCircleObj then self.fovCircleObj = Drawing_newCircle(); self.fovCircleObj.NumSides = 64 end
        local mp = UserInputService:GetMouseLocation()
        self.fovCircleObj.Position = mp; self.fovCircleObj.Radius = cfg.fovCircle.radius or 150
        self.fovCircleObj.Color = cfg.fovCircle.color or T(255,255,255)
        self.fovCircleObj.Thickness = cfg.fovCircle.thickness or 1; self.fovCircleObj.Filled = cfg.fovCircle.filled or false
        self.fovCircleObj.Transparency = cfg.fovCircle.transparency or 1; self.fovCircleObj.Visible = true
    elseif self.fovCircleObj then self.fovCircleObj.Visible = false end
    if cfg.fovChanger and cfg.fovChanger.enabled then Camera.FieldOfView = cfg.fovChanger.value or 90 end
    if cfg.noFog then Lighting.FogEnd = 100000 end
    if cfg.noADS then
        if Camera.CameraType == Enum.CameraType.Attach then Camera.CameraType = Enum.CameraType.Custom end
    end
    if cfg.watermark and cfg.watermark.enabled then
        if not self.watermarkObj then
            self.watermarkObj = Drawing_newText(); self.watermarkObj.Size = cfg.watermark.size or 14; self.watermarkObj.Outline = true
            self.waterAccentObj = Drawing_newText(); self.waterAccentObj.Size = (cfg.watermark.size or 14)-2; self.waterAccentObj.Outline = true
        end
        local fps = cfg.watermark.showFPS and (" | " .. U.GetFPS() .. " FPS") or ""
        local time = cfg.watermark.showTime and (" | " .. os.date("%H:%M")) or ""
        local txt = "Arctis v3.0" .. fps .. time
        local pos = cfg.watermark.position or "TopLeft"
        local x, y = 10, 10
        if pos == "TopRight" then x = Camera.ViewportSize.X - #txt*7 - 10
        elseif pos == "BottomLeft" then y = Camera.ViewportSize.Y - 30
        elseif pos == "BottomRight" then x = Camera.ViewportSize.X - #txt*7 - 10; y = Camera.ViewportSize.Y - 30 end
        if cfg.animatedColors and cfg.animatedColors.enabled then
            self.watermarkObj.Color = Color3.fromHSV((tick()*(cfg.animatedColors.speed or 1))%1, 0.8, 1)
        else self.watermarkObj.Color = cfg.watermark.color or T(66,135,245) end
        self.watermarkObj.Text = txt; self.watermarkObj.Position = Vector2_new(x,y); self.watermarkObj.Visible = true
        self.waterAccentObj.Text = "Arctis v3.0"; self.waterAccentObj.Color = T(255,255,255)
        self.waterAccentObj.Position = Vector2_new(x+3,y+2); self.waterAccentObj.Visible = false
    elseif self.watermarkObj then
        self.watermarkObj.Visible = false
        if self.waterAccentObj then self.waterAccentObj.Visible = false end
    end
    local now = tick()
    for i = #self.hitMarkerObjs, 1, -1 do
        local e = self.hitMarkerObjs[i]
        local a = 1 - (now - e.start) / e.duration
        if a <= 0 then
            for _, o in ipairs(e.objs) do pcall(function() o:Remove() end) end
            table_remove(self.hitMarkerObjs, i)
        else
            for _, o in ipairs(e.objs) do pcall(function() o.Transparency = a end) end
        end
    end
    for i = #self.damageIndicators, 1, -1 do
        local e = self.damageIndicators[i]
        local elapsed = now - e.start
        local a = 1 - elapsed / e.duration
        if a <= 0 then
            for _, o in ipairs(e.objs) do pcall(function() o:Remove() end) end
            table_remove(self.damageIndicators, i)
        else
            local cy = e.pos.Y - elapsed * e.rise
            for _, o in ipairs(e.objs) do
                pcall(function() o.Position = Vector2_new(e.pos.X, cy); o.Transparency = a end)
            end
        end
    end
end
function Visuals:Destroy()
    self:SetEnabled(false); self:DestroyCrosshair()
    for _, e in ipairs(self.hitMarkerObjs) do for _, o in ipairs(e.objs) do pcall(function() o:Remove() end) end end
    self.hitMarkerObjs = {}
    for _, e in ipairs(self.damageIndicators) do for _, o in ipairs(e.objs) do pcall(function() o:Remove() end) end end
    self.damageIndicators = {}
end
local Misc = {}
Misc.__index = Misc
function Misc.new()
    return setmetatable({
        conn = nil, chatConn = nil, lastSpam = 0, spamIdx = 1,
        stats = { kills=0, deaths=0, wins=0, losses=0, startTime=tick(), sessionKills=0 },
    }, Misc)
end
function Misc:Start()
    if self.conn then return end
    self.conn = RunService.Heartbeat:Connect(function() self:Update() end)
    if Config.misc.chatSpam.enabled then
        self.chatConn = RunService.Heartbeat:Connect(function() self:ChatSpamUpdate() end)
    end
end
function Misc:ChatSpamUpdate()
    local c = Config.misc.chatSpam
    if not c.enabled then return end
    local now = tick()
    if now - self.lastSpam < (c.interval or 3) then return end
    self.lastSpam = now
    local msg = c.message or "Arctis Hook on top!"
    if c.messages and #c.messages > 0 then
        if c.randomMode then msg = c.messages[math_random(#c.messages)]
        else msg = c.messages[self.spamIdx]; self.spamIdx = (self.spamIdx % #c.messages) + 1 end
    end
    pcall(function()
        local ce = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if ce then
            local sr = ce:FindFirstChild("SayMessageRequest")
            if sr then sr:FireServer(msg) end
        end
    end)
end
function Misc:Update()
    local c = Config.misc
    if c.autoQueue and c.autoQueue.enabled then
        pcall(function()
            for _, v in ipairs(CoreGui:GetDescendants()) do
                if v:IsA("TextButton") and (v.Text:find("Play") or v.Text:find("Queue") or v.Text:find("Join")) then
                    task_spawn(function() v:Click() end); break end
            end
        end)
    end
    if c.autoBan and c.autoBan.enabled then
        pcall(function()
            for _, v in ipairs(CoreGui:GetDescendants()) do
                if v:IsA("TextButton") and (v.Text:find("Ban") or v.Text:find("Vote")) then
                    task_spawn(function() v:Click() end); break end
            end
        end)
    end
    if c.killSay and c.killSay.enabled then end
    if c.autoGG and c.autoGG.enabled then
        pcall(function()
            for _, v in ipairs(CoreGui:GetDescendants()) do
                if v:IsA("Frame") and v.Visible then
                    local t = v:FindFirstChildOfClass("TextLabel")
                    if t and (t.Text:find("Victory") or t.Text:find("Defeat")) then
                        local ce = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                        if ce then
                            local sr = ce:FindFirstChild("SayMessageRequest")
                            if sr then sr:FireServer("gg") end
                        end
                    end
                end
            end
        end)
    end
    if c.nameSpoofer and c.nameSpoofer.enabled and HAS_GETRAWMT then
        pcall(function()
            local mt = getrawmetatable(LocalPlayer)
            if mt then setreadonly(mt, false)
                local oi = mt.__index
                mt.__index = function(t, k)
                    if k == "DisplayName" or k == "Name" then return c.nameSpoofer.name or "Unknown" end
                    return oi and oi(t, k) or t[k]
                end
                setreadonly(mt, true)
            end
        end)
    end
    if c.hackerDetector and c.hackerDetector.enabled then
        for _, p in ipairs(Players:GetPlayers()) do
            repeat
                if p == LocalPlayer then break end
                local char = p.Character; if not char then break end
                local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then break end
                local vel = hrp.Velocity.Magnitude
                if vel > 80 then
                    print("Arctis: [DETECT] " .. p.Name .. " speed hacking (" .. math_floor(vel) .. " studs/s)")
                end
            until true
        end
    end
end
function Misc:Destroy()
    if self.conn then self.conn:Disconnect(); self.conn = nil end
    if self.chatConn then self.chatConn:Disconnect(); self.chatConn = nil end
end
local HitSounds = {}
HitSounds.__index = HitSounds
function HitSounds.new()
    return setmetatable({
        enabled = false, conn = nil, lastHitTime = 0,
    }, HitSounds)
end
function HitSounds:Start()
    -- Hit detection is event-based; no heartbeat needed
end
function HitSounds:PlaySound(soundId, volume)
    volume = volume or 1
    task_spawn(function()
        local s = Instance_new("Sound"); s.SoundId = soundId; s.Volume = volume * (Config.audio.globalVolume or 1); s.Parent = Workspace; s:Play()
        local s2 = s; s.Ended:Connect(function() if s2 and s2.Parent then s2:Destroy() end end)
        task_delay(5, function() if s and s.Parent then s:Destroy() end end)
    end)
end
function HitSounds:PlayHit()
    local c = Config.audio.hitSound
    if c.enabled and HIT_SOUNDS[c.sound] then self:PlaySound(HIT_SOUNDS[c.sound], c.volume or 1) end
end
function HitSounds:PlayKill()
    local c = Config.audio.killSound
    if c.enabled and HIT_SOUNDS[c.sound] then self:PlaySound(HIT_SOUNDS[c.sound], c.volume or 1) end
end
function HitSounds:PlayHeadshot()
    local c = Config.audio.headshotSound
    if c.enabled and HIT_SOUNDS[c.sound] then self:PlaySound(HIT_SOUNDS[c.sound], c.volume or 1) end
end
function HitSounds:Destroy()
    if self.conn then self.conn:Disconnect(); self.conn = nil end
end
local SkinChanger = {}
SkinChanger.__index = SkinChanger
function SkinChanger.new()
    return setmetatable({ enabled = false, originals = {} }, SkinChanger)
end
function SkinChanger:Set(enabled)
    self.enabled = enabled
    if not enabled then self:Restore() end
end
function SkinChanger:Apply()
    if not self.enabled then return end
    local tool = U.GetTool()
    if not tool then return end
    if not self.originals[tool] then
        self.originals[tool] = {
            meshId = tool:FindFirstChild("Handle") and tool.Handle.MeshId,
            textureId = tool:FindFirstChild("Handle") and tool.Handle.TextureID,
            color = tool:FindFirstChild("Handle") and tool.Handle.Color,
        }
    end
end
function SkinChanger:Restore()
    for tool, orig in pairs(self.originals) do
        if tool and tool.Parent then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                if orig.meshId then handle.MeshId = orig.meshId end
                if orig.textureId then handle.TextureID = orig.textureId end
                if orig.color then handle.Color = orig.color end
            end
        end
    end
    self.originals = {}
end
function SkinChanger:UnlockAll()
    pcall(function()
        local ue = ReplicatedStorage:FindFirstChild("UnlockEvent") or ReplicatedStorage:FindFirstChild("PurchaseEvent")
        if ue then ue:FireServer("All") end
    end)
end
function SkinChanger:Destroy() self:Restore() end
local Spoofer = {}
Spoofer.__index = Spoofer
function Spoofer.new()
    return setmetatable({
        enabled = false, hookInstalled = false,
        origPlayerIndex = nil, origNetworkIndex = nil,
    }, Spoofer)
end
function Spoofer:Set(enabled)
    self.enabled = enabled
    if enabled then self:InstallHooks()
    else self:RemoveHooks() end
end
function Spoofer:InstallHooks()
    if self.hookInstalled then return end
    if not HAS_GETRAWMT then return end
    pcall(function()
        local mt = getrawmetatable(LocalPlayer)
        if mt then
            setreadonly(mt, false)
            self.origPlayerIndex = mt.__index
            mt.__index = function(t, k)
                if k == "DisplayName" or k == "Name" then
                    local n = Config.misc.nameSpoofer
                    return n.enabled and n.name ~= "" and n.name or (self.origPlayerIndex and self.origPlayerIndex(t, k) or t[k])
                end
                return self.origPlayerIndex and self.origPlayerIndex(t, k) or t[k]
            end
            setreadonly(mt, true)
        end
    end)
    self.hookInstalled = true
end
function Spoofer:RemoveHooks()
    if not self.hookInstalled then return end
    pcall(function()
        local mt = getrawmetatable(LocalPlayer)
        if mt then
            setreadonly(mt, false)
            mt.__index = self.origPlayerIndex
            setreadonly(mt, true)
        end
    end)
    self.hookInstalled = false
end
function Spoofer:Destroy() self:RemoveHooks() end
local BulletTracers = {}
BulletTracers.__index = BulletTracers
function BulletTracers.new()
    return setmetatable({ enabled = false, conn = nil, tracers = {} }, BulletTracers)
end
function BulletTracers:Set(enabled)
    self.enabled = enabled
    if self.enabled then
        if not self.conn then self.conn = RunService.RenderStepped:Connect(function() self:OnRender() end) end
    else if self.conn then self.conn:Disconnect(); self.conn = nil end; self:Clear() end
end
function BulletTracers:AddTracer(from, to)
    if not self.enabled then return end
    local cfg = Config.visuals.bulletTracers
    local line = Drawing_newLine()
    line.From = from; line.To = to; line.Color = cfg.rainbow and Color3.fromHSV(math_random()%1,0.8,1) or (cfg.color or T(66,135,245))
    line.Thickness = cfg.thickness or 2; line.Transparency = 1; line.Visible = true
    table_insert(self.tracers, { obj=line, start=tick(), lifetime=cfg.lifetime or 0.3 })
end
function BulletTracers:OnRender()
    local now = tick()
    for i = #self.tracers, 1, -1 do
        local t = self.tracers[i]
        local age = now - t.start
        if age > t.lifetime then
            pcall(function() t.obj:Remove() end)
            table_remove(self.tracers, i)
        else
            pcall(function() t.obj.Transparency = 1 - (age / t.lifetime) end)
        end
    end
end
function BulletTracers:Clear()
    for _, t in ipairs(self.tracers) do pcall(function() t.obj:Remove() end) end
    self.tracers = {}
end
function BulletTracers:Destroy() if self.conn then self.conn:Disconnect(); self.conn = nil end; self:Clear() end
local Detectors = {}
Detectors.__index = Detectors
function Detectors.new()
    return setmetatable({
        enabled = false, conn = nil,
        playerData = {},
    }, Detectors)
end
function Detectors:Start()
    if self.conn then return end
    self.enabled = Config.misc.hackerDetector or Config.misc.modDetector or false
    self.conn = RunService.Heartbeat:Connect(function() self:Update() end)
end
function Detectors:Update()
    if not self.enabled or (not Config.misc.hackerDetector and not Config.misc.modDetector) then return end
    for _, p in ipairs(Players:GetPlayers()) do
        repeat
            if p == LocalPlayer then break end
            local char = p.Character; if not char then break end
            local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then break end
            if not self.playerData[p] then
            self.playerData[p] = { lastPos = hrp.Position, lastVel = 0, lastHealth = 100, samples = {} }
        end
        local d = self.playerData[p]
        local vel = hrp.Velocity.Magnitude
        table_insert(d.samples, vel)
        if #d.samples > 10 then table_remove(d.samples, 1) end
        if vel > 70 and Config.misc.hackerDetector then
            print("Arctis: [DETECT] " .. p.Name .. " speed: " .. math_floor(vel))
        end
        local dist = (hrp.Position - d.lastPos).Magnitude
        if dist > 20 and vel < 5 and Config.misc.hackerDetector then
            print("Arctis: [DETECT] " .. p.Name .. " teleport")
        end
        d.lastPos = hrp.Position; d.lastVel = vel
        until true
    end
end
function Detectors:Destroy()
    if self.conn then self.conn:Disconnect(); self.conn = nil end
    self.playerData = {}
end
-- LinoriaLib UI
local repo = 'https://raw.githubusercontent.com/ofugii/Unnamed-Linoria/main/'
local Library, ThemeManager, SaveManager
local loadSuccess, loadErr = pcall(function()
    Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
    ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
    SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
end)
if not loadSuccess then return error("Failed to load LinoriaLib: " .. tostring(loadErr)) end
local Window = Library:CreateWindow({
    Title = 'Unnamed Enhancements',
    Center = true, AutoShow = true, TabPadding = 8, MenuFadeTime = 0.2,
})
local Tabs = {
    Combat = Window:AddTab('Combat'),
    ESP = Window:AddTab('ESP'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Misc = Window:AddTab('Misc'),
    Audio = Window:AddTab('Audio'),
    Skins = Window:AddTab('Skins'),
    Config = Window:AddTab('Config'),
}
local aimbot = Aimbot.new(); aimbot_instance = aimbot
local ragebot = Ragebot.new(); local triggerbot = Triggerbot.new()
local antiKatana = AntiKatana.new(); local movement = Movement.new()
local visualModule = Visuals.new(); local misc = Misc.new()
local hitSounds = HitSounds.new(); local skinChanger = SkinChanger.new()
local spoofer = Spoofer.new(); local bulletTracers = BulletTracers.new()
local detectors = Detectors.new(); local bypass = Bypass.new()
local esp = ESP.new()
local notifications = Notifications.new()
-- Combat Tab
local CombatLeft = Tabs.Combat:AddLeftGroupbox('Aimbot')
local AimbotToggle = CombatLeft:AddToggle('AimbotToggle', { Text = 'Aimbot', Default = Config.combat.aimbot.enabled, Tooltip = 'Toggle aimbot on/off', Callback = function(v) Config.combat.aimbot.enabled = v; aimbot:SetEnabled(v) end })
AimbotToggle:AddKeyPicker('AimbotKey', { Default = 'MB2', SyncToggleState = true, Mode = 'Toggle', Text = 'Aimbot Key' })
CombatLeft:AddDropdown('AimbotMode', { Values = { 'Always', 'Toggle', 'Hold' }, Default = Config.combat.aimbot.mode, Text = 'Aimbot Mode', Callback = function(v) Config.combat.aimbot.mode = v end })
CombatLeft:AddSlider('AimbotSmoothing', { Text = 'Smoothing', Default = Config.combat.aimbot.smoothing, Min = 0, Max = 100, Rounding = 0, Suffix = '%', Callback = function(v) Config.combat.aimbot.smoothing = v end })
CombatLeft:AddSlider('AimbotFOV', { Text = 'FOV', Default = Config.combat.aimbot.fov, Min = 10, Max = 500, Rounding = 0, Suffix = 'px', Callback = function(v) Config.combat.aimbot.fov = v end })
CombatLeft:AddDropdown('AimbotPart', { Values = { 'Head', 'HumanoidRootPart', 'UpperTorso' }, Default = Config.combat.aimbot.aimPart, Text = 'Aim Part', Callback = function(v) Config.combat.aimbot.aimPart = v end })
CombatLeft:AddToggle('AimbotAutoShoot', { Text = 'Auto Shoot', Default = Config.combat.aimbot.autoShoot, Callback = function(v) Config.combat.aimbot.autoShoot = v end })
CombatLeft:AddToggle('AimbotPrediction', { Text = 'Prediction', Default = Config.combat.aimbot.prediction > 0, Callback = function(v) Config.combat.aimbot.prediction = v and 0.15 or 0 end })
CombatLeft:AddToggle('AimbotTeamCheck', { Text = 'Team Check', Default = Config.combat.aimbot.teamCheck, Callback = function(v) Config.combat.aimbot.teamCheck = v end })
CombatLeft:AddToggle('AimbotWallCheck', { Text = 'Wall Check', Default = Config.combat.aimbot.wallCheck, Callback = function(v) Config.combat.aimbot.wallCheck = v end })
CombatLeft:AddToggle('SilentAimToggle', { Text = 'Silent Aim', Default = Config.combat.silentAim.enabled, Callback = function(v) Config.combat.silentAim.enabled = v end })
CombatLeft:AddToggle('ScrollTargets', { Text = 'Scroll Targets', Default = Config.combat.aimbot.scrollTargets, Callback = function(v) Config.combat.aimbot.scrollTargets = v end })
CombatLeft:AddDivider()
CombatLeft:AddLabel('Ragebot')
local RagebotToggle = CombatLeft:AddToggle('RagebotToggle', { Text = 'Ragebot', Default = Config.combat.ragebot.enabled, Callback = function(v) Config.combat.ragebot.enabled = v; ragebot:Set(v) end })
RagebotToggle:AddKeyPicker('RagebotKey', { Default = 'R', SyncToggleState = true, Mode = 'Toggle', Text = 'Ragebot Key' })
CombatLeft:AddSlider('RagebotHitChance', { Text = 'Hit Chance', Default = Config.combat.ragebot.hitChance, Min = 1, Max = 100, Rounding = 0, Suffix = '%', Callback = function(v) Config.combat.ragebot.hitChance = v end })
CombatLeft:AddSlider('RagebotPrediction', { Text = 'Prediction', Default = Config.combat.ragebot.prediction, Min = 0, Max = 1, Rounding = 2, Suffix = 's', Callback = function(v) Config.combat.ragebot.prediction = v end })
CombatLeft:AddSlider('RagebotMaxDist', { Text = 'Max Distance', Default = Config.combat.ragebot.maxDistance, Min = 100, Max = 5000, Rounding = 0, Suffix = 'm', Callback = function(v) Config.combat.ragebot.maxDistance = v end })
CombatLeft:AddDropdown('RagebotTargetSel', { Values = { 'Closest', 'Health', 'Crosshair' }, Default = Config.combat.ragebot.targetSelection, Text = 'Target Selection', Callback = function(v) Config.combat.ragebot.targetSelection = v end })
CombatLeft:AddToggle('RagebotAutoFire', { Text = 'Auto Fire', Default = Config.combat.ragebot.autoFire, Callback = function(v) Config.combat.ragebot.autoFire = v end })
CombatLeft:AddToggle('RagebotResolver', { Text = 'Resolver', Default = Config.combat.ragebot.resolver, Callback = function(v) Config.combat.ragebot.resolver = v end })
CombatLeft:AddToggle('RagebotMultiPoint', { Text = 'Multi-Point', Default = Config.combat.ragebot.multiPoint, Callback = function(v) Config.combat.ragebot.multiPoint = v end })
CombatLeft:AddToggle('RagebotPreferHead', { Text = 'Prefer Head', Default = Config.combat.ragebot.preferHead, Callback = function(v) Config.combat.ragebot.preferHead = v end })
CombatLeft:AddSlider('RagebotBAIM', { Text = 'BAIM After Shots', Default = Config.combat.ragebot.baimAfterShots, Min = 0, Max = 10, Rounding = 0, Callback = function(v) Config.combat.ragebot.baimAfterShots = v end })
CombatLeft:AddToggle('RagebotWallCheck', { Text = 'Wall Check', Default = Config.combat.ragebot.wallCheck, Callback = function(v) Config.combat.ragebot.wallCheck = v end })
CombatLeft:AddToggle('RagebotAutoWall', { Text = 'Auto Wall', Default = Config.combat.ragebot.autoWall, Callback = function(v) Config.combat.ragebot.autoWall = v end })
CombatLeft:AddDivider()
CombatLeft:AddLabel('Other')
CombatLeft:AddToggle('TriggerbotToggle', { Text = 'Triggerbot', Default = Config.combat.triggerbot.enabled, Callback = function(v) Config.combat.triggerbot.enabled = v; triggerbot:Set(v) end })
CombatLeft:AddToggle('AntiKatanaToggle', { Text = 'Anti-Katana', Default = Config.combat.antiKatana.enabled, Callback = function(v) Config.combat.antiKatana.enabled = v; antiKatana:Set(v) end })
CombatLeft:AddToggle('RecoilToggle', { Text = 'Recoil Control', Default = Config.combat.recoilControl.enabled, Callback = function(v) Config.combat.recoilControl.enabled = v end })
CombatLeft:AddSlider('RecoilPitch', { Text = 'Pitch Comp', Default = Config.combat.recoilControl.pitchCompensation, Min = 0, Max = 1, Rounding = 2, Callback = function(v) Config.combat.recoilControl.pitchCompensation = v end })
CombatLeft:AddSlider('RecoilYaw', { Text = 'Yaw Comp', Default = Config.combat.recoilControl.yawCompensation, Min = 0, Max = 1, Rounding = 2, Callback = function(v) Config.combat.recoilControl.yawCompensation = v end })
CombatLeft:AddDivider()
CombatLeft:AddToggle('AutoParryToggle', { Text = 'Auto Parry', Default = Config.combat.autoParry.enabled, Callback = function(v) Config.combat.autoParry.enabled = v end })
CombatLeft:AddSlider('ParryReactionTime', { Text = 'Reaction Time', Default = Config.combat.autoParry.reactionTime, Min = 0, Max = 1, Rounding = 2, Suffix = 's', Callback = function(v) Config.combat.autoParry.reactionTime = v end })
CombatLeft:AddSlider('ParryRange', { Text = 'Parry Range', Default = Config.combat.autoParry.parryRange, Min = 5, Max = 50, Rounding = 0, Suffix = 'm', Callback = function(v) Config.combat.autoParry.parryRange = v end })
-- ESP Tab
local ESPGroup = Tabs.ESP:AddLeftGroupbox('ESP Settings')
ESPGroup:AddToggle('ESPToggle', { Text = 'ESP Enabled', Default = Config.esp.enabled, Callback = function(v) Config.esp.enabled = v; esp:SetEnabled(v) end })
ESPGroup:AddDivider()
ESPGroup:AddLabel('Player ESP')
ESPGroup:AddToggle('ESPBox', { Text = 'Box', Default = Config.esp.box, Callback = function(v) Config.esp.box = v end })
ESPGroup:AddToggle('ESPName', { Text = 'Name', Default = Config.esp.name, Callback = function(v) Config.esp.name = v end })
ESPGroup:AddToggle('ESPHealthBar', { Text = 'Health Bar', Default = Config.esp.healthBar, Callback = function(v) Config.esp.healthBar = v end })
ESPGroup:AddToggle('ESPHealthText', { Text = 'Health Text', Default = Config.esp.healthText, Callback = function(v) Config.esp.healthText = v end })
ESPGroup:AddToggle('ESPDistance', { Text = 'Distance', Default = Config.esp.distance, Callback = function(v) Config.esp.distance = v end })
ESPGroup:AddToggle('ESPWeapon', { Text = 'Weapon', Default = Config.esp.weapon, Callback = function(v) Config.esp.weapon = v end })
ESPGroup:AddToggle('ESPTracers', { Text = 'Tracers', Default = Config.esp.tracer, Callback = function(v) Config.esp.tracer = v end })
ESPGroup:AddToggle('ESPSkeleton', { Text = 'Skeleton', Default = Config.esp.skeleton, Callback = function(v) Config.esp.skeleton = v end })
ESPGroup:AddToggle('ESPHeadDot', { Text = 'Head Dot', Default = Config.esp.headDot, Callback = function(v) Config.esp.headDot = v end })
ESPGroup:AddToggle('ESPOffscreen', { Text = 'Offscreen', Default = Config.esp.offscreen, Callback = function(v) Config.esp.offscreen = v end })
ESPGroup:AddDropdown('ESPTracerOrigin', { Values = { 'Bottom', 'Top', 'Crosshair' }, Default = Config.esp.tracerOrigin, Text = 'Tracer Origin', Callback = function(v) Config.esp.tracerOrigin = v end })
ESPGroup:AddSlider('ESPMaxDist', { Text = 'Max Distance', Default = Config.esp.maxDistance, Min = 100, Max = 5000, Rounding = 0, Suffix = 'm', Callback = function(v) Config.esp.maxDistance = v end })
ESPGroup:AddToggle('ESPTeamCheck', { Text = 'Team Check', Default = Config.esp.teamCheck, Callback = function(v) Config.esp.teamCheck = v end })
ESPGroup:AddToggle('ESPVIsibleOnly', { Text = 'Visible Only', Default = Config.esp.visibleOnly, Callback = function(v) Config.esp.visibleOnly = v end })
-- ESP Right
local ESPRight = Tabs.ESP:AddRightGroupbox('Colors')
ESPRight:AddColorPicker('ESPBoxColor', { Text = 'Box Color', Default = Config.esp.boxColor or Color3.fromRGB(255,255,255), Callback = function(v) Config.esp.boxColor = v end })
ESPRight:AddColorPicker('ESPTracerColor', { Text = 'Tracer Color', Default = Config.esp.tracerColor or Color3.fromRGB(255,255,255), Callback = function(v) Config.esp.tracerColor = v end })
ESPRight:AddColorPicker('ESPSkeletonColor', { Text = 'Skeleton Color', Default = Config.esp.skeletonColor, Callback = function(v) Config.esp.skeletonColor = v end })
ESPRight:AddColorPicker('ESPHeadDotColor', { Text = 'Head Dot Color', Default = Config.esp.headDotColor, Callback = function(v) Config.esp.headDotColor = v end })
ESPRight:AddColorPicker('ESPOffscreenColor', { Text = 'Offscreen Color', Default = Config.esp.offscreenColor, Callback = function(v) Config.esp.offscreenColor = v end })
-- Visuals Tab
local VisGroup = Tabs.Visuals:AddLeftGroupbox('Crosshair')
VisGroup:AddToggle('CrosshairToggle', { Text = 'Crosshair', Default = Config.visuals.crosshair.enabled, Callback = function(v) Config.visuals.crosshair.enabled = v; visualModule:SetEnabled(true) end })
VisGroup:AddSlider('CrosshairGap', { Text = 'Gap', Default = Config.visuals.crosshair.gap, Min = 0, Max = 20, Rounding = 0, Suffix = 'px', Callback = function(v) Config.visuals.crosshair.gap = v end })
VisGroup:AddSlider('CrosshairLength', { Text = 'Length', Default = Config.visuals.crosshair.length, Min = 2, Max = 30, Rounding = 0, Suffix = 'px', Callback = function(v) Config.visuals.crosshair.length = v end })
VisGroup:AddSlider('CrosshairThickness', { Text = 'Thickness', Default = Config.visuals.crosshair.thickness, Min = 1, Max = 6, Rounding = 0, Suffix = 'px', Callback = function(v) Config.visuals.crosshair.thickness = v end })
VisGroup:AddToggle('CrosshairDot', { Text = 'Dot', Default = Config.visuals.crosshair.dot, Callback = function(v) Config.visuals.crosshair.dot = v; visualModule:SetEnabled(true) end })
VisGroup:AddToggle('CrosshairOutline', { Text = 'Outline', Default = Config.visuals.crosshair.outline, Callback = function(v) Config.visuals.crosshair.outline = v; visualModule:SetEnabled(true) end })
VisGroup:AddDivider()
VisGroup:AddLabel('World')
VisGroup:AddToggle('FOVCircleToggle', { Text = 'FOV Circle', Default = Config.visuals.fovCircle.enabled, Callback = function(v) Config.visuals.fovCircle.enabled = v end })
VisGroup:AddSlider('FOVChanger', { Text = 'FOV Changer', Default = Config.visuals.fovChanger.value, Min = 30, Max = 120, Rounding = 0, Suffix = 'deg', Callback = function(v) Config.visuals.fovChanger.value = v; Config.visuals.fovChanger.enabled = true end })
VisGroup:AddToggle('NoFog', { Text = 'No Fog', Default = Config.visuals.noFog, Callback = function(v) Config.visuals.noFog = v end })
VisGroup:AddToggle('NoADS', { Text = 'No ADS', Default = Config.visuals.noADS, Callback = function(v) Config.visuals.noADS = v end })
VisGroup:AddToggle('AnimatedColors', { Text = 'Animated Colors', Default = Config.visuals.animatedColors.enabled, Callback = function(v) Config.visuals.animatedColors.enabled = v end })
VisGroup:AddToggle('BulletTracers', { Text = 'Bullet Tracers', Default = Config.visuals.bulletTracers.enabled, Callback = function(v) Config.visuals.bulletTracers.enabled = v; bulletTracers:Set(v) end })
VisGroup:AddToggle('HitMarker', { Text = 'Hit Marker', Default = Config.visuals.hitMarker.enabled, Callback = function(v) Config.visuals.hitMarker.enabled = v end })
VisGroup:AddToggle('DamageIndicator', { Text = 'Damage Indicator', Default = Config.visuals.damageIndicator.enabled, Callback = function(v) Config.visuals.damageIndicator.enabled = v end })
VisGroup:AddToggle('WatermarkToggle', { Text = 'Watermark', Default = Config.visuals.watermark.enabled, Callback = function(v) Config.visuals.watermark.enabled = v end })
VisGroup:AddDropdown('WatermarkPosition', { Values = { 'TopLeft', 'TopRight', 'BottomLeft', 'BottomRight' }, Default = Config.visuals.watermark.position, Text = 'Watermark Pos', Callback = function(v) Config.visuals.watermark.position = v end })
VisGroup:AddDivider()
VisGroup:AddLabel('Misc')
VisGroup:AddToggle('NoScopeToggle', { Text = 'No Scope', Default = Config.visuals.noScope, Callback = function(v) Config.visuals.noScope = v end })
VisGroup:AddToggle('NoGrassToggle', { Text = 'No Grass', Default = Config.visuals.noGrass, Callback = function(v) Config.visuals.noGrass = v end })
VisGroup:AddToggle('NoEffectsToggle', { Text = 'No Effects', Default = Config.visuals.noEffects, Callback = function(v) Config.visuals.noEffects = v end })
-- Visuals Right
local VisRight = Tabs.Visuals:AddRightGroupbox('FOV Circle')
VisRight:AddSlider('FOVCircleRadius', { Text = 'Radius', Default = Config.visuals.fovCircle.radius, Min = 10, Max = 500, Rounding = 0, Suffix = 'px', Callback = function(v) Config.visuals.fovCircle.radius = v end })
VisRight:AddSlider('FOVCircleThickness', { Text = 'Thickness', Default = Config.visuals.fovCircle.thickness, Min = 1, Max = 10, Rounding = 0, Suffix = 'px', Callback = function(v) Config.visuals.fovCircle.thickness = v end })
VisRight:AddToggle('FOVCircleFilled', { Text = 'Filled', Default = Config.visuals.fovCircle.filled, Callback = function(v) Config.visuals.fovCircle.filled = v end })
VisRight:AddDivider()
VisRight:AddLabel('Bullet Tracers')
VisRight:AddColorPicker('BTColor', { Text = 'Tracer Color', Default = Config.visuals.bulletTracers.color, Callback = function(v) Config.visuals.bulletTracers.color = v end })
VisRight:AddToggle('BTRainbow', { Text = 'Rainbow', Default = Config.visuals.bulletTracers.rainbow, Callback = function(v) Config.visuals.bulletTracers.rainbow = v end })
VisRight:AddDivider()
VisRight:AddLabel('Hit Marker')
VisRight:AddDropdown('HMType', { Values = { 'Cross', 'Circle' }, Default = Config.visuals.hitMarker.type, Text = 'Type', Callback = function(v) Config.visuals.hitMarker.type = v end })
VisRight:AddColorPicker('HMColor', { Text = 'Color', Default = Config.visuals.hitMarker.color, Callback = function(v) Config.visuals.hitMarker.color = v end })
VisRight:AddDivider()
VisRight:AddLabel('Damage Indicator')
VisRight:AddColorPicker('DIColor', { Text = 'Dmg Color', Default = Config.visuals.damageIndicator.color, Callback = function(v) Config.visuals.damageIndicator.color = v end })
VisRight:AddSlider('DIRiseSpeed', { Text = 'Rise Speed', Default = Config.visuals.damageIndicator.riseSpeed, Min = 10, Max = 200, Rounding = 0, Suffix = '', Callback = function(v) Config.visuals.damageIndicator.riseSpeed = v end })
VisRight:AddSlider('DIFadeTime', { Text = 'Fade Time', Default = Config.visuals.damageIndicator.fadeTime, Min = 0.1, Max = 5, Rounding = 1, Suffix = 's', Callback = function(v) Config.visuals.damageIndicator.fadeTime = v end })
-- Movement Tab
local MoveGroup = Tabs.Movement:AddLeftGroupbox('Movement')
local FlyToggle = MoveGroup:AddToggle('FlyToggle', { Text = 'Fly', Default = Config.movement.fly.enabled, Callback = function(v) Config.movement.fly.enabled = v; movement:SetEnabled(true) end })
FlyToggle:AddKeyPicker('FlyKey', { Default = 'G', SyncToggleState = true, Mode = 'Toggle', Text = 'Fly Key' })
MoveGroup:AddSlider('FlySpeed', { Text = 'Fly Speed', Default = Config.movement.fly.speed, Min = 10, Max = 200, Rounding = 0, Callback = function(v) Config.movement.fly.speed = v end })
local NoclipToggle = MoveGroup:AddToggle('NoclipToggle', { Text = 'Noclip', Default = Config.movement.noclip.enabled, Callback = function(v) Config.movement.noclip.enabled = v; movement:SetEnabled(true) end })
NoclipToggle:AddKeyPicker('NoclipKey', { Default = 'N', SyncToggleState = true, Mode = 'Toggle', Text = 'Noclip Key' })
MoveGroup:AddToggle('SpeedToggle', { Text = 'Speed', Default = Config.movement.speed.enabled, Callback = function(v) Config.movement.speed.enabled = v; movement:SetEnabled(true) end })
MoveGroup:AddSlider('WalkSpeed', { Text = 'WalkSpeed', Default = Config.movement.speed.value, Min = 16, Max = 200, Rounding = 0, Callback = function(v) Config.movement.speed.value = v end })
MoveGroup:AddToggle('JumpPowerToggle', { Text = 'Jump Power', Default = Config.movement.jumpPower.enabled, Callback = function(v) Config.movement.jumpPower.enabled = v; movement:SetEnabled(true) end })
MoveGroup:AddSlider('JumpHeight', { Text = 'Jump Height', Default = Config.movement.jumpPower.value, Min = 50, Max = 300, Rounding = 0, Callback = function(v) Config.movement.jumpPower.value = v end })
MoveGroup:AddDivider()
local BHopToggle = MoveGroup:AddToggle('BHopToggle', { Text = 'Bunny Hop', Default = Config.movement.bhop.enabled, Callback = function(v) Config.movement.bhop.enabled = v end })
BHopToggle:AddKeyPicker('BHopKey', { Default = 'Space', SyncToggleState = true, Mode = 'Toggle', Text = 'BHop Key' })
local AutoStrafeToggle = MoveGroup:AddToggle('AutoStrafeToggle', { Text = 'Auto Strafe', Default = Config.movement.autoStrafe.enabled, Callback = function(v) Config.movement.autoStrafe.enabled = v end })
AutoStrafeToggle:AddKeyPicker('AutoStrafeKey', { Default = 'Z', SyncToggleState = true, Mode = 'Toggle', Text = 'Strafe Key' })
local InfiniteJumpToggle = MoveGroup:AddToggle('InfiniteJumpToggle', { Text = 'Infinite Jump', Default = Config.movement.infiniteJump.enabled, Callback = function(v) Config.movement.infiniteJump.enabled = v end })
InfiniteJumpToggle:AddKeyPicker('InfiniteJumpKey', { Default = 'Space', SyncToggleState = true, Mode = 'Toggle', Text = 'Inf Jump Key' })
MoveGroup:AddToggle('EdgeJumpToggle', { Text = 'Edge Jump', Default = Config.movement.edgeJump.enabled, Callback = function(v) Config.movement.edgeJump.enabled = v end })
local LongJumpToggle = MoveGroup:AddToggle('LongJumpToggle', { Text = 'Long Jump', Default = Config.movement.longJump.enabled, Callback = function(v) Config.movement.longJump.enabled = v end })
LongJumpToggle:AddKeyPicker('LongJumpKey', { Default = 'LeftControl', SyncToggleState = true, Mode = 'Toggle', Text = 'LJ Key' })
local HoverToggle = MoveGroup:AddToggle('HoverToggle', { Text = 'Hover', Default = Config.movement.hover.enabled, Callback = function(v) Config.movement.hover.enabled = v; movement:SetEnabled(true) end })
HoverToggle:AddKeyPicker('HoverKey', { Default = 'V', SyncToggleState = true, Mode = 'Toggle', Text = 'Hover Key' })
MoveGroup:AddToggle('AirStrafeToggle', { Text = 'Air Strafe', Default = Config.movement.airStrafing.enabled, Callback = function(v) Config.movement.airStrafing.enabled = v end })
MoveGroup:AddToggle('NoFallDamage', { Text = 'No Fall Damage', Default = Config.movement.noFallDamage, Callback = function(v) Config.movement.noFallDamage = v end })
MoveGroup:AddToggle('InstantRespawn', { Text = 'Instant Respawn', Default = Config.movement.instantRespawn, Callback = function(v) Config.movement.instantRespawn = v end })
MoveGroup:AddDivider()
MoveGroup:AddLabel('Advanced')
MoveGroup:AddToggle('WallJumpToggle', { Text = 'Wall Jump', Default = Config.movement.wallJump.enabled, Callback = function(v) Config.movement.wallJump.enabled = v end })
MoveGroup:AddToggle('AutoClimbToggle', { Text = 'Auto Climb', Default = Config.movement.climb.enabled, Callback = function(v) Config.movement.climb.enabled = v end })
MoveGroup:AddSlider('ClimbSpeed', { Text = 'Climb Speed', Default = Config.movement.climb.climbSpeed, Min = 5, Max = 50, Rounding = 0, Callback = function(v) Config.movement.climb.climbSpeed = v end })
MoveGroup:AddToggle('FenceJumpToggle', { Text = 'Fence Jump', Default = Config.movement.autoFenceJump.enabled, Callback = function(v) Config.movement.autoFenceJump.enabled = v end })
-- Misc Tab
local MiscGroup = Tabs.Misc:AddLeftGroupbox('Miscellaneous')
MiscGroup:AddToggle('AutoQueueToggle', { Text = 'Auto Queue', Default = Config.misc.autoQueue.enabled, Callback = function(v) Config.misc.autoQueue.enabled = v end })
MiscGroup:AddToggle('AutoLoadoutToggle', { Text = 'Auto Loadout', Default = Config.misc.autoLoadout.enabled, Callback = function(v) Config.misc.autoLoadout.enabled = v end })
MiscGroup:AddToggle('NameSpooferToggle', { Text = 'Name Spoofer', Default = Config.misc.nameSpoofer.enabled, Callback = function(v) Config.misc.nameSpoofer.enabled = v end })
MiscGroup:AddInput('SpoofedName', { Default = Config.misc.nameSpoofer.name, Text = 'Spoofed Name', Placeholder = 'Enter name', Finished = true, Callback = function(v) Config.misc.nameSpoofer.name = v end })
MiscGroup:AddToggle('ChatSpamToggle', { Text = 'Chat Spam', Default = Config.misc.chatSpam.enabled, Callback = function(v) Config.misc.chatSpam.enabled = v end })
MiscGroup:AddInput('SpamMessage', { Default = Config.misc.chatSpam.message, Text = 'Spam Message', Placeholder = 'Enter message', Callback = function(v) Config.misc.chatSpam.message = v end })
MiscGroup:AddToggle('HackerDetectorToggle', { Text = 'Hacker Detector', Default = Config.misc.hackerDetector.enabled, Callback = function(v) Config.misc.hackerDetector.enabled = v end })
MiscGroup:AddToggle('KillSayToggle', { Text = 'Kill Say', Default = Config.misc.killSay.enabled, Callback = function(v) Config.misc.killSay.enabled = v end })
MiscGroup:AddToggle('AutoGGToggle', { Text = 'Auto GG', Default = Config.misc.autoGG.enabled, Callback = function(v) Config.misc.autoGG.enabled = v end })
MiscGroup:AddDivider()
MiscGroup:AddLabel('Info')
MiscGroup:AddToggle('SpectatorListToggle', { Text = 'Spectator List', Default = Config.visuals.spectatorList.enabled, Callback = function(v) Config.visuals.spectatorList.enabled = v end })
MiscGroup:AddToggle('SessionStatsToggle', { Text = 'Session Stats', Default = Config.misc.sessionStats.enabled, Callback = function(v) Config.misc.sessionStats.enabled = v end })
MiscGroup:AddToggle('PingDisplayToggle', { Text = 'Ping Display', Default = Config.misc.pingDisplay.enabled, Callback = function(v) Config.misc.pingDisplay.enabled = v end })
MiscGroup:AddToggle('ClockDisplayToggle', { Text = 'Clock Display', Default = Config.misc.clockDisplay.enabled, Callback = function(v) Config.misc.clockDisplay.enabled = v end })
MiscGroup:AddToggle('ModDetectorToggle', { Text = 'Mod Detector', Default = Config.misc.modDetector.enabled, Callback = function(v) Config.misc.modDetector.enabled = v end })
-- Audio Tab
local AudioGroup = Tabs.Audio:AddLeftGroupbox('Hit Sounds')
AudioGroup:AddToggle('HitSoundToggle', { Text = 'Hit Sound', Default = Config.audio.hitSound.enabled, Callback = function(v) Config.audio.hitSound.enabled = v end })
AudioGroup:AddDropdown('HitSoundType', { Values = { 'AmongUs','MLG','Ding','Bruh','Bone','Click','Coin','Echo','Metal','Ping','Pop','Punch','Sword','Bell' }, Default = Config.audio.hitSound.sound, Text = 'Hit Sound Type', Callback = function(v) Config.audio.hitSound.sound = v end })
AudioGroup:AddSlider('HitSoundVolume', { Text = 'Hit Volume', Default = Config.audio.hitSound.volume, Min = 0, Max = 2, Rounding = 1, Suffix = 'x', Callback = function(v) Config.audio.hitSound.volume = v end })
AudioGroup:AddToggle('KillSoundToggle', { Text = 'Kill Sound', Default = Config.audio.killSound.enabled, Callback = function(v) Config.audio.killSound.enabled = v end })
AudioGroup:AddDropdown('KillSoundType', { Values = { 'AmongUs','MLG','Ding','Bruh','Bone','Click','Coin','Echo','Metal','Ping','Pop','Punch','Sword','Bell' }, Default = Config.audio.killSound.sound, Text = 'Kill Sound Type', Callback = function(v) Config.audio.killSound.sound = v end })
AudioGroup:AddSlider('KillSoundVolume', { Text = 'Kill Volume', Default = Config.audio.killSound.volume, Min = 0, Max = 2, Rounding = 1, Suffix = 'x', Callback = function(v) Config.audio.killSound.volume = v end })
AudioGroup:AddDivider()
AudioGroup:AddLabel('Headshot')
AudioGroup:AddToggle('HeadshotSoundToggle', { Text = 'Headshot Sound', Default = Config.audio.headshotSound.enabled, Callback = function(v) Config.audio.headshotSound.enabled = v end })
AudioGroup:AddDropdown('HeadshotSoundType', { Values = { 'AmongUs','MLG','Ding','Bruh','Bone','Click','Coin','Echo','Metal','Ping','Pop','Punch','Sword','Bell' }, Default = Config.audio.headshotSound.sound, Text = 'Headshot Type', Callback = function(v) Config.audio.headshotSound.sound = v end })
AudioGroup:AddSlider('HeadshotVolume', { Text = 'HS Volume', Default = Config.audio.headshotSound.volume, Min = 0, Max = 2, Rounding = 1, Suffix = 'x', Callback = function(v) Config.audio.headshotSound.volume = v end })
AudioGroup:AddDivider()
AudioGroup:AddLabel('Global')
AudioGroup:AddSlider('GlobalVolume', { Text = 'Global Volume', Default = Config.audio.globalVolume, Min = 0, Max = 2, Rounding = 1, Suffix = 'x', Callback = function(v) Config.audio.globalVolume = v end })
-- Skins Tab
local SkinGroup = Tabs.Skins:AddLeftGroupbox('Cosmetics')
SkinGroup:AddToggle('SkinChangerToggle', { Text = 'Skin Changer', Default = Config.cosmetics.skinChanger.enabled, Callback = function(v) Config.cosmetics.skinChanger.enabled = v; skinChanger:Set(v) end })
SkinGroup:AddButton({ Text = 'Unlock All', Func = function() pcall(function() skinChanger:UnlockAll(); notifications:SendSuccess('Cosmetics','Unlocked all skins!') end) end, Tooltip = 'Unlock all cosmetic items' })
-- Config Tab
local ConfigGroup = Tabs.Config:AddLeftGroupbox('Menu')
ConfigGroup:AddLabel('Menu Keybind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu Keybind' })
ConfigGroup:AddButton({ Text = 'Unload Script', Func = function() Library:Unload() end, Tooltip = 'Unload the script' })
-- Module init
bypass:Start()
esp:SetEnabled(false)
visualModule:SetEnabled(true)
misc:Start()
hitSounds:Start()
detectors:Start()
bulletTracers:Set(true)
spoofer:Set(true)
-- Watermark
local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
local WatermarkConnection = RunService.RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter; FrameTimer = tick(); FrameCounter = 0
    end
    Library:SetWatermark(('Unnamed Enhancements | %s fps | %s ms'):format(math.floor(FPS), math.floor(StatsService.Network.ServerStatsItem['Data Ping']:GetValue())))
end)
Library.KeybindFrame.Visible = true
Library:SetWatermarkVisibility(true)
Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    if esp then esp:Destroy() end
    if aimbot then aimbot:Destroy() end
    if ragebot then ragebot:Destroy() end
    if triggerbot then triggerbot:Destroy() end
    if antiKatana then antiKatana:Destroy() end
    if movement then movement:Destroy() end
    if visualModule then visualModule:Destroy() end
    if misc then misc:Destroy() end
    if hitSounds then hitSounds:Destroy() end
    if skinChanger then skinChanger:Destroy() end
    if spoofer then spoofer:Destroy() end
    if bulletTracers then bulletTracers:Destroy() end
    if detectors then detectors:Destroy() end
    if bypass then bypass:Destroy() end
    if notifications then notifications:Destroy() end
    Library.Unloaded = true
end)
-- ThemeManager + SaveManager
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('UnnamedEnhancements')
SaveManager:SetFolder('UnnamedEnhancements/Config')
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
pcall(function() Library.ToggleKeybind = Options.MenuKeybind end)
notifications:SendInfo('Unnamed Enhancements', 'Loaded | RightShift to toggle | 10+ themes')
_G.UnnamedEnhancements = { Unload = function() Library:Unload() end, Config = Config, Version = '1.0.0' }


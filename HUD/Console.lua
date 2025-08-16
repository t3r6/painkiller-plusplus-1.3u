Console = {}

function Console:Cmd_SHOWWEAPON(enable)
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("showweapon 0/1  (disables/enables weapon rendering)")
    end
    if enable == 1 then
        Cfg.ViewWeaponModel = true
    end
    if enable == 0 then
        Cfg.ViewWeaponModel = false
    end
end

function Console:Cmd_WHERE()
    local me = 0
    for i, ps in Game.PlayerStats, nil do
        if Player == Game:FindPlayerByClientID(ps.ClientID) then
            me = ps.ClientID
        end
    end
    if Game.PlayerStats[me] and Game.PlayerStats[me]._Entity and Game.PlayerStats[me]._Entity ~= 0 then
        local x, y, z = ENTITY.PO_GetPawnHeadPos(Game.PlayerStats[me]._Entity)
        CONSOLE_AddMessage(x .. ", " .. y .. ", " .. z)
    end
end

function Console:Cmd_ADDLOC(location, l1, l2, l3, l4, l5)
    if location == nil then
        CONSOLE_AddMessage("Usage \addloc <location>")
        return
    end
    if l1 ~= nil then
        location = location .. " " .. l1
    end
    if l2 ~= nil then
        location = location .. " " .. l2
    end
    if l3 ~= nil then
        location = location .. " " .. l3
    end
    if l4 ~= nil then
        location = location .. " " .. l4
    end
    if l5 ~= nil then
        location = location .. " " .. l5
    end
    local me = -99
    for i, ps in Game.PlayerStats, nil do
        if Player == Game:FindPlayerByClientID(ps.ClientID) then
            me = ps.ClientID
        end
    end
    if me == -99 then
        return
    end
    local x = 0
    local y = 0
    local z = 0
    if Game.PlayerStats[me] and Game.PlayerStats[me]._Entity and Game.PlayerStats[me]._Entity ~= 0 then
        x, y, z = ENTITY.PO_GetPawnHeadPos(Game.PlayerStats[me]._Entity)
    end
    local locfile = "../Data/Locs/"
    local mapname = Lev.Map
    if mapname == nil then
        return
    end
    locfile = locfile .. string.gsub(mapname, "(%a+).mpk", "%1") .. ".loc"
    local file = io.open(locfile, "a")
    if not file then
        return
    end
    local txt = location .. "," .. x .. "," .. y .. "," .. z .. "\n"
    file:write(txt)
    CONSOLE_AddMessage("Added Location.")
    io.close(file)
    Loc.Position = {}
    Loc:Load(mapname)
end

function Console:Cmd_ADDWAYPOINT(location, l1, l2, l3, l4, l5)
    if location == nil then
        location = "Waypoint"
    end
    if l1 ~= nil then
        location = location .. " " .. l1
    end
    if l2 ~= nil then
        location = location .. " " .. l2
    end
    if l3 ~= nil then
        location = location .. " " .. l3
    end
    if l4 ~= nil then
        location = location .. " " .. l4
    end
    if l5 ~= nil then
        location = location .. " " .. l5
    end
    local me = -99
    for i, ps in Game.PlayerStats, nil do
        if Player == Game:FindPlayerByClientID(ps.ClientID) then
            me = ps.ClientID
        end
    end
    if me == -99 then
        return
    end
    local x = 0
    local y = 0
    local z = 0
    if Game.PlayerStats[me] and Game.PlayerStats[me]._Entity and Game.PlayerStats[me]._Entity ~= 0 then
        x, y, z = ENTITY.PO_GetPawnHeadPos(Game.PlayerStats[me]._Entity)
    end
    location = Game:GetLocationByPosition(x, y, z)
    local Waypointfile = "../Data/Waypoints/"
    local mapname = Lev.Map
    if mapname == nil then
        return
    end
    Waypointfile = Waypointfile .. string.gsub(mapname, "(%a+).mpk", "%1") .. ".bwp"
    local file = io.open(Waypointfile, "a")
    if not file then
        return
    end
    local txt = location .. "," .. x .. "," .. y .. "," .. z .. "\n"
    file:write(txt)
    CONSOLE_AddMessage("Added Location.")
    io.close(file)
    Waypoint.Position = {}
    Waypoint:Load(mapname)
end

function Console:Cmd_PRINT(txt)
    CONSOLE_AddMessage(txt)
end

function Console:Cmd_PLAYERSPLAYERSTATS()
    CONSOLE_AddMessage("ID\tx y z")
    for i, ps in Game.PlayerStats, nil do
        if ps.Player == nil then
            CONSOLE_AddMessage(ps.ClientID .. "   " .. "NIL CPlayer object")
        else
            CONSOLE_AddMessage(
                ps.ClientID ..
                    "   " ..
                        tostring(ps.Player.Pos.X) ..
                            "   " .. tostring(ps.Player.Pos.Y) .. "   " .. tostring(ps.Player.Pos.Z)
            )
        end
    end
end

function Console:Cmd_ENTITYPLAYERSTATS()
    CONSOLE_AddMessage("ID\tx y z")
    for i, ps in Game.PlayerStats, nil do
        local px, py, pz = ENTITY.GetPosition(ps._Entity)
        CONSOLE_AddMessage(ps.ClientID .. "   " .. tostring(px) .. "   " .. tostring(py) .. "   " .. tostring(pz))
    end
end

function Console:Cmd_ENTITYPLAYER()
    CONSOLE_AddMessage("ID\tx y z")
    for i, pp in Game.Players, nil do
        local px, py, pz = ENTITY.GetPosition(pp._Entity)
        CONSOLE_AddMessage(pp.ClientID .. "   " .. tostring(px) .. "   " .. tostring(py) .. "   " .. tostring(pz))
    end
end

function Console:Cmd_PLAYERSGAME()
    CONSOLE_AddMessage("ID\tx y z")
    for i, pp in Game.Players, nil do
        CONSOLE_AddMessage(
            pp.ClientID .. "   " .. tostring(pp.Pos.X) .. "   " .. tostring(pp.Pos.Y) .. "   " .. tostring(pp.Pos.Z)
        )
    end
end

function Console:Cmd_STRESSTEST()
    if IsFinalBuild() then
        return
    end
    local n = table.getn(PKLevels)
    GOD = true
    Game:LoadLevel(PKLevels[math.random(1, n)])
    Game:OnPlay(true)
    Game:SwitchPlayerToPhysics()
    AddAction(
        {
            {"Wait:30"},
            {
                "L:StringToDo = 'Console:Cmd_STRESSTEST()'"
            }
        }
    )
end

_tmpLevNr = 1

function Console:Cmd_EXPO()
    local levels = {
        "C2L5_Demo",
        "C5L1_Demo",
        "C5L4_Demo"
    }
    local n = table.getn(PKLevels)
    Game:LoadLevel(levels[_tmpLevNr])
    Game:OnPlay(true)
    _tmpLevNr = _tmpLevNr + 1
    if _tmpLevNr > 3 then
        _tmpLevNr = 1
    end

    function _EndTimeDemoCallBack()
        StringToDo = "Console:Cmd_EXPO()"
    end

    CONSOLE.Activate(false)
end

function Console:Cmd_SERVERINFO()
    if Game.GMode == GModes.SingleGame then
        return
    end
    Game.ServerInfoRequest(NET.GetClientID())
end

function Console:Cmd_BIND(params, silent)
    if not params or params == "" then
        if not silent then
            CONSOLE_AddMessage("usage: bind key command")
        end
        return
    end
    local i = string.find(params, " ", 1, true)
    i = i or string.len(params) + 1
    local key = string.sub(params, 1, i - 1)
    params = Trim(string.sub(params, i))
    i = string.find(params, " ", 1, true)
    i = i or string.len(params) + 1
    local cmd = string.sub(params, 1, i - 1)
    if not (params and params ~= "" and key) or key == "" then
        if not silent then
            CONSOLE_AddMessage("usage: bind key command")
        end
        return
    end
    if not Console["Cmd_" .. string.upper(cmd)] then
        if not silent then
            CONSOLE_AddMessage("Unknown command: " .. cmd)
        end
        return
    end
    local keyOrig = key
    if key == "[" then
        key = "LBracket"
    elseif key == "]" then
        key = "RBracket"
    elseif key == ";" then
        key = "Semicolon"
    elseif key == "'" then
        key = "Quote"
    elseif key == "-" then
        key = "Minus"
    elseif key == "=" then
        key = "Plus"
    elseif key == "\\" then
        key = "BSlash"
    elseif key == "~" then
        key = "Tilde"
    elseif key == "," then
        key = "Comma"
    elseif key == "." then
        key = "Period"
    elseif key == "/" then
        key = "Slash"
    elseif string.upper(key) == "NUMPAD*" then
        key = "NumpadMulti"
    elseif string.upper(key) == "NUMPAD+" then
        key = "NumpadAdd"
    elseif string.upper(key) == "NUMPAD-" then
        key = "NumpadSub"
    elseif string.upper(key) == "NUMPAD." then
        key = "NumpadDec"
    elseif string.upper(key) == "NUMPAD/" then
        key = "NumpadDiv"
    end
    local engName = INP.GetEngNameByShortName(key)
    if engName == "None" then
        if not silent then
            CONSOLE_AddMessage("Unknown key: " .. keyOrig)
        end
        return
    end
    Cfg_ClearKeyBinding(engName)
    INP.BindKeyCommand(string.upper(key), "Console:OnCommand('\\\\" .. params .. "')")
    Cfg["Bind_" .. string.upper(key)] = params
end

function Console:Cmd_MAP(name)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if name == nil then
        CONSOLE_AddMessage('map "name"  (loads map)')
    else
        name = string.lower(name)
        if string.sub(name, 1, 2) ~= "dm" and string.sub(name, 1, 3) ~= "ctf" and string.sub(name, 1, 3) ~= "pro" then
            CONSOLE_AddMessage("Bad map name '" .. name .. "'")
            return
        end
        if
            (string.sub(name, 1, 3) == "dm_" or string.sub(name, 1, 3) == "pro_") and
                (MPCfg.GameMode == "People Can Fly" or MPCfg.GameMode == "Capture The Flag" or MPCfg.GameMode == "ICTF")
         then
            CONSOLE_AddMessage("Map not available in " .. MPCfg.GameMode .. " mode")
            return
        end
        if string.sub(name, 1, 5) == "dmpcf" and MPCfg.GameMode ~= "People Can Fly" then
            CONSOLE_AddMessage("Map not available in " .. MPCfg.GameMode .. " mode")
            return
        end
        if string.sub(name, 1, 3) == "ctf" and MPCfg.GameMode ~= "Capture The Flag" and MPCfg.GameMode ~= "ICTF" then
            CONSOLE_AddMessage("Map not available in " .. MPCfg.GameMode .. " mode")
            return
        end
        local path = "../Data/Levels/"
        local files = FS.FindFiles(path .. "*", 0, 1)
        local found = false
        for i = 1, table.getn(files) do
            if string.lower(files[i]) == name then
                found = true
            end
        end
        if not found then
            CONSOLE_AddMessage("Bad map name '" .. name .. "'")
            return
        end
        if Game:IsServer() then
            NET.LoadMapOnServer(name)
        else
            if IsFinalBuild() then
                return
            end
            Game:LoadLevel(name)
        end
    end
    CONSOLE_AddMessage("current map:  " .. Lev._Name)
end

function Console:Cmd_MAPLIST()
    local path = "../Data/Levels/"
    local files = FS.FindFiles(path .. "*", 0, 1)
    CONSOLE_AddMessage("Available maps:")
    for i = 1, table.getn(files) do
        CONSOLE_AddMessage("   " .. files[i])
    end
end

function Console:Cmd_RELOADMAP()
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    if Lev._Name then
        Console:Cmd_MAP(Lev._Name)
    end
end

function Console:Cmd_TEAM(nr)
    if nr == "b" or nr == "blue" or nr == "Blue" then
        nr = 1
    end
    if nr == "r" or nr == "red" or nr == "Red" then
        nr = 2
    end
    if nr == "f" or nr == "free" then
        nr = 1
    end
    if nr == "s" or nr == "spectator" then
        Console:Cmd_SPECTATOR(1)
        return
    end
    if MPCfg.GameMode == "Clan Arena" and MPCfg.GameState ~= GameStates.WarmUp then
        if Cfg.Team == 0 then
            CONSOLE_AddMessage("current team: blue")
        else
            CONSOLE_AddMessage("current team: red")
        end
        CONSOLE_AddMessage("Switching team is unallowed during the round")
        return
    end
    nr = tonumber(nr)
    if nr and (nr == 1 or nr == 2) and Cfg.Team ~= nr - 1 then
        Cfg.Team = nr - 1
        if Cfg.SimpleItems and MPCfg.GameMode == "Capture The Flag" or MPCfg.GameMode == "ICTF" then
            for i = 1, 2 do
                local entity = Game.FlagEntityData[i].Entity
                local param = Game.FlagEntityData[i].Param
                Templates["Flag.CItem"]:Client_OnCreateSimpleItems(entity, param)
            end
        end
        if Game.GMode ~= GModes.SingleGame then
            Game.NewPlayerTeamRequest(NET.GetClientID(), Cfg.Team)
            return
        end
    end
    if Cfg.Team == 0 then
        CONSOLE_AddMessage("current team: blue")
    else
        CONSOLE_AddMessage("current team: red")
    end
end

function Console:Cmd_KILL()
    if Game.GMode == GModes.SingleGame then
        return
    end
    Game.PlayerKill(NET.GetClientID())
end

function Console:Cmd_SPECTATOR(nr)
    if nr then
        nr = tonumber(nr)
        if nr and (nr == 0 or nr == 1) and Game.GMode ~= GModes.SingleGame then
            local spec = true
            if nr == 0 then
                spec = false
            end
            if spec ~= NET.IsSpectator(NET.GetClientID()) then
                if NET.IsPlayingRecording() then
                    if nr == 0 then
                        GObjects:ToKill(Game._procSpec)
                        Game._procSpec = nil
                        Player = Game._spectatorRecordingPlayer
                    else
                        GObjects:ToKill(Game._procStats)
                        Game._procStats = nil
                        Game._procSpec = GObjects:Add(TempObjName(), PSpectatorControler:New())
                        Game._procSpec:Init()
                        Game._spectatorRecordingPlayer = Player
                        Player = nil
                    end
                    NET.SetSpectator(NET.GetClientID(), nr)
                else
                    Game.PlayerSpectatorRequest(NET.GetClientID(), nr)
                end
            end
        end
    end
end

function Console:Cmd_READY()
    if Game.GMode == GModes.SingleGame then
        return
    end
    Game.SetStateRequest(NET.GetClientID(), 1)
end

function Console:Cmd_NOTREADY()
    if Game.GMode == GModes.SingleGame then
        return
    end
    Game.SetStateRequest(NET.GetClientID(), 0)
end

function Console:Cmd_BREAK()
    if Game.GMode == GModes.SingleGame then
        return
    end
    Game.SetStateRequest(NET.GetClientID(), 2)
end

function Console:Cmd_BANKICK(name)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    if name == nil then
        CONSOLE_AddMessage('bankick "name"  (disconnect and ban player from the server)')
        return
    end
    name = string.lower(name)
    for i, o in Game.PlayerStats, nil do
        if string.lower(HUD.StripColorInfo(o.Name)) == name then
            NET.BanClient(o.ClientID)
            NET.DisconnectClient(o.ClientID)
        end
    end
end

function Console:Cmd_KICK(name)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    if name == nil then
        CONSOLE_AddMessage('kick "name"  (disconnect player from the server)')
        return
    end
    name = string.lower(name)
    for i, o in Game.PlayerStats, nil do
        if string.lower(HUD.StripColorInfo(o.Name)) == name then
            NET.DisconnectClient(o.ClientID)
        end
    end
end

function Console:Cmd_BANKICKID(id)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    if id == nil then
        CONSOLE_AddMessage("kickid id  (disconnect player from the server)")
        return
    end
    id = tonumber(id)
    if id then
        NET.BanClient(id)
        NET.DisconnectClient(id)
    end
end

function Console:Cmd_KICKID(id)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    if id == nil then
        CONSOLE_AddMessage("kickid id  (disconnect player from the server)")
        return
    end
    id = tonumber(id)
    if id then
        NET.DisconnectClient(id)
    end
end

function Console:Cmd_MAXPLAYERS(val)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    if val == nil then
        CONSOLE_AddMessage("maxplayers value (sets max number of players on server)")
        return
    end
    if Cfg.GameMode == "Duel" then
        CONSOLE_AddMessage("maxplayers cannot be changed in Duel mode")
        return
    end
    val = tonumber(val)
    if val and 1 < val then
        Cfg.MaxPlayers = val
        local gameState = "playing"
        if MPCfg.GameState == GameStates.WarmUp then
            gameState = "warmup"
        elseif MPCfg.GameState == GameStates.Counting then
            gameState = "counting"
        elseif MPCfg.GameState == GameStates.Finished then
            gameState = "finished"
        end
        local numPlayers = 0
        local numSpecs = 0
        for id, ps in Game.PlayerStats, nil do
            if ps.Spectator == 0 then
                numPlayers = numPlayers + 1
            else
                numSpecs = numSpecs + 1
            end
        end
        GAMESPY.SetServerInfo(
            PK_VERSION,
            Cfg.ServerName,
            Cfg.ServerPassword,
            Lev._Name,
            Cfg.GameMode,
            Cfg.MaxPlayers,
            Cfg.MaxSpectators,
            Cfg.FragLimit,
            Cfg.TimeLimit,
            Game._TimeLimitOut,
            gameState,
            numPlayers,
            numSpecs
        )
        Game.ConsoleMessageAll("Max number of players is now " .. val)
    else
        CONSOLE_AddMessage("Max number of players cannot be lower than 2")
    end
end

function Console:Cmd_MAXSPECTATORS(val)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    if val == nil then
        CONSOLE_AddMessage("maxplayers value (sets max number of players on server)")
    end
    val = tonumber(val)
    if val then
        Cfg.MaxSpectators = val
        local gameState = "playing"
        if MPCfg.GameState == GameStates.WarmUp then
            gameState = "warmup"
        elseif MPCfg.GameState == GameStates.Counting then
            gameState = "counting"
        elseif MPCfg.GameState == GameStates.Finished then
            gameState = "finished"
        end
        local numPlayers = 0
        local numSpecs = 0
        for id, ps in Game.PlayerStats, nil do
            if ps.Spectator == 0 then
                numPlayers = numPlayers + 1
            else
                numSpecs = numSpecs + 1
            end
        end
        GAMESPY.SetServerInfo(
            PK_VERSION,
            Cfg.ServerName,
            Cfg.ServerPassword,
            Lev._Name,
            Cfg.GameMode,
            Cfg.MaxPlayers,
            Cfg.MaxSpectators,
            Cfg.FragLimit,
            Cfg.TimeLimit,
            Game._TimeLimitOut,
            gameState,
            numPlayers,
            numSpecs
        )
        Game.ConsoleMessageAll("Max number of spectators is now " .. val)
    end
end

function Console:Cmd_HMRECORD()
    if IsFinalBuild() then
        return
    end
    if Game.GMode == GModes.SingleGame then
        return
    end
    PLAYER.RecordMovement(Player._Entity)
end

function Console:Cmd_HMTEST()
    if IsFinalBuild() then
        return
    end
    if Game.GMode == GModes.SingleGame then
        return
    end
    PLAYER.TestMovement(Player._Entity)
end

function Console:Cmd_SETMAXFPS(val)
    if val == nil then
        CONSOLE_AddMessage("Give a new value after this command to change maxfps.")
        CONSOLE_AddMessage("Give a 0 to remove the limit.")
        return
    end
    val = tonumber(val)
    if val then
        if PainMenu.public then
            if val <= 125 and 0 <= val then
                WORLD.SetMaxFPS(val)
            end
        else
            WORLD.SetMaxFPS(val)
        end
        if Game.GMode == GModes.MultiplayerClient then
            Cfg.MaxFpsMP = val
        end
    end
end

function Console:Cmd_POWERUPDROP(enable)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("powerupdrop 0/1  (disables/enables powerup drop)")
    end
    if enable == 1 then
        Cfg.PowerupDrop = true
        Game.ConsoleMessageAll("Powerup dropping enabled")
    elseif enable == 0 then
        Cfg.PowerupDrop = false
        Game.ConsoleMessageAll("Powerup dropping disabled")
    end
end

function Console:Cmd_POWERUPS(enable)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("powerups 0/1  (disables/enables powerups)")
    end
    if enable == 1 then
        Cfg.Powerups = true
        Game.ConsoleMessageAll("Powerups will be enabled after map reload")
    elseif enable == 0 then
        Cfg.Powerups = false
        Game.ConsoleMessageAll("Powerups will be disabled after map reload")
    end
end

function Console:Cmd_WEAPONSSTAY(enable)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("weaponsstay 0/1  (disables/enables weapons stay)")
    end
    if enable == 1 then
        Cfg.WeaponsStay = true
        Game.ConsoleMessageAll("Weapons stay enabled")
    elseif enable == 0 then
        Cfg.WeaponsStay = false
        Game.ConsoleMessageAll("Weapons stay disabled")
    end
end

function Console:Cmd_TEAMDAMAGE(enable)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("teamdamage 0/1  (disables/enables team damage)")
    end
    if enable == 1 then
        Cfg.TeamDamage = true
        Game.ConsoleMessageAll("Team damage is now enabled")
    elseif enable == 0 then
        Cfg.TeamDamage = false
        Game.ConsoleMessageAll("Team damage is now disabled")
    end
    Game.SetConfiguration(
        Cfg.AllowBrightskins,
        Cfg.GameMode,
        Cfg.FragLimit,
        Cfg.CaptureLimit,
        Cfg.LMSLives,
        Cfg.TeamDamage,
        Cfg.ClientConsoleLockdown
    )
end

function Console:Cmd_ALLOWBUNNYHOPPING(enable)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("allowbunnyhopping 0/1  (disables/enables bunnyhopping)")
    end
    if enable == 1 then
        Cfg.AllowBunnyhopping = true
    elseif enable == 0 then
        Cfg.AllowBunnyhopping = false
    end
    Game.EnableBunnyhopping(Cfg.AllowBunnyhopping)
end

function Console:Cmd_ALLOWBRIGHTSKINS(enable)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("allowbrightskins 0/1  (disables/enables brightskins)")
    end
    if enable == 1 then
        Cfg.AllowBrightskins = true
    elseif enable == 0 then
        Cfg.AllowBrightskins = false
    end
    MPCfg.GameMode = Cfg.GameMode
    MPCfg.TeamDamage = Cfg.TeamDamage
    MPCfg.AllowBrightskins = Cfg.AllowBrightskins
    Game.SetConfiguration(
        Cfg.AllowBrightskins,
        Cfg.GameMode,
        Cfg.FragLimit,
        Cfg.CaptureLimit,
        Cfg.LMSLives,
        Cfg.TeamDamage,
        Cfg.ClientConsoleLockdown
    )
    Game.ReloadBrightskins()
end

function Console:Cmd_ALLOWFORWARDRJ(enable)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("allowforwardrj 0/1  (disables/enables forward rocket jumps)")
    end
    if enable == 1 then
        Cfg.AllowForwardRJ = true
        Game.ConsoleMessageAll("Forward Rocket Jumps enabled")
    elseif enable == 0 then
        Cfg.AllowForwardRJ = false
        Game.ConsoleMessageAll("Forward Rocket Jumps disabled")
    end
end

function Console:Cmd_STARTUPWEAPON(enable)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("startupweapon 0-7 (0 = default)")
    else
        Cfg.StartupWeapon = enable
    end
end

function Console:Cmd_GAMEMODE(mode)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    if IsMPDemo() then
        CONSOLE_AddMessage("Command 'gamemode' not available in demo version")
        return
    end
    local toPCF = false
    local fromPCF = false
    if Cfg.GameMode == "People Can Fly" then
        fromPCF = true
    elseif mode == "pcf" then
        toPCF = true
    end
    local newMap, mapsTable
    if mode == "ffa" then
        if Cfg.GameMode == "Free For All" then
            return
        end
        Cfg.GameMode = "Free For All"
        newMap = "DM_Sacred"
        mapsTable = Cfg.ServerMapsFFA
    elseif mode == "tdm" then
        if Cfg.GameMode == "Team Deathmatch" then
            return
        end
        Cfg.GameMode = "Team Deathmatch"
        newMap = "DM_Mine"
        mapsTable = Cfg.ServerMapsTDM
    elseif mode == "voosh" then
        if Cfg.GameMode == "Voosh" then
            return
        end
        Cfg.GameMode = "Voosh"
        newMap = "DM_Cursed"
        mapsTable = Cfg.ServerMapsVSH
    elseif mode == "tlb" then
        if Cfg.GameMode == "The Light Bearer" then
            return
        end
        Cfg.GameMode = "The Light Bearer"
        newMap = "DM_Sacred"
        mapsTable = Cfg.ServerMapsTLB
    elseif mode == "ctf" then
        if Cfg.GameMode == "Capture The Flag" then
            return
        end
        Cfg.GameMode = "Capture The Flag"
        newMap = "CTF_Forbidden"
        mapsTable = Cfg.ServerMapsCTF
    elseif mode == "pcf" then
        if Cfg.GameMode == "People Can Fly" then
            return
        end
        Cfg.GameMode = "People Can Fly"
        newMap = "DMPCF_Tower"
        mapsTable = Cfg.ServerMapsPCF
    elseif mode == "duel" then
        if Cfg.GameMode == "Duel" then
            return
        end
        Cfg.GameMode = "Duel"
        newMap = "DM_Sacred"
        mapsTable = Cfg.ServerMapsDUE
    elseif mode == "ca" then
        if Cfg.GameMode == "Clan Arena" then
            return
        end
        Cfg.GameMode = "Clan Arena"
        newMap = "DM_Sacred"
        mapsTable = Cfg.ServerMapsCLA
    elseif mode == "ig" then
        if Cfg.GameMode == "Instagib" then
            return
        end
        Cfg.GameMode = "Instagib"
        newMap = "DM_Unseen"
        mapsTable = Cfg.ServerMapsFFA
    elseif mode == "ictf" then
        if Cfg.GameMode == "ICTF" then
            return
        end
        Cfg.GameMode = "ICTF"
        newMap = "CTF_Forbidden"
        mapsTable = Cfg.ServerMapsCTF
    elseif mode == "lms" then
        if Cfg.GameMode == "Last Man Standing" then
            return
        end
        Cfg.GameMode = "Last Man Standing"
        newMap = "DM_Factory"
        mapsTable = Cfg.ServerMapsLMS
    else
        CONSOLE_AddMessage("Available modes: ffa, tdm, voosh, tlb, pcf, ctf, duel, lms, ig, ictf, ca (wip)")
        return
    end
    Cfg.ServerMaps = {}
    PainMenu.mapsOnServer = {}
    if mapsTable[1] then
        newMap = mapsTable[1]
        for i = 1, table.getn(mapsTable) do
            Cfg.ServerMaps[i] = mapsTable[i]
            PainMenu.mapsOnServer[i] = mapsTable[i]
        end
    else
        Cfg.ServerMaps[1] = newMap
        PainMenu.mapsOnServer[1] = newMap
    end
    Game.SetConfiguration(
        Cfg.AllowBrightskins,
        Cfg.GameMode,
        Cfg.FragLimit,
        Cfg.CaptureLimit,
        Cfg.LMSLives,
        Cfg.TeamDamage,
        Cfg.ClientConsoleLockdown
    )
    Console:Cmd_MAP(newMap)
end

function Console:Cmd_MODE(mode)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if not Game:IsServer() then
        return
    end
    if IsMPDemo() then
        CONSOLE_AddMessage("Command 'mode' not available in demo version")
        return
    end
    local toPCF = false
    local fromPCF = false
    if Cfg.GameMode == "People Can Fly" then
        fromPCF = true
    elseif mode == "pcf" then
        toPCF = true
    end
    local newMap, mapsTable
    if mode == "ffa" then
        if Cfg.GameMode == "Free For All" then
            return
        end
        Cfg.GameMode = "Free For All"
        newMap = "DM_Sacred"
        mapsTable = Cfg.ServerMapsFFA
    elseif mode == "tdm" then
        if Cfg.GameMode == "Team Deathmatch" then
            return
        end
        Cfg.GameMode = "Team Deathmatch"
        newMap = "DM_Mine"
        mapsTable = Cfg.ServerMapsTDM
    elseif mode == "voosh" then
        if Cfg.GameMode == "Voosh" then
            return
        end
        Cfg.GameMode = "Voosh"
        newMap = "DM_Cursed"
        mapsTable = Cfg.ServerMapsVSH
    elseif mode == "tlb" then
        if Cfg.GameMode == "The Light Bearer" then
            return
        end
        Cfg.GameMode = "The Light Bearer"
        newMap = "DM_Sacred"
        mapsTable = Cfg.ServerMapsTLB
    elseif mode == "ctf" then
        if Cfg.GameMode == "Capture The Flag" then
            return
        end
        Cfg.GameMode = "Capture The Flag"
        newMap = "CTF_Forbidden"
        mapsTable = Cfg.ServerMapsCTF
    elseif mode == "pcf" then
        if Cfg.GameMode == "People Can Fly" then
            return
        end
        Cfg.GameMode = "People Can Fly"
        newMap = "DMPCF_Tower"
        mapsTable = Cfg.ServerMapsPCF
    elseif mode == "duel" then
        if Cfg.GameMode == "Duel" then
            return
        end
        Cfg.GameMode = "Duel"
        newMap = "DM_Sacred"
        mapsTable = Cfg.ServerMapsDUE
    elseif mode == "ca" then
        if Cfg.GameMode == "Clan Arena" then
            return
        end
        Cfg.GameMode = "Clan Arena"
        newMap = "DM_Sacred"
        mapsTable = Cfg.ServerMapsCLA
    elseif mode == "ig" then
        if Cfg.GameMode == "Instagib" then
            return
        end
        Cfg.GameMode = "Instagib"
        newMap = "DM_Unseen"
        mapsTable = Cfg.ServerMapsFFA
    elseif mode == "ictf" then
        if Cfg.GameMode == "ICTF" then
            return
        end
        Cfg.GameMode = "ICTF"
        newMap = "CTF_Forbidden"
        mapsTable = Cfg.ServerMapsCTF
    elseif mode == "lms" then
        if Cfg.GameMode == "Last Man Standing" then
            return
        end
        Cfg.GameMode = "Last Man Standing"
        newMap = "DM_Factory"
        mapsTable = Cfg.ServerMapsLMS
    else
        CONSOLE_AddMessage("Available modes: ffa, tdm, voosh, tlb, pcf, ctf, duel, lms, ig, ictf, ca (wip)")
        return
    end
    Cfg.ServerMaps = {}
    PainMenu.mapsOnServer = {}
    if mapsTable[1] then
        newMap = mapsTable[1]
        for i = 1, table.getn(mapsTable) do
            Cfg.ServerMaps[i] = mapsTable[i]
            PainMenu.mapsOnServer[i] = mapsTable[i]
        end
    else
        Cfg.ServerMaps[1] = newMap
        PainMenu.mapsOnServer[1] = newMap
    end
    Game.SetConfiguration(
        Cfg.AllowBrightskins,
        Cfg.GameMode,
        Cfg.FragLimit,
        Cfg.CaptureLimit,
        Cfg.LMSLives,
        Cfg.TeamDamage,
        Cfg.ClientConsoleLockdown
    )
    Console:Cmd_MAP(newMap)
end

function Console:CheckVotingParams(cmd, params)
    if cmd == "map" then
        name = string.lower(params)
        if string.sub(name, 1, 2) ~= "dm" and string.sub(name, 1, 3) ~= "ctf" and string.sub(name, 1, 3) ~= "pro" then
            CONSOLE_AddMessage("Bad map name '" .. name .. "'")
            return false
        end
        if
            (string.sub(name, 1, 3) == "dm_" or string.sub(name, 1, 3) == "pro_") and
                (MPCfg.GameMode == "People Can Fly" or MPCfg.GameMode == "Capture The Flag" or MPCfg.GameMode == "ICTF")
         then
            CONSOLE_AddMessage("Map not available in " .. MPCfg.GameMode .. " mode")
            return
        end
        if string.sub(name, 1, 5) == "dmpcf" and MPCfg.GameMode ~= "People Can Fly" then
            CONSOLE_AddMessage("Map not available in " .. MPCfg.GameMode .. " mode")
            return
        end
        if string.sub(name, 1, 3) == "ctf" and MPCfg.GameMode ~= "Capture The Flag" and MPCfg.GameMode ~= "ICTF" then
            CONSOLE_AddMessage("Map not available in " .. MPCfg.GameMode .. " mode")
            return
        end
        local path = "../Data/Levels/"
        local files = FS.FindFiles(path .. "*", 0, 1)
        local found = false
        for i = 1, table.getn(files) do
            if string.lower(files[i]) == name then
                found = true
            end
        end
        if not found then
            CONSOLE_AddMessage("Bad map name '" .. name .. "'")
            return false
        end
        return true
    elseif
        cmd == "timelimit" or cmd == "fraglimit" or cmd == "maxplayers" or cmd == "maxspectators" or cmd == "bankickid" or
            cmd == "kickid" or
            cmd == "weaponrespawntime" or
            cmd == "capturelimit" or
            cmd == "lmslives" or
            cmd == "startupweapon"
     then
        local val = tonumber(params)
        if not val or type(val) ~= "number" then
            CONSOLE_AddMessage("Wrong params for " .. cmd)
            return false
        end
        return true
    elseif cmd == "kick" or cmd == "gamemode" or cmd == "mode" or cmd == "bankick" then
        if params and type(params) == "string" then
            return true
        else
            CONSOLE_AddMessage("Wrong params for " .. cmd)
            return false
        end
    elseif
        cmd == "powerupdrop" or cmd == "powerups" or cmd == "weaponsstay" or cmd == "teamdamage" or
            cmd == "allowbunnyhopping" or
            cmd == "allowbrightskins" or
            cmd == "allowforwardrj"
     then
        local val = tonumber(params)
        if val ~= 0 and val ~= 1 then
            CONSOLE_AddMessage("Wrong params for " .. cmd)
            return false
        end
        return true
    elseif cmd == "reloadmap" then
        return true
    elseif cmd == "proplus" then
        local val = tonumber(params)
        if val ~= 0 and val ~= 1 then
            CONSOLE_AddMessage("Wrong params for " .. cmd)
            return false
        end
        return true
    elseif cmd == "forcespec" then
        return true
    elseif cmd == "referee" then
        return true
    elseif cmd == "allready" then
        return true
    elseif cmd == "botskill" then
        local val = tonumber(params)
        if
            val ~= 0 and val ~= 1 and val ~= 2 and val ~= 3 and val ~= 4 and val ~= 5 and val ~= 6 and val ~= 7 and
                val ~= 8 and
                val ~= 9 and
                val ~= 10
         then
            CONSOLE_AddMessage("Wrong params for " .. cmd)
            return false
        end
        return true
    elseif cmd == "addbot" then
        return true
    elseif cmd == "teamlock" then
        return true
    elseif cmd == "kickbot" then
        return true
    elseif cmd == "kickallbots" then
        return true
    elseif cmd == "restartmap" then
        return true
    elseif cmd == "saferespawn" then
        return true
    elseif cmd == "warmupdamage" then
        return true
    elseif cmd == "fallingdamage" then
        return true
    elseif cmd == "rocketfix" then
        return true
    end
    CONSOLE_AddMessage("Command '" .. cmd .. "' cannot be used for voting")
    return false
end

function Console:Cmd_CALLVOTE(params)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if NET.IsSpectator(NET.GetClientID()) then
        return
    end
    if not params or params == "" then
        return
    end
    local i = string.find(params, " ", 1, true)
    i = i or string.len(params) + 1
    local cmd = string.sub(params, 1, i - 1)
    params = Trim(string.sub(params, i))
    if not Console["Cmd_" .. string.upper(cmd)] then
        CONSOLE_AddMessage("Unknown command: " .. cmd)
        return
    end
    if not self:CheckVotingParams(cmd, params) then
        return
    end
    local numPlayers = 0
    for i, o in Game.PlayerStats, nil do
        numPlayers = numPlayers + 1
    end
    if Game._voteCmd == "" then
        Game.StartVotingRequest(NET.GetClientID(), cmd, params)
    else
        CONSOLE_AddMessage("Please wait till current voting is over")
    end
end

function Console:Cmd_CV(params)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if NET.IsSpectator(NET.GetClientID()) then
        return
    end
    if not params or params == "" then
        return
    end
    local i = string.find(params, " ", 1, true)
    i = i or string.len(params) + 1
    local cmd = string.sub(params, 1, i - 1)
    params = Trim(string.sub(params, i))
    if not Console["Cmd_" .. string.upper(cmd)] then
        CONSOLE_AddMessage("Unknown command: " .. cmd)
        return
    end
    if not self:CheckVotingParams(cmd, params) then
        return
    end
    local numPlayers = 0
    for i, o in Game.PlayerStats, nil do
        numPlayers = numPlayers + 1
    end
    if Game._voteCmd == "" then
        Game.StartVotingRequest(NET.GetClientID(), cmd, params)
    else
        CONSOLE_AddMessage("Please wait till current voting is over")
    end
end

function Console:Cmd_VOTE(yesno)
    if Game.GMode == GModes.SingleGame then
        return
    end
    if NET.IsSpectator(NET.GetClientID()) then
        CONSOLE_AddMessage("Spectators cannot vote.")
        return
    end
    if not yesno or yesno ~= "no" and yesno ~= "yes" then
        CONSOLE_AddMessage("Usage: vote yes/no")
        return
    end
    local val = 0
    if yesno == "yes" then
        val = 1
    end
    if Game._voteCmd ~= "" then
        Game.PlayerVoteRequest(NET.GetClientID(), val)
    else
        CONSOLE_AddMessage("No voting in progress")
    end
end

function Console:Cmd_PLAYERS()
    if Game.GMode == GModes.SingleGame then
        CONSOLE_AddMessage("Command not available in Single Player mode")
        return
    end
    for i, o in Game.PlayerStats, nil do
        CONSOLE_AddMessage(o.ClientID .. "  " .. o.Name)
    end
end

function Console:Cmd_NETSTATS(cmd)
    if Game.GMode == GModes.SingleGame then
        CONSOLE_AddMessage("Command not available in Single Player mode")
        return
    end
    if IsNewNetcode() then
        cmd = tonumber(cmd)
        if cmd == 0 then
            NET.SetStatsShow(false)
        elseif cmd == 1 then
            NET.SetStatsShow(true)
        else
            CONSOLE_AddMessage("Params are 0 or 1")
        end
    elseif cmd == nil then
        CONSOLE_AddMessage(NET.GetClientStats(255, true))
    elseif cmd == "overall" then
        CONSOLE_AddMessage(NET.GetClientStats(255, false))
    elseif cmd == "help" then
        CONSOLE_AddMessage("Usage:")
        CONSOLE_AddMessage(" netstats         - to get stats for last 5 seconds")
        CONSOLE_AddMessage(" netstats overall - to get stats for the whole connection")
        CONSOLE_AddMessage(" netstats help    - for this message")
    end
end

function Console:Cmd_NETSTATSAVGFROM(cmd)
    if Game.GMode == GModes.SingleGame then
        CONSOLE_AddMessage("Command not available in Single Player mode")
        return
    end
    if IsNewNetcode() then
        cmd = tonumber(cmd)
        if cmd == nil then
            CONSOLE_AddMessage("Usage: netstatsavgfrom (1-1023)")
        else
            NET.SetStatsNrToAvg(cmd)
        end
    else
        CONSOLE_AddMessage("Command not available with old netcode")
    end
end

function Console:Cmd_NETSTATSUPDATEDELAY(cmd)
    if Game.GMode == GModes.SingleGame then
        CONSOLE_AddMessage("Command not available in Single Player mode")
        return
    end
    if IsNewNetcode() then
        cmd = tonumber(cmd)
        if cmd == nil then
            CONSOLE_AddMessage("Usage: netstatsupdatedelay (1-65535)")
            CONSOLE_AddMessage("    ( the value to set is in miliseconds)")
        else
            NET.SetStatsUpdateDelay(cmd)
        end
    else
        CONSOLE_AddMessage("Command not available with old netcode")
    end
end

function Console:Cmd_SERVERFRAMERATE(cmd)
    if Game.GMode == GModes.SingleGame then
        CONSOLE_AddMessage("Command not available in Single Player mode")
        return
    end
    if IsNewNetcode() then
        cmd = tonumber(cmd)
        if cmd == nil then
            CONSOLE_AddMessage("Usage: serverframerate (1-1000)")
            CONSOLE_AddMessage("    ( the value to set is in frames per second)")
        elseif PainMenu.public then
            if cmd <= 60 and 0 <= cmd then
                NET.SetServerFramerate(cmd)
            end
        else
            NET.SetServerFramerate(cmd)
        end
    else
        CONSOLE_AddMessage("Command not available with old netcode")
    end
end

function Console:Cmd_CLIENTBANDWIDTH(cmd)
    if Game.GMode == GModes.SingleGame then
        CONSOLE_AddMessage("Command not available in Single Player mode")
        return
    end
    if IsNewNetcode() then
        cmd = tonumber(cmd)
        if cmd == nil then
            CONSOLE_AddMessage("Usage: clientbandwidth <bytes-per-second>")
            CONSOLE_AddMessage("    ( sets upstream bandwidth limiter )")
            CONSOLE_AddMessage("Current value: " .. NET.GetClientBandwidth())
        else
            NET.SetClientBandwidth(cmd)
        end
    else
        CONSOLE_AddMessage("Command not available with old netcode")
    end
end

function Console:Cmd_ENEMYINTERPOLATION(cmd)
    if Game.GMode == GModes.SingleGame then
        CONSOLE_AddMessage("Command not available in Single Player mode")
        return
    end
    if IsNewNetcode() then
        cmd = tonumber(cmd)
        if cmd == 0 then
            Cfg.NetcodeEnemyPredictionInterpolation = false
            NET.SetEnemyPredictionInterpolation(false)
        elseif cmd == 1 then
            Cfg.NetcodeEnemyPredictionInterpolation = true
            NET.SetEnemyPredictionInterpolation(true)
        else
            CONSOLE_AddMessage("Usage: enemyinterpolation 0/1")
            CONSOLE_AddMessage("    ( interpolates between last two enemy positions )")
        end
    else
        CONSOLE_AddMessage("Command not available with old netcode")
    end
end

function Console:Cmd_DISCONNECT()
    if Game.GMode == GModes.SingleGame or Game:IsServer() then
        CONSOLE_AddMessage("Command not available in Single Player or Server mode")
        return
    end
    NET.Disconnect()
    Game:NewLevel("NoName", "", "", 0.3)
    WORLD.Release()
    Game.GameInProgress = false
    Game.LevelStarted = false
    PMENU.ShowMenu()
    PainMenu:BackToLastScreen()
end

function Console:Cmd_RECONNECT()
    if Game.GMode == GModes.SingleGame then
        CONSOLE_AddMessage("Command not available in Single Player mode")
        return
    end
    PMENU.Activate(false)
    local res =
        PMENU.JoinServer(
        PainMenu.playerName,
        PainMenu.passwd,
        PainMenu.speed,
        PainMenu.host,
        PainMenu.port,
        PainMenu.public,
        PainMenu.spectator
    )
    if res == false then
        Game:Print("Cannot join server " .. self.host)
        PainMenu:ShowInfo("Cannot connect to server " .. self.host, "PainMenu:BackToLastScreen()")
    end
end

function Console:Cmd_SAY(txt)
    if not txt then
        return
    end
    if Game.GMode == GModes.SingleGame then
        CONSOLE_AddMessage("Command not available in Single Player mode")
        return
    end
    Game.SayToAll(NET.GetClientID(), txt)
end

function Console:Cmd_TEAMSAY(txt)
    if not txt then
        return
    end
    if Game.GMode == GModes.SingleGame then
        CONSOLE_AddMessage("Command not available in Single Player mode")
        return
    end
    Game.SayToTeam(NET.GetClientID(), txt)
end

function Console:Cmd_BENCHMARK(name)
    if name == nil then
        CONSOLE_AddMessage('benchmark "name"')
    elseif not Game:IsServer() then
        Game:LoadLevel(name .. "_Benchmark")
        Game:OnPlay(true)
        CONSOLE.Activate(false)
    end
end

function Console:Cmd_PKAMMO()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if Player then
        Player.Ammo = Clone(CPlayer.s_SubClass.Ammo)
        CONSOLE_AddMessage(TXT.Cheats.PKAmmo)
    end
end

function Console:Cmd_PKWEAPONS()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if Player then
        Player.EnabledWeapons = Clone(CPlayer.EnabledWeapons)
        Player.Ammo = Clone(CPlayer.s_SubClass.Ammo)
        CONSOLE_AddMessage(TXT.Cheats.PKWeapons)
    end
end

function Console:Cmd_PKHEALTH()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if Player then
        if Player.Health < Game.HealthCapacity then
            Player.Health = Game.HealthCapacity
        end
        local t
        local atype = Player.ArmorType
        if atype == ArmorTypes.Weak then
            t = Templates["ArmorWeak.CItem"]
        end
        if atype == ArmorTypes.Medium then
            t = Templates["ArmorMedium.CItem"]
        end
        if atype == ArmorTypes.Strong then
            t = Templates["ArmorStrong.CItem"]
        end
        if t then
            Player.Armor = t.ArmorAdd
        end
        CONSOLE_AddMessage(TXT.Cheats.PKHealth)
    end
end

function Console:Cmd_PKPOWER()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    self:Cmd_PKAMMO()
    self:Cmd_PKHEALTH()
end

function Console:Cmd_PKGOD()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if GOD == true then
        GOD = false
        CONSOLE_AddMessage(TXT.Cheats.PKGodOff)
    else
        GOD = true
        CONSOLE_AddMessage(TXT.Cheats.PKGodOn)
    end
end

function Console:Cmd_PKALWAYSGIB()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if not Game.Cheat_AlwaysGib then
        Game.Cheat_AlwaysGib = true
        CONSOLE_AddMessage(TXT.Cheats.PKGibOn)
    else
        Game.Cheat_AlwaysGib = false
        CONSOLE_AddMessage(TXT.Cheats.PKGibOff)
    end
end

function Console:Cmd_PKWEAKENEMIES()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if not Game.Cheat_WeakEnemies then
        Game.Cheat_WeakEnemies = true
        CONSOLE_AddMessage(TXT.Cheats.PKWeakOn)
    else
        Game.Cheat_WeakEnemies = false
        CONSOLE_AddMessage(TXT.Cheats.PKWeakOff)
    end
end

function Console:Cmd_PKCARDS()
    if IsFinalBuild() then
        return
    end
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    Game.GoldenCardsUseUnlimited = true
    CONSOLE_AddMessage(TXT.Cheats.PKCards)
end

function Console:Cmd_PKGOLD()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if Game then
        Game.PlayerMoney = 99999
    end
    MBOARD.SetCashCheat(99999)
    CONSOLE_AddMessage(TXT.Cheats.PKGold)
end

function Console:Cmd_PKHASTE()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if Game.BulletTime == true then
        Game:EnableBulletTime(false)
        CONSOLE_AddMessage(TXT.Cheats.PKHasteOff)
    else
        local slow = Game.BulletTimeSlowdown
        Game.BulletTimeSlowdown = 1 / 8
        Game:EnableBulletTime(true)
        Game.BulletTimeSlowdown = slow
        CONSOLE_AddMessage(TXT.Cheats.PKHasteOn)
    end
end

function Console:Cmd_PKDEMON()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if Game.IsDemon then
        Game:EnableDemon(false)
        CONSOLE_AddMessage(TXT.Cheats.PKDemonOff)
    else
        Game:EnableDemon(true)
        CONSOLE_AddMessage(TXT.Cheats.PKDemonOn)
    end
end

function Console:Cmd_PKWEAPONMODIFIER()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if Player then
        if Player.HasWeaponModifier == false then
            Player.HasWeaponModifier = true
            Player._WeaponModifierCounter = 9999999
            CONSOLE_AddMessage(TXT.Cheats.PKWeapModOn)
        else
            Player.HasWeaponModifier = false
            Player._WeaponModifierCounter = 0
            CONSOLE_AddMessage(TXT.Cheats.PKWeapModOff)
        end
    end
end

function Console:Cmd_PKKEEPBODIES()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if Game.Cheat_KeepBodies then
        Game.Cheat_KeepBodies = false
        CONSOLE_AddMessage(TXT.Cheats.PKKeepBodiesOff)
    else
        Game.Cheat_KeepBodies = true
        CONSOLE_AddMessage(TXT.Cheats.PKKeepBodiesOn)
    end
end

function Console:Cmd_PKKEEPDECALS()
    if Game.GMode ~= GModes.SingleGame then
        return
    end
    if Game.Difficulty > 1 then
        CONSOLE_AddMessage(TXT.Cheats.LowLevelOnly)
        return
    end
    if Game.Cheat_KeepDecals then
        Game.Cheat_KeepDecals = false
        CONSOLE_AddMessage(TXT.Cheats.PKKeepDecalsOff)
    else
        Game.Cheat_KeepDecals = true
        CONSOLE_AddMessage(TXT.Cheats.PKKeepDecalsOn)
    end
    R3D.KeepDecals(Game.Cheat_KeepDecals)
end

function Console:Cmd_SERVER(name)
    if IsFinalBuild() then
        return
    end
    if name == nil then
        CONSOLE_AddMessage("server map_name")
    elseif PMENU.StartServer(Cfg.PlayerName, "", name, 1, 3455) then
        NET.LoadMapOnServer(name)
    end
    CONSOLE_AddMessage("server started on map:  " .. Lev._Name)
end

function Console:Cmd_CONNECT(ip)
    if ip == nil then
        CONSOLE_AddMessage("connect ip:port")
    else
        local host, port
        for h, p in string.gfind(ip, "(.+):(.+)") do
            host = h
            port = p
        end
        if host == nil and port == nil then
            host = ip
            port = 3455
        end
        if host ~= nil and port ~= nil then
            PMENU.Activate(false)
            PMENU.JoinServer(Cfg.PlayerName, "", 1, host, port, true)
            CONSOLE.Activate(false)
        end
    end
end

function Console:Cmd_CONNECTPKTV(arguments)
    if IsFinalBuild() then
        return
    end
    if arguments == nil then
        CONSOLE.AddMessage("connect <ip[:port]> [password]")
    else
        PMENU.Activate(false)
        PMENU.JoinPKTV(arguments)
        CONSOLE.Activate(false)
    end
end

function Console:Cmd_MSENSITIVITY(val)
    val = tonumber(val)
    if val == nil then
        CONSOLE_AddMessage("msensitivity value  (sets mouse sensitivity)")
    elseif type(val) == "number" and val < 201 and 0 <= val then
        Cfg.MouseSensitivity = val
        MOUSE.SetSensitivity(Cfg.MouseSensitivity)
    end
    CONSOLE_AddMessage("current mouse sensitivity:  " .. Cfg.MouseSensitivity)
end

function Console:Cmd_SENSITIVITY(val)
    val = tonumber(val)
    if val == nil then
        CONSOLE_AddMessage("msensitivity value  (sets mouse sensitivity)")
    elseif type(val) == "number" and val < 201 and 0 <= val then
        Cfg.MouseSensitivity = val
        MOUSE.SetSensitivity(Cfg.MouseSensitivity)
    end
    CONSOLE_AddMessage("current mouse sensitivity:  " .. Cfg.MouseSensitivity)
end

function Console:Cmd_MSMOOTH(enable)
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("msmooth value  (enables smooth mouse)")
    end
    if enable == 1 then
        Cfg.SmoothMouse = true
    end
    if enable == 0 then
        Cfg.SmoothMouse = false
    end
    MOUSE.SetSmooth(Cfg.SmoothMouse)
    if Cfg.SmoothMouse then
        CONSOLE_AddMessage("smooth mouse is enabled")
    else
        CONSOLE_AddMessage("smooth mouse is disabled")
    end
end

function Console:Cmd_FOV(val)
    val = tonumber(val)
    if val == nil then
        CONSOLE_AddMessage("fov value  (sets camera's FOV)")
    elseif type(val) == "number" then
        Cfg.FOV = val
        PainMenu.cameraFOV = val
    end
    R3D.SetCameraFOV(Cfg.FOV)
    CONSOLE_AddMessage("current fov:  " .. Cfg.FOV)
end

function Console:Cmd_CAMERAINTERPOLATION(enable)
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("camerainterpolation 0/1  (disables/enables camera interpolation for MP clients)")
    end
    if enable == 1 then
        Cfg.CameraInterpolation = true
    end
    if enable == 0 then
        Cfg.CameraInterpolation = false
    end
    CAM.EnableInterpolation(Cfg.CameraInterpolation)
    if Cfg.CameraInterpolation then
        CONSOLE_AddMessage("camera interpolation is enabled")
    else
        CONSOLE_AddMessage("camera interpolation is disabled")
    end
end

function Console:Cmd_EXIT()
    Exit()
end

function Console:Cmd_QUIT()
    Exit()
end

function Console:Cmd_TPP(enable, view)
    if IsFinalBuild() then
        return
    end
    enable = tonumber(enable)
    view = tonumber(view)
    if enable == nil then
        CONSOLE_AddMessage("third person view [1/0]")
    end
    if enable == 1 then
        Game.TPP = true
    end
    if enable == 0 then
        Game.TPP = false
    end
    if view == 1 then
        Game.TPPView = true
    end
    if view == 0 then
        Game.TPPView = false
    end
    if Player and Player._Entity then
        ENTITY.EnableDraw(Player._Entity, Game.TPP)
    end
    if Game.TPP then
        CONSOLE_AddMessage("current state: on")
    else
        CONSOLE_AddMessage("current state: off")
    end
end

function Console:Cmd_TIMELIMIT(val)
    val = tonumber(val)
    if val == nil then
        CONSOLE_AddMessage("timelimit value  (sets time limit)")
    elseif type(val) == "number" then
        Cfg.TimeLimit = val
        if Game:IsServer() then
            Game.SetTimeLimit(Cfg.TimeLimit, Game._TimeLimitOut, Game._countTimer)
        end
    end
    CONSOLE_AddMessage("current time limit:  " .. Cfg.TimeLimit)
end

function Console:Cmd_FRAGLIMIT(val)
    val = tonumber(val)
    if val == nil then
        CONSOLE_AddMessage("fraglimit value  (sets frag limit)")
    elseif type(val) == "number" then
        Cfg.FragLimit = val
        if Game:IsServer() then
            Game.SetConfiguration(
                Cfg.AllowBrightskins,
                Cfg.GameMode,
                Cfg.FragLimit,
                Cfg.CaptureLimit,
                Cfg.LMSLives,
                Cfg.TeamDamage,
                Cfg.ClientConsoleLockdown
            )
        end
    end
    CONSOLE_AddMessage("current frag limit:  " .. Cfg.FragLimit)
end

function Console:Cmd_CAPTURELIMIT(val)
    val = tonumber(val)
    if val == nil then
        CONSOLE_AddMessage("capturelimit value  (sets flag capture limit)")
    elseif type(val) == "number" then
        Cfg.CaptureLimit = val
        if Game:IsServer() then
            Game.SetConfiguration(
                Cfg.AllowBrightskins,
                Cfg.GameMode,
                Cfg.FragLimit,
                Cfg.CaptureLimit,
                Cfg.LMSLives,
                Cfg.TeamDamage,
                Cfg.ClientConsoleLockdown
            )
        end
    end
    CONSOLE_AddMessage("current capture limit:  " .. Cfg.CaptureLimit)
end

function Console:Cmd_LMSLIVES(val)
    val = tonumber(val)
    if val == nil then
        CONSOLE_AddMessage("lmslives value  (sets number of lives in LMS mode)")
    elseif type(val) == "number" then
        Cfg.LMSLives = val
        if Game:IsServer() then
            Game.SetConfiguration(
                Cfg.AllowBrightskins,
                Cfg.GameMode,
                Cfg.FragLimit,
                Cfg.CaptureLimit,
                Cfg.LMSLives,
                Cfg.TeamDamage,
                Cfg.ClientConsoleLockdown
            )
        end
    end
    CONSOLE_AddMessage("current LMS lives:  " .. Cfg.LMSLives)
end

function Console:Cmd_WEAPONRESPAWNTIME(val)
    val = tonumber(val)
    if val == nil then
        CONSOLE_AddMessage("weaponrespawntime value  (sets weapon respawn time)")
    elseif type(val) == "number" then
        Cfg.WeaponRespawnTime = val
    end
    CONSOLE_AddMessage("current weapon respawn time:  " .. Cfg.WeaponRespawnTime)
end

function Console:Cmd_CROSSHAIR(val)
    val = tonumber(val)
    if val == nil then
        CONSOLE_AddMessage("crosshair value [1-32] (changes crosshair)")
    elseif type(val) == "number" and val <= 32 and 0 < val then
        Cfg.Crosshair = val
        Cfg:Save()
    end
    CONSOLE_AddMessage("current crosshair:  " .. Cfg.Crosshair)
end

function Console:Cmd_HUDSIZE(val)
    val = tonumber(val)
    if val == nil then
        CONSOLE_AddMessage("hudsize value  (sets HUD size)")
    elseif type(val) == "number" then
        if 3 < val then
            Cfg.HUDSize = 3
        elseif val <= 0 then
            Cfg.HUDSize = 0.1
        else
            Cfg.HUDSize = val
        end
    end
    CONSOLE_AddMessage("current HUD size:  " .. Cfg.HUDSize)
end

function Console:Cmd_SPEEDMETER(enable)
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("shows speed meter [1/0]")
    end
    if enable == 1 then
        Tweak.PlayerMove.ShowSpeedmeter = true
    end
    if enable == 0 then
        Tweak.PlayerMove.ShowSpeedmeter = false
    end
    if Tweak.PlayerMove.ShowSpeedmeter then
        CONSOLE_AddMessage("current state: on")
    else
        CONSOLE_AddMessage("current state: off")
    end
end

function Console:Cmd_NAME(name)
    if name == nil then
        CONSOLE_AddMessage('name "nick" (changes player name)')
    else
        Cfg.PlayerName = HUD.ColorSubstr(tostring(name), 16)
        Cfg.PlayerName = string.gsub(Cfg.PlayerName, "$KILLER", "KILLER")
        Cfg.PlayerName = string.gsub(Cfg.PlayerName, "$PLAYER", "PLAYER")
        if Player and Game.GMode ~= GModes.SingleGame then
            Game.NewPlayerNameRequest(Player.ClientID, Cfg.PlayerName)
        end
    end
    if Game.GMode == GModes.SingleGame and CONSOLE.IsActive() then
        CONSOLE_AddMessage("current player name:  " .. Cfg.PlayerName)
    end
end

function Console:Cmd_POS(x, y, z)
    x = tonumber(x)
    y = tonumber(y)
    z = tonumber(z)
    if x then
        GX = x
    end
    if y then
        GY = y
    end
    if z then
        GZ = z
    end
    CONSOLE_AddMessage(GX .. " " .. GY .. " " .. GZ)
end

function Console:Cmd_ROT(x, y, z)
    x = tonumber(x)
    y = tonumber(y)
    z = tonumber(z)
    if x then
        GAX = x
    end
    if y then
        GAY = y
    end
    if z then
        GAZ = z
    end
    CONSOLE_AddMessage(GAX .. " " .. GAY .. " " .. GAZ)
end

function Console:Cmd_WEAPONSPECULAR(enable)
    enable = tonumber(enable)
    if enable == nil then
        CONSOLE_AddMessage("enables weapon specular [1/0]")
    end
    if enable == 1 then
        Cfg.WeaponSpecular = true
    end
    if enable == 0 then
        Cfg.WeaponSpecular = false
    end
    PainMenu:ReloadWeaponsTextures()
end

function Console:Cmd_DEMOPLAY(filename)
    if filename == nil then
        CONSOLE_AddMessage("Usage: demoplay <filename_to_play_from>")
    else
        CONSOLE.DemoPlay(filename)
    end
end

function Console:Cmd_PLAYDEMO(filename)
    if filename == nil then
        CONSOLE_AddMessage("Usage: playdemo <filename_to_play_from>")
    else
        CONSOLE.DemoPlay(filename)
    end
end

function Console:Cmd_TIMEDEMO(filename)
    if filename == nil then
        CONSOLE_AddMessage("Usage: timedemo <filename_to_play_from>")
    else
        CONSOLE.DemoPlay(filename, true)
    end
end

function Console:Cmd_DEMOPLAYBMP(filename)
    if filename == nil then
        CONSOLE_AddMessage("Usage: demoplaytga <filename_to_play_from>")
    else
        CONSOLE.DemoPlay(filename, true, true)
    end
end

function Console:Cmd_DEMORECORD(filename)
    if filename == nil then
        CONSOLE_AddMessage("Usage: demorecord <filename_to_record_in>")
    else
        CONSOLE.DemoRecord(filename)
        CONSOLE_AddMessage("Demo recording scheduled")
    end
end

function Console:Cmd_RECORDDEMO(filename)
    if filename == nil then
        CONSOLE_AddMessage("Usage: recorddemo <filename_to_record_in>")
    else
        CONSOLE.DemoRecord(filename)
        CONSOLE_AddMessage("Demo recording scheduled")
    end
end

function Console:Cmd_DEMOSTOP()
    CONSOLE.DemoStop()
    CONSOLE_AddMessage("Demo stopped")
end

function Console:Cmd_SHOWFPS(show)
    show = tonumber(show)
    if show == nil then
        CONSOLE_AddMessage("enables FPS display [1/0]")
        return
    end
    if show == 1 then
        Hud._showFPS = true
        Cfg.ShowFPS = true
    end
    if show == 0 then
        Hud._showFPS = false
        Cfg.ShowFPS = false
    end
end

function Console:Cmd_SHOWTIMER(show)
    show = tonumber(show)
    if show == nil then
        CONSOLE_AddMessage("enables timer display [1/0]")
        return
    end
    if show == 1 then
        Hud._showTimer = true
        Cfg.ShowTimer = true
    end
    if show == 0 then
        Hud._showTimer = false
        Cfg.ShowTimer = false
    end
end

function Console:Cmd_SHOWTIMERCOUNTUP(show)
    show = tonumber(show)
    if show == nil then
        CONSOLE_AddMessage("enables timer display [1/0]")
        return
    end
    if show == 1 then
        Cfg.ShowTimerCountUp = true
    end
    if show == 0 then
        Cfg.ShowTimerCountUp = false
    end
end

function Console:OnCommand(cmd)
    local exist = false
    local dontshowerror = false
    cmd = Trim(cmd)
    if cmd == "" then
        return
    end
    local is_cmd = false
    if
        string.find(cmd, "\\", 1, true) == 1 or string.find(cmd, "/", 1, true) == 1 or
            string.find(cmd, ".", 1, true) == 1
     then
        cmd = string.sub(cmd, 2)
        is_cmd = true
    end
    local i = string.find(cmd, " ", 1, true)
    i = i or string.len(cmd) + 1
    if 2 < i and (Game.GMode == GModes.SingleGame or is_cmd == true) then
        local func = string.sub(cmd, 1, i - 1)
        func = string.upper(func)
        if Console["Cmd_" .. func] then
            if Game.GMode == GModes.MultiplayerClient and MPCfg.ClientConsoleLockdown then
                CONSOLE_AddMessage("Console is locked!")
                return
            end
            dontshowerror = true
            if
                not Cfg.TournamentSettings or
                    Cfg.TournamentSettings and
                        (func == "MAP" or func == "RELOADMAP" or func == "TEAM" or func == "SPECTATOR" or
                            func == "READY" or
                            func == "NOTREADY" or
                            func == "BREAK" or
                            func == "KICK" or
                            func == "BANKICK" or
                            func == "KICKID" or
                            func == "BANKICKID" or
                            func == "CALLVOTE" or
                            func == "VOTE" or
                            func == "DISCONNECT" or
                            func == "RECONNECT" or
                            func == "CONNECT" or
                            func == "QUIT" or
                            func == "DEMOPLAY" or
                            func == "DEMOSTOP" or
                            func == "DEMORECORD")
             then
                local params = string.sub(cmd, i + 1)
                local semicolon = string.find(params, ";")
                if semicolon and func ~= "BIND" then
                    local part = string.sub(params, 1, semicolon)
                    local second = string.sub(params, semicolon + 1)
                    params = string.sub(params, 1, semicolon - 1)
                    Console:OnCommand(func .. " " .. params)
                    Console:OnCommand(second)
                    return
                end
                local args = {}
                params = Trim(params)
                for w in string.gfind(params, "[%w~`!@#$%%^&*()%-\" _=%.%+\\|{}%[%]<>?/]+") do
                    table.insert(args, w)
                end
                if func ~= "CALLVOTE" and func ~= "BIND" then
                    Console["Cmd_" .. func](self, unpack(args))
                else
                    Console["Cmd_" .. func](self, params)
                end
                Cfg:Save()
                return
            else
                CONSOLE_AddMessage("This command is disabled.")
            end
        end
    end
    if Game.GMode == GModes.SingleGame or is_cmd == true then
        if IsDedicatedServer() then
            Console:OnPrompt(cmd)
        else
            CONSOLE_AddMessage("Unknown command: " .. cmd)
        end
    else
        cmd = string.sub(cmd, 1, 200)
        Game.SayToAll(NET.GetClientID(), cmd)
    end
end

function Console:OnPrompt(txt)
    txt = Trim(txt)
    if txt == "" then
        return
    end
    if
        string.find(txt, "\\", 1, true) == 1 or string.find(txt, "/", 1, true) == 1 or
            string.find(txt, ".", 1, true) == 1
     then
        txt = string.sub(txt, 2)
    end
    txt = string.upper(txt)
    local commandlist = {}
    for a, o in self, nil do
        if type(o) == "function" then
            local i = string.find(a, "Cmd_", 1, true)
            if i and string.find(a, txt, 5, true) == 5 then
                table.insert(commandlist, string.lower(string.sub(a, 5)))
            end
        end
    end
    if 1 < table.getn(commandlist) then
        local commonPart = commandlist[1]
        CONSOLE_AddMessage(">" .. string.lower(txt))
        table.sort(
            commandlist,
            function(a, b)
                return a < b
            end
        )
        for i, o in commandlist, nil do
            CONSOLE_AddMessage("    " .. o)
            for j = 1, string.len(commonPart) do
                if string.sub(commonPart, j, j) ~= string.sub(o, j, j) then
                    commonPart = string.sub(commonPart, 1, j - 1)
                    break
                end
            end
        end
        txt = commonPart
    elseif table.getn(commandlist) == 1 then
        txt = commandlist[1] .. " "
    end
    CONSOLE.SetCurrentText("\\" .. string.lower(txt))
end

function Console:Cmd_DEMOLIST()
    local files = FS.FindFiles("../Recordings/*.*", 1, 0)
    table.sort(
        files,
        function(a, b)
            return a < b
        end
    )
    CONSOLE_AddMessage("Available demos:")
    for i = 1, table.getn(files) do
        CONSOLE_AddMessage(" " .. files[i])
    end
end

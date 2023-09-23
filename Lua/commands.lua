----- USER COMMANDS -----
Traitormod.AddCommand("!help", function (client, args)
    Traitormod.SendMessage(client, Traitormod.Language.Help)

    return true
end)

Traitormod.AddCommand("!helpadmin", function (client, args)
    Traitormod.SendMessage(client, Traitormod.Language.HelpAdmin)

    return true
end)

Traitormod.AddCommand("!setrpname", function (client, args)
    local playtimerequired = 3.5*60*60 -- 3.5 hours
    local playtime = Traitormod.GetData(client, "Playtime")
    if playtime <= playtimerequired then
        Traitormod.SendMessage(client, string.format(
            Traitormod.Language.CMDLocked,
            Traitormod.FormatTime(playtimerequired),
            Traitormod.FormatTime(math.ceil(playtime or 0))
        ))
        return true
    end

    local name = ""
    for word in args do
        name = name .. " " .. word
    end

    if name == "" or name == " " or name == "nil" or name == "null" then
        Traitormod.SetData(client, "TrueRPName", nil)
    else
        Traitormod.SetData(client, "TrueRPName", name)
        Traitormod.SetData(client, "RPName", name)
        Traitormod.SaveData()
        Traitormod.SendMessage(client, "Your RP name has been set to "..name..". Reminder: Non-realistic names are not tolerated.")
    end

    return true
end)

Traitormod.AddCommand("!name", function (client, args)
    local name = Traitormod.GetData(client, "RPName")

    if name then
        Traitormod.SendMessage(client, "Your RP name is "..name..". You will have this name til your character dies, unless it is set.")
    else
        Traitormod.SendMessage(client, "You do not have a RP name.")
    end

    return true
end)

Traitormod.AddCommand("!helptraitor", function (client, args)
    Traitormod.SendMessage(client, Traitormod.Language.HelpTraitor)

    return true
end)

Traitormod.AddCommand({"!huskchat", "!hc"}, function (client, args)
    if client.Character == nil or not Traitormod.RoleManager.HasRole(client.Character, "Cultist") then
        Traitormod.SendMessage(client, "Only cultists can use this command.")
        return true
    end

    if #args < 1 then
        Traitormod.SendMessage(client, "Usage: !hc or !huskchat [message]")
        return true
    end

    local msg = ""
    for word in args do
        msg = msg .. " " .. word
    end

    Traitormod.SendHuskChatMessage(msg, client)

    return true
end)

Traitormod.AddCommand({"!ooc", "!looc"}, function (client, args)
    if client.Character == nil or client.Character.IsDead then
        Traitormod.SendMessage(client, Traitormod.Language.CMDAliveToUse)
        return true
    end

    if #args < 1 then
        Traitormod.SendMessage(client, "Usage: !ooc [message]")
        return true
    end

    local msg = ""
    for word in args do
        msg = msg .. " " .. word
    end

    local formatedname = string.format(Traitormod.Language.CMDOOCChat, client.Name, client.Character.Name)
    local chatMessage = ChatMessage.Create(formatedname, msg, ChatMessageType.Default)
    chatMessage.Color = Color(0,255,255,255)

    for _, loopclient in pairs(Client.ClientList) do
        local loopchar = loopclient.Character
        if loopchar and not loopchar.IsDead and loopchar.IsHuman then
            local distance = Vector2.Distance(loopchar.WorldPosition, client.Character.WorldPosition)
            if distance <= 1100 then
                Game.SendDirectChatMessage(chatMessage, loopclient)
            end
        end
    end

    return true
end)

Traitormod.AddCommand({"!ahelp", "!adminhelp"}, function (sender, args)
    local discordWebHook = "https://discord.com/api/webhooks/1138861228341604473/Hvrt_BajroUrS60ePpHTT1KQyCNhTwsphdmRmW2VroKXuHLjxKwKRwfajiCZUc-ZtX2L"

    local adminmsg = ""
    if #args > 0 then
        for word in args do
            adminmsg = adminmsg .. " " .. word
        end
    else
        Traitormod.SendMessage(client, "Incorrect usage of !ahelp/!adminhelp CMD. Usage: !ahelp/!adminhelp [msg]")
        return true
    end

    local messageChat = ChatMessage.Create("", "TO ADMINS:\n"..adminmsg, ChatMessageType.Default, nil, sender)
    messageChat.Color = Color.IndianRed

    for client in Client.ClientList do
        if client.HasPermission(ClientPermissions.Kick) then
            Game.SendDirectChatMessage(messageChat, client)
        end
    end

    Game.SendDirectChatMessage(messageChat, sender)

    local finalmsg
    if sender.Character then
        finalmsg = "``User "..sender.Name.." as "..sender.Character.Name..":`` "..adminmsg
    else
        finalmsg = "``User "..sender.Name..":`` "..adminmsg
    end

    local function escapeQuotes(str)
        return str:gsub("\"", "\\\"")
    end

    local escapedMessage = escapeQuotes(finalmsg)
    Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..'ADMIN HELP (HUSK SURVIVAL)'..'\"}')

    return true
end)

Traitormod.AddCommand("!version", function (client, args)
    Traitormod.SendMessage(client, "Running Evil Factory's Traitor Mod v" .. Traitormod.VERSION)

    return true
end)

Traitormod.AddCommand({"!role", "!traitor"}, function (client, args)
    if client.Character == nil or client.Character.IsDead then
        Traitormod.SendMessage(client, "You need to be alive to use this command.")
        return true
    end

    local role = Traitormod.RoleManager.GetRole(client.Character)
    if role == nil then
        Traitormod.SendMessage(client, "You have no special role.")
    else
        Traitormod.SendMessage(client, role:Greet())
    end

    return true
end)

Traitormod.AddCommand({"!roles", "!traitors"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local roles = {}

    for character, role in pairs(Traitormod.RoleManager.RoundRoles) do
        if not roles[role.Name] then
            roles[role.Name] = {}
        end

        table.insert(roles[role.Name], character.Name)
    end

    local message = ""

    for roleName, r in pairs(roles) do
        message = message .. roleName .. ": "
        for _, name in pairs(r) do
            message = message .. "\"" .. name .. "\" "
        end
        message = message .. "\n\n"
    end

    if message == "" then message = "None." end

    Traitormod.SendMessage(client, message)

    return true
end)

Traitormod.AddCommand("!traitoralive", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    for _, character in pairs(Traitormod.RoleManager.FindAntagonists()) do
        if not character.IsDead then
            Traitormod.SendMessage(client, Traitormod.Language.TraitorsAlive)
            return true
        end
    end

    Traitormod.SendMessage(client, Traitormod.Language.AllTraitorsDead)
    return true
end)

Traitormod.AddCommand("!toggletraitor", function (client, args)
    local text = Traitormod.Language.CommandNotActive

    if Traitormod.Config.OptionalTraitors then
        local toggle = false
        if #args > 0 then
            toggle = string.lower(args[1]) == "on"
        else
            toggle = Traitormod.GetData(client, "NonTraitor") == true
        end
    
        if toggle then
            text = Traitormod.Language.TraitorOn
        else
            text = Traitormod.Language.TraitorOff
        end
        Traitormod.SetData(client, "NonTraitor", not toggle)
        Traitormod.SaveData() -- move this to player disconnect someday...
        
        Traitormod.Log(Traitormod.ClientLogName(client) .. " can become traitor: " .. tostring(toggle))
    end

    Traitormod.SendMessage(client, text)

    return true
end)

Traitormod.AddCommand({"!point", "!points", "!money"}, function (client, args)
    Traitormod.SendMessage(client, Traitormod.GetDataInfo(client, true))

    return true
end)

Traitormod.AddCommand("!info", function (client, args)
    Traitormod.SendWelcome(client)
    
    return true
end)

Traitormod.AddCommand({"!suicide", "!kill", "!death"}, function (client, args)
    if client.Character == nil or client.Character.IsDead then
        Traitormod.SendMessage(client, "You are already dead!")
        return true
    end

    if client.Character.IsHuman then
        local item = client.Character.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)
        if item ~= nil and item.Prefab.Identifier == "handcuffs" then
            Traitormod.SendMessage(client, "You cant use this command while handcuffed.")
            return true
        end

        if client.Character.IsKnockedDown then
            Traitormod.SendMessage(client, "You cant this command while knocked down.")
            return true
        end
    end

    if Traitormod.GhostRoles.ReturnGhostRole(client.Character) then
        client.SetClientCharacter(nil)
    else
        client.Character.Kill(CauseOfDeathType.Unknown)
    end
    return true
end)

----- ADMIN COMMANDS -----
Traitormod.AddCommand("!alive", function (client, args)
    if not (client.Character == nil or client.Character.IsDead) and not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if not Game.RoundStarted or Traitormod.SelectedGamemode == nil then
        Traitormod.SendMessage(client, Traitormod.Language.RoundNotStarted)

        return true
    end

    local msg = ""
    for index, value in pairs(Client.ClientList) do
        if value.Character and value.Character.IsHuman and not value.Character.IsBot then
            local job = tostring(value.Character.Info.Job.Prefab.Name)
            if job == "Meltwater Region Admin" then
                job = "Melt Admin"
            elseif job == "Azoe Region Admin" then
                job = "Azoe Admin"
            elseif job == "Meltwater Security" then
                job = "Melt Security"
            elseif job == "Cave Dweller" then
                job = "C. Dweller"
            elseif job == "Medical Doctor" then
                job = "Medic"
            end

            if value.Character.IsDead then
                msg = msg .. value.Name .. " ---- " .. Traitormod.Language.Dead .. " as " .. job .. " " ..value.Character.Name .."\n"
            else
                msg = msg .. value.Name .. " ++++ " .. Traitormod.Language.Alive .. " as " .. job .. " " .. value.Character.Name .."\n"
            end
        end
    end
    if msg == "" then msg = Traitormod.Language.CMDAliveNoPlayers end

    Traitormod.SendMessage(client, msg)

    return true
end)

Traitormod.AddCommand("!spawn", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    if not Game.RoundStarted then 
        Game.SendDirectChatMessage("", "The game hasn't started yet.", nil, ChatMessageType.Error, client)
        return true
    end

    local spawnClient = client

    if #args > 0 then
        -- if client name is given, revive related character
        local name = table.remove(args, 1)
        -- find character by client name
        for player in Client.ClientList do
            if player.Name == name or player.SteamID == name then
                spawnClient = player
            end
        end
    end

    if spawnClient.Character == nil or spawnClient.Character.IsDead then
        Traitormod.MidRoundSpawn.TryCreateClientCharacter(Submarine.MainSub, spawnClient)
        Game.SendDirectChatMessage("", "Character of ".. Traitormod.ClientLogName(spawnClient) .. " successfully spawned.", nil, ChatMessageType.Server, client)
    else
        Game.SendDirectChatMessage("", "Character of " .. Traitormod.ClientLogName(spawnClient) .. " is alive.", nil, ChatMessageType.Error, client)
    end

    return true
end)

Traitormod.AddCommand("!pdatci", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    if not Game.RoundStarted then return end

    local feedback = ""
    local msg = ""

    if #args > 0 then
        for word in args do
            msg = msg .. " " .. word
        end
        feedback = string.format(Traitormod.Language.CMDPDAFeedback, msg, "Centrum Institute")
    else
        feedback = "Usage: !pda [Message]"
    end

    Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)
    if msg == "" then return true end

    Traitormod.RoundEvents.SendEventMessage(msg, nil, "tci")
    return true
end)

Traitormod.AddCommand("!pdaazoe", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    if not Game.RoundStarted then return end

    local feedback = ""
    local msg = ""

    if #args > 0 then
        for word in args do
            msg = msg .. " " .. word
        end
        feedback = string.format(Traitormod.Language.CMDPDAFeedback, msg, "Azoe Region")
    else
        feedback = "Usage: !pda [Message]"
    end

    Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)
    if msg == "" then return true end
    
    Traitormod.RoundEvents.SendEventMessage(msg, nil, "azoe")
    return true
end)

Traitormod.AddCommand("!pda", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    if not Game.RoundStarted then return end

    local feedback = ""
    local msg = ""

    if #args > 0 then
        for word in args do
            msg = msg .. " " .. word
        end
        feedback = string.format(Traitormod.Language.CMDPDAFeedback, msg, "Both Regions")
    else
        feedback = "Usage: !pda [Message]"
    end

    Game.SendDirectChatMessage("", feedback, nil, Traitormod.Config.ChatMessageType, client)
    if msg == "" then return true end

    Traitormod.RoundEvents.SendEventMessage(msg, nil, "both")
    return true
end)

Traitormod.AddCommand("!roundinfo", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if Game.RoundStarted and Traitormod.SelectedGamemode and Traitormod.SelectedGamemode.RoundSummary then
        local summary = Traitormod.SelectedGamemode:RoundSummary()
        Traitormod.SendMessage(client, summary)
    elseif Game.RoundStarted and not Traitormod.SelectedGamemode then
        Traitormod.SendMessage(client, "Gamemode: None")
    elseif Traitormod.LastRoundSummary ~= nil then
        Traitormod.SendMessage(client, Traitormod.LastRoundSummary)
    else
        Traitormod.SendMessage(client, Traitormod.Language.RoundNotStarted)
    end

    return true
end)

Traitormod.AddCommand({"!allpoint", "!allpoints"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
    local messageToSend = ""

    for index, value in pairs(Client.ClientList) do
        messageToSend = messageToSend .. "\n" .. value.Name .. ": " .. math.floor(Traitormod.GetData(value, "Points") or 0) .. " Points - " .. math.floor(Traitormod.GetData(value, "Weight") or 0) .. " Weight"
    end

    Traitormod.SendMessage(client, messageToSend)

    return true
end)

Traitormod.AddCommand({"!traitorcom"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 1 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !traitorcom [msg] - If you need to announce something with more than one word, surround it in quotations.")
    
        return true
    end

    local text = table.remove(args, 1)

    for key, player in pairs(Client.ClientList) do
        if player and player.Character and player.HasPermission(ClientPermissions.ConsoleCommands) or Traitormod.RoleManager.HasRole(player.Character, "Traitor") then
            Traitormod.SendTraitorMessageBox(player, text)
        end
    end

    return true
end)

Traitormod.AddCommand({"!cultistcom"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 1 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !traitorcom [msg] - If you need to announce something with more than one word, surround it in quotations.")
    
        return true
    end

    local text = table.remove(args, 1)

    for key, player in pairs(Client.ClientList) do
        if player and player.Character and player.HasPermission(ClientPermissions.ConsoleCommands) or Traitormod.RoleManager.HasRole(player.Character, "Cultist") then
            Traitormod.SendTraitorMessageBox(player, text, "oneofus")
        end
    end

    return true
end)

Traitormod.AddCommand({"!funny"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    spawnPosition = Submarine.MainSub.WorldPosition

    local funnyClient = client

    if #args > 0 then
        -- if client name is given, revive related character
        local name = table.remove(args, 1)
        -- find character by client name
        for player in Client.ClientList do
            if player.Name == name or player.SteamID == name then
                funnyClient = player
            end
        end
    end

    Entity.Spawner.AddCharacterToSpawnQueue("mudraptor", spawnPosition, function (character)
        funnyClient.SetClientCharacter(character)
        character.TeamID = CharacterTeamType.Team1
    end)

    return true
end)

Traitormod.AddCommand({"!addpoint", "!addpoints"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then
        Traitormod.SendMessage(client, "You do not have permissions to add points.")
        return
    end
    
    if #args < 2 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !addpoint \"Client Name\" 500")

        return true
    end

    local name = table.remove(args, 1)
    local amount = tonumber(table.remove(args, 1))

    if amount == nil or amount ~= amount then
        Traitormod.SendMessage(client, "Invalid number value.")
        return true
    end

    if name == "all" then
        for index, value in pairs(Client.ClientList) do
            Traitormod.AddData(value, "Points", amount)
        end

        Traitormod.SendMessage(client, string.format(Traitormod.Language.PointsAwarded, amount), "InfoFrameTabButton.Mission")

        local msg = string.format("Admin added %s points to everyone.", amount)
        Traitormod.SendMessageEveryone(msg)
        msg = Traitormod.ClientLogName(client) .. ": " .. msg
        Traitormod.Log(msg)

        return true
    end

    local found = Traitormod.FindClient(name)

    if found == nil then
        Traitormod.SendMessage(client, "Couldn't find a client with name / steamID " .. name)
        return true
    end

    Traitormod.AddData(found, "Points", amount)

    Traitormod.SendMessage(client, string.format(Traitormod.Language.PointsAwarded, amount), "InfoFrameTabButton.Mission")

    local msg = string.format("Admin added %s points to %s.", amount, Traitormod.ClientLogName(found))
    Traitormod.SendMessageEveryone(msg)
    msg = Traitormod.ClientLogName(client) .. ": " .. msg
    Traitormod.Log(msg)

    return true
end)

Traitormod.AddCommand({"!addlife", "!addlive", "!addlifes", "!addlives"}, function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 1 then
        Traitormod.SendMessage(client, "Incorrect amount of arguments. usage: !addlife \"Client Name\" 1")

        return true
    end

    local name = table.remove(args, 1)

    local amount = 1
    if #args > 0 then
        amount = tonumber(table.remove(args, 1))
    end

    if amount == nil or amount ~= amount then
        Traitormod.SendMessage(client, "Invalid number value.")
        return true
    end

    local gainLifeClients = {}
    if string.lower(name) == "all" then
        gainLifeClients = Client.ClientList
    else
        local found = Traitormod.FindClient(name)

        if found == nil then
            Traitormod.SendMessage(client, "Couldn't find a client with name / steamID " .. name)
            return true
        end
        table.insert(gainLifeClients, found)
    end

    for lifeClient in gainLifeClients do
        local lifeMsg, lifeIcon = Traitormod.AdjustLives(lifeClient, amount)
        local msg = string.format("Admin added %s lives to %s.", amount, Traitormod.ClientLogName(lifeClient))

        if lifeMsg then
            Traitormod.SendMessage(lifeClient, lifeMsg, lifeIcon)
            Traitormod.SendMessageEveryone(msg)
        else
            Game.SendDirectChatMessage("", Traitormod.ClientLogName(lifeClient) .. " already has maximum lives.", nil, Traitormod.Config.Error, client)
        end
    end

    return true
end)

local voidPos = {}

Traitormod.AddCommand("!void", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local target = Traitormod.FindClient(args[1])

    if not target then
        Traitormod.SendMessage(client, "Couldn't find a client with specified name / steamID")
        return true
    end

    if target.Character == nil or target.Character.IsDead then
        Traitormod.SendMessage(client, "Client's character is dead or non-existent.")
        return true
    end

    voidPos[target.Character] = target.Character.WorldPosition
    target.Character.TeleportTo(Vector2(0, Level.Loaded.Size.Y + 100000))
    target.Character.GodMode = true

    Traitormod.SendMessage(client, "Sent the character to the void.")

    return true
end)

Traitormod.AddCommand("!unvoid", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local target = Traitormod.FindClient(args[1])

    if not target then
        Traitormod.SendMessage(client, "Couldn't find a client with specified name / steamID")
        return true
    end

    if target.Character == nil or target.Character.IsDead then
        Traitormod.SendMessage(client, "Client's character is dead or non-existent.")
        return true
    end

    target.Character.TeleportTo(voidPos[target.Character])
    target.Character.GodMode = false
    voidPos[target.Character] = nil
    
    Traitormod.SendMessage(client, "Remove character from the void.")

    return true
end)

Traitormod.AddCommand("!revive", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local reviveClient = client

    if #args > 0 then
        -- if client name is given, revive related character
        local name = table.remove(args, 1)
        -- find character by client name
        for player in Client.ClientList do
            if player.Name == name or player.SteamID == name then
                reviveClient = player
            end
        end
    end

    if reviveClient.Character and reviveClient.Character.IsDead then
        reviveClient.Character.Revive()
        Timer.Wait(function ()
            reviveClient.SetClientCharacter(reviveClient.Character)
        end, 1500)
        local liveMsg, liveIcon = Traitormod.AdjustLives(reviveClient, 1)

        if liveMsg then
            Traitormod.SendMessage(reviveClient, liveMsg, liveIcon)
        end

        Game.SendDirectChatMessage("", "Character of " .. Traitormod.ClientLogName(reviveClient) .. " revived and given back 1 life.", nil, ChatMessageType.Error, client)
        Traitormod.SendMessageEveryone(string.format("Admin revived %s", Traitormod.ClientLogName(reviveClient)))

    elseif reviveClient.Character then
        Game.SendDirectChatMessage("", "Character of " .. Traitormod.ClientLogName(reviveClient) .. " is not dead.", nil, ChatMessageType.Error, client)
    else
        Game.SendDirectChatMessage("", "Character of " .. Traitormod.ClientLogName(reviveClient) .. " not found.", nil, ChatMessageType.Error, client)
    end

    return true
end)

Traitormod.AddCommand({"!apm", "!adminpm"}, function (sender, args)
    if not sender.HasPermission(ClientPermissions.Kick) then return end

    local adminmsg = ""
    local targetClient = nil
    if #args > 1 then
        targetClient = table.remove(args, 1)
        -- find character by client name
        for client in Client.ClientList do
            if client.Name == targetClient or client.SteamID == targetClient then
                targetClient = client
                break
            end
        end

        -- get the message to be pm'd
        for word in args do
            adminmsg = adminmsg .. " " .. word
        end
    else
        return true
    end

    if targetClient == nil then
        Traitormod.SendMessage(sender, "That player does not exist.")
        return true
    end

    local finalmsg = adminmsg.."\n\nTo respond, type use the admin help button or the command !adminhelp."
    local messageChat = ChatMessage.Create("", "ADMIN PM:\n"..finalmsg, ChatMessageType.Default, nil, sender)
    messageChat.Color = Color.IndianRed

    Game.SendDirectChatMessage(messageChat, targetClient)

    for client in Client.ClientList do
        if client.HasPermission(ClientPermissions.Kick) then
            Game.SendDirectChatMessage(messageChat, client)
        end
    end

    local discordWebHook = "https://discord.com/api/webhooks/1138861228341604473/Hvrt_BajroUrS60ePpHTT1KQyCNhTwsphdmRmW2VroKXuHLjxKwKRwfajiCZUc-ZtX2L"
    local hookmsg = string.format("``Admin %s`` to ``User %s:`` %s", sender.Name, targetClient.Name, adminmsg)

    local function escapeQuotes(str)
        return str:gsub("\"", "\\\"")
    end

    local escapedMessage = escapeQuotes(hookmsg)
    Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..'ADMIN HELP (HUSK SURVIVAL)'..'\"}')

    return true
end)

Traitormod.AddCommand("!ongoingevents", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    local text = "On Going Events: "
    for key, value in pairs(Traitormod.RoundEvents.OnGoingEvents) do
        text = text .. "\"" .. value.Name .. "\" "
    end

    Traitormod.SendMessage(client, text)

    return true
end)

Traitormod.AddCommand("!giveghostrole", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
    if #args < 2 then
        Traitormod.SendMessage(client, "Usage: !giveghostrole <ghost role name> <character>")
        return true
    end

    local target

    for key, value in pairs(Character.CharacterList) do
        if value.Name == args[2] and not value.IsDead then
            target = value
            break
        end
    end

    if not target then
        Traitormod.SendMessage(client, "Couldn't find a character with specified name")
        return true
    end

    Traitormod.GhostRoles.Ask(args[1], function (ghostClient)
        Traitormod.LostLivesThisRound[ghostClient.SteamID] = false

        ghostClient.SetClientCharacter(target)
    end, target)

    return true
end)

Traitormod.AddCommand("!roundtime", function (client, args)
    Traitormod.SendMessage(client, "This round has been going for " .. math.floor(Traitormod.RoundTime / 60) .. " minutes.")

    return true
end)

Traitormod.AddCommand("!assignrolecharacter", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
    if #args < 2 then
        Traitormod.SendMessage(client, "Usage: !assignrole <character> <role>")
        return true
    end

    local target

    for key, value in pairs(Character.CharacterList) do
        if value.Name == args[1] then
            target = value
            break
        end
    end

    if not target then
        Traitormod.SendMessage(client, "Couldn't find a character with specified name")
        return true
    end

    if target == nil or target.IsDead then
        Traitormod.SendMessage(client, "Client's character is dead or non-existent.")
        return true
    end

    local role = Traitormod.RoleManager.Roles[args[2]]

    if role == nil then
        Traitormod.SendMessage(client, "Couldn't find role to assign.")
        return true
    end

    if Traitormod.RoleManager.GetRole(target) ~= nil then
        Traitormod.RoleManager.RemoveRole(target)
    end
    Traitormod.RoleManager.AssignRole(target, role:new())

    Traitormod.SendMessage(client, "Assigned " .. target.Name .. " the role " .. role.Name .. ".")

    return true
end)

Traitormod.AddCommand("!assignrole", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end
    
    if #args < 2 then
        Traitormod.SendMessage(client, "Usage: !assignrole <client> <role>")
        return true
    end

    local target = Traitormod.FindClient(args[1])

    if not target then
        Traitormod.SendMessage(client, "Couldn't find a client with specified name / steamID")
        return true
    end

    if target.Character == nil or target.Character.IsDead then
        Traitormod.SendMessage(client, "Client's character is dead or non-existent.")
        return true
    end

    local role = Traitormod.RoleManager.Roles[args[2]]

    if role == nil then
        Traitormod.SendMessage(client, "Couldn't find role to assign.")
        return true
    end

    local targetCharacter = target.Character

    if Traitormod.RoleManager.GetRole(targetCharacter) ~= nil then
        Traitormod.RoleManager.RemoveRole(targetCharacter)
    end
    Traitormod.RoleManager.AssignRole(targetCharacter, role:new())

    Traitormod.SendMessage(client, "Assigned " .. target.Name .. " the role " .. role.Name .. ".")

    return true
end)

Traitormod.AddCommand("!triggerevent", function (client, args)
    if not client.HasPermission(ClientPermissions.ConsoleCommands) then return end

    if #args < 1 then
        Traitormod.SendMessage(client, "Usage: !triggerevent <event name>")
        return true
    end

    local event = nil
    for _, value in pairs(Traitormod.RoundEvents.EventConfigs.Events) do
        if value.Name == args[1] then
            event = value
        end
    end

    if event == nil then
        Traitormod.SendMessage(client, "Event " .. args[1] .. " doesnt exist.")
        return true
    end

    Traitormod.RoundEvents.TriggerEvent(event.Name)
    Traitormod.SendMessage(client, "Triggered event " .. event.Name)

    return true
end)

Traitormod.AddCommand({"!locatesub", "!locatesubmarine"}, function (client, args)
    if client.Character == nil or not client.InGame then
        Traitormod.SendMessage(client, "You must be alive to use this command.")
        return true
    end

    if client.Character.IsHuman and client.Character.TeamID == CharacterTeamType.Team1 then
        Traitormod.SendMessage(client, "Only monsters are able to use this command.")
        return true
    end

    local center = client.Character.WorldPosition
    local target = Submarine.MainSub.WorldPosition

    local distance = Vector2.Distance(center, target) * Physics.DisplayToRealWorldRatio

    local diff = center - target

    local angle = math.deg(math.atan2(diff.X, diff.Y)) + 180

    local function degreeToOClock(v)
        local oClock = math.floor(v / 30)
        if oClock == 0 then oClock = 12 end
        return oClock .. " o'clock"
    end

    Game.SendDirectChatMessage("", "Submarine is " .. math.floor(distance) .. "m away from you, at " .. degreeToOClock(angle) .. ".", nil, ChatMessageType.Error, client)

    return true
end)


local preventSpam = {}
Traitormod.AddCommand({"!droppoints", "!droppoint", "!dropoint", "!dropoints"}, function (client, args)
    if preventSpam[client] ~= nil and Timer.GetTime() < preventSpam[client] then
        Traitormod.SendMessage(client, "Please wait a bit before using this command again.")
        return true
    end

    if client.Character == nil or client.Character.IsDead or client.Character.Inventory == nil then
        Traitormod.SendMessage(client, "You must be alive to use this command.")
        return true
    end

    if #args < 1 then
        Traitormod.SendMessage(client, "Usage: !droppoints amount")
        return true
    end

    local amount = tonumber(args[1])

    if amount == nil or amount ~= amount or amount < 100 or amount > 100000 then
        Traitormod.SendMessage(client, "Please specify a valid number between 100 and 100000.")
        return true
    end

    local availablePoints = Traitormod.GetData(client, "Points") or 0

    if amount > availablePoints then
        Traitormod.SendMessage(client, "You don't have enough points to drop.")
        return true
    end

    Traitormod.SpawnPointItem(client.Character.Inventory, tonumber(amount))
    Traitormod.SetData(client, "Points", availablePoints - amount)

    preventSpam[client] = Timer.GetTime() + 5

    return true
end)

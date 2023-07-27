local re = {}

LuaUserData.RegisterType("Barotrauma.EventManager") -- temporary

re.OnGoingEvents = {}

re.ThisRoundEvents = {}
re.EventConfigs = Traitormod.Config.RandomEventConfig

re.AllowedEvents = {}

re.IsEventActive = function (eventName)
    if re.OnGoingEvents[eventName] then
        return true
    end
    return false
end

re.EventExists = function (eventName)
    local event = nil
    for _, value in pairs(re.EventConfigs.Events) do
        if value.Name == eventName then
            event = value
        end
    end

    return event ~= nil
end

re.TriggerEvent = function (eventName)
    if not Game.RoundStarted then
        Traitormod.Error("Tried to trigger event " .. eventName .. ", but round is not started.")
        return
    end

    if re.OnGoingEvents[eventName] then
        Traitormod.Error("Event " .. eventName .. " is already running.")
        return
    end

    local event = nil
    for _, value in pairs(re.EventConfigs.Events) do
        if value.Name == eventName then
            event = value
        end
    end

    if event == nil then
        Traitormod.Error("Tried to trigger event " .. eventName .. " but it doesnt exist or is disabled.")
        return
    end

    local originalEnd = event.End
    event.End = function (isRoundEnd)
        re.OnGoingEvents[eventName] = nil
        originalEnd(isRoundEnd)
    end

    Traitormod.Stats.AddStat("EventTriggered", event.Name, 1)

    re.OnGoingEvents[eventName] = event
    event.Start()

    if re.ThisRoundEvents[eventName] == nil then
        re.ThisRoundEvents[eventName] = 0
    end
    re.ThisRoundEvents[eventName] = re.ThisRoundEvents[eventName] + 1

    Traitormod.Log("Event " .. eventName .. " triggered.")
end

re.CheckRandomEvent = function (event)
    if event.MinRoundTime ~= nil and Traitormod.RoundTime / 60 < event.MinRoundTime then
        return
    end

    if event.MaxRoundTime ~= nil and Traitormod.RoundTime / 60 > event.MaxRoundTime then
        return
    end

    local intensity = Game.GameSession.EventManager.CurrentIntensity

    if event.MinIntensity ~= nil and intensity < event.MinIntensity then
        return
    end

    if event.MaxIntensity ~= nil and intensity > event.MaxIntensity then
        return
    end

    if math.random() > event.ChancePerMinute then
        return
    end

    Traitormod.Log("Selected random event to trigger \"" .. event.Name .. "\" with intensity " .. intensity .. " and round time " .. Traitormod.RoundTime / 60 .. " minutes.")

    re.TriggerEvent(event.Name)
end

re.SendEventMessage = function (text, icon, flavortext)
    text = "NOTICE: "..text

    for key, value in pairs(Client.ClientList) do
        local messageChat = ChatMessage.Create("", flavortext, ChatMessageType.Default, nil, nil)
        messageChat.Color = Color(200, 30, 241, 255)
        local messageBox = ChatMessage.Create("", flavortext, ChatMessageType.ServerMessageBoxInGame, nil, nil)

        if value.Character and not value.Character.IsDead and value.Character.IsHuman then
            if value.Character.Inventory.FindItemByIdentifier("admindeviceazoe", true) then
                messageChat = ChatMessage.Create("ADMINISTRATOR PDA", text, ChatMessageType.Default, nil, nil)
                messageBox = ChatMessage.Create("", text, ChatMessageType.ServerMessageBoxInGame, nil, nil)
                messageBox.IconStyle = icon
                messageChat.Color = Color.DeepSkyBlue
            elseif value.Character.Inventory.FindItemByIdentifier("admindevicemelt", true) then
                messageChat = ChatMessage.Create("ADMINISTRATOR PDA", text, ChatMessageType.Default, nil, nil)
                messageBox = ChatMessage.Create("", text, ChatMessageType.ServerMessageBoxInGame, nil, nil)
                messageBox.IconStyle = icon
                messageChat.Color = Color.Khaki
            end
        elseif not value.Character or value.Character.IsDead or not value.Character.IsHuman then
            messageChat = ChatMessage.Create("ADMINISTRATOR PDA", text, ChatMessageType.Default, nil, nil)
            messageBox = ChatMessage.Create("", text, ChatMessageType.ServerMessageBoxInGame, nil, nil)
            messageBox.IconStyle = icon
            messageChat.Color = Color.Khaki
        end

        Game.SendDirectChatMessage(messageBox, value)
        Game.SendDirectChatMessage(messageChat, value)
    end 
end

local lastRandomEventCheck = 0
Hook.Add("think", "TraitorMod.RoundEvents.Think", function ()
    if not Game.RoundStarted then return end

    if Timer.GetTime() > lastRandomEventCheck then
        for _, event in pairs(re.EventConfigs.Events) do
            if re.OnGoingEvents[event.Name] == nil and re.AllowedEvents[event.Name] then
                if not event.OnlyOncePerRound or re.ThisRoundEvents[event.Name] == nil then
                    re.CheckRandomEvent(event)
                end
            end
        end
        lastRandomEventCheck = Timer.GetTime() + 60
    end
end)

re.Initialize = function (allowedEvents)
    re.AllowedEvents = {}

    if allowedEvents == nil then
        for key, value in pairs(re.EventConfigs.Events) do
            re.AllowedEvents[value.Name] = true
        end
    else
        for key, value in pairs(allowedEvents) do
            re.AllowedEvents[value] = true
        end
    end
end

re.EndRound = function ()
    for key, value in pairs(re.OnGoingEvents) do
        value.End(true)
        re.OnGoingEvents[key] = nil
    end

    re.ThisRoundEvents = {}
    re.AllowedEvents = {}
end

for _, value in pairs(re.EventConfigs.Events) do
    if value.Init then value.Init() end
end

return re
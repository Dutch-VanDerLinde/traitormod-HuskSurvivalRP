local part = 1

if SERVER then
    -- Functions
    local function HideIntercomButton(client, team)
        local message = Networking.Start("IntercomHide")
        message.WriteString(team)
        Networking.Send(message, client.Connection)
    end

    local function ShowIntercomButton(client, team)
        local message = Networking.Start("IntercomShow")
        message.WriteString(team)
        Networking.Send(message, client.Connection)
    end

    local function AddStaticToMessage(msg, chance)
        for i = 1, #msg do
            local c = msg:sub(i,i)

            if math.random(1, chance) == 1 then
                msg = msg.gsub(msg, c, "-")
            end
        end

        return msg
    end

    -- Hooks
    Hook.Add("item.interact", "UICheckInteract", function(item, character)
        local client = Traitormod.FindClientCharacter(character)

        if character and character.IsHuman then
            if item.Prefab.Identifier == "idcard" then
                if item.GetComponentString("IdCard").OwnerJobId == "adminone" then
                    ShowIntercomButton(client, "azoe")
                 elseif item.GetComponentString("IdCard").OwnerJobId == "admintwo" then
                    ShowIntercomButton(client, "melt")
                 end
             end
        end
    end)
    
    Hook.Add("item.equip", "UICheckEquip", function(item, character)
        local client = Traitormod.FindClientCharacter(character)

        if character and character.IsHuman then
            if item.Prefab.Identifier == "idcard" then
                if item.GetComponentString("IdCard").OwnerJobId == "adminone" then
                    ShowIntercomButton(client, "azoe")
                 elseif item.GetComponentString("IdCard").OwnerJobId == "admintwo" then
                    ShowIntercomButton(client, "melt")
                 end
             end
        end
    end)

    -- Send Message to Azoe Linea
    Networking.Receive("azoecom", function(message, sender)
        local announcement = message.ReadString()

        if sender.Character and sender.Character.IsHuman and not sender.Character.IsDead then
            local idcard = sender.Character.Inventory.FindItemByIdentifier("idcard")
            local comms = Traitormod.GetRandomJobWaypoint("adminone")
            local senderdistance = Vector2.Distance(sender.Character.WorldPosition, comms.WorldPosition)

            if sender.Character.LockHands
                or sender.Character.IsRagdolled
                or sender.Character.IsUnconscious
                or HF.HasAffliction(sender.Character,"sym_unconsciousness",1)
                or HF.HasAffliction(sender.Character,"anesthesia",1)
            then
                Traitormod.SendMessage(sender, "You cannot use the intercom at this time!")
                return
            end

            if senderdistance > 10000 then
                Traitormod.SendMessage(sender, "You are too far from the station to use the intercom!")
                return
            end

            if idcard and idcard.GetComponentString("IdCard").OwnerJobId == "adminone" then
                for key, client in pairs(Client.ClientList) do
                    if client.Character and not client.Character.IsDead then
                        local radio = false
                        local distance = Vector2.Distance(client.Character.WorldPosition, comms.WorldPosition)
                        local messageChat = ChatMessage.Create("INTERCOM", announcement, ChatMessageType.Default, nil, nil)
                        local messageBox = ChatMessage.Create("", "INTERCOM: "..announcement, ChatMessageType.ServerMessageBoxInGame, nil, nil)
                        messageBox.Color = Color.DeepSkyBlue

                        for item in client.Character.Inventory.AllItems do
                            if item.HasTag("mobileradio") then
                                local battery = item.OwnInventory.GetItemAt(0)
                                if battery and battery.Condition > 0.1 then
                                    radio = true
                                    break
                                end
                            end
                        end

                        -- If the player doesn't have a radio then it only announces if they're near the station
                        if radio then
                            if distance >= 25000 then
                                announcement = AddStaticToMessage(announcement, math.random(3, 4))
                                messageChat = ChatMessage.Create("???", announcement, ChatMessageType.Default, nil, nil)
                                messageChat.Color = Color.White
                            elseif distance >= 15000 then --and distance <= 15000 then
                                announcement = AddStaticToMessage(announcement, math.random(5, 6))
                                messageChat = ChatMessage.Create("INTERCOM", announcement, ChatMessageType.Default, nil, nil)
                                messageChat.Color = Color.White
                            else
                                messageChat.Color = Color.DeepSkyBlue
                            end

                            if distance <= 30000 then
                                Game.SendDirectChatMessage(messageChat, client)
                            end
                        end

                        if distance <= 15000 then
                            Game.SendDirectChatMessage(messageBox, client)
                        end
                    end
                end
            else
                HideIntercomButton(sender, "azoe")
            end
        else
            HideIntercomButton(sender, "azoe")
        end
    end)

    -- Send Message to Meltwater
    Networking.Receive("meltcom", function(message, sender)
        local announcement = message.ReadString()

        if sender.Character and sender.Character.IsHuman and not sender.Character.IsDead then
            local idcard = sender.Character.Inventory.FindItemByIdentifier("idcard")
            local comms = Traitormod.GetRandomJobWaypoint("admintwo")
            local senderdistance = Vector2.Distance(sender.Character.WorldPosition, comms.WorldPosition)

            if sender.Character.LockHands
                or sender.Character.IsRagdolled
                or sender.Character.IsUnconscious
                or HF.HasAffliction(sender.Character,"sym_unconsciousness",1)
                or HF.HasAffliction(sender.Character,"anesthesia",1)
            then
                Traitormod.SendMessage(sender, "You cannot use the intercom at this time!")
                return
            end

            if senderdistance > 10000 then
                Traitormod.SendMessage(sender, "You are too far from the station to use the intercom!")
                return
            end

            if idcard and idcard.GetComponentString("IdCard").OwnerJobId == "admintwo" then
                for key, client in pairs(Client.ClientList) do
                    if client.Character and not client.Character.IsDead then
                        local radio = false
                        local distance = Vector2.Distance(client.Character.WorldPosition, comms.WorldPosition)
                        local messageChat = ChatMessage.Create("INTERCOM", announcement, ChatMessageType.Default, nil, nil)
                        local messageBox = ChatMessage.Create("", "INTERCOM: "..announcement, ChatMessageType.ServerMessageBoxInGame, nil, nil)
                        messageBox.Color = Color.Khaki

                        for item in client.Character.Inventory.AllItems do
                            if item.HasTag("mobileradio") then
                                local battery = item.OwnInventory.GetItemAt(0)
                                if battery and battery.Condition > 0.1 then
                                    radio = true
                                    break
                                end
                            end
                        end

                        -- If the player doesn't have a radio then it only announces if they're near the station
                        if radio then
                            if distance >= 25000 then
                                announcement = AddStaticToMessage(announcement, math.random(3, 4))
                                messageChat = ChatMessage.Create("???", announcement, ChatMessageType.Default, nil, nil)
                                messageChat.Color = Color.White
                            elseif distance >= 15000 then --and distance <= 15000 then
                                announcement = AddStaticToMessage(announcement, math.random(5, 6))
                                messageChat = ChatMessage.Create("INTERCOM", announcement, ChatMessageType.Default, nil, nil)
                                messageChat.Color = Color.White
                            else
                                messageChat.Color = Color.Khaki
                            end

                            if distance <= 30000 then
                                Game.SendDirectChatMessage(messageChat, client)
                            end
                        end

                        if distance <= 15000 then
                            Game.SendDirectChatMessage(messageBox, client)
                        end
                    end
                end
            else
                HideIntercomButton(sender, "melt")
            end
        else
            HideIntercomButton(sender, "melt")
        end
    end)

    Hook.Add("character.giveJobItems", "Player.UI.giveJobItems", function(character, waypoint)
        local client = Traitormod.FindClientCharacter(character)

        if client then
            if character.HasJob("adminone") then
                ShowIntercomButton(client, "azoe")
            elseif character.HasJob("admintwo") then
                ShowIntercomButton(client, "melt")
            end

            Timer.Wait(function ()
                local CharacterString = client.Name.." as "..character.Name
                local message = Networking.Start("AddPlayerToCredits")
                message.WriteString(CharacterString)
                Networking.Send(message, client.Connection)
            end, 4000)
        end
    end)

    Hook.Add("roundEnd", "EndCredits", function()
        for key, client in pairs(Client.ClientList) do
            local message = Networking.Start("NewCredits")
            Networking.Send(message, client.Connection)
        end
    end)

    Hook.Add("roundStart", "DeleteCredits", function()
        for key, client in pairs(Client.ClientList) do
            local message = Networking.Start("DeleteCredits")
            Networking.Send(message, client.Connection)
        end
    end)
end

if not CLIENT then return end

local MessageType = "azoe"
local isCreated = false
local players = {}

Hook.Add("think", "CreateSpawnMenuAfterLoad", function()

    if (isCreated) then
        Hook.Remove("think", "CreateSpawnMenuAfterLoad")
    end

    isCreated = true

    -- our main frame where we will put our custom GUI
    local frame = GUI.Frame(GUI.RectTransform(Vector2(1, 1)), nil)
    frame.CanBeFocused = false

    -- menu frame
    local menu = GUI.Frame(GUI.RectTransform(Vector2(1, 1), frame.RectTransform, GUI.Anchor.Center), nil)
    menu.CanBeFocused = false
    menu.Visible = false

    -- Chat menu content 
    local chatMenuContent = GUI.Frame(GUI.RectTransform(Vector2(0.2, 0.08), menu.RectTransform, GUI.Anchor.Center))
    local chatMenuList = GUI.ListBox(GUI.RectTransform(Vector2(1, 1), chatMenuContent.RectTransform, GUI.Anchor.BottomCenter))
    chatMenuContent.Visible = false

    -- Chat Box Message
    local chatText = GUI.TextBlock(GUI.RectTransform(Vector2(1, 0.3), chatMenuList.Content.RectTransform), "Placeholder", nil, nil, GUI.Alignment.Left)
    chatText.CanBeFocused = false
    chatText.TextColor = Color(204, 74, 78)

    local textBox = GUI.TextBox(GUI.RectTransform(Vector2(1, 0.2), chatMenuList.Content.RectTransform), "")
    textBox.OnTextChangedDelegate = function (textBox) end

    local sendButton = GUI.Button(GUI.RectTransform(Vector2(1, 0.1), chatMenuList.Content.RectTransform), "Send Message", GUI.Alignment.Center, "GUIButtonSmall")

    local function ChangeMessageType(string)
        if string.lower(string) == "azoe" then
            MessageType = "azoe"
            chatText.Text = "Announce on Azoe Region intercom:"
            chatText.TextColor = Color.CadetBlue
        elseif string.lower(string) == "melt" then
            MessageType = "melt"
            chatText.Text = "Announce on Meltwater Region intercom:"
            chatText.TextColor = Color.Khaki
        elseif string.lower(string) == "admin" then
            MessageType = "admin"
            chatText.Text = "Send message to moderator/admin:"
            chatText.TextColor = Color(97, 241, 196)
        end
    end

    local button = GUI.Button(GUI.RectTransform(Vector2(0.12, 0.05), frame.RectTransform, GUI.Anchor.BottomLeft), "INTERCOM", GUI.Alignment.Center, "GUIButtonSmall")
    button.RectTransform.AbsoluteOffset = Point(15, 330)
    button.Visible = false
    button.OnClicked = function ()
        menu.Visible = not menu.Visible
        chatMenuContent.Visible = menu.Visible
    end
    sendButton.OnClicked = function ()
        menu.Visible = not menu.Visible
        chatMenuContent.Visible = menu.Visible
        if textBox.Text ~= "" then
            local message = ""
    
            if MessageType == "admin" then
                message = Networking.Start("admin")
            elseif MessageType == "azoe" then
                message = Networking.Start("azoecom")
            elseif MessageType == "melt" then
                message = Networking.Start("meltcom")
            end
            message.WriteString(textBox.Text)
            Networking.Send(message)
        end
        textBox.Text = ""
    end

    -- Hide or Show Intercom Buttons
    Networking.Receive("IntercomShow", function(message)
        local team = message.ReadString()

        button.Visible = true
        menu.Visible = false
        chatMenuContent.Visible = menu.Visible
        ChangeMessageType(team)
    end)

    Networking.Receive("IntercomHide", function(message)
        local team = message.ReadString()

        button.Visible = false
        menu.Visible = false
        chatMenuContent.Visible = menu.Visible
        ChangeMessageType(team)
    end)

    Networking.Receive("AddPlayerToCredits", function(message)
        local text = message.ReadString()

        table.insert(players, text)
    end)

    Hook.Patch("Barotrauma.GameScreen", "AddToGUIUpdateList", function()
        frame.AddToGUIUpdateList()
    end)

    -- CREDITS STUFF BELOW
    local defframe = GUI.Frame(GUI.RectTransform(Vector2(1, 1)), nil)
    defframe.CanBeFocused = false

    local creditsList = {}
    local creditsList2 = {}
    local creditsNames = {}
    local scrolling = false
    local scrolltime = 0
    local creditsFrame = nil
    local creditsBoxFrame = nil
    local creditsMiniList = nil
    local baseName = nil
    
    local Title = nil
    local Credits = nil
    
    local newName = function(obj, text)
        obj.Visible = true
        obj.Text = text
    end
    
    local newTitle = function(text)
        Title.Visible = true
        Title.Text = text
    end
    
    local makeFadeTitleText = function(text, plrlist)
        local Box = GUI.Button(GUI.RectTransform(Vector2(0.0, 0.05), plrlist.RectTransform, GUI.Anchor.TopCenter), text, GUI.Alignment.Center, "GUIButtonLarge")
        Box.CanBeFocused = false
        Box.TextColor = Color(255, 255, 255, 0)
        Title = Box
    end
    
    local makeFadeText = function(text, plrlist)
        local Box = GUI.Button(GUI.RectTransform(Vector2(0.0, 0.05), plrlist.Content.RectTransform, GUI.Anchor.Center), text, GUI.Alignment.Center, "GUIButton")
        Box.CanBeFocused = false
        Box.TextColor = Color(255, 255, 255, 0)
        Box.Visible = false
        table.insert(creditsList, Box)
    end
    
    local makeTitleText = function(text, plrlist)
        local Box = GUI.Button(GUI.RectTransform(Vector2(0.0, 0.05), plrlist.Content.RectTransform, GUI.Anchor.TopCenter), text, GUI.Alignment.Center, "GUIButtonLarge")
        Box.CanBeFocused = false
        Box.TextColor = Color(255, 255, 255)
    end
    
    local makeText = function(text, plrlist)
        local Box = GUI.Button(GUI.RectTransform(Vector2(0.0, 0.05), plrlist.Content.RectTransform, GUI.Anchor.TopCenter), text, GUI.Alignment.Center, "GUIButton")
        Box.CanBeFocused = false
        Box.TextColor = Color(255, 255, 255)
        Box.Visible = false
        table.insert(creditsNames, Box)
        return Box
    end
    
    local makeAltText = function(text, plrlist)
        local Box = GUI.Button(GUI.RectTransform(Vector2(0.0, 0.05), plrlist.Content.RectTransform, GUI.Anchor.TopCenter), text, GUI.Alignment.Center, "GUIButton")
        Box.CanBeFocused = false
        Box.TextColor = Color(255, 255, 255)
        table.insert(creditsList2, Box)
        return Box
    end
    
    local defframe = GUI.Frame(GUI.RectTransform(Vector2(1, 1)), nil)
    defframe.CanBeFocused = false
    
    MakeCredits = function (ui)
        scrolling = false
        scrolltime = 0
        local baseframe = GUI.Frame(GUI.RectTransform(Vector2(0.93, 0.83), ui.RectTransform, GUI.Anchor.Center))
        baseframe.CanBeFocused = false
        baseframe.Color = Color(255, 255, 255, 0)
        local creditsContent = GUI.Frame(GUI.RectTransform(Vector2(0.45, 0.5), baseframe.RectTransform, GUI.Anchor.BottomLeft))
        local plrlist = GUI.ListBox(GUI.RectTransform(Vector2(1, 1), creditsContent.RectTransform, GUI.Anchor.TopCenter))
        creditsBoxFrame = baseframe
        creditsBoxFrame.Visible = false
        creditsFrame = creditsContent
        Credits = plrlist
    
        creditsMiniList = GUI.ListBox(GUI.RectTransform(Vector2(1, 1), creditsFrame.RectTransform, GUI.Anchor.Center))
        baseName = GUI.Frame(GUI.RectTransform(Vector2(0.93, 0.83), creditsFrame.RectTransform, GUI.Anchor.Center))
        baseName.CanBeFocused = false
        baseName.Color = Color(255, 255, 255, 0)
    
        makeFadeTitleText("Title", baseName)
        for i=1, 6, 1 do
            makeFadeText("FadeText", creditsMiniList)
        end
    
        for i=1, 9, 1 do
            makeTitleText("", Credits)
        end
        makeTitleText("Cast", Credits)
        for i=1, 18, 1 do
            makeText("Example person as Character #".. i, Credits)
        end
        makeAltText("", Credits)
        makeAltText("", Credits)
        makeTitleText("Producers", Credits)
        makeAltText("Television - Developer", Credits)
        makeAltText("Dr. Javier - Map Maker", Credits)
        makeAltText("Evil Factory - Lua For Barotrauma Developer", Credits)
        for i=1, 3, 1 do
            makeTitleText("", Credits)
        end
        local someButton = GUI.Button(GUI.RectTransform(Vector2(1, 0.1), Credits.Content.RectTransform), "Close Credits", GUI.Alignment.Center, "GUIButtonSmall")
        someButton.OnClicked = function ()
            baseframe.Visible = false
        end
    end

    Hook.Patch("Barotrauma.NetLobbyScreen", "AddToGUIUpdateList", function()
        defframe.AddToGUIUpdateList()
    end, Hook.HookMethodType.After)
    
    MakeCredits(defframe)

    Networking.Receive("NewCredits", function()
        scrolltime = 0
        creditsMiniList.Visible = true
        baseName.Visible = true
        Credits.BarScroll = 0
        creditsBoxFrame.Visible = true

        for key, player in pairs(players) do
            newName(creditsNames[key], player)
        end

        Timer.Wait(function ()
            creditsMiniList.Visible = false
            scrolling = true
            Credits.Visible = true
        end, 20000)

        Hook.Add("think", "CreditsThink", function()
            if scrolling and Timer.GetTime() > scrolltime then
                print(Credits.BarScroll)
                Credits.BarScroll = Credits.BarScroll + 0.0005 * (12 / #creditsList2)
                scrolltime = Timer.GetTime() + 0.01
            end

            if Credits.BarScroll >= 1 then
                Hook.Remove("think", "CreditsThink")
            end
        end)

        players = {}
    end)

    Networking.Receive("DeleteCredits", function()
        creditsBoxFrame.Visible = false
        scrolling = false
        scrolltime = 0
        creditsMiniList.Visible = true
        baseName.Visible = true
        creditsBoxFrame.Visible = true
        Credits.Visible = false
        Credits.BarScroll = 0
    end)
end)
if CLIENT then
    local MessageType = "admin"
    local players = {}

    Timer.Wait(function()
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
            if string.lower(string) == "admin" then
                MessageType = "admin"
                chatText.Text = "Send message to admins:"
                chatText.TextColor = Color(97, 241, 196)
            end
        end

        -- AdminHelp Button
        local buttonAdmin = GUI.Button(GUI.RectTransform(Vector2(0.15, 0.05), frame.RectTransform, GUI.Anchor.TopRight), "ADMIN HELP", GUI.Alignment.Center, "GUIButtonSmall")
        --Normal Color
        buttonAdmin.TextColor = Color.IndianRed
        buttonAdmin.OutlineColor = Color.Black
        buttonAdmin.Color = Color.DimGray
        --Hover color
        buttonAdmin.HoverTextColor = Color.Red
        buttonAdmin.HoverColor = Color.DarkGray

        buttonAdmin.RectTransform.AbsoluteOffset = Point(103, 60)
        buttonAdmin.Visible = true
        buttonAdmin.OnClicked = function ()
            menu.Visible = not menu.Visible
            chatMenuContent.Visible = menu.Visible
            ChangeMessageType("admin")
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

        Networking.Receive("AddPlayerToCredits", function(message)
            local text = message.ReadString()

            table.insert(players, text)
        end)

        Hook.Patch("Barotrauma.GameScreen", "AddToGUIUpdateList", function()
            frame.AddToGUIUpdateList()
        end)

        -- CREWSTATUS STUFF BELOW
        local ActiveCrewNames = {}

        local crewlistContent = GUI.Frame(GUI.RectTransform(Vector2(0.35, 0.4), frame.RectTransform, GUI.Anchor.Center))
        local crewlist = GUI.ListBox(GUI.RectTransform(Vector2(1, 1), crewlistContent.RectTransform, GUI.Anchor.Center))
        crewlistContent.Visible = false

        local CrewListTitle = GUI.Button(GUI.RectTransform(Vector2(0.0, 0.05), crewlist.Content.RectTransform, GUI.Anchor.TopCenter), "Crew Status", GUI.Alignment.Center, "GUIButtonLarge")
        CrewListTitle.CanBeFocused = false
        CrewListTitle.TextColor = Color(255, 255, 255)

        local newCrewStatusText = function(text, color)
            local Box = GUI.Button(GUI.RectTransform(Vector2(0.0, 0.05), crewlist.Content.RectTransform, GUI.Anchor.TopCenter), text, GUI.Alignment.Center, "GUIButtonSmall")
            Box.CanBeFocused = false
            Box.TextColor = color or Color.White
            table.insert(ActiveCrewNames, Box)
            return Box
        end

        local toggleCrewListStatus = function (bool)
            crewlistContent.Visible = bool or not crewlistContent.Visible
            crewlist.Visible = bool or crewlistContent.Visible
        end

        local resetCrewStatus = function()
            toggleCrewListStatus(false)
            for element in ActiveCrewNames do
                element.Text = ""
            end
        end

        local newCrewListName = function(obj, text, color)
            obj.Visible = true
            obj.Text = text
            obj.TextColor = color or Color.White
        end

        for i=1, 20, 1 do
            newCrewStatusText("")
        end

        local startCrewList = function (message)
            local messageString = message.ReadString()
            local messageKey = message.ReadByte()

            toggleCrewListStatus(true)
            newCrewListName(ActiveCrewNames[messageKey], messageString)
        end

        local buttonCrewList = GUI.Button(GUI.RectTransform(Vector2(0.1, 0.05), crewlistContent.RectTransform, GUI.Anchor.TopLeft), "X", GUI.Alignment.Center, "GUIButtonSmall")
        --Normal Color
        buttonCrewList.TextColor = Color.Red
        --Hover color
        buttonCrewList.HoverTextColor = Color.Red
        buttonCrewList.OnClicked = resetCrewStatus

        Networking.Receive("Traitormod.IdCardLocator.MakeCrewList", startCrewList)

        -- CREDITS STUFF BELOW
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
            for i=1, 4, 1 do
                makeFadeText("FadeText", creditsMiniList)
            end

            for i=1, 7, 1 do
                makeTitleText("", Credits)
            end
            makeTitleText("Cast", Credits)
            for i=1, 20, 1 do
                makeText("Example person as Character #".. i, Credits)
            end
            for i=1, 2, 1 do
                makeTitleText("", Credits)
            end
            makeTitleText("Producers", Credits)
            makeAltText("Television - Developer", Credits)
            makeAltText("Dr. Javier - Developer", Credits)
            makeAltText("Evil Factory - Lua For Barotrauma Developer", Credits)
            makeTitleText("", Credits)
            makeTitleText("Contributors", Credits)
            makeAltText("None yet!", Credits)
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
            crewlistContent.Visible = false
        end)

        Timer.Wait(function()
            if not Husk then
                buttonAdmin.Visible = false
                crewlistContent.Visible = false
            end
        end, 2000)

        -- AdminHelp Button
        local lightingToggleButton = GUI.Button(GUI.RectTransform(Vector2(0.07, 0.05), frame.RectTransform, GUI.Anchor.TopCenter), "Toggle Lighting", GUI.Alignment.Center, "GUIButtonSmall")
        lightingToggleButton.RectTransform.AbsoluteOffset = Point(-75, 25)
        lightingToggleButton.OnClicked = function ()
            if Character.Controlled == nil then
                Game.LightManager.LightingEnabled = not Game.LightManager.LightingEnabled
            end
        end

        Hook.Patch("Barotrauma.Networking.GameClient", "UpdateHUD", function(instance, ptable)
            lightingToggleButton.Visible = Character.Controlled == nil
        end, Hook.HookMethodType.After)

        Networking.Receive("ToggleLightsFromServer", function (msg)
            local bool = msg.ReadBoolean()
            Game.LightManager.LightingEnabled = bool
        end)
    end, 5000)
elseif SERVER then
    Hook.Patch("Barotrauma.Networking.GameServer", "SetClientCharacter", function(instance, ptable)
        local client = ptable["client"]

        if client.Character and not client.Character.IsDead then
            local netmessage = Networking.Start("ToggleLightsFromServer")
            netmessage.WriteBoolean(true)
            Networking.Send(netmessage, client.Connection)
        end
    end, Hook.HookMethodType.After)
end
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

    -- Admin message
    Networking.Receive("admin", function(message, sender)
        local adminmsg = message.ReadString()
        local finalmsg = nil
        local discordWebHook = "https://discord.com/api/webhooks/1132681601235550248/Bv-aVamzlUk6NamJlnyXQjBDD3A_zMTNBI3fZdKJD0m-liucLGdTru_DjBBddPLaF861"
        local function escapeQuotes(str)
            return str:gsub("\"", "\\\"")
        end
        
        if sender.Character then
            finalmsg = "``User "..sender.Name.." as "..sender.Character.Name..":`` "..adminmsg
        else
            finalmsg = "``User "..sender.Name..":`` "..adminmsg
        end
        local escapedMessage = escapeQuotes(finalmsg)
        Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..'ADMIN HELP (HUSK SURVIVAL)'..'\"}')
        for key, client in pairs(Client.ClientList) do
            if client.HasPermission(ClientPermissions.Kick) then
                local messageChat = ChatMessage.Create("", "TO ADMINS:\n"..adminmsg, ChatMessageType.Default, nil, sender)
                messageChat.Color = Color.IndianRed
                Game.SendDirectChatMessage(messageChat, client)
                Game.SendDirectChatMessage(messageChat, sender)
            end
        end
    end)

    -- Check if the ID card is correct when intercom button is pressed
    Networking.Receive("checkID", function(message, sender)
        if sender.Character and not sender.Character.IsDead and sender.Character.IsHuman then
            local idcard = sender.Character.Inventory.FindItemByIdentifier("idcard")

            if idcard then
                local component = idcard.GetComponentString("IdCard")

                if component.OwnerJobId == "adminone" then
                    ShowIntercomButton(sender, "azoe")
                elseif component.OwnerJobId == "admintwo" then
                    ShowIntercomButton(sender, "melt")
                else
                    HideIntercomButton(sender, "admin")
                end
            else
                HideIntercomButton(sender, "admin")
            end
        else
            HideIntercomButton(sender, "admin")
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

                        if distance <= 10000 then
                            Game.SendDirectChatMessage(messageBox, client)
                        end
                    end
                end
            else
                HideIntercomButton(sender, "admin")
            end
        else
            HideIntercomButton(sender, "admin")
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
                HideIntercomButton(sender, "admin")
            end
        else
            HideIntercomButton(sender, "admin")
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
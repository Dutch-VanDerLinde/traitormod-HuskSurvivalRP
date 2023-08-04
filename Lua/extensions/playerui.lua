﻿if SERVER then
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

    -- Add character to credits
    Hook.Add("character.giveJobItems", "Player.UI.giveJobItems", function(character, waypoint)
        local client = Traitormod.FindClientCharacter(character)

        if client then
            Timer.Wait(function ()
                local jobname = character.Info.Job.Name.ToString()
                local truename = jobname
                local idcard = character.Inventory.FindItemByIdentifier("idcard")
                if idcard then
                    if idcard.HasTag("azoe_admin") then
                        truename = "Azoe Administrator"
                    elseif idcard.HasTag("melt_admin") then
                        truename = "Meltwater Administrator"
                    elseif idcard.HasTag("azoe") then
                        truename = "Azoe "..jobname
                    elseif idcard.HasTag("melt") then
                        truename = "Meltwater "..jobname
                    elseif idcard.HasTag("researchdirector") then
                        truename = "Institute Research Director"
                    elseif idcard.HasTag("scientist") then
                        truename = "Institute Scientist"
                    end
                end

                local CharacterString = client.Name.." as "..truename.." "..character.Name
                local message = Networking.Start("AddPlayerToCredits")
                message.WriteString(CharacterString)
                Networking.Send(message, client.Connection)
            end, 4100)
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
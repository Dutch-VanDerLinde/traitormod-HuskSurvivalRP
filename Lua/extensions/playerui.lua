if SERVER then
    local function escapeQuotes(str)
        return str:gsub("\"", "\\\"")
    end
    -- Admin message
    Networking.Receive("admin", function(message, sender)
        local adminmsg = message.ReadString()
        local finalmsg = nil
        local discordWebHook = "https://discord.com/api/webhooks/1138861228341604473/Hvrt_BajroUrS60ePpHTT1KQyCNhTwsphdmRmW2VroKXuHLjxKwKRwfajiCZUc-ZtX2L"
        
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

    local function UpdatePlayerList(client)
        local discordWebHook = "https://discord.com/api/webhooks/1138862181723668500/Kv-hzWLm9KM2-ZusZ2itu8FHSjN4fa2DK5WSlJju5QNW-WGKSb5C57ULxuRftUiwJjjS"
        local totalclients = #Client.ClientList
        local maxclients = Game.ServerSettings.MaxPlayers

        local msg = client.Name.." has left the server.\nThe player count is now "..totalclients.."/"..maxclients.."."

        local escapedMessage = escapeQuotes(msg)
        Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..'Current Players (HUSK SURVIVAL)'..'\"}')
    end

    Hook.Add("client.connected", "PlayerListConnection", UpdatePlayerList)
    Hook.Add("client.disconnected", "PlayerListDisconnection", UpdatePlayerList)

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
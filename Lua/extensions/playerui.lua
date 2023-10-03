if SERVER then
    local function escapeQuotes(str)
        return str:gsub("\"", "\\\"")
    end

    -- Admin message
    Traitormod.SendAdminHelpMessage = function(adminmsg, sender)
        local discordWebHook = "https://discord.com/api/webhooks/1138861228341604473/Hvrt_BajroUrS60ePpHTT1KQyCNhTwsphdmRmW2VroKXuHLjxKwKRwfajiCZUc-ZtX2L"
        local finalmsg = nil

        if sender.Character then
            finalmsg = "``User "..sender.Name.." as "..sender.Character.Name..":`` "..adminmsg
        else
            finalmsg = "``User "..sender.Name..":`` "..adminmsg
        end

        local escapedMessage = escapeQuotes(finalmsg)
        Networking.RequestPostHTTP(discordWebHook, function(result) end, '{\"content\": \"'..escapedMessage..'\", \"username\": \"'..'ADMIN HELP (HUSK SURVIVAL)'..'\"}')

        local messageChat = ChatMessage.Create("", "TO ADMINS:\n"..adminmsg, ChatMessageType.Default, nil, sender)
        messageChat.Color = Color.IndianRed

        for key, client in pairs(Client.ClientList) do
            if client.HasPermission(ClientPermissions.Kick) then
                Game.SendDirectChatMessage(messageChat, client)
            end
        end

        Game.SendDirectChatMessage(messageChat, sender)
    end

    Networking.Receive("admin", function(message, sender)
        local adminmsg = message.ReadString()
        Traitormod.SendAdminHelpMessage(adminmsg, sender)
    end)

    local function ParseJobName(name, jobid)
        if jobid == "adminone" then
            name = "Azoe Administrator"
        elseif jobid == "guardone" then
            name = "Azoe Security Officer"
        elseif jobid == "guardtci" then
            name = "Institute Security Officer"
        elseif jobid == "researchdirector" then
            name = "Institute Research Director"
        elseif jobid == "thal_scientist" then
            name = "Institute Scientist"
        elseif jobid == ("citizen" or "medicaldoctor") then
            name = "Azoe "..name
        end

        return name
    end

    -- Add character to credits
    Hook.Add("character.giveJobItems", "Player.UI.giveJobItems", function(character, waypoint)
        local client = Traitormod.FindClientCharacter(character)

        if client then
            Timer.Wait(function ()
                local jobid = tostring(character.JobIdentifier)
                local jobname = character.Info.Job.Name.ToString()
                jobname = ParseJobName(jobname, jobid)

                local CharacterString = client.Name.." as "..jobname.." "..character.Name
                local message = Networking.Start("AddPlayerToCredits")
                message.WriteString(CharacterString)

                for loopClient in Client.ClientList do
                    Networking.Send(message, loopClient.Connection)
                end
            end, 4100)
        end
    end)

    Hook.Add("client.connected", "PlayerUIClientConnection", function(client)
        Timer.Wait(function ()
            if client.Connection then
                local message = Networking.Start("NewCredits")
                Networking.Send(message, client.Connection)
            end
        end, 2500)
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
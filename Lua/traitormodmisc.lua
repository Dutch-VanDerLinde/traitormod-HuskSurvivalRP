local timer = Timer.GetTime()

local huskBeacons = {}

Traitormod.AddHuskBeacon = function(item, time)
    huskBeacons[item] = time
end

local peopleInOutpost = 0
local ghostRoleNumber = 1
Hook.Add("think", "Traitormod.MiscThink", function()
    if timer > Timer.GetTime() then return end
    if not Game.RoundStarted then return end

    for item, _ in pairs(huskBeacons) do
        local interface = item.GetComponentString("CustomInterface")
        if interface.customInterfaceElementList[1].State then
            huskBeacons[item] = huskBeacons[item] - 5
        end

        if huskBeacons[item] <= 0 then
            for i = 1, 4, 1 do
                Entity.Spawner.AddCharacterToSpawnQueue("husk", item.WorldPosition)
            end

            Entity.Spawner.AddEntityToRemoveQueue(item)
            huskBeacons[item] = nil
        end
    end

    timer = Timer.GetTime() + 5

    if Traitormod.Config.GhostRoleConfig.Enabled then
        for key, character in pairs(Character.CharacterList) do
            local client = Traitormod.FindClientCharacter(character)
            if not Traitormod.GhostRoles.IsGhostRole(character) and not client then
                if Traitormod.Config.GhostRoleConfig.MiscGhostRoles[character.SpeciesName.Value] then
                    Traitormod.GhostRoles.Ask(character.Name .. " " .. ghostRoleNumber, function(client)
                        client.SetClientCharacter(character)
                    end, character)
                    ghostRoleNumber = ghostRoleNumber + 1
                end
            end
        end
    end

    if not Traitormod.RoundEvents.EventExists("OutpostPirateAttack") then return end
    if Traitormod.RoundEvents.IsEventActive("OutpostPirateAttack") then return end
    if Traitormod.SelectedGamemode == nil or Traitormod.SelectedGamemode.Name ~= "Secret" then return end

    local targets = {}
    local outpost = Level.Loaded.EndOutpost.WorldPosition

    for key, character in pairs(Character.CharacterList) do
        if character.IsRemotePlayer and character.IsHuman and not character.IsDead and Vector2.Distance(character.WorldPosition, outpost) < 5000 then
            table.insert(targets, character)
        end
    end

    if #targets > 0 then
        peopleInOutpost = peopleInOutpost + 1
    end

    if peopleInOutpost > 30 then
        Traitormod.RoundEvents.TriggerEvent("OutpostPirateAttack")
    end
end)

Hook.Add("roundEnd", "Traitormod.MiscEnd", function()
    peopleInOutpost = 0
    ghostRoleNumber = 1
    huskBeacons = {}
end)

if Traitormod.Config.DeathLogBook then
    local messages = {}

    Hook.Add("roundEnd", "Traitormod.DeathLogBook", function()
        messages = {}
    end)

    Hook.Add("character.death", "Traitormod.DeathLogBook", function(character)
        if messages[character] == nil then return end

        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("logbook"), character.Inventory, nil, nil,
            function(item)
                local terminal = item.GetComponentString("Terminal")

                local text = ""
                for key, value in pairs(messages[character]) do
                    text = text .. value .. "\n"
                end

                terminal.TextColor = Color.MidnightBlue
                terminal.ShowMessage = text
                terminal.SyncHistory()
            end)
    end)

    Traitormod.AddCommand("!write", function(client, args)
        if client.Character == nil or client.Character.IsDead or client.Character.SpeechImpediment > 0 or not client.Character.IsHuman then
            Traitormod.SendChatMessage(client, "You are unable to write to your death logbook.", Color.Red)
            return true
        end

        if messages[client.Character] == nil then
            messages[client.Character] = {}
        end

        if #messages[client.Character] > 255 then return end

        local message = table.concat(args, " ")
        table.insert(messages[client.Character], message)

        Traitormod.SendChatMessage(client, "Wrote \"" .. message .. "\" to the death logbook.", Color.Green)

        return true
    end)
end

Traitormod.AddStaticToMessage = function(msg, chance)
    for i = 1, #msg do
        local c = msg:sub(i, i)

        if math.random(1, chance) == 1 then
            msg = msg.gsub(msg, c, "-")
        end
    end

    return msg
end

Hook.Add("traitormod.terminalWrite", "HuskSurvival.Intercom", function(item, sender, output)
    local idcard = item.OwnInventory.GetItemAt(0)

    if item.Condition < 100 then
        local messageChat = ChatMessage.Create("Intercom", "Cooldown active. Please wait.", ChatMessageType.Default, nil,
            nil)
        messageChat.Color = Color.Red
        Game.SendDirectChatMessage(messageChat, sender)
        return
    end

    if not idcard then
        local messageChat = ChatMessage.Create("Intercom", "Invalid credentials.", ChatMessageType.Default, nil, nil)
        messageChat.Color = Color.Red
        Game.SendDirectChatMessage(messageChat, sender)
        return
    end

    if not item.HasTag("intercom")
        or not sender.Character
        or not sender.Character.IsHuman
        or output == (nil or "")
    then
        return
    end

    local sendername = idcard.GetComponentString("IdCard").OwnerName

    local announcement = function(color, jobname)
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("husksfx_intercomstart"), item.WorldPosition)
        item.Condition = 0
        Timer.Wait(function() item.Condition = 100 end, 2 * 60000)  -- 2 minute cooldown

        for key, client in pairs(Client.ClientList) do
            if client.Character then
                local radio = false
                local distance = Vector2.Distance(client.Character.WorldPosition, item.WorldPosition)

                for headset in client.Character.Inventory.AllItems do
                    if headset.HasTag("mobileradio") then
                        local battery = headset.OwnInventory.GetItemAt(0)
                        if battery and battery.Condition > 0.1 then
                            radio = true
                            break
                        end
                    end
                end

                -- If the player doesn't have a radio then it doesn't announce
                if radio then
                    if distance >= 9500 then
                        output = Traitormod.AddStaticToMessage(output, math.random(3, 5))
                    end

                    local sb = Traitormod.StringBuilder:new()
                    sb(color, string.format("\"%s\"", output))
                    sb("\n\n")
                    sb("‖color:#D5B413‖%s‖color:end‖",
                        string.format(Traitormod.Language.IntercomSentBy, sendername, jobname))

                    output = sb:concat()

                    if distance <= 17500 then
                        Timer.Wait(function()
                            local messageChat = ChatMessage.Create("Intercom", output, ChatMessageType.Default, nil, nil)
                            Game.SendDirectChatMessage(messageChat, client)
                        end, 500)
                    end
                end
            end
        end
    end

    if idcard then
        if idcard.GetComponentString("IdCard").OwnerJobId == "adminone" and item.HasTag("azoe") then
            announcement("‖color:#00B4F1‖%s‖color:end‖", "Administrator")
        elseif idcard.GetComponentString("IdCard").OwnerJobId == "researchdirector" and item.HasTag("tci") then
            announcement("‖color:#01FFFC‖%s‖color:end‖", "Research Director")
        end
    end
end)

Hook.Patch("Barotrauma.Items.Components.CustomInterface", "ServerEventRead", function(instance, ptable)
    local client = ptable["c"]
    local item = instance.Item

    if item.Prefab.Identifier == "admindeviceazoe" then
        Traitormod.Pointshop.ShowCategory(client)
    elseif item.Prefab.Identifier == "admindevicemelt" then
        Traitormod.Pointshop.ShowCategory(client)
    end
end, Hook.HookMethodType.After)

-- Incubator Logic
Hook.Add("HuskSurvival.CloneStart", "HuskSurvival.CloneStart", function(effect, deltaTime, item, targets, worldPosition)
    local data = item.OwnInventory.GetItemAt(0)
    local possibledisorders = {
        "thal_disorderseizure",
        "thal_disorderhypo",
        "thal_disorderacid",
        "thal_disordermumble",
        "thal_disorderdeath",
        "thal_disorderbuff",
        "thal_disorderhusk",
        "thal_disorderstupid",
        "thal_disorderweapon",
        "thal_disorderrad",
        "thal_disorderbloodloss",
        "thal_disorderacid",
        "thal_disorderairloss",
    }
    local possibleLimbs = {
        LimbType.LeftLeg,
        LimbType.RightLeg,
        LimbType.RightArm,
        LimbType.LeftArm,
        LimbType.Head
    }
    if data and not data.NonInteractable then
        local condition = data.Condition
        local prop = data.SerializableProperties[Identifier("NonInteractable")]
        data.NonInteractable = true
        Networking.CreateEntityEvent(data, Item.ChangePropertyEventData(prop, data))

        local tags = HF.SplitString(data.Tags, ",")
        local clientname = nil
        for tag in tags do
            if HF.StartsWith(tag, "name") then
                local split = HF.SplitString(tag, ":")
                if split[2] ~= nil then clientname = split[2] end
            end
        end
        local client = HF.ClientFromName(clientname)
        if not client then return end

        if not client.Character or not client.Character.IsHuman or client.Character.IsDead then
            local textPromptUtils = require("textpromptutils")
            local options = { Traitormod.Language.Yes, Traitormod.Language.No }
            textPromptUtils.Prompt("You are being cloned! Return to your body?", options, client,
                function(option, client2)
                    if option == 1 then
                        client2.SetClientCharacter(nil)
                    else
                        Traitormod.Log(client.Name .. " denied returning to the spectator chat")
                    end
                end)

            Traitormod.SendMessage(client,
                "You are being cloned! If your current character is alive, you won't gain control of the clone.")
        end

        Timer.Wait(function()
            local traumatic = 0
            local surgical = 0
            local randomdisorder = possibledisorders[math.random(1, #possibledisorders)]
            local char = Character.Create(client.CharacterInfo, item.WorldPosition, client.CharacterInfo.Name, 0, true,
                false)
            char.TeamID = CharacterTeamType.FriendlyNPC
            HF.RemoveItem(data)

            Timer.Wait(function()
                if not client.Character or client.Character.IsDead and not char.IsDead then
                    client.SetClientCharacter(char)
                    Traitormod.LostLivesThisRound[client.SteamID] = false

                    Traitormod.SendMessageCharacter(char, Traitormod.Language.CloneOGClient, "InfoFrameTabButton.Mission")
                elseif not char.IsDead then
                    Traitormod.GhostRoles.Ask(char.Name .. " (Cloned)", function(ghostclient)
                        Traitormod.LostLivesThisRound[ghostclient.SteamID] = false
                        ghostclient.SetClientCharacter(char)

                        Traitormod.SendMessageCharacter(char, string.format(Traitormod.Language.CloneRandom, char.Name),
                            "InfoFrameTabButton.Mission")
                    end, char)
                end
            end, 1500)

            if condition < 50 and condition > 20 then
                if math.random(1, 4) == 1 then
                    table.remove(possibleLimbs, 5)
                    if math.random(1, 4) == 1 then
                        traumatic = 100
                    else
                        surgical = 100
                    end
                    NT.SurgicallyAmputateLimb(char, possibleLimbs[math.random(1, #possibleLimbs)], surgical, traumatic)
                    if math.random(1, 4) == 1 then
                        HF.AddAffliction(char, randomdisorder, 2)
                    end
                end
            elseif condition <= 20 and condition >= 1 then
                if math.random(1, 2) == 1 then table.remove(possibleLimbs, 5) end
                if math.random(1, 3) == 1 then
                    traumatic = 100
                else
                    surgical = 100
                end
                NT.SurgicallyAmputateLimb(char, possibleLimbs[math.random(1, #possibleLimbs)], surgical, traumatic)
                if math.random(1, 2) == 1 then
                    HF.AddAffliction(char, randomdisorder, 2)
                end
            elseif condition < 1 then
                if math.random(1, 2) == 1 then
                    traumatic = 100
                else
                    surgical = 100
                end
                NT.SurgicallyAmputateLimb(char, possibleLimbs[math.random(1, #possibleLimbs)], surgical, traumatic)
                NT.SurgicallyAmputateLimb(char, possibleLimbs[math.random(1, #possibleLimbs)], surgical, traumatic)
                HF.AddAffliction(char, randomdisorder, 2)
            end
        end, 30000)
    end
end)

Traitormod.Laugh = function(character)
    local laugh = "laugh_human"

    if not HF.HasAffliction(character, "sym_unconsciousness", 1) then
        HF.AddAffliction(character, laugh, 2)
    end
end

Traitormod.FlaggedRP_Phrases = {
    ["omg"] = "oh my god",
    ["omfg"] = "oh my fucking god",
    ["ong"] = "on god",
    ["wtf"] = "what the fuck",
    ["gtfo"] = "get the fuck out",
    ["ffs"] = "for fuck's sake",
    ["stfu"] = "shut the fuck up",
    ["tf"] = "the fuck",
    ["afaik"] = "as far as i know",
    ["ik"] = "i know",
    ["ikr"] = "i know, right",
    ["idc"] = "i don't care",
    ["tbh"] = "to be honest",
    ["u"] = "you",
    ["ur"] = "your",
    ["mk"] = "mmm, okay",
    ["iirc"] = "if i remember correctly",
    ["np"] = "no problem",
    ["omw"] = "on my way",
    ["nvm"] = "nevermind",
    ["imo"] = "in my opinion",
    ["pls"] = "please",
    ["plz"] = "please",
    ["plox"] = "please",
    ["fr"] = "for real",
    ["brb"] = "be right back",
    ["btw"] = "by the way",
    ["jk"] = "just kidding",
    ["thx"] = "thanks",
    ["ty"] = "thank you",
    ["afk"] = "",
    ["lmk"] = "let me know",
    --Laughs
    ["lmao"] = { Traitormod.Laugh, "laughs" },
    ["lol"] = { Traitormod.Laugh, "laughs" },
    ["lo"] = { Traitormod.Laugh, "laughs" },
    ["xd"] = { Traitormod.Laugh, "laughs" },
    ["rofl"] = { Traitormod.Laugh, "laughs" },
    ["*laughs"] = { Traitormod.Laugh, "laughs" },
    ["laughs"] = { Traitormod.Laugh, "laughs" },
    ["*laughs*"] = { Traitormod.Laugh, "laughs" },
    --1984
    ["admins"] = "gods",
}

-- To prevent people from using non-realistic phrases, it also auto capitalizes the first letter of the sentence
Hook.Patch("Barotrauma.Networking.GameServer", "SendChatMessage", function(instance, ptable)
    local client = ptable["senderClient"]
    local character
    local message = ptable["message"]

    if not client or not client.Character or client.Character.IsHusk or not Traitormod.Config.EnableRPChat then
        return
    else
        character = client.Character
    end

    if character and not character.IsDead and not character.IsHusk then
        -- Original = flagged phrase, such as "wtf" | replacement = the word to replace it, such as "what the fuck"
        message = Traitormod.Accents.replaceWords(message, Traitormod.FlaggedRP_Phrases, character)

        -- Loop through all afflictions, if you have one that matches an accent table, then replace the words.
        local afflictionlist = character.CharacterHealth.GetAllAfflictions()
        for aff in afflictionlist do
            local prefab = aff.Prefab
            local identifier = tostring(prefab.Identifier)
            if not prefab.LimbSpecific then
                local accenttable = Traitormod.Accents[identifier]
                if accenttable then -- if found an accent, then replace the words of the message
                    message = Traitormod.Accents.replaceWords(message, accenttable, character)
                    break
                end
            end
        end

        if HF.HasAffliction(character, "tortureaccent", 1) then
            message = Traitormod.Accents.OwO(message)
        end

        -- If drunk, then slur string
        if HF.HasAffliction(character, "drunk", 45) then
            local strength = HF.GetAfflictionStrength(character, "drunk")
            message = Traitormod.Accents.drunkslur(message, strength)
        end

        -- If brain hemorrhage, then shuffle string
        if HF.HasAffliction(character, "brainhemorrhage", 5) then
            local strength = HF.GetAfflictionStrength(character, "brainhemorrhage")
            message = Traitormod.Accents.brainbleed(message, strength)
        end

        -- If losing blood, then stutter string
        if HF.HasAffliction(character, "bloodloss", 50) or HF.HasAffliction(character, "hypothermia", 45) then
            message = Traitormod.Accents.stutter(message)
        end

        -- capitalize the first letter and "I"
        local uppercaseletter = message:sub(1, 1):upper()
        message = uppercaseletter .. message:sub(2, #message)
        message = Traitormod.Accents.capitalizeLetterI(message)
    end

    ptable["message"] = message
end, Hook.HookMethodType.Before)

-- accents
Traitormod.Accents = {}

dofile(Traitormod.Path .. "/Lua/Accents/owo.lua")
dofile(Traitormod.Path .. "/Lua/Accents/misc.lua")
dofile(Traitormod.Path .. "/Lua/Accents/archaic.lua")
dofile(Traitormod.Path .. "/Lua/Accents/scottish.lua")



-- monster loot spawns
Hook.Add("character.created", "traitormod.huskmodspawn", function (character)
    
end)
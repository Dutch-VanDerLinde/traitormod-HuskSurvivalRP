local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")
local gm = Traitormod.Gamemodes.Gamemode:new()

gm.Name = "Survival"

function gm:CharacterDeath(character)
    local client = Traitormod.FindClientCharacter(character)

    -- if character is valid player
    if client == nil or
        character == nil or
        character.IsHuman == false or
        character.ClientDisconnected == true or
        character.TeamID == 0 then
        return
    end

    if Traitormod.RoundTime < Traitormod.Config.MinRoundTimeToLooseLives then
        return
    end

    if Traitormod.LostLivesThisRound[client.SteamID] == nil then
        Traitormod.LostLivesThisRound[client.SteamID] = true
    else
        return
    end

    local name = Traitormod.GetRPName(client)
    local msg = string.format(Traitormod.Language.CharacterDeath, name)
    Traitormod.SendMessage(client, msg, "GameModeIcon.pvp")
    Traitormod.AdjustLives(client, -1)
    Traitormod.ChangeRPName(client, nil)
end

function gm:Start()
    local this = self

    if self.EnableRandomEvents then
        Traitormod.RoundEvents.Initialize()
    end

    Hook.Add("characterDeath", "Traitormod.Survival.CharacterDeath", function(character, affliction)
        this:CharacterDeath(character)
    end)

    local loottable = {
        --Uses binomial distribution (p is %, n is tries)
        --refrigator = {
        --{'identifier', p, n, amount}
        rations = {
            {"he-humanburger", 0.65, 2, 1},
            {"he-crawlerburger", 0.5, 2, math.random(1, 2)},
            {"he-bread", 0.75, 2, math.random(1, 3)},
            {"banana", 0.4, 2, math.random(1, 2)},
            {"he-cookedthresherfilet", 0.4, 1, 1},
            {"he-cookedcrawlerfilet", 0.75, math.random(1, 2), 2},
        },
        seed = {
            {"aquaticpoppyseed", 0.2, 2, 1},
            {"elastinseed", 0.2, 1, 1},
            {"yeastshroomseed", 0.2, 1, 1},
            {"fiberseed", 0.2, 1, 1},
            {"rubberseed", 0.8, 2, math.random(1, 2)},
            {"thal_rustseed", 0.3, 2, 1},
            {"thal_wheatseed", 0.4, 2, 1},
            {"saltvineseed", 0.9, 1, 1},
            {"bubbleberryvineseed", 0.55, 2, 1},
            {"creepingorangevineseed", 0.65, 2, 2},
            {"popnutvineseed", 0.57, 2, 1},
            {"tobaccovineseed", 0.7, 1, 1},
            {"bacteriaslime", 0.5, 2, 1},
            {"seedbag", 1, 1, 1},
        },
    }

    Traitormod.SpawnLootTables(loottable)
end

function gm:PreStart()
    Traitormod.Pointshop.Initialize(self.PointshopCategories or {})

    Hook.Add("character.giveJobItems", "Husk.Survival.giveJobItems", function(character, waypoint)
        if Traitormod.Config.HideCrewList then Networking.CreateEntityEvent(character, Character.RemoveFromCrewEventData.__new(character.TeamID, {})) end
        if Traitormod.Config.RoleplayNames then Traitormod.randomizeCharacterName(character) end

        Traitormod.GiveJobItems(character)
    end)
end

function gm:AwardCrew()
    local missionType = {}

    for key, value in pairs(MissionType) do
        missionType[value] = key
    end

    local missionReward = 0
    for _, mission in pairs(Traitormod.RoundMissions) do
        if mission.Completed then
            local type = missionType[mission.Prefab.Type]
            local missionValue = self.MissionPoints.Default

            for key, value in pairs(self.MissionPoints) do
                if key == type then
                    missionValue = value
                end
            end

            missionReward = missionReward + missionValue
        end
    end

    for key, value in pairs(Client.ClientList) do
        if value.Character ~= nil
            and value.Character.IsHuman
            and not value.SpectateOnly
            and not value.Character.IsDead
        then
            local role = Traitormod.RoleManager.GetRole(value.Character)

            local wasAntagonist = false
            if role ~= nil then
                wasAntagonist = role.IsAntagonist
            end

            -- if client was no traitor, and in reach of end position, gain a live
            if not wasAntagonist and Traitormod.EndReached(value.Character, self.DistanceToEndOutpostRequired) then
                local msg = ""

                -- award points for mission completion
                if missionReward > 0 then
                    local points = Traitormod.AwardPoints(value, missionReward
                        , true)
                    msg = msg ..
                        Traitormod.Language.CrewWins ..
                        " " .. string.format(Traitormod.Language.PointsAwarded, points) .. "\n\n"
                end

                local lifeMsg, icon = Traitormod.AdjustLives(value,
                    (self.LivesGainedFromCrewMissionsCompleted or 1))
                if lifeMsg then
                    msg = msg .. lifeMsg .. "\n\n"
                end

                if msg ~= "" then
                    Traitormod.SendMessage(value, msg, icon)
                end
            end
        end
    end
end

function gm:TraitorResults()
    local success = false

    local sb = Traitormod.StringBuilder:new()

    local antagonists = {}
    for character, role in pairs(Traitormod.RoleManager.RoundRoles) do
        if role.IsAntagonist then
            table.insert(antagonists, character)
        end

        if role.IsAntagonist then
            sb("%s %s", role.Name, character.Name)
            sb("\n")

            local objectives = 0
            local pointsGained = 0

            for key, value in pairs(role.Objectives) do
                if value:IsCompleted() or value.IsAwarded then
                    objectives = objectives + 1
                    pointsGained = pointsGained + value.AmountPoints
                end
            end

            if objectives > 0 then
                success = true
            end

            sb(Traitormod.Language.SecretSummary, objectives, pointsGained)
        end
    end

    if success then
        Traitormod.Stats.AddStat("Rounds", "Traitor rounds won", 1)
    else
        Traitormod.Stats.AddStat("Rounds", "Crew rounds won", 1)
    end

    -- first arg = mission id, second = message, third = completed, forth = list of characters
    return {TraitorMissionResult(self.RoundEndIcon or Traitormod.MissionIdentifier, sb:concat(), success, antagonists)}
end

function gm:End()
    for key, character in pairs(Traitormod.RoleManager.FindAntagonists()) do
        self:CheckHandcuffedTraitors(character)
    end

    gm:AwardCrew()

    Hook.Remove("characterDeath", "Traitormod.Survival.CharacterDeath")
    Hook.Remove("traitormod.midroundspawn", "Traitormod.Survival.MidRoundSpawn")
    Hook.Remove("character.giveJobItems", "Husk.Survival.giveJobItems")
end

function gm:Think()
    local ended = true

    for key, value in pairs(Character.CharacterList) do
        if not value.IsDead and value.IsHuman and value.TeamID == CharacterTeamType.Team1 then
            local role = Traitormod.RoleManager.GetRole(value)
            if role == nil or not role.IsAntagonist then
                ended = false
            end
        end
    end

    if not self.Ending and Game.RoundStarted and self.EndOnComplete and ended then
        local delay = self.EndGameDelaySeconds or 0
        Traitormod.SendColoredMessageEveryone(Traitormod.Language.HusksWin, "GameModeIcon.pvp", Color.LightSeaGreen)
        Traitormod.Log("Survival gamemode complete. Ending round in " .. delay)

        for key, value in pairs(Character.CharacterList) do
            if value.IsHuman and value.IsDead then
                value.Revive(false)
                Networking.CreateEntityEvent(value, Character.AddToCrewEventData.__new(value.TeamID, {}))
            end
        end

        Timer.Wait(function ()
            Game.EndGame()
        end, delay * 1000)

        self.Ending = true
    end
end

return gm

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

    --[[
    local name = Traitormod.GetRPName(client)
    local msg = string.format(Traitormod.Language.CharacterDeath, name)
    Traitormod.SendMessage(client, msg, "GameModeIcon.pvp")
    --]]
    if not Traitormod.GetData(client, "TrueRPName") then
        Traitormod.ChangeRPName(client, nil)
    end
end

function gm:Start()
    local this = self

    if self.EnableRandomEvents then
        Traitormod.RoundEvents.Initialize()
    end

    Hook.Add("characterDeath", "Traitormod.Survival.CharacterDeath", function(character, affliction)
        this:CharacterDeath(character)
    end)

    Submarine.MainSub.LockX = true
    Submarine.MainSub.LockY = true
    Game.ExecuteCommand("enablecheats")
    Game.ExecuteCommand("disablecrewai") -- Disable human ai (It's laggy as hell)

    local possiblespecialweaponholder = {"autoshotgun","assaultrifle","arcemitter"}
    local randomweaponholder = possiblespecialweaponholder[math.random(1, #possiblespecialweaponholder)]

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
            {"he-cookedcrawlerfilet", 0.75, math.random(1, 2), 2},
            {"he-water", 1, math.random(1, 2), 2},
            {"he-water", 0.25, 1, math.random(1, 2)},
            {"he-water", 0.32, 2, 1},
        },
        seed = {
            {"aquaticpoppyseed", 0.2, 2, 1},
            {"elastinseed", 0.2, 1, 1},
            {"yeastshroomseed", 0.2, 1, 1},
            {"fiberseed", 0.2, 1, 1},
            {"rubberseed", 0.8, 2, math.random(1, 2)},
            {"thal_rustseed", 0.3, 2, 1},
            {"saltvineseed", 0.9, 1, 1},
            {"bubbleberryvineseed", 0.55, 2, 1},
            {"creepingorangevineseed", 0.65, 2, 2},
            {"popnutvineseed", 0.57, 2, 1},
            {"tobaccovineseed", 0.7, 1, 1},
            {"bacteriaslime", 0.5, 2, 1},
            {"seedbag", 1, 1, 1},
            {"fertilizer", 1, 1, 1},
            {"fertilizer", 0.2, 1, 1},
        },
        azoesuitcab = {
            {"armoredivingmask_improved", 0.4, 1, math.random(1, 3)},
            {"armoredivingmask", 0.8, 2, 1},
            {"armoredivingmask", 1, 1, 1},
        },
        tcisuitcab = {
            {"armoredivingmask_improved", 0.35, 1, math.random(1, 2)},
            {"armoredivingmask_improved", 1, 1, 1},
            {"expeditionsuit_institute", 0.45, 1, 1},
            {"armoredivingmask", 1, 1, 1},
        },
        secarmcab = {
            {"revolver", 0.35, 2, 1},
            {"revolver", 0.65, 1, 1},
            {"revolverround", 0.35, 2, math.random(6, 12)},
            {"revolverround", 0.35, 2, math.random(6, 12)},
            {"revolverround", 0.35, 2, math.random(6, 12)},
            {"revolverround", 0.55, 1, math.random(6, 12)},
            {"revolverround", 0.85, 1, math.random(1, 4)},
            {"smg", 1, 1, 1},
            {"smg", 0.75, 1, math.random(1, 2)},
            {"smg", 0.35, 2, 1},
            {"smgmagazine", 0.55, 1, math.random(1, 2)},
            {"smgmagazine", 0.85, 2, 1},
            {"smgmagazine", 0.65, 1, 1},
            {"pistol", 1, 1, 2},
            {"pistol", 0.5, 1, 1},
            {"pistol", 0.5, 1, 1},
            {"pistolmagazine", 0.5, 2, 1},
            {"pistolmagazine", 0.25, 1, 1},
            {"pistolmagazine", 1, 1, math.random(1, 2)},
            {"shotgun", 0.45, 1, 1},
            {"shotgun", 0.15, 2, 1 + math.random(1, 2)},
            {"shotgunshell", 0.85, 1, math.random(1, 4)},
            {"shotgunshell", 0.35, 2, 1 + math.random(1, 2)},
            {"shotgunshell", 0.55, 1, math.random(6, 12)},
            {"assaultriflemagazine", 0.15, 2, math.random(1, 2)},
            {"assaultriflemagazine", 1, 1, math.random(1, 2)},
            {"assaultriflemagazine", 0.5, 1, 1},
            -- Non lethals
            {"shotgunshellblunt", 0.5, 2, math.random(6, 24)},
            {"shotgunshellblunt", 0.85, 1, 4},
            {"RubberMagazineSmg", 0.5, 2, math.random(2, 4)},
            {"RubberMagazineSmg", 1, 1, 1},
            {"thgrubberrevolverround", 1, 1, 6},
            {"thgrubberrevolverround", 0.9, 1, 6},
            {"thgrubberrevolverround", 0.45, 1, math.random(6, 12)},
            -- Grenades
            {"stungrenade", 1, 1, 3},
            {"stungrenade", 0.5, math.random(1, 2), 1},
            {"stungrenade", 0.2, math.random(1, 2), 1},
            {"fraggrenade", 1, 1, math.random(1, 3)},
            {"fraggrenade", 0.5, 1, 1},
            {"incendiumgrenade", 1, 1, 1},
            {"incendiumgrenade", 0.65, math.random(1, 2), math.random(1, 2)},
            {"chemgrenade ", 0.85, 1, math.random(2, 5)},
            {"chemgrenade ", 1, 1, 1},
            {"chemgrenade ", 1, 1, 1},
            {"empgrenade ", 1, 1, math.random(1, 2)},
        },
        specialweaponholder = {
            {randomweaponholder, 1, 1, 1},
        },
        firstaidcab = {
            {"scp_painkillers ", 1, 1, math.random(1, 2)},
            {"scp_painkillers", 0.5, 1, 2},
            {"opium ", 1, 1, 1},
            {"opium ", 0.7, 1, 1},
            {"opium ", 0.75, 1, math.random(1, 3)},
            {"adrenaline ", 0.85, 1, 1},
            {"adrenaline ", 0.5, 1, 1},
            {"adrenaline ", 0.75, 1, math.random(1, 2)},
            {"stabilozine ", 0.5, 2, math.random(1, 2)},
            {"stabilozine ", 1, 1, math.random(1, 2)},
            {"husk_praziquantel", 0.75, 1, math.random(1, 2)},
            {"husk_praziquantel", 0.9, 1, 1},
            {"husk_praziquantel", 0.45, 1, math.random(1, 2)},
            {"antinarc", 0.9, 2, math.random(1, 2)},
            {"antibiotics", 0.9, 2, math.random(1, 2)},
            {"antibiotics", 1, 1, 1},
            {"incendiumsyringe", 1, 1, 1},
            {"scp_adrenaline", 1, 1, 1},
            {"scp_condensedstabilozine", 1, 1, 1},
        },
        engcab = {
            -- Welding
            {"weldingtool", 1, 1, 1},
            {"weldingtool", 1, 1, math.random(1, 2)},
            {"weldingtool", 0.5, 1, 1},
            {"weldingtool", 0.35, 2, 1},
            {"weldingfueltank", 0.5, 1, math.random(1, 3)},
            {"weldingfueltank", 0.9, 2, math.random(1, 2)},
            {"weldingfueltank", 1, 1, math.random(1, 2)},
            {"thgelectrowelder", 0.32, 2, 1},
            -- Electrical
            {"ekutility_advancedheadset", 0.5, 1, 1},
            {"batterycell", 0.85, 2, 1},
            {"batterycell", 1, 1, math.random(1, 2)},
            {"batterycell", 1, 1, 1},
            {"flashlight", 0.5, 2, 1},
            {"flashlight", 0.5, 1, 1},
            {"thgflashlightheavy", 0.52, 1, 1},
            -- Cutting
            {"thgelectrocutter", 0.67, 1, 1},
            {"plasmacutter", 1, 1, 1},
            {"plasmacutter", 0.45, 2, 1},
            {"plasmacutter", 0.8, 1, 1},
            {"plasmacutter", 0.5, 1, math.random(1, 2)},
            -- Other
            {"crowbar", 0.5, 1, 1},
            {"crowbar", 0.25, 1, 1},
        },
    }

    Traitormod.SpawnLootTables(loottable)
end

function gm:PreStart()
    Traitormod.Pointshop.Initialize(self.PointshopCategories or {})

    Hook.Add("character.giveJobItems", "Husk.Survival.giveJobItems", function(character, waypoint)
        if Traitormod.Config.HideCrewList then Networking.CreateEntityEvent(character, Character.RemoveFromCrewEventData.__new(character.TeamID, {})) end
        if Traitormod.Config.RoleplayNames then Traitormod.randomizeCharacterName(character) end

        character.GiveTalent("husk_overwhelmingpresence")
        Traitormod.GiveJobItems(character)
    end)

    Hook.Patch("Barotrauma.Networking.GameServer", "AssignJobs", function (instance, ptable)
        local gamemode = Traitormod.SelectedGamemode
        if gamemode.RoleLock == nil then return end

        for index, client in pairs(ptable["unassigned"]) do
            local flag = false
            local jobName = client.AssignedJob.Prefab.Identifier.ToString()
            local playtimerequired = nil
            for role, params in pairs(gamemode.RoleLock.LockedRoles) do
                if jobName == role then
                    if client.HasPermission(ClientPermissions.ConsoleCommands) then break end
                    if gamemode.RoleLock.LockIf(client, params) then
                        flag = true
                        playtimerequired = params[1]
                    end
                    break
                end
            end
            if flag then
                Traitormod.SendMessage(client, string.format(
                    Traitormod.Language.RoleLocked,
                    client.AssignedJob.Prefab.Name.ToString(),
                    Traitormod.FormatTime(playtimerequired),
                    Traitormod.FormatTime(math.ceil(Traitormod.GetData(client, "Playtime") or 0))
                ))
                client.AssignedJob = Traitormod.MidRoundSpawn.GetJobVariant(gamemode.RoleLock.SubstituteRoles[math.random(1, #gamemode.RoleLock.SubstituteRoles)])
            end
        end
    end, Hook.HookMethodType.After)

    Traitormod.AzoeRadioChannel = math.random(250, 9000) + math.random(1, 100)
    Traitormod.InstituteRadioChannel = math.random(500, 9000) + math.random(100, 200)

    Traitormod.AmountMiners = 0
    Traitormod.AmountTechnicians = 0
    Traitormod.AmountChefs = 0
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
            local name = role.DisplayName or role.Name
            sb("%s %s", name, character.Name)
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
    --[[
    for key, character in pairs(Traitormod.RoleManager.FindAntagonists()) do
        self:CheckHandcuffedTraitors(character)
    end
    --]]

    gm:AwardCrew()

    Hook.Remove("characterDeath", "Traitormod.Survival.CharacterDeath")
    Hook.Remove("traitormod.midroundspawn", "Traitormod.Survival.MidRoundSpawn")
    Hook.Remove("character.giveJobItems", "Husk.Survival.giveJobItems")
end

function gm:Think()
    local ended = true

    for key, value in pairs(Character.CharacterList) do
        if not value.IsDead and value.IsHuman and value.TeamID == CharacterTeamType.Team1 and not value.IsBot then
            local role = Traitormod.RoleManager.GetRole(value)
            if role == nil or not role.IsAntagonist then
                ended = false
            end
        end
    end
    --disable (TEMP)
    --[[
    if not self.Ending and Game.RoundStarted and self.EndOnComplete and ended then
        local delay = self.EndGameDelaySeconds or 0
        Traitormod.SendColoredMessageEveryone(Traitormod.Language.HusksWin, "GameModeIcon.pvp", Color.LightSeaGreen)
        Traitormod.Log("Survival gamemode complete. Ending round in " .. delay)
        Timer.Wait(function ()
            Game.EndGame()
            Traitormod.InstituteRadioChannel = nil
            Traitormod.AzoeRadioChannel = nil
        end, delay * 1000)

        self.Ending = true
    end
    --]]
end

return gm

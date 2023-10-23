local weightedRandom = dofile(Traitormod.Path .. "/Lua/weightedrandom.lua")
local gm = Traitormod.Gamemodes.Gamemode:new()

gm.Name = "Survival"
gm.AntagsSelected = false

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

    local possiblespecialweaponholderTCI = {"autoshotgun","husk_assaultrifle","arcemitter","flamerunique","grenadelauncher"}
    local possiblespecialweaponholderAzoe = {"autoshotgun","shotgununique","arcemitter","harpooncoilrifle","grenadelauncher"}
    local randomweaponholderTCI = possiblespecialweaponholderTCI[math.random(#possiblespecialweaponholderTCI)]
    local randomweaponholderAzoe = possiblespecialweaponholderAzoe[math.random(#possiblespecialweaponholderAzoe)]

    local loottable = {
        --Uses binomial distribution (p is %, n is tries)
        --refrigator = {
        --{'identifier', p, n, amount}
        rations = {
            {"he-humanburger", 0.65, 2, 1},
            {"he-crawlerburger", 0.5, 2, math.random(2)},
            {"he-bread", 0.75, 2, math.random(3)},
            {"banana", 0.4, 2, math.random(2)},
            {"he-cookedthresherfilet", 0.4, 1, 1},
            {"he-cookedcrawlerfilet", 0.75, math.random(2), 2},
            {"he-cookedcrawlerfilet", 0.75, math.random(2), 2},
            {"he-water", 1, math.random(2), 2},
            {"he-water", 0.25, 1, math.random(2)},
            {"he-water", 0.32, 2, 1},
        },
        seed = {
            {"aquaticpoppyseed", 0.2, 2, 1},
            {"elastinseed", 0.2, 1, 1},
            {"yeastshroomseed", 0.2, 1, 1},
            {"fiberseed", 0.2, 1, 1},
            {"rubberseed", 0.8, 2, math.random(2)},
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
            {"armoredivingmask_improved", 0.4, 1, math.random(2)},
            {"armoredivingmask_improved", 0.4, 1, 1},
            {"armoredivingmask_improved", 0.9, 2, 1},
        },
        tcisuitcab = {
            {"armoredivingmask_improved", 0.35, 1, math.random(2)},
            {"armoredivingmask_improved", 0.85, 2, 1},
            {"armoredivingmask_improved", 1, 1, 1},
            {"expeditionsuit_institute", 0.45, 1, math.random(2)},
        },
        minersuitcab = {
            {"armoredivingmask_alternate", 0.35, 1, 1},
            {"armoredivingmask_alternate", 0.2, 2, 1},
            {"armoredivingmask_alternate", 1, 1, 1},
            {"armoredivingmask_alternate", 1, 1, 1},
        },
        minercab = {
            {"minerclothes", 0.45, 2, 1},
            {"orangejumpsuit1", 0.5, 2, 1},
            {"oxygentank", 0.5, 2, math.random(2, 3)},
            {"oxygentank", 1, 1, 1},
            {"aportableminingdrill", 0.3, 2, 1},
            {"plasmacutter", 0.9, 2, 1},
            {"crowbar", 0.75, 2, 1},
            {"crowbarhardened", 0.2, 1, 1},
            {"flashlight", 0.6, 2, 1},
            {"toolbox", 0.7, 3, 1},
            {"divingknife", 0.9, 3, 1},
            {"detonator", 0.5, 1, 1},
            {"UEX", 0.65, 2, 1},
            {"sgt_timedet", 0.95, 1, 1},
            {"button", 1, 1, 1},
            {"screwdriver", 1, 1, 1},
            {"batterycell", 0.85, 3, 1},
            {"husk_oxygenmask", 0.95, 3, 1},
            {"12_shell", 0.7, 2, 12},
            {"husk_landmine", 0.5, 1, 1},
            {"flare", 0.8, 2, math.random(2, 4)},
            {"ek_flare_round", 0.7, 2, math.random(2)},
        },
        secarmcab = {
            {"husk_revolver", 0.35, 2, 1},
            {"husk_revolver", 0.65, 1, 1},
            {"38_round", 0.35, 2, math.random(6, 12)},
            {"38_round", 0.35, 2, math.random(6, 12)},
            {"38_round", 0.35, 2, math.random(6, 12)},
            {"38_round", 0.55, 1, math.random(6, 12)},
            {"38_round", 1, 1, 12},
            {"husk_smg", 1, 1, 1},
            {"husk_smg", 0.75, 1, math.random(2)},
            {"husk_smg", 0.35, 2, 1},
            {"husk_smgunique", 0.15, 1, 1},
            {"husk_smgmag", 0.55, 1, math.random(2)},
            {"husk_smgmag", 0.85, 2, 1},
            {"husk_smgmag", 0.65, 1, 1},
            {"husk_smgmagexpanded", 0.15, 1, math.random(2)},
            {"pistol", 1, 1, 2},
            {"pistol", 0.5, 1, 1},
            {"pistol", 0.5, 1, 1},
            {"husk_pistolmag", 0.55, 2, 1},
            {"husk_pistolmag", 0.85, 1, 2},
            {"husk_pistolmag", 1, 1, math.random(2)},
            {"9mm_round", 0.5, 2, math.random(6, 12)},
            {"9mm_round", 0.25, 1, math.random(6, 24)},
            {"9mm_round", 1, 1, math.random(18, 32)},
            {"9mm_round", 0.85, 1, math.random(6, 12)},
            {"husk_shotgun", 0.45, 1, 1},
            {"husk_shotgun", 0.15, 2, 1 + math.random(2)},
            {"husk_shotgun", 0.75, 1, 1},
            {"12_shell", 0.85, 1, math.random(4)},
            {"12_shell", 0.35, 2, 1 + math.random(2)},
            {"12_shell", 0.55, 1, math.random(6, 12)},
            {"12_shell", 0.9, 1, math.random(12, 18)},
            -- Non lethals
            {"shotgunshellblunt", 0.5, 2, math.random(6, 24)},
            {"shotgunshellblunt", 0.85, 1, 4},
            {"shotgunshellblunt", 1, 1, 12},
            -- Grenades
            {"stungrenade", 1, 1, 3},
            {"stungrenade", 0.5, math.random(2), 1},
            {"stungrenade", 0.2, math.random(2), 1},
            {"fraggrenade", 1, 1, math.random(3)},
            {"fraggrenade", 0.5, 1, 1},
            {"chemgrenade", 0.85, 1, math.random(2, 5)},
            {"chemgrenade", 1, 1, 1},
            {"chemgrenade", 1, 1, 1},
            {"empgrenade", 1, 1, math.random(2)},
        },
        specialweaponholdertci = {{randomweaponholderTCI, 1, 1, 1}},
        specialweaponholderazoe = {{randomweaponholderAzoe, 1, 1, 1}},
        firstaidcab = {
            {"scp_painkillers ", 1, 1, math.random(2)},
            {"scp_painkillers", 0.5, 1, 2},
            {"adrenaline ", 0.85, 1, 1},
            {"adrenaline ", 0.5, 1, 1},
            {"adrenaline ", 0.75, 1, math.random(2)},
            {"stabilozine ", 0.5, 2, math.random(2)},
            {"stabilozine ", 1, 1, math.random(2)},
            {"husk_praziquantel", 0.75, 1, math.random(2)},
            {"husk_praziquantel", 0.9, 1, 1},
            {"husk_praziquantel", 0.45, 1, math.random(2)},
            {"antinarc", 0.9, 2, math.random(2, 4)},
            {"antinarc", 0.5, 1, math.random(2)},
            {"antibiotics", 0.9, 2, math.random(2)},
            {"antibiotics", 1, 1, 1},
            {"incendiumsyringe", 1, 1, 1},
            {"scp_adrenaline", 1, 1, 1},
            {"scp_condensedstabilozine", 1, 1, 1},
        },
        engcab = {
            -- Welding
            {"weldingtool", 1, 1, 1},
            {"weldingtool", 1, 1, math.random(2)},
            {"weldingtool", 0.5, 1, 1},
            {"weldingtool", 0.35, 2, 1},
            {"weldingfueltank", 0.5, 1, math.random(3)},
            {"weldingfueltank", 0.9, 2, math.random(2)},
            {"weldingfueltank", 1, 1, math.random(2)},
            -- Electrical
            {"ekutility_advancedheadset", 0.5, 1, 1},
            {"batterycell", 0.85, 2, 1},
            {"batterycell", 1, 1, math.random(2)},
            {"batterycell", 1, 1, 1},
            {"flashlight", 0.5, 2, 1},
            {"flashlight", 0.5, 1, 1},
            -- Cutting
            {"plasmacutter", 1, 1, 1},
            {"plasmacutter", 0.45, 2, 1},
            {"plasmacutter", 0.8, 1, 1},
            {"plasmacutter", 0.5, 1, math.random(2)},
            -- Other
            {"crowbar", 0.5, 2, 1},
            {"crowbar", 0.25, 1, 1},
            -- Tools
            {"screwdriver", 1, 1, 2},
            {"wrench", 1, 1, 2},
            {"screwdriver", 0.7, math.random(2), 1},
            {"wrench", 0.7, math.random(2), 1},
        },
        stasis = {
            {"stasisbag", 0.3, 2, 1},
            {"stasisbag", 1, 1, 1},
            {"stasisbag", 0.5, 1, 1},
        },
        numbcab = {
            {"opium", 0.85, 2, 1},
            {"opium", 0.35, 2, 1},
            {"opium", 0.65, 3, math.random(3, 4)},
            {"scp_painkillers", 0.4, 2, 1},
            {"antidama1", 0.35, 2, math.random(2)},
        },
        azoemedcab = {
            {"defibrillator", 1, 1, math.random(2)},
            {"aed", 0.25, 1, 1},
            {"healthscanner", 0.5, 1, math.random(2)},
            {"bloodanalyzer", 0.75, 1, math.random(2)},
            {"bvm", 1, 1, math.random(2)},
            {"scp_painkillers", 0.5, 1, 1},
            {"antidama1", 0.5, 2, math.random(4)},
            {"stabilozine", 0.75, 1, math.random(4, 6)},
            {"stabilozine", 1, 1, 2},
            {"liquidoxygenite", 0.8, 1, math.random(3)},
            {"liquidoxygenite", 0.22, 2, math.random(2)},
            {"saline", 0.8, 2, math.random(2, 4)},
            {"suture", 0.85, 1, math.random(8, 12)},
            {"suture", 1, 1, math.random(4, 6)},
            {"antibleeding1", 1, 1, math.random(4, 7)},
            {"antibleeding1", 0.65, 1, math.random(3)},
            {"antibleeding2", 0.75, 2, math.random(2, 4)},
            {"antibleeding3", 0.6, 2, math.random(3)},
            {"antipsychosis", 0.8, 2, math.random(2)},
            {"combatstimulantsyringe", 0.1, math.random(2), 1},
            {"deusizine", 0.45, math.random(2), math.random(2)},
            {"calyxanide", 0.75, math.random(2), math.random(2)},
            {"antibiotics", 0.9, math.random(3), math.random(2)},
            {"husk_praziquantel", 0.9, 1, math.random(2)},
            {"pomegrenadeextract", 1, 1, math.random(4, 6)},
            {"pomegrenadeextract", 0.89, 1, math.random(2)},
            {"antibloodloss2", 1, 1, math.random(2, 4)},
            {"antibloodloss2", 0.35, 1, math.random(2)},
            {"bloodpackoplus", 1, 1, math.random(5, 7)},
            {"scp_adrenaline", 0.55, 1, 1},
            {"he-hotwater", 0.8, 1, math.random(2)},
            {"needle", 1, 1, 1},
            {"needle", 0.4, 1, 1},
        },
        tcimedcab = {
            {"defibrillator", 1, 1, math.random(2)},
            {"aed", 0.25, 1, 1},
            {"healthscanner", 0.5, 1, math.random(2)},
            {"bloodanalyzer", 0.75, 1, math.random(2)},
            {"bvm", 1, 1, math.random(2)},
            {"scp_painkillers", 0.5, 1, 1},
            {"antidama1", 0.5, 2, math.random(4)},
            {"stabilozine", 0.75, 1, math.random(4, 6)},
            {"stabilozine", 1, 1, 2},
            {"liquidoxygenite", 0.8, 1, math.random(3)},
            {"liquidoxygenite", 0.22, 2, math.random(2)},
            {"saline", 0.8, 2, math.random(2, 4)},
            {"suture", 0.85, 1, math.random(8, 12)},
            {"suture", 1, 1, math.random(4, 6)},
            {"antibleeding1", 1, 1, math.random(4, 7)},
            {"antibleeding1", 0.7, 1, math.random(3)},
            {"antibleeding2", 0.8, 2, math.random(2, 4)},
            {"antibleeding3", 0.7, 2, math.random(3)},
            {"antipsychosis", 0.8, 2, math.random(2)},
            {"combatstimulantsyringe", 0.2, math.random(2), 1},
            {"deusizine", 0.45, math.random(2), math.random(2)},
            {"calyxanide", 0.75, math.random(2), math.random(2)},
            {"antibiotics", 0.9, math.random(3), math.random(2)},
            {"husk_praziquantel", 0.9, 1, math.random(2)},
            {"pomegrenadeextract", 1, 1, math.random(4, 6)},
            {"pomegrenadeextract", 0.89, 1, math.random(2)},
            {"antibloodloss2", 1, 1, math.random(2, 4)},
            {"antibloodloss2", 0.35, 1, math.random(2)},
            {"bloodpackoplus", 1, 1, math.random(5, 7)},
            {"scp_adrenaline", 0.8, 1, 1},
            {"needle", 1, 1, 1},
            {"needle", 0.4, 1, 1},
            {"streptokinase", 0.4, 2, 1},
            {"pressuremeds", 0.6, 3, math.random(2)},
        },
        medfabcab = {
            {"adrenaline", 0.9, 1, math.random(3, 6)},
            {"ointment", 0.9, 1, math.random(3, 6)},
            {"ointment", 1, 1, math.random(2, 4)},
            {"chlorine", 0.9, math.random(2, 3), math.random(2)},
            {"phosphorus", 0.75, math.random(2), math.random(3, 4)},
            {"calcium", 0.9, math.random(2), math.random(2, 3)},
            {"chlorine", 0.9, math.random(2), math.random(2, 3)},
            {"potassium", 0.9, math.random(2, 3), math.random(2)},
            {"sodium", 0.9, math.random(2, 3), math.random(2)},
            {"rubber", 0.9, math.random(2, 3), math.random(2, 3)},
            {"magnesium", 0.8, math.random(2), math.random(2, 3)},
            {"plastic", 0.9, math.random(2, 3), math.random(2, 3)},
            {"organicfiber", 0.9, math.random(2), math.random(3)},
            {"swimbladder", 0.09, math.random(2), 1},
            {"adrenalinegland", 0.09, math.random(2), 1},
            {"elastin", 0.75, math.random(3), math.random(2)},
            {"organicfiber", 0.8, math.random(3), math.random(2)},
            {"carbon", 0.75, 2, math.random(3, 4)},
            {"zinc", 0.8, 2, math.random(2, 4)},
            {"tonicliquid", 0.75, math.random(2), math.random(4)},
        },
        toxcontainerazoe = {
            {"huskscanner", 0.8, 1, 1},
            {"huskscanner", 0.25, math.random(2), 1},
            {"antidama2", 0.9, 1, math.random(4)},
            {"antidama2", 1, 1, 1},
            {"lithium", 0.9, math.random(2, 3), math.random(2)},
            {"flashpowder", 0.75, math.random(2), math.random(2)},
            {"alienblood", 0.95, 1, 1},
            {"incendiumsyringe", 0.8, math.random(2), 1},
            {"morbusineantidote", 0.99, 1, math.random(2)},
            {"cyanideantidote", 0.99, 1, math.random(2)},
            {"sufforinantidote", 0.99, 1, math.random(2)},
            {"deliriumineantidote", 1, 1, math.random(2, 3)},
            {"antirad", 1, 1, 1},
            {"antirad", 0.45, 1, 1},
            {"antirad", 0.6, math.random(2), 1},
        },
        toxcontainertci = {
            {"huskscanner", 0.8, 1, 1},
            {"huskscanner", 0.5, math.random(2), 1},
            {"antidama2", 0.9, 1, math.random(4)},
            {"antidama2", 1, 1, 1},
            {"lithium", 0.9, math.random(2, 3), math.random(2)},
            {"flashpowder", 0.75, math.random(2), math.random(2)},
            {"alienblood", 0.95, 1, 1},
            {"incendiumsyringe", 0.8, math.random(3), 1},
            {"morbusineantidote", 0.99, 1, math.random(2)},
            {"cyanideantidote", 0.99, 1, math.random(2)},
            {"sufforinantidote", 0.99, 1, math.random(2)},
            {"deliriumineantidote", 1, 1, math.random(2, 3)},
            {"antirad", 1, 1, 2},
            {"antirad", 0.45, 1, 1},
            {"organscalpel_brain", 0.1, 1, 1},
            {"organscalpel_lungs", 0.4, 1, 1},
            {"organscalpel_kidneys", 0.75, 1, 1},
            {"organscalpel_liver", 0.75, 1, 1},
            {"osteosynthesisimplants", 0.6, math.random(2), 1},
        },
        azoesurgerybox = {
            {"organscalpel_brain", 0.1, 1, 1},
            {"organscalpel_heart", 0.3, 1, 1},
            {"organscalpel_lungs", 0.3, 1, 1},
            {"organscalpel_kidneys", 0.65, 1, 1},
            {"organscalpel_liver", 0.65, 1, 1},
            {"osteosynthesisimplants", 0.8, 1, 1},
        },
        materialcab = {
            {"carbon", 0.75, 2, math.random(3, 4)},
            {"carbon", 0.9, 1, math.random(2)},
            {"organicfiber", 0.75, 2, math.random(3, 4)},
            {"silicon", 0.8, 2, math.random(3, 4)},
            {"titanium", 0.75, 2, math.random(3, 4)},
            {"iron", 0.9, 2, math.random(3, 4)},
            {"copper", 0.95, 2, math.random(3, 4)},
            {"lead", 0.75, 2, math.random(3, 4)},
            {"ballisticfiber", 0.8, 2, math.random(2, 3)},
            {"tin", 0.9, 2, math.random(3, 5)},
            {"zinc", 0.9, 2, math.random(3, 5)},
            {"lead", 0.9, 2, math.random(2, 4)},
            {"fpgacircuit", 0.75, 2, math.random(3)},
            {"rubber", 1, 1, 8},
            {"rubber", 0.65, 1, math.random(3, 6)},
            {"titaniumaluminiumalloy", 0.9, 2, math.random(2, 3)},
            {"steel", 0.95, 2, math.random(3, 4)},
            {"plastic", 0.85, 2, math.random(3, 4)},
            {"scp_durasteel", 0.55, 1, math.random(3)},
            {"magnesium", 0.7, math.random(2), math.random(3)},
            {"lithium", 0.9, math.random(2), math.random(3)},
            {"sulphuriteshard", 0.45, 1, math.random(3)},
            {"oxygeniteshard", 0.38, 1, math.random(2)},
            {"dementonite", 0.32, 1, math.random(2)},
            {"fulgurium", 0.3, 1, math.random(2)},
            {"incendium", 0.25, 1, 1},
            {"physicorium", 0.25, math.random(2), 1},
        },
        materialcabtci = {
            {"carbon", 0.8, 2, math.random(3, 4)},
            {"carbon", 0.9, 1, math.random(2)},
            {"organicfiber", 0.8, 2, math.random(4, 5)},
            {"silicon", 0.9, 2, math.random(3, 4)},
            {"titanium", 0.8, 2, math.random(3, 4)},
            {"iron", 0.9, 2, math.random(4, 5)},
            {"copper", 1, 2, math.random(3, 4)},
            {"lead", 0.85, 2, math.random(3, 4)},
            {"ballisticfiber", 0.85, 2, math.random(2, 3)},
            {"tin", 0.9, 2, math.random(3, 5)},
            {"zinc", 0.9, 2, math.random(3, 5)},
            {"lead", 0.9, 2, math.random(2, 4)},
            {"fpgacircuit", 0.83, 2, math.random(3)},
            {"rubber", 1, 1, 8},
            {"rubber", 0.65, 1, math.random(8)},
            {"titaniumaluminiumalloy", 0.95, 2, math.random(2, 3)},
            {"steel", 0.95, 2, math.random(3, 4)},
            {"plastic", 0.85, 2, math.random(3, 4)},
            {"scp_durasteel", 0.55, 1, math.random(3)},
            {"magnesium", 0.7, math.random(2), math.random(3)},
            {"lithium", 0.9, math.random(2), math.random(3)},
            {"sulphuriteshard", 0.45, 1, math.random(3)},
            {"oxygeniteshard", 0.38, 1, math.random(2)},
            {"dementonite", 0.32, 1, math.random(2)},
            {"fulgurium", 0.3, 1, math.random(2)},
            {"incendium", 0.25, 1, 1},
            {"physicorium", 0.25, math.random(2), 1},
        },
    }

    Traitormod.SpawnLootTables(loottable)
    Traitormod.SpawnWreckedCrates(math.random(4))
    self:SelectAntagonists()
end

function gm:PreStart()
    Traitormod.Pointshop.Initialize(self.PointshopCategories or {})

    Hook.Add("character.giveJobItems", "Husk.Survival.giveJobItems", function(character, waypoint)
        if Traitormod.Config.HideCrewList then Networking.CreateEntityEvent(character, Character.RemoveFromCrewEventData.__new(character.TeamID, {})) end
        if Traitormod.Config.RoleplayNames then Traitormod.randomizeCharacterName(character) end

        Traitormod.GiveJobItems(character)

        local client = Traitormod.FindClientCharacter(character)

        if client and self.AntagsSelected then
            Traitormod.Log("Attempted to choose "..client.Name.." as antag")
            self:SelectAntagonist(client)
        end
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
    Traitormod.AzoeLaunchCodes = math.random(10000, 50000)
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
            if not wasAntagonist then
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

function gm:SelectAntagonists()
    local this = self
    local thisRoundNumber = Traitormod.RoundNumber

    Timer.Wait(function()
        if thisRoundNumber ~= Traitormod.RoundNumber or not Game.RoundStarted then return end

        local clientWeight = {}
        local traitorChoices = 0
        local playerInGame = 0
        for key, value in pairs(Client.ClientList) do
            -- valid traitor choices must be ingame, player was spawned before (has a character), is no spectator
            if value.InGame and value.Character and not value.SpectateOnly then
                -- filter by config
                if this.AntagFilter(value) > 0 and Traitormod.GetData(value, "NonTraitor") ~= true then
                    -- players are alive or if respawning is on and config allows dead traitors (not supported yet)
                    if not value.Character.IsDead and Traitormod.RoleManager.GetRole(value.Character) == nil then
                        clientWeight[value] = (Traitormod.GetData(value, "Weight") or 0) * this.AntagFilter(value)
                        traitorChoices = traitorChoices + 1
                    end
                end
                playerInGame = playerInGame + 1
            end
        end

        if traitorChoices == 0 then
            this:AssignAntagonists({})
            Traitormod.Log("No players to assign traitors")
            return
        end

        local AmountAntags = this.AmountAntags(playerInGame)
        if AmountAntags > traitorChoices then
            AmountAntags = traitorChoices
            Traitormod.Log("Not enough valid players to assign all traitors... New amount: " .. tostring(AmountAntags))
        end

        local antagonists = {}

        for i = 1, AmountAntags, 1 do
            local index = weightedRandom.Choose(clientWeight)

            if index ~= nil then
                Traitormod.Log("Chose " ..
                    index.Character.Name .. " as traitor. Weight: " .. math.floor(clientWeight[index] * 100) / 100)

                table.insert(antagonists, index.Character)

                clientWeight[index] = nil

                Traitormod.SetData(index, "Weight", 0)
            end
        end

        self.AmountAntags = AmountAntags
        self.AmountTotalAntags = #antagonists
        Traitormod.Log("Antagonists have been selected | " .. tostring(self.AntagsSelected))
        self:AssignAntagonists(antagonists)
    end, 8500)
end

function gm:SelectAntagonist(client)
    local this = self

    Timer.Wait(function()
        if not Game.RoundStarted then return end

        local antagonists = {}
        local randomNumber = math.random(2, 6)

        if this.AntagFilter(client) > 0 then
            if not client.Character.IsDead then
                if self.AmountAntags < self.AmountTotalAntags then
                    if math.random(randomNumber) == 1 then
                        Traitormod.Log("Chose "..client.Name.." as antag")
                        table.insert(antagonists, client.Character)
                        self:AssignAntagonists(antagonists)
                    else
                        Traitormod.Log(client.Name.." Failed to become an antag. Reason: Random chance. The number was: "..randomNumber)
                    end
                else
                    Traitormod.Log(client.Name.." Failed to become an antag. Reason: Maximum amount of antags reached.")
                end
            else
                Traitormod.Log(client.Name.." Failed to become an antag. Reason: Client's character was dead.")
            end
        else
            Traitormod.Log(client.Name.." Failed to become an antag. Reason: Antag filter.")
        end
    end, 1500)
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

    self.AntagsSelected = false
    Hook.Remove("characterDeath", "Traitormod.Survival.CharacterDeath")
    Hook.Remove("traitormod.midroundspawn", "Traitormod.Survival.MidRoundSpawn")
    Hook.Remove("character.giveJobItems", "Husk.Survival.giveJobItems")

    for key, client in pairs(Client.ClientList) do
        if Traitormod.Config.RoleplayNames then
            if not client.Character or client.Character.IsDead or not client.Character.IsHuman then
                if not Traitormod.GetData(client, "TrueRPName") then
                    Traitormod.ChangeRPName(client, nil)
                end
            end
        end
    end
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
            Traitormod.AzoeLaunchCodes = nil
        end, delay * 1000)

        self.Ending = true
    end
    --]]
end

return gm

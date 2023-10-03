local config = {}
config.DebugLogs = true

----- USER FEEDBACK -----
config.Languages = {
    dofile(Traitormod.Path .. "/Lua/config/english.lua"), -- If it can't find a specific language key, it will always fallback to the first language on the list.
}
config.Language = "English" -- English, Russian
config.SendWelcomeMessage = true
config.ChatMessageType = ChatMessageType.Private    -- Error = red | Private = green | Dead = blue | Radio = yellow

config.Extensions = {
    dofile(Traitormod.Path .. "/Lua/extensions/playerui.lua"),
    dofile(Traitormod.Path .. "/Lua/extensions/bypassplayercount.lua"),
    dofile(Traitormod.Path .. "/Lua/extensions/hivemind.lua"),
    dofile(Traitormod.Path .. "/Lua/extensions/idcardprinter.lua"),
    dofile(Traitormod.Path .. "/Lua/extensions/constructionmenu.lua"),
    --dofile(Traitormod.Path .. "/Lua/extensions/weaponnerfs.lua"),
    --dofile(Traitormod.Path .. "/Lua/extensions/paralysisnerf.lua"),
    --dofile(Traitormod.Path .. "/Lua/extensions/pressuremidjoin.lua"),
}

config.ExtensionConfig = {

}

----- GAMEPLAY -----
config.Codewords = {
    "hull", "tabacco", "nonsense", "fish", "clown", "hello", "fast", "possibility",
	"thalamus", "hungry", "water", "looks", "renegade", "angry", "green", "sink", "rubber",
	"mask", "sweet", "ice", "crawler", "cult", "secret", "frequency", "red", "blue",
	"husk", "rust", "ruins", "red", "boat", "cats", "rats", "blast", "found", "wreck",
	"tire", "trunk", "weapons", "mudraptors", "cargo", "method", "monkey", "cultist", "fast"
}

config.AmountCodeWords = 2

config.DamageResistance = 0.1
config.OptionalTraitors = true        -- players can use !toggletraitor
config.RagdollOnDisconnect = false
config.EnableControlHusk = true     -- EXPERIMENTAL: enable to control husked character after death
config.DeathLogBook = true
config.HideCrewList = true
config.RoleplayNames = true
config.EnableRPChat = true -- removes phrases like "lol" and "afk"

-- This overrides the game's respawn shuttle, and uses it as a submarine injector, to spawn submarines in game easily. Respawn should still work as expected, but the shuttle submarine file needs to be manually added here.
-- Note: If this is disabled, traitormod will disable all functions related to submarine spawning.
-- Warning: Only respawn shuttles will be used, the option to spawn people directly into the submarine doesnt work.
config.OverrideRespawnSubmarine = true
config.RespawnSubmarineFile = "Content/Submarines/Selkie.sub"
config.RespawnText = "Respawn in %s seconds."
config.RespawnTeam = CharacterTeamType.Team1
config.RespawnOnKillPoints = 0
config.RespawnEnabled = false -- set this to false to disable respawn, respawn shuttle override features will still be active, there just wont be any respawns
config.RespawnTextOnlySpectators = false

-- Allows players that just joined the server to instantly spawn
config.MidRoundSpawn = true

----- POINTS + LIVES -----
config.StartPoints = 3000 -- new players start with this amount of points
config.PermanentPoints = true      -- sets if points and lives will be stored in and loaded from a file
config.RemotePoints = nil
config.RemoteServerAuth = {}
config.PermanentStatistics = true  -- sets if statistics be stored in and loaded from a file
config.MaxLives = 5
config.MinRoundTimeToLooseLives = 30
config.RespawnedPlayersDontLooseLives = true
config.MaxExperienceFromPoints = 500000     -- if not nil, this amount is the maximum experience players gain from stored points (30k = lvl 10 | 38400 = lvl 12)

config.FreeExperience = 750         -- temporary experience given every ExperienceTimer seconds
config.ExperienceTimer = 120

config.PointsGainedFromSkill = {
    medical = 8,
    weapons = 5,
    mechanical = 3,
    electrical = 3,
    helm = 2,
}

config.PointsLostAfterNoLives = function (x)
    return x * 0.75
end

config.AmountExperienceWithPoints = function (x)
    return x
end

-- Give weight based on the logarithm of experience
-- 100 experience = 4 chance
-- 1000 experience = 6 chance
config.AmountWeightWithPoints = function (x)
    return math.log(x + 10) -- add 1 because log of 0 is -infinity
end

----- GAMEMODE -----
config.GamemodeConfig = {
    Survival = {
        PointshopCategories = {"deathspawn", "administrator2"},
        EndOnComplete = true,           -- end round everyone but traitors are dead
        EnableRandomEvents = true,
        EndGameDelaySeconds = 10,

        AntagSelectionMode = "Random",
        AntagTypeChance = {
            InstituteUndercover = 50,
            CaveDwellerBandit = 50,
            Cultist = 50,
        },

        PointsGainedFromCrewMissionsCompleted = 1000,
        LivesGainedFromCrewMissionsCompleted = 1,

        AmountAntags = function (amountPlayers)
            config.TestMode = false
            if amountPlayers > 22 then return 5 end
            if amountPlayers > 18 and math.random() < 0.25 then return 4 end
            if amountPlayers > 12 then return 3 end
            if amountPlayers > 7 then return 2 end
            if amountPlayers > 3 then return 1 end
            if amountPlayers == 1 then
                Traitormod.SendMessageEveryone(Traitormod.Language.TestingMode)
                config.TestMode = true
                return 1
            end
            print("Not enough players to start traitor mode.")
            return 0
        end,

        -- 0 = 0% chance
        -- 1 = 100% chance
        AntagFilter = function (client)
            if client.Character.TeamID ~= CharacterTeamType.Team1 then return 0 end
            if not client.Character.IsHuman then return 0 end
            if not client.Character.HasJob("cavedweller") then return 0 end

            return 1
        end
        --[[
        RoleLock = {
            LockIf = function(client, params)
                local time = params[1]
                if Traitormod.GetData(client, "Playtime") <= time then return true end
                return false
            end
            ,
            -- If the client doesnt meet the playtime requirements, it wont be selected as that role || 5*60*60 = 5 hours

            LockedRoles = { 
                ["adminone"] = {4*60*60},
                ["guardone"] = {2*60*60},
                ["researchdirector"] = {3*60*60},
                ["guardtci"] = {2*60*60},
            },
            SubstituteRoles = {"cavedweller", "citizen"}, -- A random one will be selected
        },
        --]]
    },
}

config.RoleConfig = {
    Technician = {
        AvailableObjectives = {"RepairElectrical", "RepairMechanical", "RepairHull"}
    },

    Miner = {
        AvailableObjectives = {"RepairElectrical", "RepairMechanical", "DeconstructMinerals"},
    },

    Husk = {
        TraitorBroadcast = false,
    },

    -- Cave Dweller Roles

    CaveDwellerBandit = {
        SubObjectives = {"StealCaptainID", "KillAny", "Kidnap"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 55,
        NextObjectiveDelayMax = 95,

        TraitorBroadcast = false,           -- bandits can broadcast to other bandits using !tc
        TraitorBroadcastHearable = true,  -- if true, !tc will be hearable in the vicinity via local chat

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
        SelectUniqueTargets = true,     -- every traitor target can only be chosen once per traitor (respawn+false -> no end)
    },

    InstituteUndercover = {
        AvailableObjectives = {"StealCaptainID", "HeistAzoeCodes", "Kidnap", "StealAzoeIDCard", "AssassinateAzoe"},

        NextObjectiveDelayMin = 5,
        NextObjectiveDelayMax = 10,

        TraitorBroadcast = false,           -- bandits can broadcast to other bandits using !tc
        TraitorBroadcastHearable = true,  -- if true, !tc will be hearable in the vicinity via local chat

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
        SelectUniqueTargets = true,     -- every traitor target can only be chosen once per traitor (respawn+false -> no end)
    },

    Cultist = {
        MinSubObjectives = 2,
        MaxSubObjectives = 3,
        AvailableObjectives = {"DestroyCaly", "TurnHusk", "Husk"},
    },
}

config.ObjectiveConfig = {
    Assassinate = {
        AmountPoints = 600,
    },

    Survive = {
        AlwaysActive = true,
        AmountPoints = 500,
        AmountLives = 1,
    },

    StealCaptainID = {
        AmountPoints = 1300,
    },

    Kidnap = {
        AmountPoints = 2500,
        Seconds = 100,
    },

    PoisonCaptain = {
        AmountPoints = 1600,
    },

    Husk = {
        AmountPoints = 800,
    },

    TurnHusk = {
        AmountPoints = 500,
        AmountLives = 1,
    },

    DestroyCaly = {
        AmountPoints = 500,
    },
}

----- EVENTS -----
config.RandomEventConfig = {
    Events = {
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/communicationsoffline.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/superballastflora.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/maintenancetoolsdelivery.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/medicaldelivery.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/ammodelivery.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/hiddenpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/electricalfixdischarge.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/wreckpirate.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/beaconpirate.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/lightsoff.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/shadymission.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/oxygengenpoison.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/oxygengenhusk.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/randomlights.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/clownmagic.lua"),
    }
}

config.PointShopConfig = {
    Enabled = true,
    DeathTimeoutTime = 60,
    DeathSpawnRefundAtEndRound = true,
    ItemCategories = {
        dofile(Traitormod.Path .. "/Lua/config/pointshop/deathspawn.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/administratorAzoe.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/pointshop/ships.lua"),
    }
}

config.GhostRoleConfig = {
    Enabled = true,
    MiscGhostRoles = {
        ["humanhuskold"] = true,
        ["Huskold"] = true,
        ["Huskabyssold"] = true,
        ["Huskcombatold"] = true,
        ["Huskslipold"] = true,
        ["Huskpucsold"] = true,
        ["Mudraptorhusk"] = true,
        ["Crawlerhusk"] = true,
        ["Mantishusk"] = true,
        ["Defensebot"] = true,
        ["Mudraptor_pet"] = true,
    }
}

return config
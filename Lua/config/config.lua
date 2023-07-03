-- DO NOT EDIT THIS FILE DIRECTLY, instead: Create a file in this very same folder called config.lua, and override the values there. config.lua should automatically be created once you run the game with traitormod installed, but if you for some reason need to create it yourself, check out config.lua.example
-- Note: You can still edit this file directly, but using the above method is recommended so your configs are actually saved when you update this mod.

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
    --dofile(Traitormod.Path .. "/Lua/extensions/weaponnerfs.lua"),
    --dofile(Traitormod.Path .. "/Lua/extensions/paralysisnerf.lua"),
    --dofile(Traitormod.Path .. "/Lua/extensions/pressuremidjoin.lua"),
}

config.ExtensionConfig = {

}

----- GAMEPLAY -----
config.Codewords = {
    "hull", "tabacco", "nonsense", "fish", "clown", "quartermaster", "fast", "possibility",
	"thalamus", "hungry", "water", "looks", "renegade", "angry", "green", "sink", "rubber",
	"mask", "sweet", "ice", "charybdis", "cult", "secret", "frequency",
	"husk", "rust", "ruins", "red", "boat", "cats", "rats", "blast",
	"tire", "trunk", "weapons", "threshers", "cargo", "method", "monkey"
}

config.AmountCodeWords = 2

config.OptionalTraitors = true        -- players can use !toggletraitor
config.RagdollOnDisconnect = false
config.EnableControlHusk = false     -- EXPERIMENTAL: enable to control husked character after death
config.DeathLogBook = true
config.HideCrewList = true
config.RoleplayNames = true

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
        PointshopCategories = {"deathspawn", "ships"},
        EndOnComplete = true,           -- end round everyone but traitors are dead
        EnableRandomEvents = true,
        EndGameDelaySeconds = 15,
        TraitorSelectDelayMin = 120,
        TraitorSelectDelayMax = 150,

        PointsGainedFromCrewMissionsCompleted = 1000,
        LivesGainedFromCrewMissionsCompleted = 1,
    },
}

config.RoleConfig = {
    Crew = {
        AvailableObjectives = {
            ["captain"] = {"KillLargeMonsters", "FinishRoundFast", "SecurityTeamSurvival"},
            ["engineer"] = {"RepairElectrical", "RepairMechanical", "KillSmallMonsters"},
            ["mechanic"] = {"RepairMechanical", "RepairHull", "KillSmallMonsters"},
            ["securityofficer"] = {"KillLargeMonsters", "KillSmallMonsters"},
            ["medicaldoctor"] = {"HealCharacters", "KillSmallMonsters"},
            ["assistant"] = {"RepairElectrical", "RepairMechanical", "KillPets"},
        }
    },

    Cultist = {
        SubObjectives = {"Assassinate", "Kidnap", "TurnHusk", "DestroyCaly"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
    },

    HuskServant = {
        TraitorBroadcast = true,
    },

    Traitor = {
        SubObjectives = {"StealCaptainID", "Survive", "Kidnap", "PoisonCaptain"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, Codewords, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
        SelectUniqueTargets = true,     -- every traitor target can only be chosen once per traitor (respawn+false -> no end)
        PointsPerAssassination = 100,
    },

    Clown = {
        SubObjectives = {"BananaSlip", "SuffocateCrew", "AssassinateDrunk", "GrowMudraptors", "Survive"},
        MinSubObjectives = 3,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
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
        dofile(Traitormod.Path .. "/Lua/config/randomevents/communicationsoffline.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/superballastflora.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/maintenancetoolsdelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/medicaldelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/ammodelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/hiddenpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/electricalfixdischarge.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/wreckpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/beaconpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/abysshelp.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/lightsoff.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/emergencyteam.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/piratecrew.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/outpostpirateattack.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/shadymission.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/oxygengenpoison.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/oxygengenhusk.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/prisoner.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/randomlights.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/clownmagic.lua"),
    }
}

config.PointShopConfig = {
    Enabled = true,
    DeathTimeoutTime = 60,
    DeathSpawnRefundAtEndRound = true,
    ItemCategories = {
        dofile(Traitormod.Path .. "/Lua/config/pointshop/deathspawn.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/ships.lua"),
    }
}

config.GhostRoleConfig = {
    Enabled = true,
    MiscGhostRoles = {
        ["Watcher"] = true,
        ["Mudraptor_pet"] = true,
        ["Fractalguardian"] = true,
        ["Fractalguardian2"] = true,
        ["Fractalguardian3"] = true,
    }
}

return config
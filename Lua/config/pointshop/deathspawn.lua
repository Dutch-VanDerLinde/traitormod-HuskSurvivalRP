local category = {}

category.Identifier = "deathspawn"
category.Decoration = "huskinvite"

category.CanAccess = function(client)
    return client.Character == nil or client.Character.IsDead
end

local function SpawnCreature(species, client, product, paidPrice, insideHuman)
    local spawnwaypoint
    local character

    if species == "human" then
        local info = CharacterInfo(Identifier("human"))
        info.Job = Job(JobPrefab.Get("cavedweller"))

        local spawnwaypoint = Traitormod.GetRandomJobWaypoint("cavedweller")
        character = Character.Create(info, spawnwaypoint.WorldPosition, info.Name, 0, false, true)
        character.GiveJobItems(spawnwaypoint)
        Game.GameSession.CrewManager.AddCharacter(character)
    else
        spawnwaypoint = Traitormod.GetRandomJobWaypoint("MonsterSpawn1")
        Entity.Spawner.AddCharacterToSpawnQueue(species, spawnwaypoint.WorldPosition, function (spawned)
            character = spawned
        end)

        Traitormod.SendTraitorMessageBox(client, Traitormod.Language.HuskServantYou, "oneofus")
        Traitormod.UpdateVanillaTraitor(client, true, Traitormod.Language.HuskServantYou, "oneofus")
    end

    Traitormod.Pointshop.TrackRefund(client, product, paidPrice)
    client.SetClientCharacter(character)
end

category.Products = {
    {
        Identifier = "spawnasdweller",
        Price = 1250,
        Limit = 1,
        IsLimitGlobal = false,
        Timeout = 75,

        RoundPrice = {
            PriceReduction = 500,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("human", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnascrawler",
        Price = 100,
        Limit = 2,
        IsLimitGlobal = false,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 25,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("crawler", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnascrawlerhusk",
        Price = 250,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 250,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("Crawlerhusk", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasraptorhusk",
        Price = 500,
        Limit = 5,
        IsLimitGlobal = true,
        PricePerLimit = 50,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 500,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("mudraptor_unarmoredhusk", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasraptorhuskarmored",
        Price = 650,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 120,

        RoundPrice = {
            PriceReduction = 500,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("mudraptorhusk", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnashusk",
        Price = 600,
        Limit = 5,
        IsLimitGlobal = false,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 600,
            StartTime = 15,
            EndTime = 35,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("humanhuskold", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasmutanthusk",
        Price = 1000,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 500,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 900,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("huskmutanthuman", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasmutanthuskhead",
        Price = 450,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 500,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 900,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("huskmutanthumanhead", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasmutanthuskarmored",
        Price = 2000,
        Limit = 2,
        IsLimitGlobal = true,
        PricePerLimit = 950,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 850,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("huskmutantarmored", client, product, paidPrice)
        end
    },
}

return category
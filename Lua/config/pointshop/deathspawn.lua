local category = {}

category.Identifier = "deathspawn"
category.Decoration = "huskinvite"

category.CanAccess = function(client)
    return client.Character == nil or client.Character.IsDead or not client.Character.IsHuman
end

local function SpawnCreature(species, client, product, paidPrice, insideHuman)
    local spawnPosition = Traitormod.GetRandomJobWaypoint("MonsterSpawn1").WorldPosition

    Entity.Spawner.AddCharacterToSpawnQueue(species, spawnPosition, function (character)
        client.SetClientCharacter(character)
        Traitormod.Pointshop.TrackRefund(client, product, paidPrice)
    end)
end

category.Products = {
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
            SpawnCreature("mudraptorhusk", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnasraptorhuskarmored",
        Price = 650,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

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
        Identifier = "spawnashuskedhumanold",
        Price = 450,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 300,
            StartTime = 15,
            EndTime = 35,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("humanhuskold", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnashusk",
        Price = 600,
        Limit = 3,
        IsLimitGlobal = true,
        PricePerLimit = 100,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 600,
            StartTime = 15,
            EndTime = 35,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("huskold", client, product, paidPrice)
        end
    },

    {
        Identifier = "spawnashuskpucs",
        Price = 900,
        Limit = 4,
        IsLimitGlobal = true,
        PricePerLimit = 175,
        Timeout = 60,

        RoundPrice = {
            PriceReduction = 850,
            StartTime = 15,
            EndTime = 30,
        },

        Action = function (client, product, items, paidPrice)
            SpawnCreature("huskpucsold", client, product, paidPrice)
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
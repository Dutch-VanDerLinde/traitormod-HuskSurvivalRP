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
        SubObjectives = {"StealCaptainID", "KillAny"},
        MinSubObjectives = 1,
        MaxSubObjectives = 2,

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

-- Codeword Verbs and Adjectives

config.CodewordsVerbs = {
    "accept", "add", "admire", "admit", "advise",
    "afford", "agree", "alert", "allow", "amuse",
    "analyse", "announce", "annoy", "answer", "apologize",
    "appear", "applaud", "appreciate", "approve", "argue",
    "arrange", "arrest", "arrive", "ask", "attach",
    "attack", "attempt", "attend", "attract", "avoid",
    "back", "bake", "balance", "ban", "bang",
    "bare", "bat", "bathe", "battle", "beam",
    "beg", "behave", "belong", "bleach", "bless",
    "blind", "blink", "blot", "blush", "boast",
    "boil", "bolt", "bomb", "book", "bore",
    "borrow", "bounce", "bow", "box", "brake",
    "branch", "breathe", "bruise", "brush", "bubble",
    "bump", "burn", "bury", "buzz", "calculate",
    "call", "camp", "care", "carry", "carve",
    "cause", "challenge", "change", "charge", "chase",
    "cheat", "check", "cheer", "chew", "choke",
    "chop", "claim", "clap", "clean", "clear",
    "clip", "close", "coach", "coil", "collect",
    "colour", "comb", "command", "communicate", "compare",
    "compete", "complain", "complete", "concentrate", "concern",
    "confess", "confuse", "connect", "consider", "consist",
    "contain", "continue", "copy", "correct", "cough",
    "count", "cover", "crack", "crash", "crawl",
    "cross", "crush", "cry", "cure", "curl",
    "curve", "cycle", "dam", "damage", "dance",
    "dare", "decay", "deceive", "decide", "decorate",
    "delay", "delight", "deliver", "depend", "describe",
    "desert", "deserve", "destroy", "detect", "develop",
    "disagree", "disappear", "disapprove", "disarm", "discover",
    "dislike", "divide", "double", "doubt", "drag",
    "drain", "dream", "dress", "drip", "drop",
    "drown", "drum", "dry", "dust", "earn",
    "educate", "embarrass", "employ", "empty", "encourage",
    "end", "enjoy", "enter", "entertain", "escape",
    "examine", "excite", "excuse", "exercise", "exist",
    "expand", "expect", "explain", "explode", "extend",
    "face", "fade", "fail", "fancy", "fasten",
    "fax", "fear", "fence", "fetch", "file",
    "fill", "film", "fire", "fit", "fix",
    "flap", "flash", "float", "flood", "flow",
    "flower", "fold", "follow", "fool", "force",
    "form", "found", "frame", "frighten", "fry",
    "gather", "gaze", "glow", "glue", "grab",
    "grate", "grease", "greet", "grin", "grip",
    "groan", "guarantee", "guard", "guess", "guide",
    "hammer", "hand", "handle", "hang", "happen",
    "harass", "harm", "hate", "haunt", "head",
    "heal", "heap", "heat", "help", "hook",
    "hop", "hope", "hover", "hug", "hum",
    "hunt", "hurry", "identify", "ignore", "imagine",
    "impress", "improve", "include", "increase", "influence",
    "inform", "inject", "injure", "instruct", "intend",
    "interest", "interfere", "interrupt", "introduce", "invent",
    "invite", "irritate", "itch", "jail", "jam",
    "jog", "join", "joke", "judge", "juggle",
    "jump", "kick", "kill", "kiss", "kneel",
    "knit", "knock", "knot", "label", "land",
    "last", "laugh", "launch", "learn", "level",
    "license", "lick", "lie", "lighten", "like",
    "list", "listen", "live", "load", "lock",
    "long", "look", "love", "man", "manage",
    "march", "mark", "marry", "match", "mate",
    "matter", "measure", "meddle", "melt", "memorize",
    "mend", "messup", "milk", "mine", "miss",
    "mix", "moan", "moor", "mourn", "move",
    "muddle", "mug", "multiply", "murder", "nail",
    "name", "need", "nest", "nod", "note",
    "notice", "number", "obey", "object", "observe",
    "obtain", "occur", "offend", "offer", "open",
    "order", "overflow", "owe", "own", "pack",
    "paddle", "paint", "park", "part", "pass",
    "paste", "pat", "pause", "peck", "pedal",
    "peel", "peep", "perform", "permit", "phone",
    "pick", "pinch", "pine", "place", "plan",
    "plant", "play", "please", "plug", "point",
    "poke", "polish", "pop", "possess", "post",
    "pour", "practice", "pray", "preach", "precede",
    "prefer", "prepare", "present", "preserve", "press",
    "pretend", "prevent", "prick", "print", "produce",
    "program", "promise", "protect", "provide", "pull",
    "pump", "punch", "puncture", "punish", "push",
    "question", "queue", "race", "radiate", "rain",
    "raise", "reach", "realize", "receive", "recognize",
    "record", "reduce", "reflect", "refuse", "regret",
    "reign", "reject", "rejoice", "relax", "release",
    "rely", "remain", "remember", "remind", "remove",
    "repair", "repeat", "replace", "reply", "report",
    "reproduce", "request", "rescue", "retire", "return",
    "rhyme", "rinse", "risk", "rob", "rock",
    "roll", "rot", "rub", "ruin", "rule",
    "rush", "sack", "sail", "satisfy", "save",
    "scare", "scatter", "scold", "scorch", "scrape",
    "scratch", "scream", "screw", "scribble", "scrub",
    "seal", "search", "separate", "serve", "settle",
    "shade", "share", "shave", "shelter", "shiver",
    "shock", "shop", "shriek", "shrug", "sigh",
    "sign", "signal", "sin", "sip", "ski",
    "skip", "slap", "slip", "slow", "smash",
    "smell", "smile", "smoke", "snatch", "sneeze",
    "sniff", "snore", "snow", "soak", "soothe",
    "sound", "spare", "spark", "sparkle", "spell",
    "spill", "spoil", "spot", "spray", "sprout",
    "squash", "squeak", "squeal", "squeeze", "stain",
    "stamp", "stare", "start", "stay", "steer",
    "step", "stir", "stitch", "stop", "store",
    "strap", "strengthen", "stretch", "stroke", "stuff",
    "subtract", "succeed", "suck", "suffer", "suggest",
    "suit", "supply", "support", "suppose", "surprise",
    "surround", "suspect", "suspend", "switch", "talk",
    "tame", "tap", "taste", "tease", "telephone",
    "tempt", "terrify", "test", "thank", "thaw",
    "tick", "tickle", "tie", "time", "tip",
    "tire", "touch", "tour", "tow", "trace",
    "trade", "train", "transport", "trap", "travel",
    "treat", "tremble", "trick", "trip", "trot",
    "trouble", "trust", "try", "tug", "tumble",
    "turn", "twist", "type", "unfasten", "unite",
    "unlock", "unpack", "untidy", "use", "vanish",
    "visit", "wail", "wait", "walk", "wander",
    "want", "warm", "warn", "wash", "waste",
    "watch", "water", "wave", "weigh", "welcome",
    "whine", "whip", "whirl", "whisper", "whistle",
    "wink", "wipe", "wish", "wobble", "wonder",
    "work", "worry", "wrap", "wreck", "wrestle",
    "wriggle", "yawn", "yell", "zip", "zoom"
}

config.CodewordsAdjectives = {
    "adorable", "adventurous", "aggressive", "alert", "attractive",
    "average", "beautiful", "blue-eyed", "bloody", "blushing",
    "bright", "clean", "clear", "cloudy", "colorful",
    "crowded", "cute", "dark", "drab", "distinct",
    "dull", "elegant", "excited", "fancy", "filthy",
    "glamorous", "gleaming", "gorgeous", "graceful", "grotesque",
    "handsome", "homely", "light", "long", "magnificent",
    "misty", "motionless", "muddy", "old-fashioned", "plain",
    "poised", "precious", "quaint", "shiny", "smoggy",
    "sparkling", "spotless", "stormy", "strange", "ugly",
    "ugliest", "unsightly", "unusual", "wide-eyed", "alive",
    "annoying", "bad", "better", "beautiful", "brainy",
    "breakable", "busy", "careful", "cautious", "clever",
    "clumsy", "concerned", "crazy", "curious", "dead",
    "different", "difficult", "doubtful", "easy", "expensive",
    "famous", "fragile", "frail", "gifted", "helpful",
    "helpless", "horrible", "important", "impossible", "inexpensive",
    "innocent", "inquisitive", "modern", "mushy", "odd",
    "open", "outstanding", "poor", "powerful", "prickly",
    "puzzled", "real", "rich", "shy", "sleepy",
    "stupid", "super", "talented", "tame", "tender",
    "tough", "uninterested", "vast", "wandering", "wild",
    "wrong", "angry", "annoyed", "anxious", "arrogant",
    "ashamed", "awful", "bad", "bewildered", "black",
    "blue", "bored", "clumsy", "combative", "condemned",
    "confused", "crazy,flipped-out", "creepy", "cruel", "dangerous",
    "defeated", "defiant", "depressed", "disgusted", "disturbed",
    "dizzy", "dull", "embarrassed", "envious", "evil",
    "fierce", "foolish", "frantic", "frightened", "grieving",
    "grumpy", "helpless", "homeless", "hungry", "hurt",
    "ill", "itchy", "jealous", "jittery", "lazy",
    "lonely", "mysterious", "nasty", "naughty", "nervous",
    "nutty", "obnoxious", "outrageous", "panicky", "repulsive",
    "scary", "selfish", "sore", "tense", "terrible",
    "testy", "thoughtless", "tired", "troubled", "upset",
    "uptight", "weary", "wicked", "worried", "agreeable",
    "amused", "brave", "calm", "charming", "cheerful",
    "comfortable", "cooperative", "courageous", "delightful", "determined",
    "eager", "elated", "enchanting", "encouraging", "energetic",
    "enthusiastic", "excited", "exuberant", "fair", "faithful",
    "fantastic", "fine", "friendly", "funny", "gentle",
    "glorious", "good", "happy", "healthy", "helpful",
    "hilarious", "jolly", "joyous", "kind", "lively",
    "lovely", "lucky", "nice", "obedient", "perfect",
    "pleasant", "proud", "relieved", "silly", "smiling",
    "splendid", "successful", "thankful", "thoughtful", "victorious",
    "vivacious", "witty", "wonderful", "zealous", "zany",
    "broad", "chubby", "crooked", "curved", "deep",
    "flat", "high", "hollow", "low", "narrow",
    "round", "shallow", "skinny", "square", "steep",
    "straight", "wide", "big", "colossal", "fat",
    "gigantic", "great", "huge", "immense", "large",
    "little", "mammoth", "massive", "miniature", "petite",
    "puny", "scrawny", "short", "small", "tall",
    "teeny", "teeny-tiny", "tiny", "cooing", "deafening",
    "faint", "harsh", "high-pitched", "hissing", "hushed",
    "husky", "loud", "melodic", "moaning", "mute",
    "noisy", "purring", "quiet", "raspy", "resonant",
    "screeching", "shrill", "silent", "soft", "squealing",
    "thundering", "voiceless", "whispering", "ancient", "brief",
    "early", "fast", "late", "long", "modern",
    "old", "old-fashioned", "quick", "rapid", "short",
    "slow", "swift", "young", "bitter", "delicious",
    "fresh", "juicy", "ripe", "rotten", "salty",
    "sour", "spicy", "stale", "sticky", "strong",
    "sweet", "tart", "tasteless", "tasty", "thirsty",
    "fluttering", "fuzzy", "greasy", "grubby", "hard",
    "hot", "icy", "loose", "melted", "nutritious",
    "plastic", "prickly", "rainy", "rough", "scattered",
    "shaggy", "shaky", "sharp", "shivering", "silky",
    "slimy", "slippery", "smooth", "soft", "solid",
    "steady", "sticky", "tender", "tight", "uneven",
    "weak", "wet", "wooden", "yummy", "boiling",
    "breezy", "broken", "bumpy", "chilly", "cold",
    "cool", "creepy", "crooked", "cuddly", "curly",
    "damaged", "damp", "dirty", "dry", "dusty",
    "filthy", "flaky", "fluffy", "freezing", "hot",
    "warm", "wet", "abundant", "empty", "few",
    "heavy", "light", "many", "numerous", "substantial", "capitalist"
}

return config
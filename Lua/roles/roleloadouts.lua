-- Loadouts for each class.
-- 1st number, amount of item. 2nd number, chance. Chance needs to be a number in between 0 and 1.
-- 4th value is the slot that the item equips in automatically.

Traitormod.Loadouts = {
    ["adminone"] = {
        {"smgunique", 0, 1},
    },

    ["guardone"] = {
        {"smgunique", 0, 1},
    },

    ["researchdirector"] = {
        {"thal_geneticsign", 1, 1},
        {"thal_hydrophonicsign", 1, 1},
    },

    ["thal_scientist"] = {
        {"thal_hydrophonicsign", 1, 0.5},
        {"thal_geneticsign", 1, 0.5},
        {"thal_pen", 1, 1},
        {"thal_memo", 1, 1},
    },

    ["guardtci"] = {
        {"smgunique", 0, 1},
    },

    ["cavedweller"] = {
        {"smgunique", 1, 0.09},
        {"smgmagazine", math.random(1, 3), 0.35},
        {"shotgununique", 1, 0.05},
        {"shotgunsawedoff", 1, 0.19},
        {"shotgunshell", math.random(2,12), 0.35},
        {"flarelauncher", 1, 0.65},
        {"flare", math.random(2, 6), 0.4},
        {"flare", math.random(1, 2), 0.9},
        {"batterycell", math.random(1, 2), 0.4},
        {"oxygentank", 1, 1},
        {"oxygentank", math.random(1, 2), 0.2},
        {"oxygentank", 1, 0.5},
        {"riflebullet", math.random(1, 7), 0.29},
        {"thgmultitool", 1, 0.5},
        {"huskstinger", 1, 0.48},
    },
}
Traitormod.Outfits = {
    ["adminone"] = {
        {"captainsuniform3", "captainscap3"},
    },

    ["guardone"] = {
        "","",""
    },

    ["researchdirector"] = {
        {"researchdirectorclothes", "cyanberet"},
    },

    ["guardtci"] = {
        "","",""
    },

    ["thal_scientist"] = {
        {"thal_botanistsuit", "placeholdermask"},
        {"thal_botanistsuit", "thal_botanistmask"},
        {"thal_geneticistsuit", "placeholdermask"},
        {"thal_geneticistsuit", "scientistscannerhud"},
    },

    ["cavedweller"] = { -- Diving Mask is a placeholder for the random masks in giveitemjob function
        -- Brown Jackets
        {"caveclothes1", "placeholdermask", "cavejacketbrown"},
        {"caveclothes1green", "placeholdermask", "cavejacketbrown"},
        {"caveclothes2", "placeholdermask", "cavejacketbrown"},
        {"caveclothes3", "placeholdermask", "cavejacketbrown"},
        {"prisonerclothes", "placeholdermask", "cavejacketbrown"},
        -- Black Coat
        {"caveclothes1", "placeholdermask", "cavejacketblack"},
        {"caveclothes2", "placeholdermask", "cavejacketblack"},
        {"prisonerclothes", "placeholdermask", "cavejacketblack"},
        -- Expedition Suit
        {"caveclothes3", "placeholdermask", "armoredivingmask"},
    },
}
-- Loadouts for each class.
-- 1st number, amount of item. 2nd number, chance. Chance needs to be a number in between 0 and 1.
-- 4th value is the slot that the item equips in automatically.

Traitormod.Loadouts = {
    adminone = {
        {"smgunique", 0, 1},
    },

    guardone = {
        {"smgunique", 0, 1},
    },

    researchdirector = {
        {"thal_geneticsign", 1, 1},
        {"thal_hydrophonicsign", 1, 1},
    },

    thal_scientist = {
        {"thal_hydrophonicsign", 1, 0.5},
        {"thal_geneticsign", 1, 0.5},
        {"thal_pen", 1, 1},
        {"thal_memo", 1, 1},
    },

    guardtci = {
        {"smgunique", 0, 1},
    },

    ["he-chef"] = {
        {"flashlight", 0, 1},
    },

    citizen = {
        {"flashlight", 0, 1},
    },

    cavedweller = {
        {"shotgunshell", math.random(6,12), 0.5},
        {"flare", math.random(2, 6), 0.4},
        {"flare", math.random(1, 2), 0.9},
        {"batterycell", math.random(2), 0.2},
        {"oxygentank", 2, 1},
        {"thgmultitool", 1, 0.5},
        {"huskstinger", 1, 0.4},
        {"redwire", math.random(4), 0.5},
        {"redwire", 2, 1},
    },

    medicaldoctor = {
        {"flashlight", 0, 1},
    },
}
Traitormod.Outfits = {
    researchdirector = {
        clothes = {"researchdirectorclothes"}
    },

    guardtci = {
        wearables = {"scp_riotvest"}
    },

    thal_scientist = {
        clothes = {"thal_botanistsuit", "thal_geneticistsuit"}
    },

    citizen = {},

    cavedweller = {
        clothes = {"caveclothes1", "caveclothes1green", "caveclothes2", "caveclothes3", "prisonerclothes"},
    },

    adminone = {
        wearables = {"captainscap3"}
    },

    medicaldoctor = {
        clothes = {"doctorsuniform2", "doctorsuniform1"},
        wearables = {"surgicalmask"}
    },

    guardone = {
        wearables = {"scp_softvest"},
        randomwearables = {"sgt_fieldcap", "scp_simplehelmet"}
    },
}
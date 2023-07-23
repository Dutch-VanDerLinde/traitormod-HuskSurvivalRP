-- Loadouts for each class.
-- 1st number, amount of item. 2nd number, chance. Chance needs to be a number in between 0 and 1.
-- 4th value is the slot that the item equips in automatically.

Traitormod.Loadouts = {}
Traitormod.Outfits = {}

Traitormod.Loadouts["captain"] = {
	{'autoshotgun', 1, 0.1, InvSlotType.Bag},
	{"handcannon", 1, 0.5},
}

Traitormod.Outfits["captain"] = {
    {"captainsuniform1", "captainscap1"},
    {"captainsuniform2", "captainscap2"},
    {"captainsuniform3", "captainscap3"}
}

Traitormod.Loadouts["cavedweller"] = {
	{"smgunique", 1, 0.09},
    {"smgmagazine", math.random(1, 2), 0.35},
    {"shotgununique", 1, 0.05},
    {"shotgunshell", math.random(1,12), 0.35},
    {"thgflaregun", 1, 0.3},
    {"thgphosphorusflareshot", 2, 0.23},
    {"flare", math.random(1, 5), 0.35},
    {"batterycell", math.random(1, 2), 0.4},
    {"oxygentank", 1, 1},
    {"oxygentank", math.random(1, 2), 0.2},
    {"oxygentank", 1, 0.5},
    {"riflebullet", math.random(1, 7), 0.29},
    {"thgmultitool", 1, 0.5},
    {"huskstinger", 1, 0.48},
}

Traitormod.Outfits["cavedweller"] = { -- Diving Mask is a placeholder for the random masks in giveitemjob function
    -- Brown Jackets
    {"caveclothes1", "placeholdermask", "cavejacketbrown"},
    {"caveclothes1green", "placeholdermask", "cavejacketbrown"},
    {"caveclothes2", "placeholdermask", "cavejacketbrown"},
    {"caveclothes3", "placeholdermask", "cavejacketbrown"},
    -- Black Coat
    {"caveclothes1", "placeholdermask", "cavejacketblack"},
    {"caveclothes2", "placeholdermask", "cavejacketblack"},
    -- Expedition Suit
    {"caveclothes3", "placeholdermask", "armoredivingmask"},
}
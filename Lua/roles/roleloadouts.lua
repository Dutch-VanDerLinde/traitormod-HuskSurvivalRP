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
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

Traitormod.Loadouts["huskJob"] = {
	{"smgunique", 1, 0.09},
    {"shotgununique", 1, 0.05},
    {"shotgunshell", math.random(1,12), 0.35},
    {"thgflaregun", 1, 0.3},
    {"thgphosphorusflareshot", 2, 0.23},
    {"flare", 3, 0.55},
    {"thgflashlightheavy", 1, 0.4},
}

Traitormod.Outfits["huskJob"] = {
    {"divinginstructorgarments"},
    {"divinginstructorgarments", "ballistichelmet1"},
    {"divinginstructorgarments", "divingmask"},
    {"divinginstructorgarments", "bluebeanie"},
    {"divinginstructorgarments", "bluebeanie", "bodyarmor"},
    {"divinginstructorgarments", "divingmask", "bodyarmor"},
    {"banditclothes2", "divingmask"},
    {"banditclothes2", "advanceddivingmask"},
    {"banditclothes2", "baseballcap"},
    {"banditclothes2", "bluebeanie"},
    {"banditclothes2"},
    {"crewchiefclothes"},
    {"crewchiefclothes"},
    {"crewchiefclothes", "captainscap3"},
    {"crewchiefclothes", "bodyarmor"},
    {"crewchiefclothes", "captainscap3"}
}
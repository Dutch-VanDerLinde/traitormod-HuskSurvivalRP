local objective = Traitormod.RoleManager.Objectives.Repair:new()

objective.Name = "RepairMechanical"
objective.AmountPoints = 500
objective.ItemIdentifier = {
"smallpump",
"pump",
"oxygenerator",
"shuttleoxygenerator",
"outpostoxygenerator",
"shuttleoxygeneratorNoSlots",
"deconstructor",
"fabricator",
"engine",
"largeengine",
"shuttleengine",
"coilgunloader", "pulselaserloader", "depthchargeloader", "railgunloader", "chaingunloader", "flakcannonloader",
"door", "doorwbuttons",
"windoweddoor", "windoweddoorwbuttons",
"hatch", "hatchwbuttons", "ductblock",
"ekdockyard_glassdoor","ekdockyard_glassdoorwbuttons",
"ekdockyard_glasshatch","ekdockyard_glasshatchwbuttons",
"ekdockyard_shortdoor",
"ekdockyard_heavydoorvanilla","ekdockyard_heavydoorvanillawbuttons",
"ekdockyard_blastdoor","ekdockyard_blastdoorwbuttons",
"ekdockyard_blasthatch","ekdockyard_blasthatchwbuttons",
"ekdockyard_doormaintenance1_vertical416","ekdockyard_doormaintenance1_vertical256",
"thal_blastdoor","thal_glassdoor","thal_glassdoorwbuttons","thal_glasshatch","thal_glasshatchwbuttons"}
objective.ItemText = Traitormod.Language.MechanicalDevices

return objective

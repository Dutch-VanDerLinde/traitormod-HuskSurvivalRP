local language = {}
language.Name = "English"

language.TipText = "Survival Tip: "
language.Tips = {
    "Want to suggest new content for husk survival? Join the Neurotraumatic RP discord!\ndiscord.gg/SqeTDM9KSP",
    "You can use !role to get information about your current role status.",
    "You can use !help to get a list of all available commands.",
    "You can use !write to write text to a logbook that spawns when you die.",
    "Be careful around cave dwellers.",
    "Ghost roles might become available when you are dead, you can use !ghostrole to claim them.",
    "You can use !deathspawn to respawn as a creature.",
    "Dying in the first 200 seconds as a bought creature refunds the price of it fully.",
    "Use !ooc command to talk about out of character matters.",
    "The round will automatically end once all humans die.",
    "If your original character died, do not worry! You can still be cloned at the institute. Better hope that someone brings you there, though..",
}

language.Help = "\n!help - shows this help message\n!helpadmin - lists all admin commands\n!role - show role info\n!deathspawn - opens the deathspawn shop\n!money - show your money and lives\n!alive - list alive players (only while dead)\n!suicide - kills your character\n!adminhelp - sends a message to an admin and on the discord\n!version - shows running version of the traitormod\n!write - writes to your death logbook\n!playtime - shows how long you've played on the server\n!roundtime - shows the current round time\n!ooc [message] - sends a message to ooc chat"
language.HelpTraitor = "\n!toggletraitor - toggles if the player can be selected as traitor\n!tc [msg] - sends a message to all traitors\n!tannounce [msg] - sends a traitor announcement for traitors\n!tdm [Name] [msg] - sends a anonymous msg to given player"
language.HelpAdmin = "\n!adminpm [player] [msg] - send private message to specificed player\n!roundinfo - show round information (spoiler!)\n!allpoints - shows money amounts of all connected clients\n!addpoint [Client] [+/-Amount] - add money to a client\n!addlife [Client] [+/-Amount] - add life(s) to a client\n!revive [Client] - revives a given client character\n!void [Character Name] - sends a character to the void\n!unvoid [Character Name] - brings a character back from the void\n!vote [text] [option1] [option2] [...] - starts a vote on the server\n!giveghostrole [text] [character] - assigns a character with the specified name as a ghost role"

language.TestingMode = "1P testing mode - no points can be gained or lost"

language.NoTraitor = "You aren't a traitor."
language.TraitorOn = "You can be selected as traitor."
language.TraitorOff = "You can not be chosen traitor.\n\nUse !toggletraitor to change that."
language.RoundNotStarted = "Round not started."

language.ReceivedPoints = "You have received %s dollars."

language.AllTraitorsDead = "All traitors dead!"
language.TraitorsAlive = "There's still traitors alive."

language.Alive = "Alive"
language.Dead = "Dead"

language.KilledByTraitor = "Your death may be caused by a traitor on a secret mission."

language.TraitorWelcome = "You are a traitor!"
language.TraitorDeath = "You have failed in your mission. As a result, the mission has been canceled and you will come back as part of the crew.\n\nYou are no longer a traitor, so play nice!"
language.TraitorDirectMessage = "You received a secret message from a traitor:\n"
language.TraitorBroadcast = "[Traitor %s]: %s"

language.NoObjectivesYet = " > No objectives yet... Stay futile."

language.MainObjectivesYou = "Your main objectives are:"
language.SecondaryObjectivesYou = "Your secondary objectives are:"
language.MainObjectivesOther = "Their main objectives were:"
language.SecondaryObjectivesOther = "Their secondary objectives were:"
language.BasicObjectivesYou = "Your objectives are:"
language.BasicObjectivesOther = "Their objectives were:"

language.CaveDwellerBanditYou = "You are a cave dweller bandit!\n\nYour job is to loot structures and people. You are hostile to everyone except for your partners!"
language.BanditOther = "Bandit %s."
language.SoloBandit = "You are the only bandit."
language.BanditNoticePartners = "Find your partners for a higher chance of survival."

language.CaveDwellerUndercoverYou = "You are an undercover agent working for the Centrum Institute.\n\nGood day, agent. This is your research director speaking. Your job is to spy on the Azoe Region. Make sure they're not against us."
language.UndercoverOther = "Institute Agent %s."
language.SoloAgent = "You are the only institute agent."

language.AzoeMiner = "You are a miner of the Azoe Region. Your job is to mine/find materials, fabricate items and logistics of supplies for the survival of the Azoe Region.\n\nYou have been assigned the following bonus objectives.\n\n"
language.AzoeTechnician = "You are a technician of the Azoe Region. Your job is to operate the reactor, fix devices, and create new electrical/mechanical contraptions.\n\nYou have been assigned the following bonus objectives.\n\n"
language.AzoeChef = "You are the chef of the Azoe Region!\nCook food and make rations so that Azoe Region can thrive."

language.SoloAntagonist = "You are the only antagonist."
language.Partners = "Partners: %s"
language.TcTip = "Use !tc to communicate with your partners."
language.CultistTip = "You have been linked with the husk hivemind; husks are friendly to you and you have the ability to communicate with the hive."

language.TraitorYou = "You are a traitor!"
language.TraitorOther = "Traitor %s."
language.HonkMotherYou = "You are a Honkmother Clown!"
language.HonkMotherOther = "Honkmother Clown %s."
language.CultistYou = "You are a Cultist!\nI was kicked out of the Azoe Region for my great practices.. Now it's time to get revenge."
language.CultistOther = "Cultist %s."
language.HuskServantYou = "You are now a Husk!\nWork together with your hive to infect all other lifeforms."
language.HuskServantOther = "Husk %s."
language.HuskServantTcTip = "You can communicate with your hive by typing in chat.\n\nReminder: If you drop items or are friendly to humans, you will be set to spectator."

language.AgentNoticeCodewords = "There are other agents on this submarine. You dont know their names, but you do have a method of communication. Use the code words to greet the agent and code response to respond. Disguise such words in a normal-looking phrase so the crew doesn't suspect anything."

language.AgentNoticeNoCodewords = "There are other agents on this submarine. You know their names, cooperate with them so you have a higher chance of success."

language.AgentNoticeOnlyTraitor = "You are the only traitor on this ship, proceed with caution."

language.GhostRoleAvailable = "[Ghost Role] New ghost role available: %s (type in chat ‖color:gui.orange‖!ghostrole %s‖color:end‖ to accept)"
language.GhostRolesDisabled = "Ghost roles are disabled."
language.GhostRolesSpectator = "Only spectators can use ghost roles."
language.GhostRolesInGame = "You must be in game to use ghost roles."
language.GhostRolesDead = "(Dead)"
language.GhostRolesTaken = "(Already Taken)"
language.GhostRolesNotFound = "Ghost role not found, did you type the name correctly? Available roles: \n\n"
language.GhostRolesTook = "Someone already took this ghost role."
language.GhostRolesAlreadyDead = "Seems this ghost role is already dead, too bad!"
language.GhostRolesReminder = "Ghost roles available: %s\n\nUse !ghostrole name to pick a role."

language.MidRoundSpawnWelcome = ">> MidRoundSpawn active! <<\nThe round has already started, but you can spawn instantly!"
language.MidRoundSpawn = "Do you want to spawn instantly or wait for the next respawn?\n"
language.MidRoundSpawnMission = "> Spawn"
language.MidRoundSpawnCoalition = "> Spawn Coalition"
language.MidRoundSpawnSeparatists = "> Spawn Separatists"
language.MidRoundSpawnWait = "> Wait"

language.RoundSummary = "| Round Summary |"
language.Gamemode = "Gamemode: %s"
language.RandomEvents = "Random Events: %s"
language.ObjectiveCompleted = "Objective completed: %s"
language.ObjectiveFailed = "Objective failed: %s"
language.CharacterDeath = "Your character %s has died. You are no longer allowed to use information from that character. A new name has been given."

language.CrewWins = "The humans have survived."
language.TraitorHandcuffed = "The crew handcuffed the traitor %s."
language.HusksWin = "All humans have succumbed to the husk! The round ends."

language.TraitorsRound = "Traitors of the round:"
language.NoTraitors = "No traitors."
language.TraitorAlive = "You survived as a traitor."

language.PointsInfo = "You have %s dollars and %s/%s lives."
language.TraitorInfo = "Your traitor chance is %s%%, compared to the rest of the crew."

language.Points = " (%s Dollars)"
language.Experience = " (%s XP)"

language.SkillsIncreased = "Good job on improving your skills."
language.PointsAwarded = "You have been awarded %s dollars."
language.PointsAwardedRound = "This round you gained:\n%s dollars"
language.ExperienceAwarded = "You gained %s XP."

language.LivesGained = "You gained %s. You now have %s/%s Lives."
language.ALife = "one life"
language.Lives = " lives"
language.Death = "You lost a life. You have %s left before you lose money."
language.NoLives = "You lost all your lives. As a result you lose some money."
language.MaxLives = "You have the maximum amount of lives."

language.RoleLocked = "You didn't meet the requirements to be selected as %s.\nThe requirements are:\n%s worth of playtime. Your playtime is %s."
language.CMDLocked = "You need %s worth of playtime to use this command. Your playtime is %s."

language.Codewords = "Code Words: %s"
language.CodeResponses = "Code Responses: %s"

language.OtherTraitors = "All Traitors: %s"

language.CommandTip = "(Type !traitor in chat to show this message again.)"
language.CommandNotActive = "This command is deactivated."

language.Completed = " (Completed)"

language.Objective = "Main Objectives:"
language.SubObjective = "Sub Objectives (optional):"

language.NoObjectives = "No objectives."
language.NoObjectivesYet = "No targets yet..."

language.ObjectiveKillAny = "Kill someone that isn't a bandit."
language.ObjectiveAssassinate = "Assassinate %s."
language.ObjectiveAssassinateAzoe = "Assassinate %s. They are an enemy of the institute."
language.ObjectiveAssassinateDrunk = "Assassinate %s while drunk"
language.ObjectiveAssassinatePressure = "Crush %s with high pressure"
language.ObjectiveBananaSlip = "Slip %s on bananas (%s/%s) times."
language.ObjectiveDestroyCaly = "Deconstruct %s Calyxanide(s)."
language.ObjectiveDrunkSailor = "Give %s more than 80% drunkness."
language.ObjectiveGrowMudraptors = "Grow (%s/%s) mudraptors."
language.ObjectiveHusk = "Turn %s into a full husk."
language.ObjectiveTurnHusk = "Ascend."
language.ObjectiveGiveHusk = "Infect people, by any means necessary."
language.ObjectiveSurvive = "Complete at least one objective and survive the shift."
language.ObjectiveStealCaptainID = "Steal the Azoe Region adminstrator's ID."
language.ObjectiveStealID = "Steal the %s's ID for %s seconds."
language.ObjectiveKidnap = "Bring %s to the institute, we need to interrogate them. Make sure they're in cuffs."
language.ObjectivePoisonCaptain = "Poison %s with %s."
language.ObjectiveWreckGift = "Grab the gift"
language.ObjectiveDestroyMinerals = "Deconstruct %s minerals."
language.ObjectiveStealAzoeCodes = "Steal the Azoe Region administrator's classified codes document. Deliver it to me, the research director."

language.ObjectiveFinishAllObjectives = "Finish all objectives."
language.ObjectiveFinishRoundFast = "Finish the round in less than 20 minutes."
language.ObjectiveHealCharacters = "Do (%s/%s) points of healing."
language.ObjectiveKillMonsters = "Kill (%s/%s) %s."
language.ObjectiveRepair = "Repair (%s/%s) %s"
language.ObjectiveRepairHull = "Repair (%s/%s) damage from the hull."
language.ObjectiveSecurityTeamSurvival = "Make sure at least one member of the security team survives."

language.ObjectiveText = "Assassinate the crew in order to complete your mission."

language.HeistNextTarget = "Better stay low until I can get a new heist in order.."
language.HeistNewObjective = "Your next heist target is %s."
language.HeistLoopComplete = "I stole all I could.. Doesn't look look there will be any heist targets for a while."

language.AssassinationNextTarget = "Stay low until further instructions."
language.AssassinationNewObjective = "Your next assassination target is %s."
language.CultistNextTarget = "The church of husk values your efforts, a new target shall be assigned soon."
language.HuskNewObjective = "Your next husk target is %s."
language.AssassinationEveryoneDead = "Good job agent, you did it!"
language.HonkmotherNextTarget = "Honkmother is pleased with your work, but there is still more to do, wait for further instructions."
language.HonkmotherNewObjective = "Your next target is %s."

language.AbyssHelpPart1 = "Incoming Distress Call... H---! -e-----uck i- --e abys-- W- n--d -e-- A l--her dr---e- us d--- her-. ---se -e a-e of--ring ----thing w- -ave, inclu--- our ---0 -o------"
language.AbyssHelpPart2 = "The transmission cuts out right after."
language.AbyssHelpPart3 = "I can't believe we made it out alive, thank you so much! Here are the points I promised, take this cargo scooter and the LogBook inside. The LogBook should contain the points I promised."
language.AbyssHelpPart4 = "Holy shit! Someone came! Thank you so much! Please find a way to get us out here, I'll give you %s of my points if you can get me out alive."
language.AbyssHelpPart5 = "You could try to get a new battery for this submarine and fix it up."
language.AbyssHelpDead = "I guess that's how it ends...."

language.AmmoDelivery = "A delivery of explosive coilgun ammo and railgun shells has been made to the armoury area of the submarine."
language.BeaconPirate = "There have been reports about a notorious pirate with a PUCS suit terrorizing these waters, the pirate was detected recently inside a beacon station - eliminate the pirate to claim a reward of %s points for the entire crew."
language.WreckPirate = "There have been reports about a notorious pirate with a PUCS suit terrorizing these waters, the pirate was detected recently inside a wrecked submarine - eliminate the pirate to claim a reward of %s points for the entire crew."
language.PirateInside = "Attention! A dangerous PUCS pirate has been detected inside the main submarine!"
language.PirateKilled = "The PUCS pirate has been killed, the crew has received a reward of %s points."

language.ClownMagic = "You feel a strange sensation, and suddenly you're somewhere else."
language.CommunicationsOffline = "Something is interfering with all our communications systems. It's been estimated that communications will be offline for atleast %s minutes."
language.CommunicationsBack = "Communications are back online."
language.EmergencyTeam = "A group of engineers and mechanics have entered the submarine to assist with repairs."
language.LightsOff = "All lights suddenly turn off, but power is still on? What's going on?"
language.MaintenanceToolsDelivery = "A delivery of maintenance tools has been made into the cargo area of the ship. The supplies are inside a yellow crate."
language.MedicalDelivery = "A medical delivery has been made into the medical area of the ship. The medical supplies are inside a red medical crate."
language.PrisonerAboard = "A prisoner is aboard the submarine, keep the prisoner alive and handcuffed until the submarine arrives at it's destination for the crew to receive %s Points."
language.PrisonerYou = "You are a prisoner! If you manage to get 500 meters away from the submarine, you will be rewarded with %s points."
language.PrisonerSuccess = "The prisoner has been successfully transported, the crew has received a reward of %s points."
language.PrisonerFail = "The prisoner has escaped and the transportation reward has been cancelled."
language.OxygenSafe = "The oxygen from the oxygen generator is now safe to breathe again."
language.OxygenHusk = "The oxygen generator has been sabotaged and is now giving husk to whoever breathes it's air, you have about 15 seconds to get a diving mask or a diving suit before you receive a high enough dose!"
language.OxygenPoison = "The oxygen generator has been sabotaged and is now giving sufforin to whoever breathes it's air, you have about 15 seconds to get a diving mask or a diving suit before you receive a high enough dose!"
language.PirateCrew = "Attention! A pirate ship has been spotted in these waters! Destroy the pirate's reactor or kill all pirates to claim a reward of %s points for the entire crew"
language.PirateCrewYou = "You are part of this submarine's pirate crew! Defend the submarine from any filthy coalitions trying to get what is yours!"
language.PirateCrewSuccess = "The pirates have succumbed, the crew has received a reward of %s points."

language.CloneOGClient = "You have been cloned successfully! You remember everything before you went unconscious."
language.CloneRandom = "You are a clone of %s! You don't remember anything, strangely. Who are these people?"

language.ShadyMissionPart1 = "You pickup a weird radio transmission, it sounds like they are looking for someone to do a job for them."
language.ShadyMissionPart2 = "\"Oh hello there! We are looking for someone to do a simple task for us. We are willing to pay up to 3000 points for it. Interested?\""
language.ShadyMissionPart2Answer = "Sure! What's it?"
language.ShadyMissionPart3 = "\"In this area where your submarine is heading through, there's an old wrecked submarine where we need to place some supplies. Because we don't have the supplies available right now, you are going to need to get the supplies yourself. We are going to need at least 8 of any medical item, 4 oxygen tanks, 2 loaded firearms of any type and a special sonar beacon. We will be paying 1500 points for these supplies, if you add any other supplies, we will give you up to 1500 additional points.\""
language.ShadyMissionPart3Answer = "This sounds fishy, why would you want to put these supplies in a wrecked submarine?!"
language.ShadyMissionPart4 = "\"Now this is none of your business, will you do it or not?\""
language.ShadyMissionPart4AnswerAccept = "Accept the offer"
language.ShadyMissionPart4AnswerDeny = "Deny the offer"
language.ShadyMissionPart5 = "\"Great! Just put all the supplies and the special sonar beacon in a metal crate and leave it in the wreck.\""
language.ShadyMissionPart5Answer = "I'll do my best"
language.ShadyMissionBeacon = "‖color:gui.red‖It looks like this sonar beacon was modified.\nBehind it there's a note saying: \"8 medical items, 4 oxygen tanks and 2 loaded firearms.\"‖color:end‖"

language.SuperBallastFlora = "High concentration of ballast flora spores has been detected in this area, it's advised to search pumps for ballast flora!"

language.Answer = "Answer"
language.Ignore = "Ignore"

language.SecretSummary = "Objectives Completed: %s - Points Gained: %s\n"
language.SecretTraitorAssigned = "You have been assigned to be a traitor, vote which type you want to be."

language.ItemsBought = "Items bought from point shop"
language.CrewBoughtItem = "Players bought items from point shop"
language.PointsGained = "Total money gained"
language.PointsLost = "Total money lost"
language.Spawns = "Spawned human characters"
language.Traitor = "Chosen as traitor"
language.TraitorDeaths = "Died as traitor"
language.TraitorMainObjectives ="Main Objectives successful"
language.TraitorSubObjectives = "Sub Objectives successful"
language.CrewDeaths = "Deaths"
language.Rounds = "General Round stats"

language.Yes = "Yes"
language.No = "No"

language.BeingCloned = "You are being cloned. Return to your body?"

language.PointshopInGame = "You must be in game to use the Pointshop."
language.PointshopCannotBeUsed = "This product cannot be used at the moment."
language.PointshopWait = "You have to wait %s seconds before you can use this product."
language.PointshopNoPoints = "You do not have enough money to buy this product."
language.PointshopNoStock = "This product is out of stock."
language.PointshopPurchased = "Purchased \"%s\" for %s dollars\n\nNew bank balance is: %s dollars."
language.PointshopGoBack = ">> Go back <<"
language.PointshopCancel = ">> Cancel <<"
language.PointshopWishBuy = "Your current bank balance: %s dollars\nWhat do you wish to buy?"
language.PointshopInstallation = "The product that you are about to buy will spawn an installation in your exact location, you won't be able to move it else where, do you wish to continue?\n"
language.PointshopNotAvailable = "Point Shop not available."
language.PointshopWishCategory = "Your current bank balance: %s dollars\nChoose a category."
language.PointshopRefunded = "You have been refunded %s dollars for your %s purchase"


language.Pointshop = {
    fakehandcuffs = "Fake Cuffs",
    choke = "Chocker",
    choke_desc = "‖color:gui.red‖Silences the target‖color:end‖",
    jailgrenade = "DarkRP Jail Grenade",
    jailgrenade_desc = "‖color:gui.red‖A special grenade with an interesting surprise...‖color:end‖",
    clowngearcrate = "Clown Gear Crate",
    clowntalenttree = "Clown Talent Tree",
    invisibilitygear = "Invisibility Gear",
    clownmagic = "Clown Magic (Randomly swaps places of people)",
    randomizelights = "Randomize Lights",
    fuelrodlowquality = "Low Quality Fuel Rod",
    gardeningkit = "Gardening Kit",
    randomitem = "Random Item",
    clownsuit = "Clown Suit",
    randomegg = "Random Egg",
    assistantbot = "Assistant Bot",
    firemanscarrytalent = "Firemans Carry Talent",
    stungunammo = "Stun Gun Ammo (x4)",
    revolverammo = "Revolver Ammo (x6)",
    smgammo = "SMG Magazine (x2)",
    shotgunammo = "Shotgun Shells (x8)",
    streamchalk = "Stream Chalk",
    uri = "Uri - Alien Ship",
    seashark = "Sea shark Mark II",
    barsuk = "Barsuk",
    huskattractorbeacon = "Husk Attractor Beacon",
    huskautoinjector = "Husk Auto-Injector",
    huskedbloodpack = "Husked Blood Pack",
    spawnhusk = "Spawn Husk",
    huskoxygensupply = "Husk Oxygen Supply",
    explosiveautoinjector = "Explosive Auto-Injector",
    teleporterrevolver = "Teleporter Revolver",
    poisonoxygensupply = "Poison Oxygen Supply",
    turnofflights = "Turn Off Lights For 3 Minutes",
    turnoffcommunications = "Turn Off Communications For 2 Minutes",
    spawnascrawler = "Spawn as Crawler",
    spawnascrawlerhusk = "Spawn as Crawler Husk",
    spawnaslegacycrawler = "Spawn as Legacy Crawler",
    spawnaslegacyhusk = "Spawn as Legacy Husk (horrible)",
    spawnascrawlerbaby = "Spawn as Crawler Baby",
    spawnasmudraptorbaby = "Spawn as Mudraptor Baby",
    spawnasthresherbaby = "Spawn as Thresher Baby",
    spawnasspineling = "Spawn as Spineling",
    spawnasmudraptor = "Spawn as Mudraptor",
    spawnasmantis = "Spawn as Mantis",
    spawnashusk = "Spawn as Husk",
    spawnasdweller = "Spawn as Cave Dweller (Human)",
    spawnashuskpucs = "Spawn as Husk (PUCS)",
    spawnashuskedhuman = "Spawn as Husked Human",
    spawnasmutanthuskarmored = "Spawn as Mutated Husk Human (Armored)",
    spawnasmutanthusk = "Spawn as Mutated Husk Human",
    spawnasmutanthuskhead = "Spawn as Mutated Husk Human (Head)",
    spawnashuskedhumanold = "Spawn as Husked Human (Rotting)",
    spawnasraptorhusk = "Spawn as Husked Mudraptor",
    spawnasraptorhuskarmored = "Spawn as Husked Mudraptor (Armored)",
    spawnasbonethresher = "Spawn as Bone Thresher",
    spawnastigerthresher = "Spawn as Tiger Thresher",
    spawnaslegacymoloch = "Spawn as Legacy Moloch",
    spawnaslegacycarrier = "Spawn as Legacy Carrier",
    spawnashammerhead = "Spawn as Hammerhead",
    spawnasfractalguardian = "Spawn as Fractal Guardian",
    spawnasgiantspineling = "Spawn as Giant Spineling",
    spawnasveteranmudraptor = "Spawn as Veteran Mudraptor",
    spawnaslatcher = "Spawn as Latcher",
    spawnascharybdis = "Spawn as Charybdis",
    spawnasendworm = "Spawn as Endworm",
    spawnaspeanut = "Spawn as Peanut",
    spawnasorangeboy = "Spawn as Orange Boy",
    spawnascthulhu = "Spawn as Cthulu",
    spawnaspsilotoad = "Spawn as Psilotoad",
    clown = "Clown",
    cultist = "Cultist",
    traitor = "Traitor",
    deathspawn = "Death Spawn",
    wiring = "Wiring",
    ores = "Ores",
    administrator2 = "Administrator",
    administrator = "Administrator",
    security = "Security",
    ships = "Ships",
    materials = "Materials",
    medical = "Medical",
    maintenance = "Maintenance",
    other = "Other",
    idcardlocator = "Id Card Locator",
    idcardlocator_desc = "‖color:gui.red‖Id Card Locator‖color:end‖",
    idcardlocator_result = "%s - %s - %s meters away - %s",
}

language.FakeHandcuffsUsage = "You can free yourself from these handcuffs using !fhc"

language.ShipTooCloseToWall = "Cannot spawn ship, position is too close to a level wall."
language.ShipTooCloseToShip = "Cannot spawn ship, position is too close to another submarine."

language.Pets = "Pets"
language.SmallCreatures = "Small Creatures"
language.LargeCreatures = "Large Creatures"
language.AbyssCreature = "Abyss Creature"
language.ElectricalDevices = "Electrical Devices"
language.MechanicalDevices = "Mechanical Devices"

language.CMDAliveToUse = "You must be alive to use this command."
language.CMDNoRole = "You have no special role."
language.CMDAlreadyDead = "You are already dead!"
language.CMDHandcuffed = "You cant use this command while handcuffed."
language.CMDKnockedDown = "You cant this command while knocked down."
language.GamemodeNone = "Gamemode: None"
language.CMDPermisionPoints = "You do not have permissions to add money."
language.CMDInvalidNumber = "Invalid number value."
language.CMDClientNotFound = "Couldn't find a client with name / steamID."
language.CMDCharacterNotFound = "Couldn't find a character with the specified name."
language.CMDAdminAddedPointsEveryone = "Admin added %s dollars to everyone."
language.CMDAdminAddedPoints = "Admin added %s dollars to %s."
language.CMDAdminAddedLives = "Admin added %s lives to %s."
language.CMDOnlyMonsters = "Only monsters are able to use this command."
language.CMDLocateSub = "Submarine is %sm away from you, at %s."
language.CMDRoundTime = "This round has been going for %s."
language.CMDPlaytime = "Your playtime is %s."
language.CMDHuskChat = "%s (as %s)"
language.CMDOOCChat = "[OOC] %s (as %s)"
language.CMDAliveNoPlayers = "There no alive human players currently."
language.CMDPDAFeedback = "Sent '%s' to Administrator PDA %s."

language.MaleNames = {"Liam","Noah","James","Oliver","Benjamin","Elijah","Lucas","Mason","Logan","Alexander","Ethan","Jacob","Michael","Daniel",
"Henry","Jackson","Sebastian","Aiden","Matthew","Samuel","David","Joseph","Carter","Owen","Wyatt","John","Jack","Luke","Jayden","Dylan",
"Grayson","Levi","Isaac","Gabriel","Julian","Mateo","Anthony","Jaxon","Lincoln","Joshua","Christopher","Andrew","Theodore","Caleb","Ryan",
"Asher","Nathan","Thomas","Leo","Isaiah","Charles","Josiah","Hudson","Christian","Hunter","Connor","Eli","Ezra","Aaron","Landon","Adrian",
"Jonathan","Nolan","Jeremiah","Easton","Elias","Colton","Cameron","Carson","Robert","Angel","Maverick","Nicholas","Dominic","Jaxson",
"Greyson","Adam","Ian","Austin","Santiago","Jordan","Cooper","Brayden","Roman","Evan","Ezekiel","Xavier","Jose","Jace","Jameson","Leonardo",
"Bryson","Axel","Everett","Parker","Kayden","Miles","Sawyer","Jason","Gordon","Timothy","Justin","Brett","Marco","Joe","Jones","Richard",
"Darwin","Jay","Stephen","Jeremy","Fritz","Kevin","Stuart","William","Preston","Dallas","Tobias","Hugo","Yousef","Jeff","Alan",
"Peter","Patrick","Bruce","Tyler","Muhhamed","Abe","Adan","Ahmed","Aldo","Allan","Alonso","Alton","Alvaro","Alvin",
"Andres","Anton","Antony","Arkadi","Arron","Arthur","Arturo","Avery","Barney","Barry","Barton","Ben","Bennie","Bertram","Bill",
"Bo","Boyce","Boyd","Brady","Brian","Britt","Bruno","Bryce","Burl","Burt","Carlos","Carlton","Carmen","Chance","Christoper",
"Chuck","Claude","Dan","Darius","Darrin","Delbert","Dewey","Devin","Dewitt","Dimitry","Dominick","Donn","Dorsey",
"Edgar","Edison","Eldridge","Elmer","Erich","Erik","Ernie","Esteban","Everette","Ezequiel","Filiberto","Frances","Franklin", "Garrett",
"Gerard","Glenn","Gregor","Hal","Harlan","Harrison","Harry","Hector","Herman","Hobert","Igor","Irwin","Ivan","Jackie","Jaime","Jamey","Jan","Jared",
"Jarrod","Jarvis","Jc","Jean","Jerald","Jerrell","Jerrod","Jess","Joel","Johny","Jorge","Josef",
"Jude","Julius","Keith","Kendall","Keneth","Kenton","Kerry","Keven","Kim","Kip","Lamont","Lane","Lanny","Lee","Len","Lenny","Lionel","Lynn",
"Lynwood","Malcom","Manuel","Marc","Marcel","Marcelino","Marcellus","Mathew","Matt","Maurice","Mauricio","Mckinley","Mechislav","Merrill","Messiah",
"Micheal","Milton","Minh","Mitchel","Mitrofan","Mohammad","Monte","Morton","Mose","Murray","Neal","Neil","Nick","Norman","Omari","Orval",
"Oscar","Pedro","Pete","Quincy","Ramon","Randall","Raphael","Raymon","Reed","Reggie","Reginald","Renato","Rene","Rob",
"Roderick","Roland","Romeo","Ronnie","Rosendo","Roy","Rupert","Sammie","Saul","Sergei","Seth","Shelby","Sidney","Simon","Son",
"Sonny","Steve","Stevie","Sylvester","Terrance","Terrell","Timur","Tod","Todd","Tommie","Tory","Travis","Tyson","Ulof","Waldo",
"Warner","Vasili","Wilford","Will","Willie","Willy","Winston","Virgil","Virgilio","Zachary","Clark","Johnathan","Sans","Kieran","Javier","Leviticus",
"Angelo","Colm","Rains","Flaco","Jean-Luc","Zubin","Dutch","Hercule","Gaylord","Banana","Xalamus","Foob","Dillinger","Carl","Freddie","Micah"}

language.FemaleNames = {"Emma","Olivia","Ava","Isabella","Sophia","Charlotte","Mia","Amelia","Harper","Evelyn","Abigail","Emily","Penelope",
"Elizabeth","Mila","Ella","Avery","Ashlynn","Camila","Aria","Scarlett","Victoria","Madison","Luna","Grace","Chloe","Layla","Riley",
"Zoey","Nora","Lily","Eleanor","Hannah","Lillian","Addison","Aubrey","Ellie","Stella","Natalie","Zoe","Leah","Hazel","Violet","Aurora",
"Savannah","Audrey","Brooklyn","Bella","Claire","Skylar","Lucy","Sarah","Paisley","Everly","Anna","Caroline","Nova","Genesis","Emilia",
"Kennedy","Samantha","Maya","Willow","Kinsley","Naomi","Aaliyah","Elena","Ariana","Allison","Gabriella","Alice","Madelyn","Cora","Ruby","Eva",
"Serenity","Autumn","Adeline","Hailey","Gianna","Valentina","Isla","Eliana","Quinn","Nevaeh","Ivy","Sadie","Piper","Lydia","Alexa","Josephine",
"Emery","Julia","Delilah","Arianna","Vivian","Kaylee","Sophie","Brielle","Madeline","Alyx","Jaida","Veronica","Jade","Lisa","Jessica","Rebecca",
"Guenevere","Sandra","Monika","Melissa","Fiona","Bailey","Carmen","Megan","Bethany","Hollie","Isabelle","Carly","Katie","Anika","Scarlet", 
"Ayala","Jenny","Amy","Karen","Albertine","Alexia","Alfredia","Alice","Alita","Alla","Alta","Althea","Alyce","Amee","Amira","Annette","Ara",
"Arcelia","Arie","Armanda","Aryanna","Ashley","Ashly","Astrid","Avril","Azul","Barbra","Beaulah","Bell","Bertha","Bettyann","Beverley","Bridgett",
"Candace","Cara","Carie","Carla","Cathleen","Cathy","Cecille","Christiana","Christine","Cinda","Cleopatra","Codi","Corinne",
"Creola","Criselda","Dahlia","Danielle","Dannette","Darleen","Deborah","Denise","Denisha","Dona","Doria","Dorthy","Elinor","Eliza",
"Elliana","Emerald","Emilee","Erica","Erline","Ethel","Eugenia","Fanny","Fernanda","Glenda","Gloria","Hortensia","Ilene","Ina","Inga",
"Iris","Jacquline","Janee","Janessa","Janie","Jeanene","Jenine","Jina","Jodee","Joy","Joyce","Juana","Julianne","Jutta","Karyn","Katerina",
"Katherina","Kathy","Katrina","Kellie","Kenna","Keri","Kizzie","Kristeen","Kristie","Larissa","Larita","Lauren","Laurie","Laurinda","Lavinia",
"Leanne","Leila","Lelah","Lena","Leola","Lindy","Liza","Lola","Lora","Lorriane","Lorrie","Macey","Mafalda","Maira","Majorie","Marcy",
"Margaret","Margeret","Mariela","Marin","Marissa","Marla","Maryann","Marylee","Masako","Maudie","Maybell","Mechelle","Melany","Melba",
"Michele","Mikaela","Miranda","Muoi","Natalia","Natashia","Nicole","Nola","Noriko","Page","Pamela","Paula","Peggie","Phoenix","Priscilla",
"Randi","Reatha","Renata","Rhonda","Roberta","Roselle","Rosina","Roslyn","Rowena","Ruthie","Sabrina","Sage","Sanda","Sara","Serena","Sharie","Shayla",
"Shelly","Sherise","Sherita","Sherry","Shin","Shirlee","Siena","Socorro","Stefany","Stephane","Summer","Susy","Synthia","Tania",
"Tanika","Tanya","Tawanda","Tera","Tessie","Thea","Tisha","Tracy","Trista","Trudie","Trudy","Valerie","Vanessa","Velma","Yahaira","Zandra","Kieran"}

language.LastNames = {"Smith","Hall","Stewart","Price","Johnson","Allen","Sanchez","Bennett","Jones","Williams","Young","Morris","Wood",
"Hernandez","Rogers","Barnes","Brown","King","Reed","Ross","Davis","Wright","Cook","Henderson","Miller","Lopez","Morgan","Coleman","Wilson",
"Hill","Bell","Jenkins","Moore","Scott","Murphy","Perry","Taylor","Green","Bailey","Powell","Anderson","Adams","Rivera","Long","Thomas",
"Baker","Cooper","Patterson","Jackson","Gonzalez","Richardson","Hughes","White","Nelson","Cox","Flores","Harris","Carter","Howard",
"Washington","Martin","Mitchell","Ward","Butler","Thompson","Perez","Torres","Simmons","Garcia","Roberts","Peterson","Foster","Martinez",
"Turner","Gray","Gonzales","Robinson","Phillips","Ramirez","Bryant","Clark","Campbell","James","Alexander","Rodriguez","Parker","Watson",
"Russell","Lewis","Evans","Brooks","Griffin","Lee","Edwards","Kelly","Diaz","Walker","Collins","Sanders","Hayes","Freeman","Coomer","Judson",
"Boris","Golden","Gatz","Afton","Donaldson","Wolfe","Boseman","Winston","Saulisbury","Clement","Bannon","Breen","Wayne","Truman","Humphrey",
"Nuttingham","Bateman","Dimitrev","Marx","Aguilar","Aker","Angles","Ashley","Atterbury","Avery","Banks","Bartolomeo","Basnett",
"Baumgardner","Beltran","Bergman","Berlin","Berner","Blackwell","Blakley","Boman","Bonham","Books","Box","Bradley","Brady","Breeki",
"Buckley","Burke","Bushman","Callahan","Carey","Carroll","Case","Castillo","Castro","Chandler","Chaney","Chapman",
"Chiu","Clements","Clothier","Cluck","Cobble","Colpitts","Combs","Connors","Cork","Cortese","Craig","Cuevas","Danko","Day",
"Delange","Deloney","Deras","Dews","Dimauro","Dollinger","Donovan","Dorado","Dudley","Duplantier","Dyer","Eastman","Elliott","Ellison","Escobar",
"Feinberg","Feinman","Fesler","Fleig","Flowers","Fonte","Frye","Gadberry","Gallagher","Gallardo","Gears","Geist","Gomez",
"Goodin","Gordon","Gould","Graves","Gregory","Gumbs","Hajek","Hallett","Hampton","Hardy","Harp","Hebert","Hedrick",
"Hefner","Heuer","Higgins","Hillard","Hines","Hinton","Hocker","Hoffman","Holter","House","Huber","Hurley","Hutchinson",
"Huynh","Jack","Keller","Kidd","Kinney","Klein","Knowles","Krall","Kramer","Lane","Larsen","Lavey","Lawrence","Lawson",
"Leonard","Lester","Linares","Little","Lowe","Lozano","Lucas","Lyons","Malone","Mansfield","Marchi","Marquez","Mason","Maxwell","Maynard",
"Maynes","Mcclure","Mcdowell","McLeroy","McNeal","Mcneil","Mead","Meals","Meisner","Mell","Mendel","Mendez","Meza","Molina","Monroe","Mooney",
"Moran","Moses","Mosley","Mulford","Mungo","Navarro","Newton","Nicolosi","Nunez","Ordway","Ouellette","Palmieri","Parchman",
"Parks","Patel","Pearson","Petersen","Phoenix","Pickett","Planck","Pollard","Pool","Poole","Preston","Proctor","Quinn",
"Radebaugh","Radice","Ram","Ramos","Rangel","Reeves","Reynolds","Rhymer","Riddle","Riles","Rios","Robertson","Rolfe","Roman",
"Rosewood","Rowe","Sacks","Santillan","Santistevan","Saunders","Sawyer","Schmitt","Serrano","Severance","Sexton","Shah","Simpson",
"Southworth","Sparks","Stalvey","Stanley","Stein","Stogner","Suarez","Summers","Summitt","Sunderland","Swanger","Swanson","Sykes","Tamashiro",
"Tate","Terry","Thompkins","Tootle","Tseng","Tyson","Ulrich","Walls","Vaughn","Vazquez","Veach","Weaver","Velazquez","Welden","Wheeling",
"Whitely","Wiley","Williams","Zhang","Barotrauma","van der Linde","Matthews","Pinhead","Marston","Escuella","MacGuire","Trelawny","Duffy","Cornwall",
"O'Driscoll","Bronte","Falls","Hernández","Granger","Adler","Picard","Hawley","Federman","Horowitz","Cantor","Compson","Dickens","Fussar","Valdespino",
"Boolean","Man","Harnley","Guitar","Fentanyl","Bones","Dingle","Delcan","Truther","Leana"}


--administrator delivery stuff
language.InstituteCodes = "This document is for %s, the latest research director. These codes should only be given to institute members."
language.AzoeCodes = "This document is for %s, the newly appointed Azoe Region administrator. These codes should be given to trusted personnel only."

language.ToAzoe = "There's a label on it, it says: 'To Azoe Region'"
language.ToMeltwater = "There's a label on it, it says: 'To Meltwater Region'"
language.DeliverySuccess = "Thank you for purchasing. Your supplies will be delivered to you shortly. ETA: 3 minutes"
language.DeliveryArrival = "Your delivery has arrived! It is in the cargo bay of your region."

language.MedicalDeliveryCrate = "A crate full of medical supplies. %s"


language.IntercomSentBy = "Sent by %s (%s)"

return language
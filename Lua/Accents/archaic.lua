-- Credit to SS14 accent file
Traitormod.Accents.archaicaffliction = {
    ["tell"] = "advise",
    ["let me know"] = "awaiting your reply",
    ["use"] = "utilize",
    ["my"] = "mine",
    ["your"] = "thy",
    ["yourself"] = "thyself",
    ["has"] = "hast",
    ["are"] = "art",
    ["presented"] = "bestowed",
    ["by chance"] = "perchance",
    ["nothing"] = "naught",
    ["beg"] = "plead",
    ["full"] = "fraught",
    ["careless"] = "heedless",
    ["of this"] = "hereof",
    ["of that"] = "thereof",
    ["by which"] = "whereby",
    ["in what"] = "wherein",
    ["security"] = "guard",
    ["sec"] = "guard",
    ["gib"] = "butcher",
    ["fancy"] = "furbished",
    ["can i"] = "am i allowed to",
    ["where"] = "whither",
    ["and"] = "an",
    ["accused"] = "appeached",
    ["stain"] = "taint",
    ["take place"] = "befall",
    ["happened"] = "befall'n",
    ["most likely"] = "belike",
    ["suggest"] = "bespeak",
    ["indicate"] = "bespeak",
    ["at once"] = "betimes",
    ["altar"] = "chantry",
    ["salesman"] = "chapman",
    ["shopkeeper"] = "chapman",
    ["ore"] = "chapman",
    ["cheat"] = "cozen",
    ["ilk"] = "consort",
    ["crown"] = "coronal",
    ["certainly"] = "forsooth",
    ["obese"] = "corpulent",
    ["carved"] = "carven",
    ["idiot"] = "cur",
    ["ruined"] = "defiled",
    ["pretend"] = "feign",
    ["abandoned"] = "forlorn",
    ["abandon"] = "forsake",
    ["old woman"] = "gammer",
    ["chop"] = "hew",
    ["slice"] = "hew",
    ["wrong"] = "ill",
    ["reluctant"] = "loth",
    ["true"] = "sooth",
    ["twisted"] = "thrawn",
    ["stubborn"] = "thrawn",
    ["travel"] = "traverse",
    ["thwart"] = "stop",
    ["pest"] = "varmint",
    ["apparition"] = "wraith",
    ["stupid"] = "foolish",
    ["hooray"] = "hurrah",
    ["right now"] = "forthwith",
    ["clown"] = "jester",
    ["write"] = "inscribe",
    ["one time"] = "once",
    ["three times"] = "thrice",
    ["sec off"] = "guardsman",
    ["bar"] = "tavern",
    ["hi"] = "greetings",
    ["heya"] = "greetings",
    ["yeah"] = "indeed",
    ["yup"] = "indeed",
    ["k"] = "alright",
    ["sure"] = "alright",
    ["the"] = "thy",
    ["maybe"] = "perhaps",
    ["alcohol"] = "booze",
    ["id"] = "identification",
    ["locker"] = "closet",
    ["food"] = "grub",
    ["cool"] = "enjoyable",
    ["indeed"] = "certainly",
    ["now"] = "immediately",
    ["will"] = "shalt",
    ["hate"] = "loathe",
    ["bike horn"] = "honker",
    ["pen"] = "quill",
    ["good"] = "well",
    ["I'm"] = "I am",
    ["administrator"] = "lord",
    ["research director"] = "lord",
    ["chapel"] = "church",
    ["ask for"] = "request",
    ["got rid of"] = "removed",
    ["guys"] = "people",
    ["sorry"] = "i apologise",
    ["chair"] = "seating",
    ["kill"] = "murder",
    ["wow"] = "astonishing",
    ["im"] = "i am",
    ["tasty"] = "delectable",
    ["i am hungry"] = "i require grub",
    ["please"] = "i request of thee",
    ["pop"] = "drink",
    ["wants"] = "wishes",
}

-- Create a new table for uppercase variants
local uppercaseReplacements = {}
for word, replacement in pairs(Traitormod.Accents.archaicaffliction) do
    uppercaseReplacements[word:upper()] = replacement:upper()
end

-- Merge the two tables
for word, replacement in pairs(uppercaseReplacements) do
    Traitormod.Accents.archaicaffliction[word] = replacement
end

Traitormod.Accents.replaceWords = function(input, replacements)
    local output = input
    for word, replacement in pairs(replacements) do
        local pattern = word:gsub("(%a+)", function(w)
            return w:lower() == word:lower() and w or w:gsub("%a", "?")
        end)
        output = output:gsub(pattern, function(match)
            return match:lower() == word:lower() and replacement or match
        end)
    end
    return output
end
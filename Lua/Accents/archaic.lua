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
    ["mineral"] = "ore",
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
    ["hello"] = "salutations",
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
    ["below"] = "beneath",
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
    ["liquor"] = "booze",
    ["crate"] = "chest",
    ["do"] = "doth",
    ["saw"] = "observed",
    ["delicious"] = "exquisite",
    ["think"] = "believe",
    ["help"] = "assist",
    ["i am thirsty"] = "i require a drink",
    ["flashlight"] = "torch",
    ["old"] = "olden",
    ["bad"] = "unpleasant",
    ["move"] = "relocate",
    ["fate"] = "doom",
    ["ask"] = "request",
    ["myself"] = "mineself",
    ["going on"] = "happening",
    ["can"] = "may",
    ["why"] = "for what reason",
    ["hey"] = "pardon me",
    ["you suck"] = "thou are foul",
    ["soda"] = "drink",
    ["how"] = "in what way",
    ["want"] = "wish for",
    ["refuse"] = "shun",
    ["frown"] = "glower",
    ["evil"] = "ill",
    ["sharp"] = "keen",
    ["corner"] = "nook",
    ["faint"] = "swoon",
    ["forsee"] = "forbode",
    ["desolate"] = "forlorn",
    ["before"] = "ere",
    ["ruin"] = "defile",
    ["coward"] = "craven",
    ["probably"] = "belike",
    ["burden"] = "fardel",
    ["partnership"] = "consort",
    ["swindler"] = "cog",
    ["cheater"] = "cog",
    ["madenning"] = "bemadding",
    ["request"] = "bespeak",
    ["taken place"] = "befall'n",
    ["was"] = "have been",
    ["obligated"] = "allegiant",
    ["upon"] = "unto",
    ["onto"] = "unto",
    ["under that"] = "thereunder",
    ["by what"] = "whereby",
    ["this"] = "thee",
    ["wonderful"] = "wonderous",
    ["have"] = "hath",
    ["yours"] = "thine",
    ["you"] = "thou",
    ["ya"] = "thou",
    ["consider"] = "deem",
    ["so far"] = "as of this date",
    ["shall"] = "shalt",
    ["yes"] = "aye",
    ["from this point onwards"] = "hereinafter",
    ["gloom"] = "drear",
    ["rush"] = "make haste",
    ["after that"] = "thereafter",
}

Traitormod.Accents.replaceWords = function(input, replacements, speaker)
    local result = {}
    local start = 1

    for i = 1, #input do
        local foundPhrase = false

        for phrase, replacement in pairs(replacements) do
            local phraseStart, phraseEnd = input:find("%f[%a]"..phrase.."%f[%A]", start)

            if phraseStart == start then
                local originalPhrase = input:sub(phraseStart, phraseEnd)

                if type(replacement) ~= "string" then
                    local ReplaceFunc = replacement[1]
                    ReplaceFunc(speaker)
                    replacement = replacement[2]
                elseif originalPhrase == originalPhrase:upper() then
                    replacement = replacement:upper()
                end

                table.insert(result, replacement)
                start = phraseEnd + 1
                foundPhrase = true
                break
            end
        end

        if not foundPhrase then
            local pattern = "([^%s%.%?%!%;:/\\'%+_=%[%] }{ |\\~`!@#%^&*()%-]*['%w]*)([%s%.%?%!%;:/\\'%+_=%[%] }{ |\\~`!@#%^&*()%-]*)(.*)"
            local word, punctuation = input:match(pattern, start)

            if word then
                local replacement = replacements[word:lower()] or word

                if type(replacement) ~= "string" then
                    local ReplaceFunc = replacement[1]
                    ReplaceFunc(speaker)
                    replacement = replacement[2]
                elseif word == word:upper() then
                    replacement = replacement:upper()
                end

                table.insert(result, replacement .. punctuation)
                start = start + #word + #punctuation
            else
                break
            end
        end
    end

    return table.concat(result)
end
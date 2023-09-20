--Stuttering system
Traitormod.Accents.stutter = function (message)
    local finalMessage = ""
    local length = string.len(message)

    for i = 1, length do
        local newLetter = string.sub(message, i, i)

        -- Check if the current character matches the pattern of characters to stutter.
        if newLetter:match("[b-df-hj-np-tv-wxyzB-DF-HJ-NP-TV-WXYZ]") and math.random() < 0.8 then
            if math.random() < 0.1 then
                newLetter = newLetter .. "-" .. newLetter .. "-" .. newLetter .. "-" .. newLetter
            elseif math.random() < 0.2 then
                newLetter = newLetter .. "-" .. newLetter .. "-" .. newLetter
            elseif math.random() < 0.05 then
                newLetter = ""
            else
                newLetter = newLetter .. "-" .. newLetter
            end
        end

        finalMessage = finalMessage .. newLetter
    end

    return finalMessage
end

-- Slurred/drunk system
Traitormod.Accents.drunkslur = function(message, drunkedness)
    -- Ensure that drunkedness is within the 1-100 range
    drunkedness = math.max(1, math.min(100, drunkedness))

    local result = ""
    local length = string.len(message)

    for i = 1, length do
        local character = string.sub(message, i, i)

        if math.random(1, 100) <= drunkedness then
            local lower = string.lower(character)
            local newString = character

            if lower == 'o' then
                newString = "u"
            elseif lower == 's' then
                newString = "ch"
            elseif lower == 'a' then
                newString = "ah"
            elseif lower == 'u' then
                newString = "oo"
            elseif lower == 'c' then
                newString = "k"
            end

            result = result .. newString
        else
            result = result .. character
        end

        if drunkedness >= 50 and math.random(1, 100) <= drunkedness then
            if character == ' ' then
                if drunkedness >= 80 then
                    result = result .. "...huuuhhh..."
                end
            elseif character == '.' then
                if drunkedness >= 85 then
                    result = result .. " *BURP*"
                end
            end
        end

        if drunkedness >= 75 and not (math.random(1, 100) <= drunkedness) then
            local next = math.random(1, 3)

            if next == 1 then
                result = result .. "'"
            elseif next == 2 then
                result = result .. character .. character
            else
                result = result .. character .. character .. character
            end
        elseif drunkedness >= 25 and not (math.random(1, 100) <= drunkedness) then
            result = result .. character .. character
        else
            result = result .. character
        end
    end

    return result
end

-- Function to shuffle a string randomly with intensity controlled by value
local function shuffleString(input, value)
    local result = {}
    local len = #input

    for i = 1, len do
        local char = input:sub(i, i)
        if math.random(80) <= value - 50 then -- Subtract 50 to start shuffling from value 50
            char = input:sub(math.random(len), math.random(len))
        end
        result[i] = char
    end

    return table.concat(result)
end

-- brain hemorrhage stuff
Traitormod.Accents.brainbleed = function(input, value)
    if value < 50 then
        return input -- No weird text below 50
    elseif value > 100 then
        value = 100
    end

    if value > 85 then
        -- Replace with a random phrase
        local randomPhrases = {
            "About...time...",
            "...I...found...it!",
            "Who...?",
            "Whaaat?",
            "Whhh.....",
            "th...th....",
            "Th...anks....",
            "But.....how?",
            "NO!",
            "Y...Y..YES!",
            "YES!",
            "Yes..?",
            "B......ye!",
            "N...ice",
            "There....it....is",
            "g..g......g....",
            "Get....get...that..thing!",
            "there....w..we.....go",
            "damn......it....",
            "damn.....it?....",
            "funny..",
            "help..",
            "help....ME...",
            "help....ME.....NOW!!",
            "that's...funny...........",
            "tht's......funny....?.",
            "get...him....!",
            "get...her....!",
            "get.....him...?",
            "get.....her...?",
            "kill...the..one...",
            "kill...the..twoooooooo...!",
            "fucking....",
            "HUSK!",
            "That's...a...husk!",
            "Yeah!",
            "Yeah...yeah...yeah......yeah",
            "Yeah...yeah..no......yeah",
            "fucking..hell....",
            "i like...it!",
            "seems...nice!",
            "what..in....god...",
            "what..hmm...",
            "what...you...say?",
            "what..it......say..?",
            "OF...COURSE!",
            "OF...COURSE.......NOT!",
            "saying? no...no...no!",
            "fuck...........off!",
            "FIRE!",
            "IT'S...ON.....FIRE...PUT...!",
            "IT'S...ON.....FIRE...PUT.........IT...............OUT!!!",
            "IT'S...FIRE.....ON...PUT.........IT!!!",
            "I need....some water, please...?",
            "I....need....water some, please...",
            "I....need....water...",
            "I....need....foooooood...",
            "I....need....fod...",
            "I....need......",
            "doctor......PLEASE!",
            "hey...there!",
            "what's up....guys??",
            "of course??",
            "DENIED!",
        }
        input = randomPhrases[math.random(#randomPhrases)]
    end

    local scrambledWords = {}
    for word in input:gmatch("%S+") do
        local scrambledWord = shuffleString(word, value)
        table.insert(scrambledWords, scrambledWord)
    end

    return table.concat(scrambledWords, " ")
end
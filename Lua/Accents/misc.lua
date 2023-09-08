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
Traitormod.Accents.drunk = function(message, drunkedness)
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
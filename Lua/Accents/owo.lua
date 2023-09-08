--OwO accent
Traitormod.Accents.OwO = function (message)
    local specialWords = {
        ["you"] = "wu",
    }

    for word, replacement in pairs(specialWords) do
        message = message:gsub(word, replacement)
    end

    local faces = {
        " (・`ω´・)", " ;;w;;", " owo", " UwU", " >w<", " ^w^"
    }

    message = message:gsub("!", function()
        return faces[math.random(#faces)]
    end)

    message = message:gsub("[rR]", {
        ["r"] = "w",
        ["R"] = "W"
    })

    message = message:gsub("[lL]", {
        ["l"] = "w",
        ["L"] = "W"
    })

    return message
end
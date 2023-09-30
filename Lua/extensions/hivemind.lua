local extension = {}

extension.Identifier = "HuskComms"

extension.Init = function ()
    Hook.Add("chatMessage", "Traitormod.ChatMessageHivemindComms", function(message, client)
        local character = client.Character

        if character and not character.IsHuman and character.SpeciesName ~= "Crawler" then
            Traitormod.SendHuskChatMessage(message, client)
            return true
        end
    end)
end

return extension
local extension = {}

extension.Identifier = "HuskComms"

extension.Init = function ()
    Hook.Add("chatMessage", "Traitormod.ChatMessageHivemindComms", function(message, client)
        local character = client.Character

        if character and not character.IsHuman and character.SpeciesName ~= "Crawler" then
            for _, loopclient in pairs(Client.ClientList) do
                if (not loopclient.Character or loopclient.Character.IsDead) or not loopclient.Character.IsHuman then
                    local formatedname = string.format(Traitormod.Language.CMDHuskChat, client.Name, client.Character.Name)
                    local chatMessage = ChatMessage.Create(formatedname, message, ChatMessageType.Default, character, client)
                    chatMessage.Color = Color(60,107,195,255)
                    Game.SendDirectChatMessage(chatMessage, loopclient)
                end
            end

            return true
        end
    end)
end

return extension
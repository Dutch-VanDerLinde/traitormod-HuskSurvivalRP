local role = Traitormod.RoleManager.Roles.Antagonist:new()

role.Name = "Husk"
role.IsAntagonist = false

function role:Start()
    local text = self:Greet()
    local client = Traitormod.FindClientCharacter(self.Character)
    if client then
        Traitormod.SendTraitorMessageBox(client, text, "oneofus")
        Traitormod.UpdateVanillaTraitor(client, true, text, "oneofus")
    end
end

function role:Greet()
    local partners = Traitormod.StringBuilder:new()
    local traitors = Traitormod.RoleManager.FindAntagonists()
    for _, character in pairs(traitors) do
        if character ~= self.Character then
            local client = Traitormod.FindClientCharacter(character)
            if client then
                partners('"%s" ', client.Name)
            end
        end
    end
    partners = partners:concat(" ")

    local sb = Traitormod.StringBuilder:new()
    sb(Traitormod.Language.HuskServantYou)

    sb("\n\n")
    sb(Traitormod.Language.HuskFellows, partners)

    if self.TraitorBroadcast then
        sb("\n\n%s", Traitormod.Language.HuskServantTcTip)
    end

    return sb:concat()
end

function role:OtherGreet()
    local sb = Traitormod.StringBuilder:new()
    sb(Traitormod.Language.HuskServantOther, self.Character.Name)
    return sb:concat()
end

return role

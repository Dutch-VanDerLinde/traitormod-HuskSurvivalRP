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
    local sb = Traitormod.StringBuilder:new()
    sb(Traitormod.Language.HuskServantYou)

    sb("\n\n")

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

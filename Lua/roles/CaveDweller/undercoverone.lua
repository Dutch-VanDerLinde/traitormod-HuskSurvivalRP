local role = Traitormod.RoleManager.Roles.Antagonist:new()

role.Name = "InstituteUndercover"
role.DisplayName = "Undercover Institute Agent"
role.IsAntagonist = true
role.StartSound = "traitormod_undercoverstart"

function role:Start()
    Traitormod.Stats.AddCharacterStat("Undercover", self.Character, 1)

    local availableObjectives = self.AvailableObjectives

    if not availableObjectives or #availableObjectives == 0 then
        return
    end

    local pool = {}
    for key, value in pairs(availableObjectives) do pool[key] = value end

    for i = 1, 3, 1 do
        local objective = Traitormod.RoleManager.RandomObjective(pool)
        if objective == nil then break end

        objective = objective:new()

        local character = self.Character
        objective:Init(character)
        local target = self:FindValidTarget(objective)

        if objective:Start(target) then
            self:AssignObjective(objective)
            for key, value in pairs(pool) do
                if value == objective.Name then
                    table.remove(pool, key)
                end
            end
        end
    end

    local text = self:Greet()
    local client = Traitormod.FindClientCharacter(self.Character)
    if client then
        Traitormod.SendBoxMessage(client, text, "FactionLogo.Insitute", Color.Aquamarine)
        Traitormod.UpdateVanillaTraitor(client, true, text)
    end
end


function role:End(roundEnd)
    local client = Traitormod.FindClientCharacter(self.Character)
    if not roundEnd and client then
        Traitormod.UpdateVanillaTraitor(client, false)
    end
end

---@return string objectives
function role:ObjectivesToString()
    local objs = Traitormod.StringBuilder:new()

    for _, objective in pairs(self.Objectives) do
        if objective:IsCompleted() then
            objs:append(" > ", objective.Text, Traitormod.Language.Completed)
        else
            objs:append(" > ", objective.Text, string.format(Traitormod.Language.Points, objective.AmountPoints))
        end
    end

    return objs:concat("\n")
end

function role:Greet()
    local partners = Traitormod.StringBuilder:new()
    local agents = Traitormod.RoleManager.FindUndercovers()
    for _, character in pairs(agents) do
        if character ~= self.Character then
            partners('"%s" ', character.Name)
        end
    end
    partners = partners:concat(" ")
    local objectives = self:ObjectivesToString()

    local sb = Traitormod.StringBuilder:new()
    sb("%s\n\n", Traitormod.Language.CaveDwellerUndercoverYou)
    sb("%s\n", Traitormod.Language.BasicObjectivesYou)
    sb(objectives)
    sb("\n\n")
    if #agents < 2 then
        sb(Traitormod.Language.SoloAgent)
    else
        sb(Traitormod.Language.BanditNoticePartners)
        sb("\n")
        sb(Traitormod.Language.Partners, partners)
    end

    return sb:concat()
end

function role:OtherGreet()
    local sb = Traitormod.StringBuilder:new()
    local objectives = self:ObjectivesToString()
    sb(Traitormod.Language.UndercoverOther, self.Character.Name)
    sb("\n%s\n", Traitormod.Language.BasicObjectivesOther)
    sb(objectives)
    return sb:concat()
end

return role

local role = Traitormod.RoleManager.Roles.Antagonist:new()

role.Name = "CaveDwellerBandit"
role.IsAntagonist = true
role.StartSound = "traitormod_undercoverstart"

function role:Start()
    Traitormod.Stats.AddCharacterStat("Bandit", self.Character, 1)
    self.Character.TeamID = CharacterTeamType.Team2

    local killobjective = Traitormod.RoleManager.Objectives.KillAny:new()
    killobjective:Init(self.Character)
    self:AssignObjective(killobjective)

    local pool = {}
    for key, value in pairs(self.SubObjectives) do pool[key] = value end

    local toRemove = {}
    for key, value in pairs(pool) do
        local objective = Traitormod.RoleManager.FindObjective(value)
        if objective ~= nil and objective.AlwaysActive then
            objective = objective:new()

            local character = self.Character

            objective:Init(character)
            objective.OnAwarded = function ()
                Traitormod.Stats.AddCharacterStat("TraitorSubObjectives", character, 1)
            end

            if objective:Start(character) then
                self:AssignObjective(objective)
                table.insert(toRemove, key)
            end
        end
    end
    for key, value in pairs(toRemove) do table.remove(pool, value) end

    for i = 1, math.random(self.MinSubObjectives, self.MaxSubObjectives), 1 do
        local objective = Traitormod.RoleManager.RandomObjective(pool)
        if objective == nil then break end

        objective = objective:new()

        local character = self.Character

        objective:Init(character)
        local target = self:FindValidTarget(objective)

        objective.OnAwarded = function ()
            Traitormod.Stats.AddCharacterStat("TraitorSubObjectives", character, 1)
        end

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
        Traitormod.SendTraitorMessageBox(client, text)
        Traitormod.UpdateVanillaTraitor(client, true, text)
    end
end


function role:End(roundEnd)
    local client = Traitormod.FindClientCharacter(self.Character)
    if not roundEnd and client then
        Traitormod.UpdateVanillaTraitor(client, false)
    end
end

---@return string mainPart, string subPart
function role:ObjectivesToString()
    local primary = Traitormod.StringBuilder:new()
    local secondary = Traitormod.StringBuilder:new()

    for _, objective in pairs(self.Objectives) do
        -- Assassinate objectives are primary
        local buf = objective.Name == "KillAny" and primary or secondary

        if objective:IsCompleted() or objective.Awarded then
            buf:append(" > ", objective.Text, Traitormod.Language.Completed)
        else
            buf:append(" > ", objective.Text, string.format(Traitormod.Language.Points, objective.AmountPoints))
        end
    end
    if #primary == 0 then
        primary(Traitormod.Language.NoObjectivesYet)
    end

    return primary:concat("\n"), secondary:concat("\n")
end

function role:Greet()
    local partners = Traitormod.StringBuilder:new()
    local bandits = Traitormod.RoleManager.FindBandits()
    for _, character in pairs(bandits) do
        if character ~= self.Character then
            partners('"%s" ', character.Name)
        end
    end
    partners = partners:concat(" ")
    local primary, secondary = self:ObjectivesToString()

    local sb = Traitormod.StringBuilder:new()
    sb("%s\n\n", Traitormod.Language.CaveDwellerBanditYou)
    sb("%s\n", Traitormod.Language.MainObjectivesYou)
    sb(primary)
    sb("\n\n%s\n", Traitormod.Language.SecondaryObjectivesYou)
    sb(secondary)
    sb("\n\n")
    if #bandits < 2 then
        sb(Traitormod.Language.SoloBandit)
    else
        sb(Traitormod.Language.BanditNoticePartners)
        sb("\n")
        sb(Traitormod.Language.Partners, partners)
    end

    return sb:concat()
end

function role:OtherGreet()
    local sb = Traitormod.StringBuilder:new()
    local primary, secondary = self:ObjectivesToString()
    sb(Traitormod.Language.BanditOther, self.Character.Name)
    sb("\n%s\n", Traitormod.Language.MainObjectivesOther)
    sb(primary)
    sb("\n%s\n", Traitormod.Language.SecondaryObjectivesOther)
    sb(secondary)
    return sb:concat()
end

function role:FilterTarget(objective, character)
    if not self.SelectBotsAsTargets and character.IsBot then return false end

    if objective.Name == "Assassinate" and self.SelectUniqueTargets then
        for key, value in pairs(Traitormod.RoleManager.FindCharactersByRole("CaveDwellerBandit")) do
            local targetRole = Traitormod.RoleManager.GetRole(value)

            for key, obj in pairs(targetRole.Objectives) do
                if obj.Name == "Assassinate" and obj.Target == character then
                    return false
                end
            end
        end
    end

    if character.TeamID ~= CharacterTeamType.Team1 and not self.SelectPiratesAsTargets then
        return false
    end

    return Traitormod.RoleManager.Roles.Antagonist.FilterTarget(self, objective, character)
end

return role

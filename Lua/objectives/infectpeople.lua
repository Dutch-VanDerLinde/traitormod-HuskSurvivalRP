local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "InfectPeopleHusk"
objective.AmountPoints = 250

function objective:Start()
    return true
end

function objective:CharacterAttacked(character, attacker, attackresult)
    if -- invalid attack data, don't do anything
        character == nil or
        character.IsDead or
        attacker == nil or
        attacker.IsDead or
        attackresult == nil or
        attackresult.Afflictions == nil or
        #attackresult.Afflictions <= 0
    then return end

    local afflictions = attackResult.Afflictions

    local identifier = ""
    for value in afflictions do
        -- execute fitting method, if available
        identifier = value.Prefab.Identifier.Value
        if identifier == "huskinfection" and attacker == self.Character then
            local client = Traitormod.FindClientCharacter(self.Character)
            if client then
                local points = Traitormod.AwardPoints(client, self.AmountPoints)
                Traitormod.SendObjectiveCompleted(client, "You have infected "..character.Name..".", points)
                break
            end
        end
    end
end

function objective:IsCompleted()
    return false
end

return objective
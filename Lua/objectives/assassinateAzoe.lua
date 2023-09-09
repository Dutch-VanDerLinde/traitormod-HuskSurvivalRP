local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "AssassinateAzoe"
objective.AmountPoints = 600
function objective:Start(target)
    self.Target = target

    if self.Target == nil then return false end

    self.Text = string.format(Traitormod.Language.ObjectiveAssassinateAzoe, self.Target.Name)

    return true
end

function objective:IsCompleted()
    return self.Target.IsDead
end

function objective:TargetPreference(character)
    if character.HasJob("guardtci")
        or character.HasJob("thal_scientist")
        or character.HasJob("researchdirector")
        or character.HasJob("cavedweller")
    then
        return false
    end

    return true
end

return objective
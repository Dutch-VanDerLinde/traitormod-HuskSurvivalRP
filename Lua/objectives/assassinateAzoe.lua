local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "AssassinateAzoe"
objective.AmountPoints = 925
objective.RoleFilter = {
    ["citizen"] = true,
    ["medicaldoctor"] = true,
    ["he-chef"] = true,
    ["guardone"] = true,
}

function objective:Start(target)
    self.Target = target

    if self.Target == nil then return false end

    self.Text = string.format(Traitormod.Language.ObjectiveAssassinateAzoe, self.Target.Name)

    return true
end

function objective:IsCompleted()
    return self.Target.IsDead
end

return objective
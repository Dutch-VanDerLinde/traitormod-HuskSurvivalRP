local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "TurnHusk"
objective.AmountPoints = 500
objective.AlwaysActive = true

function objective:Start()
    self.Text = Traitormod.Language.ObjectiveTurnHusk

    return true
end

function objective:IsCompleted()
    if self.Character.IsHusk then
        return true
    end

    return false
end

return objective

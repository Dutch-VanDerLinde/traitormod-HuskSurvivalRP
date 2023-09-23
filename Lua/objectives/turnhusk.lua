local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "TurnHusk"
objective.AmountPoints = 500
objective.AlwaysActive = true

function objective:Start()
    self.Text = Traitormod.Language.ObjectiveTurnHusk

    self.OldCharacter = self.Character

    return true
end

function objective:IsCompleted()
    if self.OldCharacter == nil then
        return true
    end

    return false
end

return objective

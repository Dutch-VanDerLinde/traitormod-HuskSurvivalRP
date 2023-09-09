local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "HeistAzoeCodes"
objective.AmountPoints = 1400
objective.RoleFilter = {["researchdirector"] = true}

function objective:Start(target)
    -- if no valid rd found, abort
    if not target then
        return false
    end

    self.Text = Traitormod.Language.ObjectiveStealAzoeCodes
    self.Target = target

    return true
end

function objective:IsCompleted()
    if self.Target.IsDead then return false end

    for item in self.Target.Inventory.AllItems do
        if item.Prefab.Identifier == "adminpaper" then
            return true
        end
    end

    return false
end

return objective
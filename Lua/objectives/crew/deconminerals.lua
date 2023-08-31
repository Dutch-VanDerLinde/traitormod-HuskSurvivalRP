local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "DeconstructMinerals"
objective.AmountPoints = 700

function objective:Start(target)
    self.AmountDeconstructed = 0

    self.HookName = "MineralDeconstructed"..self.Character.Name..tostring(math.random(1, 50))

    Hook.Add("item.deconstructed", self.HookName, function(item, otherItem, userCharacter)
        if self.AmountDeconstructed == nil then
            Hook.Remove("item.deconstructed", self.HookName)
        end

        if item.HasTag("ore") and userCharacter == self.Character then
            self.AmountDeconstructed = self.AmountDeconstructed + 1
        end
    end)

    self.Amount = math.random(6, 8)
    self.Text = string.format(Traitormod.Language.ObjectiveDestroyMinerals, self.Amount)

    return true
end

function objective:IsCompleted()
    if self.AmountDeconstructed >= self.Amount then
        Hook.Remove("item.deconstructed", self.HookName)
        return true
    end

    return false
end

return objective
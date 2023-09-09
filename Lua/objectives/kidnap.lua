local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Kidnap"
objective.AmountPoints = 4500
objective.InstitutePosition = Traitormod.GetRandomJobWaypoint("DeliverySpawnTci").WorldPosition

function objective:Start(target)
    self.Target = target

    if self.Target == nil then
        return false
    end

    self.TargetName = Traitormod.GetJobString(target) .. " " .. target.Name
    self.Text = string.format(Traitormod.Language.ObjectiveKidnap, self.TargetName)


    return true
end

function objective:IsCompleted()
    local char = self.Target

    if char == nil or char.IsDead then return false end

    local item = char.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)

    if item ~= nil and item.Prefab.Identifier == "handcuffs" then
        local distance = Vector2.Distance(char.WorldPosition, self.InstitutePosition)

        if distance < 6000 then
            return true
        end
    end

    return false
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

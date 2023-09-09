local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Kidnap"
objective.AmountPoints = 2500
objective.InstitutePosition = Traitormod.GetRandomJobWaypoint("DeliverySpawnTci").WorldPosition
objective.RoleFilter = {
    ["citizen"] = true,
    ["medicaldoctor"] = true,
    ["he-chef"] = true,
    ["guardone"] = true,
}

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

        if distance < 5000 then
            return true
        end
    end

    return false
end

return objective

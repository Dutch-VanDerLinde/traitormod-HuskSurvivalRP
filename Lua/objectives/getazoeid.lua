local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "StealAzoeIDCard"
objective.AmountPoints = 600
objective.Seconds = 65
objective.RoleFilter = {
    ["citizen"] = true,
    ["medicaldoctor"] = true,
    ["he-chef"] = true,
    ["guardone"] = true,
}

function objective:GetTargetName()
    if self.IdCard.OwnerName == "" then
        return self.Target.Name
    end

    return self.IdCard.OwnerName
end

function objective:Start(target)
    if not target then
        return false
    end

    local idCardItem = target.Inventory.GetItemInLimbSlot(InvSlotType.Card)
    if not idCardItem then
        return false
    end

    self.Target = target
    self.SecondsLeft = self.Seconds
    self.IdCard = idCardItem.GetComponentString("IdCard")
    self.Text = string.format(Traitormod.Language.ObjectiveStealID, self:GetTargetName(), math.floor(self.SecondsLeft))

    return true
end

function objective:IsCompleted()
    if self.SecondsLeft <= 0 then
        self.Text = string.format(Traitormod.Language.ObjectiveStealID, self:GetTargetName(), math.floor(self.SecondsLeft))

        return true
    end

    local stolenCard = false

    for item in self.Character.Inventory.AllItems do
        if item == self.IdCard.Item then
            stolenCard = true
            break
        end
    end

    if stolenCard then
        if self.lastTimer == nil then
            self.lastTimer = Timer.GetTime()
        end

        self.SecondsLeft = math.max(0, self.SecondsLeft - (Timer.GetTime() - self.lastTimer))
        self.Text = string.format(Traitormod.Language.ObjectiveStealID, self:GetTargetName(), math.floor(self.SecondsLeft))
    end

    self.lastTimer = Timer.GetTime()

    return false
end

function objective:TargetPreference(character)
    local idCardItem = character.Inventory.GetItemInLimbSlot(InvSlotType.Card)
    if not idCardItem then
        return false
    end

    return true
end

return objective
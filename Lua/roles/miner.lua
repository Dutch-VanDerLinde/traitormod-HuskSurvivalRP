local role = Traitormod.RoleManager.Roles.Role:new()
role.Name = "Miner"
role.Antagonist = false
role.RoleClothes = {"orangejumpsuit1", "minerclothes"}
role.RoleGear = {"plasmacutter","oxygentank","oxygentank","advanceddivingmask"}

function role:Start()
    local availableObjectives = self.AvailableObjectives

    if not availableObjectives or #availableObjectives == 0 then
        return
    end

    local pool = {}
    for key, value in pairs(availableObjectives) do pool[key] = value end

    for i = 1, 3, 1 do
        local objective = Traitormod.RoleManager.RandomObjective(pool)
        if objective == nil then break end

        objective = objective:new()

        local character = self.Character
        objective:Init(character)
        local target = self:FindValidTarget(objective)

        if objective:Start(target) then
            self:AssignObjective(objective)
            for key, value in pairs(pool) do
                if value == objective.Name then
                    table.remove(pool, key)
                end
            end
        end
    end

    local finishObjectives = Traitormod.RoleManager.FindObjective("FinishAllObjectives"):new()
    finishObjectives:Init(self.Character)
    self:AssignObjective(finishObjectives)


    local text = self:Greet()
    local client = Traitormod.FindClientCharacter(self.Character)
    if client then
        Traitormod.SendChatMessage(client, text, Color(218, 179, 112, 255))
    end

    self.Character.Info.SetSkillLevel("mechanical", math.random(40, 50))
    self.Character.Info.SetSkillLevel("weapons", math.random(20, 35))
    -- Delete Original clothes
    local originalclothes = self.Character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
    Entity.Spawner.AddEntityToRemoveQueue(originalclothes)
    -- Clothes spawn
    local selectedClothes = ItemPrefab.GetItemPrefab(self.RoleClothes[math.random(1, #self.RoleClothes)])
    Entity.Spawner.AddItemToSpawnQueue(selectedClothes, self.Character.Inventory, nil, nil, function(spawned)
        local slot = self.Character.Inventory.FindLimbSlot(InvSlotType.InnerClothes)
        self.Character.Inventory.TryPutItem(spawned, slot, true, false, self.Character)
    end)
    --Toolbelt spawn
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("toolbelt"), self.Character.Inventory, nil, nil, function(spawned)
        local slot = self.Character.Inventory.FindLimbSlot(InvSlotType.Bag)
        self.Character.Inventory.TryPutItem(spawned, slot, true, false, self.Character)
    end)
    -- Gear spawn
    for key, item in pairs(self.RoleGear) do
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(item), self.Character.Inventory)
    end

    --Give id card tags
    local ogidcard = self.Character.Inventory.FindItemByIdentifier("idcard", true)
    Entity.Spawner.AddEntityToRemoveQueue(ogidcard)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("idcard"), self.Character.Inventory, nil, nil, function (id)
        id.AddTag("name:"..self.Character.Name)
        id.AddTag("job:citizen")
        id.AddTag("miner")
        id.AddTag("azoe")
        id.Description = "They are an Azoe Linea miner."
        local IdCardComponent = id.GetComponentString("IdCard")
        IdCardComponent.OwnerJobId = "citizen"
        IdCardComponent.OwnerName = self.Character.Name
        id.CreateServerEvent(IdCardComponent, IdCardComponent)
        -- Place in IdCard slot
        local slot = self.Character.Inventory.FindLimbSlot(InvSlotType.Card)
        self.Character.Inventory.TryPutItem(id, slot, true, false, self.Character)
    end)
end


function role:End(roundEnd)

end

---@return string objectives
function role:ObjectivesToString()
    local objs = Traitormod.StringBuilder:new()

    for _, objective in pairs(self.Objectives) do
        if objective:IsCompleted() then
            objs:append(" > ", objective.Text, Traitormod.Language.Completed)
        else
            objs:append(" > ", objective.Text, string.format(Traitormod.Language.Points, objective.AmountPoints))
        end
    end

    return objs:concat("\n")
end

function role:Greet()
    local objectives = self:ObjectivesToString()

    local sb = Traitormod.StringBuilder:new()
    sb(Traitormod.Language.AzoeMiner)
    sb(objectives)

    return sb:concat()
end

function role:OtherGreet()
    return nil -- No other greet.
end


return role

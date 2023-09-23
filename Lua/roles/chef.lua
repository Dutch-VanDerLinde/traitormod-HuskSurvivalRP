local role = Traitormod.RoleManager.Roles.Role:new()
role.Name = "Chef"
role.Antagonist = false
role.RoleClothes = {"he-chefsuniform1", "he-chefsuniform2"}
role.RoleGear = {"he-cleaver","he-water"}

function role:Start()
    local text = self:Greet()
    local client = Traitormod.FindClientCharacter(self.Character)
    if client then
        Traitormod.SendChatMessage(client, text, Color(230, 115, 0, 255))
    end

    self.Character.Info.SetSkillLevel("butchery", math.random(15, 20))
    self.Character.Info.SetSkillLevel("cooking", math.random(15, 30))
    -- Delete Original clothes
    local originalclothes = self.Character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
    Entity.Spawner.AddEntityToRemoveQueue(originalclothes)
    -- Clothes spawn
    local selectedClothes = ItemPrefab.GetItemPrefab(self.RoleClothes[math.random(1, #self.RoleClothes)])
    Entity.Spawner.AddItemToSpawnQueue(selectedClothes, self.Character.Inventory, nil, nil, function(spawned)
        local slot = self.Character.Inventory.FindLimbSlot(InvSlotType.InnerClothes)
        self.Character.Inventory.TryPutItem(spawned, slot, true, false, self.Character)
    end)
    --Hat spawn
    local hatprefab = "he-chefscap1"
    if selectedClothes == "he-chefsuniform2" then hatprefab = "he-chefscap2" end
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(hatprefab), self.Character.Inventory, nil, nil, function(spawned)
        local slot = self.Character.Inventory.FindLimbSlot(InvSlotType.Head)
        self.Character.Inventory.TryPutItem(spawned, slot, true, false, self.Character)
    end)

    --Give id card tags
    local ogidcard = self.Character.Inventory.FindItemByIdentifier("azoe_idcard", true)
    Entity.Spawner.AddEntityToRemoveQueue(ogidcard)
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("azoe_idcard"), self.Character.Inventory, nil, nil, function (id)
        id.AddTag("name:"..self.Character.Name)
        id.AddTag("job:chef")
        id.AddTag("azoe_chef")
        id.AddTag("azoe")
        id.Description = "Kitchen access."
        local IdCardComponent = id.GetComponentString("IdCard")
        IdCardComponent.OwnerJobId = "citizen"
        IdCardComponent.OwnerName = self.Character.Name
        id.CreateServerEvent(IdCardComponent, IdCardComponent)
        -- Place in IdCard slot
        local slot = self.Character.Inventory.FindLimbSlot(InvSlotType.Card)
        self.Character.Inventory.TryPutItem(id, slot, true, false, self.Character)
    end)

    Timer.Wait(function ()
        -- Gear Spawn
        for key, item in pairs(self.RoleGear) do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(item), self.Character.Inventory)
         end
    end, 450)

    local tppos = Traitormod.GetRandomJobWaypoint("he-chef").WorldPosition
    self.Character.TeleportTo(tppos)
end


function role:End(roundEnd)

end

function role:Greet()
    local sb = Traitormod.StringBuilder:new()
    sb(Traitormod.Language.AzoeChef)

    return sb:concat()
end

function role:OtherGreet()
    return nil -- No other greet.
end


return role

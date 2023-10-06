local role = Traitormod.RoleManager.Roles.Antagonist:new()
role.Name = "Cultist"
role.RoleGear = {
    "syringegun",
    "huskstinger",
    "huskeggsbasic",
    "huskeggsbasic",
    "huskeggs",
    "huskeggs",
    "unstablehuskeggs",
    "handcuffs",
    "husk_campfire",
}

function role:Start()
    Traitormod.Stats.AddCharacterStat("Cultist", self.Character, 1)

    self.Character.AddAbilityFlag(AbilityFlags.IgnoredByEnemyAI) -- husks ignore the cultists

    -- Delete All Items
    for item in self.Character.Inventory.AllItemsMod do
        Entity.Spawner.AddEntityToRemoveQueue(item)
    end
    -- Mask spawn
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("husk_oxygenmask"), self.Character.Inventory, nil, nil, function(spawned)
        local slot = self.Character.Inventory.FindLimbSlot(InvSlotType.HealthInterface)
        self.Character.Inventory.TryPutItem(spawned, slot, true, false, self.Character)
        Timer.Wait(function ()
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygentank"), spawned.OwnInventory, nil, nil)
        end, 150)
    end)
    -- Clothes spawn
    local selectedClothes = ItemPrefab.GetItemPrefab("huskrobes")
    Entity.Spawner.AddItemToSpawnQueue(selectedClothes, self.Character.Inventory, nil, nil, function(spawned)
        local slot = self.Character.Inventory.FindLimbSlot(InvSlotType.InnerClothes)
        self.Character.Inventory.TryPutItem(spawned, slot, true, false, self.Character)
    end)
    --Toolbelt spawn
    Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("toolbelt"), self.Character.Inventory, nil, nil, function(spawned)
        local slot = self.Character.Inventory.FindLimbSlot(InvSlotType.Bag)
        self.Character.Inventory.TryPutItem(spawned, slot, true, false, self.Character)
        Timer.Wait(function ()
            for i = 1, math.random(1, 4) do
                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("oxygentank"), spawned.OwnInventory, nil, nil)
            end
        end, 100)
    end)
    -- Gear Spawn
    Timer.Wait(function ()
        for key, item in pairs(self.RoleGear) do
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(item), self.Character.Inventory, nil, nil, function(spawned)
                if spawned.Prefab.Identifier == "huskstinger" then
                    spawned.AddTag("cultist_stinger")
                end
            end)
         end
    end, 100)

    local pool = {}
    for key, value in pairs(self.AvailableObjectives) do pool[key] = value end

    local toRemove = {}
    for key, value in pairs(pool) do
        local objective = Traitormod.RoleManager.FindObjective(value)
        if objective ~= nil and objective.AlwaysActive then
            objective = objective:new()

            local character = self.Character

            objective:Init(character)
            objective.OnAwarded = function ()
                Traitormod.Stats.AddCharacterStat("TraitorSubObjectives", character, 1)
            end

            if objective:Start(character) then
                self:AssignObjective(objective)
                table.insert(toRemove, key)
            end
        end
    end
    for key, value in pairs(toRemove) do table.remove(pool, value) end

    for i = 1, math.random(self.MinSubObjectives, self.MaxSubObjectives), 1 do
        local objective = Traitormod.RoleManager.RandomObjective(pool)
        if objective == nil then break end

        objective = objective:new()

        local character = self.Character

        objective:Init(character)
        local target = self:FindValidTarget(objective)

        objective.OnAwarded = function ()
            Traitormod.Stats.AddCharacterStat("TraitorSubObjectives", character, 1)
        end

        if objective:Start(target) then
            self:AssignObjective(objective)
            for key, value in pairs(pool) do
                if value == objective.Name then
                    table.remove(pool, key)
                end
            end
        end
    end

    local text = self:Greet()
    local client = Traitormod.FindClientCharacter(self.Character)
    if client then
        Traitormod.SendTraitorMessageBox(client, text, "oneofus")
        Traitormod.UpdateVanillaTraitor(client, true, text, "oneofus")
    end
end


function role:End(roundEnd)
    local client = Traitormod.FindClientCharacter(self.Character)
    if not roundEnd and client then
        --Traitormod.SendMessage(client, Traitormod.Language.TraitorDeath, "InfoFrameTabButton.Traitor")
        Traitormod.UpdateVanillaTraitor(client, false)
    end
end

---@return string mainPart, string subPart
function role:ObjectivesToString()
    local primary = Traitormod.StringBuilder:new()
    local secondary = Traitormod.StringBuilder:new()

    for _, objective in pairs(self.Objectives) do
        if objective:IsCompleted() or objective.Awarded then
            secondary:append(" > ", objective.Text, Traitormod.Language.Completed)
        else
            secondary:append(" > ", objective.Text, string.format(Traitormod.Language.Points, objective.AmountPoints))
        end
    end

    primary(" > "..Traitormod.Language.ObjectiveGiveHusk)

    return primary:concat("\n"), secondary:concat("\n")
end

function role:Greet()
    local primary, secondary = self:ObjectivesToString()

    local sb = Traitormod.StringBuilder:new()
    sb("%s\n\n", Traitormod.Language.CultistYou)
    sb("%s\n", Traitormod.Language.MainObjectivesYou)
    sb(primary)
    sb("\n\n%s\n", Traitormod.Language.SecondaryObjectivesYou)
    sb(secondary)
    sb("\n\n")
    sb(Traitormod.Language.CultistTip)

    return sb:concat()
end

function role:OtherGreet()
    local sb = Traitormod.StringBuilder:new()
    local primary, secondary = self:ObjectivesToString()
    sb(Traitormod.Language.CultistOther, self.Character.Name)
    sb("\n%s\n", Traitormod.Language.MainObjectivesOther)
    sb(primary)
    sb("\n%s\n", Traitormod.Language.SecondaryObjectivesOther)
    sb(secondary)
    return sb:concat()
end

Hook.Add("husk.clientControlHusk", "Traitormod.Cultist.HuskControl", function (client, husk)
    local cultist
    for _, character in pairs(Traitormod.RoleManager.FindCharactersByRole("Cultist")) do
        if character.Name == Traitormod.GetRPName(client) then
            cultist = Traitormod.RoleManager.GetRole(character)
            break
        else
            local cultistClient = Traitormod.FindClientCharacter(character)
            if cultistClient then
                local points = Traitormod.AwardPoints(cultistClient, 100)
                Traitormod.SendObjectiveCompleted(cultistClient, husk.Name.." has joined the hive.", points)
            end
        end
    end

    if cultist then
        Traitormod.RoleManager.TransferRole(client.Character, cultist)
    else
        Traitormod.RoleManager.AssignRole(client.Character, Traitormod.RoleManager.Roles["Husk"]:new())
    end
end)

LuaUserData.MakeMethodAccessible(Descriptors["Barotrauma.StatusEffect"], "set_Afflictions")
LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Affliction"], "_strength")

Hook.Add("meleeWeapon.handleImpact",  "Cultist.Stinger", function (melee, target)
    if melee.Item.Prefab.Identifier ~= "huskstinger" or not melee.Item.HasTag("cultist_stinger") then return end
    if not LuaUserData.IsTargetType(target.UserData, "Barotrauma.Limb") then return end
    local character = target.UserData.character

    do
        local affliction = AfflictionPrefab.Prefabs["huskinfection"].Instantiate(2)
        character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, affliction)
    end

    do -- speed up affliction, since its capped at 50% by default
        local affliction = character.CharacterHealth.GetAffliction("huskinfection", true)
        if affliction then
            affliction._strength = affliction._strength + 2
        end
    end
end)

return role

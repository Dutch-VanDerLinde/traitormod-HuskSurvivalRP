local extension = {}

extension.Identifier = "construction"
extension.FailedCraftMessage = "You don't have enough materials to craft %s!"
extension.SuccessCraftMessage = "Succesfully crafted %s."

extension.Init = function ()
    Networking.Receive("HuskConstructionMenu_RequestSpawn", function(msg, sender)
        local itemID = msg.ReadString()
        local prefab = ItemPrefab.GetItemPrefab(itemID)
        local itemEntry = Husk.ConstructionMenuList[itemID]

        local clonedTable = {}
        for item in itemEntry do
            table.insert(clonedTable, item) -- clone the table because table.remove
        end

        if not sender.Character
            or sender.Character.IsDead
            or sender.Character.IsHusk
            or not sender.Character.IsHumanoid
            or sender.Character.SpeciesName.ToString() ~= ("Human" or "Cyborg")
        then
            return
        end

        local character = sender.Character
        local MaxRequiredItems = #itemEntry
        local RequiredItemsPicked = 0
        local ItemsToRemove = {}

        local itemsTable = {}
        for item in character.Inventory.AllItems do
            for key, value in pairs(clonedTable) do
                if value == item.Prefab.Identifier.ToString() then
                    table.insert(itemsTable, item)
                end
            end
        end

        for item in itemsTable do
            for key, value in ipairs(clonedTable) do
                if item.Prefab.Identifier.ToString() == value and RequiredItemsPicked < MaxRequiredItems then
                    RequiredItemsPicked = RequiredItemsPicked + 1
                    table.remove(clonedTable, key)
                    table.insert(ItemsToRemove, item)
                end
            end
        end

        if RequiredItemsPicked >= MaxRequiredItems then
            for item in ItemsToRemove do
                if item.OwnInventory then
                    for containeditem in item.OwnInventory.AllItemsMod do
                        containeditem.Drop()
                    end
                end
                Entity.Spawner.AddEntityToRemoveQueue(item)
            end
            Timer.Wait(function ()
                Entity.Spawner.AddItemToSpawnQueue(prefab, character.Inventory, nil, nil, nil)
                Game.Log(tostring(prefab).." has been crafted by "..sender.Name, ServerLogMessageType.Spawning)
            end, 2000)
        else
            Husk.SendHuskAlertMessage(string.format(extension.FailedCraftMessage, prefab.Name.ToString()), Color.Red, sender)
            Game.Log(sender.Name.." has attempted to craft "..tostring(prefab)..", but failed.", ServerLogMessageType.Spawning)
        end
    end)
end

return extension
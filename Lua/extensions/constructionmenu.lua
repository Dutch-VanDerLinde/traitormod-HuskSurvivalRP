local extension = {}

extension.Identifier = "construction"
extension.FailedCraftMessage = "You don't have enough materials to craft %s!"
extension.SuccessCraftMessage = "Succesfully crafted %s."

extension.Init = function ()
    Networking.Receive("HuskConstructionMenu_RequestSpawn", function(msg, sender)
        local itemID = msg.ReadString()
        local prefab = ItemPrefab.GetItemPrefab(itemID)
        local itemEntry = Husk.ConstructionMenuList[itemID]
        local itemEntryRecipe = itemEntry.Recipe

        if not sender.Character
            or sender.Character.IsDead
            or sender.Character.IsHusk
            or not sender.Character.IsHumanoid
            or sender.Character.SpeciesName.ToString() ~= ("Human" or "Cyborg")
        then
            return
        end

        local character = sender.Character
        local ItemsToRemove = {}
        local itemsTable = {}

        for value, amount in pairs(itemEntryRecipe) do
            itemsTable[value] = 0
        end

        for item in character.Inventory.AllItems do
            for value, amount in pairs(itemEntryRecipe) do
                if value == item.Prefab.Identifier.ToString() then
                    if itemsTable[value] < amount and item.Condition == 100 then
                        itemsTable[value] = itemsTable[value] + 1
                        table.insert(ItemsToRemove, item)
                    end
                end
            end
        end

        local MaxRequiredItems = 0
        local RequiredItemsFound = 0
        for v in itemEntryRecipe do MaxRequiredItems = MaxRequiredItems + 1 end -- get the correct length of items

        for item, item_amount in pairs(itemEntryRecipe) do
            for value, amount in pairs(itemsTable) do
                if item == value and item_amount == amount then
                    RequiredItemsFound = RequiredItemsFound + 1
                end
            end
        end

        if RequiredItemsFound >= MaxRequiredItems then
            for item in ItemsToRemove do
                if item.OwnInventory then
                    for containeditem in item.OwnInventory.AllItemsMod do
                        containeditem.Drop()
                    end
                end
                Entity.Spawner.AddEntityToRemoveQueue(item)
            end
            Timer.Wait(function ()
                for i = 1, itemEntry.Amount do
                    Entity.Spawner.AddItemToSpawnQueue(prefab, character.Inventory, nil, nil, nil)
                end
                Game.Log(tostring(prefab).." has been crafted by "..sender.Name, ServerLogMessageType.Spawning)
            end, (itemEntry.CraftingTime or 0.05) * 1000)
        else
            Husk.SendHuskAlertMessage(string.format(extension.FailedCraftMessage, prefab.Name.ToString()), Color.Red, sender)
            Game.Log(sender.Name.." has attempted to craft "..tostring(prefab)..", but failed.", ServerLogMessageType.Spawning)
        end
    end)
end

return extension
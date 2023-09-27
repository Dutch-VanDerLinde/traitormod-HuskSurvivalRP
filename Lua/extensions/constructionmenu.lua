local extension = {}

extension.Identifier = "construction"

extension.Init = function ()
    Networking.Receive("HuskConstructionMenu_RequestSpawn", function(msg, sender)
        local itemID = msg.ReadString()
        local prefab = ItemPrefab.GetItemPrefab(itemID)
        local itemEntry = Husk.ConstructionMenuList[itemID]

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

        for requireditem in itemEntry do
            for item in character.Inventory.AllItemsMod do
                if item.Prefab.Identifier == requireditem then
                    RequiredItemsPicked = RequiredItemsPicked + 1
                    table.insert(ItemsToRemove, item)
                end
            end
        end

        if RequiredItemsPicked >= MaxRequiredItems then
            for item in ItemsToRemove do
                Entity.Spawner.AddEntityToRemoveQueue(item)
            end
            Timer.Wait(function ()
                Entity.Spawner.AddItemToSpawnQueue(prefab, character.Inventory, nil, nil, nil)
                Game.Log(tostring(prefab).." has been crafted by "..sender.Name, ServerLogMessageType.Spawning)
            end, 2000)
        else
            local chatmessage = ChatMessage.Create("", "I don't have enough materials to make this..", ChatMessageType.Default, character, sender)
            Game.SendDirectChatMessage(chatmessage, sender)
            Game.Log(sender.Name.." has attempted to craft "..tostring(prefab)..", but failed.", ServerLogMessageType.Spawning)
        end
    end)
end

return extension
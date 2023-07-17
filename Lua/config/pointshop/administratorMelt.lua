local category = {}

category.Identifier = "administrator"
category.CanAccess = function(client)
    if client.Character and not client.Character.IsDead and client.Character.IsHuman and client.Character.HasJob("admintwo") then
        return true
    else
        return false
    end
end

local team = "Placeholder"
local function SpawnCrate(client, items, color, description)
    local messageChat = ChatMessage.Create("", Traitormod.Language.DeliverySuccess, ChatMessageType.Default, nil, nil)
    local messageBox = ChatMessage.Create("", Traitormod.Language.DeliverySuccess, ChatMessageType.ServerMessageBoxInGame, nil, nil)
    messageChat.Color = Color(66, 135, 235)
    messageBox.Color = Color(66, 135, 235)
    Game.SendDirectChatMessage(messageChat, client)
    Game.SendDirectChatMessage(messageBox, client)

    Timer.Wait(function ()
        Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab("securemetalcrate"), client.Character.Inventory, nil, nil, function (item)
            item.Description = description
            item.set_InventoryIconColor(color)
            item.SpriteColor = Color(color)

            local colorsprite = item.SerializableProperties[Identifier("SpriteColor")]
            Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(colorsprite, item))
            local invColor = item.SerializableProperties[Identifier("InventoryIconColor")]
            Networking.CreateEntityEvent(item, Item.ChangePropertyEventData(invColor, item))

            for crateitem in items do
                Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(crateitem), item.OwnInventory)
            end
        end)

        messageChat = ChatMessage.Create("", Traitormod.Language.DeliveryArrival, ChatMessageType.Default, nil, nil)
        Game.SendDirectChatMessage(messageChat, client)
    end, math.random(2, 4)*60000) -- convert minutes to milliseconds
end

Timer.Wait(function () 
    team = Traitormod.Language.ToMeltwater
end, 5000)

category.Products = {
    {
        Identifier = "Medical Delivery",
        Price = 2000,
        Limit = 2,
        PricePerLimit = 1000,
        Action = function (client, product, paidPrice)
            local description = string.format(Traitormod.Language.MedicalDeliveryCrate, team)
            local color = Color(250, 80, 65)
            local items = {
                "antidama1",
                "antidama1",
                "antidama1",
                "antidama1",
                "antidama1",
                "antidama1",
                "antidama1",
                "antidama1",
                "antidama1",
                "antidama1",
                "antidama1",
            }

            SpawnCrate(client, items, color, description)
        end
    },
}

return category
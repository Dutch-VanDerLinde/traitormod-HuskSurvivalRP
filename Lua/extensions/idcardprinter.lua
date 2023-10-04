local extension = {}

extension.Identifier = "idcard_printer"

extension.Init = function()
    local function ComponentisPoweredOn(target)
        if target == nil then
            return false
        else
            return target.Item.Condition > 0 and target.IsOn and target.Voltage >= target.MinVoltage
        end
    end

    local function ReplaceIDCard(targetInventory, oldItem, newPrefab, tags, description, name, jobname, jobid)
        Entity.Spawner.AddItemToRemoveQueue(oldItem)
        Timer.Wait(function ()
            Entity.Spawner.AddItemToSpawnQueue(ItemPrefab.GetItemPrefab(newPrefab), targetInventory, nil, nil, function(spawnedidcard)
                spawnedidcard.Tags = tags
                spawnedidcard.Description = description
                spawnedidcard.AddTag("name:" .. name)
                spawnedidcard.AddTag("job:" .. jobname)
                -- Below is to change the IdCardComponent so it displays the targetCharacter's name rather than nothing
                local idcard = spawnedidcard.GetComponentString("IdCard")
                idcard.OwnerName = name
                idcard.OwnerJobId = jobid
                spawnedidcard.CreateServerEvent(idcard, idcard)
            end)
        end, 500)
    end

    Hook.Add("HuskSurvival.PrintIDCard", "HuskSurvival.PrintIDCard", function(effect, deltaTime, item, targets, worldPosition)
        local containedID = item.OwnInventory.GetItemAt(0)
        local idComputerItem

        if not ComponentisPoweredOn(item.GetComponentString("LightComponent")) then return end

        for wire in item.Connections[2].Wires do
            if not wire then break end
            for connection in wire.Connections do
                local connectionItem = connection.item

                if connectionItem ~= item and connectionItem.HasTag("idcomputer") then
                    idComputerItem = connectionItem
                    break
                end -- idcomputer
            end
        end

        if containedID and idComputerItem then
            local computerID = idComputerItem.Prefab.Identifier
            local CustomInterface = idComputerItem.GetComponentString("CustomInterface")
            local CustomInterfaceList = CustomInterface.customInterfaceElementList
            local IDTags = {}
            local tagstring = ""
            local AccessTable = {}
            local AccessString = ""
            local idname
            local idjobname
            local jobid
            local idcardprefab = "idcard"

            if computerID == "husk_idterminalazoe" then
                local secaccess = CustomInterfaceList[1].State
                local mineaccess = CustomInterfaceList[2].State
                local engaccess = CustomInterfaceList[3].State
                local medaccess = CustomInterfaceList[4].State
                local chefaccess = CustomInterfaceList[5].State
                idname = CustomInterfaceList[6].Signal
                jobid = "citizen"
                idjobname = "citizen"
                idcardprefab = "azoe_idcard"

                if chefaccess == true then
                    jobid = "he-chef"
                    idjobname = "chef"
                    table.insert(IDTags, "azoe_chef")
                    table.insert(AccessTable, "kitchen access")
                end
                if mineaccess == true then
                    idjobname = "miner"
                    table.insert(IDTags, "miner")
                    table.insert(AccessTable, "mine access")
                end
                if engaccess == true then
                    idjobname = "technician"
                    table.insert(IDTags, "technician")
                    table.insert(AccessTable, "engineering access")
                end
                if medaccess == true  then
                    jobid = "medicaldoctor"
                    idjobname = "medical doctor"
                    table.insert(IDTags, "azoe_med")
                    table.insert(AccessTable, "medbay access")
                end
                if secaccess == true then
                    jobid = "guardone"
                    idjobname = "security officer"
                    table.insert(IDTags, "azoe_gov")
                    table.insert(AccessTable, "government access")
                end
            elseif computerID == "husk_idterminaltci" then
                local secaccess = CustomInterfaceList[1].State
                local labaccess = CustomInterfaceList[2].State
                idname = CustomInterfaceList[3].Signal
                jobid = "thal_scientist"
                idjobname = "institute member"
                idcardprefab = "tci_idcard"
                table.insert(AccessTable, "laboratory access")
                table.insert(IDTags, "sci")

                if labaccess == true then
                    idjobname = "thal_scientist"
                end
                if secaccess == true then
                    jobid = "guardtci"
                    idjobname = "security officer"
                    table.insert(IDTags, "tci_guard")
                    table.insert(AccessTable, "security access")
                end
            end

            for index, value in ipairs(IDTags) do
                tagstring = tagstring .. value
                if index < #IDTags then tagstring = tagstring .. "," end
            end

            local formatstring = "%s and %s"
            if #AccessTable < 1 then
                local descstring = tostring(ItemPrefab.GetItemPrefab(idcardprefab).Description):lower()
                AccessString = descstring:sub(1, #descstring - 1)
            elseif #AccessTable == 1 then
                AccessString = AccessTable[1]
            elseif #AccessTable == 2 then
                AccessString = string.format(formatstring, AccessTable[1], AccessTable[2])
            else
                local concatted = table.concat(AccessTable, ", ", 1, #AccessTable - 1)
                AccessString = string.format(formatstring, concatted, AccessTable[#AccessTable])
            end

            local upperCasedLetter = AccessString:sub(1, 1):upper()
            AccessString = upperCasedLetter..AccessString:sub(2, #AccessString).."."

            ReplaceIDCard(item.OwnInventory, containedID, idcardprefab, tagstring, AccessString, idname, idjobname, jobid)
        end
    end)
end

return extension
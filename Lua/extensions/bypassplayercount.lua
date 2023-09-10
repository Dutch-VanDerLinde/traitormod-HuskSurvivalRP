local extension = {}

extension.Identifier = "bypassplayercount"
extension.Credits = "Evil Factory" -- he is awesome

extension.Init = function ()
    Hook.Add("lidgren.handleConnection", "ignorePlayerCount", function ()
        return true
    end)

    Hook.Add("handlePendingClient", "handlePendingClient", function (pendingClient)
        local id = pendingClient.AccountInfo.AccountId

        if id == nil then -- Client is still not authenticated, let him thru for now
            return true
        end

        for key, value in pairs(Game.ServerSettings.ClientPermissions) do
            if value.AddressOrAccountId == id then
                if bit32.band(value.Permissions, ClientPermissions.KarmaImmunity) == ClientPermissions.KarmaImmunity then
                    return true
                end
            end
        end
    end)
end

return extension
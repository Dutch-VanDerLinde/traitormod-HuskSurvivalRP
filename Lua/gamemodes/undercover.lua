local gm = Traitormod.Gamemodes.Survival:new()

gm.Name = "Undercovers"

function gm:AssignAntagonists(antagonists)
    local function Assign(roles)
        local newRoles = {}

        for key, value in pairs(antagonists) do
            table.insert(newRoles, roles[key]:new())
        end

        Traitormod.RoleManager.AssignRoles(antagonists, newRoles)
    end

    if self.AntagSelectionMode == "Random" then
        local role = Traitormod.RoleManager.Roles["InstituteUndercover"]

        local roles = {}
        for key, value in pairs(antagonists) do
            table.insert(roles, role)
        end
        Assign(roles)
    end
end

return gm
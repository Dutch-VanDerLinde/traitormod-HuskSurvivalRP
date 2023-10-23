local gm = Traitormod.Gamemodes.Survival:new()

gm.Name = "Bandits"

function gm:AssignAntagonists(antagonists)
    local function Assign(roles)
        local newRoles = {}

        for key, value in pairs(antagonists) do
            table.insert(newRoles, roles[key]:new())
        end

        Traitormod.RoleManager.AssignRoles(antagonists, newRoles)
    end

    local role = Traitormod.RoleManager.Roles["CaveDwellerBandit"]

    local roles = {}
    for key, value in pairs(antagonists) do
        table.insert(roles, role)
    end
    Assign(roles)
    self.AntagsSelected = true
    Traitormod.Log("Antagonists have been assigned: " .. tostring(self.AntagsSelected))
end

return gm
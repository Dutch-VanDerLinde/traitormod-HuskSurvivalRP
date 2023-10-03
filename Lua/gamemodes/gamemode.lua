local gm = {}

gm.Name = "Gamemode"

function gm:PreStart()
    Traitormod.Pointshop.Initialize(self.PointshopCategories or {})
end

function gm:Start()

end

function gm:Think()

end

function gm:End()

end

function gm:TraitorResults()

end

function gm:RoundSummary()
    local sb = Traitormod.StringBuilder:new()

    sb("Gamemode: %s\n", self.Name)

    for character, role in pairs(Traitormod.RoleManager.RoundRoles) do
        local text = role:OtherGreet()
        if text then
            sb("\n%s\n", role:OtherGreet())
        end
    end

    sb("\nThe round lasted for " .. math.floor(Traitormod.RoundTime / 60) .. " minutes.")

    return sb:concat()
end

function gm:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    return o
end

return gm

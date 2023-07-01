if CLIENT then return end

Traitormod = {}
Traitormod.VERSION = "1.0.0"

print(">> Husk Survival v" .. Traitormod.VERSION)
print(">> Made by Television.")

local path = table.pack(...)[1]

Traitormod.Path = path

dofile(Traitormod.Path .. "/Lua/traitormod.lua")
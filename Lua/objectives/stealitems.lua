local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Heist"
objective.AmountPoints = 1000

objective.PossibleItems = {
    admindeviceazoe = {
        text = "Steal the Azoe Region Administrator's PDA.",
        points = 1800,
    },
    husk_wallet = {
        text = "Steal someone's wallet.",
        points = 250,
    },
    expeditionsuit_institute = {
        text = "Steal an Institute expedition suit.",
        points = 1100,
    },
    scientistscannerhud = {
        text = "Steal scientist goggles.",
        points = 850,
    },
    adminpaper = {
        text = "Steal the Azoe Region Administrator's classified codes document.",
        points = 2100,
    },
    institutepaper = {
        text = "Steal the Institute Research Director's classified codes document.",
        points = 2200,
    },
}

function objective:Start(item)
    self.SelectedItem = item
    self.SelectedTable = self.PossibleItems[self.SelectedItem]
    self.Text = self.SelectedTable["text"]
    self.AmountPoints = self.SelectedTable["points"]

    return true
end

function objective:IsCompleted()
    for item in self.Character.Inventory.AllItems do
        if item.Prefab.Identifier == self.SelectedItem then
            return true
        end
    end

    return false
end

return objective
local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "Heist"
objective.AmountPoints = 1000

objective.PossibleItems = {
    admindeviceazoe = {
        text = "Steal the Azoe Region Administrator's PDA.",
        points = 2000,
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
    adminazoenukecodes = {
        text = "Steal the Azoe Region Administrator's nuclear launch code document.",
        points = 2800,
    },
    tci_antagcodewords = {
        text = "Steal the Institute Research Director's undercover agent codeword document.",
        points = 2500,
    },
    admindevicetci = {
        text = "Steal the Institute Research Director's PDA.",
        points = 2000,
    },
    azoe_bodyarmor = {
        text = "Steal the Azoe Region Administrator's advanced body armor.",
        points = 2000,
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
local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "KillAny"
objective.AmountPoints = 450
objective.Text = Traitormod.Language.ObjectiveKillAny

function objective:Start()
    self.Completed = false

    return true
end

function objective:CharacterDeath(character)
    if Traitormod.RoleManager.HasRole(character, "CaveDwellerBandit") then return end
    if character.IsHuman and character.CauseOfDeath and character.CauseOfDeath.Killer == self.Character then
        character.CauseOfDeath.Killer.Info.GiveExperience(500)
        local jobid = tostring(character.JobIdentifier)

        if jobid == "adminone" then
            self.AmountPoints = 1800
        elseif jobid == "researchdirector" then
            self.AmountPoints = 2100
        elseif jobid == "guardtci" or jobid == "guardone" then
            self.AmountPoints = 1100
        end

        self.Completed = true
    end
end

function objective:IsCompleted()
    return self.Completed
end

return objective
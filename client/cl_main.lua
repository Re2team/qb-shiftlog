local QBCore = exports['qb-core']:GetCoreObject() -- We've ALWAYS got to grab our core object

local currentjob = ""

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
	local Player=QBCore.Functions.GetPlayerData()
    local job = Player.job.name
    print(json.encode(Player.job))
    currentjob = job
    if job == "police" or job == "ambulance" or job == "mechanic" then -- job's name here
        TriggerServerEvent("qb-shiftlog:userjoined", job)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    print(json.encode(job))
    if currentjob == "police" or currentjob == "ambulance" or job == "mechanic" then -- job's name here
        if not (currentjob == job.name) then
            TriggerServerEvent("qb-shiftlog:jobchanged", currentjob, job.name, 1)
        end
    else
        if job.name == "police" or job.name == "ambulance" or job == "mechanic" then -- job's name here
            TriggerServerEvent("qb-shiftlog:jobchanged", currentjob, job.name, 0)
        end
    end
    currentjob = job.name
end)


-- RegisterNetEvent('QBCore:ToggleDuty', function()
--     local src = source
--     local Player = QBCore.Functions.GetPlayer(src)
--     if Player.PlayerData.job.onduty then
--         Player.Functions.SetJobDuty(false)
--         TriggerClientEvent('QBCore:Notify', src, 'You are now off duty!')
--     else
--         Player.Functions.SetJobDuty(true)
--         TriggerClientEvent('QBCore:Notify', src, 'You are now on duty!')
--     end
--     TriggerClientEvent('QBCore:Client:SetDuty', src, Player.PlayerData.job.onduty)
-- end)
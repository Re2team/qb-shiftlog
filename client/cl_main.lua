local QBCore = exports['qb-core']:GetCoreObject() -- We've ALWAYS got to grab our core object

local currentjob = {}

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
	local Player=QBCore.Functions.GetPlayerData()
    local job = Player.job
    print(json.encode(Player.job))
    currentjob = job
    if job == "police" or job == "ambulance" or job == "mechanic" then -- job's name here
        TriggerServerEvent("qb-shiftlog:userjoined", job)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    Wait(100)
    
    if job.name == "police" or job.name == "ambulance" or job.name == "mechanic" then -- job's name here
        if job.onduty == false then
            TriggerEvent("qb-shiftlog:jobchanged", job, job, 1, src)
        end
           
    end
    currentjob = job
end)



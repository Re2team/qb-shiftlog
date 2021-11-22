local QBCore = exports['qb-core']:GetCoreObject() -- Grabs our core object

local timers = { -- if you want more job shifts add table entry here same as the examples below
    ambulance = {
        {} -- don't edit inside
    },
    police = {
        {} -- don't edit inside
    },
    -- fbi = {}
}
local dcname = "Shift Logger" -- bot's name
local http = "https://discord.com/api/webhooks/911895867877900329/s4BtsyXHbgH6Lcc98pkqHe1w9F-gMNXiPlsMOaNCaFZ8v782S4gP9uoCz2X4ihK9FnS-" -- webhook for police
local httpAmbulance = "https://discord.com/api/webhooks/911895867877900329/s4BtsyXHbgH6Lcc98pkqHe1w9F-gMNXiPlsMOaNCaFZ8v782S4gP9uoCz2X4ihK9FnS-" -- webhook for ems (you can add as many as you want)
local httpMechanic = "https://discord.com/api/webhooks/911895867877900329/s4BtsyXHbgH6Lcc98pkqHe1w9F-gMNXiPlsMOaNCaFZ8v782S4gP9uoCz2X4ihK9FnS-"
local avatar = "https://discord.com/api/webhooks/911895867877900329/s4BtsyXHbgH6Lcc98pkqHe1w9F-gMNXiPlsMOaNCaFZ8v782S4gP9uoCz2X4ihK9FnS-" -- bot's avatar

function DiscordLog(name, message, color, job)
    local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "qb-shiftlog",
            },
        }
    }
    if job == "police" then
        PerformHttpRequest(http, function(err, text, headers) end, 'POST', json.encode({username = dcname, embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
    elseif job == "ambulance" then
        PerformHttpRequest(httpAmbulance, function(err, text, headers) end, 'POST', json.encode({username = dcname, embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
    elseif job == "mechanic" then
        PerformHttpRequest(httpMechanic, function(err, text, headers) end, 'POST', json.encode({username = dcname, embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
    end
end

RegisterServerEvent("qb-shiftlog:userjoined")
AddEventHandler("qb-shiftlog:userjoined", function(job)
    local id = source
    local xPlayer = QBCore.Functions.GetPlayer(id)

    table.insert(timers[job], {id = id, identifier = xPlayer.identifier, name = xPlayer.name, time = os.time(), date = os.date("%d/%m/%Y %X")})
end)

RegisterServerEvent("qb-shiftlog:jobchanged")
AddEventHandler("qb-shiftlog:jobchanged", function(old, new, method)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local header = nil
    local color = nil

    if old == "police" then
        header = "Police Shift" -- Header
        color = 3447003 -- Color
    elseif old == "ambulance" then
        header = "EMS Shift"
        color = 15158332
    elseif old == "mechanic" then
        header = "Mechanic Shift"
        color = 13400320
    --elseif job == "fbi" then
        --header = "FBI Shift"
        --color = 3447003
    end
    if method == 1 then
        for i = 1, #timers[old], 1 do
            if timers[old][i].identifier == xPlayer.identifier then
                local duration = os.time() - timers[old][i].time
                local date = timers[old][i].date
                local timetext = nil

                if duration > 0 and duration < 60 then
                    timetext = tostring(math.floor(duration)).." seconds"
                elseif duration >= 60 and duration < 3600 then
                    timetext = tostring(math.floor(duration / 60)).." minutes"
                elseif duration >= 3600 then
                    timetext = tostring(math.floor(duration / 3600).." hours, "..tostring(math.floor(math.fmod(duration, 3600)) / 60)).." minutes"
                end
                DiscordLog(header , "Steam Name: **"..timers[old][i].name.."**\nIdentifier: **"..timers[old][i].identifier.."**\n Shift duration: **__"..timetext.."__**\n Start date: **"..date.."**\n End date: **"..os.date("%d/%m/%Y %X").."**", color, old)
                table.remove(timers[old], i)
                break
            end
        end
    end
    if not (timers[new] == nil) then
        for t, l in pairs(timers[new]) do
            if l.id == xPlayer.source then
                table.remove(table[new], l)
            end
        end
    end
    if new == "police" or new == "ambulance" then
        table.insert(timers[new], {id = xPlayer.source, identifier = xPlayer.identifier, name = xPlayer.name, time = os.time(), date = os.date("%d/%m/%Y %X")})
    end
end)

AddEventHandler("playerDropped", function(reason)
    local id = source
    local header = nil
    local color = nil

    for k, v in pairs(timers) do
        for n = 1, #timers[k], 1 do
            if timers[k][n].id == id then
                local duration = os.time() - timers[k][n].time
                local date = timers[k][n].date
                local timetext = nil

                if k == "police" then
                    header = "Police Shift"
                    color = 3447003
                elseif k == "ambulance" then
                    header = "EMS Shift"
                    color = 15158332
                end
                if duration > 0 and duration < 60 then
                    timetext = tostring(math.floor(duration)).." seconds"
                elseif duration >= 60 and duration < 3600 then
                    timetext = tostring(math.floor(duration / 60)).." minutes"
                elseif duration >= 3600 then
                    timetext = tostring(math.floor(duration / 3600).." hours, "..tostring(math.floor(math.fmod(duration, 3600)) / 60)).." minutes"
                end
                DiscordLog(header, "Steam Name: **"..timers[k][n].name.."**\nIdentifier: **"..timers[k][n].identifier.."**\n Shift duration: **__"..timetext.."__**\n Start date: **"..date.."**\n End date: **"..os.date("%d/%m/%Y %X").."**", color, k)
                table.remove(timers[k], n)
                return
            end
        end
    end
end)

DiscordLog("[qb-shiftlog]", "Shift logger started!", 3447003, "police")
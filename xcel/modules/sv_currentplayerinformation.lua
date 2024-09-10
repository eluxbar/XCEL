function XCEL.updateCurrentPlayerInfo()
  local currentPlayersInformation = {}
  local playersJobs = {}
  for k,v in pairs(XCEL.getUsers()) do
    table.insert(playersJobs, {user_id = k, jobs = XCEL.getUserGroups(k)})
  end
  currentPlayersInformation['currentStaff'] = XCEL.getUsersByPermission('admin.tickets')
  currentPlayersInformation['jobs'] = playersJobs
  TriggerClientEvent("XCEL:receiveCurrentPlayerInfo", -1, currentPlayersInformation)
end


AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
  if first_spawn then
    XCEL.updateCurrentPlayerInfo()
  end
end)
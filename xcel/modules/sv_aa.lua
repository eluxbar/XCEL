RegisterServerEvent('XCEL:openAAMenu')
AddEventHandler('XCEL:openAAMenu', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil and XCEL.hasPermission(user_id, "aa.menu")then
      XCELclient.openAAMenu(source,{})
    end
end)

RegisterServerEvent('XCEL:setAAMenu')
AddEventHandler('XCEL:setAAMenu', function(status)
    local source = source
    local user_id = XCEL.getUserId(source)
end)
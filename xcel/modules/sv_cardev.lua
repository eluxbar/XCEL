RegisterServerEvent('XCEL:setCarDevMode')
AddEventHandler('XCEL:setCarDevMode', function(status)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil and XCEL.hasPermission(user_id, "cardev.menu") then 
      if status then
        XCEL.setBucket(source, 333)
      else
        XCEL.setBucket(source, 0)
      end
    else
      XCEL.ACBan(15,user_id,'XCEL:setCarDevMode')
    end
end)
reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(40514 , 0) -----move cursor to mouse cursor  no snapping           
reaper.Main_OnCommand(40289 , 0) --unselect all items   
reaper.Main_OnCommand(40331 , 0) ---unselect all envelopes
reaper.Main_OnCommand(40635 , 0) ----remove time selection



        
        
        _, _, _ = reaper.BR_GetMouseCursorContext()
                    item = reaper.BR_GetMouseCursorContext_Item()
                    if item ~= nil then
        
        
        
          lastitem = reaper.BR_GetMediaItemGUID(item)
        
             
         
   
             
             reaper.DeleteExtState('MyDaw', 'Click On Bottom Half', 0)
             reaper.SetExtState('MyDaw', 'Click On Bottom Half', lastitem, 0)
end
reaper.PreventUIRefresh(-1)

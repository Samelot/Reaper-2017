local function nothing() end; local function noaction() reaper.defer(nothing) end


             
             _, _, _ = reaper.BR_GetMouseCursorContext()
             item = reaper.BR_GetMouseCursorContext_Item()
             if item ~= nil then
             tr = reaper.GetMediaItem_Track(item)
             local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
             local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
             reaper.GetSet_LoopTimeRange2(0, true, 0, itemStart, itemEnd, 0)
            
    
                 
             



 for i = 0, reaper.GetTrackNumMediaItems(tr)-1 do
             
            
             local mitem = reaper.GetTrackMediaItem(tr, i) 
             
             
             
             
            
             
            start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false) -- Get start and end time selection value in seconds
             
            if start_time ~= end_time then -- if there is a time selection
                
               
                    item_pos = reaper.GetMediaItemInfo_Value(mitem, "D_POSITION")
                    item_len = reaper.GetMediaItemInfo_Value(mitem, "D_LENGTH")
             
                    item_end = item_pos + item_len -- Calculate the item end position
             
                    if (item_pos >= start_time and item_pos <= end_time) or (item_end >= start_time and item_end <= end_time) or (item_pos <= start_time and item_end >= end_time) then -- check if item is in time selection
                            
                        reaper.SetMediaItemInfo_Value(mitem, "B_MUTE", 1) -- Set new value
                        reaper.SetMediaItemInfo_Value(item, "B_MUTE", 0)    
                    end -- end if item is in time selection
                    
             
         
            
 reaper.TrackList_AdjustWindows(0)            
 reaper.UpdateArrange()            
 
 
end                              
                 
end  
             
             
end           

 
 _, _, _ = reaper.BR_GetMouseCursorContext()
citem = reaper.BR_GetMouseCursorContext_Item()

if citem ~= nil then
            
CurStart = reaper.GetMediaItemInfo_Value(citem, "D_POSITION") 
 

end 

reaper.Main_OnCommand(40635, 0) ---------remove Time selection      


 



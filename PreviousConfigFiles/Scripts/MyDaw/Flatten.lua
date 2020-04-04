reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40289,0)  ---unselect all items

itemscount = reaper.CountMediaItems(0)
for i = 1, itemscount do
  item = reaper.GetMediaItem(0, i-1)
  is_selected_item = reaper.GetMediaItemInfo_Value(item, "B_UISEL")
  item_track = reaper.GetMediaItem_Track(item)
  IsTrackSelected = reaper.IsTrackSelected(item_track)
  if IsTrackSelected == true then 
    tr = reaper.GetMediaItem_Track(item)
    IsFreeze = reaper.BR_GetMediaTrackFreezeCount(tr)
    
   if IsFreeze > 0 then  reaper.SetMediaItemInfo_Value(item, "B_UISEL", 1) end  
  
end

end
reaper.Main_OnCommand(40689,0)  ---unlock
                  

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Flatten', -1)



reaper.UpdateArrange()

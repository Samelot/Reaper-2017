function deleteEmptyItems() 
   reaper.Main_OnCommand(40296, 0)
   
    
    
    reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'), 0)
    
    
    for t = 0, reaper.CountTracks(0)-1 do
        local track = reaper.GetTrack(0, t)
        local tItems = {}
        for i = 0, reaper.GetTrackNumMediaItems(track)-1 do
            local item = reaper.GetTrackMediaItem(track, i)
            if reaper.ULT_GetMediaItemNote(item) == "AREA SELECT           " then
                tItems[#tItems+1] = item
            end
        end
        for _, item in ipairs(tItems) do
            reaper.DeleteTrackMediaItem(track, item)
        end
    end
end


reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40311, 0) ---Set ripple edit for all tracks
reaper.Main_OnCommand(40296, 0) ---Select all tracks
--reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELFIRSTOFSELTRAX'), 0) ---Select first selected tracks

reaper.Main_OnCommand(40058, 0) -- paste

deleteEmptyItems() 

reaper.Main_OnCommand(40309, 0)---Set ripple edit off

reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Paste Time', -1)

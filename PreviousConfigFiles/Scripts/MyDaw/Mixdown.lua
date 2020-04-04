function mix()

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)


reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVEVIEW'), 0)

reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_SAVE_CURSOR_POS_SLOT_5'), 0)




function select() -- local (i, j, item, take, track)

 

  UnselectAllTracks()

  -- LOOP THROUGH SELECTED ITEMS
  selected_items_count = reaper.CountSelectedMediaItems(0)
  
  -- INITIALIZE loop through selected items
  -- Select tracks with selected items
  for i = 0, selected_items_count - 1  do
    -- GET ITEMS
    item = reaper.GetSelectedMediaItem(0, i) -- Get selected item i

    -- GET ITEM PARENT TRACK AND SELECT IT
    track = reaper.GetMediaItem_Track(item)
    reaper.SetTrackSelected(track, true)
  
 reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVESEL'), 0) 
  
        
  end -- ENDLOOP through selected tracks

 

end


function UnselectAllTracks()
  first_track = reaper.GetTrack(0, 0)
  reaper.SetOnlyTrackSelected(first_track)
  reaper.SetTrackSelected(first_track, false)
end





select() -- Execute your main function


reaper.Main_OnCommand(41559, 0) --solo
reaper.Main_OnCommand(41174, 0) --Item navigation: Move cursor to end of items
reaper.Main_OnCommand(41040, 0)  --Go to start of next measure
reaper.Main_OnCommand(40296, 0)  ---Track: Select all tracks
   



local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

function last_tr_in_folder (folder_tr)
  last = nil
  local dep = r.GetTrackDepth(folder_tr)
  local num = r.GetMediaTrackInfo_Value(folder_tr, 'IP_TRACKNUMBER')
  local tracks = r.CountTracks()
  for i = num+1, tracks do
    if r.GetTrackDepth(r.GetTrack(0,i-1)) <= dep then last = r.GetTrack(0,i-2) break end
  end
  if last == nil then last = r.GetTrack(0, tracks-1) end
  return last
end

sel_tracks = r.CountSelectedTracks()
if sel_tracks == 0 then bla() end

first_sel = r.GetSelectedTrack(0,0)
tr_num = r.GetMediaTrackInfo_Value(first_sel, 'IP_TRACKNUMBER')

last_sel = r.GetSelectedTrack(0,sel_tracks-1)
last_sel_dep = r.GetMediaTrackInfo_Value(last_sel, 'I_FOLDERDEPTH')
if last_sel_dep == 1 then last_tr = last_tr_in_folder(last_sel) else last_tr = last_sel end



r.InsertTrackAtIndex(tr_num-1, 1)
r.TrackList_AdjustWindows(0)
tr = r.GetTrack(0, tr_num-1)

r.SetMediaTrackInfo_Value(tr, 'I_FOLDERDEPTH', 1)
r.SetMediaTrackInfo_Value(last_tr, 'I_FOLDERDEPTH', last_sel_dep-1)
r.SetOnlyTrackSelected(tr)

r.Main_OnCommand(40914,0) -- Track: Set first selected track as last touched track



--r.Main_OnCommand(40913,0) -- Track: Vertical scroll selected tracks into view


reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_AWRENDERSTEREOSMART'), 0) ---SWS/AW: Render tracks to stereo stem tracks, obeying time selection

reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELNEXTTRACK'), 0) ---Xenakios/SWS: Select next tracks
reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_FOLDEROFF'), 0) ----SWS/S&M: Set selected tracks folder states to normal

reaper.Main_OnCommand(40005, 0) --Track: Remove tracks
reaper.Main_OnCommand(40635, 0) ---Time selection: Remove time selection
reaper.Main_OnCommand(41560, 0)   ---Item properties: Unsolo



    tr = reaper.GetTrack(0,reaper.CountTracks(0)-1)
    if tr then reaper.SetOnlyTrackSelected( tr ) end
    
reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_FOLDEROFF'), 0)  ----SWS/S&M: Set selected tracks folder states to normal   

reaper.Main_OnCommand(40296, 0) --Select All 
 
reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELFIRSTOFSELTRAX'), 0)   ---Xenakios/SWS: Select first of selected tracks


reaper.Main_OnCommand(40337, 0) --Track: Cut tracks

--reaper.Main_OnCommand(40296, 0) ---Select All tracks


reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTORESEL'), 0)   -----restore tracks selection


reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELLASTOFSELTRAX'), 0) ---Select last track


reaper.Main_OnCommand(40058, 0) ---Paste track    
 
function rename()



for i = 0, tracks_count - 1 do
    
    track = reaper.GetSelectedTrack(0, i)



if track then
      
        track_name_retval, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "Mixdown", true) 


end
end

end

tracks_count = reaper.CountSelectedTracks(0)

rename()





reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_RESTORE_CURSOR_POS_SLOT_5'), 0) 

 
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTOREVIEW'), 0) 
       
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Mixdown', -1)

end
  

startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"

selected_items_count = reaper.CountSelectedMediaItems(0)

if endOut > 0 and selected_items_count > 0 then 
mix()
end




   
  

    


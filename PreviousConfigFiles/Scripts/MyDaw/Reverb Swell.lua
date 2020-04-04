function swell()

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)


reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVEVIEW'), 0)


reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_SAVE_CURSOR_POS_SLOT_5'), 0)



reaper.Main_OnCommand(41173, 0)--------------------------------------Item navigation: Move cursor to start of items  

itemsstart =  reaper.GetCursorPosition()

startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 )


reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_RESTORE_CURSOR_POS_SLOT_5'), 0) 


function UnselectAllTracks()
  first_track = reaper.GetTrack(0, 0)
  reaper.SetOnlyTrackSelected(first_track)
  reaper.SetTrackSelected(first_track, false)
end





function select() 

 
UnselectAllTracks()
selected_items_count = reaper.CountSelectedMediaItems(0)
  
  for i = 0, selected_items_count - 1  do

    item = reaper.GetSelectedMediaItem(0, i)


    track = reaper.GetMediaItem_Track(item)
    reaper.SetTrackSelected(track, true)
    reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVESEL'), 0)  
        
  end 

end



select() 


reaper.Main_OnCommand(41559, 0) -----------Item properties: Solo
reaper.Main_OnCommand(41174, 0) ------------Item navigation: Move cursor to end of items
reaper.Main_OnCommand(41040, 0) ---------------Go to start of next measure
reaper.Main_OnCommand(40296, 0) --------------Track: Select all tracks
   



local function nothing() end; local function bla() reaper.defer(nothing) end

function last_tr_in_folder (folder_tr)
  last = nil
  local dep = reaper.GetTrackDepth(folder_tr)
  local num = reaper.GetMediaTrackInfo_Value(folder_tr, 'IP_TRACKNUMBER')
  local tracks = reaper.CountTracks()
  for i = num+1, tracks do
    if reaper.GetTrackDepth(reaper.GetTrack(0,i-1)) <= dep then last = reaper.GetTrack(0,i-2) break end
  end
  if last == nil then last = reaper.GetTrack(0, tracks-1) end
  return last
end

sel_tracks = reaper.CountSelectedTracks()
if sel_tracks == 0 then bla() end

first_sel = reaper.GetSelectedTrack(0,0)
tr_num = reaper.GetMediaTrackInfo_Value(first_sel, 'IP_TRACKNUMBER')

last_sel = reaper.GetSelectedTrack(0,sel_tracks-1)
last_sel_dep = reaper.GetMediaTrackInfo_Value(last_sel, 'I_FOLDERDEPTH')
if last_sel_dep == 1 then last_tr = last_tr_in_folder(last_sel) else last_tr = last_sel end



reaper.InsertTrackAtIndex(tr_num-1, 1)
reaper.TrackList_AdjustWindows(0)
tr = reaper.GetTrack(0, tr_num-1)

reaper.SetMediaTrackInfo_Value(tr, 'I_FOLDERDEPTH', 1)
reaper.SetMediaTrackInfo_Value(last_tr, 'I_FOLDERDEPTH', last_sel_dep-1)
reaper.SetOnlyTrackSelected(tr)

reaper.Main_OnCommand(40914,0) -- Track: Set first selected track as last touched track



reaper.Main_OnCommand(40913,0) -- Track: Vertical scroll selected tracks into view


reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_AWRENDERSTEREOSMART'), 0) ---SWS/AW: Render tracks to stereo stem tracks, obeying time selection

reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELNEXTTRACK'), 0) ----Xenakios/SWS: Select next tracks, keeping current selection
reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_FOLDEROFF'), 0) ------------SWS/S&M: Set selected tracks folder states to normal

reaper.Main_OnCommand(40005, 0) ------------------Track: Remove tracks
reaper.Main_OnCommand(40635, 0) ------------Time selection: Remove time selection
reaper.Main_OnCommand(41560, 0) -------------Item properties: Unsolo



    tr = reaper.GetTrack(0,reaper.CountTracks(0)-1)
    if tr then reaper.SetOnlyTrackSelected( tr ) end
    
reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_FOLDEROFF'), 0)    ----------SWS/S&M: Set selected tracks folder states to normal

reaper.Main_OnCommand(40296, 0) ---------------------------------------------------Select All 
 
reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELFIRSTOFSELTRAX'), 0) -----Xenakios/SWS: Select first of selected tracks


reaper.Main_OnCommand(40337, 0) -------------------------------------------------------Track: Cut tracks

reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTORESEL'), 0)   ------------restore tracks selection 
reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELLASTOFSELTRAX'), 0) ------Select last track
reaper.Main_OnCommand(40058, 0) -------------------------------------------------------Paste track    
 
function selected_items_on_tracks() 
 
  selected_tracks_count = reaper.CountSelectedTracks(0)

  for i = 0, selected_tracks_count-1  do
   
    track_sel = reaper.GetSelectedTrack(0, i) 

    item_num = reaper.CountTrackMediaItems(track_sel)

   
    for j = 0, item_num-1 do
      item = reaper.GetTrackMediaItem(track_sel, j)
      reaper.SetMediaItemSelected(item, 1)
    end

  end 
  



end

selected_items_on_tracks() 


reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVESEL'), 0) --SWS: Save current track selection


reaper.Main_OnCommand(41051, 0) -------------------------------------Item properties: Toggle take reverse

reaper.Main_OnCommand(41173, 0)--------------------------------------Item navigation: Move cursor to start of items  



reaper.Main_OnCommand(40699, 0) ------------------------------------Edit: Cut items


--reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_LOADTRACKTEMPLATE01'), 0) --Xenakios/SWS: [Deprecated] Load track template 01!!!!!!!!!!!!!!!!!!!!!






revtail = itemsstart-startOut





if revtail <= 0.3 then

tail = 0.3

elseif revtail <= 0.5 then

tail = 0.6

elseif revtail > 0.5 and revtail <= 0.8  then

tail = 0.65

elseif revtail >= 0.8 and  revtail < 1.1 then


tail = 0.75


elseif revtail >= 1.1 and  revtail < 2 then


tail = 0.80


elseif revtail >= 2 and  revtail < 2.5 then

tail = 0.85

elseif revtail >= 2.5 and  revtail < 3 then

tail = 0.90

elseif revtail >= 3 and  revtail < 4 then

tail = 0.94

elseif revtail >= 4 and  revtail < 5 then

tail = 0.95


elseif revtail >= 5 and  revtail < 6 then

tail = 0.97 

elseif revtail >= 6 and  revtail < 8 then

tail = 0.98 

elseif revtail >= 8 and  revtail < 10 or revtail > 10  then

tail = 1



end









seltrack = reaper.GetSelectedTrack( 0, 0 )
 
seltracknumber = reaper.GetMediaTrackInfo_Value( seltrack, 'IP_TRACKNUMBER' )



reaper.InsertTrackAtIndex(seltracknumber, true)
local SwellTr = reaper.GetTrack(0, seltracknumber)
reaper.SetOnlyTrackSelected(SwellTr)


 

 SwellReverb = reaper.TrackFX_AddByName( SwellTr, 'ReaVerbate', 0, 1 )
 reaper.TrackFX_SetParamNormalized( SwellTr, SwellReverb, 0, 0.3 )
 reaper.TrackFX_SetParamNormalized( SwellTr, SwellReverb, 1, 0 )
 reaper.TrackFX_SetParamNormalized( SwellTr, SwellReverb, 2, tail ) 
 reaper.TrackFX_SetParamNormalized( SwellTr, SwellReverb, 3, 0.6 )
 reaper.TrackFX_SetParamNormalized( SwellTr, SwellReverb, 4, 1 )
 reaper.TrackFX_SetParamNormalized( SwellTr, SwellReverb, 5, 0 )
 reaper.TrackFX_SetParamNormalized( SwellTr, SwellReverb, 6, 1 )
 reaper.TrackFX_SetParamNormalized( SwellTr, SwellReverb, 7, 0.005 )













reaper.Main_OnCommand(40058, 0) --------------------------------------Psste Items

--reaper.Main_OnCommand(40118, 0) ----------move item

reaper.Main_OnCommand(40209, 0) ------------------------------------Item: Apply track/take FX to items


reaper.Main_OnCommand(40131, 0) -------------------------------Take: Crop to active take in items


reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTORESEL'), 0) -----------------SWS: Restore saved track selection


reaper.Main_OnCommand(40005, 0) ------------------------------------Delete Previus track


reaper.Main_OnCommand(41051, 0) ----------------------------------------------Item properties: Toggle take reverse

function seltrack() 


  UnselectAllTracks()

  selected_items_count = reaper.CountSelectedMediaItems(0)
  

  for i = 0, selected_items_count - 1  do

    item = reaper.GetSelectedMediaItem(0, i) 

    track = reaper.GetMediaItem_Track(item)
    reaper.SetTrackSelected(track, true)
        
  end -- 



end

function UnselectAllTracks()
  first_track = reaper.GetTrack(0, 0)
  reaper.SetOnlyTrackSelected(first_track)
  reaper.SetTrackSelected(first_track, false)
end


reaper.PreventUIRefresh(1) 

seltrack() 



reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_CLRFXCHAIN3'), 0) ---clear fx chain



function rename()



for i = 0, tracks_count - 1 do
    
    track = reaper.GetSelectedTrack(0, i)



if track then
      
        track_name_retval, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "Reverb Swell", true) 


end
end

end

tracks_count = reaper.CountSelectedTracks(0)

rename()

reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_WNCLS4'), 0)  ---Close FX



reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_RESTORE_CURSOR_POS_SLOT_5'), 0) 


reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTOREVIEW'), 0)

       
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Reverb Swell', -1)

 

end  







startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"
selected_items_count = reaper.CountSelectedMediaItems(0)

if endOut > 0 and selected_items_count > 0 then 
swell()
end

   
  
    

    


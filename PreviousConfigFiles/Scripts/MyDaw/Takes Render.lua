


function Wrap()


item = {}
take = {}
name = {}
start_pos = {}
length = {}
end_pos = {}
items_on_same_track = {}
item_track = {}
midi_items = {}
midi_idx = 0

track_idx = 0
item_idx = 0

first_start_pos_in_track = nil
last_end_pos_in_track = nil

first_selected_track = nil
last_selected_track = nil



empty_items = {}
empty_index = 0

 
 
 reaper.Main_OnCommand(40290,0) --Time selection: Set time selection to items
   track = reaper.GetTrack(0,1)
   starttime = 1
   endtime = 2
   qnInOptional = 0
   
   reaper.Main_OnCommand( 40034, 0 ) --Item grouping: Select all items in groups
   selected_count = reaper.CountSelectedMediaItems(0)
   --Msg(selected_count)
 
   --Find selection start and end
   selectionStart, selectionEnd =  reaper.GetSet_LoopTimeRange(0,0,0,0,0)
   selectionLength = selectionEnd - selectionStart
    
   --check if there are empty items in selection
   for i = 0, selected_count - 1 do
     local item = reaper.GetSelectedMediaItem(0,i)
     local take = reaper.GetMediaItemTake(item, 0)
     if take ~= nil then
       local name =  reaper.GetTakeName(take)
     else
       empty_items[empty_index] = item
       empty_index = empty_index + 1
     end
   end
  --run thru all selected items
  for k in pairs(empty_items) do
    local label_start =  reaper.GetMediaItemInfo_Value( empty_items[k], "D_POSITION")
    local label_length = reaper.GetMediaItemInfo_Value( empty_items[k], "D_LENGTH")
    local label_end = label_start + label_length
    
    if label_start ~= selectionStart or label_end ~= selectionEnd then
       reaper.SetMediaItemInfo_Value( empty_items[k], "D_POSITION", selectionStart)
       reaper.SetMediaItemInfo_Value( empty_items[k], "D_LENGTH", selectionLength)
    end
  end
  
  for i = 0, selected_count - 1 do

    --get the values
    item[i] = reaper.GetSelectedMediaItem(0,i)
    take[i] = reaper.GetMediaItemTake(item[i], 0)
    if take[i] ~= nil then
      name[i] =  reaper.GetTakeName(take[i])
    else
      there_is_empty_item = true
    end
    start_pos[i] = reaper.GetMediaItemInfo_Value( item[i], "D_POSITION")
    length[i] = reaper.GetMediaItemInfo_Value( item[i], "D_LENGTH")
    end_pos[i] = start_pos[i] + length[i]
    item_track[i] = reaper.GetMediaItem_Track(item[i])


    --Msg(name[i])
    --Msg(item_track[i])
    --Msg()
    --Msg(start_pos[i])
    --Msg(end_pos[i])
    --Msg("===")

    --calculate first and last track
    item_track[i] = reaper.GetMediaItem_Track(item[i])
    track_number = reaper.GetMediaTrackInfo_Value(item_track[i], "IP_TRACKNUMBER" )
    --Msg(track_number)
    if first_selected_track == nil then
      first_selected_track = track_number
      last_selected_track = track_number
    elseif track_number < first_selected_track then
      first_selected_track = track_number
    elseif  last_selected_track < track_number then
      last_selected_track = track_number
    end




    --fill the gaps
    if i > 0 then
      if item_track[i] == item_track[i-1] then
        empty_midi = reaper.CreateNewMIDIItemInProj(item_track[i], end_pos[i-1], start_pos[i], qnInOptional ) --between items of same track
        midi_items[midi_idx] = empty_midi
        --name
        local mid_take = reaper.GetMediaItemTake(empty_midi, 0)
        reaper.GetSetMediaItemTakeInfo_String(mid_take, "P_NAME", "", true)
        
        midi_idx = midi_idx + 1
      else
        a = reaper.CreateNewMIDIItemInProj(item_track[i-1], end_pos[i-1], selectionEnd,qnInOptional) -- at the end of inner tracks
        --name
        local mid_take = reaper.GetMediaItemTake(a, 0)
        reaper.GetSetMediaItemTakeInfo_String(mid_take, "P_NAME", "", true)
        
        midi_items[midi_idx] = a
        midi_idx = midi_idx + 1

        b = reaper.CreateNewMIDIItemInProj(item_track[i], selectionStart, start_pos[i],qnInOptional) --at the start of inner tracks
        --name
        local mid_take = reaper.GetMediaItemTake(b, 0)
        reaper.GetSetMediaItemTakeInfo_String(mid_take, "P_NAME", "", true)
        
        midi_items[midi_idx] = b
        midi_idx = midi_idx + 1

        --fill completely empty tracks
        track_a_idx =  reaper.GetMediaTrackInfo_Value( item_track[i-1], "IP_TRACKNUMBER" )
        track_b_idx =  reaper.GetMediaTrackInfo_Value( item_track[i], "IP_TRACKNUMBER" )


        if track_b_idx - track_a_idx > 1 then
          for k = track_a_idx+1, track_b_idx-1 do
            trackk = reaper.GetTrack(0,k-1)
            mid = reaper.CreateNewMIDIItemInProj(trackk, selectionStart,selectionEnd,qnInOptional)
            local mid_take = reaper.GetMediaItemTake(mid, 0)
            reaper.GetSetMediaItemTakeInfo_String(mid_take, "P_NAME", "", true)
            midi_items[midi_idx] = mid
            midi_idx = midi_idx + 1
          end
        end

      end
    else
      if selectionStart ~= start_pos[i] then
        c = reaper.CreateNewMIDIItemInProj(item_track[i], selectionStart, start_pos[i], qnInOptional) --for start of first track
        --name
        local mid_take = reaper.GetMediaItemTake(c, 0)
        reaper.GetSetMediaItemTakeInfo_String(mid_take, "P_NAME", "", true)
        
        midi_items[midi_idx] = c
        midi_idx = midi_idx + 1
      end
    end

    if i == selected_count - 1 then
      if end_pos[i] ~= selectionEnd then
        d = reaper.CreateNewMIDIItemInProj(item_track[i], end_pos[i], selectionEnd, qnInOptional) -- for end of last track
        --name
        local mid_take = reaper.GetMediaItemTake(d, 0)
        reaper.GetSetMediaItemTakeInfo_String(mid_take, "P_NAME", "", true)
        
        midi_items[midi_idx] = d
        midi_idx = midi_idx + 1
      end
    end


  end





  for i = 0, midi_idx-1 do
    reaper.SetMediaItemSelected( midi_items[i], 1)
  end

  for i = 0, selected_count-1 do
    reaper.SetMediaItemSelected(item[i],1)
  end

    
  reaper.Main_OnCommand(40290,0) --set time selection on group

  --oboj
  --reaper.Main_OnCommand(40706,0) --Item: Set to one random color
    reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_ITEMRANDCOL"),0) --SWS: Set selected item(s) to one random custom color

end





reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)



reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVETIME1'), 0)   ----- SWS: Save time selection, slot 1
reaper.Main_OnCommand(40290, 0)  ----Time selection: Set time selection to items
reaper.Main_OnCommand(40224, 0)  ----Take: Explode takes of items across tracks
--reaper.Main_OnCommand(41588, 0) ----Item: Glue items



t0 = os.clock()
function run()
  t = os.clock()
  if t - t0 < 2 then reaper.defer(run) else   reaper.Main_OnCommand(40548, 0)  end
end

run()



reaper.Main_OnCommand(40548, 0) -----Item: Heal splits in items 


Wrap()


reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_AWTRIMFILL'), 0) ---SWS/AW: Trim selected items to fill selection
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SELTRKWITEM'), 0) ------SWS: Select only track(s) with selected item(s)
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_MAKEFOLDER'), 0) ----SWS: Make folder from selected tracks


--reaper.Main_OnCommand(40644, 0) ---Implode items across tracks into items on one track 


--reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SELCHILDREN'), 0) ---SWS: Select only children of selected folders
--reaper.Main_OnCommand(40005, 0) ---- Track: Remove tracks
--reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SELTRKWITEM'), 0) -----SWS: Select only track(s) with selected item(s)
--reaper.Main_OnCommand(40418, 0) ---Item navigation: Select and move to item in previous track
--reaper.Main_OnCommand(40718, 0) -----Item: Select all items on selected tracks in current time selection
--reaper.Main_OnCommand(40699, 0)  -------Edit: Cut items
--reaper.Main_OnCommand(40419, 0) ----Item navigation: Select and move to item in next track
--reaper.Main_OnCommand(41384, 0) -----Edit: Cut items/tracks/envelope points (depending on focus) within time selection, if any (smart cut)
--reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELPREVTRACK'), 0)   -----Xenakios/SWS: Select previous tracks
--reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_AWPASTE'), 0)------SWS/AW: Paste
--reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELNEXTTRACK'), 0)  ---Xenakios/SWS: Select next tracks
--reaper.Main_OnCommand(40005, 0) ------Track: Remove tracks
--reaper.Main_OnCommand(40635, 0) ----Time selection: Remove time selection
--reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTTIME1'), 0) ----SWS: Restore time selection, slot 1


   
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Takes Render', -1)  



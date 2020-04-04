function lanesoff()

function nothing() end
function exit() reaper.defer(nothing) end

Lanes_State = reaper.GetToggleCommandState(41329)

if Lanes_State == 1 then

reaper.Main_OnCommand(41330, 0) ---SEPARETE LANES OFF BUG

else exit() end 

end










function mutepreviousitems() 


local function nothing() end; local function noaction() reaper.defer(nothing) end

local tracks = reaper.CountTracks()

if not tracks == 0 then noaction() return end


for i = 0, tracks-1 do
  local tr = reaper.GetTrack(0, i)
  local tr_recarm = reaper.GetMediaTrackInfo_Value(tr, 'I_RECARM')
    
  if tr_recarm  == 1 then  
 
 
 for i = 0, reaper.GetTrackNumMediaItems(tr)-1 do
             local item = reaper.GetTrackMediaItem(tr, i) 
             
             isselected = reaper.GetMediaItemInfo_Value(item, "B_UISEL")
             
             
             if isselected == 1 then
             local itemStart = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
             local itemEnd = itemStart + reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
             reaper.GetSet_LoopTimeRange2(0, true, 0, itemStart, itemEnd, 0)
                 
             end


 for i = 0, reaper.GetTrackNumMediaItems(tr)-1 do
             
            
             local item = reaper.GetTrackMediaItem(tr, i) 
             
             isselected = reaper.GetMediaItemInfo_Value(item, "B_UISEL")
             
             
             if isselected == 0 then
             
             
             
            start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false) -- Get start and end time selection value in seconds
             
            if start_time ~= end_time then -- if there is a time selection
                
               
                    item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                    item_len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
             
                    item_end = item_pos + item_len -- Calculate the item end position
             
                    if (item_pos >= start_time and item_pos <= end_time) or (item_end >= start_time and item_end <= end_time) or (item_pos <= start_time and item_end >= end_time) then -- check if item is in time selection
                            
                        reaper.SetMediaItemInfo_Value(item, "B_MUTE", 1) -- Set new value
                            
                    end -- end if item is in time selection
                    
                end
         
            
 reaper.TrackList_AdjustWindows(0)            
 reaper.UpdateArrange()            
             
                   
                 
end  
             
             
end           

                      
 
end

end


 
 
end   --------------end 

reaper.Main_OnCommand(40635, 0) ---------remove Time selection      


 
end   --------------end 


  
 




startOut, endOut = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) --  Даем переменную "Time selection"

Scroll_State = reaper.GetToggleCommandState(40036)
focus = reaper.GetCursorContext()
Record_State = reaper.GetExtState('SmartRecord', 'Recording') 







function NoUndoPoint() end 

function guidesoff()

name1 = 'Guide'
name2 = 'guide'
name3 = 'GUIDE'
name4 = 'Reference'
name5 = 'reference'
name6 = 'REFERENCE'
name7 = 'Ref'
name8 = 'ref'
name9 = 'REF'


local function nothing() end; local function noaction() reaper.defer(nothing) end

local tracks = reaper.CountTracks()

if not tracks == 0 then noaction() return end


for i = 0, tracks-1 do
  local tr = reaper.GetTrack(0, i)
  local _, tr_name = reaper.GetSetMediaTrackInfo_String(tr, 'P_NAME', '', 0)
  local param = 'B_MUTE'
  local param1 = 'I_SOLO'  
  if tr_name  == name1 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name2 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name3 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name4 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name5 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name6 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name7 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name8 then  reaper.SetMediaTrackInfo_Value( tr, param, 1 )
  elseif tr_name  == name9 then  reaper.SetMediaTrackInfo_Value( tr, param, 1  )
 end


end

end








function NoScroll()
 
  reaper.PreventUIRefresh(1)
  local midieditor =  reaper.MIDIEditor_GetActive()
      if midieditor and focus == -1 then  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SN_FOCUS_MIDI_EDITOR'), 0)
      reaper.Main_OnCommand(40044, 0)  
else
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVEVIEW'), 0)
  reaper.Main_OnCommand(41173, 0)
  reaper.Main_OnCommand(40044, 0)
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTOREVIEW'), 0)  
  local midieditor =  reaper.MIDIEditor_GetActive()
        if midieditor and focus == -1 then  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SN_FOCUS_MIDI_EDITOR'), 0)
        end
  
  end
end  
  
function Scroll()  
local midieditor =  reaper.MIDIEditor_GetActive()
      if midieditor and focus == -1 then  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SN_FOCUS_MIDI_EDITOR'), 0)
      reaper.Main_OnCommand(40044, 0)   
else
 reaper.PreventUIRefresh(1)
  reaper.Main_OnCommand(41173, 0)
  reaper.Main_OnCommand(40044, 0)
local midieditor =  reaper.MIDIEditor_GetActive()
        if midieditor and focus == -1 then  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SN_FOCUS_MIDI_EDITOR'), 0)
        end  
  
 
  reaper.PreventUIRefresh(-1)
end
end
   

function playstop()

if endOut  == 0 then


 if Scroll_State == 0 then        
    NoScroll()  
  else                            
     Scroll() 
  end


 else
  reaper.Main_OnCommand(40630, 0)-----Cursos to TS
  reaper.Main_OnCommand(40044, 0)-----Play


end
end


RegularRecord = reaper.GetToggleCommandState(1013)


if Record_State == '1'or RegularRecord == 1 then 


playstop()
guidesoff() 
reaper.Main_OnCommand(41746, 0) --Disable metronome
mutepreviousitems()
local recordz = 0
reaper.DeleteExtState('SmartRecord', 'Recording', 0)
reaper.SetExtState('SmartRecord', 'Recording', recordz, 0)






else

playstop()

end 


reaper.defer(NoUndoPoint)


lanesoff()

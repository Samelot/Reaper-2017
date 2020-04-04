


isreturns = 0

reaper.Undo_BeginBlock() reaper.PreventUIRefresh(1)

function tracksnotzero()

if reaper.CountSelectedTracks() > 0 then
  local last_sel = reaper.GetSelectedTrack(0,reaper.CountSelectedTracks()-1)
  reaper.SetOnlyTrackSelected(last_sel)
  reaper.Main_OnCommand(40914,0) -- Track: Set first selected track as last touched track
  local dep = reaper.GetMediaTrackInfo_Value(last_sel, "I_FOLDERDEPTH")

  
  if dep > 0 then
    reaper.Main_OnCommand(40001, 0)----Track: Insert new track
    reaper.SetMediaTrackInfo_Value( last_sel , 'I_FOLDERCOMPACT', 0 )


  else
    reaper.Main_OnCommand(40001, 0)----Track: Insert new track
  end
else 
  local n = reaper.CountTracks(0)
  if n > 0 then
    local was_last_tr = reaper.GetTrack(0, n-1)
    local dep = reaper.GetMediaTrackInfo_Value(was_last_tr, "I_FOLDERDEPTH")
    reaper.SetOnlyTrackSelected(was_last_tr)
    reaper.Main_OnCommand(40702, 0) --Track: Insert new track at end of track list
  end
end

end

tracks = reaper.CountTracks()


if tracks == 0 then  reaper.Main_OnCommand(40001, 0)-------Track: Insert new track
else 
tracksnotzero() 
end

reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_TRACKRANDCOL'), 0)  ----set color


 function sendtrackstoreturns()
   
 reaper.Main_OnCommand(40296, 0) ----select all tracks  
   
   function addtoselection()
   local function nothing() end; local function noaction() reaper.defer(nothing) end
   local retval, notes = reaper.GetProjExtState( 0, 'MyDaw', 'Return')
   local data = notes:match'||addreturns\r\n(.-\r\n)end||'
   if not data then noaction() return end
   local sel_tracks_str = data:match('return_note'..'%d'..' (.-)\r\n')
   if not sel_tracks_str then noaction()() return end
   
   local t = {}
   
   for guid in sel_tracks_str:gmatch'{.-}' do
     local tr = reaper.BR_GetMediaTrackByGUID(0, guid)
     if tr then t[#t+1] = tr end
   end
   
   if #t == 0 then noaction() return end
   
   local first = reaper.GetTrack(0, 0)
   
   
   for i = 1, #t do reaper.SetTrackSelected(t[i],0) end
   
   
   end
   
   
 
 
      
 addtoselection() 
 
 
 
 
 
 reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SAVESEL'), 0) ---savetrack seslect
 
 
 
 
 
  
      
     
      
     
      
 local defsendflag = ({reaper.BR_Win32_GetPrivateProfileString( 'REAPER', 'defsendflag', '0',  reaper.get_ini_file() )})[2]     
      
      
      
      
           
           
           
           local function nothing() end; local function noaction() reaper.defer(nothing) end
           local retval, notes = reaper.GetProjExtState( 0, 'MyDaw', 'Return')
           local data = notes:match'||addreturns\r\n(.-\r\n)end||'
           if not data then noaction() return end
           local sel_tracks_str = data:match('return_note'..'%d'..' (.-)\r\n')
           if not sel_tracks_str then noaction()() return end
           
           local t = {}
           
           for guid in sel_tracks_str:gmatch'{.-}' do
             local new_dest_tr = reaper.BR_GetMediaTrackByGUID(0, guid)
             if new_dest_tr then t[#t+1] = new_dest_tr end
             
             
 reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_RESTORESEL'), 0) ---restore savetrack seslect              
             
             
      
      
      
      
      
      
     local selected = {}
     
     local function wasSelected(match)
       for i,new_dest_tr in ipairs(selected) do
         if new_dest_tr == match then
           return true
         end
       end
     return false
     end
     
     local function highlight(new_dest_tr, select)
       local send_receive = -1
     
       for i=0, reaper.GetTrackNumSends(new_dest_tr, send_receive)-1 do
         local target = reaper.BR_GetMediaTrackSendInfo_Track( new_dest_tr, send_receive, i, 0)
     
         reaper.SetTrackSelected(target, 0)
     
     
     
         if select then
           highlight(target, select)
         end
       end
     end
     
     local function main()
       for i,new_dest_tr in ipairs(selected) do
         local valid = reaper.ValidatePtr(new_dest_tr, 'MediaTrack*')
         local isSelected = valid and reaper.IsTrackSelected(new_dest_tr)
     
     
     
     
     
     
         if not isSelected then
           table.remove(selected, i)
     
      if valid then
             highlight(new_dest_tr, false)
           end
     
     
         end
      
      
      
       end
     
        
     
         if not wasSelected(new_dest_tr) then
           selected[#selected + 1] = new_dest_tr
         end
         
         
        highlight(new_dest_tr, true)
     
     
     
      
     end
     
     main() 
      
      
      
      
       
             
             
             
     
  for i = 1, reaper.CountSelectedTracks(0) do
     local tr = reaper.GetSelectedTrack(0,i-1)
       if tr then 
             
            
             
             
             
             
             new_send_id = reaper.CreateTrackSend( tr, new_dest_tr )
                       if new_send_id >= 0 then
             
                         if new_dest_tr then
                         
                         
                           reaper.SetTrackSendInfo_Value( tr, 0, new_send_id, 'D_VOL', 0)
                           reaper.SetTrackSendInfo_Value( tr, 0, new_send_id, 'I_SENDMODE', defsendflag)
                         end
                       end
             
             
            end
           
           if #t == 0 then noaction() return end
           
             
           
           
           
           
         end
       end
       reaper.TrackList_AdjustWindows( false )
 
   
 end  ----- function sendtrackstoreturns() end
  



local function nothing() end; local function noaction() reaper.defer(nothing) end



local tracks =  reaper.CountTracks(0)


if tracks == 0 then noaction() return end


for i = 0, tracks-1 do 

getrack =  reaper.GetTrack( 0, i )

retval, stringNeedBig = reaper.GetSetMediaTrackInfo_String( getrack, 'P_TCP_LAYOUT' , 0, 0 )


if (stringNeedBig == 'Return') then

isreturns = 1

end


end



if (isreturns == 1) then


sendtrackstoreturns()


end


 
reaper.PreventUIRefresh(-1) reaper.Undo_EndBlock('Insert Track', -1)





















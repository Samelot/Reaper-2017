reaper.Undo_BeginBlock() reaper.PreventUIRefresh(1)

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


for i = 1, #t do reaper.SetTrackSelected(t[i],1) end


end



function addreturnstonotes()

local return_note = 0

local function esc_lite(str) str = str:gsub('%-', '%%-') return str end

local function nothing() end; local function noaction() reaper.defer(nothing) end


local tracks = reaper.CountSelectedTracks()
if tracks == 0 then noaction() return end

local return_str = ''

for i = 0, tracks-1 do 


return_str = return_str..reaper.GetTrackGUID(reaper.GetTrack(0, i)) end


local retval, notes = reaper.GetProjExtState( 0, 'MyDaw', 'Return')

local a = '||addreturns\r\n'

local data = notes:match(a..'(.-\r\n)end||')

if data then

local new_data
local return_note_data = data:match('return_note'..'%d'..' (.-)\r\n')


if return_note_data then
    new_data = data:gsub('return_note'..'%d'..' '..esc_lite(return_note_data),'return_note'..return_note..' '..return_str,1)
else new_data = data..'return_note'..return_note..' '..return_str..'\r\n' end
 
notes = notes:gsub(esc_lite(data),new_data)


  
elseif notes=='' then notes = notes..a..'return_note'..return_note..' '..return_str..'\r\nend||\r\n'


else notes = notes..'\r\n'..a..'return_note'..return_note..' '..return_str..'\r\nend||\r\n' end

reaper.SetProjExtState( 0, 'MyDaw', 'Return', notes ) 
reaper.TrackList_AdjustWindows(0)

end


reaper.InsertTrackAtIndex(0, true)
local bus = reaper.GetTrack(0, 0)


reaper.GetSetMediaTrackInfo_String( bus, "P_TCP_LAYOUT", "Return", true )
reaper.GetSetMediaTrackInfo_String(bus, "P_NAME", "Return", true) 

reaper.Main_OnCommand(40297, 0) ----unselect all tracks

reaper.SetTrackSelected(bus,1)
gray=127
color =  reaper.ColorToNative( gray, gray, gray )
reaper.SetTrackColor( bus, color)


addtoselection()
addreturnstonotes()





  
    
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
  




sendtrackstoreturns()


reaper.PreventUIRefresh(-1) reaper.Undo_EndBlock('Insert Return', -1)














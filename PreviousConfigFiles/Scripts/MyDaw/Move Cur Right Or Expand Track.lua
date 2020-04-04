function MoveCur()
function NoUndoPoint() end 
reaper.Main_OnCommand(40755, 0)
reaper.Main_OnCommand(40754, 0) 
local cursorpos = reaper.GetCursorPosition()
local grid = cursorpos
while (grid <= cursorpos) do
    cursorpos = cursorpos + 0.05
    grid = reaper.SnapToGrid(0, cursorpos)
end
reaper.SetEditCurPos(grid,1,0)
reaper.Main_OnCommand(40756, 0) 
reaper.defer(NoUndoPoint)
end



local focus = reaper.GetCursorContext()


if focus == 0 then
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_UNCOLLAPSE'), 0)


function Decrease()
  for sel_tr = 1, reaper.CountSelectedTracks(0) do
    local track = reaper.GetSelectedTrack(0,sel_tr-1)
    if track then 
    reaper.SetMediaTrackInfo_Value( track, 'I_HEIGHTOVERRIDE', 78 )
    
    reaper.TrackList_AdjustWindows(true) -- Update the arrangement (often needed)
      
      reaper.UpdateArrange()
    
    
     
      end
    end
  end
  
Decrease()

function showenvelopes()
  for tr = 1, reaper.CountSelectedTracks(0) do
    local track = reaper.GetSelectedTrack(0,tr-1)
    if track then 
      for i = 1,  reaper.CountTrackEnvelopes( track ) do
        local env = reaper.GetTrackEnvelope( track, i-1 )
        local br_env = reaper.BR_EnvAlloc( env, false )
        local active, visible, armed, inLane, laneHeight, defaultShape, _, _, _, _, faderScaling = reaper.BR_EnvGetProperties( br_env )
        
        if active then visible = true else visible = false end
        
        reaper.BR_EnvSetProperties( br_env, 
                                  active, 
                                  visible, 
                                  armed, 
                                  inLane, 
                                  laneHeight, 
                                  defaultShape, 
                                  faderScaling )
        reaper.BR_EnvFree( br_env, true )
      end
    end
  end
  
end
    
showenvelopes()





else



MoveCur() 
reaper.Main_OnCommand(40769, 0) ---Unselect all tracks/items/envelope points
reaper.Main_OnCommand(40635, 0)----Time selection: Remove time selection


end
   






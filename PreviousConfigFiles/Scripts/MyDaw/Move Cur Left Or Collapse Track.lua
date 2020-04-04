function MoveCur()
function NoUndoPoint() end 
reaper.Main_OnCommand(40755, 0) -- Snapping: Save snap state
reaper.Main_OnCommand(40754, 0) -- Snapping: Enable snap
local cursorpos = reaper.GetCursorPosition()
if cursorpos > 0 then
  local grid = cursorpos
  while (grid >= cursorpos) do
      cursorpos = cursorpos - 0.05
      grid = reaper.SnapToGrid(0, cursorpos)
  end
  reaper.SetEditCurPos(grid,1,0)
end
reaper.Main_OnCommand(40756, 0) -- Snapping: Restore snap state
reaper.defer(NoUndoPoint)
end

local focus = reaper.GetCursorContext()


if focus == 0 then
reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_COLLAPSE'), 0)


function Increase()
  for sel_tr = 1, reaper.CountSelectedTracks(0) do
    local track = reaper.GetSelectedTrack(0,sel_tr-1)
    if track then 
    reaper.SetMediaTrackInfo_Value( track, 'I_HEIGHTOVERRIDE', 26 )
    reaper.TrackList_AdjustWindows(true) -- Update the arrangement (often needed)
      
      reaper.UpdateArrange()
    
    
     
      end
    end
  end
  
Increase()

reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_ENV_HIDE_ALL_BUT_ACTIVE_SEL'), 0)

else
MoveCur() 
reaper.Main_OnCommand(40769, 0) ---Unselect all tracks/items/envelope points
reaper.Main_OnCommand(40635, 0)----Time selection: Remove time selection
end


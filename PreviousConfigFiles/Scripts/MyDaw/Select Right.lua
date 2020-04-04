reaper.PreventUIRefresh(11)
function NoUndoPoint() end 

CursorToTime = 40276
CursorToTime_State = reaper.GetToggleCommandState(CursorToTime)
wason = 0
if (CursorToTime_State == 1) then
reaper.Main_OnCommand(CursorToTime, 0)
wason= 1
end

  sel_start, sel_end = reaper.GetSet_LoopTimeRange(false,false,0,0,false)
  cursorpos = reaper.GetCursorPosition()
  grid = reaper.BR_GetNextGridDivision(cursorpos)
  if sel_start == 0 and sel_end == 0 then
    reaper.Main_OnCommand(40625, 0) -- set start point time selection
  end
 reaper.Main_OnCommand(40755, 0) -- Snapping: Save snap state
 reaper.Main_OnCommand(40754, 0) -- Snapping: Enable snap
 local cursorpos = reaper.GetCursorPosition()
 local grid = cursorpos
 while (grid <= cursorpos) do
     cursorpos = cursorpos + 0.05
     grid = reaper.SnapToGrid(0, cursorpos)
 end
  reaper.SetEditCurPos(grid,1,0)
  
  if sel_start == 0 and sel_end == 0 then
    reaper.Main_OnCommand(40626, 0) -- set end point time selection
  else
    if cursorpos >= (sel_start+sel_end)/2 then
      reaper.Main_OnCommand(40626, 0) -- set end point time selection
    else
      reaper.Main_OnCommand(40625, 0) -- set start point time selection
    end
  end
 
  
  reaper.Main_OnCommand(40718, 0)
 
  reaper.Main_OnCommand(40756, 0) -- Snapping: Restore snap state  
  
  if (wason == 1) then
  reaper.Main_OnCommand(CursorToTime, 0)
  end



reaper.defer(NoUndoPoint)
reaper.PreventUIRefresh(-11)

reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
local function nothing() end
local function exit() reaper.defer(nothing) end

local item = reaper.GetSelectedMediaItem(0,0)
if not item then exit() return end
reaper.Main_OnCommand(41173, 0)


reaper.Main_OnCommand(40635, 0) 
reaper.Main_OnCommand(40754, 0) 
local cursorpos = reaper.GetCursorPosition()
local grid = cursorpos
while (grid <= cursorpos) do
    cursorpos = cursorpos + 0.05
    grid = reaper.SnapToGrid(0, cursorpos)
end
reaper.SetEditCurPos(grid,1,0)
reaper.Main_OnCommand(40756, 0) 
reaper.Main_OnCommand(41205, 0)


reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Move Item Right', -1) 

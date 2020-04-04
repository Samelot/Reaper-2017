----------------------------------------------------------------------------------------------------
local msg = function(M) reaper.ShowConsoleMsg(tostring(M).."\n") end
----------------------------------------------------------------------------------------------------
defer_rate = 1
reaper.PreventUIRefresh(1)-- Prevent UI refreshing. Uncomment it only if the script works.
local Project = {}
function Project.isChanged()
  local change_cnt = reaper.GetProjectStateChangeCount(0)
  if change_cnt ~= Project.change_cnt then
    Project.change_cnt = change_cnt
    return true
  end
end

function main ()
  if Project.isChanged() then
    counttracks = reaper.CountTracks(0)
    for i = 1, counttracks do
      track = reaper.GetTrack(0,i-1)
      if track ~= nil then
        if reaper.IsTrackSelected( track ) == true then
          reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 1)
        else
          reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 0)
        end
      end
    end
  end
end


---------------- Mainloop---------------------------------------------------------------------------
cycle = 0
function mainloop ()
  cycle = cycle+1
  if cycle == defer_rate then
    main()
    cycle = 0
  end
  reaper.defer(mainloop)
end

reaper.PreventUIRefresh(-1) -- Restore UI Refresh. Uncomment it only if the script works.

----------------------------------------------------------------------------------------------------
-- Set ToolBar Button ON
function SetButtonON()
  is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
  state = reaper.GetToggleCommandStateEx( sec, cmd )
  reaper.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
  reaper.RefreshToolbar2( sec, cmd )
end
--
-- Set ToolBar Button OFF
function SetButtonOFF()
  is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
  state = reaper.GetToggleCommandStateEx( sec, cmd )
  reaper.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  reaper.RefreshToolbar2( sec, cmd )
end
----------------------------------------------------------------------------------------------------


SetButtonON() -- функция запуска срипта с "поджигом" кнопки тулбара

mainloop () -- основная функция дефера


reaper.atexit(SetButtonOFF) -- выход из скрипта с запуском функции выхода с тушением кнопки тулбара

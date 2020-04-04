----------------------------------------------------------------------------------------------------
local msg = function(M) reaper.ShowConsoleMsg(tostring(M).."\n") end
----------------------------------------------------------------------------------------------------
local sel_track_n = 0
local Fx_id = {}
function Start ()
  local track_cnt = reaper.CountTracks(0)
  for i = 1, track_cnt do
    local track = reaper.GetTrack(0, i-1)
    seltrack = reaper.GetMediaTrackInfo_Value(track, "I_SELECTED")
    if seltrack == 1 then
      if track ~= sel_track_n then
        sel_Track = track
        if sel_track_n ~= 0 then
          reaper.TrackFX_Show( sel_track_n, 0, 0 )
        end
        reaper.TrackFX_Show( sel_Track, 0, 1 )
        local cnt_FX =  reaper.TrackFX_GetCount( sel_Track )
        for i=1, cnt_FX do
          local FX_on = reaper.TrackFX_GetEnabled(sel_Track, i-1 )
          if FX_on == false then
            table.insert(Fx_id, i-1)
          end
        end
      end
    end
  end
  sel_track_n = sel_Track
end


function Main ()
  if sel_Track then
    local cnt_FX =  reaper.TrackFX_GetCount( sel_Track )
    local FX_vis = reaper.TrackFX_GetChainVisible(sel_Track )
    for i=1, #Fx_id do
      if Fx_id[i] == FX_vis then
        reaper.TrackFX_SetEnabled(sel_Track, Fx_id[i], 1)
      else
        reaper.TrackFX_SetEnabled(sel_Track, Fx_id[i], 0)
      end
      -- msg(Fx_id[i])
    end
    reaper.defer(Main)
  else
    mesg = [=[   Выделите один Трек!!!
    ]=]
    fff = reaper.MB(mesg , "            ВНИМАНИЕ!!!", 0)
    return
  end
  Start ()
end

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
  if sel_Track then
    reaper.TrackFX_Show( sel_Track, 0, 0 )
  end
  is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
  state = reaper.GetToggleCommandStateEx( sec, cmd )
  reaper.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  reaper.RefreshToolbar2( sec, cmd )
end
----------------------------------------------------------------------------------------------------


SetButtonON() -- функция запуска срипта с "поджигом" кнопки тулбара
Start ()

Main () -- основная функция дефера

reaper.atexit(SetButtonOFF) -- выход из скрипта с запуском функции выхода с тушением кнопки тулбара

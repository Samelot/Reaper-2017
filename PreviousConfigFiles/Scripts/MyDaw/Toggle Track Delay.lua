


for i = 1, reaper.CountSelectedTracks(0) do
        local seltr = reaper.GetSelectedTrack(0,i-1)
        if seltr then 

time_adjustment = reaper.TrackFX_AddByName( seltr, "MIDI_Time_Adjustment", false, 0 )


if time_adjustment == -1 then 


time_adjustment_index = reaper.TrackFX_GetByName( seltr, "MIDI_Time_Adjustment", 1 )


reaper.TrackFX_AddByName( seltr, "MIDI_Time_Adjustment", false, 1 )   
    
    

while time_adjustment_index > 0  do

reaper.SNM_MoveOrRemoveTrackFX( seltr, time_adjustment_index, -1 )
time_adjustment_index = reaper.TrackFX_GetByName( seltr, "MIDI_Time_Adjustment", 1 )

end


time_adjustment_index = reaper.TrackFX_GetByName( seltr, "MIDI_Time_Adjustment", 1 )
reaper.SNM_AddTCPFXParm( seltr, time_adjustment_index, 0 )

elseif time_adjustment > -1 then  

time_adjustment_index = reaper.TrackFX_GetByName( seltr, "MIDI_Time_Adjustment", 1 )
reaper.SNM_MoveOrRemoveTrackFX( seltr, time_adjustment_index, 0 )

end

end

end











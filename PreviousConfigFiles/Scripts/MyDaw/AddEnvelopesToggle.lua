

function XRClean(track)

function Action(delenv)
  retval, xml_env = reaper.GetEnvelopeStateChunk(env, "", false)
  xml_env = xml_env:gsub("\n", "¤¤")
  retval, xml_env = reaper.SetEnvelopeStateChunk(env, xml_env, false)
return xml_env
end
env_count = reaper.CountTrackEnvelopes(track)
for j = 0, env_count-1 do

          -- GET THE ENVELOPE
env = reaper.GetTrackEnvelope(track, j)
      
if env ~= nil then
br_env_del = reaper.BR_EnvAlloc(env, false)
      
active, visible, _, _, _, _, _, _, _, type, faderScaling = reaper.BR_EnvGetProperties(br_env_del, true, true, true, true, 0, 0, 0, 0, 0, 0, true)

 if visible == false and active == false then
          retval, xml_track = reaper.GetTrackStateChunk(track, "", false)
          xml_track = xml_track:gsub("\n", "¤¤")
          xml_env =  Action(delenv)
end
reaper.BR_EnvFree(br_env_del, 0)
end 
end

end 




local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
local state = reaper.GetToggleCommandStateEx( sectionID, cmdID )

if state == 1 then 


reaper.SetExtState("MyDaw", "ShowEnvelopes", 0, 0 )


reaper.Main_OnCommand(41150, 0) 


if reaper.CountTracks() > 0 then  


for i = 0, reaper.CountTracks()-1 do
  local tr = reaper.GetTrack(0, i)
  XRClean(tr)

 end

end



else  
reaper.Main_OnCommand(41149, 0)


reaper.SetExtState("MyDaw", "ShowEnvelopes", 1, 0 )

end

  




reaper.SetToggleCommandState(sectionID, cmdID, state == 1 and 0 or 1)
reaper.RefreshToolbar2(sectionID, cmdID)


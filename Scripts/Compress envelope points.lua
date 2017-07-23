-- Initialize variables ---
local e_i = {}
local e_v = {}
local envelope = {}
local sel_points = 0
local sum = 0
local average = 0
local c = 1
---------------------------


function get_set_envelope_points()
  local env = envelope.pointer
  local get_env_point = reaper.GetEnvelopePoint
  if env == nil then
    return
  else
    local min_val = envelope.min_val
    local max_val = envelope.max_val
    local name = envelope.name
 
    local env_point_count = reaper.CountEnvelopePoints(env)
    
    
  -- COLLECT POINTS --
  
    sel_points = 0
    sum = 0
    c = 1
    e_i = {}
    e_v = {}
    local value = 0
    local selected = false
    for i=1,env_point_count do
      value = ({get_env_point(env, i)})[3]
      selected = ({get_env_point(env, i)})[6]
      if selected then
        e_i[c] = i
        e_v[c] = value
        c = c+1
        sel_points = sel_points + 1
        sum = sum + value
      end
    end
    average = sum/sel_points
  
  
  -- APPLY CHANGES TO SELECTED ENVELOPE --

    for i=1, sel_points do
      local retval, timeOut, value, shape, tensionOut, selected = reaper.GetEnvelopePoint(env, e_i[i])
      local v = e_v[i]
      value = v + (average-v) * 0.1
      value = math.min(math.max(min_val, value), max_val)
      reaper.SetEnvelopePoint(env, e_i[i], timeOut, value)
    end
  end
  reaper.UpdateArrange()
end


function get_sel_env_properties()
  local env = reaper.GetSelectedEnvelope(0)
  if env == nil then
    return
  else
    local br_env = reaper.BR_EnvAlloc(env, true)
    local active, visible, armed, in_lane, lane_height, default_shape, 
          min_val, max_val, center_val, env_type, is_fader_scaling
          = reaper.BR_EnvGetProperties(br_env, false, false, false, false, 0, 0, 0, 0, 0, 0, false)
        
    reaper.BR_EnvFree(br_env, false)
    local retval, env_name = reaper.GetEnvelopeName(env, "")
    if env_name == "Volume" or env_name == "Volume (Pre-FX)" then
      max_val = reaper.SNM_GetIntConfigVar("volenvrange", -1)
      if max_val ~= -1 then
        if max_val == 1 then 
          max_val = 1.0
        elseif max_val == 0 then 
          max_val = 2.0
        elseif max_val == 4 then 
          max_val = 4.0
        else 
          max_val = 16.0
        end
      end 
      
      if is_fader_scaling then
        max_val = reaper.ScaleToEnvelopeMode(1, max_val)
        center_val = reaper.ScaleToEnvelopeMode(1, center_val)
      end
    end
    
    if env_name == "Pitch" then
      max_val = reaper.SNM_GetIntConfigVar("pitchenvrange", -1000)
      min_val = -max_val
     end
     
    envelope.pointer = env
    envelope.active = active
    envelope.visible = visible
    envelope.armed = armed
    envelope.in_lane = in_lane
    envelope.lane_height = lane_height
    envelope.default_shape = default_shape
    envelope.min_val = min_val
    envelope.max_val = max_val
    envelope.center_val = center_val
    envelope.is_fader_scaling = is_fader_scaling
    envelope.type = env_type
    envelope.name = env_name
  end
end  

function mainloop()
  get_sel_env_properties()
  get_set_envelope_points()
  
end

reaper.defer(mainloop)

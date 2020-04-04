--Based on Lokasenna code

function msg(m)
  reaper.ShowConsoleMsg(tostring(m) .. "\n")
end


if reaper.GetExtState("MyDaw", "ShowItemEnvelopes") and reaper.GetExtState("MyDaw", "ShowItemEnvelopes")~= "" then 
reaper.DeleteExtState( "MyDaw", "ShowItemEnvelopes", false ) E_ToggleState = 0
else
reaper.SetExtState( "MyDaw", "ShowItemEnvelopes", "true", false) 
E_ToggleState = 1
end 


 




local states = {
    Show = function() return true end,
    Hide = function() return false end,
    Toggle = function(state) return not state end,
}

local function get_new_state(state)
    
    local new = "Toggle"
    return states["Toggle"](state)
end


local function toggle_env_visibility(take, envidx)
    
    local env = reaper.GetTakeEnvelope( take, envidx)
    if not env then return end
    
    local env = reaper.BR_EnvAlloc(env, false)
    
      local props = {reaper.BR_EnvGetProperties(env)}
    local new = E_ToggleState
    
    --get_new_state(props[2])
    
    --if new ~= props[2] then
        reaper.BR_EnvSetProperties( env, props[1], new, props[3], props[4], props[5], props[6], props[11] )
   -- end

    local ret = reaper.BR_EnvFree(env, true)
    
end


local function iterate_env(take)

    local num_params = reaper.CountTakeEnvelopes(take)
    
    for i = 0, num_params - 1 do
        
        toggle_env_visibility(take, i)        
        
    end    
    
end
       


local function iterate_items()

    -- Get sel. item count
    local num_items = reaper.CountMediaItems()
    if num_items == 0 then return end

    -- For each sel. item
    for i = 0, num_items - 1 do
        
        local item = reaper.GetMediaItem(0, i)
        local take = reaper.GetActiveTake(item)
        
        iterate_env(take)

    end        
    
end

local function Main()
    
    if not reaper.BR_EnvAlloc then
        reaper.MB("This script requires the SWS extension for Reaper.", "Whoops!", 0)
        return
    end
    
    reaper.Undo_BeginBlock()
    reaper.PreventUIRefresh(1)
    
    
    
    
    iterate_items()
   



    
    
    
    is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
    reaper.SetToggleCommandState(sec, cmd, E_ToggleState);  
    reaper.RefreshToolbar2(sec, cmd);
    
    reaper.PreventUIRefresh(-1)
    reaper.UpdateTimeline()
    reaper.Undo_EndBlock("Toggle Show Item Envelopes", -1)
    
end

Main()

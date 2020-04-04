-----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------


FX = 40271 -- command id from action list
ME = 50124
MainTool = 41942
SideTool = 41943

FX_State = reaper.GetToggleCommandState(FX) -- get action state (on/off)
ME_State = reaper.GetToggleCommandState(ME)
MainTool_State = reaper.GetToggleCommandState(MainTool)
SideTool_State = reaper.GetToggleCommandState(SideTool)


function nothing() end
function exit() reaper.defer(nothing) end



function MEOFF()
if (ME_State == 1) then 
reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(ME, 0)
reaper.PreventUIRefresh(-1)  
else exit() end 
end 


function MainToolOFF()
if (MainTool_State == 1) then 
reaper.PreventUIRefresh(1) 
reaper.Main_OnCommand(MainTool, 0)  
reaper.PreventUIRefresh(-1)
else exit() end 
end 

function SideToolOFF()
if (SideTool_State == 1) then 
reaper.PreventUIRefresh(1) 
reaper.Main_OnCommand(SideTool, 0)
reaper.PreventUIRefresh(-1)  
else exit() end 
end 


function MEON()
if (ME_State == 0) then 
reaper.PreventUIRefresh(1) 
reaper.Main_OnCommand(ME, 0)
reaper.PreventUIRefresh(-1)  
else exit() end 
end 


function MainToolON()
if (MainTool_State == 0) then 
reaper.PreventUIRefresh(1) 
reaper.Main_OnCommand(MainTool, 0)
reaper.PreventUIRefresh(-1)  
else exit() end 
end 

function SideToolON()
if (SideTool_State == 0) then 
reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(SideTool, 0)
reaper.PreventUIRefresh(-1) 
else exit() end 

end 

function FXOFF()
if (FX_State == 1) then 
reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(FX, 0)
reaper.PreventUIRefresh(-1) 
else exit() end 
end 

function FXON()
if (FX_State == 0) then 
reaper.PreventUIRefresh(1) 
reaper.Main_OnCommand(FX, 0)
reaper.PreventUIRefresh(-1)   
else exit() end 
end 





---------Make SIDE OFF

if (MainTool_State == 0) then

reaper.PreventUIRefresh(1)
FXOFF()
MEOFF()
SideToolOFF()
MainToolON()
reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'), 0)
reaper.PreventUIRefresh(-1)

FX_State2 = reaper.GetToggleCommandState(FX)
if (FX_State2 == 1) then
reaper.Main_OnCommand(FX, 0)
end


    
    
  
    
      toggleState = 0

---------Make SIDE ON
  elseif (MainTool_State == 1) then
reaper.PreventUIRefresh(1)  
  FXON()
  MEON()
  SideToolON()
  MainToolOFF()
reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'), 0)  
reaper.PreventUIRefresh(-1)
  
    toggleState = 1
end


is_new,name,sec,cmd,rel,res,val = reaper.get_action_context()
reaper.SetToggleCommandState(sec, cmd, toggleState);  
reaper.RefreshToolbar2(sec, cmd);  


reaper.UpdateArrange()
no_undo()


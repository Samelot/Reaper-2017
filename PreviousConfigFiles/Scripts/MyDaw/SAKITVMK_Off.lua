InputToVKB = 40637
ShowVkb = 40377

InputToVKB_State = reaper.GetToggleCommandState(InputToVKB)
ShowVkb_State = reaper.GetToggleCommandState(ShowVkb)


function nothing() end
function exit() reaper.defer(nothing) end



function InputToVKBOFF()
if (InputToVKB_State == 1) then 
reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(InputToVKB, 0)
reaper.PreventUIRefresh(-1)  
else exit() end 
end 



reaper.PreventUIRefresh(1)
InputToVKBOFF()
reaper.PreventUIRefresh(-1)

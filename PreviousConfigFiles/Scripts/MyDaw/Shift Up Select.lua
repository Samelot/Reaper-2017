local function nothing() end; local function noaction() reaper.defer(nothing) end

tracks = reaper.CountTracks()
sel_tracks = reaper.CountSelectedTracks()

if tracks == 0 then noaction() return end 

 if sel_tracks == 0 then
  
  reaper.Main_OnCommand(40505, 0) ---select last tousched
  reaper.Main_OnCommand(40718, 0) ---select all items in currient time selection
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'), 0)
 elseif sel_tracks > 0 then
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELPREVTRACKKEEP'), 0)
    reaper.Main_OnCommand(40718, 0) ---select all items in currient time selection
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'), 0)
  
end 

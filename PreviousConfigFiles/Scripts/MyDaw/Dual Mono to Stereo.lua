reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)


reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SELTRKWITEM'), 0)
reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_SELFIRSTOFSELTRAX'), 0)
reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_IMPLODEITEMSPANSYMMETRICALLY'), 0)
reaper.Main_OnCommand(41588, 0)
reaper.Main_OnCommand(40285, 0)
reaper.Main_OnCommand(40005, 0)
reaper.Main_OnCommand(40286, 0)
reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_RENAMETRAXDLG'), 0)



reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Dual Mono To Stereo', -1)  



   
  

    


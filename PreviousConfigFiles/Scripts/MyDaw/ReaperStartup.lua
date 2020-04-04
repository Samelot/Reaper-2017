-----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------




-- Is SWS installed?
if not reaper.APIExists("ULT_SetMediaItemNote") then
    reaper.ShowMessageBox("This script requires the SWS/S&M extension.\n\nThe SWS/S&M extension can be downloaded from www.sws-extension.org.", "ERROR", 0)
    return false 
end


local info = debug.getinfo(1,'S');
local script_path = info.source:match([[^@?(.*[\/])[^\/]-$]])

settemp = os.getenv"TEMP"


splash = (script_path .. "ReaperResources\\MyDawSplash.png")
metr_up = (script_path .. "ReaperResources\\Metronome\\MetronomeUp.wav")
metr = (script_path .. "ReaperResources\\Metronome\\Metronome.wav")


function writeini(section, key, path)
inipath = reaper.get_ini_file()
reaper.BR_Win32_WritePrivateProfileString(section, key, path, inipath )
reaper.TrackList_AdjustWindows(true)
reaper.UpdateArrange()
end


writeini("reaper","splashimage", splash)
writeini("reaper","projmetrofn1", metr_up)
writeini("reaper","projmetrofn2", metr)
writeini("reaper","defrecpath", settemp)
writeini("vkb","notecenter",72)














reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40001, 0) ---Track: Insert new track

reaper.Main_OnCommand(40214, 0) ---Insert new MIDI item...

reaper.Main_OnCommand(40153, 0) ---Step input: Insert note at current -11 semitones

reaper.MIDIEditor_LastFocused_OnCommand(40045, 0) ---View: Toggle show note names

reaper.SetMIDIEditorGrid( 0, 0,0625 )


Step_State = reaper.GetToggleCommandStateEx(32060,40481)

if (Step_State == 1) then
reaper.MIDIEditor_LastFocused_OnCommand(40481, 0) 
end








reaper.Main_OnCommand(41676, 0) ----Toolbar: Open MIDI/close piano roll toolbar

reaper.Main_OnCommand(40505, 0) ----Track: Select last touched track

reaper.Main_OnCommand(40005, 0) ---Track: Remove tracks

reaper.Main_OnCommand(40042, 0) ----Transport: Go to start of project

reaper.PreventUIRefresh(-1)


    reaper.UpdateArrange()
    no_undo()







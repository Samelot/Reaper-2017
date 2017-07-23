SCRIPT_PATH = debug.getinfo(1,'S').source:match[[^@?(.*[\/])[^\/]-$]]
if string.sub(reaper.GetOS(), 1, 3) == "Win" then SEP = "\\" else SEP = "/" end
dofile(SCRIPT_PATH.."inspector.dat")


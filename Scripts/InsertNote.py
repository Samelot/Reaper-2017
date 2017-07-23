from reaper_python import *
from sws_python import *
from contextlib import contextmanager

@contextmanager
def undoable(message):
    RPR_Undo_BeginBlock2(0)
    try:
        yield
    finally:
        RPR_Undo_EndBlock2(0, message, -1)

@contextmanager
def Free_MIDI_Take():
    try:
        yield
    finally:
        FNG_FreeMidiTake(FNG_Take)       

def Insert():
    if RPR_GetToggleCommandState(1007):
        start = RPR_MIDI_GetPPQPosFromProjTime(take, pp)
    else:
        start = RPR_MIDI_GetPPQPosFromProjTime(take, RPR_GetCursorPosition())
    newnote = FNG_AddMidiNote(FNG_Take)
    FNG_SetMidiNoteIntProperty(newnote, "CHANNEL", 1)
    FNG_SetMidiNoteIntProperty(newnote, "VELOCITY", 96)
    FNG_SetMidiNoteIntProperty(newnote, "SELECTED", 0)
    FNG_SetMidiNoteIntProperty(newnote, "LENGTH", 480)
    FNG_SetMidiNoteIntProperty(newnote, "PITCH", 24)
    FNG_SetMidiNoteIntProperty(newnote, "POSITION", int(start))

pp = RPR_GetPlayPosition()
with undoable("Insert note at play or edit cursor"): 
    take = RPR_MIDIEditor_GetTake(RPR_MIDIEditor_GetActive())
    FNG_Take = FNG_AllocMidiTake(take)
    with Free_MIDI_Take():
        Insert()


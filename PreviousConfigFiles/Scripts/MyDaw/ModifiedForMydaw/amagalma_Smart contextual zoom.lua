-- @description amagalma_Smart contextual zoom
-- @author amagalma
-- @version 1.53
-- @link https://forum.cockos.com/showthread.php?t=215575
-- @about
--  # Toggles zoom to objects under mouse (if 0 or 1 is selected), or to selected objects (if 2+ are selected)
--  # Can zoom to tracks, items, envelopes, regions or time selection
--  # Mode is stored in project external state, so zooming out can be resumed even after loading a saved project
--  # Does not create unnecessary undo points
--  # Undo points are created only when (un)hiding Master Track, which is unavoidable
--  # Needs js_ReaScriptAPI extension and offers to install it if not present
-- @changelog
--  # Behavior change: When zoomed to tracks, zooming to items zooms only horizontally, so when zooming out you don't loose previous track zoom
--  # New: when run over empty TCP area, it fits vertically all (as many as possible) tracks into view (no toggle action)
--  # Various optimizations

--------------------------------------------------------------------------------

function msg(m)
  reaper.ShowConsoleMsg(tostring(m) .. "\n")
  
end



function is_soloed()
local tracks = reaper.CountTracks()
if tracks == 0 then  return end
for i = 0, tracks-1 do 
if reaper.GetMediaTrackInfo_Value(reaper.GetTrack(0, i), 'I_SOLO') > 0  then
return true, reaper.GetTrack(0, i)  
end
end
end


cursor_context = reaper.GetCursorContext()
_, istimesel = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 ) 







if not reaper.APIExists( "JS_Window_FindChildByID" ) then
  local msg = [[The js_ReaScriptAPI extension is needed for this script to run.
  
Do you want to install it now?

The ReaPack package browser will open. Make sure the API is installed by
checking there are no parentheses around the version.
If there are, please right-click and install.
(You will need to restart Reaper for the installation to take effect)]]

  local answer = reaper.MB( msg, "Install js_ReaScriptAPI extension?", 4 )
  if answer == 6 then
    local url = [[https://raw.githubusercontent.com/ReaTeam/Extensions/master/index.xml]]
    reaper.ReaPack_AddSetRepository( "ReaTeam Extensions", url, true, 2 )
    reaper.ReaPack_ProcessQueue( true )
    reaper.ReaPack_BrowsePackages('js_ReascriptAPI')
    return
  else
    return  
  end
else
  local js_vers = reaper.JS_ReaScriptAPI_Version()
  if js_vers < 0.961 then
    reaper.MB( "You need at least v.0.961 to run this script. Please, update.", "Old JS_ReaScriptAPI version detected", 0 )
    reaper.ReaPack_BrowsePackages('js_ReascriptAPI')
  end
end

local reaper = reaper
local abs = math.abs
local defheightenv = {} -- stored here are envelope lanes with default height (height = 0)
local defaultheight = 24 + 12*reaper.SNM_GetIntConfigVar("defvzoom", -1)
local trackview = reaper.JS_Window_FindChildByID( reaper.GetMainHwnd(), 1000)
local _, left, top, right, bottom = reaper.JS_Window_GetClientRect( trackview )
local arrange_height = bottom - top
local arrange_width = right - left
local master = reaper.GetMasterTrack( 0 )
local mastervis = reaper.GetMasterTrackVisibility()
local mastersel = reaper.IsTrackSelected( master ) and 1 or 0
local masterguid = reaper.GetTrackGUID( master )
-- Get details for what is under mouse cursor
local window, segment, details = reaper.BR_GetMouseCursorContext()





istrack,_=  is_soloed() 



if istrack == true  then 
_, mouseTrack =  is_soloed() 


else 
mouseTrack =  reaper.GetSelectedTrack( 0, 0 )

mouseItem =  reaper.GetSelectedMediaItem(0,0) 

if mouseTrack == nil and mouseItem then  
mouseTrack = reaper.GetMediaItem_Track(mouseItem )
end



end 

if mouseTrack ==nil then return end
	


local mousePos = reaper.BR_GetMouseCursorContext_Position()
local mouseEnvelope =  reaper.GetSelectedEnvelope(0)
-- Get time selection and if mouse is inside
local overTimeSel, tExists = false, false
local tStart, tEnd = reaper.GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 )
if tStart ~= tEnd then
  overTimeSel = mousePos >= tStart and mousePos <= tEnd
  tExists = true
end


----------------

local function GetStates()
  local _, savedTCPView = reaper.GetProjExtState( 0, "Smart Zoom", "SavedTCPView" )
  local _, v_scroll = reaper.GetProjExtState( 0, "Smart Zoom", "V_Scroll" )
  local _, arrange = reaper.GetProjExtState( 0, "Smart Zoom", "SavedArrangeView" )
  local _, hType = reaper.GetProjExtState( 0, "Smart Zoom", "hType" )
  local _, vType = reaper.GetProjExtState( 0, "Smart Zoom", "vType" )
  local _, env_scroll = reaper.GetProjExtState( 0, "Smart Zoom", "Env_Scroll" )
  return hType, vType, arrange, savedTCPView, v_scroll, env_scroll
end

----------------


----------------

local function ok(str)
  -- return false if string non-existent
  if str == "" or not str then
    return false
  else
    return true
  end
end

----------------

function CenterMaximizedPanelinTCP()
  local hWnd_array = reaper.new_array({}, 100)
  reaper.JS_Window_ArrayAllChild( reaper.GetMainHwnd(), hWnd_array )
  local windows = hWnd_array.table()
  local cnt = 0
  local pixels = 0
  for i = 1, #windows do
    local hwnd = reaper.JS_Window_HandleFromAddress(windows[i])
    if reaper.JS_Window_GetClassName( hwnd ) == "REAPERVirtWndDlgHost" 
    and reaper.JS_Window_GetTitle( hwnd ) == ""
    and reaper.JS_Window_IsVisible( hwnd )
    then
      local _, left, top, right, bottom = reaper.JS_Window_GetClientRect( hwnd )
      local height = bottom - top
      local parent = reaper.JS_Window_GetParent( hwnd )
      local _, _, parentpos = reaper.JS_Window_GetClientRect( parent )
      local position = top - parentpos
      if arrange_height - height < 60 and position > -(arrange_height*0.499) and position < (arrange_height*0.499) then
        pixels = position
        break
      end
    end
  end
  local _, position = reaper.JS_Window_GetScrollInfo( trackview, "v" )
  reaper.JS_Window_SetScrollPos( trackview, "v", position + pixels )
end

----------------

local function FitAllTracksIntoView()
  local unsel_tr = {}
  local c = 0
  local tr_cnt = reaper.CSurf_NumTracks( false )
  for i = 0, tr_cnt do
    local track = reaper.CSurf_TrackFromID( i, false )
    if not reaper.IsTrackSelected( track ) then
      c = c + 1
      unsel_tr[c] = track
    end
  end
  -- select all tracks (unselected ones)
  for i = 1, #unsel_tr do
    reaper.SetTrackSelected( unsel_tr[i], true )
  end
  -- SWS: Vertical zoom to selected tracks
  reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_VZOOMFIT'), 0)
  -- Restore initial track selection
  for i = 1, #unsel_tr do
    reaper.SetTrackSelected( unsel_tr[i], false )
  end
end

----------------

local function GetTrackEnvID(env) -- in: track_envelope | out: ID as a string
  local _, envname = reaper.GetEnvelopeName( env, "" )
  return reaper.GetTrackGUID(reaper.Envelope_GetParentTrack(env)) .. envname
end

----------------

local function GetTrackEnvFromID(ID) -- in: ID string | out: track_envelope
  local guid, envname = ID:match("(%b{})(.+)")
  return reaper.GetTrackEnvelopeByName(reaper.BR_GetMediaTrackByGUID(0,guid ),envname)
end

----------------

local function GetSelectedTracksinTCP(forcemouseTrack)
  local t = {}
  -- if master selected and visible then count it
  local masterselvis = ((mastersel == 1) and (mastervis & 1 == 1)) and 1 or 0
  local cnt = masterselvis
  local seltracks_cnt = reaper.CountSelectedTracks( 0 )
  if seltracks_cnt + masterselvis > 1 and forcemouseTrack ~= 1 then
    for i = -1, seltracks_cnt - 1 do
      if i ~= -1 then -- reserve -1 for master
        -- tracks must be visible in order to be considered as selected
        local track = reaper.GetSelectedTrack(0, i)
        if reaper.IsTrackVisible( track, false ) then
          local guid = reaper.GetTrackGUID( track )
          t[guid] = track
          cnt = cnt + 1
        end
      else -- it's the master track
        if mastersel == 1 and mastervis & 1 == 1 then
          t[masterguid] = master
        end
      end
    end
   t.cnt = cnt
    if t.cnt == 0 then
      local guid = reaper.GetTrackGUID( mouseTrack )
      t[guid] = mouseTrack
      t.cnt = 1
    end
  else
    local guid = reaper.GetTrackGUID( mouseTrack )
    t[guid] = mouseTrack
    t.cnt = 1
  end
  return t
end

----------------

local function GetSoloedTracksinTCP(forcemouseTrack)
  local t = {}
  -- if master selected and visible then count it
  local masterselvis = ((mastersel == 1) and (mastervis & 1 == 1)) and 1 or 0
  local cnt = masterselvis
  local seltracks_cnt = reaper.CountTracks( 0 )
  if seltracks_cnt + masterselvis > 1 and forcemouseTrack ~= 1 then
    for i = -1, seltracks_cnt - 1 do
      if i ~= -1 then -- reserve -1 for master
        -- tracks must be visible in order to be considered as selected
        local track = reaper.GetTrack(0, i)
        if reaper.IsTrackVisible( track, false ) and reaper.GetMediaTrackInfo_Value(track, 'I_SOLO') > 0 then
          local guid = reaper.GetTrackGUID( track )
          t[guid] = track
          cnt = cnt + 1
        end
      else -- it's the master track
        if mastersel == 1 and mastervis & 1 == 1 then
          t[masterguid] = master
        end
      end
    end
    
	t.cnt = cnt
    if t.cnt == 0 then
      local guid = reaper.GetTrackGUID( mouseTrack )
      t[guid] = mouseTrack
      t.cnt = 1
    end
  else
    local guid = reaper.GetTrackGUID( mouseTrack )
    t[guid] = mouseTrack
    t.cnt = 1
  end
  return t
end







local function StoreVertical()
  local _, v_scroll = reaper.JS_Window_GetScrollInfo( trackview, "v" )
  local track_data = {}
  local track_cnt = reaper.CountTracks( 0 )
  for i = -1, track_cnt - 1 do
    local tr, guid, vis
    if i ~= -1 then
      tr = reaper.GetTrack( 0, i )
      guid = reaper.GetTrackGUID( tr )
      vis = reaper.GetMediaTrackInfo_Value( tr, "B_SHOWINTCP" )
    else -- is master track
      tr = master
      guid = masterguid
      vis = mastervis & 1
    end
    local height = reaper.GetMediaTrackInfo_Value( tr, "I_HEIGHTOVERRIDE" )
    local env_cnt = reaper.CountTrackEnvelopes( tr )
    local trackinfo = string.format("%sh%dv%de%d", guid, height, vis, env_cnt)
    local envelopes = {}
    if env_cnt > 0 then
      for j = 0, env_cnt-1 do
        local envelope = reaper.GetTrackEnvelope( tr, j )
        local _, name = reaper.GetEnvelopeName( envelope, "" )
        local BR_Envelope = reaper.BR_EnvAlloc( envelope, true )
        local _, visible, _, _, laneHeight = reaper.BR_EnvGetProperties( BR_Envelope )
        reaper.BR_EnvFree( BR_Envelope, false )
        -- Double Dagger ‡ , Alt + 0135 -> envelopes separator
        envelopes[j+1] = string.format("%qh%dv%d‡", name, laneHeight, visible and 1 or 0)
      end
      envelopes = table.concat(envelopes)
    else
      envelopes = "nil"
    end
    -- Broken bar ¦ , Alt + 0166 -> tracks separator
    track_data[i+2] = trackinfo .. envelopes .. "¦"
  end
  track_data = table.concat(track_data)
  -- store data in project
  reaper.SetProjExtState( 0, "Smart Zoom", "SavedTCPView", track_data)
  reaper.SetProjExtState( 0, "Smart Zoom", "V_Scroll", v_scroll)
end

----------------

local function RestoreVertical(SavedTCPView)
  local cnt = 0
  for info in SavedTCPView:gmatch("(.-)¦") do
    cnt = cnt + 1
    local guid, height, visible, envelopes, env_info = info:match("(%b{})h(%d+)v(%d+)e(%d+)(.+)")
    local track = cnt ~= 1 and reaper.BR_GetMediaTrackByGUID( 0, guid ) or master
    if track then
      if track ~= master then
        reaper.SetMediaTrackInfo_Value( track, "B_SHOWINTCP", tonumber(visible) )
      else -- is master
        local mastervisN
        if visible == "1" then
          if mastervis == 0 or mastervis == 2 then
            mastervisN = mastervis + 1
          else
            mastervisN = mastervis
          end
        elseif visible == "0" then
          if mastervis == 1 or mastervis == 3 then
            mastervisN = mastervis - 1
          else
            mastervisN = mastervis
          end
        end
        reaper.SetMasterTrackVisibility( mastervisN )
      end
      reaper.SetMediaTrackInfo_Value( track, "I_HEIGHTOVERRIDE", tonumber(height) )
      if envinfo ~= "nil" then
        for i in env_info:gmatch('(.-)‡') do
          local name, env_h, env_v = i:match('"(.-)"h(%d+)v(%d+)')
          local env = reaper.GetTrackEnvelopeByName( track, name )
          if env then
            local _, chunk = reaper.GetEnvelopeStateChunk( env, "", false )
            chunk = string.gsub(chunk, "VIS (%d+)", "VIS " .. env_v)
            chunk = string.gsub(chunk, "LANEHEIGHT (%d+)", "LANEHEIGHT " .. env_h)
            reaper.SetEnvelopeStateChunk( env, chunk, false )
          end
        end
      end
    end
  end
  reaper.SetProjExtState( 0, "Smart Zoom", "SavedTCPView", "" )
  reaper.SetProjExtState( 0, "Smart Zoom", "V_Scroll", "")
end

----------------

local function StoreHorizontal()
  local arr_start, arr_end = reaper.GetSet_ArrangeView2( 0, 0, 0, 0)
  reaper.SetProjExtState( 0, "Smart Zoom", "SavedArrangeView", arr_start .. "-" .. arr_end )
end

----------------

local function ReStoreHorizontal()
  local ok, size = reaper.GetProjExtState( 0, "Smart Zoom", "SavedArrangeView" )
  if ok == 1 and size ~= "" then
    local arr_start, arr_end = size:match("(.+)-(.+)")
    reaper.GetSet_ArrangeView2( 0, 1, 0, 0, tonumber(arr_start) , tonumber(arr_end))
    reaper.SetProjExtState( 0, "Smart Zoom", "SavedArrangeView", "")
  end
end

----------------

local function IsArrangeSimilar(storedArrangeView)
  if storedArrangeView and storedArrangeView ~= "" then
    local old_ar_st, old_ar_en = storedArrangeView:match("(.+)-(.+)")
    old_ar_st, old_ar_en = tonumber(old_ar_st), tonumber(old_ar_en)
    local old_len = old_ar_en - old_ar_st
    local cur_ar_st, cur_ar_en = reaper.GetSet_ArrangeView2( 0, 0, 0, 0)
    local cur_len = cur_ar_en - cur_ar_st
    if abs(old_len-cur_len) < 1 and ( abs(old_ar_st-cur_ar_st) < 1 or abs(old_ar_en-cur_ar_en) < 1) then
      return true
    end
  end
  return false
end

----------------

local function GetTotalEnvLaneHeight(tracks)
  local totalheight = 0
  local totalenv_cnt = 0
  for guid, track in pairs(tracks) do
    if guid ~= "cnt" then
      local count = reaper.CountTrackEnvelopes( track )
      totalenv_cnt = totalenv_cnt + count
      if count > 0 then
        for i = 0, count-1 do
          local env = reaper.GetTrackEnvelope( track, i )
          local _, chunk = reaper.GetEnvelopeStateChunk( env, "", false )
          local height = tonumber(string.match(chunk, "LANEHEIGHT (%d+) "))
          if height == 0 then
            if not string.match(chunk, "TEMPOENVEX") then -- do not count Tempo Env
              height = defaultheight -- default track/lane height
              defheightenv[#defheightenv+1] = env
            end
          end 
          totalheight = totalheight + height
        end
      end
      if track == master then totalenv_cnt = totalenv_cnt - 1 end -- do not count Tempo Map
    end
  end
  return totalheight, totalenv_cnt
end

----------------

local function ZoomFitTracksTCP(selectedtracks)
	-- take into account the gap between the master and the normal tracks
  local y = (mastervis & 1 == 1) and ( arrange_height - 7) or arrange_height
  local totalenvheight, totalenv_cnt = GetTotalEnvLaneHeight(selectedtracks)
  local tr_height = ((y - totalenvheight - totalenv_cnt) / selectedtracks.cnt) - 1
  -- Hide unselected tracks and Fit selected tracks to TCP
  local track_cnt = reaper.CountTracks( 0 )
  local track, guid
  for i = -1, track_cnt-1 do
	
    if i ~= -1 then
      track = reaper.GetTrack( 0, i )
      guid = reaper.GetTrackGUID( track )
    else
      track = master
      guid = masterguid
    end
    if not selectedtracks[guid] then
		
      if track ~= master then
		reaper.SetMediaTrackInfo_Value( track, "B_SHOWINTCP", 0)
      else
        local vis = (mastervis & 1 == 1) and (mastervis - 1) or mastervis
        reaper.SetMasterTrackVisibility( vis )
      end
    else -- it's one of the stored tracks
      if track ~= master then
        reaper.SetMediaTrackInfo_Value( track, "B_SHOWINTCP", 1)
      else
        local vis = (mastervis & 1 == 0) and (mastervis + 1) or mastervis
        reaper.SetMasterTrackVisibility( vis )
      end
      reaper.SetMediaTrackInfo_Value( track, "I_HEIGHTOVERRIDE", tr_height)
    end
  end
  if #defheightenv > 0 then -- fix envelope lanes with default height
    for i = 1, #defheightenv do
      local env = reaper.BR_EnvAlloc( defheightenv[i], false )
      local act, vis, arm, inL, height, sha, _, _, _, _, fad = reaper.BR_EnvGetProperties( env )
      reaper.BR_EnvSetProperties( env, act, vis, arm, inL, defaultheight, sha, fad )
      reaper.BR_EnvFree( env, true )
    end
  end
end

----------------

local function ZoomFitSelectedItems(zoomvertical)
  local item_cnt = reaper.CountSelectedMediaItems( 0 )
  local tracks = {}
  local cnt = 0
  local min, max = reaper.GetProjectLength( 0 ), 0
  if item_cnt < 2 then
    local guid = reaper.GetTrackGUID( mouseTrack )
    tracks[guid] = mouseTrack
    tracks.cnt = 1
    min = reaper.GetMediaItemInfo_Value( mouseItem, "D_POSITION" )
    max = reaper.GetMediaItemInfo_Value( mouseItem, "D_LENGTH" ) + min
  else
    for i = 0, item_cnt-1 do
      local item = reaper.GetSelectedMediaItem( 0, i )
      local it_st = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
      local it_end = reaper.GetMediaItemInfo_Value( item, "D_LENGTH" ) + it_st
      if it_st < min then min = it_st end
      if it_end > max then max = it_end end
      local track = reaper.GetMediaItem_Track( item )
      local guid = reaper.GetTrackGUID( track )
      if not tracks[guid] then
        tracks[guid] = track
        cnt = cnt + 1
      end
    end
    tracks.cnt = cnt
  end
  local len = max - min
  local scrollbar = 18 * (len / arrange_width )
  reaper.GetSet_ArrangeView2( 0, 1, 0, 0, min - len*0.01 , max + len*0.01 + scrollbar)
  if zoomvertical then
    ZoomFitTracksTCP(tracks)
  end
end

----------------

local function ZoomToRegion(region)
  local _, _, rgnstart, rgnend = reaper.EnumProjectMarkers( region )
  local rgnlen = rgnend - rgnstart
  local scrollbar = 18 * (rgnlen / arrange_width )
  reaper.GetSet_ArrangeView2( 0, 1, 0, 0, rgnstart - rgnlen*0.01 , rgnend + rgnlen*0.01 + scrollbar)
end

---------------- TOGGLE ZOOM FUNCTIONS ----------------

local function ToggleZoomFitSelectedItems()
  local hType, vType, arrange, savedTCPView, v_scroll, env_scroll = GetStates()
  -- check if envelope zoom is active and disable
  local _, envID = reaper.GetProjExtState( 0, "Smart Zoom", "Env_ID" )
  local _, env_scroll = reaper.GetProjExtState( 0, "Smart Zoom", "Env_Scroll" )
  if envID ~= "" then -- there is active envelope zoom
    local storedEnvelope = GetTrackEnvFromID( envID )
    reaper.SetCursorContext( 2, storedEnvelope )
    reaper.Main_OnCommand(reaper.NamedCommandLookup('_WOL_SETSELENVHDEF'), 0)      
    reaper.SetProjExtState( 0, "Smart Zoom", "Env_Scroll", "")
    reaper.SetProjExtState( 0, "Smart Zoom", "Env_ID", "")
  end
  if not ok(hType) and not ok(vType) then -- no zoom active at all
    StoreVertical()
    StoreHorizontal()
    ZoomFitSelectedItems(true)
    reaper.SetProjExtState( 0, "Smart Zoom", "hType", "items")
    reaper.SetProjExtState( 0, "Smart Zoom", "vType", "items")
   
    return 0
  else -- some zoom mode is active
    if hType == "items" and vType == "items" then -- active zoom to sel items
      RestoreVertical(savedTCPView)
      ReStoreHorizontal()
      reaper.SetProjExtState( 0, "Smart Zoom", "hType", "")
      reaper.SetProjExtState( 0, "Smart Zoom", "vType", "")
      
      return v_scroll
    else
      if vType == "tracks" then -- active zoom to sel tracks
        if hType == "tr_items" then -- active zoom vert to tracks and horiz to items
          if IsArrangeSimilar(arrange) then -- exit all zoom
            RestoreVertical(savedTCPView)
            ReStoreHorizontal()
            reaper.SetProjExtState( 0, "Smart Zoom", "hType", "")
            reaper.SetProjExtState( 0, "Smart Zoom", "vType", "")
           
            return v_scroll
          else
            ReStoreHorizontal()
            reaper.SetProjExtState( 0, "Smart Zoom", "hType", "")
           
          end
        else -- no horiz active zoom
          if IsArrangeSimilar(arrange) then -- exit all zoom
            RestoreVertical(savedTCPView)
            ReStoreHorizontal()
            reaper.SetProjExtState( 0, "Smart Zoom", "hType", "")
            reaper.SetProjExtState( 0, "Smart Zoom", "vType", "")
            
            return v_scroll
          else
            StoreHorizontal()
            ZoomFitSelectedItems(false) -- zoom horizontally to selected items
            reaper.SetProjExtState( 0, "Smart Zoom", "hType", "tr_items")
           
          end
        end
      elseif ok(vType) then -- active vertical zoom to envelope
          StoreHorizontal()
          ZoomFitSelectedItems(true)
          reaper.SetProjExtState( 0, "Smart Zoom", "hType", "items")
          reaper.SetProjExtState( 0, "Smart Zoom", "vType", "items")
          
          return 0
      else -- no vertical zoom active
        StoreHorizontal()
        StoreVertical()
        ZoomFitSelectedItems(true)
        reaper.SetProjExtState( 0, "Smart Zoom", "hType", "items")
        reaper.SetProjExtState( 0, "Smart Zoom", "vType", "items")
        
        return 0
      end
    end
  end
end

----------------

local function ToggleZoomFitSelectedTracksTCP(forcemouseTrack)
  local hType, vType, arrange, savedTCPView, v_scroll, env_scroll = GetStates()
  if vType == "tracks" then -- active zoom to tracks
    if hType == "tr_items" then
      RestoreVertical(savedTCPView)
      ReStoreHorizontal()
      reaper.SetProjExtState( 0, "Smart Zoom", "hType", "")
      reaper.SetProjExtState( 0, "Smart Zoom", "vType", "")
      
      return v_scroll
    else
      RestoreVertical(savedTCPView)
      reaper.SetProjExtState( 0, "Smart Zoom", "vType", "")
      
      return v_scroll
    end
  else
    local selectedtracks = GetSelectedTracksinTCP(forcemouseTrack)
    if vType == "items" then -- active zoom to sel items
      -- count visible tracks
      local track_cnt = reaper.CountTracks( 0 )
      local vis_cnt = 0
      for i = 0, track_cnt - 1 do
        local track = reaper.GetTrack(0, i)
        if reaper.IsTrackVisible( track, false ) then
          vis_cnt = vis_cnt + 1
        end
      end
      vis_cnt = vis_cnt + mastervis
      if vis_cnt == 1 then -- only one track visible, exit from sel item zoom
        RestoreVertical(savedTCPView)
        ReStoreHorizontal()
        reaper.SetProjExtState( 0, "Smart Zoom", "hType", "")
        reaper.SetProjExtState( 0, "Smart Zoom", "vType", "")
        
        return v_scroll
      else
        
        ZoomFitTracksTCP(selectedtracks)
        return 0
      end
    elseif not ok(vType) then -- no active vertical zoom
      StoreVertical()
      ZoomFitTracksTCP(selectedtracks)
      reaper.SetProjExtState( 0, "Smart Zoom", "vType", "tracks")
     
      return 0
    end
  end 
end

----------------



local function ToggleZoomFitSoloedTracksTCP(forcemouseTrack)
  local hType, vType, arrange, savedTCPView, v_scroll, env_scroll = GetStates()
  if vType == "tracks" then -- active zoom to tracks
    if hType == "tr_items" then
      RestoreVertical(savedTCPView)
      ReStoreHorizontal()
      reaper.SetProjExtState( 0, "Smart Zoom", "hType", "")
      reaper.SetProjExtState( 0, "Smart Zoom", "vType", "")
      
      return v_scroll
    else
      RestoreVertical(savedTCPView)
      reaper.SetProjExtState( 0, "Smart Zoom", "vType", "")
      
      return v_scroll
    end
  else
    local soloedtracks = GetSoloedTracksinTCP(forcemouseTrack)
    if vType == "items" then -- active zoom to sel items
      -- count visible tracks
      local track_cnt = reaper.CountTracks( 0 )
      local vis_cnt = 0
      for i = 0, track_cnt - 1 do
        local track = reaper.GetTrack(0, i)
        if reaper.IsTrackVisible( track, false ) then
          vis_cnt = vis_cnt + 1
        end
      end
      vis_cnt = vis_cnt + mastervis
      if vis_cnt == 1 then -- only one track visible, exit from sel item zoom
        RestoreVertical(savedTCPView)
        ReStoreHorizontal()
        reaper.SetProjExtState( 0, "Smart Zoom", "hType", "")
        reaper.SetProjExtState( 0, "Smart Zoom", "vType", "")
        
        return v_scroll
      else
        
        ZoomFitTracksTCP(soloedtracks)
        return 0
      end
    elseif not ok(vType) then -- no active vertical zoom
      StoreVertical()
      ZoomFitTracksTCP(soloedtracks)
      reaper.SetProjExtState( 0, "Smart Zoom", "vType", "tracks")
     
      return 0
    end
  end 
end

----------------













----------------

local function ToggleZoomTimeSelection()
  local hType, vType, arrange, savedTCPView, v_scroll, env_scroll = GetStates()
  if tExists then
    if hType == "timesel" then -- zoom to time selection is active
      if vType == "items" then -- go back to item mode
        ReStoreHorizontal()
        reaper.SetProjExtState( 0, "Smart Zoom", "hType", "items")
        
      else -- exit zoom
        ReStoreHorizontal()
        reaper.SetProjExtState( 0, "Smart Zoom", "hType", "")
       
      end
    elseif not ok(hType) then -- no active horizontal zoom
      StoreHorizontal()
      reaper.Main_OnCommand(40031, 0) -- View: Zoom time selection
      reaper.SetProjExtState( 0, "Smart Zoom", "hType", "timesel")
      
    elseif hType == "items" or hType == "tr_items" then -- active zoom to sel items
      StoreHorizontal()
      reaper.Main_OnCommand(40031, 0) -- View: Zoom time selection
      reaper.SetProjExtState( 0, "Smart Zoom", "hType", "timesel")
      
    elseif hType == "region" then -- active zoom to region
      reaper.Main_OnCommand(40031, 0) -- View: Zoom time selection
      reaper.SetProjExtState( 0, "Smart Zoom", "hType", "timesel")
    
    end
  end
end

----------------

local function ToggleZoomSelEnvelope()
  local hType, vType, arrange, savedTCPView, v_scroll
  
  local ok, env_scroll = reaper.GetProjExtState( 0, "Smart Zoom", "Env_Scroll" )
  reaper.SetCursorContext( 2, mouseEnvelope )
  local mouseEnvID = GetTrackEnvID( mouseEnvelope )
  local _, env_scrollN = reaper.JS_Window_GetScrollInfo( trackview, "v" )
  if ok ~= 1 then -- no envelope zoom is active
    -- SWS/wol: Set selected envelope height to maximum
    reaper.Main_OnCommand(reaper.NamedCommandLookup('_WOL_SETSELENVHMAX'), 0)
    reaper.SetProjExtState( 0, "Smart Zoom", "Env_Scroll", env_scrollN)
    reaper.SetProjExtState( 0, "Smart Zoom", "Env_ID", mouseEnvID)
    
  else -- envelope zoom is active
    local same = false
    -- check if the stored envelope exists and is the same as the current mouseEnvelope
    local _, envID = reaper.GetProjExtState( 0, "Smart Zoom", "Env_ID" )
    local storedEnvelope = GetTrackEnvFromID( envID )
    if storedEnvelope == mouseEnvelope then -- it's the same : delete values
      reaper.SetProjExtState( 0, "Smart Zoom", "Env_Scroll", "")
      reaper.SetProjExtState( 0, "Smart Zoom", "Env_ID", "")
      same = true
    else -- they are different : maximize new and overwrite stored values
      reaper.Main_OnCommand(reaper.NamedCommandLookup('_WOL_SETSELENVHMAX'), 0)
      reaper.SetProjExtState( 0, "Smart Zoom", "Env_ID", mouseEnvID)
    end
    if storedEnvelope then -- exists: minimize it
      reaper.SetCursorContext( 2, storedEnvelope )
      reaper.Main_OnCommand(reaper.NamedCommandLookup('_WOL_SETSELENVHDEF'), 0)
    end
    if same then
     
      return env_scroll
    else
     
      CenterMaximizedPanelinTCP()
    end
  end
end


---------------- MAIN FUNCTION ----------------


-- SMART ZOOM TO CONTEXT








local v_scroll = false
reaper.PreventUIRefresh( 1 )



if  is_soloed() == true then   

ToggleZoomFitSoloedTracksTCP()
 


if istimesel > 0 then   ToggleZoomTimeSelection() end
 
  
else  




-- TCP track
if cursor_context == 0  then
  v_scroll = ToggleZoomFitSelectedTracksTCP()
if istimesel > 0 then   ToggleZoomTimeSelection() end
elseif cursor_context == 1   and  istimesel > 0 then
  ToggleZoomTimeSelection()

elseif cursor_context == 1 and istimesel == 0 and   reaper.CountSelectedMediaItems(0) > 0 then
  
 v_scroll = ToggleZoomFitSelectedItems()

elseif  cursor_context == 2 and  istimesel > 0 then
 
  ToggleZoomTimeSelection()
 
 
 
 
 end
reaper.PreventUIRefresh( -1 )
-- Selected envelope
-- The SWS envelope actions should not be inside an active PreventUIRefresh state
if  cursor_context == 2  then
  v_scroll = ToggleZoomSelEnvelope()
  reaper.PreventUIRefresh( 1 )
end

end

if v_scroll then
  reaper.TrackList_AdjustWindows( false )
  reaper.JS_Window_SetScrollPos( trackview, "v", tonumber(v_scroll) )
end
reaper.UpdateTimeline()
reaper.defer(function () end ) -- No Undo point creation
-- Undo points will be created when (un)hiding the Master Track. It is unavoidable
reaper.TrackList_AdjustWindows(false)
function msg(m)
  reaper.ShowConsoleMsg(tostring(m) .. "\n")
end



local function SaveSelectedItems()
  for i = 0, reaper.CountSelectedMediaItems(0)-1 do
    local it = reaper.GetSelectedMediaItem(0, i)
  reaper.ULT_SetMediaItemNote(it , "LetsGlue")
  end
end

SaveSelectedItems()



local function RestoreSelectedItems()
  reaper.SelectAllMediaItems( 0, 0 )
  for i = 0, reaper.CountMediaItems(0)-1 do
    local it = reaper.GetMediaItem(0, i)
  if reaper.ULT_GetMediaItemNote(it) == "LetsGlue" then
  reaper.SetMediaItemSelected( it, true)
 reaper.ULT_SetMediaItemNote(it , "")
  end
  end
end



function wavestune_glue()
local itemcount = reaper.CountMediaItems(0)
if itemcount ~= nil then
  for i = 1, itemcount do
   local item = reaper.GetMediaItem(0, i - 1)
    if item ~= nil  then
      if reaper.ULT_GetMediaItemNote(item) == "LetsGlue" then
	 takecount = reaper.CountTakes(item)
      for j = 1, takecount do
        take = reaper.GetTake(item, j - 1)        
        if reaper.BR_GetTakeFXCount(take) ~= 0 then
          fx_count = reaper.TakeFX_GetCount(take)
          for fx = 1, fx_count do           
            _, fx_name = reaper.TakeFX_GetFXName(take, fx-1, '')
            if string.find(fx_name,"WavesTune") then
            
            reaper.Main_OnCommand(40289, 0)----unselect all media items
            reaper.SetMediaItemSelected(item, true)
            reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_SELTRKWITEM'), 0) ----SelectOnly with items 
            reaper.Main_OnCommand(40535, 0) ----Set offline tracks with items 
            reaper.Main_OnCommand(40361, 0)   -----Apply to mono take
            reaper.Main_OnCommand(40131, 0)  -----Crop to Active take
            DelGlued()
            reaper.Main_OnCommand(40536, 0)  ----set online track fx 
            
		end
            end
          end -- for fx
        end
      end -- for
    end
  end -- for
end

end



function audio_midi_glue()
itemcountd = reaper.CountMediaItems(0)
if itemcountd ~= nil then


 for i = 1, itemcountd do
   local  item = reaper.GetMediaItem(0, i - 1)
    if item ~= nil then
	if reaper.ULT_GetMediaItemNote(item) == "LetsGlue" then 
     local take = reaper.GetActiveTake(item)
        if reaper.TakeIsMIDI(take)== true then midihere=1    end
       if reaper.TakeIsMIDI(take)== false then audiohere=1    end
      end -- for
    end
  end -- for
end
  
if midihere==1 and audiohere==1 then 



itemcount = reaper.CountMediaItems(0)
if itemcount ~= nil then
for i = 1, itemcount do
   local  item = reaper.GetMediaItem(0, i - 1)
    if item ~= nil then
	if reaper.ULT_GetMediaItemNote(item) == "LetsGlue" then 
      local takecount = reaper.CountTakes(item)
      for j = 1, takecount do
       local  take = reaper.GetTake(item, j - 1)
        if reaper.TakeIsMIDI(take)== true then 
       
       
       reaper.Main_OnCommand(40289, 0) ----Unslelct all
       reaper.SetMediaItemSelected(item, true)
       reaper.Main_OnCommand(40209, 0)  ----apply
       reaper.Main_OnCommand(40131, 0) -----crop to active take
        
        
        end
      end
      end -- for
    end
  end -- for
 end
 end

end




function DelGlued()
local o=0;local c=reaper.CountSelectedMediaItems(o)
local e=reaper.GetProjectLength(o)
local m='kawa MAIN Delete "Glued" Name'local r=200
local function l(e)local a=true
local t=reaper.CountSelectedMediaItems(o)
if(t>e)then reaper.ShowMessageBox("over "..tostring(e).." clip num .\nstop process","stop.",0)a=false
end return a end if(l(r)==false)then return end local function d(e)local t=reaper.CountSelectedMediaItems(e)
local d=reaper.GetProjectLength(e)
local n={}local a={}local r=0
while(r<t)do local l=reaper.GetSelectedMediaItem(e,r)
local t=reaper.GetMediaItemTrack(l)
local e=reaper.GetMediaTrackInfo_Value(t,"IP_TRACKNUMBER")
if(a[e]==nil)then a[e]={}local r=reaper.CountTrackMediaItems(t)
local l=0
while(l<r)do local r=reaper.GetTrackMediaItem(t,l)local o=reaper.GetMediaItemInfo_Value(r,"D_POSITION")local n=reaper.GetMediaItemInfo_Value(r,"D_LENGTH")local t={mediaItem=r,startTime=o,length=n,endTime=o+n,mediaItemIdx=reaper.GetMediaItemInfo_Value(r,"IP_ITEMNUMBER"),trackId=e,mediaTrack=t}
table.insert(a[e],t)
l=l+1
end table.sort(a[e],function(a,e)return(a.startTime>e.startTime)
end)
end local i=reaper.GetMediaItemInfo_Value(l,"D_POSITION")local o=reaper.GetMediaItemInfo_Value(l,"D_LENGTH")local t={mediaItem=l,startTime=i,length=o,endTime=i+o,mediaItemIdx=reaper.GetMediaItemInfo_Value(l,"IP_ITEMNUMBER"),trackId=e,mediaTrack=t,nextItemStartTime=nil,nextMediaItem=nil}
local o=d
local l=nil for a,e in ipairs(a[e])do if(e.mediaItemIdx==t.mediaItemIdx)then t.nextItemStartTime=o
t.nextMediaItem=l
end o=e.startTime
l=e
end if(n[e]==nil)then n[e]={}end table.insert(n[e],t)
r=r+1
end return a,n end function string:split(e)local a,e=e or":",{}local a=string.format("([^%s]+)",a)self:gsub(a,function(a)e[#e+1]=a end)return e end if(c>0)then reaper.Undo_BeginBlock()
local a,e=d(o)for a,e in pairs(e)do for a,e in ipairs(e)do local l=e.mediaItem local a=reaper.GetTake(l,reaper.GetMediaItemInfo_Value(l,"I_CURTAKE"))if(a~=nil)then 
local l,t=reaper.GetSetMediaItemTakeInfo_String(a,"P_NAME","",false)local e=t e=string.match(e,"(.*)%.")or e e=string.match(e,"(.*)-glued")or e e=string.match(e,"(.*)render") or e l,t=reaper.GetSetMediaItemTakeInfo_String(a,"P_NAME",e,true)else local a,e=reaper.GetItemStateChunk(l,"",false)
local t=e:split("\n")
for a,e in ipairs(t)do if(string.match(e,"^<NOTES"))then local e=0
a=a+1
while(string.match(t[a],"^|"))do if(e>100 or a>#t)then break
end e=e+1
local e=t[a]e=string.gsub(t[a],"|","")or e e=string.match(e,"(.*)%.")or e e=string.match(e,"(.*)-glued") or e e=string.match(e,"(.*)render") or e t[a]="|"..e
a=a+1
end end end local e=""
for t,a in ipairs(t)do e=e..a.."\n"
end reaper.SetItemStateChunk(l,e,false)
end end end reaper.Undo_EndBlock(m,-1)
reaper.UpdateArrange()
end
end





function JustGlue()



focus = reaper.GetCursorContext() 


if focus == 1 then
reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)



wavestune_glue()

audio_midi_glue()


RestoreSelectedItems()

reaper.Main_OnCommand(40644, 0)  ---Item: Implode items across tracks into items on one track
reaper.Main_OnCommand(41588, 0) ----Item: Glue items
DelGlued()
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Glue', -1)

elseif focus == 2 then
reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
reaper.Main_OnCommand(42089, 0)-----Envelope: Glue automation items
DelGlued()   
reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Glue', -1)
end


end


JustGlue()
  

  
  

  
  
  
  
 
 
 
 
 
 
 
 
 
  
  
  
  
  
  









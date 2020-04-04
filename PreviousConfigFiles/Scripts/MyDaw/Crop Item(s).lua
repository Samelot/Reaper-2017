function DelGlued()
local o=0;local c=reaper.CountSelectedMediaItems(o);
local e=reaper.GetProjectLength(o);local m='kawa MAIN Delete "Glued" Name'
local r=200;
local function l(e)
local a=true;
local t=reaper.CountSelectedMediaItems(o);
if(t>e)then reaper.ShowMessageBox("over "..tostring(e).." clip num .\nstop process","stop.",0)a=false;end return a end 
if(l(r)==false)then return end 
local function d(e)
local t=reaper.CountSelectedMediaItems(e);
local d=reaper.GetProjectLength(e);
local n={}local a={}local r=0;
while(r<t)do 
local l=reaper.GetSelectedMediaItem(e,r);
local t=reaper.GetMediaItemTrack(l);
local e=reaper.GetMediaTrackInfo_Value(t,"IP_TRACKNUMBER");if(a[e]==nil)then 
a[e]={}local r=reaper.CountTrackMediaItems(t);local l=0;while(l<r)do 
local r=reaper.GetTrackMediaItem(t,l)
local o=reaper.GetMediaItemInfo_Value(r,"D_POSITION")
local n=reaper.GetMediaItemInfo_Value(r,"D_LENGTH")
local t={mediaItem=r,startTime=o,length=n,endTime=o+n,mediaItemIdx=reaper.GetMediaItemInfo_Value(r,"IP_ITEMNUMBER"),trackId=e,mediaTrack=t};table.insert(a[e],t);l=l+1;end
table.sort(a[e],function(a,e)return(a.startTime>e.startTime);end);end 
local i=reaper.GetMediaItemInfo_Value(l,"D_POSITION")
local o=reaper.GetMediaItemInfo_Value(l,"D_LENGTH")
local t={mediaItem=l,startTime=i,length=o,endTime=i+o,mediaItemIdx=reaper.GetMediaItemInfo_Value(l,"IP_ITEMNUMBER"),trackId=e,mediaTrack=t,nextItemStartTime=nil,nextMediaItem=nil};
local o=d;local l=nil for a,e in ipairs(a[e])do if(e.mediaItemIdx==t.mediaItemIdx)then t.nextItemStartTime=o;t.nextMediaItem=l;end o=e.startTime;l=e;end if(n[e]==nil)then n[e]={}end
table.insert(n[e],t);r=r+1;end return a,n end function string:split(e)local a,e=e or":",{}local a=string.format("([^%s]+)",a)self:gsub(a,function(a)e[#e+1]=a end)return e end 
if(c>0)then reaper.Undo_BeginBlock();
local a,e=d(o)for a,e in pairs(e)do for a,e in ipairs(e)do 
local l=e.mediaItem local a=reaper.GetTake(l,reaper.GetMediaItemInfo_Value(l,"I_CURTAKE"))if(a~=nil)then 
local l,t=reaper.GetSetMediaItemTakeInfo_String(a,"P_NAME","",false)local e=t e=string.match(e,"(.*)%.")or e e=string.match(e,"(.*)-glued")or e l,t=reaper.GetSetMediaItemTakeInfo_String(a,"P_NAME",e,true)
else local a,e=reaper.GetItemStateChunk(l,"",false);local t=e:split("\n");for a,e in ipairs(t)do if(string.match(e,"^<NOTES"))then local e=0;a=a+1;while(string.match(t[a],"^|"))do if(e>100 or a>#t)then 
break;end e=e+1;local e=t[a]e=string.gsub(t[a],"|","")or e e=string.match(e,"(.*)%.")or e e=string.match(e,"(.*)-glued")or e t[a]="|"..e;a=a+1;end end end local e="";for t,a in ipairs(t)do e=e..a.."\n";
end reaper.SetItemStateChunk(l,e,false);end end end reaper.Undo_EndBlock(m,-1);reaper.UpdateArrange();end

end







function DelRender()
local o=0;local c=reaper.CountSelectedMediaItems(o);
local e=reaper.GetProjectLength(o);local m='kawa MAIN Delete "Glued" Name'
local r=200;
local function l(e)
local a=true;
local t=reaper.CountSelectedMediaItems(o);
if(t>e)then reaper.ShowMessageBox("over "..tostring(e).." clip num .\nstop process","stop.",0)a=false;end return a end 
if(l(r)==false)then return end 
local function d(e)
local t=reaper.CountSelectedMediaItems(e);
local d=reaper.GetProjectLength(e);
local n={}local a={}local r=0;
while(r<t)do 
local l=reaper.GetSelectedMediaItem(e,r);
local t=reaper.GetMediaItemTrack(l);
local e=reaper.GetMediaTrackInfo_Value(t,"IP_TRACKNUMBER");if(a[e]==nil)then 
a[e]={}local r=reaper.CountTrackMediaItems(t);local l=0;while(l<r)do 
local r=reaper.GetTrackMediaItem(t,l)
local o=reaper.GetMediaItemInfo_Value(r,"D_POSITION")
local n=reaper.GetMediaItemInfo_Value(r,"D_LENGTH")
local t={mediaItem=r,startTime=o,length=n,endTime=o+n,mediaItemIdx=reaper.GetMediaItemInfo_Value(r,"IP_ITEMNUMBER"),trackId=e,mediaTrack=t};table.insert(a[e],t);l=l+1;end
table.sort(a[e],function(a,e)return(a.startTime>e.startTime);end);end 
local i=reaper.GetMediaItemInfo_Value(l,"D_POSITION")
local o=reaper.GetMediaItemInfo_Value(l,"D_LENGTH")
local t={mediaItem=l,startTime=i,length=o,endTime=i+o,mediaItemIdx=reaper.GetMediaItemInfo_Value(l,"IP_ITEMNUMBER"),trackId=e,mediaTrack=t,nextItemStartTime=nil,nextMediaItem=nil};
local o=d;local l=nil for a,e in ipairs(a[e])do if(e.mediaItemIdx==t.mediaItemIdx)then t.nextItemStartTime=o;t.nextMediaItem=l;end o=e.startTime;l=e;end if(n[e]==nil)then n[e]={}end
table.insert(n[e],t);r=r+1;end return a,n end function string:split(e)local a,e=e or":",{}local a=string.format("([^%s]+)",a)self:gsub(a,function(a)e[#e+1]=a end)return e end 
if(c>0)then reaper.Undo_BeginBlock();
local a,e=d(o)for a,e in pairs(e)do for a,e in ipairs(e)do 
local l=e.mediaItem local a=reaper.GetTake(l,reaper.GetMediaItemInfo_Value(l,"I_CURTAKE"))if(a~=nil)then 
local l,t=reaper.GetSetMediaItemTakeInfo_String(a,"P_NAME","",false)local e=t e=string.match(e,"(.*)%.")or e e=string.match(e,"(.*) render")or e l,t=reaper.GetSetMediaItemTakeInfo_String(a,"P_NAME",e,true)
else local a,e=reaper.GetItemStateChunk(l,"",false);local t=e:split("\n");for a,e in ipairs(t)do if(string.match(e,"^<NOTES"))then local e=0;a=a+1;while(string.match(t[a],"^|"))do if(e>100 or a>#t)then 
break;end e=e+1;local e=t[a]e=string.gsub(t[a],"|","")or e e=string.match(e,"(.*)%.")or e e=string.match(e,"(.*) render")or e t[a]="|"..e;a=a+1;end end end local e="";for t,a in ipairs(t)do e=e..a.."\n";
end reaper.SetItemStateChunk(l,e,false);end end end reaper.Undo_EndBlock(m,-1);reaper.UpdateArrange();end




end










function nothing()
end

items = reaper.CountSelectedMediaItems(0)
if items > 0 then
  dump = 1
  if dump == 1 then 
  
  
  reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(1)
    
    for i = 0, items-1 do
      it = reaper.GetSelectedMediaItem(0, i)
	  	  
	  take = reaper.GetActiveTake( it)
	  	  
        midi = reaper.TakeIsMIDI(take)
        if midi == true then
         
         
         reaper.Main_OnCommand(41588, 0)  ---Glue  
                      DelGlued() 
                      
                 
                 
                 
                  elseif midi == false then
                
                
                
                
                     reaper.Main_OnCommand(41999, 0) --Render as new take
                       
                       DelRender()
                       
                      reaper.Main_OnCommand(40131, 0) --Crop
                                    
                   
                       
        
      end
     
    end

   reaper.PreventUIRefresh(-1); reaper.Undo_EndBlock('Crop Item(s)', -1)
  else
    reaper.defer(nothing)
  end
else
  reaper.defer(nothing)
end



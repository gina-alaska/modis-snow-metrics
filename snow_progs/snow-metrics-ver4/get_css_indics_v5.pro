pro get_css_indics_v5, newcv, fract,albed, quali,bname,first_idx, last_idx, css_snow_day ,gapday, num_css,stidx, edidx, totnumsnow,totnosnow,totcloud

;inputs:  newcv, fract,albed,quali,bname,first_idx, last_idx,css_snow_day,gapday
;outputs: num_css, stidx,edidx
;num_css--number of css segments, stidx,edidx are start and end indices of the longest css segments 
;jzhu, 2012/6/8, get-css_indics_v4.pro is modified from get_css_indics_v2.pro. It identify multiple segements of css
;in the time series. save the longest css, and also report how many segements. A css segment is defined as 14 days css days.
;jzhu,2012/6/12, modified from get_css_indics_v2.pro, css_snow_day is the number of days that used to determine css segment.typical value=14 days
; gapday is used to determine the segment.Typical value is 2 days. If there are consecutive gapday days of no-snow or lake orocea day, this is a broke between segments.  
;snow=200, ocean=39,lake=37
;
;jzhu, modified from get_css_indics_v4. think CSS must be exeact snow days.

;
;---initilize the first_css_idx and last_css_idx with -1
;snow_num=css_ed-css_st + 1

totnumsnow=0 ; initialize

;----- conditions to determine css segment
snow_num=css_snow_day ; typical=14 consecutive "snow" day as a css segment
gapidx=gapday  ; typical=2, consecutive "no-snow" days

num_css=0  ; count the number of css segements
stidx  = -1 ; store stidx og the longest css segment
edidx  = -1  ; store edidx of the longest css segment

num=n_elements(newcv)

;---check if first_idx, css_st,  css_ed, last_idx are in increasing order
;if (first_idx LE css_st and css_st LE css_ed and css_ed LE last_idx ) EQ 0 then begin
;return
;endif



;--- check if there is un-breaked period between css_st and css_ed, if not, return first_css_idx=-1 and last_css_idx=-1
;idx_nosnow = where(newcv(css_st:css_ed) EQ 25,no_snow_cnt)
;if no_snow_cnt GT  then begin   ; do not get reasonable css first and last indics
;return
;endif

;--- from first_idx to num-1,look for first_css_idx, otherwise, set first_css_idx=first_idx



;---- define a array to hold segment sequence number and start and end indics
;--initial define three arries to store segment info, it will be re-define according to the number of no-snow days
segno    = intarr(1)
segstidx=  intarr(1)
segedidx=  intarr(1)

;seginfo={segno:segno,segstidx:segstidx,segedidx:segedidx}

;---looking for the suitable snowpoints, must be snow, fraction of snow >=50%, and albedo >=30%

;idx=where(newcv(first_idx:last_idx) EQ 200 and $
;          fract(first_idx:last_idx) GE 50  and $
;          albed(first_idx:last_idx) GE 30, cnt)

idx=where(newcv(first_idx:last_idx) EQ 200 and $
          fract(first_idx:last_idx) GE 50, cnt)


if cnt GT 0 then begin ;<1> found possible css

;assume first_idx+idx(0) to first_idx+idx( n_elements(idx)-1 ) points of newcv only have no-snow (no-snow, lake,ocean) or snow (rest of types)
;go one by one check

idx_css_ck_st=first_idx+idx(0)

idx_css_ck_ed=first_idx+idx( n_elements(idx)-1 )


if idx_css_ck_st EQ 0 then begin

num_of_snow1=0

endif else begin 
tmpidx=where(newcv(0:idx_css_ck_st-1) EQ 200,num_of_snow1 )
endelse

if idx_css_ck_ed EQ num-1 then begin

num_of_snow3 =0

endif else begin

tmpidx3=where( newcv(idx_css_ck_ed+1:num-1 ) EQ 200, num_of_snow3 )

endelse

;after cloud filtering, there are still cloud days in time series,
;v5 treats these cloud days as no snow days for dtermining CSS purpose.

idx_nosnow = where( newcv(idx_css_ck_st: idx_css_ck_ed) EQ 25 or $
                    newcv(idx_css_ck_st: idx_css_ck_ed) EQ 37 or $
                    newcv(idx_css_ck_st: idx_css_ck_ed) EQ 39 or $
                    newcv(idx_css_ck_st: idx_css_ck_ed) EQ 50, cnt_nosnow )

num_of_snow2= idx_css_ck_ed-idx_css_ck_st + 1 -cnt_nosnow 

totnumsnow=num_of_snow1 + num_of_snow2 + num_of_snow3

if cnt_nosnow LT gapidx then begin ; <15> only number of no-snow days is greater or equal to gapidx, check segment

   segno[0]=1
   segstidx[0]=idx_css_ck_st
   segedidx[0]=idx_css_ck_ed
   
endif else begin ;<15> more than gapidx of no-snow days, check multiple css segments

;---define the arries to store segment information


 
segno    = intarr(cnt_nosnow)
segstidx=  intarr(cnt_nosnow)
segedidx=  intarr(cnt_nosnow)

;---check no-snow point to determine how to divide the css segements

k=0  ; star fromt the first no-snow idx

m=0 ; segment sequnce no, start from 0

found_hd=0; find_header_flag, 0= not found, 1=found

found_ed=0;

finish_flg=0 ; 0--not finish process time series, 1- finish processing time series

while k LE cnt_nosnow-1 and finish_flg EQ 0 do begin  ;<2>

if found_hd EQ 0 then begin ;<10> , try to find header

;check m segment header

  if m EQ 0 then begin ; <3> find the first segment heder
  
  segheader=idx_css_ck_st
  
  found_hd=1

  goto, lb_found
  
  endif else begin ;<3> try to find the segment m (m >1)header
  
  
  ;check if k+1 exists
  
  if k+1 GT cnt_nosnow-1 then begin ; <16> the last segment 
  
  found_hd=1
  
  segheader=idx_css_ck_st+idx_nosnow(k)+1
  
  found_ed=1
  
  segender =idx_css_ck_ed
  
  finish_flg=1
  
  k=k+1
  
  goto,lb_found
  
  
  endif ;<16> 
  
  
if idx_nosnow(k)+1 LT idx_nosnow(k+1) then begin ;<11> found header
  
     segheader=idx_css_ck_st+idx_nosnow(k)+1
     
     found_hd=1

     k=k+1

     goto, lb_found
            
endif else begin  ;<11>
      
   k=k+1 

endelse ;<11>
  
  
endelse  ;<3>
 

endif else begin ;<10>, found header, try to find the ender  


;check m segment ender 

 
if k+gapidx GT cnt_nosnow-1 then begin ;<20>
 
 found_ed=1
 
 segender=idx_css_ck_ed
 
 finish_flg=1
 
 goto,lb_found
 
 endif else begin ;<20>
 
;---- compare k with k+gapidx

    if idx_nosnow(k)+gapidx EQ idx_nosnow(k+gapidx) then begin ;<4>, found segemnt m ender
  
    found_ed=1

    segender=idx_css_ck_st+idx_nosnow(k)-1
    
    k=k+gapidx
     
    goto,lb_found
        
    endif else begin ;<4>  
 
    k=k+1
 
    endelse ;<4>

 endelse ;<20>
 
endelse ; <10>

lb_found:

if found_hd EQ 1 and found_ed EQ 1 then begin; <12> 

segno[m]=m+1

segstidx[m]=segheader

segedidx[m]=segender

;prepare to process the next segment

found_hd=0

found_ed=0     

m=m+1
    
endif ;<12>   

 
endwhile ; <2> next round   

 
endelse ; <15>  
  
  
;---- check how many css segment and the stidx and edidx of the longest css segment  

idx_css =where(segedidx-segstidx GE snow_num,num_css)
 
if num_css GT 0 then begin

idx_longest = where(segedidx-segstidx EQ max(segedidx-segstidx) )

stidx1=segstidx(idx_longest(0) )

edidx1=segedidx(idx_longest(0) )

;---- extend the longest snow cover periods both side to 1/2 of no snow days

idx_nosnow=where(newcv(0:sitdx1) EQ 25,cnt_nosnow)
if cnt_nosnow GT 0 then begin
stidx=fix(0.5*(idx_nosnow(n_elements(idx_nosnow)) +stidx1 ) )
newcv(stidx:stidx)=200
endif

idx_nosnow=where(newcv( edidx1:n_elements(newcv)-1 ) EQ 25,cnt_nosnow)
if cnt_nosnow GT 0 then begin
edidx=fix(0.5*(edidx1 + idx_nosnow(0) ) )
newcv(edidx1:edidx)=200
endif

endif else begin

num_css=0
stidx=-1
edidx=-1

endelse

;----------------------

endif else begin ;<1> no possible css

;--- no css segment

num_css=0
stidx=-1
edidx=-1

idxsnow = where(newcv EQ 200,totnumsnow)

endelse ;<1>


;--- calculate snow days, no-snow days, and cloud days

idxsnow   = where(newcv EQ 200,totnumsnow)
idxnosnow = where(newcv EQ  25,totnosnow)
idxcloud  = where(newcv EQ  50, totcloud)


return

end
 
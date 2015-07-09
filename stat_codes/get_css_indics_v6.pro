pro get_css_indics_v6, newcv, fract,albed, quali,bname,first_idx, last_idx, css_snow_day ,gapday, day_str, num_css,stidx, edidx, totnumsnow,totnosnow,totcloud,tot_css_days,longest_css_days

;inputs:  newcv, fract,albed,quali,bname,first_idx, last_idx,css_snow_day,gapday
;outputs: num_css, stidx,edidx
;num_css--number of css segments, stidx,edidx are start and end indices of the longest css segments 
;jzhu, 2012/6/8, get-css_indics_v4.pro is modified from get_css_indics_v2.pro. It identify multiple segements of css
;in the time series. save the longest css, and also report how many segements. A css segment is defined as 14 days css days.
;jzhu,2012/6/12, modified from get_css_indics_v2.pro, css_snow_day is the number of days that used to determine css segment.typical value=14 days
; gapday is used to determine the segment.Typical value is 2 days. If there are consecutive gapday days of no-snow or lake orocea day, this is a broke between segments.  
;snow=200, ocean=39,lake=37
;
;jzhu, modified from get_css_indics_v4. calcualte totsnow,totnosnow,and totcloud


totnumsnow=0 ; initialize
totnosnow=0;
totcloud=0;
totothers=0;
tot_css_days=0;
longest_css_days=0;

num_css=0  ; count the number of css segements
stidx  = -1 ; store stidx og the longest css segment
edidx  = -1  ; store edidx of the longest css segment

;----- conditions to determine css segment
snow_num=css_snow_day ; typical=14 consecutive "snow" day as a css segment
gapidx=gapday  ; typical=2, consecutive "no-snow" days
;-----------------------------

num=n_elements(newcv)

;---- define a array to hold segment sequence number and start and end indics
;
;--initial define three arries to store segment info, it will be re-define according to the number of no-snow days
segno    = intarr(1)
segstidx=  intarr(1)
segedidx=  intarr(1)

;seginfo={segno:segno,segstidx:segstidx,segedidx:segedidx}

;---looking for the possible first and last snow days, must be snow and the fraction of snow >=50%, and albedo >=30%

;idx=where(newcv(first_idx:last_idx) EQ 200 and $
;          fract(first_idx:last_idx) GE 50  and $
;          albed(first_idx:last_idx) GE 30, cnt)

idx=where(newcv(first_idx:last_idx) EQ 200 and $
          fract(first_idx:last_idx) GE 50, cnt)


if cnt GT 0 then begin ;<1> found possible css

idx_css_ck_st=first_idx+idx(0)

idx_css_ck_ed=first_idx+idx( n_elements(idx)-1 )


;if idx_css_ck_st EQ 0 then begin
;num_of_snow1=0
;endif else begin 
;tmpidx=where(newcv(0:idx_css_ck_st-1) EQ 200,num_of_snow1 )
;endelse

;if idx_css_ck_ed EQ num-1 then begin

;num_of_snow3 =0

;endif else begin

;tmpidx3=where( newcv(idx_css_ck_ed+1:num-1 ) EQ 200, num_of_snow3 )

;endelse

;after cloud filtering, there are still cloud days in time series,

idx_nosnow = where( newcv(idx_css_ck_st: idx_css_ck_ed) EQ 25 or $
                    newcv(idx_css_ck_st: idx_css_ck_ed) EQ 37 or $
                    newcv(idx_css_ck_st: idx_css_ck_ed) EQ 39, cnt_nosnow )



;num_of_snow2= idx_css_ck_ed-idx_css_ck_st + 1 -cnt_nosnow 

;totnumsnow=num_of_snow1 + num_of_snow2 + num_of_snow3

if cnt_nosnow LT gapidx then begin ; <15> only number of no-snow days is greater or equal to gapidx, check segment

   segno[0]=1
   segstidx[0]=idx_css_ck_st
   segedidx[0]=idx_css_ck_ed
   
endif else begin ;<15> more than gapidx of no-snow days, check multiple css segments

;---define the arries to store segment information


 
segno    = intarr(cnt_nosnow+1)
segstidx=  intarr(cnt_nosnow+1)
segedidx=  intarr(cnt_nosnow+1)

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
  

;---- ecach segment, may includes cloud days in the begining and/or ending,we choose to use 1/2 of the cloud days
;as the start or end days of the segment. do not re-classify the half of cloudy days into snow or no-snow.

num_seg=max(segno)

for k=0,num_seg-1 do begin

;from begin forward looking for the first snow day
idx_k_snow = where( newcv(segstidx(k):segedidx(k)) EQ 200, cnt_k_snow)
tmpstidx = fix( 0.5*( segstidx(k) +segstidx(k)+idx_k_snow(0) ) )

;--reclassify cloudy days in tmpstidx to segstidx(k) + idx_k_snow(0) into snow days
;newcv(tmpstidx:segstidx(k)+idx_k_snow(0) )= 200  

;looking for the last snow day in the end of the segment k
tmpedidx = fix( 0.5*( segstidx(k)+idx_k_snow(n_elements(idx_k_snow)-1) +segedidx(k) ) )

;---reclassify cloudy days in segstidx(k)+idx_k_snow(n_elements(idx_k_snow)-1) to tmpedidx into snow
;newcv( segstidx(k) +idx_k_snow(n_elements(idx_k_snow)-1):tmpedidx )=200

segstidx(k)=tmpstidx

segedidx(k)=tmpedidx

;if segedidx(k)-segstidx(k) GE snow_num then begin
;tot_css_days=tot_css_days +segedidx(k)-segstidx(k) + 1 
;endif

endfor
  
;---- check how many css segment,
;----total number of days of longest css,
;---- and the stidx and edidx of the longest css segment  

idx_css =where(segedidx-segstidx GE snow_num,num_css)
 
if num_css GT 0 then begin

;calcualte the tot_css_day

tot_css_days=0
for i=0,num_css-1 do begin

seg_css = dayrange(day_str,segstidx( idx_css(i) ),segedidx( idx_css(i) ) )   
;css_first=css.on_day
;css_last =css.end_day
seg_css_days=seg_css.day_range
tot_css_days=tot_css_days + seg_css_days

endfor

;----look for the longest css period, that means maximun edidx-stidx

idx_longest = where(segedidx-segstidx EQ max(segedidx-segstidx) )

stidx=segstidx(idx_longest(0) )

edidx=segedidx(idx_longest(0) )

longest_css_days=(dayrange(day_str,stidx,edidx)).day_range

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
tot_css_days=0

endelse ;<1>


;--- calculate snow days, no-snow days, and cloud days

idxsnow   = where(newcv EQ 200,totnumsnow)
idxnosnow = where(newcv EQ  25,totnosnow)
idxcloud  = where(newcv EQ  50, totcloud)


if tot_css_days LT longest_css_days then begin
  
print, 'check it, possible wrong!'

endif   

return

end
 
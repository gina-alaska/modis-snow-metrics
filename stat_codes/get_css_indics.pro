pro get_css_indics, newcv, first_idx, last_idx, stidx, edidx 

;this program uses newcv, the index of the first snow, the indec of the last snow

;---2. use newcv and albed to determin the css: css_f,css_l,css_range, days of snow, smooths fract to get smoothed_fract

;look for stidx in first half of first_idx to last_idx, 

;---- get possible first and last index of CSS

stidx=-1  ;initial values
edidx =-1

tmp=newcv(first_idx+1:last_idx-1) ;
tmp_snow=where(tmp EQ 200, tmp_snowcnt)
if tmp_snowcnt EQ 0 then begin   ; in newcv(first_idx:lastt_idx), there is no snow, return 
return
endif

if newcv(first_idx+1) EQ 200 then begin
first1=first_idx
endif else begin
first1 =first_idx+1+tmp_snow(0) 
endelse

if newcv(last_idx-1) EQ 200 then begin
last1=last_idx
endif else begin
last1  = first_idx+1+tmp_snow(n_elements(tmp_snow)-1 )
endelse

;-----
tmp=newcv(first1:last1)


tmpidx=where(tmp EQ 25, tmpcnt) ;consider the no-snow

if tmpcnt GE 16 then begin  ; <2>, if there are more than 16 days of no-snow, need break this fist1:last1 to find the true conseqitive snow period

rmax = tmpidx(0)
stidx=first1
edidx=first1 + tmpidx(0)-1

for k=1, tmpcnt-1 do begin

if tmpidx(k)-tmpidx(k-1)-1 GT rmax then begin
   rmax=tmpidx(k)-tmpidx(k-1)-1
   stidx=first1 + tmpidx(k-1)+1 
   edidx=first1 + tmpidx(k)-1
endif

endfor

if rmax LT last1 -( tmpidx(tmpcnt-1)+first1 ) then begin
 rmax= last1 -( tmpidx(tmpcnt-1)+first1 )
 stidx=first1+tmpidx(tmpcnt-1)+1
 edidx=last1
 
endif

endif else begin    ;<2>

stidx=first1
edidx=last1

endelse  ; <2>


;---- check first_idx, first1, and stidx

if stidx LT first1 or first1 LT first_idx then begin

print, 'problem, check!'

endif 

if edidx GT last1 or last1 GT last_idx then begin

print, 'problem, check!'

endif

return

end

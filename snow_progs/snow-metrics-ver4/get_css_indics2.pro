pro get_css_indics2, newcv, fract,albed, quali, first_idx, last_idx, css_st, css_ed, stidx, edidx

;get_css_indics2, newcv, fract, albed, quali, first_idx, last_idx, css_st, css_ed, stidx, edidx
;input newcv, first snow day index, last snow day index, resonable css first index, resonable css last index
;output first css index, last css index

;---initilize the first_css_idx and last_css_idx with -1

stidx  = -1
edidx  = -1

num=n_elements(newcv)

;--- check first_idx, css_st, css_ed, last_idx are in increasing order

if (first_idx LE css_st and css_st LE css_ed and css_ed LE last_idx ) EQ 0 then begin
return
endif



;--- check if there is un-breaked period between css_st and css_ed, if not, return first_css_idx=-1 and last_css_idx=-1


idx_nosnow = where(newcv(css_st:css_ed) EQ 25,no_snow_cnt)

if no_snow_cnt GT 0 then begin   ; do not get reasonable css first and last indics

return

endif

;-- if the cover = 25 , 0< fract  <=100, and this point is after and closed to the last night point (11),not lagging more than daywd,  then re-classify the point as snow.

daywd=7 ; 7 indecs (7-day window)

nightidx=where(newcv(first_idx:last_idx) EQ 11, nightcnt)

if nightcnt GT 0 then begin ;<20>

last_night_idx=first_idx + nightidx(n_elements(nightidx)-1 ) 

if last_night_idx + daywd LE last_idx then begin  ; <21> 

adj2idx=where( newcv(last_night_idx :last_night_idx + daywd ) EQ 25 $
           and fract(last_night_idx :last_night_idx + daywd ) LE 100 $
           and fract(last_night_idx :last_night_idx + daywd ) GT 0, adj2cnt)
endif else begin  ;<21>

adj2idx=where( newcv(last_night_idx :last_idx ) EQ 25 $
           and fract(last_night_idx :last_idx ) LE 100, adj2cnt)

endelse  ;<21>


if adj2cnt GT 0 then begin  ;<22>

newcv(last_night_idx+adj2idx )=200

endif  ;<22>   

endif ;<20>


;---for pints in between first_idx:last_idx with cover=25, 50<=fract<=100, and quali =0/1, re-classify this point as snow

adjidx=where( newcv(first_idx:last_idx) EQ 25 and fract(first_idx:last_idx) LE 100 $
              and fract(first_idx:last_idx) GE 50 and quali(first_idx:last_idx) LE 1, adjcnt)

if adjcnt GT 0 then begin
newcv(first_idx+adjidx)=200
endif              


      
;--- get the css_first_idx from 0:css_st, and css_last_idx from css_ed to n_elements(newcv)-1

idx1=where(newcv(first_idx:css_st) EQ 25, cnt1 )

if cnt1 GT 0 then begin

 stidx=first_idx + idx1( n_elements(idx1)-1) + 1

endif else begin

 stidx=first_idx

endelse




idx2=where(newcv(css_ed:last_idx) EQ 25, cnt2)

if cnt2 GT 0 then begin

edidx=css_ed + idx2(0)-1 

endif else begin

edidx=last_idx

endelse

return

end


 
 
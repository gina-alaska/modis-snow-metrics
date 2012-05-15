function cal_index_for_day, bname,ddd,current_yr

; bname---band name vector, ddd---days of year in string format, eg. '013', current_yr=1, current year, 
;current_yr=0, next year

yyyy=strmid(bname(0),0,4) ;
yyyyn= string(fix(yyyy)+1, format='(I4)')

if current_yr EQ 1 then begin  ; current year
;---first_idx range
;ddd='214'  ; current 8/1

date=yyyy+'-'+ddd
endif else begin
date=yyyyn+'-'+ddd
endelse

idx=where(bname GE date,cnt )
if cnt GT 0 then begin
first_idx_st = idx(0) ;
endif else begin

first_idx_st = n_elements(bname) -1
 
endelse

return, first_idx_st

end
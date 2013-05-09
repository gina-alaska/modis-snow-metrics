;find the first index of number of consequtive snow (include cloud, night, fill, saturated ) points.

function find_forward_consequtive_snow_v2,cover,fract, albed, bname, num_point

;define a default value range of the possible first day of the consequtive snow period, fist day of snow-year to 12/31 of current year 


;--- set threshold of the consecutive snow period equal to 14 days

snow_num=num_point ; consecutive snow points must be great than snow_number
yyyy=strmid(bname(0),0,4) ;
yyyyn= string(fix(yyyy)+1, format='(I4)')


;---set the range of the sos as first day of current year to 12/31 of current year
;ddd='273'
;date=yyyy+'-'+ddd
;idx=where(bname GE date)
;sos_st = idx(0) ; index of the number of consequtive snow points

sos_st=0

ddd='365'
date=yyyy+'-'+ddd
idx=where(bname GE date)
sos_ed = idx(0) ; index of the number of consequtive snow points


last_idx=idx(0)

;----initialize sos and flag

sos=sos_ed

num_tot=n_elements(cover)

found=0;   found--0, sos is not found, 1--sos is found

;---looking for the suitable snowpoints, must be snow, fraction of snow >=50%, and albedo >=30%

idx=where(cover(0:last_idx) EQ 200 and fract(0:last_idx) GE 50 and albed(0:last_idx) GE 30, cnt)

if cnt GT 0 then begin  ; <1>, have possible sos

for k=0, cnt-1 do begin   ;<2>

startpt=idx(k)

if startpt + snow_num-1 GT num_tot-1 then begin

break

endif

idxv = where(  cover(startpt:startpt+snow_num-1 ) NE 25  and   $
               cover(startpt:startpt+snow_num-1 ) NE 37  and   $
               cover(startpt:startpt+snow_num-1 ) NE 39 ,cntv, complement=idxnon )

  if cntv EQ snow_num then begin   ; <3> points from startpt to last_idx are all one of night,cloud,fill,or snow, found the sos
   sos=startpt
   found=1
   break
  endif ; <3>

endfor ;<2>

endif  ;<1>

return, sos

end

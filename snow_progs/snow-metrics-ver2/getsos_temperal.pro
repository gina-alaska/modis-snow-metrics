
function getsos_temperal, snow,bq,num_point,rate

num_tot=n_elements(snow)

last_idx=100 ; oct.1---1, next Jan,6--100

startpt=0 ; initial value
next_round=0 ; intial calue
sost=fltarr(1)
sosn=fltarr(1)

lb_again:

found=0 ; initial, not found sos

for j=next_round, last_idx do begin  ;check from Ocr.1 to DEc.31
;---looking for the first snowpoint
if snow(j) GE rate and ( bq(j) EQ 25 or bq(j) EQ 200 ) then begin  ; found the first snowpoint
  
  
  startpt = j ; possible sos point
  
   
  idx = where( (snow(startpt:startpt+num_point-1) GE rate ) and $
         (bq(startpt:startpt+num_point-1 ) EQ 11 or   $
          bq(startpt:startpt+num_point-1 ) EQ 25 or   $
          bq(startpt:startpt+num_point-1 ) EQ 50 or   $
          bq(startpt:startpt+num_point-1 ) EQ 200 ), cnt, complement=idxnon )
                                                              
  if cnt EQ num_point then begin   ; found the sos

  sost(0)=startpt
  sosn(0)=snow(startpt)
  found=1
  break
  endif else begin  ; not consecutive num_point of snow points, find the greatest index of un-consecutive point
  sz=n_elements(idxnon)
  next_round=startpt+idxnon(sz-1) + 1
  found=0
  break
  endelse

 endif

endfor

if found EQ 1 or j GE last_idx then begin

if j GE last_idx then begin

print,'can not find SOS'

endif


goto,lb_next

endif else begin

goto, lb_again

endelse

lb_next:
sos={sost:sost,sosn:sosn}

return, sos
end


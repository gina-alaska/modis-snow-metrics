
function geteos_temperal,snow,bq,num_point, rate

num_tot=n_elements(snow)
first_idx=100     ; check snow in the index range 100 to 365
startpt=num_tot-1 ; initial value
next_round=num_tot-1 ; intial calue
eost=fltarr(1)
eosn=fltarr(1)

lb_again:

found=0; initial value

for j=next_round, first_idx,-1 do begin
;---looking for the first snowpoint
  if snow(j) GE rate and ( bq(j) EQ 25 or bq(j) EQ 200 ) then begin  ; found the first snowpoint
  
  
  startpt = j ; possible sos point
  
   
  idx = where( (snow(startpt-num_point+1:startpt) GE rate ) and $
         (bq(startpt-num_point+1:startpt ) EQ 11 or   $
          bq(startpt-num_point+1:startpt ) EQ 25 or   $
          bq(startpt-num_point+1:startpt ) EQ 50 or   $
          bq(startpt-num_point+1:startpt ) EQ 200 ), cnt, complement=idxnon )
                                                              
  if cnt EQ num_point then begin   ; found the sos
  eost(0)=startpt
  eosn(0)=snow(startpt)
  found=1
  break
  endif else begin  ; not consecutive num_point of snow points, find smallest index of the un-consecutive point
  next_round = startpt-num_point+1 + idxnon(0)-1
  found=0
  break
  endelse
   
  endif

endfor

if found EQ 1 or j LE first_idx then begin

if j LE first_idx then begin

print, 'can not find EOS'

endif

goto, lb_next

endif else begin

goto, lb_again

endelse
  
lb_next:

eos={eost:eost,eosn:eosn}

return, eos

end
;find the first index of number of consequtive snow (include cloud, night, fill, saturated ) points.

function find_forward_consequtive_snow,cover,fract, albed, bname, num_point
;define a default value range  of the possible first day of the consequtive snow period, 9/30 to 12/30 of current year 
;the last day to investigate the consequtive period is 1/31 next year
num_tot=n_elements(cover)
yyyy=strmid(bname(0),0,4) ;
yyyyn= string(fix(yyyy)+1, format='(I4)')
ddd='031'
date=yyyyn+'-'+ddd
idx=where(bname GE date )
last_idx=idx(0) ; is always set as 1/30 of next year

;---the range of the sos as 9/30 to 12/31 of current year
ddd='273'
date=yyyy+'-'+ddd
idx=where(bname GE date)
sos_st = idx(0) ; index of the number of consequtive snow points

ddd='365'
date=yyyy+'-'+ddd
idx=where(bname GE date)
sos_ed = idx(0) ; index of the number of consequtive snow points
;---initial sos 12/31
sos=sos_ed

found=0;   found--0, sos is not found, 1--sos is found

;---looking for the  suitable snowpoints

idx=where(cover(0:last_idx) EQ 200 and fract(0:last_idx) GE 50 and albed(0:last_idx) GE 30, cnt)

if cnt GT 0 then begin  ; <1>, have possible sos

next_round=idx(0)-1

for k=0, cnt-1 do begin   ;<2>

if  idx(k) LT next_round then begin

  continue
  
endif
  

startpt = idx(k) ; possible sos point
  
   
  idxv = where( cover(startpt:startpt+num_point-1 ) EQ 11  or   $
               cover(startpt:startpt+num_point-1 ) EQ 50  or   $
               cover(startpt:startpt+num_point-1 ) EQ 255 or   $
               cover(startpt:startpt+num_point-1 ) EQ 200 , cntv, complement=idxnon )
                                                              
  if cntv EQ num_point then begin   ; <3>found the sos
   sos=startpt
   found=1
   break

  endif else begin ;<3>
   next_round= startpt + idxnon( n_elements(idxnon)-1 ) + 1
   if next_round GT last_idx then begin
   
    break
    
   endif 

  endelse   ; <3>

endfor ;<2>

endif  ;<1>

lb_next:


;----change sos to previous points if the previous consequtive points are cloud points

if found EQ 1 and sos GT 0 then begin ;<10>  , if sos is found, and sos GT 0, it must be snow point

idx=where(cover(0:sos-1) EQ 50, cnt )

if cnt GT 0 then begin  ;<5>

idx_begin=sos

if idx(cnt-1) + 1 EQ sos then begin ; <6>the point right before sos is cloud

;--- locate the consequtive cloud points from end to beginning of idx

for k= cnt-1, 1, -1 do begin  ;<7>

if idx(k-1) +1 EQ idx(k) then begin  ;<8>

idx_begin =idx(k-1)

endif else begin  ;<8>

break
 
endelse   ;<8>

endfor ;<7>

;--- idx_begin to idx(cnt-1) are cloud points

sos=idx_begin

endif ;<6>

endif ;<5> 

endif  ; <10>

;--make sure sos is in the range of sos_st and sos_ed

if sos LT sos_st or sos GT sos_ed then begin

sos=sos_ed 

endif

return, sos

end


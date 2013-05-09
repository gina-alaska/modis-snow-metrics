;find the number of consequtive snow points from end to begiing (backforward), get the index 
function find_backward_consequtive_snow, cover, fract,albed, bname, num_point
;the range of last point of the consequtive snow points is 1/31 next year, 5/31 next year 
num_tot=n_elements(cover)

;--- initial first_idx corresponding to current year 1/31

yyyy=strmid(bname(0),0,4) ;
yyyyn= string(fix(yyyy)+1, format='(I4)')
ddd='335'
date=yyyy+'-'+ddd
idx=where(bname GE date )
first_idx=idx(0) ; is always set as 12/1 of current year

;---eos range is 1/31 to 5/31 next year
ddd='031'
date=yyyyn+'-'+ddd
idx=where(bname GE date)
eos_st = idx(0)

ddd='151'
date=yyyyn+'-'+ddd
idx=where(bname GE date)
eos_ed = idx(0)

;---initialize eos as 90 days of next year
eos=eos_st
found=0   ; 0--not found eos, 1--found eos


;---looking for the suitable snowpoints

idx= where(cover(first_idx:num_tot-1) EQ 200 and fract(first_idx:num_tot-1) GE 50 and albed(first_idx:num_tot-1) GE 30, cnt ) ; found the first snowpoint from end to beginning
  
if  cnt GT 0 then begin  ;<1>
   
next_round=first_idx + idx(cnt-1) + 1 

for k =cnt-1, 0, -1 do begin  ; <2> 
    
    if first_idx + idx(k) GT next_round then begin
    
     continue 
     
    endif
    
    startpt = idx(k)+first_idx ; possible eos point
    
    idxv = where( cover(startpt-num_point+1:startpt ) EQ 11  or   $
                 cover(startpt-num_point+1:startpt ) EQ 255 or   $
                 cover(startpt-num_point+1:startpt ) EQ 50  or   $
                 cover(startpt-num_point+1:startpt ) EQ 200 , cntv, complement=idxnon )
                                                              
  if cntv EQ num_point then begin   ; <3>found the sos
   eos = startpt
   found=1
   break
  endif else begin    ;<3>

    next_round = startpt-num_point+1 + idxnon(0)-1
    if next_round LT first_idx then begin
      break
    endif
    
         
  endelse  ;<3> 


endfor ;<2>

endif  ;<1>

lb_next:

if found EQ 1  and eos LT num_tot-1 then begin   ; <10>

;----change eos to next points if the next consequtive points are cloud points

idx=where(cover(eos+1:num_tot-1) EQ 50, cnt )

if cnt GT 0 then begin  ;<5>

idx_begin=eos

if eos+1+idx(0)-1 EQ eos then begin ; <6>the point right before sos is cloud

;--- locate the consequtive cloud points from end to beginning of idx

for k = 0 , cnt-2 do begin  ;<7>

if idx(k+1) EQ idx(k) + 1 then begin  ;<8>

idx_begin =eos + 1 + idx(k+1)

endif else begin  ;<8>

break
 
endelse   ;<8>

endfor ;<7>

;--- idx_begin to idx(cnt-1) are cloud points

eos=idx_begin

endif ;<6>

endif ;<5> 

endif   ; <10>

;---- smake sure eos is in eos_st and eos_ed

if eos LT eos_st or eos GT eos_ed then begin

eos=eos_ed

endif

return, eos

end
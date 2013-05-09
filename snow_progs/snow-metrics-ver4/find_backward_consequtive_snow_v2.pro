;find the number of consequtive snow points from end to begiing (backforward), get the index 
function find_backward_consequtive_snow_v2, cover, fract,albed, bname, num_point

;the range of last point of the consequtive snow points is 1/31 next year, 5/31 next year 

;set the consecutive snow period equal to 14 days

snow_num = num_point ;

;--- initial first_idx corresponding to current year 1/31

yyyy=strmid(bname(0),0,4) ;
yyyyn= string(fix(yyyy)+1, format='(I4)')


;---eos range is 1/31 to last day of next year
ddd='031'
date=yyyyn+'-'+ddd
idx=where(bname GE date)
eos_st = idx(0)

first_idx=eos_st ; check the last_day_css from first_idx to last_idx

;ddd='151'
;date=yyyyn+'-'+ddd
;idx=where(bname GE date)
eos_ed = n_elements(cover)


;---initialize eos as 031 days of next year

eos=eos_st

found=0   ; 0--not found eos, 1--found eos


;---looking for the suitable snow points

num_tot=n_elements(cover)

idx= where(cover(first_idx:num_tot-1) EQ 200 and $
           fract(first_idx:num_tot-1) GE 50  and $
           albed(first_idx:num_tot-1) GE 30, cnt ) ; found the first snowpoint from end to beginning
  
if  cnt GT 0 then begin  ;<1>  found the possible eos
   
for k =cnt-1, 0, -1 do begin  ; <2> 
       
    startpt = idx(k)+first_idx ; possible eos point
    
    if startpt -snow_num+1 LT 0 then begin
    
      break
      
    endif
          
    idxv = where(cover(startpt-snow_num+1:startpt ) NE 25  and   $
                 cover(startpt-snow_num+1:startpt ) NE 37  and   $
                 cover(startpt-snow_num+1:startpt ) NE 39 , cntv, complement=idxnon )
                                                              
  if cntv EQ snow_num then begin   ; <3>found the sos
   eos = startpt
   found=1
   break
  endif  ;<3>

endfor ;<2>

endif  ;<1>

return, eos

end

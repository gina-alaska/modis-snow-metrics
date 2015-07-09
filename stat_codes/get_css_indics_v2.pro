pro get_css_indics_v2, newcv, fract,albed, quali,bname,first_idx, last_idx, css_st, css_ed, stidx, edidx

;get_css_indics2, newcv, fract, albed, quali, first_idx, last_idx, css_st, css_ed, stidx, edidx
;input newcv, first snow day index, last snow day index, resonable css first index, resonable css last index
;output first css index, last css index
;use find_forward_consequtive_snow and find_backward_consecutive_snow.pro 


;---initilize the first_css_idx and last_css_idx with -1

stidx  = -1
edidx  = -1

num=n_elements(newcv)

;---check if first_idx, css_st,  css_ed, last_idx are in increasing order
;if (first_idx LE css_st and css_st LE css_ed and css_ed LE last_idx ) EQ 0 then begin
;return
;endif



;--- check if there is un-breaked period between css_st and css_ed, if not, return first_css_idx=-1 and last_css_idx=-1
;idx_nosnow = where(newcv(css_st:css_ed) EQ 25,no_snow_cnt)
;if no_snow_cnt GT  then begin   ; do not get reasonable css first and last indics
;return
;endif

;--- from first_idx to num-1,look for first_css_idx, otherwise, set first_css_idx=first_idx

snow_num=css_ed-css_st + 1

;---looking for the suitable snowpoints, must be snow, fraction of snow >=50%, and albedo >=30%

;idx=where(newcv(first_idx:last_idx) EQ 200 and $
;          fract(first_idx:last_idx) GE 50  and $
;          albed(first_idx:last_idx) GE 30, cnt)

idx=where(newcv(first_idx:last_idx) EQ 200 and $
          fract(first_idx:last_idx) GE 50, cnt)


if cnt GT 0 then begin  ; <1>, have possible first_css

for k=0, cnt-1 do begin   ;<2>

startpt=idx(k) +first_idx

if startpt + snow_num -1 GT last_idx then begin
  break
endif  

idxv = where(  newcv(startpt:startpt+snow_num-1 ) NE 25  and   $
               newcv(startpt:startpt+snow_num-1 ) NE 37  and   $
               newcv(startpt:startpt+snow_num-1 ) NE 39 ,cntv, complement=idxnon )

  if cntv GE snow_num then begin   ; <3> points from startpt to last_idx are all one of night,cloud,fill,or snow, found the sos
   stidx =  startpt
   
   break
  endif ; <3>



endfor ;<2>

endif  ;<1>


if stidx GE first_idx and stidx LE last_idx then begin ; <8> only if stidx is valid , then look for edidx

;----- find edidx from 0 to last_idx 

;idx= where(newcv(first_idx:last_idx) EQ 200 and $
;           fract(first_idx:last_idx) GE 50  and $
;           albed(first_idx:last_idx) GE 30, cnt ) ; found the first snowpoint from last_idx to beginning


idx= where(newcv(first_idx:last_idx) EQ 200 and $
           fract(first_idx:last_idx) GE 50, cnt ) ; found the last snowpoint from first_idx to last_idx, backward looking


  
if  cnt GT 0 then begin  ;<1>  found the possible eos
   
for k =cnt-1, 0, -1 do begin  ; <2> 
       
    startpt = idx(k) + first_idx ; possible edidx point

if startpt-snow_num+1 LT first_idx then begin

  break
  
endif  
    
    idxv = where(newcv(startpt-snow_num+1:startpt ) NE 25  and   $
                 newcv(startpt-snow_num+1:startpt ) NE 37  and   $
                 newcv(startpt-snow_num+1:startpt ) NE 39 , cntv, complement=idxnon )
                                                              
  if cntv GE snow_num then begin   ; <3>found the sos
   edidx = startpt
   
   break
  endif  ;<3>

endfor ;<2>

endif  ;<1>

endif ; <8>


if stidx EQ -1 or edidx EQ -1 or stidx GT edidx then begin


if stidx GT edidx then begin

print, 'check why'

endif

stidx=-1
edidx=-1

;print,'check why can not locate css

endif

return

end


 
 
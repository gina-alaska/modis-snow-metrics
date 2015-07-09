;this routine do re classify the cloud points as snow or no-snow
pro cloud_reclassify_v2,cover,fract,stidx,edidx,flg,newcv
;inputs: cover,fract,stidx--start index, edidx--end index, flg--1,backward,snow, 2=backward,no-snow; 3-forward,snow; 4-forward, no-snow
;output: newcv--reclassifed cover
;jzhu,2012/10/29, treat 0-missing data, 1-no decision data, 11-night,254-detector saturated, 255-fill as cloud pixel 
;missing_data=0
;no_decision=1
;night=11
;no_snow=25
;cloud=50
;snow=200
;saturated=254
;fill=255

num_tot=n_elements(cover)

if (stidx LT 0 or $ 
    stidx GT num_tot-1 or $
    edidx LT 0 or $
    edidx GT num_tot-1 or  $
    stidx GE edidx ) then begin
   
   return
endif   
   
wrk_fract=fract(stidx:edidx)

wrk_cover=cover(stidx:edidx)

wrk_newcv=newcv(stidx:edidx)

idxcld=where (wrk_newcv EQ 50,cntcld)

if cntcld EQ 0 then begin   ; no cloud point to adjust, return
return
endif



num=n_elements(wrk_fract)  ; number of wrk_fract


case flg of

1: begin   ;backward, snow ->snow

   idx=where(wrk_cover EQ 200, cnt) ; check snow with wrk_cover
   
   if cnt GT 0 then begin ; <1>
    
   for k=cnt-1, 0, -1 do begin  ;<2>

    tmpk =idx(k)
    
    if tmpk GT 0 then begin  ;<3>
    
    while wrk_cover(tmpk-1) EQ 0  or $
          wrk_cover(tmpk-1) EQ 11 or $
          wrk_cover(tmpk-1) EQ 50 or $
          wrk_cover(tmpk-1) EQ 255 do begin ;<4>, think fill, night,or missing point as cloud point
     
      wrk_newcv(tmpk-1) = 200
      
      tmpk=tmpk-1
      
      if tmpk LE 0 then begin ;<5>
      
       break

      endif ;<5> 
      
    endwhile ;<4>
    
    endif  ;<3>
    
   endfor ;<2>
    
   endif ;<1>
   
   end
   
               
2: begin  ;backward, no-snow ->no-snow

   idx=where(wrk_cover EQ 25, cnt) ; check snow with wrk_cover
   
   if cnt GT 0 then begin ; <1>
    
   for k=cnt-1, 0, -1 do begin  ;<2>

    tmpk =idx(k)
    
    if tmpk GT 0 then begin  ;<3>
    
    while wrk_cover(tmpk-1) EQ 0  or $
          wrk_cover(tmpk-1) EQ 11 or $ 
          wrk_cover(tmpk-1) EQ 50 or $
          wrk_cover(tmpk-1) EQ 255 do begin ;<4>
   
      wrk_newcv(tmpk-1) = 25
      
      tmpk=tmpk-1
      
      if tmpk LE 0 then begin ;<5>
      
         break
         
      endif  ;<5>
         
    endwhile ;<4>
   
   endif ; <3>
   
     
   endfor ;<2>
   
   endif ;<1>
   
   end
   
3: begin   ;forward, snow -> snow

 
  idx=where(wrk_cover EQ 200, cnt) ; check snow with wrk_cover
   
   if cnt GT 0 then begin ; <1>
    
   for k=0, cnt-1 do begin  ;<2>

    tmpk =idx(k)
   
    if tmpk LT num-1 then begin  ;<3>
    
    while wrk_cover(tmpk+1) EQ 0 or $
          wrk_cover(tmpk+1) EQ 11 or $
          wrk_cover(tmpk+1) EQ 50 or $
          wrk_cover(tmpk+1) EQ 255 do begin ; <4>
    
      wrk_newcv(tmpk+1) = 200
      tmpk=tmpk+1
      
      if tmpk GE num-1 then begin ;<5>
      
         break
         
      endif  ;<5>
      
    endwhile ;<4>
    
    endif ;<3>
    
   endfor ;<2>
   
   endif ;<1>
   
  end
                 
4: begin  ;process dmax to dmin,forward, no-snow

   idx=where(wrk_cover EQ 25, cnt) ; check snow with wrk_cover
   
   if cnt GT 0 then begin ; <1>
    
   for k=0, cnt-1 do begin  ;<2>

    tmpk =idx(k)
    
    if tmpk LT num-1 then begin ;<3>
    
    while wrk_cover(tmpk+1) EQ 0 or $
          wrk_cover(tmpk+1) EQ 11 or $
          wrk_cover(tmpk+1) EQ 50 or $
          wrk_cover(tmpk+1) EQ 255  do begin ;<4>
   
      wrk_newcv(tmpk+1) = 25
      
      tmpk=tmpk+1
      
      if tmpk GE num-1 then begin ;<5>
      
         break
         
      endif  ;<5>
      
    endwhile ;<4>

    endif  ;<3>
    
   endfor ;<2>
   
   endif ;<1>
  
  end
     
endcase   

newcv(stidx:edidx) = wrk_newcv
 
return

end      
      
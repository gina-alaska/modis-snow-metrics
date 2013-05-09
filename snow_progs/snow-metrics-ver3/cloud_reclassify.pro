;this routine do re classify the cloud points as snow or no-snow
pro cloud_reclassify,cover,fract,stidx,edidx,flg,newcv
;inputs: cover, fract,stidx--start index, edidx--end index, flg--1,backward,snow, 2=backward,no-snow; 3-forward,snow; 4-forward, no-snow
;output: newcv--reclassifed cover

num_tot=n_elements(cover)

if stidx LT 0 or $ 
   stidx GT num_tot-1 or $
   edidx LT 0 or $
   edidx GT num_tot-1 or  $
   stidx GE edidx then begin
   newcv=cover
   return
endif   
   
wrk_fract=fract(stidx:edidx)

wrk_cover=cover(stidx:edidx)

wrk_newcv=newcv(stidx:edidx)

num=n_elements(wrk_fract)  ; number of wrk_fract


case flg of

1: begin   ;process dmax to dmin, backward, snow ->snow

   idx_snow=where(wrk_cover EQ 200, cnt_snow) ; check snow with wrk_cover
   
   if cnt_snow GT 0 then begin ; <1>
    
   for k=cnt_snow-1, 1, -1 do begin  ;<2>

   ;process idx_snow(cnt_snow-1) to idx_snow(1)

   for m=idx_snow(k), idx_snow(k-1)+2,-1 do begin  ;<3>
   
   if wrk_cover(m-1) EQ 50 or wrk_cover(m-1) EQ 255 or wrk_cover(m-1) EQ 11 then begin   ;<4>,  50--cloud, 255--fill,11--night
      wrk_newcv(m-1)= 200  ; 200--snow
   
   endif else begin ;<4>
   
   break
   
   endelse  ;<4>
   
   endfor  ;<3>
   
   endfor  ;<2>
   
   ;---process 0 to idx_snow(0) of wrk_cover
   
   for m=idx_snow(0), 1, -1 do begin  ;<5>
   
   if wrk_cover(m-1) EQ 50 or wrk_cover(m-1) EQ 255 or wrk_cover(m-1) EQ 11 then begin   ;<6>,  50--cloud, 255--fill,11--night
      wrk_newcv(m-1)= 200  ; 200--snow
   
   endif else begin ;<6>
   
   break
   
   endelse  ;<6>
   
   endfor  ;<5>
   
   
   endif  ;<1>  
   
   end
   
2: begin  ;process da to dmax, backward, no-snow ->no-snow

   idx_snow=where(wrk_cover EQ 25, cnt_snow) ; 25--no-snow
   
   if cnt_snow GT 0 then begin ;
   
   for k=cnt_snow-1, 1, -1 do begin

   ;process idx_snow(m) to idx_snow(m-1)

   for m=idx_snow(k), idx_snow(k-1)+2,-1 do begin
   
   if wrk_cover(m-1) EQ 50 or wrk_cover(m-1) EQ 255 or wrk_cover(m-1) EQ 11 then begin ;50--cloud, 255--fill,11--night
      wrk_newcv(m-1)= 25         ; 25--no-snow
   
   endif else begin
   
   break
   
   endelse
   
   
   endfor
   
  
   
   endfor
   
  ;---process 0 to idx_snow(0)
   
   for m=idx_snow(0), 1, -1 do begin  ;<5>
   
   if wrk_cover(m-1) EQ 50 or wrk_cover(m-1) EQ 255 or wrk_cover(m-1) EQ 11 then begin   ;<6>,  50--cloud, 255--fill,11--night
      wrk_newcv(m-1)= 25  ; 200--snow
   
   endif else begin ;<6>
   
   break
   
   endelse  ;<6>
   
   endfor  ;<5>
  
  
   endif   ;
  
   end
   
3: begin   ;process da to dmax, forward, snow

   idx_snow=where(wrk_cover EQ 200, cnt_snow)  ; check snow with wrk_cover
   
   
    
   if cnt_snow GT 0 then begin ;
   
   for k=0,cnt_snow-2 do begin

   ;process idx_snow(m) to idx_snow(m-1)
   
   for m=idx_snow(k), idx_snow(k+1)-2 do begin
   
   if wrk_cover(m+1) EQ 50 or wrk_cover(m+1) EQ 255 or wrk_cover(m+1) EQ 11 then begin
      wrk_newcv(m+1)= 200 
   
   endif else begin
   
     break
     
   endelse  

   endfor
   
   
   
   endfor
   
   ;---process idx_snow( n_elements(idx_snow)-1 ) to num-1
   
   
   for m=idx_snow(cnt_snow-1), num-2 do begin  ;<5>
   
   if wrk_cover(m+1) EQ 50 or wrk_cover(m+1) EQ 255 or wrk_cover(m+1) EQ 11 then begin   ;<6>,  50--cloud, 255--fill
      wrk_newcv(m+1)= 200  ; 200--snow
   
   endif else begin ;<6>
   
   break
   
   endelse  ;<6>
   
   endfor  ;<5>
   
   
   endif   ;
     
   end
   
4: begin  ;process dmax to dmin,forward, no-snow

   idx_snow=where(wrk_cover EQ 25, cnt_snow)
  
   if cnt_snow GT 0 then begin  ; <4>
     
   for k=0, cnt_snow-2 do begin

   ;process idx_snow(k) to idx_snow(k+1)-1
   
   for m=idx_snow(k), idx_snow(k+1)-2 do begin
   
   if wrk_cover(m+1) EQ 50 or wrk_cover(m+1) EQ 255 or wrk_cover(m+1) EQ 11 then begin
      wrk_newcv(m+1)= 25
   
   endif else begin
   
      break
      
   endelse   
   
   endfor
   
   
  endfor
  
  ;process idx_snow(cnt_snow-1) to num-1
   
  for m=idx_snow(cnt_snow-1), num-2 do begin  ;<5>
   
   if wrk_cover(m+1) EQ 50 or wrk_cover(m+1) EQ 255 or wrk_cover(m+1) EQ 11 then begin   ;<6>,  50--cloud, 255--fill
      wrk_newcv(m+1)= 25  ; 200--snow
   
   endif else begin ;<6>
   
   break
   
   endelse  ;<6>
   
   endfor  ;<5>
   endif  ; <4>
   
   end
   
endcase   

newcv(stidx:edidx) = wrk_newcv
 
return

end      
      
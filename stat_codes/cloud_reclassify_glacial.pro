pro cloud_reclassify_glacial, newcv

;if there are only snow and cloud in the newcv, 
;it is treated as glacial pixel, re-classify all cloud ponits as snow points

idxsnow = where(newcv EQ 200, cntsnow)
idxcld = where(newcv EQ 50, cntcld)

if cntsnow+cntcld EQ n_elements(newcv) then begin  ; this is glacial pixel, set all cloud points as snow points

 if cntcld GT 0 then begin
 
   newcv(idxcld)=200
   
 endif

endif

return

end    
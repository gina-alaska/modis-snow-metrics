pro replace_cloud_by_aqua_v2, tmp_cover,tmp_fract,tmp_quali,tmp_albed,bnames,tmp_cover_a,tmp_fract_a,tmp_quali_a,tmp_albed_a,bnames_a
;this program check cloud pixels in tmp_cover, find corresponding pixel in tmp_cover_a, 
;if it is no_snow or snow pixel, replace tmp_cover, tmp_fract,tmp_quali, and tmp_albed with related values in aqua.

cloud=50
snow=200
no_snow=25
miss_data=0
fill_data=255


;--- if cloud in terra, and no_snow in aqua, change into no_snow

cloud_idx=where(tmp_cover EQ cloud,cloud_cnt)

if cloud_cnt GT 0 then begin ;<11>

for i=0, cloud_cnt-1 do begin ;<12>

idx_aqua = where(bnames_a EQ bnames( cloud_idx(i) ) ,found_cnt)

if found_cnt EQ 1 then begin  ; <13>found the coresponding pixel in aqua

   if tmp_cover_a(idx_aqua(0) ) EQ no_snow or tmp_cover_a(idx_aqua(0) ) EQ snow then begin ; <14>
      tmp_cover(cloud_idx(i)) =tmp_cover_a(idx_aqua(0) )
      tmp_fract(cloud_idx(i)) =tmp_fract_a(idx_aqua(0) ) 
      tmp_quali(cloud_idx(i)) =tmp_quali_a(idx_aqua(0) )
      tmp_albed(cloud_idx(i)) =tmp_albed_a(idx_aqua(0) )
   endif  ;<14>
     
endif ; <13>

endfor ;<12>

endif ;<11>


   



return

end

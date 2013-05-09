;This program does adjacent teporal deduction of cloud points. If cloud point is in between two adjacent snow point, the cloud is re-classified
;as snow point; if cloud point is in two adjacent "no-snow" points, the cloud point is re-classified as "no-snow" point

pro adjacent_deduction_cloud, cover, newcv

cloud=50 ; cloud is set as 50 in cover  
snow=200 ;
no_snow=25 ;

newcv=cover  ; initialize the newcv

num=n_elements(cover)

idx=where(cover EQ cloud,cnt)

if cnt GT 0 then begin  ;<1>


for k=0, cnt-1 do begin  ;<2>

if idx(k) GT 0 and idx(k) LT ( num-1 )  then begin  ;<3>

if cover(idx(k)-1 ) EQ snow and cover( idx(k)+1 ) EQ snow then begin  ;<4>

newcv( idx(k) ) = snow

endif else begin  ;<4>

if cover(idx(k)-1 ) EQ no_snow and cover( idx(k)+1 ) EQ no_snow then begin  ;<5>

newcv( idx(k) ) = no_snow

endif  ;<5>

endelse  ;<4>

endif  ;<3>

endfor ;<2>


endif ;<1>

return

end
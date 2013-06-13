function cal_fract,fract,stidx,edidx
;this function interpolate three segments of fract-array devided by stidx and edidx with different methods 
newfract =fract

if stidx GT edidx then begin

return, newfract

endif


;------ 0 to stidx-1
if stidx GT 0 then begin
wrk1=newfract(0:stidx-1)
num1=stidx
idx100 = where(wrk1 GT 100,cnt100)
if cnt100 GT 0 then begin
wrk1(idx100) = 0
newfract(0:stidx-1)=wrk1
endif

endif

;-----edidx+1 to n_elements(newfract)-1 

num=n_elements(newfract)
if edidx LT num-1 then begin
wrk3= newfract(edidx+1:num-1)
idx100=where(wrk3 GT 100, cnt100)
if cnt100 GT 0 then begin
wrk3(idx100)= 0
newfract(edidx+1:num-1)=wrk3
endif

endif

;--- stidx to edidx
wrk2 = newfract(stidx:edidx)
num2=n_elements(wrk2)
xin=where(wrk2 LE 100 and wrk2 GT 0, xincnt )  ; valid fract

if xincnt GT 0 then begin
v=wrk2(xin)
xout=indgen(num2)
wrk2=byte( interpol_line_fill(v,xin,xout)  )
newfract(stidx:edidx)=wrk2
endif

return, newfract

end
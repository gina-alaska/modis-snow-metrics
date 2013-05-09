;this program to interpolate, inputs are: v, xin, xout, 
;v is input vector, xin and xout are indics

function interpol_line_fill,v,xin,xout

; convert v,xin,xout from type into float

v=float(v)

;xin=float(xin)
;xout=float(xout)

numout=n_elements(xout)

y=fltarr(numout)   ; store output


numin=n_elements(xin)



;---- first idxin(0)
;--- interpol v(xin(0)) to between y(0) and y(xin(0) )
; for k=xout(0),xin(0) do begin
;    y(k)=v(0)
; endfor

;---interp 0 for y(0) to y(xin(0))

st_num=xin(0)-xout(0)

if st_num GT 0 then begin
y( xout(0):xin(0)-1 )=v(0)
endif

y(xin(0)) = v(0)

for j=0, numin-2 do begin

if xin(j+1) - xin(j) GT 1 then begin

b=( v(j + 1 ) - v( j ) )/ ( float(xin(j+1)) -float(xin(j))  ) 

a= ( v( j ) ) - b*xin(j)

for k=xin(j), xin(j+1) do begin

y( k )= a+b*xout(k) 

endfor

endif else begin   ; xin(j) and xin(j+1) are adjunctive

y( xin(j) )= v(j)

y( xin(j+1) )=v( j+1 )

endelse

endfor

;--- process last point of v


;----fill 0 for xin(numin-1)+1 to xout(numout-1)
ed_num=xout(numout-1)-xin(numin-1)

if ed_num GT 0 then begin

y(xin(numin-1)+1:xout(numout-1))= v(numin-1) 
endif
 


return, y 

end



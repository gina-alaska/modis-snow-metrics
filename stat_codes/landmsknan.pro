function landmsknan, b
; b is a 2d matrics, set the NAN to elements with value eq to 0, and keep others as they are.
; 

sz=size(b)
c=float(b)

for i=0, sz(2)-1 do begin
  for j=0, sz(2)-1 do begin
    
     if b[i,j] EQ 0 then begin
       c[i,j]=!VALUES.F_NAN
     endif
  endfor
endfor  

return, c
end  
    

function landmask_nan_by_mflg, b
; b is a mflg matrics, set 1 for pixels equal to 12,22,or 32, set the NAN for pixels with other values.
; 

sz=size(b)
c=float(b)

for i=0, sz(1)-1 do begin
  for j=0, sz(2)-1 do begin
    
     if (b[i,j] EQ 12) or (b[i,j] EQ 22) or (b[i,j] EQ 32) then begin
       c[i,j]=1
     endif else begin  
       c[i,j]=0
     endelse
  endfor
endfor  

return, c
end  
    

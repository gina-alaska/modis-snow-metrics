;this function calculate y as a function of y=ax+b

function yvalline,vx,vy,x
;vx is x coordinate, vy is the y coorinate, x is the point of x, 

if x mod fix(x) then begin ; 

x1=fix(x)

x2=fix(x)+1

slope = vy(x2)-vy(x1)/(x2-x1)

y=vy(x1)+slope(x-x1)

endif else begin

y=vy(x)

endelse

return,y


end
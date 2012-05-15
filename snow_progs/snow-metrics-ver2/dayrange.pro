function dayrange, bandname, onp,endp

;---get the index of the last day of the current year

cyear=strmid( bandname(0),0,4)
;----the last day of the current year
dpy=365
dpystr = '365'
learn_year = cyear mod 4
if learn_year EQ 0 then begin
dpy=366
dpystr='366'
endif

lastday=cyear+'-'+dpystr

nyear_firstday_idx = (where(bandname GT lastday))(0)  ; the index of the first day of the next year
 

;---------onp
dayidx1=fix(onp)
onpidx=onp
fract = onp mod dayidx1
if fract then begin
onpidx=dayidx1+1
endif

year1=strmid( bandname(onpidx),0,4)
x1=strmid( bandname(onpidx),5,3)
yyyyddd1=float(year1+'.'+x1)
x11=fix(x1)

if onpidx GE nyear_firstday_idx then begin

x11=x11+dpy

endif

;------------endp
dayidx1=fix(endp)
endpidx = endp
fract = endp mod dayidx1

if fract then begin
endpidx = dayidx1+1
endif
year2=strmid( bandname(endpidx),0,4)
x2=strmid( bandname(endpidx),5,3)
yyyyddd2=float(year2+'.'+x2)
x22=fix(x2)

if endpidx GE nyear_firstday_idx then begin

x22=x22+dpy

endif

;---calculate the range between onp and endp
 
d_range = x22 - x11 

days={on_day:x11,end_day:x22,day_range:d_range}

return,days 

end


function dayrange, days_str, onp, endp
;days_str is composed of days from the Jan.,1 of current year. 
;day=1 for JAn 1 of current year.
;onp and endp are indics.
x11=fix(days_str(onp))
x22=fix(days_str(endp))
d_range=x22-x11 + 1
days={on_day:x11,end_day:x22,day_range:d_range}
return,days 

end


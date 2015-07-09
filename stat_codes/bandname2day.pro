function bandname2day,bandname
;bandname is conposed of yyyy.day,covert them into day from the jan,1 of current year
num=n_elements(bandname)
days_str=strarr(num)

;---get the index of the last day of the current year
cyear= strmid( bandname(0),0,4)
;----get the last day of the current year
dpy=365
dpystr = '365'
leap_year = cyear mod 4 ;leap_year=0, it is leap year
if leap_year EQ 0 then begin
dpy=366
dpystr='366'
endif

idx_cyear=where( strmid(bandname(*),0,4) EQ cyear, cnt_cyear, complement=idx_nyear)

days_str(idx_cyear)=strmid(bandname(idx_cyear),5,3)

days_str(idx_nyear)= strtrim( string(fix( strmid(bandname(idx_nyear),5,3) )+dpy ),2)

return, days_str

end
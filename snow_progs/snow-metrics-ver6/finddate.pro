;this function accept band name vector, and float index, to return exec day

function finddate, bandName, dayindex_flt

dayidx1=fix(dayindex_flt)
dayidx=dayidx1

fract = dayindex_flt mod dayidx1
if fract then begin
dayidx=dayidx1+1
;day1= fix( strmid( bandname(dayidx1),5,3)) 
;day2= fix( strmid( bandname(dayidx2),5,3))
endif

year=strmid( bandname(dayidx),0,4)
x=strmid( bandname(dayidx),5,3)

yydd=float(year+'.'+x)


return, x

end
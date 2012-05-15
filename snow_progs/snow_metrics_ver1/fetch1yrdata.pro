pro fetch1yrdata, three_year_cb,three_year_bn, year,num,ndvi,bq,bn

;year input 0,1,2, where 0 prevoius year, 1-current year, 2- after current year
;ndvi, bq, bn are return variables

yr1idx = where(strmid(three_year_bn,0,1) EQ year,yr1cnt ) 
yr1num= yr1cnt/2
yr1cb=three_year_cb(yr1idx)
yr1cb_bn =three_year_bn(yr1idx)

ndvi =yr1cb(0:yr1num-1)
bq  = yr1cb(yr1num:2*yr1num-1)
bn =  yr1cb_bn(0:yr1num-1)
num=yr1num 
return

end
 
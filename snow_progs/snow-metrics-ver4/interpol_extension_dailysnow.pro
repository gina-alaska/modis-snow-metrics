;This program process a vector, it get rid of no-sense point such as -2000 (80), intepolate with adjunct points
;This program do not call oneyear_extension, that means do not interpolate jan,nov,and dec into feb to oct data series
;do interpolate, interpolate threshold, if all time series are threshold values, means this pixel is not vegitation, perhaps water, do not calcualte metrics of this pixel
;threshold is fill value, do not do interpolate, snowcld=60, need interpolate, for points with 81-100, need interpolate
 

pro interpol_extension_dailysnow, tmp,tmp_cover,bnames,tmp_interp,flg_metrics
   ;interpol_extension_dailysnow, tmp,tmp_cover,bnames,tmp_interp,flg_metrics
;


;input: tmp---time-series of one year dailysnow, tmp_cover---classification value of the time-series,
;bnames--band name of the time-series

;output:tmp_interp----interpolated version of temp, flg_metrics---if the tmp_interp can be sued to calcualte metrics

;tmp is a 365 points time-series, the data in this time-series are:
;good data is in 0 to 100, bad data is 255

;flg_metrics= 0 ; initial not calculate metrics 

idxv = where( (tmp NE 255 ), cnt, complement=idxnon ) ; valid data index=idxv, no-valid data index=idxnon

;cnt is the number of valid pixels
                                                     
tmpnan=tmp ; tmpnan will be used to store return vector

;if cnt GT 30 then begin ;valid days is more than 30 days, we calculate the snow metrics of this pixel, otherwise, do not calculate it

flg_metrics=1

;---get the mean of first and last valid as fill value for 1-28, 223-365 days

tmpx=fix(idxv) ;x coordinates values of valid values

tmpv=tmp(idxv) ; valid values

;---interpolate the missing points: cloud,bad, fill, and negative reflectance pixels

len=n_elements(tmp)

tmpu=indgen(len) ; interpolated x coorinidates

tmpnan=interpol_line(tmpv,tmpx,tmpu)

;endif 

tmp_interp = tmpnan

return

end
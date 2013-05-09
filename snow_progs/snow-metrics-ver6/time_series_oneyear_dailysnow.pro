;jiang Zhu, 11/21/2011,jiang@gina.alaska.edu
;
;This program calls subroutines to interpolate one-year time-series data,
;smooth the one-year time-series data, and calculate the snow metrics for the one-year time-series data.
;The inputs are: 
;tmp (one-year-time-series-cvector), 
;bnames (three-year-time-series-vector name),

;outputs are:
;mid_interp (mid-year interpolated vector),
;mid_smooth (mod-year smoothed vector),
;mid_bname (mid-year smoothed vector's band names),
;vmetrics (mid-year metrics).
 
;jzhu, 5/5/2011, use the program provided by Amy to do moving smooth and calculate the crossover
 
;jzhu, 9/8/2011, ver9 processes the one-year-stacking file which includes ndvi and bq together.  

pro time_series_oneyear_dailysnow,tmp_cover,tmp_fract,tmp_quali,bnames,mid_cover,mid_fract,mid_bname,vmetrics

   ;time_series_oneyear_dailysnow,tmp_cover,tmp_fract,tmp_quali,bnames,mid_cover,mid_fract,mid_bname,vmetrics


; only choose land data for snow metrics calculation
idx = where( (tmp_cover EQ 25 or tmp_cover EQ 200 ), cnt, complement=idxcomp)


if cnt LE 30 then begin  ; valid number is less than 30, do not calculate metrics, metrics = 0  <1>

idx_ocean=where(tmp_cover EQ 255 or tmp_cover EQ 39,cnt_ocean)   ;ocen points
mid_cover=tmp_cover
mid_fract=tmp_fract
mid_bname=bnames
vmetrics=fltarr(12)  ; flg_metrics=0

if cnt_ocean GE 0.8*n_elements(tmp_cover) then begin  ; if points in tmp_cover are completely 255
flg_metrics=-1
vmetrics(*)=flg_metrics  ; flg_metrics=-1

endif

return

endif ; corresponds to if <1>


;---- tmp is composed of 0-100 and 255, 255-indicates points which needs to be interpolated

tmp = tmp_fract
tmp(idx) =tmp_fract(idx)
tmp(idxcomp)=255


;---- calls interpol_extension_1y_vector_ver9.pro to process one-year data, do one-year vector extension, then inpterpolate

interpol_extension_dailysnow,tmp,tmp_cover,bnames,tmp_interp,flg_metrics

;---flg_metrics -1, missing data, not calculate, 0--not good data, not calculate, 1-- good data, calculate 


;----- calculate metrics-----------------------------
;---calls wls_smooth to do smooth. wls_smooth is developed based on the method 
;---that Daniel L. Swets originally developed, except including combined windows

wls_smooth, tmp_interp,2,2,tmp_smooth

;metrics_dailysnow, tmp_smooth,tmp_interp,tmp_bq_interp,tmp_bname_interp, metrics_cal_threshold,vmetrics ;vout--smoothed vector, vorg--orginal vector, vmetrics--metrics

metrics_dailysnow, tmp_smooth,tmp_cover,bnames,vmetrics
mid_cover=tmp_cover
mid_fract=tmp_interp
mid_bname=bnames

return

end

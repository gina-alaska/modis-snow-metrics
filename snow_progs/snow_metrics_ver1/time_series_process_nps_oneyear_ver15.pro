;jiang Zhu, 2/17/2011,jiang@gina.alaska.edu
;This program calls subroutines to interpolate a three-year time-series data,
;smooth mid-year time-series data, and calculate the metrics for the mid-year time-series data.
;The inputs are: 
;tmp (three-year-time-series-cvector), 
;bnames (three-year-time-series-vector name),
;threshold (fill value for no data, 60b),
;snowcld (fill value for snow and cloud, 60b),
;outputs are:
;mid_interp (mid-year interpolated vector),
;mid_smooth (mod-year smoothed vector),
;mid_bname (mid-year smoothed vector's band names),
;vmetrics (mid-year metrics).
 
;jzhu, 5/5/2011, use the program provided by Amy to do moving smooth and calculate the crossover
 
;jzhu, 9/8/2011, ver9 processes the one-year-stacking file which includes ndvi and bq together.  

pro time_series_process_nps_oneyear_ver15,tmp,bnames,threshold,snowcld,mid_interp,mid_smooth,mid_bq,mid_bname,vmetrics

a=-100
sfactor=0.01
ratio=0.3  ;number of valid points(not threshold or snowcld) of mid_year/number of total points of mid_year
metrics_cal_threshold=0.4 ;when ndvi is less than metrics_cal_threshold, do not calculate metrics
flg_metrics=0 ; 0---not calculate metrics
stnum=3  ; make first stnum points up
ednum=3  ; make last ednum points up

tmp_bn=bnames

;---- calls interpol_extension_1y_vector_ver9.pro to process one-year data, do one-year vector extension, then inpterpolate

interpol_extension_3y_vector_ver15,tmp,tmp_bn,threshold,snowcld,tmp_interp,tmp_bq_interp,tmp_bname_interp,ratio,stnum_real,ednum_real,flg_metrics

;---conver to 0 to 1 ndvi range
;tmp_smooth = ( tmp_smooth +a )*sfactor

tmp_interp = ( tmp_interp +a )*sfactor

yr2idx=where(strmid(tmp_bname_interp,0,1) EQ 1)

mid_bq    =tmp_bq_interp(yr2idx)

mid_bname=tmp_bname_interp(yr2idx)

if flg_metrics EQ 0 then begin  ; no not calculate metrics

mid_interp=tmp_interp(yr2idx)

mid_smooth=tmp_interp(yr2idx)

vmetrics =fltarr(12) ; if do not calculate metrics, set every element = 0.0

endif else begin  
;----- calculate metrics-----------------------------
;---calls wls_smooth to do smooth. wls_smooth is developed based on the method 
;---that Daniel L. Swets originally developed, except including combined windows

wls_smooth, tmp_interp,2,2,tmp_smooth

mid_interp=tmp_interp(yr2idx)

mid_smooth=tmp_smooth(yr2idx)


user_metrics_nps_by3yr, tmp_smooth,tmp_interp,tmp_bq_interp,tmp_bname_interp, metrics_cal_threshold,vmetrics ;vout--smoothed vector, vorg--orginal vector, vmetrics--metrics

endelse 

return

end

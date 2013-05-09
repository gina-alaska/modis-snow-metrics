;jiang Zhu, 1/25/2012,jiang@gina.alaska.edu
;
;This program calls subroutines to process a snow-year time-series data according to Keshav Prasad Paudel
;Keshav Prasad Paudel, Peter Andersen, Monitoring snow cover variability in an agropastoral area in the trans himalayan region of nepal using
;MODIS data with improved cloud removal methodology, remote sensing of environment 115 (2011) 1234-1246
;it includes 1. define the Da, Dmax,and Dmin, 2. process data points between Da and Dmax, and Dmax and Dmin to get the smoothed time series.
;3. get snow metrics
;smooth the one-year time-series data, and calculate the snow metrics for the one-year time-series data.
;The inputs are: 
;tmp_cover (one-snowyear-time-series-cvector), 
;tmp_fract
;tmp_quali

;outputs are:
;mid_interp (mid-year interpolated vector),
;mid_smooth (mod-year smoothed vector),
;mid_bname (mid-year smoothed vector's band names),
;vmetrics (mid-year metrics).
 
  

pro time_series_oneyear_dailysnow_kp,tmp_cover,tmp_fract,tmp_quali,tmp_albed,bnames,day_str,mid_cover,mid_fract,mid_bname,vmetrics

;time_series_oneyear_dailysnow_kp,tmp_cover,tmp_fract,tmp_quali,tmp_albed,bnames,mid_cover,mid_fract,mid_bname,vmetrics

;----1. determine if calculate the metrics of the time-series, if water, do not calculate the snow metrics

;define a new mflg: ocen-1,land-2,lake-3 and no-snow=1, only-brokensnow=2, consevutive snow=3,
;mflag is conposed as snow_flag and type flag, so no-snow ocean=11,no-snow land=12,no-snow lake=13
;broken-snow ocean=21, broken-snow land=22,broken snow lake=23, css-snow ocean=31,css-snow land=32,css-snow lake=33

;identfy the type of the pixel indicated by the time-series

vmetrics=intarr(14) ; initialize the metrics data

num =n_elements(tmp_cover)

idx_fst=where(tmp_cover EQ 39 ,cnt_fst)  ; ocean

if cnt_fst GE 10 then begin  ; it is ocean

  type_flg = 1

endif else begin

  idx_fst=where(tmp_cover EQ 37 or tmp_cover EQ 100,cnt_fst)
 
  if cnt_fst GE 10 then begin ; it is lake or inland water
      type_flg=3
   endif else begin
   
      type_flg=2   ; it is land   
  endelse
  
endelse

;---check if the time-series has any snow point

idx_snow=where(tmp_cover EQ 200,cnt_snow)

if cnt_snow LE 0 then begin  ; <1> no any snow ponit in the time series

snow_flg=10

mid_cover=tmp_cover
mid_fract=tmp_fract
mid_bname=bnames
metrics_flg=snow_flg+type_flg 
vmetrics(9)=metrics_flg
return

endif ; corresponds to if <1>


;----2. Adjacent temporal deduction of cloud points

adjacent_deduction_cloud, tmp_cover, newcv_aj



;----determine Da,Dmax,Dmin, this is called snow cycle, you may choose 0-idx_dmax-last_idx as snow cycle for test

;idx_snow= where(tmp_fract GT 0 and tmp_fract LE 100, cnt_snow)

idxda=0  ; 0---first index

idxfirst=find_forward_consequtive_snow_v2(newcv_aj,tmp_fract, tmp_albed, bnames,16)

;idx_dmax=where( tmp_fract EQ  max( tmp_fract(idx_snow ) ) )  

;idxfirst=idx_dmax(0)

idxlast=find_backward_consequtive_snow_v2( newcv_aj, tmp_fract, tmp_albed, bnames,16)

;idxlast=idx_dmax( n_elements(idx_dmax)-1 )

idxdmin = n_elements(tmp_fract)-1  ; last index


;output the SOCSSb and EOCSSb to vmetrics

tmp_b=dayrange(day_str,idxfirst,idxlast)

;vmetrics(10)=tmp_b.on_day
;vmetrics(11)=tmp_b.end_day


;----re-classify the cover, devide the time-series into three segements: 0 point-first 100% point, first 100% point to last 100% point,and last 100% point to last point

newcv=newcv_aj  ; this is necessary

;backward processing

cloud_reclassify_v5, newcv_aj,tmp_fract,idxlast+1,idxdmin, 1,newcv

cloud_reclassify_v5, newcv_aj,tmp_fract, idxfirst,idxlast,1,newcv 

cloud_reclassify_v5, newcv_aj,tmp_fract, idxda,idxfirst-1,2,newcv

;foward processing
cloud_reclassify_v5, newcv_aj,tmp_fract, idxda,idxfirst-1, 3,newcv 

cloud_reclassify_v5, newcv_aj,tmp_fract, idxfirst,idxlast, 3,newcv

cloud_reclassify_v5, newcv_aj,tmp_fract, idxlast+1,idxdmin, 4, newcv


;for segment 2, also uses backward and forward no snow ->no snow per Chuck's reguest, JZhu think this shouldn't be done. 2012/10/29.
;cloud_reclassify_v5, newcv_aj,tmp_fract, idxfirst,idxlast, 2,newcv
;cloud_reclassify_v5, newcv_aj,tmp_fract, idxfirst,idxlast, 4,newcv

;check if three segments still include cloud days.Chuck thinks there should not include cloud days, Jzhu thinks it may still have some cloud days.

idxcld=where(newcv EQ 50,cntcld)

;if cntcld GT 0 then begin

;print, 'cloud days ara still there'

;endif

;cloud_reclassify_glacial,newcv 

 cloud_reclassify_glacial_v2,newcv

;calcualte new SOCCSa and EOCCSa

;idx_soccsa=find_forward_consequtive_snow_v2(newcv,tmp_fract, tmp_albed, bnames,16)

;idx_eoccsa=find_backward_consequtive_snow_v2( newcv, tmp_fract, tmp_albed, bnames,16)

;tmp_a=dayrange(day_str,idx_soccsa,idx_eoccsa)

;vmetrics(12)=tmp_a.on_day
;vmetrics(13)=tmp_a.end_day

;--- check if soccs change after cloud filtering

;if idxfirst NE idx_soccsa or idxlast NE idx_eoccsa then begin
;print, 'soccs or eoccs changed!'
;endif

;------ snow_metrics

snow_metrics_calcu, tmp_cover, newcv, tmp_fract, tmp_albed, tmp_quali,bnames, day_str, type_flg, newfract,vmetrics

mid_cover=newcv
mid_fract=newfract
mid_bname=bnames

return

end

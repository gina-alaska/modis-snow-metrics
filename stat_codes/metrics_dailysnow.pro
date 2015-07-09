;user_metrics.pro 
;Author: jiang zhu, 2/17/2011, jiang@gina.alaska.edu
;This program calculates the metrics of a time-series vector.
;inputs are v (smoothed vector),v2 (original vector),bn (band name vector).
;output is out_v(a 12-element vector).
;out_v=[onp,onv,endp,endv,durp,maxp,maxv,ranv,rtup,rtdn,tindvi,mflg]
;The 12 elements are:
;0=onp(time of onset of greenness),
;1=onv(NDVI value at onset),
;2=endp(time of end of greenness),
;3=endv(NDVI value at end),
;4=Durp(duration of greenness),
;5=Maxp(Time of maximum NDVI),
;6=maxv(Maximum NDVI Value),
;7=ranv(range of NDVI values),
;8=rtup(rate of grrenup),
;9=rtdn(rate of senescense),
;10=tindvi(time-integrated NDVI),
;11=mflg(data valid flag,0--no-sense metrics,1--valid metrics)


;jzhu, 5/5/2011, use program provided by Aym to calculate the moving average and crossover 



pro metrics_dailysnow, tmp_interp,tmp_cover,bn,out_v
   ;metrics_dailysnow, tmp_interp,tmp_cover,bnames,vmetrics
;---tmp_interp is snow fractional  data in one-year vector
;---tmp_cover is the classification value of one-year vector
;---bn is the band name of the one-year vector
               
;assume normally snow season is 180, so wl=[185,185]

wl=[185,185]

;wl is decided by Reed, B.C.Measure phenological variability from satellite imagery,1994, 703, J. vegetation Science 5
           ;jzhu, wl impacts the SOS and EOS, normally, sos is 102 days, eos is 280 days, days of noe green =102+ (365-280)=187
           ; 187/7=27, so choose wl=[28,30], because end of season sharply declines, use longer time average do not affect determine the location
           ; of EOS, longer average makes average more greather than data, so gurrantee the eos is corrrect.

;----------------------
num_point=8  ; user determined values
rate=20.0    ; because fraction is 0 to 100, so rate=20.0 means you set threshold rate as 20%, which is normal threshold rate for start of snow season
;----------------------
;jzhu, 8/29, 2011, call determine_wl.pro to estimate wl for each ndvi
;wl=determine_wl(ndvi, threshold_val)

bpy=365        ; bands per year

CurrentBand=1
DaysPerBand=1  ; day interval between two consecituve bands = 1 day

;---get the day between two 7-day band

intv_day = fix( strmid( bn(1),5,3 ) )-fix(strmid( bn(0),5,3 ) ) 

;This is the interval days between two measurement weeks. The band name format is:n-yyyy-ddd-ddd.

start_year=fix(strmid( bn(0),0,4) ) ; this is the year of the first date 
start_day =fix(strmid( bn(0),5,3) ) ; this is the day of the first date 

;---define out_v 

out_v=fltarr(12) ; used to store metrics, initial value out_v(*)=0

;---inital metrics valid flag

mflg=0    ; initial value 0, 0---not valid metrics, 1-- valid metrics

;---sometimem elements in v have the same values, or max(v)*sfactor LT 0.5, do not calculate metrics,return

;--jzhu, talk to Dave, this condition may not correct. because ndvi in tundra region may be lower than 0.4

;if min(ndvi) EQ max(ndvi) or max(ndvi) LT metrics_cal_threshold then begin  ; if maximun ndvi < 0.4, 
;return
;endif

;threshold_val=max(ndvi)/3.0

;wl=determine_wl(ndvi,threshold_val)


;metrics=ComputeMetrics_snowmetrics(tmp_interp,tmp_cover, bn, wl,bpy,CurrentBand,DaysPerBand)


metrics=comput_snowmetrics_consecutivesnowpoint(tmp_interp, tmp_cover, bn, wl,num_point,rate,bpy,DaysperBand,CurrentBand )
;Comput_snowmetrics_consecutivesnowpoint,snow, bq, bn, wl, num_point,rate,DaysPerBand, CurrentBand

;ComputeMetrics_snowmetrics, snow, bq, bn, wl, bpy, CurrentBand, DaysPerBand;dt
;convert sost->onp, sosn->onv, eost->endp,eosn->endv

onp=metrics.sost
onv=metrics.sosn
endp=metrics.eost
endv=metrics.eosn

;---calculate NDVI of onset


;onv=( ndvi(onp)+a )*sfactor

;---calculate NDVI of end-of-greenness

;endv=( ndvi(endp)+a )*sfactor

;---get additional condition to make sure the metrics calculation is resonable. default condition is
;---the end-of-greenness -stsrt-of-grenness must greater than 42 days.
if endp LE 0 or onp LE 0 or endp -onp LE 42 then begin

return

endif 


;---calculate durp, 

;rangeday = metrics.rangeT

maxp=metrics.maxt

maxv=metrics.maxn


;---use onp,maxp,endp to judge if the metrics are correct

;condi= onp LT maxp and maxp LT endp
;if condi EQ 0B then begin  ; not valid metrics
;return
;endif

;---continue to calculate other metrics

mflg=1 ; valid metrics

out_v(11)=1 ; valid metrics data flag


;---convert onp, endp, maxp into related day labels, because onp,endp,maxp are float data, they indicate exect day




;onpday = finddate(bn, onp) ;yyyy.ddd
;endpday= finddate(bn,endp);yyyy.ddd

maxpday= finddate(bn,maxp);yyyy.ddd

day_range = dayrange(bn,onp,endp) ;



;if maxv-onv GE maxv-endv then begin
;ranv= maxv-onv                  ; unit ndvi                    
;endif else begin
;ranv=maxv-endv                  ; unit ndvi          
;endelse

ranv =metrics.rangeN

rtup= metrics.slopeup     ; positive, ndvi/day

rtdnp=-metrics.slopedown  ; negative, ndvi/day

tindvi=metrics.totalndvi ;ndvi*day


out_v[0]=day_range.on_day ;unit day
out_v[1]=onv    ;normalized ndvi
out_v[2]=day_range.end_day ;unit day
out_v[3]=endv   ;normoalized ndvi
out_v[4]=day_range.day_range  ;unit day
out_v[5]=maxpday ;unit day
out_v[6]=maxv ; normalized ndvi
out_v[7]=ranv; normalized ndvi
out_v[8]=rtup; slopeup, ndvi/day
out_v[9]=rtdnp ;slopedown, ndvi/day 
out_v[10]=tindvi; ndvi*day
 
return

end
 

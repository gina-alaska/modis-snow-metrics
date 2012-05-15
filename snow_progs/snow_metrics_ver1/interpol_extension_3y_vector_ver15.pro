;This program process a vector, it get rid of no-sense point such as -2000 (80), intepolate with adjunct points
;This program do not call oneyear_extension, that means do not interpolate jan,nov,and dec into feb to oct data series
;do interpolate, interpolate threshold, if all time series are threshold values, means this pixel is not vegitation, perhaps water, do not calcualte metrics of this pixel
;threshold is fill value, do not do interpolate, snowcld=60, need interpolate, for points with 81-100, need interpolate
 

pro interpol_extension_3y_vector_ver15, three_year_cb, three_year_bn,threshold,snowcld,v_interp,v_bq_interp,v_bname_interp,ratio, mid_stnum,mid_ednum,flg_metrics

;input: three_year--- input vector, return data stored in v_interp, threshold--- get rid of those points with value below threshold, then interpol
;       three_year_bn----band names of elements of vector
;output: v_interp---- result vector, v_bname_interp --- result of band names

;----- interpol into a complete year, 52 bands/year, so three year will be 52*3 bands

;-- located start and end idx for three years,

;---- for 7day per period, it has 52 period per year, before calcualte, interpol beginning and ending missing values

;ndvi flag: 0b- valid, 1b-cloudy,2b-bad quality,3b-negative reflectance,4b-snow,10b-fill, from eMODIS documentation


;----determine if we calculate ndvi metrics

flg_metrics= 0 ; initial not calculate metrics 

numofthreeyrcb=n_elements(three_year_cb)

;--- data in three_year are 1yr ndvi,1y bq, 2yr ndvi,2yr bq, 3yr ndvi, 3yr bq
;use three_year_bn to determine the size of 1,2,3 year

;--- first year
fetch1yrdata, three_year_cb,three_year_bn, 0, yr1num,yr1ndvi,yr1bq,yr1bn
;--- second year
fetch1yrdata, three_year_cb,three_year_bn, 1, yr2num,yr2ndvi,yr2bq,yr2bn
;--- third year
fetch1yrdata, three_year_cb,three_year_bn, 2, yr3num,yr3ndvi,yr3bq,yr3bn

;----- for fill pixels, do not calculate ndvi, just extend the band name to one year ---

;----- call oneyear_extension

oneyear_extension_ver15, yr1ndvi, yr1bq, yr1bn, bf_stnum, bf_ednum, days_bf

oneyear_extension_ver15, yr2ndvi, yr2bq, yr2bn, mid_stnum,mid_ednum,days_mid

oneyear_extension_ver15, yr3ndvi, yr3bq, yr3bn, af_stnum, af_ednum, days_af

;------ joint three years of vectors

vcomp=[yr1ndvi,yr2ndvi,yr3ndvi]

vcomp_bq=[yr1bq, yr2bq, yr3bq]

vcomp_bn=[yr1bn,yr2bn,yr3bn]

daycom=[days_bf,days_mid,days_af]


;----determine if calculate interpolate

yr2num = (size(yr2ndvi))(1)

idx10=where(yr2bq EQ 10b or yr2bq EQ 20b,cnt10)

if cnt10 EQ  yr2num then begin   ; all of points in vector is fill pixel, do not calculate interpolate

flg_metrics=0
v_interp   =   vcomp
v_bq_interp =  vcomp_bq
v_bname_interp= vcomp_bn

return

endif   


; calculate interpolate, but if valid is less than or equal to 5, set flg_metrics=0

idxv=where(yr2bq EQ 0b or yr2bq EQ 4b,cntv)

if cntv GT 0 then begin

idxpos=where(yr2ndvi(idxv) GT 100b, cntpos)

if cntpos GT 5 then begin

flg_metrics=1

endif

endif

;---interpolate un-extended vector

cutoff_interp_ver15,vcomp,vcomp_bq,vcomp_g

;----- output interpolated data

v_interp=vcomp_g  ; processed vector to v
v_bq_interp = vcomp_bq ; ndvi type vector
v_bname_interp=vcomp_bn ;

return

end
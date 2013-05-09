;this subroutine calculates the snow metrics
;snow metrics ae defined as: fss_f,fss_l,fss_range, css_f,css_l,css_range,days_snowon,flg_metrics
;flg_metrics=-1, no data, flg_metrics=0, not valid data, flg_metrics=1, valid metrics data
   
pro snow_metrics_calcu, cover, newcv, fract, albed, quali, bname, day_str, type_flg,newfract, metrics

;---- define the constants

snow=200
night=11
no_snow=25
cloud=50
fill=255
saturated=254

;---0. get the resonable range for first_idx: current 8/1 to next 1/31, last_idx:next 2/1- next 7/31
;yyyy=strmid(bname(0),0,4) ;
;yyyyn= string(fix(yyyy)+1, format='(I4)')

;---first_idx range current 8/1 to next 1/31 
;ddd='214'  ; current 8/1
;first_idx_st = cal_index_for_day(bname,ddd,1)

;ddd='031'  ; next 1/31
;first_idx_ed = cal_index_for_day(bname,ddd,0)

;---the last_idx range next 2/1 to next 7/31
;ddd='032'  ; next 2/1
;last_idx_st = cal_index_for_day(bname,ddd,0)

;ddd='213'  ; next 7/31
;last_idx_ed = cal_index_for_day(bname,ddd,0)


;---- reasonable css range, next 1/31 to next 2/15

;ddd='031'  ; next 1/31
;css_st= cal_index_for_day(bname,ddd,0)

;ddd='045'  ; next 2/15
;css_ed = cal_index_for_day(bname,ddd,0)


;----1. use newcv to determine the index of first and last snow days 
;bnames_metrics = ['first_day','last_day','fss_range','css_first_day','css_last_day','css_day_range','snow_days','no_snow_days','reserved','mflag']

num=n_elements(newcv)

first_idx = -1

last_idx  = -1  ; initial values 

;-- have snow day, get the first_day, last_day, and fss_days

;---looking for the possible first and last snow days:must be snow, fraction of snow >=50%, and albedo >=30%

;idx=where(newcv EQ 200 and $
;          fract GE 50  and $
;          albed GE 30, cnt)


idx=where(newcv EQ 200,cnt)

if cnt EQ 0 then begin  ;<1> not any "snow" day

  snow_flag = 10 ; no snow
  metrics[6] = 0; num of snow days
  metrics[7] =num ; num of no-snow days
  metrics[9]= snow_flg + type_flg 

endif else begin ;<1>


first_idx=idx(0) ;

last_idx = idx(n_elements(idx)-1 )

;---calculate first_day, last_day, and fss_days
fss=dayrange(day_str,first_idx,last_idx)
first_day=fss.on_day
last_day =fss.end_day
fss_days =fss.day_range

if first_day GT 639 or last_day GT 639 then begin

print, 'wrong, check it!'

endif


;--- calculate css first and last day
;
;method 1
;get_css_indics, newcv, first_idx,last_idx,stidx, edidx
;if stidx LT css_st or stidx GT css_ed or edidx LT css_st or edidx GT css_ed then begin
;newfract=fract
;metrics=0
;return
;endif

;method 2
;
 get_css_indics_v5, newcv, fract, albed, quali, bname, first_idx, last_idx, 14,           2,      num_css,stidx, edidx, totnumsnow,totnosnow,totcloud
;get_css_indics_v4, newcv, fract, albed, quali, bname, first_idx, last_idx, css_snow_day ,gapday, num_css,stidx, edidx, totnumsnow

if stidx LT first_idx or $
   edidx GT last_idx  or $
   stidx EQ -1        or $
   edidx EQ -1 then begin ; <2> only have snow days, but not have css, mflg=0

;have only broken-snow

snow_flg=20 ; have only broken-snow

metrics[0]=first_day
metrics[1]=last_day
metrics[2]=fss_days
metrics[3]=0
metrics[4]=0
metrics[5]=0

newfract=fract
;---calcualte snow days and no-snow days

;snowidx= where(newfract GT 0 and newfract LE 100, snowcnt)
;if snowcnt GT 0 then begin ; <3>
;metrics(6)=snowcnt  ;  snow days

metrics(6)=totnumsnow

;-----calcualte no-snow days

metrics(7)=totnosnow

;---css_segment_num

metrics(8)=num_css

metrics(9)= snow_flg +type_flg ;have only broken-snow 

metrics(10) = totcloud
return

endif else begin ;<2> have snow days and css 

;---have both snow days and css
snow_flg=30  ;have css_snow

;--- calcualte newfract---------
newfract=cal_fract(fract,stidx,edidx)
 
;;bnames_metrics = ['first_day','last_day','day_range','css_first_day','css_last_day','css_day_range','snow_days','no_snow_days','mflag']
;----calculate css_first_day, css_last_day, and css_days
css = dayrange(day_str,stidx,edidx )   
css_first=css.on_day
css_last =css.end_day
css_days=css.day_range

if css_first GT 639 or css_last GT 639 then begin

print,'wrong, check it!'

endif



metrics[0]=first_day
metrics[1]=last_day
metrics[2]=fss_days

metrics[3]=css_first
metrics[4]=css_last
metrics[5]=css_days

;-----calcualte snow days
;snowidx= where(newfract GT 0 and newfract LE 100, snowcnt)
;if snowcnt GT 0 then begin
;metrics(6)=snowcnt  ;  snow days

metrics[6]=totnumsnow

;-----calcualte no-snow days
metrics(7)=num -totnumsnow

;---css_segment_num

metrics(8)=num_css

;----set mflag as valid

metrics[9]= snow_flg + type_flg  ; have css

return

endelse ;<2>

endelse ;<1> 

return
end
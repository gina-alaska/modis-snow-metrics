;Jinag Zhu, jiang@gina.alaska.edu, 11/21/2011
;This program interpolates and smoothes an one_year_dailysnow_stack file and calculate snow metrics of the year.
;The input is:
;one_year_dailysnow_stack file;
;the output is:
;one-year_dailysnow_smoothed
;one_year_dailysnow_metrics

;This program breaks the huge data into tiles and goes through tile loop to proces each tile.

;This program modify on 2012/5/16, from smooth_calculate_snowmetrics_tile_terra_aqua.pro, it just process terra data.

pro smooth_calculate_snowmetrics_tile_terra_only,filen,flg
;input: filen---one_year_dailysnow_stack
;outputs: a smoothed file (filen+'_smooth'),
;a metrics file (filen+'_metrics'),
;flg (indicate if the program run successful, 0--successful, 1--not successful)




;test
;terra files
filen_cover='/wrkdir/jzhu/nps/snow-metrics/2009/terra/2009_snow_cover'
filen_fract='/wrkdir/jzhu/nps/snow-metrics/2009/terra/2009_snow_fract'
filen_quali='/wrkdir/jzhu/nps/snow-metrics/2009/terra/2009_snow_quali'
filen_albed='/wrkdir/jzhu/nps/snow-metrics/2009/terra/2009_snow_albed'

;aqua files
;filen_cover_a='/wrkdir/jzhu/nps/snow-metrics/2009/aqua/2009_snow_cover'
;filen_fract_a='/wrkdir/jzhu/nps/snow-metrics/2009/aqua/2009_snow_fract'
;filen_quali_a='/wrkdir/jzhu/nps/snow-metrics/2009/aqua/2009_snow_quali'
;filen_albed_a='/wrkdir/jzhu/nps/snow-metrics/2009/aqua/2009_snow_albed'



;---- initial envi,

;---make sure the program can work in both windows and linux.

if !version.OS_FAMILY EQ 'Windows' then begin

sign='\'

endif else begin
sign='/'

endelse

;----produces output file names: smooth data file name and metrics file name.

p =strpos(filen_cover,sign,/reverse_search)

len=strlen(filen_cover)

wrkdir=strmid(filen_cover,0,p+1)

filebasen=strmid(filen_cover,p+1,len-p)

year=strmid(filebasen,0,4)

;----open smooth file and metrics file to ready to be writen.

fileout_cover=wrkdir+filebasen+'_cover'

openw,unit_cover,fileout_cover,/get_lun


fileout_smooth=wrkdir+filebasen+'_smooth'

openw,unit_smooth,fileout_smooth,/get_lun


fileout_metrics=wrkdir+filebasen+'_metrics'

openw,unit_metrics,fileout_metrics,/get_lun

;---start ENVI batch mode
 
start_batch, wrkdir+'b_log',b_unit

;---setup a flag to inducate this program work successful. flg=0, successful, flg=1, not successful

flg=0;  0----successs, 1--- not sucess


;---open the terra files

;open4files,filen_cover,filen_fract,filen_quali,filen_albed,tile_id_cover,tile_id_fract,tile_id_quali,tile_id_albed,xstart,ystart,dims,ns,nl,nb,bnames,num_of_tiles,flg 

open_one_file,filen_cover,rt_fid_cover,tile_id_cover,xstart,ystart,dims,ns,nl,nb,bnames,num_of_tiles,intlv,flg_cover

open_one_file,filen_fract,rt_fid_fract,tile_id_fract,xstart,ystart,dims,ns,nl,nb,bnames,num_of_tiles,intlv,flg_fract

open_one_file,filen_quali,rt_fid_quali,tile_id_quali,xstart,ystart,dims,ns,nl,nb,bnames,num_of_tiles,intlv,flg_quali

open_one_file,filen_albed,rt_fid_albed,tile_id_albed,xstart,ystart,dims,ns,nl,nb,bnames,num_of_tiles,intlv,flg_albed

if flg_cover EQ 1 or flg_fract EQ 1 or flg_quali EQ 1 or flg_albed EQ 1 then begin   ; not open files successfully, quit

return

endif


;-----open and get the information of aqua files

;open4files,filen_cover_a, filen_fract_a,filen_quali_a,filen_albed_a,tile_id_cover_a,tile_id_fract_a,tile_id_quali_a,tile_id_albed_a,xstart_a,ystart_a,dims_a,ns_a,nl_a,nb_a,bnames_a,num_of_tiles_a,interleave,flg 

;open_one_file,filen_cover_a,rt_fid_cover_a,tile_id_cover_a,xstart_a,ystart_a,dims_a,ns_a,nl_a,nb_a,bnames_a,num_of_tiles_a,intlv_a,flg_cover

;open_one_file,filen_fract_a,rt_fid_fract_a,tile_id_fract_a,xstart_a,ystart_a,dims_a,ns_a,nl_a,nb_a,bnames_a,num_of_tiles_a,intlv_a,flg_fract

;open_one_file,filen_quali_a,rt_fid_quali_a,tile_id_quali_a,xstart_a,ystart_a,dims_a,ns_a,nl_a,nb_a,bnames_a,num_of_tiles_a,intlv_a,flg_quali

;open_one_file,filen_albed_a,rt_fid_albed_a,tile_id_albed_a,xstart_a,ystart_a,dims_a,ns_a,nl_a,nb_a,bnames_a,num_of_tiles_a,intlv_a,flg_albed

;if flg_cover EQ 1 or flg_fract EQ 1 or flg_quali EQ 1 or flg_albed EQ 1 then begin   ; not open files successfully, quit
;return
;endif

;---define a data buff to store the band names of the metrics, bnames_metrics=strarry(9)

bnames_metrics = ['first_day','last_day','fss_range','css_first_day','css_last_day','css_day_range','snow_days','no_snow_days','reserved','mflag']
vmetrics=intarr(10);

;---tile loop, goes through each tile to process

for i=0l, num_of_tiles-1 do begin  ; every line

;data=envi_get_slice(/BIL,fid=rt_fid,line=i)
;define data arraies to hold one tile of terra data
data_cover = envi_get_tile(tile_id_cover, i)
data_fract = envi_get_tile(tile_id_fract, i)
data_quali = envi_get_tile(tile_id_quali, i)
data_albed = envi_get_tile(tile_id_albed, i)  

sz=size(data_fract)
num_band=sz(2) ; number of points in a time-series vector

;define data arraies to hold one tile of aqua data
;data_cover_a = envi_get_tile(tile_id_cover_a, i)
;data_fract_a = envi_get_tile(tile_id_fract_a, i)
;data_quali_a = envi_get_tile(tile_id_quali_a, i)
;data_albed_a = envi_get_tile(tile_id_albed_a, i)

;print, 'process '+strtrim(string(i),2)+ $
;       ' of total tile '+ strtrim(string(num_of_tiles),2)


;---time-series-vector loop, process each time-series-vector in the tile i

for j=0l, sz(1)-1 do begin

;---print out the information about which tile and which time-series vector is being processed.
;---image(s,l) ---s-sample = j, l-line =tiles
print, 'process '+strtrim(string(i),2)+ $
       ' of total tile '+ strtrim(string(num_of_tiles),2) + ', sample: '+strtrim(string(j),2)

if i EQ 2909 and j EQ 4054 then begin

print,'check!'

endif


;--- convert terra time-series data into vectors
tmp_cover=transpose(data_cover(j,*) ) ; band vector
tmp_fract=transpose(data_fract(j,*) ) ; band vector
tmp_quali=transpose(data_quali(j,*) ) ; band vector
tmp_albed=transpose(data_albed(j,*) ) ; band vector

;----covert aqua time-series data into a vectors 
;tmp_cover_a=transpose(data_cover_a(j,*) ) ; band vector
;tmp_fract_a=transpose(data_fract_a(j,*) ) ; band vector
;tmp_quali_a=transpose(data_quali_a(j,*) ) ; band vector
;tmp_albed_a=transpose(data_albed_a(j,*) ) ; band vector

;----replace cloud pixels in terra with snow/no_snow pixels at the same locations in aqua
;replace_cloud_by_aqua_v2, tmp_cover,tmp_fract,tmp_quali,tmp_albed,bnames,tmp_cover_a,tmp_fract_a,tmp_quali_a,tmp_albed_a, bnames_a


; time_series_oneyear_dailysnow calculate snow metrics and return fract, bname

time_series_oneyear_dailysnow_kp,tmp_cover,tmp_fract,tmp_quali,tmp_albed,bnames,mid_cover,mid_smooth,mid_bname,vmetrics

;---define data_smoothed to store smoothed data if it is the first time-series vector process

if i EQ 0l and j EQ 0l then begin  ; the very first sample loop, only execuated once

nb_smooth =n_elements(mid_smooth)
bnames_smooth=mid_bname
out_cover =bytarr(sz(1),nb_smooth)
out_smooth=bytarr(sz(1),nb_smooth)
nb_metrics=n_elements(vmetrics)
out_metrics=intarr(sz(1),nb_metrics)

;---output head info file for smooth data
map_info=envi_get_map_info(fid=rt_fid_cover)
;---output cover data header
data_type=1 ; btye type for cover
envi_setup_head, fname=fileout_cover, ns=ns, nl=nl, nb=nb_smooth,bnames=bnames_smooth, $
    data_type=data_type, offset=0, interleave=(intlv > 1),$
    xstart=xstart+dims[1], ystart=ystart+dims[3],map_info=map_info, $
    descrip='one-year cover data', /write
;---output fract data header
data_type=1 ; btye type for smooth
envi_setup_head, fname=fileout_smooth, ns=ns, nl=nl, nb=nb_smooth,bnames=bnames_smooth, $
    data_type=data_type, offset=0, interleave=(intlv > 1),$
    xstart=xstart+dims[1], ystart=ystart+dims[3],map_info=map_info, $
    descrip='one-year fract data', /write
;---output header to metrics file
data_type=2 ; integer for metrics
envi_setup_head, fname=fileout_metrics, ns=ns, nl=nl, nb=nb_metrics,bnames=bnames_metrics, $
    data_type=data_type, offset=0, interleave=(intlv > 1),$
    xstart=xstart+dims[1], ystart=ystart+dims[3],map_info=map_info, $
    descrip='one-year metrics data', /write


endif

out_cover(j,*)  = mid_cover

out_smooth(j,*) = mid_smooth

out_metrics(j,*) = vmetrics

endfor  ; sample loop

;---write data_smooth of one tile

writeu,unit_cover, out_cover

writeu,unit_smooth,out_smooth

writeu,unit_metrics,out_metrics


endfor  ; line loop

;---close files

free_lun, unit_cover

free_lun, unit_smooth

free_lun, unit_metrics

envi_tile_done, tile_id

;---- exit batch mode

ENVI_BATCH_EXIT

print,'finishing smoothing and calculating metrics ...'

return

end


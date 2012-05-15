;Jinag Zhu, jiang@gina.alaska.edu, 11/21/2011
;This program interpolates and smoothes an one_year_dailysnow_stack file and calculate snow metrics of the year.
;The input is:
;one_year_dailysnow_stack file;
;the output is:
;one-year_dailysnow_smoothed
;one_year_dailysnow_metrics

;This program breaks the huge data into tiles and goes through tile loop to proces each tile.

pro smooth_calculate_snowmetrics_tile,filen,flg

;test

filen_cover='/mnt/pod/snow_products/terra/daily/wrkdir/2009_snow_cover'
filen_fract='/mnt/pod/snow_products/terra/daily/wrkdir/2009_snow_fract'
filen_quali='/mnt/pod/snow_products/terra/daily/wrkdir/2009_snow_quali'
filen_albed='/mnt/pod/snow_products/terra/daily/wrkdir/2009_snow_albed'

;input: filen---one_year_dailysnow_stack
;outputs: a smoothed file (filen+'_smooth'),
;a metrics file (filen+'_metrics'),
;flg (indicate if the program run successful, 0--successful, 1--not successful)

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


;---open the input file

envi_open_file,filen_cover,r_fid=rt_fid_cover


if rt_fid_cover EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif

;---open the input file

envi_open_file,filen_fract,r_fid=rt_fid_fract


if rt_fid_fract EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif

;---open the input file filen_quali

envi_open_file,filen_quali,r_fid=rt_fid_quali


if rt_fid_quali EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif

;---open the input file filen_albed

envi_open_file,filen_albed,r_fid=rt_fid_albed


if rt_fid_albed EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif


;envi_select,fid=rt_fid,pos=pos,dims=dims

;envi_file_query,rt_fid,dims=dims,nb=nb,ns=ns,nl=nl,fname=fn,bnames=bnames

;---get the information of the input file

envi_file_query, rt_fid_cover,data_type=data_type, xstart=xstart,ystart=ystart,$
                 interleave=interleave,dims=dims,ns=ns,nl=nl,nb=nb,bnames=bnames
pos=lindgen(nb)

tile_id_cover = envi_init_tile(rt_fid_cover, pos, num_tiles=num_of_tiles, $
    interleave=(interleave > 1), xs=dims(1), xe=dims(2), $
    ys=dims(3), ye=dims(4) )

envi_file_query, rt_fid_fract,data_type=data_type, xstart=xstart,ystart=ystart,$
                 interleave=interleave,dims=dims,ns=ns,nl=nl,nb=nb,bnames=bnames
pos=lindgen(nb)

  tile_id_fract = envi_init_tile(rt_fid_fract, pos, num_tiles=num_of_tiles, $
    interleave=(interleave > 1), xs=dims(1), xe=dims(2), $
    ys=dims(3), ye=dims(4) )
    
envi_file_query, rt_fid_quali,data_type=data_type, xstart=xstart,ystart=ystart,$
                 interleave=interleave,dims=dims,ns=ns,nl=nl,nb=nb,bnames=bnames
pos=lindgen(nb)

  tile_id_quali = envi_init_tile(rt_fid_quali, pos, num_tiles=num_of_tiles, $
    interleave=(interleave > 1), xs=dims(1), xe=dims(2), $
    ys=dims(3), ye=dims(4) )    
    
envi_file_query, rt_fid_albed,data_type=data_type, xstart=xstart,ystart=ystart,$
                 interleave=interleave,dims=dims,ns=ns,nl=nl,nb=nb,bnames=bnames
pos=lindgen(nb)

  tile_id_albed = envi_init_tile(rt_fid_albed, pos, num_tiles=num_of_tiles, $
    interleave=(interleave > 1), xs=dims(1), xe=dims(2), $
    ys=dims(3), ye=dims(4) )  



;---define a data buff to store the band names of the metrics, bnames_metrics=strarry(9)

bnames_metrics = ['first_day','last_day','fss_range','css_first_day','css_last_day','css_day_range','snow_days','no_snow_days','reserved','mflag']
vmetrics=intarr(10);

;---tile loop, goes through each tile to process

for i=0l, num_of_tiles-1 do begin  ; every line

;data=envi_get_slice(/BIL,fid=rt_fid,line=i)

data_cover = envi_get_tile(tile_id_cover, i)
data_fract = envi_get_tile(tile_id_fract, i)
data_quali = envi_get_tile(tile_id_quali, i)
data_albed = envi_get_tile(tile_id_albed, i)  

sz=size(data_fract)

num_band=sz(2) ; number of points in a time-series vector

;---time-series-vector loop, process each time-series-vector in the tile i

for j=0l, sz(1)-1 do begin

;---print out the information about which tile and which time-series vector is being processed.

print, 'process tile: '+strtrim(string(i),2), ', sample: '+strtrim(string(j),2)

if i EQ 7 and j EQ 1818 then begin

print,'check!'

endif


;--- convert a time-series data into a vector

tmp_cover=transpose(data_cover(j,*) ) ; band vector
tmp_fract=transpose(data_fract(j,*) ) ; band vector
tmp_quali=transpose(data_quali(j,*) ) ; band vector
tmp_albed=transpose(data_albed(j,*) ) ; band vector

; time_series_oneyear_dailysnow calculate snow metrics and return fract, bname

time_series_oneyear_dailysnow_kp,tmp_cover,tmp_fract,tmp_quali,tmp_albed,bnames,mid_cover,mid_smooth,mid_bname,vmetrics

;---define data_smoothed to store smoothed data if it is the first time-series vector process

if j EQ 0l then begin  ; the very first sample loop, only execuated once




nb_smooth =n_elements(mid_smooth)

bnames_smooth=mid_bname

out_cover =bytarr(sz(1),nb_smooth)

out_smooth=bytarr(sz(1),nb_smooth)

nb_metrics=n_elements(vmetrics)

out_metrics=intarr(sz(1),nb_metrics)

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


;---output head info file for smooth data

map_info=envi_get_map_info(fid=rt_fid_cover)


;---output smooth data

data_type=1 ; btye type for cover
envi_setup_head, fname=fileout_cover, ns=ns, nl=nl, nb=nb_smooth,bnames=bnames_smooth, $
    data_type=data_type, offset=0, interleave=(interleave > 1),$
    xstart=xstart+dims[1], ystart=ystart+dims[3],map_info=map_info, $
    descrip='one-year cover data', /write



data_type=1 ; btye type for smooth
envi_setup_head, fname=fileout_smooth, ns=ns, nl=nl, nb=nb_smooth,bnames=bnames_smooth, $
    data_type=data_type, offset=0, interleave=(interleave > 1),$
    xstart=xstart+dims[1], ystart=ystart+dims[3],map_info=map_info, $
    descrip='one-year fract data', /write

;--- write head to metrics file
data_type=2 ; integer for metrics
envi_setup_head, fname=fileout_metrics, ns=ns, nl=nl, nb=nb_metrics,bnames=bnames_metrics, $
    data_type=data_type, offset=0, interleave=(interleave > 1),$
    xstart=xstart+dims[1], ystart=ystart+dims[3],map_info=map_info, $
    descrip='one-year metrics data', /write


envi_tile_done, tile_id

;---- exit batch mode

ENVI_BATCH_EXIT

print,'finishing smooth and calculation of metrics ...'

return

end


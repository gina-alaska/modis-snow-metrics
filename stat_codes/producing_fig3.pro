pro producing_fig3, filen

;filen is 3d array snow cover file, such as 2012_snow_cover and 2012_snow_cover.hdr
;

data_fn='/center/w/jzhu/nps/snow_metrics/2012/2012_snowyear__stat2'


;landmsk_fn='/import/c/w/jzhu/nps/snow_metrics/2012/land_mask'

landmsk_fn='/import/c/w/jzhu/nps/snow_metrics/2012/landmask_nan_by_mflg'

;---start ENVI batch mode
 
start_batch,'b_log',b_unit


;---open the file

envi_open_file,data_fn,r_fid=rt_fid

if rt_fid EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif

envi_open_file,landmsk_fn,r_fid=landmsk_fid

if landmsk_fid EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif



;---get the information of the terra files

envi_file_query, rt_fid,data_type=data_type1, xstart=xstart1,ystart=ystart1,$
                 interleave=interleave1,dims=dims1,ns=ns1,nl=nl1,nb=nb1,bnames=bnames1


envi_file_query, landmsk_fid,data_type=data_type2, xstart=xstart2,ystart=ystart2,$
                 interleave=interleave2,dims=dims2,ns=ns2,nl=nl2,nb=nb2,bnames=bnames2


;pos=lindgen(nb)
;tile_id = envi_init_tile(rt_fid, pos, num_tiles=num_of_tiles, $
;    interleave=(interleave > 1), xs=dims(1), xe=dims(2), $
;    ys=dims(3), ye=dims(4) )

; read 3d data file

;dims = [-1, 0, ns-1, 0, nl-1]

;determine if dims1 and dims2 are the same

if ~ARRAY_EQUAL(dims1,dims2) then begin
  
  print, 'Two files do not have the same samples and lines, exit!'
  
  goto, lb1
  
endif  

pct=fltarr(4,nb1)

landmsk = ENVI_GET_DATA(fid=landmsk_fid, dims=dims2, pos=0)

idx_tot=where(landmsk EQ 1,tot_num)

for i=0, nb1-1 do begin
; process band i
;    

print, i

data = ENVI_GET_DATA(fid=rt_fid, dims=dims1, pos=i) 

;if tot_num NE 0 then begin

idx_nosnow=where(data EQ 25 and landmsk EQ 1, nosnow_num)

idx_cloud=where(data EQ 50 and landmsk EQ 1, cloud_num)

idx_snow=where(data EQ 200 and landmsk EQ 1, snow_num)

nodata_num=tot_num-nosnow_num-cloud_num-snow_num

pct(0,i)=100.0*float(cloud_num)/tot_num
pct(1,i)=100.0*float(nodata_num)/tot_num
pct(2,i)=100.0*float(snow_num)/tot_num
pct(3,i)=100.0*float(nosnow_num)/tot_num

;endif 

endfor

;calculate the precentile for each catagory

p=fltarr(5,4) ; 5-min,lower quantile, median,upper quantile, max 4- cloud, no data, snow, snow free


for j=0, 3 do begin
  
  tmpdata=pct(j,*)
  
  s=sort(tmpdata)
  
  num = n_elements(s)
  
  p[*,j]=tmpdata[s[[0, .25 * num, .5 * num, .75 * num, num - 1]]]
  
  
  
endfor  

;output table data as a file

outfile=file_dirname(data_fn)+'/'+file_basename(data_fn)+'-table.dat' 
OPENW,1,outfile 
PRINTF,1,p 
CLOSE,1

;output pct data

outfile=file_dirname(data_fn)+'/'+file_basename(data_fn)+'-pct.dat' 
OPENW,1,outfile 
PRINTF,1,pct 
CLOSE,1

ENVI_BATCH_EXIT

lb1:
end
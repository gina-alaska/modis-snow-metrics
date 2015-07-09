;jzhu, 11/18/2011, this progranm read cover, fract, and quali files, and stack, subset,return three file describers
 
pro read_snowdata,wrkdir,fn_cover,fn_fract,fn_quali,fn_albed, ul,lr, rt_fid_cover,rt_fid_fract,rt_fid_quali, rt_fid_albed

;inputs:
;wrkdir, work_directory
;fn_cover (file name of a *cover.tif file, fn_fract (file name of a *_fractional.tif)
;ul (uper left coordinate in unit of meter),
;lf (lower right coorinate in unit of meter).
;output: rt_fid_cover,rt_fid_fract


;---subseting the file
;ul=[-160.0, 62.0]  ; [lon,lat] of upper left
;lr=[-146.0, 56.0]  ; [lon,lat] of lower right

;--- check t_fid, found map unit of t_fid is meters, so we define ul and lr in meters

;ul=[-206833.75D, 1303877.50D]
;lr=[ 424916.25D,  856877.50D]


if !version.os_family EQ 'Windows' then begin
sign='\'
endif else begin
sign='/'
endelse


;---- initial batch mode

p =strpos(fn_cover,sign,/reverse_search)

;wrkdir=strmid(fn_cover,0,p+1)

;start_batch, wrkdir+'b_log',b_unit

;---open file cover data file, t_fn

envi_open_data_file,fn_cover,r_fid=t_fid


if (t_fid NE -1) then begin

envi_file_query,t_fid,dims=t_dims,nb=t_nb,ns=t_ns,nl=t_nl,data_type=t_dt

endif

;---open file fract file, d_fn

ENVI_OPEN_FILE,fn_fract,R_FID=d_fid

if (d_fid NE -1) then begin

envi_file_query,d_fid,dims=d_dims,nb=d_nb,ns=d_ns,nl=d_nl,data_type=d_dt

endif


;---open quanlity file, q_fn

ENVI_OPEN_FILE,fn_quali,R_FID=q_fid

if (q_fid NE -1) then begin

envi_file_query,q_fid,dims=q_dims,nb=q_nb,ns=q_ns,nl=q_nl,data_type=q_dt

endif


;---open albed file, b_fn

ENVI_OPEN_FILE,fn_albed,R_FID=b_fid

if (b_fid NE -1) then begin

envi_file_query,b_fid,dims=b_dims,nb=b_nb,ns=b_ns,nl=b_nl,data_type=b_dt

endif


;---layer stack the four data and output the data into a out_file

file_id=[t_fid,d_fid,q_fid,b_fid]

  nb = t_nb + d_nb + q_nb +b_nb
  
  fid = lonarr(nb)
  pos = lonarr(nb)
  dims = lonarr(5,nb)
  ;
  
  for i=0L,t_nb-1 do begin
    
    fid[i] = t_fid
    pos[i] = i -0
    dims[*,i] = [-1,0,t_ns-1,0,t_nl-1]
  endfor
  ;
  for i=t_nb,t_nb+d_nb-1 do begin
    fid[i] = d_fid
    pos[i] = i-t_nb
    dims[*,i] = [-1,0,d_ns-1,0,d_nl-1]
  endfor
  
  for i=t_nb+d_nb,t_nb+d_nb+q_nb-1 do begin
    fid[i] = q_fid
    pos[i] = i-(t_nb+d_nb)
    dims[*,i] = [-1,0,q_ns-1,0,q_nl-1]
  endfor
  
  for i=t_nb+d_nb+q_nb,nb-1 do begin
    fid[i] = b_fid
    pos[i] = i-(t_nb+d_nb+q_nb)
    dims[*,i] = [-1,0,b_ns-1,0,b_nl-1]
  endfor
  
  
  
  ;
  ; Set the output projection and
  ; pixel size from the TM file. Save
  ; the result to disk and use floating
  ; point output data.
  ;
  out_proj = envi_get_projection(fid=t_fid,pixel_size=out_ps)

  tmp_layer_file = 'layer_'+strtrim(string(t_fid),2)

  out_name = wrkdir+tmp_layer_file

  out_dt=t_dt 
  
  ; Call the layer stacking routine. Do not
  ; set the exclusive keyword allow for an
  ; inclusive result. Use cubic convolution
  ; for the interpolation method.
  ;
 ; envi_doit, 'envi_layer_stacking_doit', $
 ;   fid=fid, pos=pos, dims=dims, $
 ;   out_dt=out_dt, out_name=out_name, $
 ;   interp=2, out_ps=out_ps, $
 ;   out_proj=out_proj, r_fid=r_fid
  ;

 envi_doit, 'envi_layer_stacking_doit', $
    fid=fid, pos=pos, dims=dims, $
    out_dt=out_dt, out_name=out_name, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=layer_fid
  ;


;---determine if doing subset

if ul[0] EQ 0 and ul[1] EQ 0 and lr[0] EQ 0 and lr[1] EQ 0 then begin ; do not do subset

subset_fid=layer_fid

endif else begin   ; do subset

;----- subseting the file

subset,layer_fid,ul,lr,wrkdir,subset_fid ;after exectuate this sunroutine, return file id of subset_image which is stored in memory

endelse

;---- fill snow,cloud,bad, and negative reflectance pixels with -4000

envi_file_query, subset_fid, DIMS=DIMS, NB=NB, NL=NL, NS=NS, data_type=dt

pos = lindgen(nb)

;---- envi_get_data just can get one band each time, so use loop to get all bands
image=bytarr(NS, NL, NB)
FOR i=0, NB-1 DO BEGIN
image[*,*,i]= envi_get_data(fid=subset_fid, dims=dims, pos=pos[i])
endfor

image_cover=image[*,*,0]  ;cover
image_fract=image[*,*,1]  ; fract
image_quali=image[*,*,2]  ; quali
image_albed=image[*,*,3]  ; albed

;---do spatial cloud eliminate algorithm to get rid of the cloud if the adjunct four pixels are not cloud pixels
;spatial_filt_cloud, image_cover, image_fract, image_albedo

sz=size(image_cover)

cols = sz(1) ; j, 0-cols-1 

rows = sz(2) ; i  0-rows-1

cld_idx=where(image_cover EQ 50, cld_cnt)

if cld_cnt GT 0 then begin  ; <11>

for k=0L, cld_cnt-1 do begin ; <12>

j= cld_idx(k) mod cols
i= cld_idx(k)/cols

if j GT 0 and j LT cols-1 and i GT 0 and i LT rows-1 then begin  ; <13>

snow_idx=where([image_cover(j-1), image_cover(j+1), image_cover(i-1), image_cover(i+1)] EQ 200, snow_cnt)

if snow_cnt GE 3 then begin ;<14>

image_cover(j,i)=200

tmpfract= [image_fract(j-1), image_fract(j+1), image_fract(i-1), image_fract(i+1)]
image_fract(j,i) =byte( mean( tmpfract(snow_idx)  ) )

tmpalbed= [image_albed(j-1),image_albed(j+1), image_albed(i-1), image_albed(i+1)]
image_albed(j,i) =byte( mean( tmpalbed(snow_idx)  ) )

endif else begin  ; <14>
 
no_idx=where([image_cover(j-1),image_cover(j+1), image_cover(i-1), image_cover(i+1)] EQ 25, no_cnt)

if no_cnt GE 3 then begin  ;<15>

image_cover(j,i)=25

tmpfract= [image_fract(j-1), image_fract(j+1), image_fract(i-1), image_fract(i+1)]
image_fract(j,i) =byte( mean( tmpfract(no_idx)  ) )

tmpalbed= [image_albed(j-1), image_albed(j+1), image_albed(i-1), image_albed(i+1)]
image_albed(j,i) =byte( mean( tmpalbed(no_idx)  ) )

endif   ;<15>

endelse ; <14>

endif  ; <13>

endfor  ;<12>

endif  ;<11>


;---output image_cover and image_fract into two files


map_info=envi_get_map_info(fid=subset_fid)

;--- output image_cover
out_cover_name = wrkdir+'cover'+strtrim(string(layer_fid),2)
envi_write_envi_file, image_cover, data_type= dt, $
descrip = 'cover', $
map_info = map_info,out_name=out_cover_name, $
nl=nl, ns=ns, nb=1, r_fid=good_fid_cover

;----output image_fract
out_fract_name=wrkdir+'fract'+strtrim(string(layer_fid),2)
envi_write_envi_file, image_fract, data_type= dt, $
descrip = 'fract', $
map_info = map_info,out_name=out_fract_name, $
nl=nl, ns=ns, nb=1, r_fid=good_fid_fract

;----output image_quali
out_quali_name=wrkdir+'quali'+strtrim(string(layer_fid),2)
envi_write_envi_file, image_quali, data_type= dt, $
descrip = 'quali', $
map_info = map_info,out_name=out_quali_name, $
nl=nl, ns=ns, nb=1, r_fid=good_fid_quali


;----output image_albed
out_albed_name=wrkdir+'albed'+strtrim(string(layer_fid),2)
envi_write_envi_file, image_albed, data_type= bt, $
descrip = 'albed', $
map_info = map_info,out_name=out_albed_name, $
nl=nl, ns=ns, nb=1, r_fid=good_fid_albed



;---return image with file id of good_fid,subsized, and only have good ndvi values

rt_fid_cover=good_fid_cover

rt_fid_fract=good_fid_fract

rt_fid_quali=good_fid_quali

rt_fid_albed=good_fid_albed


;---free memory and also delete temperary files, layer_* and subset_*

image=0
image_cover=0
image_fract=0
image_quali=0
image_albed=0

;---close file-ids

envi_file_mng, id=layer_fid, /remove,/delete
envi_file_mng, id=subset_fid,/remove,/delete
envi_file_mng, id=t_fid,/remove
envi_file_mng, id=d_fid,/remove
envi_file_mng, id=q_fid,/remove
envi_file_mng, id=b_fid,/remove

return

end







pro oneyear_snowdata_layer_subset,flist_cover, flist_fract,flist_quali,flist_albed, ul,lr, wrkdir

;This routine open one year snow files defined in file lists, stack these file,subset, and output the one-year snow file 
;which includes a 365*2 bands. 

;inputs: yyyy_flist_cover----file list of snow cover classification of snow year yyyy
;        yyyy_flist_fract----file list of snow fractional cover of snow_year yyyy 
;;;        yyyy_flist_qual ----- file list of snow data quanlity of snow year yyyy

;        ul-----upper left coordinate in unit of meter
;        lr-----lower right cordinate in unit of meter
;
;jzhu, 9/8/2011, subset and stack one-year ndvi and quality flag data respectively, that means we get two stacked one-year data files.


;test
;
;ul=[-206833.75D, 1303877.50D]
;lr=[ 424916.25D,  856877.50D]
;wrkdir='/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/'

flist_cover='/center/w/jzhu/nps/snow-metrics/2009/2009_flist_cover'
flist_fract='/center/w/jzhu/nps/snow-metrics/2009/2009_flist_fract'
flist_quali='/center/w/jzhu/nps/snow-metrics/2009/2009_flist_quali'
flist_albed='/center/w/jzhu/nps/snow-metrics/2009/2009_flist_albed'

wrkdir='/center/w/jzhu/nps/snow-metrics/2009'


;flist_qual ='/home/jiang/nps/cesu/snow_metrics/2009_flist_qual'
ul=0
lr=0


if !version.os_family EQ 'Windows' then begin
sign='\'
endif else begin
sign='/'
endelse

;---- read these two lists into flist and flist_bq


openr,u1,flist_cover,/get_lun
openr,u2,flist_fract,/get_lun
openr,u3,flist_quali,/get_lun
openr,u4,flist_albed,/get_lun


flistcover=strarr(366) ; 366/year
flistfract=strarr(366)
flistquali=strarr(366);
flistalbed=strarr(366);

;---- read flist_cover file into flistcover
tmp=' '
j=0L
while not EOF(u1) do begin
readf,u1,tmp

flistcover(j)=tmp

j=j+1
endwhile

;---- read flist_fract file into flistfract 

tmp=' '
j=0L
while not EOF(u2) do begin
readf,u2,tmp

flistfract(j)=tmp

j=j+1
endwhile

;---- read flist_quali file into flistqual
tmp=' '
j=0L
while not EOF(u3) do begin
readf,u3,tmp
flistquali(j)=tmp
j=j+1
endwhile

;---- read flist_albed file into flistalbed
tmp=' '
j=0L
while not EOF(u4) do begin
readf,u4,tmp
flistalbed(j)=tmp
j=j+1
endwhile



close,u1
close,u2
close,u3
close,u4



flistcover =flistcover[where(flistcover NE '')]
flistfract =flistfract[where(flistfract NE '')]
flistquali =flistquali[where(flistquali NE '')]
flistalbed =flistalbed[where(flistalbed NE '')]

;---- get the number of files

num=(size(flistcover))(1)

;---- get workdir and year from mid-year file

p =strpos(flist_cover,sign,/reverse_search)

len=strlen(flist_cover)

wrkdir=strmid(flist_cover,0,p+1)

filen =strmid(flist_cover,p+1,len-p)

year=strmid(filen,0,4)  ;eMTH_NDVI.2008.036-042.QKM.VI_NDVI.005.2011202142526.tif


;---- define a struc to save info of each file

;p={flists,fn:'abc',sn:0,dims:lonarr(5),bn:0L}

;x=create_struct(name=flist,fn,'abc',fid,0L,dims,lonarr(5),bn,0L)

x={flist,fn:'abc',bname:'abc',fid:0L,dims:lonarr(5),pos:0L}

flista=replicate(x,num) ;save cover data files

flistq=replicate(x,num) ;save fract data files

flistt=replicate(x,num) ;save quality data files

flistb=replicate(x,num); save albedo data files


start_batch  ; into envi batch_mode

;---- go through one year cover and fract files

for j=0L, num-1 do begin

fn_cover = strtrim(flistcover(j),2)

;---- for new data name

str1='.Snow_Cover_Daily_Tile.'
str2='.Fractional_Snow_Cover.'
str3='.Snow_Spatial_QA.'
str4='.Snow_Albedo_Daily_Tile.'

p=strpos(fn_cover,str1)

len=strlen(fn_cover)

file_hdr=strmid(fn_cover,0,p)

file_end =strmid(fn_cover,p+strlen(str1),len-1-strlen(str1) )

fn_fract=file_hdr+str2+file_end

fn_quali=file_hdr+str3+file_end

fn_albed=file_hdr+str4+file_end


idx =where(flistfract EQ fn_fract,cnt)

if cnt EQ 1 then begin

;---- read cover, fract, and qual 

print, 'process the '+string(j)+' th file: ' +fn_cover

;if j EQ 38 then begin
;print,'check 38th file'
;endif

read_snowdata, wrkdir,fn_cover,fn_fract,fn_quali,fn_albed, ul, lr,rt_fid_cover,rt_fid_fract,rt_fid_quali,rt_fid_albed

endif else begin

;---- no relative bq file, do not cut off no-sense points
endelse


;------- save info fo each cover file --------------
envi_file_query,rt_fid_cover,dims=dims,nb=nb,fname=fn,data_type=t_dt

p1=strpos(fn_cover,sign,/reverse_search)

tmpbname= strmid(fn_cover,p1+1,8)  ; for new data, its name looks like:2010-273.Fractional_Snow_Cover.tif

flista[j].fn=fn_cover+'.good'
flista[j].bname=tmpbname
flista[j].fid=rt_fid_cover
flista[j].dims=dims
flista[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate

;-------save info of each fract file------------
envi_file_query,rt_fid_fract,dims=dims,nb=nb,fname=fn,data_type=d_dt

p1=strpos(fn_fract,sign,/reverse_search)
tmpbname= strmid(fn_fract,p1+1,8)
flistq[j].fn=fn_fract+'.good'
flistq[j].bname=tmpbname
flistq[j].fid=rt_fid_fract
flistq[j].dims=dims
flistq[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate

;-------save info of each quali file------------
envi_file_query,rt_fid_quali,dims=dims,nb=nb,fname=fn,data_type=q_dt

p1=strpos(fn_quali,sign,/reverse_search)
tmpbname= strmid(fn_quali,p1+1,8)
flistt[j].fn=fn_quali+'.good'
flistt[j].bname=tmpbname
flistt[j].fid=rt_fid_quali
flistt[j].dims=dims
flistt[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate

;-------save info of each albed file------------
envi_file_query,rt_fid_albed,dims=dims,nb=nb,fname=fn,data_type=b_dt

p1=strpos(fn_albed,sign,/reverse_search)
tmpbname= strmid(fn_albed,p1+1,8)
flistb[j].fn=fn_albed+'.good'
flistb[j].bname=tmpbname
flistb[j].fid=rt_fid_albed
flistb[j].dims=dims
flistb[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate


endfor


; output cover file
; 
;---- layer stacking cover,fract, and quali, seperately.  ------------------

  ; Set the output projection and
  ; pixel size from the TM file. Save
  ; the result to disk and use floating
  ; point output data.
  ;

  ;fist file id is flist[0].fid

  out_proj = envi_get_projection(fid = flista[0].fid,pixel_size=out_ps)

  out_name = wrkdir+year+'_snow_cover'

  out_dt = t_dt

  ;
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
    fid=flista.fid, pos=flista.pos, dims=flista.dims,/EXCLUSIVE, $
    out_dt=out_dt, out_name=out_name,out_bname=flista.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_layer_fid

;---- delete good_* files

for j=0L,num-1 do begin

envi_file_mng,id=flista[j].fid,/remove,/delete

endfor


;output fract file

;---- stack fract together

 ;fist file id is flist[0].fid

  out_proj = envi_get_projection(fid = flistq[0].fid, $
    pixel_size=out_ps)

  out_name = wrkdir+year+'_snow_fract'

  out_dt = d_dt

  ;
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
    fid=flistq.fid, pos=flistq.pos, dims=flistq.dims,/EXCLUSIVE, $
    out_dt=out_dt, out_name=out_name,out_bname=flistq.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_layer_fid

;---- delete good_* files

for j=0L,num-1 do begin

envi_file_mng,id=flistq[j].fid,/remove,/delete

endfor


;output quali file

;---- stack quali together

 ;fist file id is flistt[0].fid

  out_proj = envi_get_projection(fid = flistt[0].fid, $
    pixel_size=out_ps)

  out_name = wrkdir+year+'_snow_quali'

  out_dt = q_dt

  ;
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
    fid=flistt.fid, pos=flistt.pos, dims=flistt.dims,/EXCLUSIVE, $
    out_dt=out_dt, out_name=out_name,out_bname=flistt.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_layer_fid

;---- delete good_* files

for j=0L,num-1 do begin

envi_file_mng,id=flistt[j].fid,/remove,/delete

endfor


;output albed file

;---- stack quali together

 ;fist file id is flistt[0].fid

  out_proj = envi_get_projection(fid = flistb[0].fid, $
    pixel_size=out_ps)

  out_name = wrkdir+year+'_snow_albed'

  out_dt = b_dt

  ;
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
    fid=flistb.fid, pos=flistb.pos, dims=flistb.dims,/EXCLUSIVE, $
    out_dt=out_dt, out_name=out_name,out_bname=flistb.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_layer_fid

;---- delete good_* files

for j=0L,num-1 do begin

envi_file_mng,id=flistb[j].fid,/remove,/delete

endfor

;-------print finish signal

print,'finishing stacking cover and fract files separately...'

envi_batch_exit

return

end
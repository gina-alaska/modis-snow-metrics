pro count_number_of_pixel,file

  start_batch  ; into envi batch_mode

  fn_cover='/home/jzhu4/data/snow_paper/2012_snowyear_sc_stat1'
  ;         '/projects/UAFGINA/nps_snow/snow_paper_data/2012_snow_cover_raw'
  
 
 out_file=fn_cover+'_num'
  
  envi_open_data_file,fn_cover,r_fid=t_fid


  if (t_fid NE -1) then begin

    envi_file_query,t_fid,dims=t_dims,nb=t_nb,ns=t_ns,nl=t_nl,data_type=t_dt

  endif
  
  openw,ounit, out_file,/get_LUN
  
  
  ;---- envi_get_data just can get one band each time, so use loop to get all bands
  pos = lindgen(t_nb)
  
  ;store cloud (0), no_data(1), snow(2), snow_free(3) in dailynum
  ;dailynum=dblarr(4,t_nb)
  
  dailynum=lon64arr(4,t_nb)
  
  image=bytarr(t_NS, t_NL, t_NB)
   
  tot=long64(t_NS*t_NL)
  
  FOR i=0, t_NB-1 DO BEGIN
    image[*,*,i]= envi_get_data(fid=t_fid, dims=t_dims, pos=pos[i])
    
    
    idx=where(image[*,*,i] EQ 50,cnt_cloud)
    
    dailynum[0,i]=cnt_cloud
    
    idx=where(image[*,*,i] EQ 200,cnt_snow)

    dailynum[2,i]=cnt_snow
    
    idx=where(image[*,*,i] EQ 25,cnt_snowfree)

    dailynum[3,i]=cnt_snowfree
    
    dailynum[1,i]=tot-cnt_cloud-cnt_snow-cnt_snowfree
    
  endfor

  ;----calculate
  
  cloud=long64(total(dailynum(0,*)))
  nodata=long64(total(dailynum(1,*)))
  snow =long64(total(dailynum(2,*)))
  snowfree=long64(total(dailynum(3,*)))
  totall=tot*t_NB
  
  totalldb=double(totall)
  ;---output

  printf, ounit, 'total number', totall

  printf, ounit, 'number of cloud: ', cloud, '  percentage: ',cloud/totalldb
  
  printf, ounit, 'number of no data: ', nodata,'  percentage: ', nodata/totalldb
  
  printf, ounit, 'number of snow: ', snow, '  percentage: ', snow/totalldb

  printf, ounit, 'number of snowfree: ',snowfree, ' percentage: ', snowfree/totalldb




free_lun, ounit


end
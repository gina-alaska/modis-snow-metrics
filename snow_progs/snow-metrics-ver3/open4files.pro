pro open4files, filen_cover,filen_fract,filen_quali,filen_albed,tile_id_cover,tile_id_fract,tile_id_quali,tile_id_albed,xstart,ystart,dims,ns,nl,nb,bnames,num_of_tiles,interleave,flg 

flg=0 ; initial value
;---open the terra files

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

;---get the information of the terra files

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

return

end
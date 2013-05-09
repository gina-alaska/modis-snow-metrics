pro open_one_file,filen,rt_fid,tile_id,xstart,ystart,dims,ns,nl,nb,bnames,num_of_tiles,interleave,flg 

flg=0 ; initial value

;---open the terra files

envi_open_file,filen,r_fid=rt_fid

if rt_fid EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif

;---get the information of the terra files

envi_file_query, rt_fid,data_type=data_type, xstart=xstart,ystart=ystart,$
                 interleave=interleave,dims=dims,ns=ns,nl=nl,nb=nb,bnames=bnames
pos=lindgen(nb)

tile_id = envi_init_tile(rt_fid, pos, num_tiles=num_of_tiles, $
    interleave=(interleave > 1), xs=dims(1), xe=dims(2), $
    ys=dims(3), ye=dims(4) )

return

end
function find_indices, array, sub_array

; find the indices in array for sub_array
; 

num=(size(sub_array))(1)

idx_array=intarr(num)

for i=0, num-1 do begin

idx_array(i)=where(array EQ sub_array(i))

endfor

return, idx_array

end
pro plot_fig3, pctfile, mtitle
;this program accepts the statistic file such as 2012_snowyear_gl_stat2-pct.dat as input, plot the bar box plot.
;

pctfile='/import/c/w/jzhu/nps/snow_metrics/2012/2012_snow_raw-pct.dat'

mtitle='unfiltered'

openr, lun, pctfile,/GET_LUN

pct=fltarr(4,366)

readf, lun, pct

close,lun

;output file name

outfile=file_dirname(pctfile)+'/'+file_basename(pctfile,'.dat')+'.pdf' 

;col0-cloud, col1-no data, col2-snow, col3-no snow

;draw stacked barplot
;Define the data set.
cloud = transpose(pct(0,*))
nodata =transpose(pct(1,*)) 
snow = transpose(pct(2,*))
snowfree=transpose(pct(3,*))

;set graphic device and color table

set_plot,'x'

;IDL_GR_X_HEIGHT=768
;IDL_GR_X_WIDTH=1024

;DEVICE, /INCHES, xsize=9, ysize=6.5, FILENAME=outfile, /LANDSCAPE, /COLOR, BITS_PER_PIXEL=8

loadct,0  ;black-white



!p.FONT=-1
!p.CHARSIZE=18

data1=snow

data2=data1+snowfree

data3=data2+cloud

data4=data3+nodata

;data1=data1(0:100)
;data2=data2(0:100)
;data3=data3(0:100)
;data4=data4(0:100)
 
;Plot four bars, stacked.
b1 = BARPLOT(data1, FILL_COLOR='white',BOTTOM_COLOR="white",ytitle='Percentage [%]',name='snow',title=mtitle,$
     xtitle='daily scenes August 1, 2011 to July 31, 2012', font_size=30, axis_style=2,xthick=1,ythick=1)
     ax1=b1.axes
     ax1[0].tickname=['']
b2 = BARPLOT(data2, BOTTOM_VALUES=data1, FILL_COLOR='light grey',BOTTOM_COLOR="light grey", name='snowfree', /OVERPLOT)
b3 = BARPLOT(data3, BOTTOM_VALUES=data2, FILL_COLOR='dark gray',BOTTOM_COLOR="dark gray",name='cloud',/OVERPLOT)
b4 = BARPLOT(data4, BOTTOM_VALUES=data3, FILL_COLOR='black',BOTTOM_COLOR="black",name='no data',/OVERPLOT)


 ; Define the data set.
;data1 = SIN((FINDGEN(15)+1)/15*!PI/2)
;data2 = data1 + COS((FINDGEN(15))/15*!PI/2)
;data3 = data2 + 0.25 + RANDOMU(1,15)
 
; Plot three bars, stacked.
;b1 = BARPLOT(data1, BOTTOM_COLOR="white")
;b2 = BARPLOT(data2, BOTTOM_VALUES=data1, $
;FILL_COLOR='yellow', BOTTOM_COLOR="white", /OVERPLOT)
;b3 = BARPLOT(data3, BOTTOM_VALUES=data2, $
;FILL_COLOR='red', BOTTOM_COLOR="white", /OVERPLOT)
 



; Add a title.
;b1.TITLE=mtitle
;b1.xtitle='July 31, 2011 to Auguest 31, 2012'

leg = LEGEND(TARGET=[b1,b2,b3,b4], POSITION=[130.0,10.0], orientation=1,font_size=18, /DATA, /AUTO_TEXT_COLOR)

;xaxis=axis('X',LOCATION=-0.1)
  
;DEVICE,/close_file

b1.save, outfile,/APPEND
b2.save, outfile,/APPEND
b3.save, outfile,/APPEND
b4.save, outfile,/APPEND,/CLOSE


close,/ALL

end
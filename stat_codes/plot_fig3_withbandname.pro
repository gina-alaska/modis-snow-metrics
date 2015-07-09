pro plot_fig3_withbandname, pctfile, mtitle
;this program accepts the statistic file such as 2012_snowyear_gl_stat2-pct.dat as input, plot the bar box plot.
;

;pctfile='/Users/jzhu/projects/nps/snow_metrics_data/2012/2012_snow_cover_raw-pct.dat'

pctfile='/center/w/jzhu/nps/snow_metrics/2012/2012_snowyear_gl_stat1-pct.dat'

;pct_bandname_file='/Users/jzhu/projects/nps/snow_metrics_data/2012/2012_snow_cover-pct-bandname.dat'

pct_bandname_file='/center/w/jzhu/nps/snow_metrics/2012/2012_snowyear_gl_stat1-pct-bandname.dat'

;2012 snowyear bandnames and their associated date 

bandname_date=[ ['2011-213','2011-244','2011-274','2011-305','2011-335','2012-001','2012-032','2012-061','2012-092','2012-122','2012-153','2012-183'], $
             ['Aug 1',   'Sep 1',   'Oct 1',   'Nov 1',   'Dec 1',   'Jan 1',   'Feb 1',   'Mar 1',   'Apr 1',   'May 1',   'Jun 1',   'Jul 1'   ] ]  


mtitle='Glacial-pixel filtered'

openr, lun, pctfile,/GET_LUN

pct=fltarr(4,366)

readf, lun, pct

close,lun

; open pct_bandname file

openr, lun, pct_bandname_file,/GET_LUN

pct_bandname=strarr(366)

readf, lun, pct_bandname

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

set_plot,'X'

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


;data1=snow

;data2=snowfree

;data3=cloud

;data4=nodata

;data1=data1(0:100)
;data2=data2(0:100)
;data3=data3(0:100)
;data4=data4(0:100)


 
;Plot four bars, stacked.



;b1 = BARPLOT(data1, FILL_COLOR='white',BOTTOM_COLOR="white",ytitle='Percentage [%]',name='snow',title=mtitle,$
;     xtitle='daily scenes August 1, 2011 to July 31, 2012', font_size=30, axis_style=2,xthick=1,ythick=1)

b1 = BARPLOT(data1, FILL_COLOR='white',BOTTOM_COLOR="white",ytitle='Percentage [%]',name='snow',title=mtitle,$
       xtitle='Daily scenes August 1, 2011 to July 31, 2012', linestyle=6, width=1, font_size=20,xtickfont_size=20, yrang=[0,100], axis_style=2,xthick=1,ythick=1)

bandname_idx=find_indices(pct_bandname, bandname_date[*,0])



     ax1=b1.axes
     
     ;ax1[0].tickfont_size=15
     
     ;b1.font_size=30
     
     ax1[0].tickvalue=bandname_idx
     
     ax1[0].tickname=bandname_date[*,1]

     ;ax1[0].tickname=['']
      
b2 = BARPLOT(data2, BOTTOM_VALUES=data1, linestyle=6, width=1, FILL_COLOR='light grey',BOTTOM_COLOR="light grey", name='snowfree', /OVERPLOT)
b3 = BARPLOT(data3, BOTTOM_VALUES=data2, linestyle=6, width=1, FILL_COLOR='dark gray',BOTTOM_COLOR="dark gray",name='cloud',/OVERPLOT)
b4 = BARPLOT(data4, BOTTOM_VALUES=data3, linestyle=6, width=1, FILL_COLOR='black',BOTTOM_COLOR="black",name='no data',/OVERPLOT)


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
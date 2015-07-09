pro test_barplot

; Define the data
Pine_Warbler = [0, 0, 13, 18, 41, 82, 59]
Yellow_Warbler = [30, 101, 312, 267, 330, 384, 191]
Year = [1970, 1975, 1980, 1985, 1990, 1995, 2000]
 
; Create the first BARPLOT
b1 = BARPLOT(Year, Pine_Warbler, INDEX=0, NBARS=2, $
   FILL_COLOR='green', YRANGE=[0, 400], YMINOR=0, $
   YTITLE='Number Breeding Individuals', XTITLE='Year', $
   TITLE = 'North American Breeding Bird Survey - ' + $
   'Counts for Maine')
 
; Add the second BARPLOT
b2 = BARPLOT(Year, Yellow_Warbler, INDEX=1, NBARS=2, $
   FILL_COLOR='gold', /OVERPLOT)
 
; Add descriptive text
text_pine = TEXT(1970, 300, 'Pine Warbler', /CURRENT, $
   COLOR='green', /DATA)
text_yel = TEXT(1970, 275, 'Yellow Warbler', /CURRENT, $
   COLOR = 'gold', /DATA)
text_note = TEXT(11, 12, 'Data courtesy USGS Patuxent ' + $
   'Wildlife Research Center, Maryland', /CURRENT, $
   COLOR='gray', FONT_SIZE=8, FONT_STYLE=2, $
   TRANSPARENCY=20, /DEVICE)
   
   end
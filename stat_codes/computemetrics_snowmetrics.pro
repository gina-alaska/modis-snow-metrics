FUNCTION ComputeMetrics_snowmetrics, snow, bq, bn, wl, bpy, CurrentBand, DaysPerBand;dt
;for modis ndvi 7-days data, DaysperBand=7
;jzhu, 9/21/2011, this program modified from computemetrics.pro,
;it inputs three-year ndvi time series abd rerlated band anme vectors,wl,bpy,currentband, and daysperband 

;---get mid year ndvi and related bn


;-----calculate forward and backward moving average ----------------
   fma=GetForwardMA(snow, wl[0])
   bma=GetBackwardMA(snow, wl[1])
   
;------get mid year-------------------------   

;mid_idx= where(strmid(bn_3yr,0,1) EQ 1)
;ndvi=ndvi_3yr(mid_idx)
;bq  =  bq_3yr(mid_idx)
;bn=    bn_3yr(mid_idx)
;fma=  fma_3yr(mid_idx)
;bma=  bma_3yr(mid_idx)
;-----

   nSize=Size(snow)
   Time=Make_Array(Size=nSize)
   Time1=findgen(nSize[nSize[0]])

   CASE(nSize[0]) OF
      1: Time=Time1
      2: FOR i=0, nSize[1]-1 DO Time[i]=Time1
      3: BEGIN
         FOR i=0, nSize[1]-1 DO BEGIN
            FOR j=0, nSize[2]-1 DO BEGIN
               Time[i,j,*]=Time1
            END
         END
      END;3
      ELSE:
   ENDCASE

;
; Get crossover points (potential starts/ends)
;
;   Starts=GetCrossOver_percentage_extremeslope_ver15(Time, NDVI, Time, FMA, bq, bpy, /Down)
;   Ends=GetCrossOver_percentage_extremeslope_ver15(Time, NDVI, Time, BMA, bq, bpy, /Up)

   Starts=GetCrossOver2(Time, snow, Time, FMA, bq, bpy, /Down)
   Ends=GetCrossOver2(Time, snow, Time, BMA, bq, bpy, /Up)

;
;die
;
; Determine start/end of season
;
   SOS=GetSOS3(Starts, snow,Time, bpy, FMA) ;dayindex of start season and related ndvi value
   EOS=GetEOS3(Ends, snow,Time, bpy, SOS,BMA)   ;dayindex of end season and related ndvi value
   

; Generate structures for Start/End of season
;
   Start_End = {SOST:SOS.SOST, $
                SOSN:SOS.SOSN, $
                EOST:EOS.EOST, $
                EOSN:EOS.EOSN, $
                FwdMA:FMA, $
                BkwdMA:BMA $
               }


;PRINT, 'COMPUTEMETRICS:NY:',ny
;   ny=n_elements(eos.eost)
   SOST = Start_End.SOST
   SOSN = Start_End.SOSN
   EOST = Start_End.EOST
   EOSN = Start_End.EOSN

   MaxND=GetMaxNDVI(snow, Time, Start_End,bpy) ;dayindex and related maximun ndvi value
   TotalNDVI=GetTotNDVI(snow, Time, Start_End,bpy, DaysperBand) ; ndvi*day (it is a ndvi curve minus baseline ), 
                                                               ; baseline( start to end) vector,
                                                               ; ndvi vector (start to end),
                                                               ; time vector (start to end).
                                                               ; GrowingSeasonT=GST, GrowingSeasonN=GSN, GrowingSeasonB=GSB)

;MJS 7/30/98 Need to write this
   NDVItoDate=GetNDVItoDate(snow, Time, Start_End, bpy, DaysPerBand, CurrentBand) ; ndvi*day, nowT (dayindex),nowN

   Slope=GetSlope(Start_End, MaxND, bpy, DaysPerBand) ;slope = ndvi/day   
   
   Range=GetRange(Start_End, MaxND, bpy, DaysPerBand) ;range.ranget = day, range.rangeN = ndvi


;IF(N_ELEMENTS(GST LE 0)) THEN GST=-1L
;IF(N_ELEMENTS(GSN LE 0)) THEN GSN=-1L
;IF(N_ELEMENTS(GSB LE 0)) THEN GSB=-1L

mMetrics = {SOST:SOST, $
            SOSN:SOSN, $
            EOST:EOST, $
            EOSN:EOSN, $
            FwdMA: Start_End.FwdMA, $
            BkwdMA: Start_End.BkwdMA, $
            SlopeUp: Slope.SlopeUp, $
            SlopeDown:  Slope.SlopeDown, $
            TotalNDVI: TotalNDVI.TotalNDVI, $
            GrowingN:TotalNDVI.GSN, $
            GrowingT:TotalNDVI.GST, $
            GrowingB:TotalNDVI.GSB, $
            MaxT: MaxND.MaxT, $
            MaxN: MaxND.MaxN, $
            RangeT: Range.RangeT, $
            RangeN: Range.RangeN, $
            NDVItoDate: NDVItoDate.NDVItoDate, $
            NowT: NDVItoDate.NowT, $
            NowN: NDVItoDate.NowN $
           }


;   mMetrics = getall(ndvi, Time, start_end, ny, bpy)
;die
return, mMetrics
END

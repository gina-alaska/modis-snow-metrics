FUNCTION Comput_snowmetrics_consecutivesnowpoint,snow, bq, bn, wl,num_point,rate,bpy,DaysPerBand,CurrentBand
;this program uses following rule to determine the start of snow season and end of snow season:
;looks for consecutive num_point, the fraction values of which are above 20% (rate), then we think the start point of the consecutive point
;is the start of snow season, the same method to determind the end of snow season 



;-----calculate forward and backward moving average ----------------
   fma=GetForwardMA(snow, wl[0])
   bma=GetBackwardMA(snow, wl[1])
;-----calculate Time------------------------------------------
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
;----------------------------------------------------------------

;----- calculate sos 
sos=getsos_temperal(snow,bq,num_point,rate)

;-------calculate eos
eos=geteos_temperal(snow,bq,num_point,rate)




; Generate structures for Start/End of season
;
   Start_End = {SOST:sos.sost, $
                SOSN:sos.sosn, $
                EOST:eos.EOST, $
                EOSN:eos.EOSN, $
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

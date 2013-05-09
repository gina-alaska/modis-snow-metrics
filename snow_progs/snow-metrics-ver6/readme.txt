1. The snow_metrics file is ENVI-foramt image file. It includes 10 bands. They are:
0-first_day, first day of snow occurs
1-last_day,  last day of snow occurs
2-fss_range, last_day-first_day 
3-css_first_day, first day of continous snow season  
4-css_last_day, last day of the continous snow season
5-css_day_range, days of continious snow season
6-snow_days, number of days which are snow-covered
7-no_snow_days, number of days which are snow-free
8-reserved, not used 
9-mflag,flag indicating the snow_metrics is valid (1), not-valid (0), or no data(-1)

2. In the version 2 of snow_metrics, I use four methods to reduce the cloud pixel before calculating the snow_metrics. They include: combine both ACUA and TERRA data, Spatial reduce, time reduce, and snow-cycle-based reduce. 

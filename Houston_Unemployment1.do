g dOil=oil/ppi_oil*100
g dGas=gas/ppi_gas*100
g dCot=cotton/ppi_cotton*100
g time=_n
tsset time


*************Unemployment variable*****************
twoway (line unemp time), xtitle(time)
ac unemp
pac unemp
varsoc unemp, maxlag(1)
dfuller unemp, lag(2) trend regress
dfuller unemp, lag(2) regress
dfuller unemp, lag(2) nocons regress


*************Climate variables*****************
*************1. Precipitaion
twoway (line prcp time), xtitle(time)
ac prcp
pac prcp
varsoc prcp, maxlag(2)
dfuller prcp, lag(2) trend regress
dfuller prcp, lag(2) regress
dfuller prcp, lag(2) nocons regress



*************2.Temperature variable****************************************
*destring monNov monDec, generate(mon_Nov mon_Dec)
*reshape long mon, i(Year) j(Month Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec) string
**merge climate tables
**merge 1:1 time Year mon Month using "C:\Users\User\OneDrive - purdue.edu\AGEC655\Project\Data\precipitation1.dta"
twoway (line temp time), xtitle(time)
ac temp
pac temp
varsoc Temp, maxlag(40)
dfuller Temp, lag(16) trend
dfuller Temp, lag(16)
dfuller Temp, lag(16) nocons

****************************************************************
*import excel "C:\Users\User\OneDrive - purdue.edu\AGEC655\Project\Data\monthly_crude_oil.xls", sheet("Data 1") firstrow
g Date=date(date1,"DMY")
/*tab Date,missing
drop if Date==.*
format Date %td
destring Price, replace
destring PPI_Oil, replace*
merge 1:1 Date using "C:\Users\User\OneDrive - purdue.edu\AGEC655\Project\Data\oil.dta"*/


****************Oil**********************************************

*Normal
twoway (line oil time), xtitle(time)
ac oil
pac oil
varsoc oil, maxlag(20)
dfuller oil, lag(6) trend
dfuller oil, lag(6)
dfuller oil, lag(6) nocons  /* DF test shows that Normal price of oil has unity */

*Real
twoway (line dOil time), xtitle(time)
ac dOil
pac dOil
varsoc dOil, maxlag(20)
dfuller dOil, lag(1) trend
dfuller dOil, lag(1)
dfuller dOil, lag(1) nocons   /* No unity in real price of oil */

*First Dif
g ddoil=dOil[_n-1]
g d1oil=dOil-ddoil
varsoc d1oil, maxlag(20)
dfuller d1oil, lag(4) trend
dfuller d1oil, lag(4)
dfuller d1oil, lag(4) nocons  /*No unity on the first difference of Real price of oil */


*********************************Natural Gas******************************

*Normal
twoway (line gas time), xtitle(time)

ac gas
pac gas
varsoc gas, maxlag(20)
dfuller gas, lag(0) trend
dfuller gas, lag(0) 
dfuller gas, lag(0) nocons /* DF test shows that Normal price of gas has unity */

*Real

twoway (line dGas time), xtitle(time)
ac dGas
pac dGas
varsoc dGas, maxlag(20)
dfuller dGas, lag(9) trend
dfuller dGas, lag(9)
dfuller dGas, lag(9) nocons /* DF test shows that Real price of gas has unity */


g ddgas=dGas[_n-1]
g d=dGas-ddgas
twoway (line d time), xtitle(time)
varsoc d, maxlag(20)
dfuller d, lag(8) trend
dfuller d, lag(8) 
dfuller d, lag(8) nocons /*No unity in the first difference of Real price of oil */



*Enders Test to see if the trend is significant in the Real Price of Natural Gas
gen lag1 = gas[_n-1]
gen lag2 = gas[_n-2]
gen lag3 = gas[_n-3]
gen lag4 = gas[_n-4]
gen lag5 = gas[_n-5]
gen lag6 = gas[_n-6]
gen lag7 = gas[_n-7]
gen lag8 = gas[_n-8]
gen lag9 = gas[_n-9]
g l1=gas-lag1
g l2=lag1-lag2
g l3=lag3-lag4
g l4=lag4-lag5
g l5=lag5-lag6
g l6=lag6-lag7
g l7=lag7-lag8
g l8=lag8-lag9

regress dGas lag1 l1-l8 time

regress dGas l1-l8              /* Fstat = 160, Time trend is significant using Ender's test */

drop residual

*Perron’s approach - To account for structural variation in Real Price

g dummy=1 if time<186
replace dummy =0 if time>=186
regress dGas dummy time
predict residual , resid
twoway (line residual time), xtitle(time)

g Gas_st=4.23+residual


*DF test of detrended Real Price
ac residual
pac residual
varsoc residual, maxlag(20)
dfuller residual, lag(0) trend
dfuller residual, lag(0) 
dfuller residual, lag(0) nocons


******************************Cotton**************************************************
twoway (line dCot time), xtitle(time)
ac dCot
pac dCot
varsoc dCot, maxlag(2)
dfuller dCot, lag(2) trend regress
dfuller dCot, lag(2) regress
dfuller dCot, lag(2) nocons regress

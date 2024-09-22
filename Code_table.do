
clear all
set more off

** Set the directory first where the datasets are downloaded.

use Full_data

*********************************************************************************************
* MAIN PAPER REGRESSIONS
*********************************************************************************************


*********************************************************************************************
* Table 1: Exposure to terrorism related violence and trust in institutions 
*********************************************************************************************

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180 210 240 270 300{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_Table1.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}


**************************************************************************************************************************************************
* Table 2: Exposure to terrorism related violence and trust in institutions: Accounting for the potential correlation between dependent variables
**************************************************************************************************************************************************

* Panel A: Estimates from Seemingly Unrelated Regression (SUR)

sureg (parliament legal police politicians parties ep un = exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1)
outreg2 using Results_Table2_PanelA, excel bdec(3) keep(exp90_s)



* Panel B: Accounting for Multiple Inferences: Inferences using Simes and Hochberg Corrected Standard Errors

preserve

local deps "parliament legal police politicians parties ep un "
foreach item in `deps' {
reg `item' exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

test exp90_s

gen pval_`item' = r(p)
}

keep pval*
keep if _n==1

xpose, clear varname
rename v1 p
rename _varname var

ssc install qqvalue, replace
qqvalue p, method(simes) qvalue(p_simes)
qqvalue p, method(hochberg) qvalue(p_hochberg)

edit

restore



****************************************************************************************************
* Table 3: Exposure to Terrorist Related Violence and Trust in Institutions: Robustness Checks
****************************************************************************************************

* Panel A: Controlling for respondents' placement on left-right scale

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s left_right age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_Table3_PanelA_TA11.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp* left_right)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}




* Panel B: Exposure to terrorism related violence in neighboring countries and trust in institutions

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90{

foreach item in `deps' {

reg `item'  exp`x'_s_n age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.dow i.nuts1 if attack`x'_s==0 [pw=dweight], cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_Table3_PanelB_TA12.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}



* Panel C: Exposure to future terrorist attacks and trust in institutions

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' f_exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_Table3_PanelC_TA13.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(f_exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}



* Panel D: Exposure to terrorism related violence and trust in others

local deps "trust pplfair pplhlp"
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_Table3_PanelD_TA14.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}





**********************************************************************************************************
* Table 4:  Exposure to terrorism related violence and trust in institutions: Experience with terrorism
**********************************************************************************************************

* Panel A: Interacted with total number of serious attacks in last 3 years

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s c.sum_last3_serious#i.exp`x'_s sum_last3_serious age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_Table4_PanelA.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp* 1.exp`x'_s#c.sum_last3_serious sum_last3_serious)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`variable')  mtitles(`deps')    ///

eststo clear

}


* Panel B:  Interacted with total attacks in last 3 years

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s c.sum_last3#i.exp`x'_s sum_last3 age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_Table4_PanelB.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp* 1.exp`x'_s#c.sum_last3 sum_last3)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`variable')  mtitles(`deps')    ///

eststo clear

}




**********************************************************************************************************
* Table 5: Exposure to terrorism related violence and trust in institutions: Role of existing trust level
**********************************************************************************************************

reg parliament exp90_s c.parliament_avg_y_lag1#i.exp90_s parliament_avg_y_lag1 age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.nuts1 [pw=dweight] , cluster(nuts1)
outreg2 using Results_Table5, excel bdec(3) keep(exp90_s c.parliament_avg_y_lag1#i.exp90_s parliament_avg_y_lag1)

reg legal exp90_s c.legal_avg_y_lag1#i.exp90_s legal_avg_y_lag1 age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.nuts1 [pw=dweight] , cluster(nuts1)
outreg2 using Results_Table5, excel bdec(3) keep(exp90_s c.legal_avg_y_lag1#i.exp90_s legal_avg_y_lag1) append

reg police exp90_s c.police_avg_y_lag1#i.exp90_s police_avg_y_lag1 age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.nuts1 [pw=dweight] , cluster(nuts1)
outreg2 using Results_Table5, excel bdec(3) keep(exp90_s c.police_avg_y_lag1#i.exp90_s police_avg_y_lag1) append

reg politicians exp90_s c.politicians_avg_y_lag1#i.exp90_s politicians_avg_y_lag1 age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.nuts1 [pw=dweight] , cluster(nuts1)
outreg2 using Results_Table5, excel bdec(3) keep(exp90_s c.politicians_avg_y_lag1#i.exp90_s politicians_avg_y_lag1) append

reg parties exp90_s c.parties_avg_y_lag1#i.exp90_s parties_avg_y_lag1 age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.nuts1 [pw=dweight] , cluster(nuts1)
outreg2 using Results_Table5, excel bdec(3) keep(exp90_s c.parties_avg_y_lag1#i.exp90_s parties_avg_y_lag1) append

reg ep exp90_s c.ep_avg_y_lag1#i.exp90_s ep_avg_y_lag1 age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.nuts1 [pw=dweight] , cluster(nuts1)
outreg2 using Results_Table5, excel bdec(3) keep(exp90_s c.ep_avg_y_lag1#i.exp90_s ep_avg_y_lag1) append

reg un exp90_s c.un_avg_y_lag1#i.exp90_s un_avg_y_lag1 age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.nuts1 [pw=dweight] , cluster(nuts1)
outreg2 using Results_Table5, excel bdec(3) keep(exp90_s c.un_avg_y_lag1#i.exp90_s un_avg_y_lag1) append




**********************************************************************************************************
* Table 6: Exposure to terrorism related violence and trust in institutions: The role of governance
**********************************************************************************************************

local deps "parliament legal police politicians parties ep un "
foreach variable in vae pve gee rqe rle cce{

foreach item in `deps' {

reg `item' exp90_s c.`variable'#i.exp90_s `variable' age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_Table6.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp90_s 1.exp90_s#c.`variable' `variable')  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`variable')  mtitles(`deps')    ///

eststo clear

}




*********************************************************************************************
* APPENDIX REGRESSIONS
*********************************************************************************************

************************************************************************************************************************
* Table A1: Descriptive Statistics
************************************************************************************************************************

reg un exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

preserve

keep if e(sample)==1


* Control variables
sum age female marit_married marit_single marit_other high_educ low_educ religion_christian religion_non_christian religion_no_denom mnact_working mnact_unempl mnact_retired mnact_notwork mnact_working mnact_in_school hh_large hh_small urban rural

* Terrorsim related variables
sum exp*_s


* Country level variables
duplicates drop country int_year, force
sum GDP pop unemp_ILO vae pve gee rqe rle cce

restore




************************************************************************************************************************
* Table A4: Exposure to terrorism related violence and trust in institutions: Using non-binarized trust variable
************************************************************************************************************************

local deps "trust_parl trust_legal trust_police trust_politicians trust_parties trust_ep trust_un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA4.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}




********************************************************************************************************************************
*Table A5: Exposure to terrorism related violence and trust in institutions: Changing cut-off for the binarized trust variable ********************************************************************************************************************************

local deps "parliament3 legal3 police4 politicians4 parties4 ep3 un3 "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA5.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}



**************************************************************************************************************************************
* Table A6: Exposure to terrorism related violence and trust in institutions: Using the median cut-off for binarized trust variable
**************************************************************************************************************************************

local deps "parliament legal police2 politicians2 parties2 ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA6.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}



******************************************************************************************************************************************
* Table A7: Exposure to terrorism related violence and trust in institutions: Changing the median cut-off for binarized trust variable
******************************************************************************************************************************************

local deps "parliament3 legal3 police3 politicians3 parties3 ep3 un3 "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA7.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}




*****************************************************************************************************************
* Table A8: Exposure to terrorism related violence and trust in institutions: Accounting for country fixed effects 
*****************************************************************************************************************

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.c [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA8.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}



****************************************************************************************************************************************************
*Table A9: Exposure to terrorism related violence and trust in institutions: Accounting for country-year trend with country and year fixed effects ****************************************************************************************************************************************************


local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.c i.c#c.int_year [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_A9.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}



****************************************************************************************************************************************************
* Table A10: Exposure to terrorism related violence and trust in institutions: Seemingly Unrelated Regression (SUR) ****************************************************************************************************************************************************

sureg (parliament legal police politicians parties ep un = exp30_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1)
outreg2 using Results_TA10, excel bdec(3) keep(exp30_s)

sureg (parliament legal police politicians parties ep un = exp60_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1)
outreg2 using Results_TA10, excel bdec(3) keep(exp60_s) append

sureg (parliament legal police politicians parties ep un = exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1)
outreg2 using Results_TA10, excel bdec(3) keep(exp90_s) append

sureg (parliament legal police politicians parties ep un = exp120_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1)
outreg2 using Results_TA10, excel bdec(3) keep(exp120_s) append

sureg (parliament legal police politicians parties ep un = exp150_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1)
outreg2 using Results_TA10, excel bdec(3) keep(exp150_s) append

sureg (parliament legal police politicians parties ep un = exp180_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1)
outreg2 using Results_TA10, excel bdec(3) keep(exp180_s) append

sureg (parliament legal police politicians parties ep un = exp210_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1)
outreg2 using Results_TA10, excel bdec(3) keep(exp210_s) append

sureg (parliament legal police politicians parties ep un = exp240_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1)
outreg2 using Results_TA10, excel bdec(3) keep(exp240_s) append

sureg (parliament legal police politicians parties ep un = exp270_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1)
outreg2 using Results_TA10, excel bdec(3) keep(exp270_s) append

sureg (parliament legal police politicians parties ep un = exp300_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1)
outreg2 using Results_TA10, excel bdec(3) keep(exp300_s) append



****************************************************************************************************************************************************
* Table A15: Exposure to terrorism related violence and trust in institutions (restricted sample)
****************************************************************************************************************************************************

preserve 

keep if parliament!=. & legal!=. & police!=. & politicians!=. & parties!=. & ep!=. & un!=.


local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA15.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}

restore




****************************************************************************************************************************************************
* Table A16: Exposure to terrorism related violence and trust in institutions: Affected countries only ****************************************************************************************************************************************************



preserve 

drop if inlist(country, "Iceland", "Cyprus", "Lithuania", "Luxembourg", "Portugal", "Slovenia")

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA16.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}

restore



****************************************************************************************************************************************************
* Table A17: Exposure to terrorism related violence and trust in institutions: Dropping outliers (countries experiencing most and least serious attacks)
****************************************************************************************************************************************************

* Panel A: Dropping United Kingdom (most affected country)

preserve 

drop if country=="United Kingdom"


local deps "parliament legal police politicians parties ep un "

foreach item in `deps' {

reg `item' exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA17_PanelA.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear



restore


* Panel B: Dropping United Kingdom and Spain (two most affected countries)

preserve 

drop if country=="Spain"| country=="United Kingdom"

local deps "parliament legal police politicians parties ep un "

foreach item in `deps' {

reg `item' exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA17_PanelB.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear



restore



*Panel C: Dropping Norway (least affected country)

preserve 

drop if country=="Norway"


local deps "parliament legal police politicians parties ep un "

foreach item in `deps' {

reg `item' exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA17_PanelC.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear


restore


*Panel D: Dropping Norway and Sweden (two least affected countries)


preserve 

drop if country=="Norway"| country=="Sweden"


local deps "parliament legal police politicians parties ep un "

foreach item in `deps' {

reg `item' exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA17_PanelD.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear


restore


* Panel E: Dropping Norway and Sweden along with never affected countries

preserve 

drop if inlist(country, "Iceland", "Cyprus", "Lithuania", "Luxembourg", "Portugal", "Slovenia", "Norway", "Sweden")


local deps "parliament legal police politicians parties ep un "

foreach item in `deps' {

reg `item' exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA17_PanelE.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear


restore



* Panel F: Dropping two most and two least affected countries (United Kingdom, Spain, Norway, and Sweden)

preserve 

drop if inlist(country, "Spain", "United Kingdom", "Norway", "Sweden")


local deps "parliament legal police politicians parties ep un "

foreach item in `deps' {

reg `item' exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA17_PanelF.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear


restore


****************************************************************************************************************************************************
* Table A18: Exposure to terrorism related violence and trust in institutions: dropping outliers (countries suffering most and least casualties)
****************************************************************************************************************************************************

* Panel A: Dropping Germany (most affected country)

preserve 

drop if country=="Germany"


local deps "parliament legal police politicians parties ep un "

foreach item in `deps' {

reg `item' exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA18_PanelA.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear


restore


* Panel B: Dropping German and Spain (two most affected countries)

preserve 

drop if country=="Spain"| country=="Germany"


local deps "parliament legal police politicians parties ep un "

foreach item in `deps' {

reg `item' exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA18_PanelB.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear


restore



		
* Panel C: Dropping two most and two least affected countries (Germany, Spain, Norway, and Sweden)

preserve 

drop if inlist(country, "Spain", "Germany", "Norway", "Sweden")


local deps "parliament legal police politicians parties ep un "

foreach item in `deps' {

reg `item' exp90_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA18_PanelC.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear


restore





****************************************************************************************************************************************************
* Table A19: Exposure to terrorism related violence on trust in institutions (EU countries only) ****************************************************************************************************************************************************

preserve 

drop if inlist(country, "Turkey", "Ukraine", "Norway", "Switzerland", "Iceland")

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA19.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}

restore




****************************************************************************************************************************************************
* Table A20: Exposure to terrorism related violence and trust in institutions (including Russia)
****************************************************************************************************************************************************

preserve

append using Russia_data

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA20.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}

restore

****************************************************************************************************************************************************
* Table A21: Exposure to terrorism related violence and trust in institutions (controlling for serious attacks in the last 3 years)
****************************************************************************************************************************************************

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 sum_last3_serious [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_A21.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}



****************************************************************************************************************************************************
* Table A22: Exposure to terrorism related violence and trust in institutions (controlling for all attacks in the last 3 years)
****************************************************************************************************************************************************

local deps "parliament legal police politicians parties ep un "
foreach x in 30 60 90 120 150 180{

foreach item in `deps' {

reg `item' exp`x'_s age age2 female marit_married marit_other low_educ religion_christian religion_non_christian mnact_working mnact_unempl mnact_retired mnact_notwork hh_large urban GDP pop unemp_ILO i.int_year i.int_month i.int_day i.nuts1 sum_last3 [pw=dweight] , cluster(nuts1)

eststo
sum `item' if e(sample)==1
estadd scalar depvarmean = r(mean)
estadd scalar Obs= e(N)
}

esttab using Results_TA22.csv, append ///
se b(%9.3f)  scalars (depvarmean ) keep(exp*)  starlevels(* 0.1 ** .05 *** .01)  ///
label title(OLS Results_`var')  mtitles(`deps')    ///

eststo clear

}





























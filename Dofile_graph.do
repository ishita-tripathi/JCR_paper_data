
clear all
set more off

** Set the directory first where the datasets are downloaded.

use GTD_data


preserve

bysort year: egen annual_kill=sum(nkill)
bysort year: egen annual_wound=sum(nwound)
bysort year: gen annual_attacks=_N
bysort year: egen annual_attacks_s=sum(attacks_s)

duplicates drop year, force

	   
twoway (line annual_attacks year, lcolor(blue) lpattern(solid) ///
        title("Attacks and Serious Attacks") ///
        ytitle("Counts") xtitle("Year") ///
        ylabel(, grid) xlabel(, grid) legend(label(1 "Attacks") label(2 "Serious Attacks"))) ///
       (line annual_attacks_s year, lcolor(red) lpattern(dash))

graph save Graph Graph_Fig1_PanelA, replace


restore



preserve

replace region = "Eastern Europe" if country =="Turkey"
keep if region=="Eastern Europe" | region=="Western Europe" 

bysort year: gen annual_attacks=_N
bysort year: egen annual_kill=sum(nkill)
bysort year: egen annual_wound=sum(nwound)
bysort year: egen annual_attacks_s=sum(attacks_s)

duplicates drop year, force

	   
twoway (line annual_attacks year, lcolor(blue) lpattern(solid) ///
        title("Attacks and Serious Attacks (Europe)") ///
        ytitle("Counts") xtitle("Year") ///
        ylabel(, grid) xlabel(, grid) legend(label(1 "Attacks") label(2 "Serious Attacks"))) ///
       (line annual_attacks_s year, lcolor(red) lpattern(dash))

graph save Graph Graph_Fig1_PanelB, replace


restore

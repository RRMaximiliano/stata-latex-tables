/*******************************************************************************
	
	ESTTAB DEMO DO-FILE
	
	How to use this do-file:
	1. Add the folder path to the root repository folder where indicated
	2. Run the do-file to make it's working
	3. Open "stata-tables/outputs/esttab.tex" and compile the file to see the 
	   tables created
	4. Edit this do-file, run it and re-compile the LaTeX file to explore the 
	   different options
		
--------------------------------------------------------------------------------
	
	For complete documentation, visit http://repec.sowi.unibe.ch/stata/estout/
	
	Written by: 	Rony Rodriguez-Ramirez [rodriguezramirez@worldbank.org]
	Last updated:	Jun 2020
	
*******************************************************************************/

// Load the data ***************************************************************

	global project "D:/Documents/GitHub/stata-latex-tables"
	global outputs "${project}/outputs"
	global tables  "${outputs}/tables"
	
	sysuse census.dta, clear
	xtset region

// Run regressions *************************************************************

	// Regression 1: nothing interesting
	eststo reg1: reg death marriage pop
	estadd local region	"No"

	// Regression 2: a different regression
	eststo reg2: reg death popurban
	estadd local region "No"

	// Regression 3: indicator expansion
	eststo reg3: reg divorce marriage pop
	estadd local region "No"

	// Regression 4: categorical control
	eststo reg4: reg divorce marriage pop i.region
	estadd local region 	"Yes"
	
	// South region only
	eststo s1: reg death marriage 		if region == 3	
	eststo s2: reg death marriage pop 	if region == 3

	
	// West region only
	eststo w1: reg death marriage 		if region == 4
	eststo w2: reg death marriage pop 	if region == 4
	

// Export tables ***************************************************************
	local regressions reg1 reg2 reg3 reg4

	*---------------------------------------------------------------------------
	* The simplest esttab tables will not compile for these regressions. This is
	* due to the occurrence of the special character # on categorical variables
	*---------------------------------------------------------------------------
	esttab `regressions' using "${tables}/t1_basic.tex", 	///
		fragment nomtitle nonumbers	nodep nogaps 			///
		collabels(none)										///
		cells("b(fmt(3))" "se(par fmt(3) star)")			///
		replace
		
	*---------------------------------------------------------------------------
	* The issue above can be solved by displaying variable labels instead of 
	* variables names with the 'label' option
	*---------------------------------------------------------------------------		
	esttab `regressions' using "${tables}/t2_labels.tex", 	///
		fragment nomtitle nonumbers	nodep nogaps			///
		label collabels(none)										///
		cells("b(fmt(3))" "se(par fmt(3) star)")			///
		replace
							
	*---------------------------------------------------------------------------
	* Remove omitted variables and levels from regression
	*---------------------------------------------------------------------------
	esttab `regressions' using "${tables}/t3_labels_omitted.tex", 	///
		fragment nomtitle nonumbers	nodep nogaps					///
		label collabels(none)										///
		cells("b(fmt(3))" "se(par fmt(3) star)")					///
		noomit nobaselevels											/// Remove variables omitted due to multicollinearity and categorical variables base levels
		replace		
			
	*---------------------------------------------------------------------------
	* The option 'drop' allows you to remove variables from the final table.
	* Use variable names to list all variables to be removed. If you want to 
	* remove specific categories within a categorical variables, type
	* 'mat list r(table)' to see how Stata refers to each category (on the 
	* column names)
	* Option 'keep' would do the opposite, keeping only listed variables.
	* Option 'order' allows you to specify the order or the rows.
	*---------------------------------------------------------------------------
	esttab `regressions' using "${tables}/t4_scalars.tex", 	///
		fragment nomtitle nonumbers	nodep nogaps					///
		label collabels(none)										///
		cells("b(fmt(3))" "se(par fmt(3) star)")					///
		drop(*.region*)												///	Remove fixed effects estimates from table	
		scalars("region Region Fixed Effects")  obslast 			/// Add row indicating their presence instead
		noomit nobaselevels											/// Remove variables omitted due to multicollinearity and categorical variables base levels
		replace		
		
	
******************************************************************* Agora acabou!
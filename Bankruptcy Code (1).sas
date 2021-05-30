/* Generated Code (IMPORT) */
/* Source File: data 2.csv */
/* Source Path: /home/u57831460/sasuser.v94 */
/* Code generated on: 2/23/21, 3:59 PM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u57831460/sasuser.v94/data 2.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT;
RUN;

title'checking missing values';
proc means data= work.import n nmiss;
var _numeric_;

title "using stepwise regression to reduce variables";
proc logistic data=WORK.IMPORT ;
	model bankrupt= ' ROA(C)'n ' ROA(A)'n ' ROA(B)'n 
		' RealizedSalesGrossMargin'n ' OperatingProfitRate'n ' PretaxnetIR'n 
		' AftertaxnetIR'n ' Nonindustryincomeandrevenue'n ' ContinuousIR(after tax)'n 
		' OperatingExpenseRate'n ' Researchdevelopexpenserate'n 'CashFlowRate'n 
		' InterestbearingdebtIR'n ' Taxrate(A)'n ' NetValuePerShare(B)'n 
		' NetValuePerShare(A)'n ' NetValuePerShare(C)'n ' CurrentAssets'n ' Cash'n 
		 ' CurrentLiabilitytoAssets'n ' OperatingFundsLiability'n 
		'WorkingCapital'N  ' CashFlowPerShare'n 
		' RevenuePerShare'n ' OperatingProfitPerShare'n 
		' PerShareNetprofitbeforetax'n ' RealizedSalesGrossProfitGrowthR'n 
		' OperatingProfitGrowthRate'n ' AftertaxNetProfitGrowthRate'n 
		' RegularNetProfitGrowthRate'n ' ContinuousNetProfitGrowthRate'n ' TAssetGR'n 
		 ' TAReturnGRRatio'n ' CashReinvestment'n ' CurrentRatio'n 
		' QuickRatio'n ' InterestExpenseRatio'n  ' Debtratio'n 'Assets'n 
		 ' Borrowingdependency'n ' Contingentliabilities'n 
		' Operatingprofit'n ' Npbeforetax'n ' Inventoryaccountsreceivable'n 
		  ' AvgCollectionDays'n 
		' FixedAssetsTurnoverFreq'n 
		' NetWorthTurnoverRate(times)'n  
		' Operatingprofitperperson'n ' Allocationrateperperson'n 
		' WorkingCapitalTotalAssets'n ' QuickAssets'n 'CurrentLiability'n 
		 'Equity'n  
		' LongtermLiabilitytoCurrentAsset'n ' RetainedEarningstototalAssets'n 
		' TotalIncome'n ' Totalexpense'n ' CurrentAssetTurnoverRate'n 
		' QuickAssetTurnoverRate'n ' WorkingcapitalTurnoverRate'n 
		' CashTurnoverRate'n  
		' CurrentLiabilitytoLiability'n  
		' EquitytoLongtermLiability'n ' CashFlowtoTotalAssets'n 
		' CashFlowtoLiability'n ' CFOtoAssets'n ' CashFlowtoEquity'n 
		' CurrentLiabilitytoCurrentAssets'n  
		' NetIncometoTotalAssets'n ' TotalassetstoGNPprice'n ' NocreditInterval'n 
		' GrossProfittoSales'n ' NetIncometoStockholdersEquity'n 
		' LiabilitytoEquity'n ' DegreeofFinancialLeverage'n ' InterestCoverageRatio'n 
		' NetIncomeFlag'n/ SELECTION=STEPWISE   SLENTRY=0.05  ;
run;

title"creating a new dataset to add those 11 variables in it";
data work.bankruptcy;
set work.import;
keep ' NetIncometoTotalAssets'n ' CashFlowtoLiability'n ' CashTurnoverRate'n  ' Npbeforetax'n 
                 ' FixedAssetsTurnoverFreq'n  ' Cash'n ' NetValuePerShare(C)'n  
                'Assets'n ' RetainedEarningstototalAssets'n ' NetWorthTurnoverRate(times)'n 'bankrupt'n ' NetValuePerShare(C)'n;
run;

ods graphics on;
title"checking the correlation between these variables";
proc corr data=work.bankruptcy plots= scatter plots(maxpoints=10000000);
run;

* Due to the high correlation between few variables we will plot scatter plot to examine the relationship.;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BANKRUPTCY;
	scatter x=' NetValuePerShare(C)'n y=' Npbeforetax'n / group=Bankrupt 
		markerattrs=(symbol=triangle);
	xaxis grid;
	yaxis grid;
run;

proc sgplot data=WORK.BANKRUPTCY;
	scatter x=' RetainedEarningstototalAssets'n y= ' NetWorthTurnoverRate(times)'n  / 
		group=Bankrupt markerattrs=(symbol=triangle);
	xaxis grid;
	yaxis grid;
run;

proc sgplot data=WORK.BANKRUPTCY;
	scatter x= ' CashFlowtoLiability'n y= ' NetWorthTurnoverRate(times)'n  / 
		group=Bankrupt markerattrs=(symbol=triangle);
	xaxis grid;
	yaxis grid;
run;

title" cant only depend upon Correlation Matrix so will check the VIF vif<10";
proc reg data=work.bankruptcy;
 model bankrupt= ' RetainedEarningstototalAssets'n ' NetIncometoTotalAssets'n  ' CashFlowtoLiability'n  ' CashTurnoverRate'n 
                 ' Npbeforetax'n     ' FixedAssetsTurnoverFreq'n ' Cash'n ' NetValuePerShare(C)'n
                  'Assets'n ' NetWorthTurnoverRate(times)'n /vif;
                  
*' NetValuePerShare(B)'n is removed as vif was high;


proc freq data=work.bankruptcy; /*to check the frequency of the variable bankrupt Y*/;
tables bankrupt;
run;

proc univariate data=work.bankruptcy plots;
histogram/normal;
run;

           
proc logistic data= bankruptcy plots(only)=effect;
model bankrupt (event='1') = ' RetainedEarningstototalAssets'n ' NetIncometoTotalAssets'n  ' CashFlowtoLiability'n  ' CashTurnoverRate'n 
                 ' Npbeforetax'n ' NetValuePerShare(C)'n    ' FixedAssetsTurnoverFreq'n ' Cash'n 
                  'Assets'n ' NetWorthTurnoverRate(times)'n/rsquare ;
run;

proc sgscatter data=work.bankruptcy ;
     matrix bankrupt ' NetIncometoTotalAssets'n ' CashFlowtoLiability'n ' CashTurnoverRate'n  ' Npbeforetax'n 
                 ' FixedAssetsTurnoverFreq'n  ' Cash'n  ' NetValuePerShare(C)'n
                'Assets'n ' RetainedEarningstototalAssets'n ' NetWorthTurnoverRate(times)'n;
run;

title"under sampling and random sampling ";
*dataset containing all the bankrupt=1 values;
proc sql noprint;
	create table work.filter as select * from WORK.BANKRUPTCY where(Bankrupt EQ 1);
quit;

proc freq data=work.filter;
tables bankrupt;
run;

*dataset containing all the bankrupt=0 values;
proc sql noprint;
	create table work.filter1 as select * from WORK.BANKRUPTCY where(Bankrupt EQ 
		0);
quit;

proc freq data=work.filter1; /*to check the frequency of the variable bankrupt Y when its 0*/;
tables bankrupt;
run;

proc sort data=WORK.FILTER1 out=WORK.SORTTempTableSorted;
	by Bankrupt;
run;

proc surveyselect data=WORK.SORTTempTableSorted out=work.bankrupt0 outhits 
		method=urs sampsize=220;
	strata Bankrupt / alloc=prop;
run;

proc print data=work.bankrupt0(obs=220);
	title "Subset of work.bankrupt0";
run;

title;

proc delete data=WORK.SORTTempTableSorted;
run;

proc freq data=work.bankrupt0; /*to check the frequency of the variable bankrupt Y*/;
tables bankrupt;
run;


data work.combine;
	set WORK.FILTER WORK.bankrupt0;
run;

proc freq data=work.combine; /*to check the frequency of the variable bankrupt Y*/;
tables bankrupt;
run;

 title"work.combine has 0,1 balanced with 440 rows";
proc univariate data=work.combine plot;
 histogram/normal;
 run;
                
               
proc corr data=work.combine;
run;
   
 
proc reg data=work.combine;
model bankrupt= ' RetainedEarningstototalAssets'n ' NetIncometoTotalAssets'n  ' CashFlowtoLiability'n  ' CashTurnoverRate'n 
                 ' Npbeforetax'n ' NetValuePerShare(C)'n    ' FixedAssetsTurnoverFreq'n ' Cash'n 
                  'Assets'n ' NetWorthTurnoverRate(times)'n/ vif; 
run;

proc logistic data=work.combine plots (only)=effect;
model bankrupt (event='1') = ' RetainedEarningstototalAssets'n ' NetIncometoTotalAssets'n  ' CashFlowtoLiability'n  ' CashTurnoverRate'n 
                 ' Npbeforetax'n ' NetValuePerShare(C)'n    ' FixedAssetsTurnoverFreq'n ' Cash'n 
                  'Assets'n ' NetWorthTurnoverRate(times)'n/ rsquare; 
run;

proc sort data=WORK.COMBINE out=WORK.TempSorted4877;
	by Bankrupt;
run;

proc boxplot data=WORK.TempSorted4877;
	plot ( ' RetainedEarningstototalAssets'n ' NetIncometoTotalAssets'n  ' CashFlowtoLiability'n  ' CashTurnoverRate'n 
                 ' Npbeforetax'n ' NetValuePerShare(C)'n    ' FixedAssetsTurnoverFreq'n ' Cash'n 
                  'Assets'n ' NetWorthTurnoverRate(times)'n )*Bankrupt / boxstyle=schematic;
run;

proc datasets library=WORK noprint;
	delete TempSorted4877;
	run;


 title"applying step wise regression on the balanced dataset";
 
proc logistic data=work.combine;
model bankrupt = ' RetainedEarningstototalAssets'n ' NetIncometoTotalAssets'n  ' CashFlowtoLiability'n  ' CashTurnoverRate'n 
                 ' Npbeforetax'n ' NetValuePerShare(C)'n    ' FixedAssetsTurnoverFreq'n ' Cash'n 
                  'Assets'n ' NetWorthTurnoverRate(times)'n/ selection=stepwise; 
                  run;
                  
data work.final;
set work.combine;
keep  ' Npbeforetax'n ' CashFlowtoLiability'n  ' CashTurnoverRate'n  ' Npbeforetax'n
                  'Assets'n ' NetWorthTurnoverRate(times)'n bankrupt;
                  run;
                  
 proc corr data=work.final;
 run;
 
 proc sgscatter data=work.final;
  title "Scatterplot Matrix ";
  matrix   ' NetWorthTurnoverRate(times)'n ' CashFlowtoLiability'n  ' CashTurnoverRate'n  ' Npbeforetax'n 
                  'Assets'n ' NetWorthTurnoverRate(times)'n bankrupt  / group= bankrupt;

run; 
  proc sort data=WORK.final out=WORK.TempSorted1;
	by Bankrupt;
run;

proc boxplot data=WORK.TempSorted1;
	plot ( ' CashFlowtoLiability'n  ' CashTurnoverRate'n  ' Npbeforetax'n  
                  'Assets'n ' NetWorthTurnoverRate(times)'n )*Bankrupt / boxstyle=schematic;
run;
 
proc univariate data=work.final;
histogram/normal;
run;
 
 proc logistic data=work.final;
 model bankrupt=   ' CashFlowtoLiability'n  ' CashTurnoverRate'n  ' Npbeforetax'n 
                  'Assets'n ' NetWorthTurnoverRate(times)'n/rsquare;
                  run;

data work.transform;
	set WORK.final;
	'log_ NetWorthTurnoverRate(times)'n=log(' NetWorthTurnoverRate(times)'n);
run;   
    
    
 proc univariate data=work.transform;
 histogram/normal;
 run;
 
 proc sort data=WORK.transform out=WORK.TempSorted;
	by Bankrupt;
run;

proc boxplot data=WORK.TempSorted;
	plot ( ' CashFlowtoLiability'n  ' CashTurnoverRate'n  ' Npbeforetax'n  
                  'Assets'n 'log_ NetWorthTurnoverRate(times)'n )*Bankrupt / boxstyle=schematic;
run;
 
 
proc logistic data=work.transform;
model bankrupt =   ' CashFlowtoLiability'n  ' CashTurnoverRate'n  ' Npbeforetax'n  
                  'Assets'n 'log_ NetWorthTurnoverRate(times)'n  / rsquare;  run;

ods graphics off;   


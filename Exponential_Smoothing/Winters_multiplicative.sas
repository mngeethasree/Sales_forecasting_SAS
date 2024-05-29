/*
 *
 * Task code generated by SAS Studio 3.8 
 *
 * Generated on '9/27/23, 11:50 AM' 
 * Generated by 'mngee' 
 * Generated on server 'DESKTOP-B5NKAJD.UCONN.EDU' 
 * Generated on SAS platform 'X64_10HOME WIN' 
 * Generated on SAS version '9.04.01M6P11152018' 
 * Generated on browser 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36' 
 * Generated on web client 'http://localhost:56723/main?locale=en_US&zone=GMT-04%253A00&sutoken=%257BE39A6846-8EC0-474F-896A-B2072969F42C%257D' 
 *
 */

ods noproctitle;
ods graphics / imagemap=on;

proc sort data=PRO.MONTHLY_SALES out=Work.preProcessedData;
	by 'Order Date'n;
run;

proc esm data=Work.preProcessedData back=12 lead=12 seasonality=12 plot=(corr 
		errors modelforecasts) out=work.out0001 outest=work.outest0001 
		outstat=work.outstat0001 outfor=work.outfor0001 outsum=work.outsum0001;
	id 'Order Date'n interval=month;
	forecast Sales / alpha=0.05 model=winters transform=none;
run;

proc delete data=Work.preProcessedData;
run;
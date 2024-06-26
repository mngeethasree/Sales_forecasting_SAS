/*
 *
 * Task code generated by SAS Studio 3.8 
 *
 * Generated on '10/8/23, 2:46 PM' 
 * Generated by 'mngee' 
 * Generated on server 'DESKTOP-B5NKAJD' 
 * Generated on SAS platform 'X64_10HOME WIN' 
 * Generated on SAS version '9.04.01M6P11152018' 
 * Generated on browser 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36' 
 * Generated on web client 'http://localhost:65487/main?locale=en_US&zone=GMT-04%253A00&sutoken=%257B9E150EEF-4B44-4B0A-B4C0-A3D6FFD6E512%257D' 
 *
 */

ods noproctitle;
ods graphics / imagemap=on;

proc sort data=PRO.MONTHLY_SALES_X out=Work.preProcessedData;
	by order_date;
run;

proc arima data=Work.preProcessedData plots
    (only)=(series(corr crosscorr) residual(corr normal) 
		forecast(forecastonly)) out=work.AR1;
	identify var=sales outcov=work.outcov;
	estimate p=(1) method=ML outest=work.outest outstat=work.outstat 
		outmodel=work.outmodel;
	forecast lead=12 back=12 alpha=0.05 id=order_date interval=month;
	outlier;
	run;
quit;

proc delete data=Work.preProcessedData;
run;

%let nhold=12;
%include "&programloc/Macros2.sas" / source2;
%accuracy_prep(indsn=PRO.MONTHLY_SALES_X, series=sales, timeid=order_date, 
    numholdback=&nhold);

%accuracy(indsn=work.AR1, timeid=order_date, series=sales, 
    numholdback=&nhold);

/* Calculate RMSE, MAPE, and MAE */
/* data errors; */
/*     set work.AR1; */
/*      */
/*     Residual squared */
/*     sqe = RESIDUAL* RESIDUAL; */
/*      */
/*     Absolute error */
/*     ae = abs(RESIDUAL); */
/*      */
/*     Absolute Percentage Error */
/*     ape = abs((RESIDUAL / sales) * 100); */
/* run; */
/*  */
/* proc means data=errors noprint; */
/*     var sqe ae ape; */
/*     output out=metrics_data  */
/*            mean(sqe)=mse  */
/*            mean(ae)=mae */
/*            mean(ape)=mape; */
/* run; */
/*  */
/* data metrics; */
/*     set metrics_data; */
/*     rmse = sqrt(mse); */
/* run; */
/*  */
/* proc print data=metrics; */
/*     var rmse mae mape; */
/* run; */
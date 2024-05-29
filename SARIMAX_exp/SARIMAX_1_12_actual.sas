/*
 *
 * Task code generated by SAS Studio 3.8 
 *
 * Generated on '10/9/23, 10:21 AM' 
 * Generated by 'mngee' 
 * Generated on server 'DESKTOP-B5NKAJD.UCONN.EDU' 
 * Generated on SAS platform 'X64_10HOME WIN' 
 * Generated on SAS version '9.04.01M6P11152018' 
 * Generated on browser 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36' 
 * Generated on web client 'http://localhost:65487/main?locale=en_US&zone=GMT-04%253A00&sutoken=%257B9E150EEF-4B44-4B0A-B4C0-A3D6FFD6E512%257D' 
 *
 */

ods noproctitle;
ods graphics / imagemap=on;

proc sort data=PRO.MONTHLY_SALES_HOLIDAY out=Work.preProcessedData;
	by order_date;
run;

proc arima data=Work.preProcessedData plots
     (only)=(series(corr crosscorr) residual(corr normal) 
		forecast(forecast) ) out=work.SARIMAX_HOLI;
	identify var=sales(1) crosscorr=(IsHoliday(1 12) ) outcov=work.outcov;
	estimate p=(12) q=(1) input=(IsHoliday) method=ML outest=work.outest 
		outstat=work.outstat outmodel=work.outmodel;
	forecast lead=12 back=12 alpha=0.05 id=order_date interval=r445mon printall;
	outlier;
	run;
quit;

proc delete data=Work.preProcessedData;
run;



/* Calculate RMSE, MAPE, and MAE */
data errors;
    set work.SARIMAX_HOLI;
    
    /* Residual squared */
    sqe = RESIDUAL* RESIDUAL;
    
    /* Absolute error */
    ae = abs(RESIDUAL);
    
    /* Absolute Percentage Error */
    ape = abs((RESIDUAL / sales) * 100);
run;

proc means data=errors noprint;
    var sqe ae ape;
    output out=metrics_data 
           mean(sqe)=mse 
           mean(ae)=mae
           mean(ape)=mape;
run;

data metrics;
    set metrics_data;
    rmse = sqrt(mse);
run;

proc print data=metrics;
    var rmse mae mape;
run;
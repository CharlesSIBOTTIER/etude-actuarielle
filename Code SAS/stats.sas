%let path= C:\Users\Charles\OneDrive - Université de Poitiers\IRIAF\Études bilatéral\Étude actuarielle\Codes Charles\Code SAS\;

/*Création de la librairie*/
libname ETUDE "&path.";
proc sql;
SELECT accYear, sum(pay) as total
FROM etude.dts_sinistres
GROUP BY accYear;
run;quit;

/*Définit le chemin des fichiers*/
%let path= Z:\Master SARADS\Étude bilatéral\Étude Actuarielle\Codes\Code SAS;

/*Création de la librairie*/
libname ETUDE "&path.";

/*Permet d'effectuer l'importation et les stats descs*/
%include "&path.\importation.sas";

/*Permet de faire le chain Ladder*/
%include "&path.\Chain Ladder.sas";
proc sql;
SELECT incYear, sum(pay) as total
FROM etude.dts_sinistres
GROUP BY accYear;
run;quit;

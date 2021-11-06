libname etude "C:\Users\Charles\OneDrive - Université de Poitiers\IRIAF\Études bilatéral\Étude actuarielle\Codes Charles\Code SAS\";

/*Chain Ladder*/
/*Macro permettant de connaître les montants pour une année en cours*/
%macro chainLadder(annee_en_cours,annee_suivante,nom);
	proc sql;
	create table &nom. as
		SELECT sum(pay) as toto
		FROM ETUDE.DTS_SINISTRES
		WHERE incYear=&annee_en_cours.
		AND accYear<=&annee_suivante.
		GROUP BY incYear;
	run;
	quit;
%mend;
/*Permet d'exécuter la macro*/
%macro effet(annee_debut,annee_fin);
%let nb=%eval(&annee_fin.-&annee_debut.);
%let debut=%eval(&annee_debut.-2010);
%do i=0 %to &nb.;
	%chainLadder(&annee_debut,201&debut.,N_&i.);
	%let debut=%eval(&debut.+1);
%end;
/*%concetenation;*/
%mend;
/*Permet de faire la concaténation et la transposé*/
%macro concatenation(nombre);
	/*Fait la concaténation*/
	data chainlader;
	%do j=0 %to &nombre.;
		 %let N= &N. || N_&j.;
	%end;
	run;
	%put &N.;
%mend;
/*Permet de faire la transposer d'une table*/
proc transpose data = Chainlader out=chain1;
var toto;run;

%effet(2010,2019);
%concatenation(9);
/*Permet la concaténation pour faire le triangle*/
data charbis;
set chain1 chain2 chain3 chain4 chain5 chain6 chain7 chain8 chain9 chain10;run;
/*Concatène les provisionnements avec l'année*/
data Etude.charquatre (rename=(col1=v1 col2=v2 col3=v3 col4=v4 col5=v5 col6=v6 col7=v7 col8=v8 col9=v9 col10=v10));
set charbis (drop=_NAME_);
input annee;
cards;
2010
2011
2012
2013
2014
2015
2016
2017
2018
2019
;
run;
/*Permet de faire les ratios*/
proc sql;
create table coef9 as
select sum(v10)/sum(v9) as coef
FROM Etude.charquatre
WHERE a<=0;
run;
quit;
/*Permet de premier ratio*/
data coef0;
input coef;
cards;
0
;
run;
/*Permet de concaténé les coefs*/
data chartrois;
set coef0 coef1 coef2 coef3 coef4 coef5 coef6 coef7 coef8 coef9;run;
/*Permet de transposer mes coefs*/
proc transpose data = chartrois out=coef;
var coef;run; quit;
/*Renomme mes colonnes et supprime la ligne de transposition*/
data coefbis (rename=(col1=v1 col2=v2 col3=v3 col4=v4 col5=v5 col6=v6 col7=v7 col8=v8 col9=v9 col10=v10));
set coef (drop=_NAME_);run;
/*Concaténé les coefs et les provisions*/
data etude.chainladder;
set coefbis charquatre;run;

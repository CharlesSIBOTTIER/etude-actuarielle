/*Importation des données*/
proc import datafile="C:\Users\Charles\OneDrive - Université de Poitiers\IRIAF\Études bilatéral\Étude actuarielle\DTA_Claims.csv"
    out=ETUDE.DTS_SINISTRES   /* Nom de la table en sortie */
    dbms=csv                /* Le type de données à importer */
    replace;               /* A utiliser pour remplacer la table de sortie*/
    delimiter=';';           /* Le séparateur utilisé */
    getnames=yes;           /* Prendre la première ligne comme nom de colonnes */
run;
/*Importe la table pour faire le chainLadder*/
proc import datafile="C:\Users\Charles\OneDrive - Université de Poitiers\IRIAF\Études bilatéral\Étude actuarielle\ChainLadder.xlsx"
    out=Etude.ChainLadder   /* Nom de la table en sortie */
    dbms=xlsx                /* Le type de données à importer */
    replace;               /* A utiliser pour remplacer la table de sortie*/
    getnames=yes;           /* Prendre la première ligne comme nom de colonnes */
run;

/*Suppression de la variable année en numérique et renommage de la nouvelle variable*/
data ETUDE.DTS_SINISTRES;
	set ETUDE.DTS_SINISTRES (drop=accYear rename=(accYearBis=accYear));
run;

/*Stats descs sur la variable eval et pay*/
proc univariate data=ETUDE.DTS_SINISTRES;
	var eval pay;
run;

/*Permet d'obtenir l'année de cloture*/
data ETUDE.DTS_SINISTRES;
	set ETUDE.DTS_SINISTRES;
	/*Nombre de sinistres*/
	cloYear=year(cloDate);
	/*Permet de connaître l'année de survenance*/
	incYear=year(incDate);
run;

/*Définit le chemin des fichiers*/
%let path= C:\Users\Charles\OneDrive - Université de Poitiers\IRIAF\Études bilatéral\Étude actuarielle\Codes Charles\Code SAS\;

/*Création de la librairie*/
libname ETUDE "&path.";

/*Permet d'effectuer l'importation et les stats descs*/
%include "&path.\Exploration des données.sas";

/*Permet de faire le chain Ladder*/
%include "&path.\Chain Ladder.sas";

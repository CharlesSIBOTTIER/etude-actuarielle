#Importation des lirairies

#Importation des données
sinistres<-read.csv2("C:/Users/Charles/OneDrive - Université de Poitiers/IRIAF/Études bilatéral/Étude actuarielle/DTA_Claims.csv",sep=";",stringsAsFactors = FALSE,dec = ".")

#Récupère l'année de survenance et le met dans le tableau
sinistres$incYear<-as.numeric(substr(sinistres$incDate,1,nchar(sinistres$incDate)-6))
#Concertie l'année en cours pour le mettre en numérique
sinistres$accYear<-as.numeric(sinistres$accYear)

sinistres<-as.matrix(sinistres)

paiement=0
for (i in 1:nrow(sinistres)){
  if (sinistres[i,6]==2010 & sinistres[i,9]==2010){
    paiement = paiement + as.numeric(sinistres[i,7])
  }
}

print(paiement)

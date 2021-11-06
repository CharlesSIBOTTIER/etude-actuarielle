#Importation des librairies

#Importation des données
sinistres<-read.csv2("https://raw.githubusercontent.com/CharlesSIBOTTIER/etude-actuarielle/main/DTA_Claims.csv",sep=";",stringsAsFactors = FALSE,dec = ".")
#Importation avec une boite de dialogue
#readline(prompt="Quel est le lien du fichier ? Entrez le chemin, et le nom et l'extention : ")

#Définit la fonction pour calculer le premier triangle
premiertriangle<-function(){
  #Récupère l'année de survenance et le met dans le tableau
  sinistres$incYear<-substr(sinistres$incDate,1,nchar(sinistres$incDate)-6)
  
  #Convertie le dataframe en matrice
  sinistres<-as.matrix(sinistres)
  
  #-----------------Initialisation des variables---------------
  #Initialise le montant payer
  paiement=0
  #Initialise la colonne
  colonne=1
  #Initialise la ligne
  ligne=1
  #Initialisation de la matrice (avec un nombre de colonne définit et un nombre de ligne définit)
  total<-matrix(nrow=as.numeric(max(sinistres[,6]))-as.numeric(min(sinistres[,6]))+1,ncol=as.numeric(max(sinistres[,6]))-as.numeric(min(sinistres[,6]))+1)
    #-------Boucle permettant de faire le premier triangle----------
  #La première boucle permet de parcourir l'année de survenance
  for (annee_survenance in as.numeric(min(sinistres[,9])):as.numeric(max(sinistres[,9]))){
    #La seconde boucle permet de parcourir l'année en cours
    for (annee_en_cours in as.numeric(min(sinistres[,6])):as.numeric(max(sinistres[,6]))){
      #La troisième boucle permet de parcourir les montants payés
      for (montant_paye in 1:nrow(sinistres)){
        #Vérifie si la cellule correspond à l'année en cours (année concernée) et vérifie l'année de survenance
        if (sinistres[montant_paye,6]==annee_en_cours & sinistres[montant_paye,9]==annee_survenance){
          #Si les deux conditions sont vérifiés, cela fait la somme
          paiement = paiement+ as.numeric(sinistres[montant_paye,7])
        }
      }
      #Vérifie si le montant est différent de 0 (notamment quand on remplis les autres lignes du tableau)
      if (paiement!=0){
        #Renseigne pour la ligne b et la colonne a le montant concerné
        total[ligne,colonne]<-round(paiement,2)
        #Ajoute 1 à a pour passer à la colonne suivante
        colonne=colonne+1
      }
      
    }
    #Ajoute 1 à b pour passer à la ligne suivante
    ligne=ligne+1
    #Réinitialise a à 1
    colonne=1
    #Réinitialise paiement à 0
    paiement=0
  }
  return (total)
}

#Définit la fonction pour calculer les coefficients
coefficient<-function(){
  #Permet d'appeler la fonction pour calculer le premier triangle, et sauvegarde le résultat dans premiertriangle
  premierTriangle<-premiertriangle()

  #-----------Initialisation des variables pour les coefficients
  #Définit la valeur pour la somme du premier vecteur
  premier=0
  #Définit la valeur pour la somme du second vecteur
  second=0
  
  #--------Définir le nombre de boucle
  #Définit le nombre de ligne à traité pour le premier tour
  nbligne<-nrow(premiertriangle)-1
  #Définit le nombre de colonne
  nbcolonne<-ncol(premiertriangle)
  
  #Définit la matrice des coefficiants (1 ligne, et le nombre de colonne du premier triangle)
  coefficient<-matrix(nrow = 1,ncol = ncol(premiertriangle))
  #Permet de définir la première valeur de la matrice en tant que 0
  coefficient[1,1]<-0
  #Permet de faire la boucle sur les colonnes
  for (colonne in 1:nbcolonne){
    #Vérifie si nbligne est toujours supérieur à 0
    if(nbligne>0){
      #Permet de faire la boucle sur les lignes
      for (ligne in 1:nbligne){
        #Fait la somme de la première colonne
        premier=premier+premiertriangle[ligne,colonne]
        #Fait la somme sur la colonne suivante
        second=second+premiertriangle[ligne,colonne+1]
      }
      #Affecte le coefficient à la matrice des coefficients
      coefficient[colonne+1]<-second/premier
      #Permet d'indiquer de prendre une ligne en moins au prochain tour
      nbligne=nbligne-1
      #Réinitialise la valeur de la somme du premier vecteur
      premier=0
      #Réinitialise la valeur de la somme du second vecteur
      second=0
    }
  }
  #Permet de faire la fusion entre la matrice coefficient et la matrice des coefficents
  triangle<-rbind(premiertriangle,coefficient)
  return (triangle)
}

#Définit la fonction pour calculer le second triangle
chainLadder<-function(){
  triangle<-coefficient()
  
  #--------Définir le nombre de boucle
  #Définit le nombre de ligne à traité pour le premier tour
  nbligne<-nrow(triangle)-1
  #Définit le nombre de colonne
  nbcolonne<-ncol(triangle)
  
  
  #Permet de faire la boucle sur les colonnes
  for (colonne in 1:nbcolonne){
    #Permet de faire la boucle sur les lignes
    for (ligne in 1:nbligne){
      #Permet de remplir la provision pour l'année en ligne à l'année en colonne
      if (is.na(triangle[ligne,colonne])){
        #Permet de faire le remplissage
        triangle[ligne,colonne]<-as.numeric(triangle[11,colonne])*as.numeric(triangle[ligne,colonne-1])
      }
    }
  }
  #Permet de retourner le triangle du ChainLadder
  return(triangle)
}

#Permet de récupérer le tableau complet
tablechainLadder<-chainLadder()

#Permet l'exportation du tableau
write.csv2(tablechainLadder,"C:/Users/Charles/OneDrive - Université de Poitiers/IRIAF/Études bilatéral/Étude actuarielle/Codes Charles/Code R/toto.csv")

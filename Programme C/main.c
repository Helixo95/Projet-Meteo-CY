#include "testLchainer.h"
#include "testavl.h" 
#include "testabr.h"

int main(int argc, char** argv) {
    FILE* fichier_entrée = NULL; //On définie les fichier d'entrer 
    FILE* fichier_sortie= NULL;
    char* entrée = NULL; //On déclare les entrées et les sorties
    char* sortie = NULL;
    pArbre a = malloc(sizeof(Arbre));  //Variable de notre futur lsite chainée pour le tri Liste Chainée     
    int trie; //On déclare des variables tri pour décrire le type trie que l'on va faire
    int sens_trie=0; //0 = tri croissant et 1 = tri décroissant
    float *tb_temp = malloc(sizeof(float) * nbcolonne); //On va initier un tableau temporaire  qui va stocker uniquement la première colonne
    int hauteur = 0; // Variable pour la hauteur de l'arbre en question
    char colonnecounter; //Variable qui va nous permettre de stocker une ligne de colonne
    int nbcolonne=1; //Variable qui va compter le nombre de colonne du fichier en paramètre
    int i=0; //Variable qui va être incruster dans le tableau pour incarner les variables 
    int j=0; //Variable qui va permettre au tableau d'avoir suffisament de mémoir pour contenir les lignes de colonnes
    float a=0; //Variable qui va stocker les valeurs de la première colonne du fichier en paramètre
    float b=0; //Variable qui va stocker les valeurs de la deuxième colonne du fichier en paramètre
    
    fichier_entrée = fopen(entrée, "r+");   //On ouvre le fichier fournit la script shell
    if (fichier_entrée == NULL) {
        printf("erreur lors de l'allocation & ouverture du fichier au C\n");
        return 2;
    }
    
    for (int j = 1; j < argc ; j++) {  //On traite les chemin souhaiter par l'utilisateur
        if (strcmp(argv[j], "--avl") == 0) {
            trie = 2;
        }
        else if (strcmp(argv[j], "-f") == 0) {
            entrée = argv[j+1];
            
        }
        else if (strcmp(argv[j], "--abr") == 0) {
            trie = 1;
        }
        else if (strcmp(argv[j], "-r") == 0) {
            sens_trie = 1;
        }
        else if (strcmp(argv[j], "--tab") == 0) {
            trie = 0;
        }
        else if (strcmp(argv[j], "-o") == 0) {
            sortie = argv[j+1];
        }
        else {
            printf("mauvaise saisie au niveau des arguments du C\n");
            return 1;
        }
    }
    
    
    while(colonnecounter != '\n'){  //On évalue le nombre de colonne qu'a le fichier en entrée
    	colonnecounter = fgetc(fichier_entrée);
    	if(colonnecounter == ';'){
    		printf("%c", colonnecounter);
    		nbcolonne++;
    	}
    }
    
    //Fonction qui avait pour but de configurer un fichier qui avait 2 colonne séparé par un ' ' (espace)
   while(colonnecounter != EOF){
    	colonnecounter = fgetc(fichier_entrée);
   	 if (i == 0){
    		rewind(fichier_entrée);
    	}
   	 if(colonnecounter == ' '){//On évalue le nombre de colonne qu'a le fichier en entrée
        		nbcolonne++;
    	}
   	if(colonnecounter != '\n'){
   		fscanf(fichier_entrée,"%f %f",&a,&b);
        	printf("%f\n", a);
        	printf("%f\n", tb_temp[0]);
        	//fscanf(fichier_entrée,"%d",tb_temp[i]>0);
    	}
    	if(colonnecounter == '\n'){
    		i=0;
    	}
    	tb_temp[i]=a;
    	printf("%f\n", tb_temp[0]);
    	i++;
    	j++; 
    }
    
    printf("Le nombre de colonne du fichier est de %d\n", nbcolonne); //On vérifie le nombre de colonne qu'a le fichier
    rewind(fichier_entrée); // On remet le curseur au début du fichier pour pouvoir parcour les lignes
    
    while(colonnecounter != EOF){
    	switch(trie){ // à modifier
    		case 0:
    		point = insertfin(a, tb_temp, colonnecounter);
    		point = tri_fusion(point);break
    		printf ("Case = 0, le trie est sélectionner sur la liste chainer");
    		case 1:
    		a = insertionABR(a, tb_temp, colonnecounter);
            case 2:
    		a = insertionAVL(a,tb_temp,&h,colonnecounter);
    		printf("Case = 2, le trie est sélectionner sur l'Abr");
    	}
    	colonnecounter = ungetc(fgetc(fichier_entrée), fichier_entrée);
    }
    	
    fclose(fichier_entrée); //On ferme le fichier entrée
    	
   
    fichier_sortie = fopen (sortie, "r+"); //On met les valeurs trié dans le tableau de sortit 
    if (fichier_sortie == NULL) {
        printf("erreur lors de l'allocation du fichier au C\n");
        return 3;
    } 
    	
    	
    // Cette condition avait pour but d'extraire le fichier trier par le trieAVL ou triABR	
    if (trie != 0) {
        parcoursCroissant(a, colonnecounter);
    	//parcourInfixe(a, sortie, colonnecounter);
    }
    return 0;
}

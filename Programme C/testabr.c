#include "testabr.h"

pArbre *creerArbre(tb_temp, colonnecounter) {
    pArbre *Chainon = MALLOC(Arbre);
    if (Chainon == NULL){
    	printf("Erreur d'allocation mémoire");
    	exit(1);
    }
    Chainon -> tb_temp = malloc(sizeof(float)) * colonnecounter);
    for (int i=0, i < taille, i++){
    	Chainon->tb_temp[i]=tb_temp[i];
    }
    return Chainon;
}

pArbre *insertionABR(pArbre a, int *tb_temp, int colonnecounter ) {
    if (a == NULL) {
        return creerArbre(tb_temp, colonnecounter);
    }
    else if (tb_temp[0] < a -> tb_temp[0]) {
        return insertionABR(a -> fg,tb_temp);
    }
    else if (tb_temp[0] > a -> tb_temp[0]) {
        return insertionABR(a -> fd, tb_temp);
    }
    return a;
}

void parcoursCroissant(pArbre a, int colonnecounter) {
    do {
        parcoursCroissant(a -> fg, colonnecounter);
        traiter(a, colonnecounter);
        parcoursCroissant(a -> fd, colonnecounter);;
    } while (a != NULL);
}

void parcoursDecroissant(pArbre a, int colonnecounter) {
    do {
        parcoursDecroissant(a -> fd, colonnecounter);
        traiter(a, colonnecounter);
        parcoursDecroissant(a -> fg, colonnecounter);
    } while (a != NULL);
    
}

void traiter(pArbre a, int colonnecounter) {
    for(int i=0; i<colonnecounter; i++) {
            printf("%d;", a->tb_temp[i]);
    }
}




#include "lib.h"

typedef struct arb {
    int elmt; // -> tab[5]
    struct arb* fg;
    struct arb* fd;
    int equilibre;
    int hauteur;
    int *tb_temp;
} Arbre;

typedef Arbre* pArbre;

pArbre *creerArbre(int *tb_temp, int colonnecounter);
pArbre *insertionABR(pArbre a, float *tb_temp, int colonnecounter ); // pourquoi pointeur ?
void parcoursCroissant(pArbre a, int colonnecounter);
/// @brief 
/// @param a 
/// @param colonnecounter 
void parcoursDecroissant(pArbre a, int colonnecounter);
void traiter(pArbre a, int colonnecounter);



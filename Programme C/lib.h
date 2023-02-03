//
//  lib.h
//  tri_c
//
//  Created by Aurélien Ruppé on 19/01/2023.
//

#ifndef lib_h
#define lib_h

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>


#define MALLOC(x) ((x *) malloc(sizeof(x)))
#define TAILLE 5
#define ERREUR_ALLOC printf("\nErreur d'allocation en mémoire")
#define ELMT_NULL(elmt) (elmt == NULL)



#endif /* lib_h */

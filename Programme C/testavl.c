//
//  main.c
//  Projet Info
//
//  Created by Paul Pitiot on 31/01/2023.
//
#include "testavl.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int max(int a, int b) {
    return (a > b) ? a : b;
}

int height(struct Node *node) {
    if (node == NULL) {
        return 0;
    }
    return node->height;
}

int getBalance(struct Node *node) {
    if (node == NULL) {
        return 0;
    }
    return height(node->left) - height(node->right);
}


void inOrder(struct Node *root) {
    if (root != NULL) {
        inOrder(root->left);
        printf("%d %f %f %f\n", root->key, root->data[0], root->data[1], root->data[2]);
        inOrder(root->right);
    }
}








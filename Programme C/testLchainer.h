#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct node {
    int key;
    char value[50];
    struct node *next;
};

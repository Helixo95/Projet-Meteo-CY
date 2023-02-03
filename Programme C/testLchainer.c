#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "testLchainer.h"

void insert(struct node **head, int key, char value[]) {
    struct node *new_node = (struct node*) malloc(sizeof(struct node));
    new_node->key = key;
    strcpy(new_node->value, value);
    new_node->next = *head;
    *head = new_node;
}

void sort_list(struct node *head) {
    struct node *p, *q;
    int key;
    char value[50];

    for (p = head; p != NULL; p = p->next) {
        for (q = p->next; q != NULL; q = q->next) {
            if (p->key > q->key) {
                key = p->key;
                strcpy(value, p->value);
                p->key = q->key;
                strcpy(p->value, q->value);
                q->key = key;
                strcpy(q->value, value);
            }
        }
    }
}

void write_to_file(struct node *head, char *file_name) {
    FILE *fp;
    struct node *p;

    fp = fopen(file_name, "w");
    if (fp == NULL) {
        printf("Error opening file!\n");
        return;
    }

    for (p = head; p != NULL; p = p->next) {
        fprintf(fp, "%d %s\n", p->key, p->value);
    }

    fclose(fp);
}




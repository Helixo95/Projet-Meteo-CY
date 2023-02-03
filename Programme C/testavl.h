#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Node {
    int key;
    float data[3];
    struct Node *left;
    struct Node *right;
    int height;
};

struct Node *newNode(int key, float data[]) {
    struct Node *node = (struct Node*) malloc(sizeof(struct Node));
    node->key = key;
    node->data[0] = data[0];
    node->data[1] = data[1];
    node->data[2] = data[2];
    node->left = NULL;
    node->right = NULL;
    node->height = 1;
    return node;
}

struct Node *rightRotate(struct Node *y) {
    struct Node *x = y->left;
    struct Node *T2 = x->right;
    x->right = y;
    y->left = T2;
    y->height = max(height(y->left), height(y->right)) + 1;
    x->height = max(height(x->left), height(x->right)) + 1;
    return x;
}

struct Node *leftRotate(struct Node *x) {
    struct Node *y = x->right;
    struct Node *T2 = y->left;
    y->left = x;
    x->right = T2;
    x->height = max(height(x->left), height(x->right)) + 1;
    y->height = max(height(y->left), height(y->right)) + 1;
    return y;
}

struct Node *insert(struct Node *node, int key, float data[]) {
    if (node == NULL) {
        return newNode(key, data);
    }
    if (key < node->key) {
        node->left = insert(node->left, key, data);
    } else if (key > node->key) {
        node->right = insert(node->right, key, data);
    } else {
        // key already exists, we can insert the new node to the left or right
        node->left = insert(node->left, key, data);
    }
        node->height = 1 + max(height(node->left), height(node->right));
    int balance = getBalance(node);
    if (balance > 1 && key < node->left->key) {
        return rightRotate(node);
    }
    if (balance < -1 && key > node->right->key) {
        return leftRotate(node);
    }
    if (balance > 1 && key > node->left->key) {
        node->left = leftRotate(node->left);
        return rightRotate(node);
    }
    if (balance < -1 && key < node->right->key) {
        node->right = rightRotate(node->right);
        return leftRotate(node);
    }
    return node;
}


#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

#include "dictionary.h"
// Number of buckets
#define N 26

// Node structure
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
} node;

// Hash table
node *table[N];

// Word count
int word_count = 0;

// Hash function (simple student version)
unsigned int hash(const char *word)
{
    return toupper(word[0]) - 'A';
}

// Load dictionary
bool load(const char *dictionary)
{
    FILE *file = fopen(dictionary, "r");
    if (file == NULL)
    {
        return false;
    }

    char word[LENGTH + 1];

    // Read words one by one
    while (fscanf(file, "%s", word) != EOF)
    {
        node *n = malloc(sizeof(node));
        if (n == NULL)
        {
            return false;
        }

        strcpy(n->word, word);

        int index = hash(word);

        // Insert at beginning (linked list)
        n->next = table[index];
        table[index] = n;

        word_count++;
    }

    fclose(file);
    return true;
}

// Check word
bool check(const char *word)
{
    int index = hash(word);

    node *cursor = table[index];

    while (cursor != NULL)
    {
        if (strcasecmp(cursor->word, word) == 0)
        {
            return true;
        }
        cursor = cursor->next;
    }

    return false;
}

// Dictionary size
unsigned int size(void)
{
    return word_count;
}

// Free memory
bool unload(void)
{
    for (int i = 0; i < N; i++)
    {
        node *cursor = table[i];

        while (cursor != NULL)
        {
            node *temp = cursor;
            cursor = cursor->next;
            free(temp);
        }
    }

    return true;
}

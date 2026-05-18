#include <cs50.h>
#include <ctype.h>
#include <stdio.h>

#include <string.h>

int main(int argc, string argv[])
{
    if (argc != 2)
    {
        printf("Usage: ./substitution key\n");
        return 1;
    }

    string key = argv[1];

    if (strlen(key) != 26)
    {
        printf("Key must contain 26 characters.\n");
        return 1;
    }

    // check for non-alphabetic characters and duplicates
    for (int i = 0; i < 26; i++)
    {
        if (!isalpha(key[i]))
        {
            printf("Key must only contain letters.\n");
            return 1;
        }

        for (int j = i + 1; j < 26; j++)
        {
            if (toupper(key[i]) == toupper(key[j]))
            {
                printf("Key must not contain duplicate letters.\n");
                return 1;
            }
        }
    }

    string text = get_string("plaintext: ");
    printf("ciphertext: ");

    for (int i = 0, n = strlen(text); i < n; i++)
    {
        if (isupper(text[i]))
        {
            int index = text[i] - 'A';
            printf("%c", toupper(key[index]));
        }
        else if (islower(text[i]))
        {
            int index = text[i] - 'a';
            printf("%c", tolower(key[index]));
        }
        else
        {
            printf("%c", text[i]);
        }
    }

    printf("\n");
}

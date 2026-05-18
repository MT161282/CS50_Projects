#include <cs50.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>

int compute_score(string word);

int main(void)
{
    string p1 = get_string("Player 1: ");
    string p2 = get_string("Player 2: ");

    int s1 = compute_score(p1);
    int s2 = compute_score(p2);

    if (s1 > s2)
    {
        printf("Player 1 wins!\n");
    }
    else if (s2 > s1)
    {
        printf("Player 2 wins!\n");
    }
    else
    {
        printf("Tie!\n");
    }
}

int compute_score(string word)
{
    int points[] = {1,3,3,2,1,4,2,4,1,8,5,1,3,1,1,3,10,1,1,1,1,4,4,8,4,10};

    int score = 0;

    for (int i = 0; i < strlen(word); i++)
    {
        if (isalpha(word[i]))
        {
            char c = toupper(word[i]);
            score += points[c - 'A'];
        }
    }

    return score;
}

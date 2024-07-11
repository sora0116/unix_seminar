#include <stdio.h>
#define SIZE 500

void mut_add_a(int D[SIZE][SIZE], int A[SIZE][SIZE], int B[SIZE][SIZE])
{
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            D[i][j] = A[i][j] + B[i][j];
}

void mut_add_b(int D[SIZE][SIZE], int A[SIZE][SIZE], int B[SIZE][SIZE])
{
    for (int j = 0; j < SIZE; j++)
        for (int i = 0; i < SIZE; i++)
            D[i][j] = A[i][j] + B[i][j];
}

int main(int argc, char const *argv[])
{
    int A[SIZE][SIZE];
    int B[SIZE][SIZE];
    int D[SIZE][SIZE];
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
        {
            A[i][j] = i * j;
            B[i][j] = i + j;
        }
    for (int c = 0; c < 10000; c++)
    {
        mut_add_a(D, A, B);
        // mut_add_b(D, A, B);
    }
    return 0;
}

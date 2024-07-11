#include <stdio.h>

typedef struct obj
{
    int value;
    char *dummy;
} obj;

int lt(obj *a, obj *b)
{
    return (a->value < b->value);
}

void cp(obj *dest, obj *src)
{
    dest->value = src->value;
    dest->dummy = src->dummy;
}

void qsort(obj *data, int low, int high)
{
    if (low > high)
        return;
    int i = low;
    int j = high;
    int p = (high + low) / 2;
    obj x;
    cp(&x, &data[p]);
    while (i <= j)
    {
        while (lt(&data[i], &x)) // data[i] < x
            i++;
        while (lt(&x, &data[j]))
            j--;
        if (i <= j)
        {
            obj t;
            cp(&t, &data[i]);
            cp(&data[i++], &data[j]);
            cp(&data[j--], &t);
        }
    }
    qsort(data, low, j);
    qsort(data, i, high);
}

int main(int argc, char const *argv[])
{
    obj data[] = {
        {1, "aaa"},
        {4, "ddd"},
        {6, "fff"},
        {8, "hhh"},
        {10, "jjj"},
        {12, "lll"},
        {3, "ccc"},
        {7, "ggg"},
        {2, "bbb"},
        {9, "iii"},
        {5, "eee"},
        {11, "kkk"},
    };
    qsort(data, 0, 11);
    puts("sorted!");
    return 0;
}

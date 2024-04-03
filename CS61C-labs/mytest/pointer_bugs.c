#include <stdio.h>

void my_strcat(char *s, char *t)
{
    while (*++s)
        ;
    while (*s++ = *t++)
        ;
}
int main()
{
    char s[100] = "liming";
    char t[] = ", I love you!";
    printf("%s\n", s);
    my_strcat(s, t);
    printf("%s", s);
    return 0;
}

/*
 Write a pointer version of the function strcat that we showed in Chapter 2:
strcat(s,t) copies the string t to the end of s.
*/

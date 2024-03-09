#include <stdio.h>
extern void gay();
extern void custom_printf(const char* format, ...);

int main()
{
    custom_printf("%%a%ca%ca%c   %s:\n", 'p', 'e', 'x', "12345");
    return 0;
}

int test_function()
{
    printf("End of programm!\n");
    return 1;
}
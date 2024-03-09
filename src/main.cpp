#include <stdio.h>
extern void gay();
extern void custom_printf(const char* format, ...);

int main()
{
    custom_printf("aaa%daaa\n", 12);
    return 0;
}

int test_function()
{
    printf("End of programm!\n");
    return 1;
}
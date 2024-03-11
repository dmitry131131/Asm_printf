#include <stdio.h>
extern void gay();
extern void custom_printf(const char* format, ...);

int main()
{
    custom_printf("%c %% %c %c %c %c %c %s %o %b:\n", '1', '2', '3', '4', '5', '6', "12345", 232323, -1);
    return 0;
}

int test_function()
{
    printf("End of programm!\n");
    return 1;
}
#include <stdio.h>
extern void gay();
extern int custom_printf(const char* format, ...);

int main()
{
    int a = custom_printf("%c %% %c %c %c %c %x %s %o %b %d:\n", '1', '2', '3', '4', '5', 0, "12345", 22323, 110, -123);
    int b = printf(       "%c %% %c %c %c %c %x %s %o %b %d:\n", '1', '2', '3', '4', '5', 0, "12345", 22323, 110, -1);

    printf("MY: %d\n", a);
    printf("DEF: %d\n", b);
    
    return 0;
}

int test_function()
{
    printf("End of programm!\n");
    return 1;
}
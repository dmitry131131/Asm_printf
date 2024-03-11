#include <stdio.h>
extern void gay();
extern int custom_printf(const char* format, ...);

int main()
{
    int a = custom_printf("%c %% %c %c %c %c %x %s %o %b %d:\n", '1', '2', '3', '4', '5', 0, "12345", 22323, 110, __INT_MAX__);
    int b = printf(       "%c %% %c %c %c %c %x %s %o %b %d:\n", '1', '2', '3', '4', '5', 0x12a, "12345", 232323, 0xb, 0);

    printf("MY: %d\n", a);
    printf("DEF: %d\n", b);
    
    return 0;
}

int test_function()
{
    printf("End of programm!\n");
    return 1;
}
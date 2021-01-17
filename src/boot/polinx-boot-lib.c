#define ture 1

void cpuHlt()
{
    __asm__("HLT");
}
void readSector(int cylinder, int head, int sector, int targetAddr)
{
    __asm__("HLT");
}
void printStr(char *addr, int len);
// {
//     __asm__("movl %0, %%ecx\n\t"
//             "movl %1, %%ebp\n\t"
//             "movw $0x1301, %%ax\n\t"
//             "movw $0x000c, %%bx\n\t"
//             "movb $0x00, %%dl\n\t"
//             "int $0x10\n\t"
//             :
//             : "r"(addr), "r"(len)
//             : "%eax", "%ebx", "%ecx", "%edx");
// }
char s[] = "polinx start! ";

void loadPolinx()
{
    printStr(s, 10);
    while (ture)
    {
        cpuHlt();
    }
}
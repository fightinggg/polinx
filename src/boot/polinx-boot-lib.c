#define ture 1

void cpuHlt();
void readSector(short cylinder, short head, short sector, short targetAddr);
void printStr(char* addr);


void loadPolinx()
{
    readSector(0, 0, 2, 0x7e00 / 16);
    while (ture)
    {
        cpuHlt();
    }
}
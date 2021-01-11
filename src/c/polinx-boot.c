

char s[] = "21323";

void readHead(int cylinder, int head, int targetAddr)
{
    for (int i = 0; i < 2880; i++, targetAddr += 512 / 16)
    {
        int cylinder = i / 36;
        int head = i / 18 % 2;
        int sector = i % 18;
        readSector(cylinder, head, sector, targetAddr);
    }
}

void readCylinder(int cylinder, int targetAddr)
{
    readHead(cylinder, 0, targetAddr);
    readHead(cylinder, 1, targetAddr + 18 * 512 / 4);
}

void readI82078(int targetAddr)
{
    for (int i = 0; i < 10; i++)
    {
        readCylinder(i, targetAddr + i * 2 * 18 * 512 / 4);
    }
}

int main()
{
    //readSector(0,0,0,0);
    // printStr(0,0);
}
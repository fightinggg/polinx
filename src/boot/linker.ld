ENTRY(start)

SECTIONS
{
    . = 0x007c00;
    
    .text :
    {
        *.o(.text)
    }
    .data :
    {
	    *.o(.data)
    }
}
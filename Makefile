build :
	nasm src/asm/polinx-boot.nasm -o target/boot.bin
	dd if=target/boot.bin of=target/boot.img bs=512 count=2880

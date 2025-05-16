FBC=fbc32 #使用fbc32位编译器
AS=as
LD=ld
OBJCOPY=objcopy

#请配置工具链
TARGET=./system.img

$(TARGET):./bootsect.o ./kernel.o ./display.o ./crt.o ./log.o ./memory.o
#$$$$$$$$$$$$$$$$$$
	$(LD) -m i386pe bootsect.o kernel.o display.o crt.o log.o memory.o -e _entry -Ttext 0x7c00 -o ./system.img
#链接文件，bootsect必须在前面，不知道为啥，在后面系统就进不去
	
	$(OBJCOPY) -O binary ./system.img
#将目标文件转换成纯二进制文件


#$$$$$$$$$$$$$$$$$$
./kernel.o:./kernel.bas
	$(FBC) ./kernel.bas -c -v -o ./kernel.o

./display.o:./display.bas
	$(FBC) ./display.bas -c -v -o ./display.o

./crt.o:./crt.bas
	$(FBC) ./crt.bas -c -v -o ./crt.o

./log.o:./log.bas
	$(FBC) ./log.bas -c -v -o ./log.o

./memory.o:./memory.bas
	$(FBC) ./memory.bas -c -v -o ./memory.o

./bootsect.o:./bootsect.asm
	$(AS) --32 ./bootsect.asm -o ./bootsect.o

.PHONY:clean
clean:


#$$$$$$$$$$$$$$$$$$
	del .\system.img .\bootsect.o .\kernel.o .\display.o .\crt.o .\log.o .\memory.o


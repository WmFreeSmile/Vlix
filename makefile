FBC=fbc32 #使用fbc32位编译器
AS=as
LD=ld
OBJCOPY=objcopy

#请配置工具链
TARGET=./system.img

#$$$$$$$$$$$$$$$$$$
$(TARGET):./bootsect.o ./kernel.o ./display.o ./crt.o ./log.o ./memory.o ./idt.o ./isr.o ./pic.o ./devices.o ./device_rand.o ./util.o ./device_pit.o
	
#$$$$$$$$$$$$$$$$$$
	$(LD) -m i386pe bootsect.o kernel.o display.o crt.o log.o memory.o idt.o isr.o pic.o devices.o device_rand.o util.o device_pit.o -e _entry -Ttext 0x7c00 -o ./system.img
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

./idt.o:./idt.bas
	$(FBC) ./idt.bas -c -v -o ./idt.o

./isr.o:./isr.bas
	$(FBC) ./isr.bas -c -v -o ./isr.o

./pic.o:./pic.bas
	$(FBC) ./pic.bas -c -v -o ./pic.o

./devices.o:./devices.bas
	$(FBC) ./devices.bas -c -v -o ./devices.o

./device_rand.o:./device_rand.bas
	$(FBC) ./device_rand.bas -c -v -o ./device_rand.o

./util.o:./util.bas
	$(FBC) ./util.bas -c -v -o ./util.o
	
./device_pit.o:./device_pit.bas
	$(FBC) ./device_pit.bas -c -v -o ./device_pit.o

./bootsect.o:./bootsect.s
	$(AS) --32 ./bootsect.s -o ./bootsect.o

.PHONY:clean
clean:


#$$$$$$$$$$$$$$$$$$
	del .\system.img .\bootsect.o .\kernel.o .\display.o .\crt.o .\log.o .\memory.o .\idt.o .\isr.o .\pic.o .\devices.o .\device_rand.o .\util.o .\device_pit.o


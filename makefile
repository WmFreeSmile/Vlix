FBC=fbc32 #使用fbc32位编译器
AS=as
LD=ld
OBJCOPY=objcopy

#请配置工具链

ifeq ($(OS),Windows_NT)
    RM := del /S /Q
    RMDIR := rmdir /S /Q
else
    RM := rm -f
    RMDIR := rm -rf
endif


#设置目录变量
INC_DIR=./include/
SRC_DIR=./src/
TARGET_DIR=./target/

#设置目标文件
TARGET=$(TARGET_DIR)system.img

CFLAGS = -c#声明编译的选项
LFLAG = -m i386pe#链接器选项

#指定目标，其实可有可无
all:$(TARGET)

$(TARGET): $(TARGET_DIR)bootsect.o \
			$(TARGET_DIR)display.o \
			$(TARGET_DIR)idt.o \
			$(TARGET_DIR)isr.o \
			$(TARGET_DIR)kernel.o \
			$(TARGET_DIR)log.o \
			$(TARGET_DIR)memory.o \
			$(TARGET_DIR)pic.o \
			$(TARGET_DIR)util.o \
								\
			$(TARGET_DIR)crt/crt.o \
			$(TARGET_DIR)devices/device_keyboard.o \
			$(TARGET_DIR)devices/device_pit.o \
			$(TARGET_DIR)devices/device_rand.o \
			$(TARGET_DIR)devices/devices.o
	
	$(LD) $(LFLAG) $(TARGET_DIR)bootsect.o \
					$(TARGET_DIR)display.o \
					$(TARGET_DIR)idt.o \
					$(TARGET_DIR)isr.o \
					$(TARGET_DIR)kernel.o \
					$(TARGET_DIR)log.o \
					$(TARGET_DIR)memory.o \
					$(TARGET_DIR)pic.o \
					$(TARGET_DIR)util.o \
										\
					$(TARGET_DIR)crt/crt.o \
					$(TARGET_DIR)devices/device_keyboard.o \
					$(TARGET_DIR)devices/device_pit.o \
					$(TARGET_DIR)devices/device_rand.o \
					$(TARGET_DIR)devices/devices.o \
					-e _entry -Ttext 0x7c00 -o $(TARGET)
	$(OBJCOPY) -O binary $(TARGET)
	


$(TARGET_DIR)display.o \
$(TARGET_DIR)idt.o \
$(TARGET_DIR)isr.o \
$(TARGET_DIR)kernel.o \
$(TARGET_DIR)log.o \
$(TARGET_DIR)memory.o \
$(TARGET_DIR)pic.o \
$(TARGET_DIR)util.o \
					\
$(TARGET_DIR)crt/crt.o \
$(TARGET_DIR)devices/device_keyboard.o \
$(TARGET_DIR)devices/device_pit.o \
$(TARGET_DIR)devices/device_rand.o \
$(TARGET_DIR)devices/devices.o \
	: $(SRC_DIR)display.bas \
		$(SRC_DIR)idt.bas \
		$(SRC_DIR)isr.bas \
		$(SRC_DIR)kernel.bas \
		$(SRC_DIR)log.bas \
		$(SRC_DIR)memory.bas \
		$(SRC_DIR)pic.bas \
		$(SRC_DIR)util.bas \
							\
		$(SRC_DIR)crt/crt.bas \
		$(SRC_DIR)devices/device_keyboard.bas \
		$(SRC_DIR)devices/device_pit.bas \
		$(SRC_DIR)devices/device_rand.bas \
		$(SRC_DIR)devices/devices.bas 
	
	mkdir .\target\crt
	mkdir .\target\devices
	
	$(FBC) $(CFLAGS) $(SRC_DIR)display.bas -o $(TARGET_DIR)/display.o
	$(FBC) $(CFLAGS) $(SRC_DIR)idt.bas -o $(TARGET_DIR)idt.o
	$(FBC) $(CFLAGS) $(SRC_DIR)isr.bas -o $(TARGET_DIR)isr.o
	$(FBC) $(CFLAGS) $(SRC_DIR)kernel.bas -o $(TARGET_DIR)kernel.o
	$(FBC) $(CFLAGS) $(SRC_DIR)log.bas -o $(TARGET_DIR)log.o
	$(FBC) $(CFLAGS) $(SRC_DIR)memory.bas -o $(TARGET_DIR)memory.o
	$(FBC) $(CFLAGS) $(SRC_DIR)pic.bas -o $(TARGET_DIR)pic.o
	$(FBC) $(CFLAGS) $(SRC_DIR)util.bas -o $(TARGET_DIR)util.o
	
	$(FBC) $(CFLAGS) $(SRC_DIR)crt/crt.bas -o $(TARGET_DIR)crt/crt.o
	$(FBC) $(CFLAGS) $(SRC_DIR)devices/device_keyboard.bas -o $(TARGET_DIR)devices/device_keyboard.o
	$(FBC) $(CFLAGS) $(SRC_DIR)devices/device_pit.bas -o $(TARGET_DIR)devices/device_pit.o
	$(FBC) $(CFLAGS) $(SRC_DIR)devices/device_rand.bas -o $(TARGET_DIR)devices/device_rand.o
	$(FBC) $(CFLAGS) $(SRC_DIR)devices/devices.bas -o $(TARGET_DIR)devices/devices.o
	
$(TARGET_DIR)bootsect.o:$(SRC_DIR)bootsect.s
	$(AS) --32 $(SRC_DIR)bootsect.s -o $(TARGET_DIR)bootsect.o

.PHONY:clean
clean:
	$(RMDIR) target
	mkdir target

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

ifeq ($(OS),Windows_NT)
    CHECK_DIR = @if not exist "$1" (mkdir "$1" & echo Created directory: $1)
else
    CHECK_DIR = @if [ ! -d "$1" ]; then mkdir -p "$1"; echo Created directory: $1; fi
endif

#设置目录变量
INC_DIR=./include/
SRC_DIR=./src/
TARGET_DIR=./target/

#设置目标文件
TARGET=$(TARGET_DIR)floppy.img

CFLAGS = -c#声明编译的选项
LFLAG = -m i386pe#链接器选项

#指定目标，其实可有可无
all:CHECK_DIR $(TARGET)

CHECK_DIR:
	$(call CHECK_DIR,target)
	
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
			$(TARGET_DIR)devices/devices.o \
										\
			$(TARGET_DIR)fbrt/fbrt.o
	
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
												\
					$(TARGET_DIR)fbrt/fbrt.o \
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
							\
$(TARGET_DIR)fbrt/fbrt.o \
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
		$(SRC_DIR)devices/devices.bas \
								\
		$(SRC_DIR)fbrt/fbrt.bas
	
	mkdir .\target\crt
	mkdir .\target\devices
	
	mkdir .\target\fbrt
	
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
	
	$(FBC) $(CFLAGS) $(SRC_DIR)fbrt/fbrt.bas -o $(TARGET_DIR)fbrt/fbrt.o

#过了编译，再把符号名改回来
	$(OBJCOPY) $(TARGET_DIR)fbrt/fbrt.o --redefine-sym _fb_ArrayErase_bak@4=_fb_ArrayErase@4
	$(OBJCOPY) $(TARGET_DIR)fbrt/fbrt.o --redefine-sym _fb_ErrorSetNum_bak@4=_fb_ErrorSetNum@4
	
	
$(TARGET_DIR)bootsect.o:$(SRC_DIR)bootsect.s
	$(AS) --32 $(SRC_DIR)bootsect.s -o $(TARGET_DIR)bootsect.o

.PHONY:clean
clean:
	$(RMDIR) target



#include once "../include/help.bi"

#include once "../include/crt/crt.bi"
#include once "../include/display.bi"
#include once "../include/log.bi"
#include once "../include/memory.bi"
#include once "../include/idt.bi"
#include once "../include/devices/devices.bi"
#include once "../include/util.bi"

sub _kernel_loop()
	asm
		jmp $
	end asm
end sub


sub test()
	
	/'
	_kdisplay_print("Press the spacebar to get a random number")
	dim nKeyCode as ubyte
	while true
		nKeyCode=_kdevice_keyboard_getkey()
		if nKeyCode=VK_SPACE then
			_kdisplay_print_ulong(GetRandNumber())
		end ISR_INTFRAME_REG_DS
		_ksleep(200)
	wend'/
	
	
	_kdisplay_print("HelloWorld")
	
end sub

extern "c"

sub _kernel_entry cdecl()
	asm
		mov ax, 0x0010
		mov ds, ax
		mov gs, ax
		mov es, ax
		
		mov esp, 0xFFFE
		'初始化栈

		xor eax, eax
		mov ebx, eax
		mov ecx, eax
		mov edx, eax
		'清空所有数据寄存器
	end asm

	_kdisplay_init()
	_kmemory_init()
	_kidt_init()
	_kdevices_init()
	_kidt_enable(true)
	
	test()
	
	/'
	_kdisplay_print("sleep:")
	
	dim count as integer
	while true
		_kdisplay_print_ulong(count)
		count=count+1
		_ksleep(1000)
	wend'/
	
	_kernel_loop()
end sub

end extern

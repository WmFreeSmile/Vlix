

#include once "help.bi"

#include once "crt.bi"
#include once "display.bi"
#include once "log.bi"
#include once "memory.bi"




sub _kernel_loop()
	asm
		jmp $
	end asm
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
	'_kidt_init()
	'_kdevices_init()
	'_kidt_enable()
	
	
	_kernel_loop()
end sub

end extern

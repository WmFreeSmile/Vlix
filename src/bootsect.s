.intel_syntax noprefix
.extern __kernel_entry

.code16
.text
  .global _entry
  _entry:

  # 重置寄存器
  mov ax, 0x0000
  mov cx, ax
  mov dx, ax
  mov bx, ax
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  # 显示器设置
  mov ax, 0x0003  # 设置显示器 (80x25 16色文本)
  #mov ax,0x0013 # 320×200 256色
  int 0x10
  
  
  lea ax, _msg_load
  call _func_print
  
  
  # ==============加载内核程序
  lea ax, _msg_ldisk
  call _func_print
  
  
  # ES:BX 缓冲区的地址   真实地址计算 es*16+bx
  mov ax, 0x00
  mov es, ax
  mov ah, 0x02      # 功能码 读扇区
  mov bx, 0x7E00    # 把内核程序加载到7E00
  mov al, 0x40      # 扇区数
  mov ch, 0x00      # 柱面
  mov cl, 0x02      # 扇区
  mov dh, 0x00      # 磁头
  mov dl, 0x80      # 驱动器   00~7F：软盘           80~FF：硬盘
  #mov dl, 0x00

  int 0x13
  cmp ah, 0x00      # 是否成功
  jnz _label_failed
  xor ax, ax        # 清空寄存器 返回成功
  
  lea ax, _msg_success
  call _func_print
  
  
  # ==============加载全局描述符表，也就是GDT
  lea ax, _msg_lgdt
  call _func_print
  
  xchg bx,bx
  lgdt ds:[_GDT_HEADER]

  
  # ==============切换保护模式
  lea ax, _msg_entrypm
  call _func_print
  
  xor eax, eax

  cli               # 关闭中断
  
  in al, 0x92
  or al, 2          # 打开 A20地址线
  out 0x92, al

  mov eax, cr0      # 启动保护模式
  or al, 1
  mov cr0, eax
  
  jmp 0x08:__kernel_entry   #跳到内核里面
  
  _label_failed:
  lea ax, _msg_failed
  call _func_print
  hlt

  # 打印字串
  _func_print:
    mov si, ax
    _label_loop:
    lodsb
    cmp al, 0x00
    jz _label_exit # 0表示字符串末尾，跳出函数
    mov ah, 0x0e
    int 0x10
    jmp _label_loop
    _label_exit:
  ret


# 保存的字串
.org 0x150
  _msg_success: .asciz " SUCCESS!\r\n"
  _msg_failed:  .asciz " FAILED!\r\n"
  _msg_load:    .asciz " Bootsect Loaded\r\n"
  _msg_ldisk:   .asciz " Loading System Kernel..."
  _msg_lgdt:    .asciz " Loading GDT.\r\n"
  _msg_entrypm: .asciz " Entry into Protected Mode..."

# 全局描述符表
.org 0x1D0
  _GDT_HEADER:
    .2byte _GDT_ENTRIES_END - _GDT_ENTRIES  # GDT Size
    .4byte _GDT_ENTRIES                     # GDT Base

  _GDT_ENTRIES:
    _GDT_NULL:
      .2byte 0x0000   # limit low
      .2byte 0x0000   # base low
      .byte  0x00     # base middle
      .byte  0x00     # access type
      .byte  0x00     # limit high, flags
      .byte  0x00     # base high

    _GDT_CODE32:
      # Base  0x00000000
      # Limit 0x000FFFFF
      # Access 1(Pr) 00(Privl) 1(S) 1(Ex) 0(DC) 1(RW) 1(Ac)
      # Flag   1(Gr) 1(Sz) 0(Null) 0(Null)
      .2byte 0xFFFF   # limit low
      .2byte 0x0000   # base low
      .byte  0x00     # base middle
      .byte  0x9A     # access type
      .byte  0xCF     # limit high, flags
      .byte  0x00     # base high

    _GDT_DATA:
      # Base  0x00000000
      # Limit 0x000FFFFF
      # Access 1(Pr) 00(Privl) 1(S) 0(Ex) 0(DC) 1(RW) 1(Ac)
      # Flag   1(Gr) 1(Sz) 0(Null) 0(Null)
      .2byte 0xFFFF   # limit low
      .2byte 0x0000   # base low
      .byte  0x00     # base middle
      .byte  0x93     # access type
      .byte  0xCF     # limit high, flags
      .byte  0x00     # base high

    _GDT_VIDEO:
  _GDT_ENTRIES_END:


.org 0x1FE
  .2byte 0xAA55

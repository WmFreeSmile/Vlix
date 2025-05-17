.intel_syntax noprefix
.equ BOOTSTART, 0x07c0
.equ KRNLNBOOT, 0x07e0
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
  int 0x10
  
  
  
  
  lea ax, _msg_load
  call _func_print
  #print "Bootsect Loaded"
  
  
  
  
  
  # 加载内核程序
  lea ax, _msg_ldisk
  call _func_print
  #print "Loading System Kernel...";
  
  mov ax, KRNLNBOOT # 中斷參數 緩衝區
  mov es, ax
  mov ah, 0x02      # 中斷函數
  mov bx, 0x0000    # 中斷參數 緩衝區偏移
  mov al, 0x40      # 中斷參數 讀取扇區數
  mov ch, 0x00      # 中斷參數 柱面號
  mov cl, 0x02      # 中斷參數 扇區號
  mov dh, 0x00      # 中斷參數 磁頭號
  mov dl, 0x00      # 中斷參數 驅動器號

  int 0x13          # 調用中斷
  cmp ah, 0x00      # 是否成功
  jnz _flag_e
  xor ax, ax        # 清空寄存器 返回成功
  
  lea ax, _msg_success
  call _func_print
  #print "SUCCESS!"
  
  
  
  
  
  # 加载全局描述符表，也就是GDT
  lea ax, _msg_lgdt
  call _func_print
  #print "Loading GDT...";
  
  xchg bx,bx
  lgdt ds:[_GDT_HEADER] # 加載GDT
  
  lea ax, _msg_success
  call _func_print
  #print "SUCCESS!"




  # 切换保护模式
  lea ax, _msg_entrypm
  call _func_print
  #print "Entry into Protected Mode...";
  
  xor eax, eax

  cli               # 关闭中断
  
  in al, 0x92
  or al, 2          # 打开 A20地址线
  out 0x92, al

  mov eax, cr0      # 启动保护模式
  or al, 1
  mov cr0, eax
  
  call _func_main
  
  
  
  _flag_e:
  lea ax, _msg_failed
  call _func_print

  hlt

  # 打印字符
  #   al = 字符
  _func_print_ch:
    mov ah, 0x0e
    int 0x10
  ret

  /*

  # 打印字串
  # 遍歷字串打印法
  #   ax = 字串指針
  _func_print:
    mov si, ax      # 參數 字串所在指針
    
    _flag_b:
      mov ax, [si]     # 取出數據
      cmp al, 0x00    # 是否爲\0
      jz _flag_a

      mov ah, 0x0e    # 中斷函數
      int 0x10        # 調用中斷函數
      inc si          # 指針遞增
      jmp _flag_b

    _flag_a:
  ret
  */

  # 打印字串
  # 中斷函數打印法
  #   ax = 字串指針
  _func_print:
    mov si, ax      # 參數 字串所在指針
    
    _flag_d:
      lodsb           # 加載指針
      cmp al, 0x00    # 是否加載成功
      jz _flag_c
      
      mov ah, 0x0e    # 中斷函數
      int 0x10
      jmp _flag_d

    _flag_c:
  ret



  
  _func_main:
    jmp 0x08:__kernel_entry
  ret


# 保存的字串
.org 0x150
  _msg_success: .asciz " SUCCESS!\r\n"
  _msg_failed:  .asciz " FAILED!\r\n"
  _msg_load:    .asciz " Bootsect Loaded\r\n"
  _msg_ldisk:   .asciz " Loading System Kernel..."
  _msg_lgdt:    .asciz " Loading GDT..."
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

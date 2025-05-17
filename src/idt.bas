#include once "../include/help.bi"

#include once "../include/idt.bi"
#include once "../include/crt/crt.bi"
#include once "../include/log.bi"
#include once "../include/isr.bi"
#include once "../include/pic.bi"

dim shared m_lpIdtDescr as integer
dim shared m_lpIdtTable as integer


sub _kidt_init()
    m_lpIdtDescr=KERNEL_KIDT_IDTR_BASEADDR
    m_lpIdtTable=KERNEL_KIDT_IDT_BASEADDR
    _kidt_reset()
    _kisr_reset()
    _kpic_remap()
end sub

sub _kidt_reset()
    *cast(short ptr,m_lpIdtDescr)=KERNEL_KIDT_IDT_MAXSIZE*KERNEL_KIDT_SIZEOF_IDT-1
    *cast(long ptr,m_lpIdtDescr+2)=m_lpIdtTable
    
    memset(cast(any ptr,m_lpIdtTable),0,KERNEL_KIDT_IDT_MAXSIZE*KERNEL_KIDT_SIZEOF_IDT)
    
    _kidt_update(m_lpIdtDescr)
    _klog_logo(TAG_KIDT,"Reload IDT table.")
end sub

sub _kidt_update(lpIDTDescr as integer)
    asm
        mov eax,[ebp+8]
        lidt [eax]
        'pop ebp
        'ret 4
    end asm
end sub

sub _kidt_enable(blEnable as bool)
    asm
        mov eax,[ebp+8]
        cmp eax,0
        
        jz dis
        
        ena:
        sti
        jmp exit
        
        dis:
        cli
        
        exit:
        'pop ebp
        'ret 4
        
    end asm
end sub

sub _kidt_install(nIndex as ubyte,nGateType as ubyte,nGateFlag as ubyte,nSelector as short,lpfnIrqAddress as sub())
    dim lpElement as integer=m_lpIdtTable+nIndex*KERNEL_KIDT_SIZEOF_IDT
    
    *cast(longint ptr,lpElement)=0
    
    cast(short ptr,lpElement)[0]=cast(integer,lpfnIrqAddress) and 65535
    cast(short ptr,lpElement)[1]=nSelector
    cast(short ptr,lpElement)[2]=cast(short,(nGateFlag shl 4) or nGateType) shl 8
    cast(short ptr,lpElement)[3]=cast(integer,lpfnIrqAddress) shr 16
end sub

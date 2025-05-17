#include once "help.bi"
#include once "isr.bi"
#include once "log.bi"
#include once "idt.bi"
#include once "gdt.bi"
#include once "irq.bi"

dim shared m_IsrHandlers(15) as sub(as integer)

#macro FAULTDEF(i)
sub _kisr_irq_fault##i naked()
    asm
        xchg bx,bx
        cli
        push ##i
        jmp _kisr_stub
    end asm
end sub
#endmacro

#macro IRQDEF(i)
sub _kisr_irq##i naked()
    asm
        cli
        push ##i
        jmp _kisr_stub
    end asm
end sub
#endmacro

sub _kisr_stub naked()
    asm
        pushad
        push ds
        push es
        push fs
        push gs
        
        
        mov ax,0x0010
        mov ds,ax
        mov es,ax
        mov fs,ax
        mov gs,ax
        
        mov eax,esp
        push eax
        call _kisr_handler
        
        pop gs
        pop fs
        pop es
        pop ds
        popad
        
        pop eax
        iretd
    end asm
end sub

FAULTDEF(0):FAULTDEF(1):FAULTDEF(2):FAULTDEF(3)
FAULTDEF(4):FAULTDEF(5):FAULTDEF(6):FAULTDEF(7)
FAULTDEF(8):FAULTDEF(9):FAULTDEF(10):FAULTDEF(11)
FAULTDEF(12):FAULTDEF(13):FAULTDEF(14):FAULTDEF(15)
FAULTDEF(16):FAULTDEF(17):FAULTDEF(18):FAULTDEF(19)
FAULTDEF(20):FAULTDEF(21):FAULTDEF(22):FAULTDEF(23)
FAULTDEF(24):FAULTDEF(25):FAULTDEF(26):FAULTDEF(27)
FAULTDEF(28):FAULTDEF(29):FAULTDEF(30):FAULTDEF(31)

IRQDEF(32):IRQDEF(33):IRQDEF(34):IRQDEF(35)
IRQDEF(36):IRQDEF(37):IRQDEF(38):IRQDEF(39)
IRQDEF(40):IRQDEF(41):IRQDEF(42):IRQDEF(43)
IRQDEF(44):IRQDEF(45):IRQDEF(46):IRQDEF(47)


sub _kisr_unknown naked()
    asm
        xchg bx,bx
        cli
        pop eax
        push 255
        jmp _kisr_stub
    end asm
end sub

sub _kisr_handler(lpIntStackFrame as integer)
    dim nIntIndex as ubyte=*cast(long ptr,lpIntStackFrame)
    
    if nIntIndex<=31 then
        
        select case nIntIndex
            case 0
                _klog_logd(TAG_KISR,"Exception occurred_0!")
            case 1
                _klog_logd(TAG_KISR,"Exception occurred_1!")
            case 2
                _klog_logd(TAG_KISR,"Exception occurred_2!")
            case 3
                _klog_logd(TAG_KISR,"Exception occurred_3!")
            case 4
                _klog_logd(TAG_KISR,"Exception occurred_4!")
            case 5
                _klog_logd(TAG_KISR,"Exception occurred_5!")
            case 6
                _klog_logd(TAG_KISR,"Exception occurred_6!")
            case 7
                _klog_logd(TAG_KISR,"Exception occurred_7!")
            case 8
                _klog_logd(TAG_KISR,"Exception occurred_8!")
            case 9
                _klog_logd(TAG_KISR,"Exception occurred_9!")
            case 10
                _klog_logd(TAG_KISR,"Exception occurred_10!")
            case 11
                _klog_logd(TAG_KISR,"Exception occurred_11!")
            case 12
                _klog_logd(TAG_KISR,"Exception occurred_12!")
            case 13
                _klog_logd(TAG_KISR,"Exception occurred_13!")
            case 14
                _klog_logd(TAG_KISR,"Exception occurred_14!")
            case 15
                _klog_logd(TAG_KISR,"Exception occurred_15!")
            case 16
                _klog_logd(TAG_KISR,"Exception occurred_16!")
            case 17
                _klog_logd(TAG_KISR,"Exception occurred_17!")
            case 18
                _klog_logd(TAG_KISR,"Exception occurred_18!")
            case 19
                _klog_logd(TAG_KISR,"Exception occurred_19!")
            case 20
                _klog_logd(TAG_KISR,"Exception occurred_20!")
            case 21
                _klog_logd(TAG_KISR,"Exception occurred_21!")
            case 22
                _klog_logd(TAG_KISR,"Exception occurred_22!")
            case 23
                _klog_logd(TAG_KISR,"Exception occurred_23!")
            case 24
                _klog_logd(TAG_KISR,"Exception occurred_24!")
            case 25
                _klog_logd(TAG_KISR,"Exception occurred_25!")
            case 26
                _klog_logd(TAG_KISR,"Exception occurred_26!")
            case 27
                _klog_logd(TAG_KISR,"Exception occurred_27!")
            case 28
                _klog_logd(TAG_KISR,"Exception occurred_28!")
            case 29
                _klog_logd(TAG_KISR,"Exception occurred_29!")
            case 30
                _klog_logd(TAG_KISR,"Exception occurred_30!")
            case 31
                _klog_logd(TAG_KISR,"Exception occurred_31!")
        end select
        return
    end if
    
    dim lpfnFunction as sub(as integer)=m_IsrHandlers(nIntIndex-32)
    if lpfnFunction<>0 then
        cast(sub(as integer),lpfnFunction)(lpIntStackFrame)
    else
        _klog_logd(TAG_KISR,"unknown IRQ received.")
    end if
    
    if nIntIndex>=40 then
        asm
            mov al,0x20
            out 0xa0,al
        end asm
    end if
    
    asm
        mov al,0x20
        out 0x20,al
    end asm
    
end sub

function _kisr_get_service(nIndex as ubyte) as sub()
    dim _kisr_fault_table(47) as sub() ={ _
        @_kisr_irq_fault0,@_kisr_irq_fault1,@_kisr_irq_fault2,@_kisr_irq_fault3, _
        @_kisr_irq_fault4,@_kisr_irq_fault5,@_kisr_irq_fault6,@_kisr_irq_fault7, _
        @_kisr_irq_fault8,@_kisr_irq_fault9,@_kisr_irq_fault10,@_kisr_irq_fault11,  _
        @_kisr_irq_fault12,@_kisr_irq_fault13,@_kisr_irq_fault14,@_kisr_irq_fault15, _
        @_kisr_irq_fault16,@_kisr_irq_fault17,@_kisr_irq_fault18,@_kisr_irq_fault19, _
        @_kisr_irq_fault20,@_kisr_irq_fault21,@_kisr_irq_fault22,@_kisr_irq_fault23, _
        @_kisr_irq_fault24,@_kisr_irq_fault25,@_kisr_irq_fault26,@_kisr_irq_fault27, _
        @_kisr_irq_fault28,@_kisr_irq_fault29,@_kisr_irq_fault30,@_kisr_irq_fault31, _
        _
        @_kisr_irq32, @_kisr_irq33,@_kisr_irq34,@_kisr_irq35, _
        @_kisr_irq36,@_kisr_irq37,@_kisr_irq38,@_kisr_irq39, _
        @_kisr_irq40,@_kisr_irq41,@_kisr_irq42,@_kisr_irq43, _
        @_kisr_irq44,@_kisr_irq45,@_kisr_irq46,@_kisr_irq47 _
    }
    
    function=iif(nIndex<=47,_kisr_fault_table(nIndex),@_kisr_unknown)
end function

sub _kisr_reset()
    for i as integer=0 to 255
        _kidt_install(i,IDT_GATE_INT,IDT_FLAG_DEFAULT,GDT_SELECTOR_CODE32,_kisr_get_service(i))
    next
    _klog_logo(TAG_KISR,"Reset ISR service.")
end sub


function _kisr_install(nIrqIndex as ubyte,lpfnHandler as sub(as integer)) as bool
    if nIrqIndex>IRQ_MAX then return false
    if lpfnHandler=0 then return false
    
    m_IsrHandlers(nIrqIndex)=lpfnHandler
    function=true
end function

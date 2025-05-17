#include once "help.bi"
#include once "device_pit.bi"
#include once "log.bi"
#include once "isr.bi"
#include once "irq.bi"
#include once "log.bi"

#include once "devices.bi"

#include once "display.bi"

dim shared m_nShock as integer
dim shared m_nTickCount as longint

sub __callback_kdevice_pit(lpIntStackFrame as integer)
    m_nShock=m_nShock+1
    m_nTickCount=m_nTickCount+1
    
    '_kdisplay_print("tick")
    
    if m_nShock=100 then m_nShock=0
end sub

sub _kdevice_pit_init()
    _kisr_install(IRQ_PIT,@__callback_kdevice_pit)
    
    _kdevice_pit_frequency(200)
    
    _klog_logo(TAG_KDEVICES,"Timer actived!")
end sub

sub _kdevice_pit_frequency(nFreqHz as integer)
    asm
        mov al, 0x36
        out 0x43, al
        
        xor edx,edx
        mov eax,0x1234DC
        
        mov ebx, [ebp+8]
        div ebx
        mov edx, eax

        and eax, 0xff
        shr edx, 0x08

        out 0x40, al
        mov eax, edx

        out 0x40, al

        'pop ebp
        'ret 4
    end asm
end sub

sub _ksleep(nMilliSecond as integer)
    dim nTickCount as longint=m_nTickCount+nMilliSecond\10
    
    while nTickCount>=m_nTickCount : wend
    
end sub
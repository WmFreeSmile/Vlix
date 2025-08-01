#include once "../../include/help.bi"
#include once "../../include/devices/device_pit.bi"
#include once "../../include/log.bi"
#include once "../../include/isr.bi"
#include once "../../include/irq.bi"
#include once "../../include/log.bi"

#include once "../../include/devices/devices.bi"

#include once "../../include/display.bi"

dim shared m_nShock as integer
dim shared m_nTickCount as longint

sub __callback_kdevice_pit(lpIntStackFrame as integer)
    m_nShock=m_nShock+1
    m_nTickCount=m_nTickCount+1
    
    if m_nShock=1000 then m_nShock=0
end sub

sub _kdevice_pit_init()
    _kisr_install(IRQ_PIT,@__callback_kdevice_pit)
    
    _kdevice_pit_frequency(1000)
    
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
    dim nTickCount as longint=m_nTickCount+nMilliSecond
    
    while nTickCount>=m_nTickCount : wend
    
end sub


function GetTickCount() as longint
    function=m_nTickCount
end function


#include once "../../include/devices/device_keyboard.bi"
#include once "../../include/devices/devices.bi"

#include once "../../include/irq.bi"

#include once "../../include/isr.bi"
#include once "../../include/log.bi"

dim shared m_nKeyCode as ubyte
dim shared m_nKeyCodeExt as ubyte

dim shared m_nStatusCapsLock as integer
dim shared m_nStatusShift as integer
dim shared m_nStatusAlt as integer

dim shared _kdevice_scancodes(255) as ubyte={ _ 
  VK_NULL, VK_ESCAPE, VK_1, VK_2, VK_3, VK_4, VK_5, VK_6, _ ' 8
  VK_7, VK_8, VK_9, VK_0, VK_SEPARATOR, VK_NULL, VK_BACK, VK_TAB, _ ' 16
  VK_Q, VK_W, VK_E, VK_R, VK_T, VK_Y, VK_U, VK_I, _ ' 24
  VK_O, VK_P, VK_NULL, VK_NULL, VK_RETURN, VK_LEFT, VK_A, VK_S, _ ' 32
  VK_D, VK_F, VK_G, VK_H, VK_J, VK_K, VK_L, VK_NULL, _  ' 40
  VK_NULL, VK_NULL, VK_LSHIFT, VK_NULL, VK_Z, VK_X, VK_C, VK_V, _ ' 48
  VK_B, VK_N, VK_M, VK_NULL, VK_NULL, VK_NULL, VK_RSHIFT, VK_NULL,  _' 56
  VK_LMENU, VK_SPACE, VK_CAPITAL, VK_F1, VK_F2, VK_F3, VK_F4, VK_F5, _ ' 64
  VK_F6, VK_F7, VK_F8, VK_F9, VK_F10, VK_NUMLOCK, VK_SCROLL, VK_NUMPAD7, _ ' 72
  VK_NUMPAD8, VK_NUMPAD9, VK_NULL, VK_NUMPAD4, VK_NUMPAD5, VK_NUMPAD6, VK_NULL, VK_NUMPAD1, _ ' 80
  VK_NUMPAD2, VK_NUMPAD3, VK_NUMPAD0, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_F11, _ ' 88
  VK_F12, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _ ' 96
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _ ' 104
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _ ' 112
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _ ' 120
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _ ' 128
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _ 
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, _
  VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL, VK_NULL }

sub __callback_kdevice_keyboard(lpIntStackFrame as integer)
    dim nScanCode as ubyte=_kdevice_keyboard_read()
    
    if m_nKeyCodeExt<>0 then
        m_nKeyCode=_kdevice_keyboard_map_scancode2(m_nKeyCodeExt,nScanCode)
        m_nKeyCodeExt=0
        return
    end if
    
    if nScanCode=224 then
        m_nKeyCodeExt=nScanCode
    end if
    
    m_nKeyCode=_kdevice_keyboard_map_scancode(nScanCode)
end sub

sub _kdevice_keyboard_init()
    _kisr_install(IRQ_KEYBOARD,@__callback_kdevice_keyboard)
    _klog_logo(TAG_KDEVICES,"Keyboard actived!")
end sub


function _kdevice_keyboard_map_scancode(uScanCode as ubyte) as ubyte
    if uScanCode<&h80 then
        function=_kdevice_scancodes(uScanCode)
    else
        function=VK_NULL
    end if
end function

function _kdevice_keyboard_map_scancode2(uExtCode as ubyte,uScanCode as ubyte) as ubyte
    select case uExtCode
        case &hE0
            select case uScanCode
                case &h48
                    return VK_UP
                case &h4D
                    return VK_RIGHT
                case &h50
                    return VK_DOWN
                case &h4B
                    return VK_LEFT
            end select
    end select
    
    function=VK_NULL
end function

function _kdevice_keyboard_read naked() as ubyte
    asm
        in al,0x64
        and al,0x01
        
        cmp al,0x00
        je exit
        
        xor eax,eax
        in al,0x60
        
        exit:
        'pop ebp
        ret
    end asm
end function

function _kdevice_keyboard_getkey() as ubyte
    function=m_nKeyCode
end function
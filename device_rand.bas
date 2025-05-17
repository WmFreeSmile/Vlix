#include once "help.bi"
#include once "device_rand.bi"
#include once "log.bi"

dim shared m_blSupportedRdrand as bool

sub _kdevice_rand_init()
    _klog_logo(TAG_KRANDOM,"Check for cpu rand generator")
    
    m_blSupportedRdrand=_kdevice_rand_check_rdrand()
    if m_blSupportedRdrand then
        _klog_logo(TAG_KRANDOM,"This machine supported RDRAND")
    else
        _klog_logw(TAG_KRANDOM,"This machine not supported RDRAND")
    end if
end sub

function _kdevice_rand_check_rdrand naked() as bool
    asm
        mov eax, 1
        xor ecx, ecx
        cpuid
        shr ecx, 30
        and ecx, 1
        mov eax, ecx
        'pop ebp
        ret
    end asm
end function

function _kdevice_rand_next_rdrand naked() as integer
    asm
        mov ecx, 255
        
        _func_rnrand_retry:
        rdrand eax
        jnc _func_rnrand_ret
        loop _func_rnrand_retry
        
        _func_rnrand_ret:
        shr eax, 16
        
        'pop ebp
        ret
    end asm
end function

function _kdevice_rand_next() as integer
    if m_blSupportedRdrand then
        function=_kdevice_rand_next_rdrand()
    else
        '伪随机数
        function=0
    end if
end function

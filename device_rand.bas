#include once "help.bi"
#include once "device_rand.bi"
#include once "log.bi"
#include once "util.bi"

#include once "device_pit.bi"

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

function rand_IsSupportedRdrand() as bool
    function=m_blSupportedRdrand
end function


dim shared TickRecord(7) as longint
dim shared RecordIndex as integer

'封装随机数函数
function GetRandNumber() as integer
	if m_blSupportedRdrand then
		function=_kdevice_rand_next_rdrand()
	else
		TickRecord(RecordIndex)=GetTickCount()
		RecordIndex=RecordIndex+1
		if RecordIndex>ubound(TickRecord) then
			RecordIndex=0
		end if
		function=CRC32(@TickRecord(0),ARRAYSIZE(TickRecord)*sizeof(longint))
	end if
end function

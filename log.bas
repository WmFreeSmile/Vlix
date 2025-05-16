#include once "display.bi"
#include once "log.bi"



'log
sub _klog_log(nLevel as integer,szTag as zstring ptr,szMessage as zstring ptr)
	dim nCursorX as integer
	dim nCursorY as integer
	
	_kdisplay_cursor(nCursorX,nCursorY)
	
	nCursorX=nCursorX+2
	
	select case nLevel
		case KERNEL_KLOG_LEVELD
			_kdisplay_print("[ DD ] ",false)
			_kdisplay_attribute_set(nCursorX,nCursorY,7,3)
		case KERNEL_KLOG_LEVELO
			_kdisplay_print("[ OK ] ",false)
			_kdisplay_attribute_set(nCursorX,nCursorY,10,3)
		case KERNEL_KLOG_LEVELW
			_kdisplay_print("[ WN ] ",false)
			_kdisplay_attribute_set(nCursorX,nCursorY,14,3)
		case KERNEL_KLOG_LEVELE
			_kdisplay_print("[ EE ] ",false)
			_kdisplay_attribute_set(nCursorX,nCursorY,11,3)
		case KERNEL_KLOG_LEVELF
			_kdisplay_print("[ FE ] ",false)
			_kdisplay_attribute_set(nCursorX,nCursorY,12,3)
	end select
	
	_kdisplay_print(szTag,false)
	_kdisplay_print(" ",false)
	
	_kdisplay_print(szMessage,true)
end sub

sub _klog_logd(szTag as zstring ptr,szMessage as zstring ptr)
	_klog_log(KERNEL_KLOG_LEVELD,szTag,szMessage)
end sub

sub _klog_logo(szTag as zstring ptr,szMessage as zstring ptr)
	_klog_log(KERNEL_KLOG_LEVELO,szTag,szMessage)
end sub

#include once "help.bi"

const TAG_KDISPLAY="DISPLAY:"


const DISPLAY_WIDTH=80
const DISPLAY_HEIGHT=25

const KERNEL_KDISPLAY_BASEADDR=&hB8000
const KERNEL_KDISPLAY_LIMITADDR=&hB8FA0


declare sub _kdisplay_init()
declare sub _kdisplay_clear()
declare sub _kdisplay_print(lpszString as zstring ptr,bEndLine as bool=true)
declare sub _kdisplay_print_ulong(lpszString as ulong,bEndLine as bool=true)
declare sub _kdisplay_attribute_set(nPosX as integer,nPosY as integer,nAttribute as ubyte,nLength as integer=1)
declare sub _kdisplay_cursor(byref nPosX as integer,byref nPosY as integer)
declare sub _kdisplay_cursor_update(nPosX as integer,nPosY as integer)
declare sub _kdisplay_scroll()

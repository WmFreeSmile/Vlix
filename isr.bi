
const TAG_KISR="ISR    "

const ISR_SIZEOF_INTFRAME=52
const ISR_INTFRAME_REG_GS=0
const ISR_INTFRAME_REG_FS=1
const ISR_INTFRAME_REG_ES=2
const ISR_INTFRAME_REG_DS=3
const ISR_INTFRAME_REG_EDI=4
const ISR_INTFRAME_REG_ESI=5
const ISR_INTFRAME_REG_EBP=6
const ISR_INTFRAME_REG_ESP=7
const ISR_INTFRAME_REG_EBX=8
const ISR_INTFRAME_REG_EDX=9
const ISR_INTFRAME_REG_ECX=10
const ISR_INTFRAME_REG_EAX=11
const ISR_INTFRAME_INT=12

declare sub _kisr_stub naked()
declare sub _kisr_unknown naked()
declare sub _kisr_handler stdcall(lpIntStackFrame as integer)
declare function _kisr_get_service(nIndex as ubyte) as sub()
declare sub _kisr_reset()
declare function _kisr_install(nIrqIndex as ubyte,lpfnHandler as sub(as integer)) as bool

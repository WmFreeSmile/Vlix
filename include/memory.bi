const TAG_KMEMORY="MEMORY :"

const KERNEL_KMEMORY_RECORD_POINTER=0
const KERNEL_KMEMORY_RECORD_SIZE=1
const KERNEL_KMEMORY_RECORD_UNUSED=2

const KERNEL_KMEMORY_MAXSIZE=65535
const KERNEL_KMEMORY_LIMITADDR=2097152

const KERNEL_KMEMORY_SIZEOF_RECORD=12

const KERNEL_KMEMORY_BASEADDR=1048576

const KERNEL_KMEMORY_NOTIFY_MALLOC=0
const KERNEL_KMEMORY_NOTIFY_REALLOC=1
const KERNEL_KMEMORY_NOTIFY_FREEMEM=2


declare sub _kmemory_init()
declare function _kmemory_malloc(nSizeBytes as integer) as integer
declare function _kmemory_realloc(lpMemory as integer,nSizeBytes as integer) as integer
declare sub _kmemory_free(lpMemory as integer)

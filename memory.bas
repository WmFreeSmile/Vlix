#include once "memory.bi"
#include once "log.bi"

dim shared m_lpRecBaseAddr as integer
dim shared m_lpMemBaseAddr as integer
dim shared m_lpCurrentAddr as integer

dim shared m_nAllocatedCount as integer
dim shared m_nAllocatedMemSize as integer

'memory

sub _kmemory_init()
	m_lpRecBaseAddr=KERNEL_KMEMORY_BASEADDR
	m_lpMemBaseAddr=KERNEL_KMEMORY_BASEADDR+KERNEL_KMEMORY_MAXSIZE*KERNEL_KMEMORY_SIZEOF_RECORD
	m_lpCurrentAddr=m_lpMemBaseAddr
	
	m_nAllocatedCount=0
	m_nAllocatedMemSize=0
	
	_klog_logo(TAG_KMEMORY,"Memory management initialized successfully.")
end sub

function _kmemory_malloc(nSizeBytes as integer) as integer
	if m_nAllocatedCount>=KERNEL_KMEMORY_MAXSIZE then
		return 0
	end if
	if m_lpCurrentAddr>KERNEL_KMEMORY_LIMITADDR then
		return 0
	end if
	
	dim lpElementAddr as integer
	dim lpMemory as integer
	
	lpMemory=m_lpCurrentAddr
	m_lpCurrentAddr=m_lpCurrentAddr+nSizeBytes
	
	lpElementAddr=m_lpRecBaseAddr+m_nAllocatedCount*KERNEL_KMEMORY_SIZEOF_RECORD
	
	cast(long ptr,lpElementAddr)[KERNEL_KMEMORY_RECORD_UNUSED]=0
	cast(long ptr,lpElementAddr)[KERNEL_KMEMORY_RECORD_SIZE]=nSizeBytes
	cast(long ptr,lpElementAddr)[KERNEL_KMEMORY_RECORD_POINTER]=lpMemory

	m_nAllocatedCount=m_nAllocatedCount+1
	m_nAllocatedMemSize=m_nAllocatedMemSize+nSizeBytes
	
	return lpMemory
end function

function _kmemory_realloc(lpMemory as integer,nSizeBytes as integer) as integer
	if lpMemory<=0 then
		return 0
	end if
	
	return 0
end function

sub _kmemory_free(lpMemory as integer)
	if lpMemory<KERNEL_KMEMORY_BASEADDR orelse lpMemory>=KERNEL_KMEMORY_LIMITADDR then
		return
	end if
	
	dim lpElement as integer
	dim lpPointer as integer
	dim nIsUnused as integer
	
	lpElement=m_lpRecBaseAddr
	for i as integer=1 to KERNEL_KMEMORY_MAXSIZE
		lpPointer=cast(long ptr,lpElement)[KERNEL_KMEMORY_RECORD_POINTER]
		nIsUnused=cast(long ptr,lpElement)[KERNEL_KMEMORY_RECORD_UNUSED]

		if nIsUnused = 1 then
			return
		end if

		if lpPointer = lpMemory then
			cast(long ptr,lpElement)[KERNEL_KMEMORY_RECORD_UNUSED]=1
			return
		end if

		lpElement = lpElement +KERNEL_KMEMORY_SIZEOF_RECORD
	next
end sub


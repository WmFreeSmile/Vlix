#include once "help.bi"

#include once "display.bi"
#include once "log.bi"
#include once "crt.bi"

dim shared m_nCursorX as integer
dim shared m_nCursorY as integer



'display

sub _kdisplay_init()
	_kdisplay_clear()
	
	_kdisplay_cursor_update(0,0)
	
	_kdisplay_print("------------------------Welcome to Vlix------------------------",true)
	
	_klog_logo(TAG_KDISPLAY,"Display initialized successfully.")
end sub

sub _kdisplay_clear()
	for i as integer=0 to DISPLAY_WIDTH*DISPLAY_HEIGHT-1
		cast(short ptr,KERNEL_KDISPLAY_BASEADDR)[i]=1824
	next
	_kdisplay_cursor_update(0,0)
end sub

sub _kdisplay_print(lpszString as zstring ptr,bEndLine as bool=true)
	dim nCharacter as ubyte
	
	dim nOffset as integer
	nOffset=-1
	
	do
		nOffset=nOffset+1
		nCharacter=cast(ubyte ptr,lpszString)[nOffset]
		
		if nCharacter=0 then
			if bEndLine then
				m_nCursorX=0
				
				m_nCursorY=m_nCursorY+1
				if m_nCursorY>DISPLAY_HEIGHT-1 then
					m_nCursorY=DISPLAY_HEIGHT-1
					_kdisplay_scroll()
				end if
			end if
			exit do
			
		elseif nCharacter=10 then
			m_nCursorX=0
			m_nCursorY=m_nCursorY+1
			if m_nCursorY>DISPLAY_HEIGHT-1 then
				m_nCursorY=DISPLAY_HEIGHT-1
				_kdisplay_scroll()
			end if
			continue do
		elseif nCharacter=13 then
			continue do
		else
			
			m_nCursorX=m_nCursorX+1
			if m_nCursorX>=DISPLAY_WIDTH then
				m_nCursorX=0
				m_nCursorY=m_nCursorY+1
				if m_nCursorY>DISPLAY_HEIGHT-1 then
					m_nCursorY=DISPLAY_HEIGHT-1
					_kdisplay_scroll()
				end if
			end if
		end if
		
		cast(ubyte ptr,KERNEL_KDISPLAY_BASEADDR)[(m_nCursorY*DISPLAY_WIDTH+m_nCursorX)*2]=nCharacter
		
	loop while nCharacter<>0
	_kdisplay_cursor_update(m_nCursorX,m_nCursorY)
end sub

sub _kdisplay_attribute_set(nPosX as integer,nPosY as integer,nAttribute as ubyte,nLength as integer=1)
	dim lpMemoryBase as integer=KERNEL_KDISPLAY_BASEADDR+(nPosY*DISPLAY_WIDTH+nPosX)*2+1
	
	for i as integer=1 to nLength
		*cast(ubyte ptr,lpMemoryBase)=nAttribute
		lpMemoryBase=lpMemoryBase+2
	next
end sub



sub _kdisplay_cursor(byref nPosX as integer,byref nPosY as integer)
	nPosX=m_nCursorX
	nPosY=m_nCursorY
end sub

sub _kdisplay_cursor_update(nPosX as integer,nPosY as integer)
	m_nCursorX=nPosX
	m_nCursorY=nPosY
	
	asm
		mov bx, [ebp+8]
		mov ax, [ebp+12]
		
		mov dl, 80
		mul dl
		add bx, ax
		mov dx, 0x03D4
		mov al, 0x0F
		out dx, al
		inc dl
		mov al, bl
		out dx, al
		dec dl
		mov al, 0x0E
		out dx, al
		inc dl
		mov al, bh
		out dx, al
		'pop ebp
		'ret 8
	end asm
end sub

sub _kdisplay_scroll()
	dim nStride as integer
	dim nMoveSize as integer
	dim lpBaseAddr as integer
	
	nStride=DISPLAY_WIDTH*2
	nMoveSize=nStride*(DISPLAY_HEIGHT-1)
	
	memcpy(KERNEL_KDISPLAY_BASEADDR,KERNEL_KDISPLAY_BASEADDR+nStride,nMoveSize)
	
	lpBaseAddr=KERNEL_KDISPLAY_BASEADDR+nMoveSize
	for i as integer=0 to DISPLAY_WIDTH-1
		cast(short ptr,lpBaseAddr)[i]=1824
	next
	
	m_nCursorY=m_nCursorY-1
	if m_nCursorY<0 then
		m_nCursorY=0
	end if
	_kdisplay_cursor_update(m_nCursorX,m_nCursorY)
end sub

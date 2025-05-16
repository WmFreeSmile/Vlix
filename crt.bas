#include once "crt.bi"

'手动实现c库



'crt
extern "c"

function strlen cdecl(byval p as const zstring ptr) as integer
	dim i as integer=0
	while *cast(ubyte ptr,p+i)<>0
		i=i+1
	wend
	return i
end function

function memset cdecl(byval s as any ptr, byval c as long, byval n as integer) as any ptr
	dim xs As ubyte ptr = s
	while n>0
		*xs=c
		xs=xs+1
		n=n-1
	wend
	function=s
end function

function memcpy cdecl(byval dst as any ptr,byval src as any ptr,n as integer) as any ptr
	for i as integer=0 to n-1
		cast(ubyte ptr,dst)[i]=cast(ubyte ptr,src)[i]
	next
	function=dst
end function

end extern

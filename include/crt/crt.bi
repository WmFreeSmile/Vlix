#include once "stddef.bi"

extern "c"
declare function malloc cdecl(byval n as size_t) as any ptr
declare sub free cdecl(byval s as any ptr)

declare function strlen cdecl(byval p as const zstring ptr) as size_t
declare function memset cdecl(byval s as any ptr, byval c as long, byval n as size_t) as any ptr
declare function memcpy cdecl(byval dst as any ptr,byval src as any ptr,n as size_t) as any ptr
end extern

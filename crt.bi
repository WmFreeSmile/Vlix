
extern "c"
declare function strlen cdecl(byval p as const zstring ptr) as integer
declare function memset cdecl(byval s as any ptr, byval c as long, byval n as integer) as any ptr
declare function memcpy cdecl(byval dst as any ptr,byval src as any ptr,n as integer) as any ptr
end extern

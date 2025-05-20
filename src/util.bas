#include once "../include/util.bi"
#include once "../include/crt/crt.bi"

Function pow_ulong(a As ULong, n As integer) As ULong
    If n = 0 Then Return 1
    
    Dim value As ULong = a
    For i As Integer=2 To n
        value = value *a
    Next
    Function=value
end function

Sub ulong2string(value As ULong, z As ZString Ptr)
    memset(z,0,10)
    if value=0 then z[0]=48:return
    
    Dim bit_value As Integer
    Dim start As Integer=-1
    
    For i As Integer = 9 To 0 Step-1
        bit_value = value \ pow_ulong(10,i) Mod 10
        If bit_value <> 0 AndAlso start=-1 Then start=i
        If start<>-1 Then
            z[start - i] = 48 + bit_value
        End If
    Next
End Sub

'CRC32校验算法，用来生成摘要
function CRC32(pBuffer as any ptr,size as integer) as integer
	dim value as integer=4294967295
	for i as integer=0 to size-1
		value=value xor cast(integer,cast(ubyte ptr,pBuffer)[i])
		
		for j as integer=0 to 7
			if (value and 1)=1 then
				value=((value shr 1) and 2147483647) xor 3988292384
			else
				value=(value shr 1) and 2147483647
			end if
		next
	next
	function=value
end function

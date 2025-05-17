#include once "util.bi"
#include once "crt.bi"

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

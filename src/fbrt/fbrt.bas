#include once "../../include/fbrt/fbrt.bi"
#include once "../../include/display.bi"

'直接用fb_ArrayErase过不了编译器，于是我编译好之后再改回来

extern "c"

'这个在使用动态数组的时候需要
function fb_ArrayErase_bak stdcall(array as FBARRAY ptr) as integer
    if array->m_ptr>0 then
        
    end if
    function=0
end function

function fb_ErrorSetNum_bak stdcall(err_num as integer) as integer
    
    function=err_num
end function

end extern

#include once "../crt/crt.bi"

type FBARRAYDIM
    m_elements as any ptr
	m_lbound as any ptr
	m_ubound as any ptr
end type

type FBARRAY
    m_data as any ptr
    m_ptr as any ptr
    m_size as size_t
    m_element_len as size_t
    m_dimensions as size_t
    m_flags as size_t
    m_dimTB(0) as FBARRAYDIM
end type

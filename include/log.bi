const TAG_KLOG="LOG    :"
const KERNEL_KLOG_LEVELD=1
const KERNEL_KLOG_LEVELO=2
const KERNEL_KLOG_LEVELW=3
const KERNEL_KLOG_LEVELE=4
const KERNEL_KLOG_LEVELF=5

declare sub _klog_log(nLevel as integer,szTag as zstring ptr,szMessage as zstring ptr)
declare sub _klog_logd(szTag as zstring ptr,szMessage as zstring ptr)
declare sub _klog_logo(szTag as zstring ptr,szMessage as zstring ptr)
declare sub _klog_logw(szTag as zstring ptr,szMessage as zstring ptr)
declare sub _klog_loge(szTag as zstring ptr,szMessage as zstring ptr)
declare sub _klog_logf(szTag as zstring ptr,szMessage as zstring ptr)
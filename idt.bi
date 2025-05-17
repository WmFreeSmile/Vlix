
const TAG_KIDT="IDT    "

const KERNEL_KIDT_IDTR_BASEADDR=86016
const KERNEL_KIDT_IDT_BASEADDR=86032
const KERNEL_KIDT_IDT_MAXSIZE=256
const KERNEL_KIDT_SIZEOF_IDT=8

const IDT_GATE_INT=14
const IDT_GATE_TRAP=15
const IDT_GATE_TASK=5
const IDT_FLAG_DEFAULT=8
const IDT_SS=1
const IDT_DPL_KERNEL=0
const IDT_DPL_SYSTEM=2
const IDT_DPL_USER=6
const IDT_PRESENT=8

declare sub _kidt_init()
declare sub _kidt_reset()
declare sub _kidt_update(lpIDTDescr as integer)
declare sub _kidt_enable(blEnable as bool)
declare sub _kidt_install(nIndex as ubyte,nGateType as ubyte,nGateFlag as ubyte,nSelector as short,lpfnIrqAddress as sub())

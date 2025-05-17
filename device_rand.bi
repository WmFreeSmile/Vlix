
const TAG_KRANDOM="RANDOM "


declare sub _kdevice_rand_init()
declare function _kdevice_rand_check_rdrand naked() as bool
declare function _kdevice_rand_next_rdrand naked() as integer
declare function _kdevice_rand_next() as integer

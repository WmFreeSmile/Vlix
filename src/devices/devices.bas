#include once "../../include/help.bi"
#include once "../../include/devices/devices.bi"

sub _kdevices_init()
    _kdevice_rand_init()
    _kdevice_pit_init()
    _kdevice_keyboard_init()
end sub

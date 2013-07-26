#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <libudev.h>

MODULE = DeviceAccessor		PACKAGE = DeviceAccessor

const char *
getDeviceList()
	CODE:
		const char *devices[10];

		struct udev_list_entry *device_entries, *device;
		struct udev_enumerate *enumerate;

		struct udev *udev = udev_new(); //create new udev object
		enumerate = udev_enumerate_new( udev ); //create device enumerator

		//add given device subsystem filter to find compatible devices
		udev_enumerate_add_match_subsystem( enumerate, "block" );
		udev_enumerate_add_match_sysattr( enumerate, "partition", "1" );
		udev_enumerate_add_match_property( enumerate, "ID_BUS", "usb" );
		udev_enumerate_scan_devices( enumerate ); //scan through devices
		device_entries = udev_enumerate_get_list_entry( enumerate );

		//retrieve device names from list
		int i = 0;
		udev_list_entry_foreach( device, device_entries )
		{
			if( i < 10 )
			{
				const char *device_path;

				device_path = udev_list_entry_get_name( device ); //locate device

				printf( "Found: %s\n", device_path );

				devices[ i ] = device_path; //add device to devices list
			}
			i++;
		}

		RETVAL = *devices;

	OUTPUT:
		RETVAL


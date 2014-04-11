#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <string.h>
#include <libudev.h>

#include "xshelper.h"

MODULE = DeviceAccessor		PACKAGE = DeviceAccessor

const char *
getDeviceList( HV *options )
	CODE:
		const char *devices[10];

		struct udev_list_entry *device_entries, *device;
		struct udev_enumerate *enumerate;

		struct udev *udev = udev_new(); //create new udev object
		enumerate = udev_enumerate_new( udev ); //create device enumerator

		//retrieve and set subsystem filter when provided
		SV *sys_sv = get_hash_value( options, "subsystem" );
		if( SvOK( sys_sv ) )
		{
			char *sys_c = SvPV_nolen( sys_sv );
			udev_enumerate_add_match_subsystem( enumerate, sys_c );
		}

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

const char *
getDeviceName( const char *sys_path )
	CODE:
		struct udev *udev = udev_new(); //create new udev object
		struct udev_device *device;
		char name[ 100 ] = "";

		//retrieve camera details from identified device
		device = udev_device_new_from_syspath( udev, sys_path );

		//ensure the specified device did not exist
		if( device )
		{
			//get device's model and vendor information
			const char *vendor = udev_device_get_property_value( device, "ID_VENDOR" );
			const char *model = udev_device_get_property_value( device, "ID_MODEL" );

			if( sizeof( vendor ) > 0 || sizeof( model ) > 0 )
			{
				strcat( name, vendor );
				strcat( name, " " );
				strcat( name, model );
			}
		}
		else
		{
			warn( "Device not found from syspath: '%s'", sys_path );

			//return undef when given device does not exist
			XSRETURN_UNDEF;
		}

		RETVAL = name;

	OUTPUT:
		RETVAL

const char *
getDevicePath( const char *sys_path )
	CODE:
		struct udev *udev = udev_new(); //create new udev object
		struct udev_device *device;
		const char *path = "";

		//retrieve details from identified device
		device = udev_device_new_from_syspath( udev, sys_path );

		//ensure the specified device did not exist
		if( device )
		{
			//retrieve device path
			path = udev_device_get_property_value( device, "DEVNAME" );
		}
		else
		{
			warn( "Device not found from syspath: '%s'", sys_path );

			//return undef when given device does not exist
			XSRETURN_UNDEF;
		}

		RETVAL = path;

	OUTPUT:
		RETVAL

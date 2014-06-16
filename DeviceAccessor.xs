#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <string.h>
#include <libudev.h>

#include "xshelper.h"

MODULE = DeviceAccessor		PACKAGE = DeviceAccessor

AV *
getDeviceList( HV *options )
	CODE:
		AV *devices = newAV();

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

		//retrieve attributes to apply as filters. These are expected to be
		//passed as an array reference, so check the given structure correctly
		//before attempting to apply.
		SV *attr = get_hash_value( options, "sysattr" );
		if( SvOK( attr ) && SvROK( attr ) &&
			( SvTYPE( SvRV( attr ) ) == SVt_PVHV ) )
		{
			HV *attr_hv = (HV*) SvRV( attr );
			HE *entry;

			while( entry = hv_iternext( attr_hv ) )
			{
				//retrieve attribute name and its value from hash
				SV *key_sv = hv_iterkeysv( entry );
				SV *value_sv = hv_iterval( attr_hv, entry );

				//convert attribute information ready to pass to udev
				char *key = SvPV_nolen( key_sv );
				char *value = SvPV_nolen( value_sv );

				//add attribute setting to udev device search query
				udev_enumerate_add_match_sysattr( enumerate, key, value );
			}
		}

		udev_enumerate_add_match_property( enumerate, "ID_BUS", "usb" );
		udev_enumerate_scan_devices( enumerate ); //scan through devices
		device_entries = udev_enumerate_get_list_entry( enumerate );

		//retrieve device names from list
		udev_list_entry_foreach( device, device_entries )
		{
			const char *device_path;
			device_path = udev_list_entry_get_name( device ); //locate device

			SV *device_path_sv = newSVpv( device_path, 0 );

			//add device to devices list
			av_push( devices, device_path_sv );
		}

		RETVAL = devices;

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

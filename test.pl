#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::testlib;

use DeviceAccessor;

#print DeviceAccessor::hello();

#use Data::Dumper;
my $devices = DeviceAccessor::get_device_list( {
	subsystem => 'block',
	sysattr => {
		partition => 1,
	},
	property => {
	}
} );

print "Looking for devices ...\n";
foreach my $device( @{ $devices } )
{
	next unless( $device );
	print "Device: $device\n";

	my $dev_vendor = DeviceAccessor::get_device_vendor( $device );
	print "Device Vendor: $dev_vendor\n";

	my $dev_model = DeviceAccessor::get_device_model( $device );
	print "Device Model: $dev_model\n";

	my $dev_path = DeviceAccessor::get_device_path( $device );
	print "Device Path: $dev_path\n";

	my $type = DeviceAccessor::get_device_property( $device, "DEVTYPE" );
	print "Device Type: $type\n";
}

print "Trying fake device ...\n";
my $dev_vendor = DeviceAccessor::get_device_vendor( "/sys/devices/pci0000:00/0000:00:16.2/usb2/3-1/3-1:1.0/host8/target8:0:0/8:0:0:0/block/sdf/sdf1" );
print "Device Vendor: $dev_vendor\n";

my $dev_model = DeviceAccessor::get_device_model( "/sys/devices/pci0000:00/0000:00:16.2/usb2/3-1/3-1:1.0/host8/target8:0:0/8:0:0:0/block/sdf/sdf1" );
print "Device Model: $dev_model\n";

my $dev_path = DeviceAccessor::get_device_path( "/sys/devices/pci0000:00/0000:00:16.2/usb2/3-1/3-1:1.0/host8/target8:0:0/8:0:0:0/block/sdf/sdf1" );
print "Device Path: $dev_path\n";

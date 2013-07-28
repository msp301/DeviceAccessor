#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::testlib;

use DeviceAccessor;

#print DeviceAccessor::hello();

use Data::Dumper;
my @devices = DeviceAccessor::getDeviceList(
	'block',
	[ 'partition', '1' ],
	[ 'ID_BUS', 'usb' ]
);

print Dumper \@devices;

print "Looking for devices ...\n";
foreach my $device( @devices )
{
	next unless( $device );
	print "Device: $device\n";

	my $dev_name = DeviceAccessor::getDeviceName( $device );

	print "Device Name: $dev_name\n";

	my $dev_path = DeviceAccessor::getDevicePath( $device );

	print "Device Path: $dev_path\n";
}

print "Trying fake device ...\n";
my $dev_name = DeviceAccessor::getDeviceName( "/sys/devices/pci0000:00/0000:00:16.2/usb2/3-1/3-1:1.0/host8/target8:0:0/8:0:0:0/block/sdf/sdf1" );
print "Device Name: $dev_name\n";

my $dev_path = DeviceAccessor::getDevicePath( "/sys/devices/pci0000:00/0000:00:16.2/usb2/3-1/3-1:1.0/host8/target8:0:0/8:0:0:0/block/sdf/sdf1" );
print "Device Path: $dev_path\n";

#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::testlib;

use DeviceAccessor;

#print DeviceAccessor::hello();

use Data::Dumper;
my @devices = DeviceAccessor::getDeviceList();

foreach my $device( @devices )
{
	next unless( $device );
	print "Device: $device\n";
}

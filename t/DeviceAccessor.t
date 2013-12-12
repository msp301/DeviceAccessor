#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use_ok( 'DeviceAccessor' );

can_ok( 'DeviceAccessor', 'getDeviceList' );
can_ok( 'DeviceAccessor', 'getDeviceName' );
can_ok( 'DeviceAccessor', 'getDevicePath' );

done_testing();

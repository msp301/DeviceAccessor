#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use_ok( 'DeviceAccessor' );

can_ok( 'DeviceAccessor', 'get_device_list' );
can_ok( 'DeviceAccessor', 'get_device_vendor' );
can_ok( 'DeviceAccessor', 'get_device_model' );
can_ok( 'DeviceAccessor', 'get_device_path' );

done_testing();

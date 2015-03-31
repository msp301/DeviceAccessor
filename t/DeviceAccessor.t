#!/usr/bin/perl

use strict;
use warnings;

use Test::Spec;
use Test::Exception;

describe 'Device searching' => sub {
	before 'all' => sub {
		use_ok( 'DeviceAccessor', ':all' );
	};

	it 'has get_device_list() function' => sub {
		can_ok( 'DeviceAccessor', 'get_device_list' );
	};
	it 'has exported function' => sub {
		ok( get_device_list( {} ) );
	};

	describe 'dies when search options' => sub {
		it 'is given a plain hash' => sub {
			dies_ok { get_device_list( "block" => 1 ) };
		};
		it 'is an array' => sub {
			dies_ok { get_device_list( ( 1, 2, 3 ) ) };
		};
		it 'is a scalar' => sub {
			dies_ok { get_device_list( 'options' ) };
		};
	};
};

runtests unless caller;

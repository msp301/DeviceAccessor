package DeviceAccessor;

use 5.014002;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use DeviceAccessor ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('DeviceAccessor', $VERSION);

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

DeviceAccessor - Perl extension for libudev.h

=head1 SYNOPSIS

  use DeviceAccessor;

  my @devices = getDeviceList();
  foreach my $device( @devices )
  {
     print getDeviceName( $device );
  }

=head1 DESCRIPTION

DeviceAccessor is a perl extension module to provide access to functionality
provided by libudev.h, allowing for information retrieval of connected devices.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Martin Pritchard, E<lt>martin@martinpritchard.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Martin Pritchard

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut

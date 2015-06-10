package WebService::MinFraud::Record::Location;

use strict;
use warnings;

our $VERSION = '0.001001';

use Moo;
use Sub::Quote qw( quote_sub );
use WebService::MinFraud::Types qw( Str );
extends 'GeoIP2::Record::Location';

has local_time => (
    is  => 'ro',
    isa => Str,
);

1;
__END__
=head1 SYNOPSIS

  use 5.010;
  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );
  my $request = { device => { ip_address => '24.24.24.24'} };
  my $insights = $client->insights( $request);
  my $location_rec = $insights->location;
  say $location_rec->local_time;

=head1 DESCRIPTION

This class contains the location data associated with a transaction

This record is returned by the insights end point.

=head1 METHODS

This class provides the same methods as L<GeoIP2::Record::Location> in addition
to:

=head2 local_time

Returns the time local to that of the ip_address.

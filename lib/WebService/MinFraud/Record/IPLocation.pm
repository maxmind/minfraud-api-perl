package WebService::MinFraud::Record::IPLocation;

use strict;
use warnings;

our $VERSION = '0.001001';

use Moo;
use Types::Standard qw( InstanceOf );
use WebService::MinFraud::Types
    qw( CityCoercion ContinentCoercion CountryCoercion LocationCoercion PostalCoercion SubdivisionCoercion TraitsCoercion);

has city => (
    is     => 'ro',
    isa    => InstanceOf ['GeoIP2::Record::City'],
    coerce => CityCoercion,
);

has continent => (
    is     => 'ro',
    isa    => InstanceOf ['GeoIP2::Record::Continent'],
    coerce => ContinentCoercion,
);

has country => (
    is     => 'ro',
    isa    => InstanceOf ['GeoIP2::Record::Country'],
    coerce => CountryCoercion,
);

has location => (
    is     => 'ro',
    isa    => InstanceOf ['GeoIP2::Record::Location'],
    coerce => LocationCoercion,
);

has postal => (
    is     => 'ro',
    isa    => InstanceOf ['GeoIP2::Record::Postal'],
    coerce => PostalCoercion,
);

has registered_country => (
    is     => 'ro',
    isa    => InstanceOf ['GeoIP2::Record::Country'],
    coerce => CountryCoercion,
);

has subvisions => (
    is     => 'ro',
    isa    => InstanceOf ['GeoIP2::Record::Subdivision'],
    coerce => SubdivisionCoercion,
);

has traits => (
    is     => 'ro',
    isa    => InstanceOf ['GeoIP2::Record::Traits'],
    coerce => TraitsCoercion,
);

1;

# ABSTRACT: Contains data for the IPLocation record returned from a minFraud web service query

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $insights = $client->insights( ip => '24.24.24.24' );

  my $ip_location = $insights->ip_location();
  print $ip_location->city->name(), "\n";

=head1 DESCRIPTION

This class contains the maxmind record data returned from a web service query.

=head1 METHODS

This class provides the following methods:

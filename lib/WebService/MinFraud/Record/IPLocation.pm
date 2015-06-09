package WebService::MinFraud::Record::IPLocation;

use strict;
use warnings;

our $VERSION = '0.001001';

use Moo;
use Types::Standard qw( ArrayRef InstanceOf Maybe );
use WebService::MinFraud::Types
    qw( CityCoercion ContinentCoercion CountryCoercion LocationCoercion
    MostSpecificSubdivisionCoercion PostalCoercion RepresentedCountryCoercion
    SubdivisionsCoercion TraitsCoercion);

has city => (
    is      => 'lazy',
    isa     => InstanceOf ['GeoIP2::Record::City'],
    coerce  => CityCoercion,
    builder => sub { GeoIP2::Record::City->new },
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

has most_specific_subdivision => (
    is      => 'lazy',
    isa     => Maybe [ InstanceOf ['GeoIP2::Record::Subdivision'] ],
    builder => sub {
        my $self         = shift;
        my @subdivisions = $self->subdivisions;
        return defined $subdivisions[0]
            ? $subdivisions[-1]
            : undef;
    },
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

has represented_country => (
    is     => 'ro',
    isa    => InstanceOf ['GeoIP2::Record::RepresentedCountry'],
    coerce => RepresentedCountryCoercion,
);

has _subdivisions => (
    is  => 'ro',
    isa => Maybe [ ArrayRef [ InstanceOf ['GeoIP2::Record::Subdivision'] ] ],
    coerce => SubdivisionsCoercion,
);

sub subdivisions {
    my ( $self, ) = @_;
    return
        defined $self->_subdivisions && @{ $self->_subdivisions }
        ? @{ $self->_subdivisions }
        : ();
}

has traits => (
    is     => 'ro',
    isa    => InstanceOf ['GeoIP2::Record::Traits'],
    coerce => TraitsCoercion,
);

1;

# ABSTRACT: Contains data for the IPLocation record returned from a minFraud web
# service query

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
  my $ip_location = $insights->ip_location;
  say $ip_location->city->name;

=head1 DESCRIPTION

This class contains the GeoIP2 location data returned from a minFraud service
query.

=head1 METHODS

This class provides the following methods:

=head2 city

Returns a L<GeoIP2::Record::City> object.

=head2 continent

Returns a L<GeoIP2::Record::Continent> object.

=head2 country

Returns a L<GeoIP2::Record::Country> object.

=head2 location

Returns a L<GeoIP2::Record::Location> object.

=head2 registered_country

Returns a L<GeoIP2::Record::Country> object.

=head2 represented_country

Returns a L<GeoIP2::Record::RepresentedCountry> object.

=head2 subdivisions

Returns an ArrayRef of L<GeoIP2::Record::Subdivision> objects.

=head2 traits

Returns a L<GeoIP2::Record::Traits> object.

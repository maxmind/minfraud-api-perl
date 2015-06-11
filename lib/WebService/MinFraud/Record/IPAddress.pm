package WebService::MinFraud::Record::IPAddress;

use strict;
use warnings;

our $VERSION = '0.001001';

use Types::Standard qw( ArrayRef InstanceOf Maybe );
use WebService::MinFraud::Record::Location;
use WebService::MinFraud::Record::Country;
use WebService::MinFraud::Types qw(
    CityCoercion
    ContinentCoercion
    CountryCoercion
    MinFraudCountryCoercion
    MinFraudLocationCoercion
    MostSpecificSubdivisionCoercion
    PostalCoercion
    RepresentedCountryCoercion
    SubdivisionsCoercion
    TraitsCoercion
);

use Moo;

has city => (
    is        => 'lazy',
    isa       => InstanceOf ['GeoIP2::Record::City'],
    coerce    => CityCoercion,
    predicate => 1,
);

has continent => (
    is        => 'ro',
    isa       => InstanceOf ['GeoIP2::Record::Continent'],
    coerce    => ContinentCoercion,
    predicate => 1,
);

has country => (
    is        => 'ro',
    isa       => InstanceOf ['WebService::MinFraud::Record::Country'],
    coerce    => MinFraudCountryCoercion,
    predicate => 1,
);

has location => (
    is        => 'ro',
    isa       => InstanceOf ['WebService::MinFraud::Record::Location'],
    coerce    => MinFraudLocationCoercion,
    predicate => 1,
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
    predicate => 1,
);

has postal => (
    is        => 'ro',
    isa       => InstanceOf ['GeoIP2::Record::Postal'],
    coerce    => PostalCoercion,
    predicate => 1,
);

has registered_country => (
    is        => 'ro',
    isa       => InstanceOf ['GeoIP2::Record::Country'],
    coerce    => CountryCoercion,
    predicate => 1,
);

has represented_country => (
    is        => 'ro',
    isa       => InstanceOf ['GeoIP2::Record::RepresentedCountry'],
    coerce    => RepresentedCountryCoercion,
    predicate => 1,
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
    is        => 'ro',
    isa       => InstanceOf ['GeoIP2::Record::Traits'],
    coerce    => TraitsCoercion,
    predicate => 1,
);

1;

# ABSTRACT: Contains data for the IPAddress record returned from a minFraud web service query

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
  my $ip_address = $insights->ip_address;
  say $ip_address->city->name;

=head1 DESCRIPTION

This class contains the GeoIP2 location data returned from a minFraud service
query for the given C<ip_address>.

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

=head2 most_specific_subdivision

Returns a L<GeoIP2::Record::Subdivision> object which is the most specific
(smallest) subdivision.

=head2 registered_country

Returns a L<GeoIP2::Record::Country> object.

=head2 represented_country

Returns a L<GeoIP2::Record::RepresentedCountry> object.

=head2 subdivisions

Returns an ArrayRef of L<GeoIP2::Record::Subdivision> objects.

=head2 traits

Returns a L<GeoIP2::Record::Traits> object.

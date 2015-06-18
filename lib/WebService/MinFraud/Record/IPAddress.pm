package WebService::MinFraud::Record::IPAddress;

use Moo;

our $VERSION = '0.001001';

use GeoIP2::Role::Model::Location;
use GeoIP2::Role::Model::HasSubdivisions;
use Types::Standard qw( ArrayRef InstanceOf Num);
use WebService::MinFraud::Record::Location;
use WebService::MinFraud::Record::Country;
use WebService::MinFraud::Types qw(
    MinFraudCountryCoercion
    MinFraudLocationCoercion
);
with 'GeoIP2::Role::Model::Location', 'GeoIP2::Role::Model::HasSubdivisions';

__PACKAGE__->_define_attributes_for_keys(
    __PACKAGE__->_record_names_from_geo );

sub _record_names_from_geo {
    qw(
        city
        continent
        postal
        registered_country
        represented_country
        traits
    );
}

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

has risk => (
    is        => 'ro',
    isa       => Num,
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

=head2 risk

Returns the risk associated with the IP address. The value ranges from 0.01 to
99. A higher value indicates a higher risk.

=head2 subdivisions

Returns an ArrayRef of L<GeoIP2::Record::Subdivision> objects.

=head2 traits

Returns a L<GeoIP2::Record::Traits> object.

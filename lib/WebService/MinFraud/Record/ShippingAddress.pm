package WebService::MinFraud::Record::ShippingAddress;

use Moo;

our $VERSION = '0.001001';

use WebService::MinFraud::Types qw( Bool BoolCoercion Num);

with 'WebService::MinFraud::Role::Record::Address';

has distance_to_billing_address => (
    is        => 'ro',
    isa       => Num,
    predicate => 1,
);

has is_high_risk => (
    is        => 'ro',
    isa       => Bool,
    coerce    => BoolCoercion,
    predicate => 1,
);

1;

# ABSTRACT: Contains data for the shipping address record associated with a transaction

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );
  my $request          = { device => { ip_address => '24.24.24.24' } };
  my $insights         = $client->insights($request);
  my $shipping_address = $insights->shipping_address;
  say $shipping_address->distance_to_ip_location;

=head1 DESCRIPTION

This class contains the shipping address data associated with a transaction.

This record is returned by the Insights end point.

=head1 METHODS

This class provides the following methods:

=head2 distance_to_billing_address

Returns the distance from the shipping address to the billing address.

=head2 distance_to_ip_location

Returns the distance from the shipping address to the location of the IP
address.

=head2 is_high_risk

Returns a boolean indicating whether or not the shipping address is considered
high risk.

=head2 is_in_ip_country

Returns a boolean indicating whether or not the shipping address is in the same
country as that of the IP address.

=head2 is_postal_in_city

Returns a boolean indicating whether or not the shipping postal code is in the
shipping city.

=head2 latitude

Returns the latitude of the shipping address.

=head2 longitude

Returns the longitude of the shipping address.


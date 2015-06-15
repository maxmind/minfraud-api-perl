package WebService::MinFraud::Record::BillingAddress;

use Moo;

our $VERSION = '0.001001';

extends 'WebService::MinFraud::Record::Address';

1;

# ABSTRACT: Contains data for the billing address record associated with a transaction

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
  my $billing_address = $insights->billing_address;
  say $billing_address->distance_to_ip_location;

=head1 DESCRIPTION

This class contains the billing address data associated with a transaction.

This record is returned by the Insights end point.

=head1 METHODS

This class provides the following methods:

=head2 distance_to_billing_address

Returns the distance from the shipping address to the billing address.

=head2 is_in_ip_country

Returns a boolean indicating whether or not the billing address is in the same
country as that of the IP address.

=head2 is_postal_in_city

Returns a boolean indicating whether or not the billing postal code is in the
billing city.

=head2 latitude

Returns the latitude of the billing address.

=head2 longitude

Returns the longitude of the billing address.

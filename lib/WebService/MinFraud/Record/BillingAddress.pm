package WebService::MinFraud::Record::BillingAddress;

use Moo;
use namespace::autoclean;

our $VERSION = '1.009002';

with 'WebService::MinFraud::Role::Record::Address';

1;

# ABSTRACT: Contains data for the billing address record associated with a transaction

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      account_id  => 42,
      license_key => 'abcdef123456',
  );
  my $request         = { device => { ip_address => '24.24.24.24' } };
  my $insights        = $client->insights($request);
  my $billing_address = $insights->billing_address;
  say $billing_address->distance_to_ip_location;

=head1 DESCRIPTION

This class contains the billing address data associated with a transaction.

This record is returned by the L<WebService::MinFraud::Model::Insights#billing_address> method.

=head1 METHODS

This class provides the following methods:

=head2 distance_to_ip_location

Returns the distance in kilometers from the billing address to the IP location.

=head2 is_in_ip_country

Returns a boolean indicating whether the billing address is in the same
country as that of the IP address.

=head2 is_postal_in_city

Returns a boolean indicating whether the billing postal code is in the
billing city.

=head2 latitude

Returns the latitude of the billing address.

=head2 longitude

Returns the longitude of the billing address.

=head1 PREDICATE METHODS

The following predicate methods are available, which return true if the related
data was present in the response body, false if otherwise:

=head2 has_distance_to_ip_location

=head2 has_is_in_ip_country

=head2 has_is_postal_in_city

=head2 has_latitude

=head2 has_longitude

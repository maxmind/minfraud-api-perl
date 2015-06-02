package WebService::MinFraud::Model::Insights;

use strict;
use warnings;

our $VERSION = '0.001001';

use Moo;

with 'WebService::MinFraud::Role::AttributeBuilder';

sub _all_record_names {
    return qw(
        billing_address
        credit_card
        ip_location
        shipping_address
    );
}

__PACKAGE__->_define_attributes_for_keys( __PACKAGE__->_all_record_names() );

1;

# ABSTRACT: Model class for minFraud Insights

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $request = { device => { ip_address => '24.24.24.24'} };
  my $insights = $client->insights( $request );

  my $shipping_address_rec = $insights->shipping_address;
  say $shipping_address_rec->is_high_risk;

  my $ip_location_rec = $insights->ip_location;
  my $postal_rec = $ip_location_rec->postal;
  say $postal_rec->code;

=head1 DESCRIPTION

This class provides a model for the data returned by the minFraud insights web
service.

The only difference between the Score and Insights model classes is
which fields in each record may be populated. See
L<http://dev.maxmind.com/minfraud> for more details.

=head1 METHODS

This class provides the following methods, each of which returns a record
object.

=head2 billing_address

Returns a L<WebService::MinFraud::Record::BillingAddress> object representing
billing data for the transaction.

=head2 credit_card

Returns a L<WebService::MinFraud::Record::CreditCard> object representing
credit card data for the transaction.

=head2 ip_location

Returns a L<WebService::MinFraud::Record::IPLocation> object representing
IP location data for the transaction.  In turn the IP location object consists
of the following methods that return GeoIP2::Record::* objects: city, continent,
country, postal, registered_country, subdivisions, traits.

=head2 shipping_address

Returns a L<WebService::MinFraud::Record::ShippingAddress> object representing shipping data for the
transaction.

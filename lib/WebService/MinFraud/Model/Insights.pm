package WebService::MinFraud::Model::Insights;

use Moo;

our $VERSION = '0.001001';

use Types::Standard qw( HashRef InstanceOf );
use WebService::MinFraud::Record::BillingAddress;
use WebService::MinFraud::Record::Country;
use WebService::MinFraud::Record::CreditCard;
use WebService::MinFraud::Record::IPAddress;
use WebService::MinFraud::Record::Issuer;
use WebService::MinFraud::Record::Location;
use WebService::MinFraud::Record::ShippingAddress;
use WebService::MinFraud::Record::Warning;

with 'WebService::MinFraud::Role::Model',
    'WebService::MinFraud::Role::HasLocales',
    'WebService::MinFraud::Role::HasCommonAttributes';

{
    my %attribute_to_class = (
        billing_address  => 'WebService::MinFraud::Record::BillingAddress',
        credit_card      => 'WebService::MinFraud::Record::CreditCard',
        ip_address       => 'WebService::MinFraud::Record::IPAddress',
        shipping_address => 'WebService::MinFraud::Record::ShippingAddress',
    );

    foreach my $attribute ( keys %attribute_to_class ) {
        has $attribute => (
            is  => 'ro',
            isa => InstanceOf [ $attribute_to_class{$attribute} ],
        );
    }
    around BUILDARGS => sub {
        my $orig  = shift;
        my $class = shift;

        my $args = $class->$orig(@_);

        foreach my $attribute ( keys %attribute_to_class ) {
            $args->{$attribute} //= {};
            $args->{$attribute}
                = $attribute_to_class{$attribute}->new( $args->{$attribute} );
        }

        return $args;
    };
}

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

  my $shipping_address = $insights->shipping_address;
  say $shipping_address->is_high_risk;

  my $ip_address = $insights->ip_address;
  my $postal = $ip_address->postal;
  say $postal->code;

=head1 DESCRIPTION

This class provides a model for the data returned by the minFraud Insights web
service.

The Insights model class includes more data than the Score model class.  See
L<http://dev.maxmind.com/minfraud> for more details.

=head1 METHODS

This model class provides the following methods:

=head2 billing_address

Returns a L<WebService::MinFraud::Record::BillingAddress> object representing
billing data for the transaction.

=head2 credit_card

Returns a L<WebService::MinFraud::Record::CreditCard> object representing
credit card data for the transaction.

=head2 credits_remaining

Returns the I<approximate> number of service credits remaining on your account.
The service credit counts are near realtime so they may not be exact.

=head2 id

Returns a UUID that identifies the minFraud request.  Please use this UUID in
bug reports or support requests to MaxMind so that we can easily identify a
particular request.

=head2 ip_address

Returns a L<WebService::MinFraud::Record::IPAddress> object representing
IP address data for the transaction.  In turn the IP address object consists
of the following methods that return GeoIP2::Record::* objects: city, continent,
country, postal, registered_country, represented_country, subdivisions and
traits.  In addition, the IP address object has a risk attribute that is
similar to the risk_score for the overall transaction, but specific to the IP
address instead of the transaction.

=head2 risk_score

Returns the risk score which is a number between 0.01 and 99. A higher score
indicates a higher risk of fraud.

=head2 shipping_address

Returns a L<WebService::MinFraud::Record::ShippingAddress> object representing
shipping data for the transaction.

=head2 warnings

Returns an ArrayRef of L<WebService::MinFraud::Record::Warning> objects.  It is
B<highly recommended that you check this array> for issues when integrating the
web service.

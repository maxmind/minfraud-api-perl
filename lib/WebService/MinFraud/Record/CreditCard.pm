package WebService::MinFraud::Record::CreditCard;

use Moo;

our $VERSION = '0.001001';

use WebService::MinFraud::Record::Issuer;
use WebService::MinFraud::Types
    qw( Bool BoolCoercion IssuerObject IssuerObjectCoercion Str );

has issuer => (
    is        => 'ro',
    isa       => IssuerObject,
    coerce    => IssuerObjectCoercion,
    predicate => 1,
);

has country => (
    is        => 'ro',
    isa       => Str,
    predicate => 1,
);

has is_issued_in_billing_address_country => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
    coerce  => BoolCoercion,
);

has is_prepaid => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
    coerce  => BoolCoercion,
);

1;

# ABSTRACT: Contains data for the credit card record associated with a transaction

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
  my $credit_card = $insights->credit_card;
  say $credit_card->is_prepaid;
  say $credit_card->issuer->name;

=head1 DESCRIPTION

This class contains the credit card data associated with a transaction.

This record is returned by the Insights end point.

=head1 METHODS

This class provides the following methods:

=head2 issuer

Returns the L<WebService::MinFraud::Record::Issuer> object for the credit card.

=head2 country

Returns the country of the credit card.

=head2 is_issued_in_billing_address_country

Returns a boolean indicating whether or not the issuer of the credit card
is in the same country as the billing address.

=head2 is_prepaid

Returns a boolean indicating whether or not the credit card is prepaid.

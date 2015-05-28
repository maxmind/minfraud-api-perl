package WebService::MinFraud::Record::CreditCard;

use strict;
use warnings;

our $VERSION = '0.001001';

use Sub::Quote qw( quote_sub );
use WebService::MinFraud::Types
    qw( Bool BoolCoercion HashRef IssuerObject IssuerObjectCoercion Str );

use Moo;

has issuer => (
    is     => 'ro',
    isa    => IssuerObject,
    coerce => IssuerObjectCoercion,
);

has country => (
    is  => 'ro',
    isa => Str,
);

has is_issued_in_billing_address_country => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
    coerce  => BoolCoercion,
);

has is_prepaid => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
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

  my $insights = $client->insights( ip => '24.24.24.24' );

  my $credit_card_rec = $insights->credit_card();
  print $credit_card_rec->issuer->name(), "\n";

=head1 DESCRIPTION

This class contains the postal code data associated with an IP address.

This record is returned by all the end points except the Country end point.

=head1 METHODS

This class provides the following methods:

=head2 $postal_rec->code()

This returns the postal code associated with the IP address. Postal codes are
not available for all countries. In some countries, this will only contain
part of the postal code.

This attribute is returned by all end points except the Country end point.

=head2 $postal_rec->confidence()

This returns a value from 0-100 indicating MaxMind's confidence that the
postal code is correct.

This attribute is only available from the Insights end point.

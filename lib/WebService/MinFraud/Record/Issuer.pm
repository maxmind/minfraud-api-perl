package WebService::MinFraud::Record::Issuer;

use strict;
use warnings;

our $VERSION = '0.001001';

use Sub::Quote qw( quote_sub );
use WebService::MinFraud::Types qw( Bool BoolCoercion Str );

use Moo;

has matches_provided_name => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
    coerce  => BoolCoercion,
);

has matches_provided_phone_number => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
    coerce  => BoolCoercion,
);

has name => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_name',
);

has phone_number => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_phone_number',
);

1;

# ABSTRACT: Contains data for the issuer of the credit card associated with a
# transaction.

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $insights = $client->insights( ip => '24.24.24.24' );

  my $issuer_rec = $insights->issuer;
  say $issuer_rec->name;

=head1 DESCRIPTION

This class contains the data for the issuer of the credit card associated with
a transaction.

=head1 METHODS

This class provides the following methods:

=head2 matches_provided_name

Returns a boolean indicating whether the name provided matches the known bank
name associated with the credit card

=head2 matches_provided_phone_number

Returns a boolean indicating whether the phone provided matches the known bank
phone associated with the credit card

=head2 name

Returns the name of the issuer of the credit card.

=head2 phone_number

Returns the phone number of the issuer of the credit card.


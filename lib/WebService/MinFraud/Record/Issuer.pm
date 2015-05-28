package WebService::MinFraud::Record::Issuer;

use strict;
use warnings;

our $VERSION = '0.001001';

use Sub::Quote qw( quote_sub );
use WebService::MinFraud::Types qw( Bool BoolCoercion Str );

use Moo;

has name => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_name',
);

has matches_provided_name => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
    coerce  => BoolCoercion,
);

has phone_number => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_phone_number',
);

has matches_provided_phone_number => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
    coerce  => BoolCoercion,
);

1;

# ABSTRACT: Contains data for the postal code record associated with an IP address

__END__

=head1 SYNOPSIS

  use 5.001001;

  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $insights = $client->insights( ip => '24.24.24.24' );

  my $issuer_rec = $insights->issuer();
  print $issuer_rec->name(), "\n";

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

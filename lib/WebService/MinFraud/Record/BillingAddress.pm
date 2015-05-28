package WebService::MinFraud::Record::BillingAddress;

use strict;
use warnings;

our $VERSION = '0.001001';

use Sub::Quote qw( quote_sub );
use WebService::MinFraud::Types qw( Bool BoolCoercion Num);

use Moo;

has distance_to_ip_location => (
    is  => 'ro',
    isa => Num,
);

has is_in_ip_country => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
    coerce  => BoolCoercion,
);

has is_postal_in_city => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
    coerce  => BoolCoercion,
);

has latitude => (
    is  => 'ro',
    isa => Num,
);

has longitude => (
    is  => 'ro',
    isa => Num,
);

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

  my $insights = $client->insights( ip => '24.24.24.24' );

  my $billing_address_rec = $insights->billing_address;
  print $billing_address_rec->distance_to_ip_location, "\n";

=head1 DESCRIPTION



=head1 METHODS

This class provides the following methods:

=head2

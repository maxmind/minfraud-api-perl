package WebService::MinFraud::Record::Country;

use strict;
use warnings;

our $VERSION = '0.001001';

use Moo;
use Sub::Quote qw( quote_sub );
use WebService::MinFraud::Types qw( Bool BoolCoercion );
extends 'GeoIP2::Record::Country';

has is_high_risk => (
    is      => 'ro',
    isa     => Bool,
    default => quote_sub(q{ 0 }),
    coerce  => BoolCoercion,
);

1;
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
  my $country_rec = $insights->country;
  say $country_rec->is_high_risk;

=head1 DESCRIPTION

This class contains the country data associated with a transaction

This record is returned by the insights end point.

=head1 METHODS

This class provides the same methods as L<GeoIP2::Record::Country> in addition
to:

=head2 is_high_risk


Returns a boolean indicating whether or not the country of the ip_address
is considered high risk.

package WebService::MinFraud::Record::Country;

use Moo;

our $VERSION = '0.001001';

use WebService::MinFraud::Types qw( Bool BoolCoercion );

extends 'GeoIP2::Record::Country';

has is_high_risk => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
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
  my $country = $insights->ip_address->country;
  say $country->is_high_risk;

=head1 DESCRIPTION

This class contains the country data associated with a transaction

This record is returned by the Insights end point.

=head1 METHODS

This class provides the same methods as L<GeoIP2::Record::Country> in addition
to:

=head2 is_high_risk


Returns a boolean indicating whether or not the country of the ip_address
is considered high risk.

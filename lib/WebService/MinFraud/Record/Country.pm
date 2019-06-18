package WebService::MinFraud::Record::Country;

use Moo;
use namespace::autoclean;

our $VERSION = '1.009002';

use GeoIP2::Record::Country 2.005001;
use WebService::MinFraud::Types qw( Bool BoolCoercion );

extends 'GeoIP2::Record::Country';

has is_high_risk => (
    is        => 'ro',
    isa       => Bool,
    coerce    => BoolCoercion,
    predicate => 1,
);

1;

# ABSTRACT: Contains data for the country record associated with an IP address

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      account_id  => 42,
      license_key => 'abcdef123456',
  );
  my $request  = { device => { ip_address => '24.24.24.24' } };
  my $insights = $client->insights($request);
  my $country  = $insights->ip_address->country;
  say $country->is_high_risk;

=head1 DESCRIPTION

This class contains the country data associated with a transaction.

This record is returned by the Insights web service.

=head1 METHODS

This class provides the same methods as L<GeoIP2::Record::Country> in addition
to:

=head2 is_high_risk

Returns a boolean indicating whether the country of the ip_address is
considered high risk.

=head1 PREDICATE METHODS

The following predicate methods are available, which return true if the related
data was present in the response body, false if otherwise:

=head2 has_is_high_risk

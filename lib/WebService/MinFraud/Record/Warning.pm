package WebService::MinFraud::Record::Warning;

use strict;
use warnings;

our $VERSION = '0.001001';

use Types::Standard qw( ArrayRef Enum Str );

use Moo;

has code => (
    is  => 'ro',
    isa => Enum [
        qw(
            BILLING_CITY_NOT_FOUND
            BILLING_COUNTRY_NOT_FOUND
            BILLING_POSTAL_NOT_FOUND
            INPUT_INVALID
            INPUT_UNKNOWN
            IP_ADDRESS_NOT_FOUND
            SHIPPING_CITY_NOT_FOUND
            SHIPPING_COUNTRY_NOT_FOUND
            SHIPPING_POSTAL_NOT_FOUND
            )
    ],
);

has warning => (
    is        => 'ro',
    isa       => Str,
    predicate => 1,
);

has input => (
    is        => 'ro',
    isa       => ArrayRef [Str],
    predicate => 1,
);

1;

# ABSTRACT: Contains data for the warning record returned from a web service
# query

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
  my $warnings_rec = $insights->warning;
  say $warnings_rec->warning;

=head1 DESCRIPTION

This class contains the maxmind warning (if any) from a web service query.

=head1 METHODS

This class provides the following methods:

=head2 code

Returns a machine-readable code identifying the warning of the following types:

        BILLING_CITY_NOT_FOUND
        BILLING_COUNTRY_NOT_FOUND
        BILLING_POSTAL_NOT_FOUND
        INPUT_INVALID
        INPUT_UNKNOWN
        IP_ADDRESS_NOT_FOUND
        SHIPPING_CITY_NOT_FOUND
        SHIPPING_COUNTRY_NOT_FOUND
        SHIPPING_POSTAL_NOT_FOUND

=head2 warning

Returns a human-readable explanation of the warning.

=head2 input

Returns an array of keys representing the path to the input that the warning is
associated with. For instance, if the warning was about the billing city, the
array would be ["billing", "city"]


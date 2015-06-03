package WebService::MinFraud::Error::IPAddressNotFound;

use strict;
use warnings;

our $VERSION = '0.001001';

use WebService::MinFraud::Types qw( Str );

use Moo;

extends 'Throwable::Error';

has ip_address => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

1;

# ABSTRACT: An exception thrown when an IP address is not in the MaxMind
# minFraud service

__END__

=head1 SYNOPSIS

  use 5.010;

  use  WebService::MinFraud::Client;
  use Scalar::Util qw( blessed );
  use Try::Tiny;

  my $client =  WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  try {
      my $request = { device => { ip_address => '24.24.24.24'} };
      $client->insights( $request );
  }
  catch {
      die $_ unless blessed $_;
      if ( $_->isa(' WebService::MinFraud::Error::IPAddressNotFound') ) {
          log_ip_address_not_found_error( ip_address => $_->ip_address() );
      }

      # handle other exceptions
  };

=head1 DESCRIPTION

This class represents an error that occurs when an IP address is not found in
the MaxMind minFraud service.

=head1 METHODS

The C<< $error->message() >>, and C<< $error->stack_trace() >> methods are
inherited from L<Throwable::Error>. It also provide two methods of its own:

=head2 ip_address

Returns the IP address that could not be found.

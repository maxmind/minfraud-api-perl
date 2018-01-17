package WebService::MinFraud::Error::HTTP;

use Moo;
use namespace::autoclean;

our $VERSION = '1.006000';

with 'WebService::MinFraud::Role::Error::HTTP';

extends 'Throwable::Error';

1;

# ABSTRACT: An HTTP transport error

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  use Scalar::Util qw( blessed );
  use Try::Tiny;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  try {
      my $request = { device => { ip_address => '24.24.24.24' } };
      $client->insights( $request );
  }
  catch {
      die $_ unless blessed $_;
      if ( $_->isa('WebService::MinFraud::Error::HTTP') ) {
          log_http_error(
              status => $_->http_status,
              uri    => $_->uri,
          );
      }

      # handle other exceptions
  };

=head1 DESCRIPTION

This class represents an HTTP transport error. It extends L<Throwable::Error>
and adds attributes of its own.

=head1 METHODS

The C<< message >> and C<< stack_trace >> methods are
inherited from L<Throwable::Error>. It also provide two methods of its own:

=head2 http_status

Returns the HTTP status. This should be either a 4xx or 5xx error.

=head2 uri

Returns the URI which gave the HTTP error.

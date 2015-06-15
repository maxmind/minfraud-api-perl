package WebService::MinFraud::Error::Type;

use Moo;

our $VERSION = '0.001001';

extends 'Throwable::Error';

# We can't load WebService::MinFraud::Types to get types here because we'd have
# a circular use in that case.
has type => (
    is       => 'ro',
    required => 1,
);

has value => (
    is       => 'ro',
    required => 1,
);

1;

# ABSTRACT: A type validation error

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;
  use Scalar::Util qw( blessed );
  use Try::Tiny;

  my $client = WebService::MinFraud::WebService::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  try {
      my $request = { device => { ip_address => '24.24.24.24'} };
      $client->insights( $request );
  }
  catch {
      die $_ unless blessed $_;
      if ( $_->isa('WebService::MinFraud::Error::Type') ) {
          log_validation_error(
              type   => $_->name,
              value  => $_->value,
          );
      }

      # handle other exceptions
  };

=head1 DESCRIPTION

This class represents a Moo type validation error. It extends
L<Throwable::Error> and adds attributes of its own.

=head1 METHODS

The C<< message >> and C<< stack_trace >> methods are
inherited from L<Throwable::Error>. It also provide two methods of its own:

=head2 name

Returns the name of the type which failed validation.

=head2 value

Returns the value which triggered the validation failure.


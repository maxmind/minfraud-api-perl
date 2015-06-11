package WebService::MinFraud::Error::Generic;

use strict;
use warnings;

our $VERSION = '0.001001';

use Moo;

extends 'Throwable::Error';

1;

# ABSTRACT: A generic exception class for WebService::MinFraud errors

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
      my $request = { device => { ip_address => '24.24.24.24'} };
      $client->insights( $request );
  }
  catch {
      die $_ unless blessed $_;
      die $_ if $_->isa('WebService::MinFraud::Error::Generic');

      # handle other exceptions
  };

=head1 DESCRIPTION

This class represents a generic error. It extends L<Throwable::Error> and does
not add any additional attributes.

=head1 METHODS

This class has two methods, both of which are inherited from
L<Throwable::Error>.

=head2 message

=head2 stack_trace


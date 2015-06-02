package WebService::MinFraud::Record::MaxMind;

use strict;
use warnings;

our $VERSION = '0.001001';

use WebService::MinFraud::Types qw( NonNegativeInt );

use Moo;

has credits_remaining => (
    is  => 'ro',
    isa => NonNegativeInt,
);

1;

# ABSTRACT: Contains data for the maxmind record returned from a web service query

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $insights = $client->insights( ip => '24.24.24.24' );

  my $maxmind_rec = $insights->maxmind();
  say $maxmind_rec->credits_remaining();

=head1 DESCRIPTION

This class contains the maxmind record data returned from a minFraud web
service query.

Unlike other record classes, the data in this record is associated with your
MaxMind account, not with a transaction or IP address.

This record is returned by all the end points. [TODO - correct?]

=head1 METHODS

This class provides the following methods:

=head2 credits_remaining

The number of credits remaining for your account. Note that this is an
approximation as credit counts are only periodically synced across all
of MaxMind's servers.


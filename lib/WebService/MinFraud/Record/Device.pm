package WebService::MinFraud::Record::Device;

use Moo;

our $VERSION = '0.002001';

use Types::UUID;

has id => (
    is        => 'ro',
    isa       => Uuid,
    predicate => 1,
);

1;

# ABSTRACT: Contains data for the device associated with a transaction

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );
  my $request  = { device => { ip_address => '24.24.24.24' } };
  my $insights = $client->insights($request);
  my $device   = $insights->device;
  say $device->id;

=head1 DESCRIPTION

This class contains the data for the device associated with a transaction.

=head1 METHODS

This class provides the following methods:

=head2 id

A UUID that MaxMind uses for the device associated
with this IP address. Note that many devices cannot be uniquely identified
because they are too common (for example, all iPhones of a given model and
OS release). In these cases, the minFraud service will simply not return a
UUID for that device.

=head1 PREDICATE METHODS

The following predicate methods are available, which return true if the related
data was present in the response body, false if otherwise:

=head2 has_id
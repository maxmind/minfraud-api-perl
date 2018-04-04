package WebService::MinFraud::Record::Device;

use Moo;
use namespace::autoclean;

our $VERSION = '1.007000';

use Types::UUID;
use WebService::MinFraud::Types qw( Num Str );

has confidence => (
    is        => 'ro',
    isa       => Num,
    predicate => 1,
);

has id => (
    is        => 'ro',
    isa       => Uuid,
    predicate => 1,
);

has last_seen => (
    is        => 'ro',
    isa       => Str,
    predicate => 1,
);

has local_time => (
    is        => 'ro',
    isa       => Str,
    predicate => 1,
);

1;

# ABSTRACT: Contains data for the device associated with a transaction

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
  my $device   = $insights->device;
  say 'Device ' . $device->id . ' was last seen ' . $device->last_seen;

=head1 DESCRIPTION

This class contains the data for the device associated with a transaction.

=head1 METHODS

This class provides the following methods:

=head2 confidence

This number represents our confidence that the device_id refers to a unique
device as opposed to a cluster of similar devices.

=head2 id

A UUID that MaxMind uses for the device associated
with this IP address. Note that many devices cannot be uniquely identified
because they are too common (for example, all iPhones of a given model and
OS release). In these cases, the minFraud service will simply not return a
UUID for that device.

=head2 last_seen

This is the date and time of the last sighting of the device on the specified
IP address for your user account. The string is formatted in the ISO 8601
combined date and time in UTC.

=head2 local_time

This is the date and time of the transaction at the UTC offset associated with
the device. The string is in the ISO 8601 combined date and time format.

=head2 session_age

A floating point number. The number of seconds between the creation of the
user's session and the time of the transaction. Note that C<session_age> is not
the duration of the current visit, but the time since the start of the first
visit.

=head2 session_id

A string up to 255 characters in length. This is an ID which uniquely
identifies a visitor's session on the site.

=head1 PREDICATE METHODS

The following predicate methods are available, which return true if the related
data was present in the response body, false if otherwise:

=head2 has_confidence

=head2 has_id

=head2 has_last_seen

=head2 has_local_time

=head2 has_session_age

=head2 has_session_id

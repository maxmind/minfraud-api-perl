use strict;
use warnings;

use Test::Fatal qw( exception );
use Test::More 0.88;

use WebService::MinFraud::Record::Device;

my $device_id = 'ECE205B0-BE16-11E5-B83F-FE035C37265F';
my $last_seen = '2016-06-08T14:16:38Z';
my $device    = WebService::MinFraud::Record::Device->new(
    confidence  => 99.0,
    id          => $device_id,
    last_seen   => $last_seen,
    session_age => 3600,
    session_id  => 'foobarbaz99',
);

my %expect = (
    confidence  => 99,
    id          => $device_id,
    last_seen   => $last_seen,
    session_age => 3600,
    session_id  => 'foobarbaz99',
);

for my $attr ( keys %expect ) {
    subtest $attr => sub {
        is( $device->$attr, $expect{$attr}, $attr );
        my $predicate = 'has_' . $attr;
        ok( $device->$predicate, $predicate );
    };
}

like(
    exception(
        sub { WebService::MinFraud::Record::Device->new( session_age => -5 ) }
    ),
    qr{not a valid NonNegativeNum},
    'no negative session age'
);

done_testing;

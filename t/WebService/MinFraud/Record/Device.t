use strict;
use warnings;

use Test::More 0.88;

use WebService::MinFraud::Record::Device;

my $device_id = 'ECE205B0-BE16-11E5-B83F-FE035C37265F';
my $device = WebService::MinFraud::Record::Device->new( id => $device_id );

is( $device->id, $device_id, 'device id' );

done_testing;

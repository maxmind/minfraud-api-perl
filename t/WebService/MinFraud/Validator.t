use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;
use WebService::MinFraud::Validator;

my $validator    = WebService::MinFraud::Validator->new;
my $good_request = { device => { ip_address => '24.24.24.24' } };
my $bad_request  = {};
ok( $validator->validate_request($good_request), 'good request validates' );
like(
    exception { $validator->validate_request($bad_request); },
    qr/no value given for required entry device/,
    'bad request throws an exception'
);

done_testing;

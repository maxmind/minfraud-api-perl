use strict;
use warnings;

use Test::More 0.88;

use JSON::PP;
use WebService::MinFraud::Record::Issuer;

my $issuer = WebService::MinFraud::Record::Issuer->new(
    name                          => 'Bank',
    matches_provided_name         => 1,
    phone_number                  => '4065551212',
    matches_provided_phone_number => 0,
);

is( $issuer->name,                  'Bank',         'name' );
is( $issuer->matches_provided_name, JSON::PP::true, 'matches_provided_name' );
is( $issuer->phone_number,          '4065551212',   'phone_number' );
is(
    $issuer->matches_provided_phone_number, JSON::PP::false,
    'matches_provided_phone_number'
);

done_testing();

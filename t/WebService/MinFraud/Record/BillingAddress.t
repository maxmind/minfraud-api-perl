use strict;
use warnings;

use Test::More 0.88;

use WebService::MinFraud::Record::BillingAddress;

my $ba = WebService::MinFraud::Record::BillingAddress->new(
    is_in_ip_country        => 1,
    latitude                => 43.1,
    longitude               => 32.1,
    distance_to_ip_location => 100,
    is_postal_in_city       => 1
);

is( 1,    $ba->is_in_ip_country,        'is_in_ip_country' );
is( 1,    $ba->is_postal_in_city,       'is_postal_in_city' );
is( 100,  $ba->distance_to_ip_location, 'distance_to_ip_location' );
is( 32.1, $ba->longitude,               'longitude' );
is( 43.1, $ba->latitude,                'latitude' );

done_testing;

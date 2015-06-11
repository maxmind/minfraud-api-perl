use strict;
use warnings;

use Test::More 0.88;
use JSON::PP;

use WebService::MinFraud::Record::ShippingAddress;

my $ba = WebService::MinFraud::Record::ShippingAddress->new(
    is_in_ip_country            => 1,
    latitude                    => 43.1,
    longitude                   => 32.1,
    distance_to_ip_location     => 100,
    is_postal_in_city           => 1,
    is_high_risk                => JSON::PP::true,
    distance_to_billing_address => 200,
);

is( 1,    $ba->is_in_ip_country,            'is_in_ip_country' );
is( 1,    $ba->is_postal_in_city,           'is_postal_in_city' );
is( 100,  $ba->distance_to_ip_location,     'distance_to_ip_location' );
is( 32.1, $ba->longitude,                   'longitude' );
is( 43.1, $ba->latitude,                    'latitude' );
is( 1,    $ba->is_high_risk,                'is_high_risk' );
is( 200,  $ba->distance_to_billing_address, 'distance_to_billing_address' );

done_testing;

use strict;
use warnings;

use JSON;
use Test::More 0.88;
use WebService::MinFraud::Client;

BEGIN {
    unless ( $ENV{AUTHOR_TESTING} ) {
        Test::More::plan( skip_all =>
                'These tests are for testing by the author as they require a live minFraud service.'
        );
    }
}

my $client;
if ( $ENV{MM_LICENSE_KEY} ) {
    $client = WebService::MinFraud::Client->new(
        host    => $ENV{MM_MINFRAUD_HOST} || 'ct100-test.maxmind.com',
        user_id => $ENV{MM_USER_ID}       || 10,
        license_key => $ENV{MM_LICENSE_KEY},
    );
}
my $request_file = 'xt/data/full-request.json';
my $request_json = do {
    local $/ = undef;
    open my $fh, '<', $request_file
        or die "Could not open $request_file: $!";
    <$fh>;
};
my $request        = decode_json($request_json);
my $response_score = $client->score($request);
ok( exists $response_score->raw->{risk_score}, 'raw risk_score exists' );

my $response_insights = $client->insights($request);
ok( exists $response_insights->raw->{risk_score}, 'risk_score exists' );
ok( $response_insights,                           'insights response' );
ok( $response_insights->billing_address, 'billing address record exists' );
ok(
    $response_insights->billing_address->latitude,
    'billing latitude exists'
);
ok( $response_insights->credit_card, 'credit card record exists' );
ok(
    $response_insights->credit_card->issuer,
    'credit card issuer record exists'
);
ok(
    $response_insights->credit_card->issuer->name,
    'credit card issuer name exists'
);
ok( $response_insights->maxmind,          'maxmind record exists' );
ok( $response_insights->shipping_address, 'shipping address record exists' );
ok(
    $response_insights->shipping_address->latitude,
    'shipping latitude exists'
);
ok( $response_insights->ip_location,       'ip_location record exists' );
ok( $response_insights->ip_location->city, 'city exists' );
ok(
    $response_insights->ip_location->city->geoname_id,
    'city geoname id exists'
);

done_testing();

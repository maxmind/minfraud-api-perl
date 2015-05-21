use strict;
use warnings;

use JSON;
use Test::More 0.88;
use WebService::MinFraud::Client;

BEGIN {
  unless ($ENV{AUTHOR_TESTING}) {
    Test::More::plan(skip_all => 'These tests are for testing by the author as they require a live minFraud service.');
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
my $request = decode_json($request_json);
my $response = $client->score($request);
ok( exists $response->raw->{risk_score}, 'risk_score exists' );

done_testing();

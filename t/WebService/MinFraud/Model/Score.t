use strict;
use warnings;

use lib 't/lib';

use JSON;
use Test::More 0.88;
use Test::WebService::MinFraud qw( test_common_attributes );
use WebService::MinFraud::Model::Score;

my $response_file = 't/data/score-response.json';
my $response_json = do {
    local $/ = undef;
    open my $fh, '<', $response_file
        or die "Could not open $response_file: $!";
    <$fh>;
};
my $response    = decode_json($response_json);
my $model_class = 'WebService::MinFraud::Model::Score';
my $score_model = $model_class->new($response);
test_common_attributes( $score_model, $model_class, $response );

done_testing();

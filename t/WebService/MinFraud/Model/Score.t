use strict;
use warnings;

use lib 't/lib';

use Test::WebService::MinFraud qw(
    test_model_class
    test_model_class_with_empty_record
    test_model_class_with_unknown_keys
);
use Test::More 0.88;

use WebService::MinFraud::Model::Score;
use WebService::MinFraud::Record::Warning;

{
    my %raw = (
        id                => '5bc5d6c2-b2c8-40af-87f4-6d61af86b6ae',
        risk_score        => 0.01,
        credits_remaining => 1212,
        warnings          => [
            {
                code => 'INPUT_INVALID',
                warning =>
                    'Encountered value at /shipping/city that does meet the required constraints',
                input => [ 'shipping', 'city' ],
            },
        ],
    );

    my $model_class = 'WebService::MinFraud::Model::Score';
    my $model       = $model_class->new(%raw);
    isa_ok( $model, $model_class, "$model_class->new returns" );
    is( $model->id, '5bc5d6c2-b2c8-40af-87f4-6d61af86b6ae', 'id' );
    is( $model->risk_score,        0.01, 'risk_score' );
    is( $model->credits_remaining, 1212, 'credits_remaining' );
    foreach my $warning ( @{ $model->warnings() } ) {
        isa_ok(
            $warning, 'WebService::MinFraud::Record::Warning',
            '$model->warnings'
        );
    }

}

done_testing();

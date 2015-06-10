use strict;
use warnings;

use lib 't/lib';

use JSON;
use Test::More 0.88;
use Test::WebService::MinFraud qw(
    test_common_attributes
    test_model_class
    test_model_class_with_empty_record
    test_model_class_with_unknown_keys
);
use WebService::MinFraud::Model::Insights;

my $response_file = 't/data/insights-response.json';
my $response_json = do {
    local $/ = undef;
    open my $fh, '<', $response_file
        or die "Could not open $response_file: $!";
    <$fh>;
};
my $response = decode_json($response_json);
my $class    = 'WebService::MinFraud::Model::Insights';
my $model    = WebService::MinFraud::Model::Insights->new($response);
test_model_class( $class, $response );
test_common_attributes( $model, $class, $response );
is_deeply( $model->raw, $response, 'response gets stored as raw' );

# We create a response structure to help us test the various attributes
# that we create from the response.
my @top_level          = keys %{ $response->{ip_location} };
my @ip_location_hashes = map {
    { $_ => [ keys %{ $response->{ip_location}{$_} } ] }
    }
    grep {
           ref( $response->{ip_location}{$_} )
        && ref( $response->{ip_location}{$_} ) eq 'HASH'
    } @top_level;
my $response_structure = {
    billing_address  => [ keys %{ $response->{billing_address} } ],
    shipping_address => [ keys %{ $response->{shipping_address} } ],
    credit_card      => [
        'country',
        'is_issued_in_billing_address_country',
        'is_prepaid',
        {
            issuer => [ keys %{ $response->{credit_card}{issuer} } ],
        },
    ],
    ip_location => \@ip_location_hashes,
};

foreach my $attribute ( keys %{$response_structure} ) {
    my @subattributes = @{ $response_structure->{$attribute} };
    foreach my $subattribute (@subattributes) {
        if ( ref($subattribute) and ref($subattribute) eq 'HASH' ) {

            # get the key its value(s)
            foreach my $subsubattribute ( keys %{$subattribute} ) {
                foreach my $value ( @{ $subattribute->{$subsubattribute} } ) {
                    is(
                        $model->$attribute->$subsubattribute->$value,
                        $response->{$attribute}->{$subsubattribute}->{$value},
                        "${attribute} > ${subsubattribute} > ${value}"
                    );
                }
            }
        }
        else {
            is(
                $model->$attribute->$subattribute,
                $response->{$attribute}->{$subattribute},
                "${attribute} > ${subattribute}"
            );
        }
    }
}

test_model_class_with_empty_record($class);
test_model_class_with_unknown_keys($class);

done_testing();

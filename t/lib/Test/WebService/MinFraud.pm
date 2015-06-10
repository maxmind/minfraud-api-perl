package Test::WebService::MinFraud;

use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;

use Exporter qw( import );

our @EXPORT_OK = qw(
    test_common_attributes
    test_model_class
    test_model_class_with_empty_record
    test_model_class_with_unknown_keys
);

sub test_common_attributes {
    my $model = shift;
    my $class = shift;
    my $raw   = shift;

    isa_ok( $model, $class, 'Have an appropriate model' );
    my @attributes = qw( credits_remaining id risk_score );
    foreach my $attribute (@attributes) {
        is( $model->$attribute, $raw->{$attribute}, "${attribute}" );
    }
    is(
        ref( $model->warnings ), 'ARRAY',
        'warnings are an array referernce'
    );
    my @warnings = @{ $model->warnings };
    foreach my $i ( 0 .. $#warnings ) {
        isa_ok(
            $warnings[$i], 'WebService::MinFraud::Record::Warning',
            '$model->warnings'
        );
        is(
            $warnings[$i]->code, $raw->{warnings}->[$i]->{code},
            'warning code'
        );
        is(
            $warnings[$i]->warning,
            $raw->{warnings}->[$i]->{warning},
            'warning message'
        );
        is_deeply(
            $warnings[$i]->input,
            $raw->{warnings}->[$i]->{input},
            'warning input'
        );
    }
}

sub test_ip_location {
    my $model = shift;
    my $class = shift;
    my $raw   = shift;

    isa_ok(
        $model->ip_location->city,
        'GeoIP2::Record::City', '$model->ip_location->city'
    );

    isa_ok(
        $model->ip_location->continent,
        'GeoIP2::Record::Continent', '$model->ip_location->continent'
    );

    isa_ok(
        $model->ip_location->country,
        'GeoIP2::Record::Country', '$model->ip_location->country'
    );

    isa_ok(
        $model->ip_location->location,
        'GeoIP2::Record::Location', '$model->ip_location->location'
    );

    isa_ok(
        $model->ip_location->postal,
        'GeoIP2::Record::Postal', '$model->ip_location->postal'
    );

    isa_ok(
        $model->ip_location->registered_country,
        'GeoIP2::Record::Country',
        '$model->ip_location->registered_country'
    );
    if ( defined $model->ip_location->represented_country ) {
        isa_ok(
            $model->ip_location->represented_country,
            'GeoIP2::Record::RepresentedCountry',
            '$model->ip_location->represented_country'
        );
    }

    if ( defined $model->ip_location->most_specific_subdivision ) {
        isa_ok(
            $model->ip_location->most_specific_subdivision,
            'GeoIP2::Record::Subdivision',
            '$model->ip_location->most_specific_subdivision',
        );
    }

    isa_ok(
        $model->ip_location->traits,
        'GeoIP2::Record::Traits', '$model->ip_location->traits'
    );
}

sub test_model_class {
    my $class = shift;
    my $raw   = shift;

    my $model = $class->new($raw);

    isa_ok( $model, $class, "$class->new returns" );

    my @subdivisions = $model->ip_location->subdivisions;
    for my $i ( 0 .. $#subdivisions ) {
        isa_ok(
            $subdivisions[$i], 'GeoIP2::Record::Subdivision',
            "\$model->ip_location->subdivisions[$i]"
        );
    }
    foreach my $warning ( @{ $model->warnings } ) {
        isa_ok(
            $warning, 'WebService::MinFraud::Record::Warning',
            '$model->warnings'
        );
    }

    test_top_level( $model, $class, $raw );
    test_ip_location( $model, $class, $raw );
}

sub test_model_class_with_empty_record {
    my $class = shift;

    my %raw = ( traits => { ip_address => '5.6.7.8' }, );

    my $model = $class->new(%raw);

    isa_ok(
        $model, $class,
        "$class object with no data except traits.ip_address"
    );

    test_top_level( $model, $class, \%raw );

    my @subdivisions = $model->ip_location->subdivisions;
    is(
        scalar @subdivisions,
        0, '$model->ip_location->subdivisions returns an empty list'
    );
}

sub test_model_class_with_unknown_keys {
    my $class = shift;

    my %raw = (
        new_top_level => { foo => 42 },
        city          => {
            confidence => 76,
            geoname_id => 9876,
            names      => { en => 'Minneapolis' },
            population => 50,
        },
        traits => { ip_address => '5.6.7.8' },
    );

    my $model;
    is(
        exception { $model = $class->new(%raw) },
        undef,
        "no exception when $class class gets raw data with unknown keys"
    );

    is_deeply( $model->raw, \%raw, 'raw method returns raw input' );
}

sub test_top_level {
    my $model = shift;
    my $class = shift;
    my $raw   = shift;

    isa_ok(
        $model->billing_address,
        'WebService::MinFraud::Record::BillingAddress',
        '$model->billing_address'
    );

    isa_ok(
        $model->credit_card, 'WebService::MinFraud::Record::CreditCard',
        '$model->credit_card'
    );

    isa_ok(
        $model->shipping_address,
        'WebService::MinFraud::Record::ShippingAddress',
        '$model->shipping_address'
    );

    isa_ok(
        $model->ip_location, 'WebService::MinFraud::Record::IPLocation',
        '$model->ip_location'
    );

    is_deeply( $model->raw, $raw, 'raw method returns raw input' );
}

1;

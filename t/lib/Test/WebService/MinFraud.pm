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

sub test_ip_address {
    my $model = shift;
    my $class = shift;
    my $raw   = shift;

    isa_ok(
        $model->ip_address->city,
        'GeoIP2::Record::City', '$model->ip_address->city'
    );

    isa_ok(
        $model->ip_address->continent,
        'GeoIP2::Record::Continent', '$model->ip_address->continent'
    );

    isa_ok(
        $model->ip_address->country,
        'GeoIP2::Record::Country', '$model->ip_address->country'
    );

    isa_ok(
        $model->ip_address->location,
        'GeoIP2::Record::Location', '$model->ip_address->location'
    );

    isa_ok(
        $model->ip_address->postal,
        'GeoIP2::Record::Postal', '$model->ip_address->postal'
    );

    isa_ok(
        $model->ip_address->registered_country,
        'GeoIP2::Record::Country', '$model->ip_address->registered_country'
    );
    if ( defined $model->ip_address->represented_country ) {
        isa_ok(
            $model->ip_address->represented_country,
            'GeoIP2::Record::RepresentedCountry',
            '$model->ip_address->represented_country'
        );
    }

    if ( defined $model->ip_address->most_specific_subdivision ) {
        isa_ok(
            $model->ip_address->most_specific_subdivision,
            'GeoIP2::Record::Subdivision',
            '$model->ip_address->most_specific_subdivision',
        );
    }

    isa_ok(
        $model->ip_address->traits,
        'GeoIP2::Record::Traits', '$model->ip_address->traits'
    );
}

sub test_model_class {
    my $class = shift;
    my $raw   = shift;

    my $model = $class->new($raw);

    isa_ok( $model, $class, "$class->new returns" );

    my @subdivisions = $model->ip_address->subdivisions;
    for my $i ( 0 .. $#subdivisions ) {
        isa_ok(
            $subdivisions[$i], 'GeoIP2::Record::Subdivision',
            "\$model->ip_address->subdivisions[$i]"
        );
    }
    foreach my $warning ( @{ $model->warnings } ) {
        isa_ok(
            $warning, 'WebService::MinFraud::Record::Warning',
            '$model->warnings'
        );
    }

    test_top_level( $model, $class, $raw );
    test_ip_address( $model, $class, $raw );
}

sub test_model_class_with_empty_record {
    my $class = shift;

    my %raw = (
        billing_address => {},
        ip_address      => { traits => { ip_address => '5.6.7.8' } }
    );

    my $model = $class->new(%raw);

    isa_ok(
        $model, $class,
        "$class object with no data except ip_adress.traits.ip_address"
    );

    test_top_level( $model, $class, \%raw );
    my @subdivisions = $model->ip_address->subdivisions;
    is(
        scalar @subdivisions,
        0, '$model->ip_address->subdivisions returns an empty list'
    );
}

sub test_model_class_with_unknown_keys {
    my $class = shift;

    my %raw = (
        new_top_level => { foo => 42 },
        ip_address    => {
            city => {
                confidence => 76,
                geoname_id => 9876,
                names      => { en => 'Minneapolis' },
                population => 50,
            },
            traits => { ip_address => '5.6.7.8' },
        },
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
        $model->ip_address, 'WebService::MinFraud::Record::IPAddress',
        '$model->ip_address'
    );

    is_deeply( $model->raw, $raw, 'raw method returns raw input' );
}

1;

use strict;
use warnings;

use lib 't/lib';

use Test::WebService::MinFraud qw(
    test_model_class
    test_model_class_with_empty_record
    test_model_class_with_unknown_keys
);
use Test::More 0.88;

use WebService::MinFraud::Model::Insights;

{
    my %raw = (
        id                => '5bc5d6c2-b2c8-40af-87f4-6d61af86b6ae',
        risk_score        => 0.01,
        credits_remaining => 1212,

        billing_address => {
            is_postal_in_city       => 1,
            latitude                => 37.545,
            longitude               => -122.421,
            distance_to_ip_location => 100,
            is_in_ip_country        => 1
        },
        credit_card => {
            issuer => {
                name                          => 'Bank of America',
                matches_provided_name         => 1,
                phone_number                  => '800-732-9194',
                matches_provided_phone_number => 1,
            },
            country                              => 'US',
            is_issued_in_billing_address_country => 1,
            is_prepaid                           => 1,
        },
        shipping_address => {
            is_high_risk                => 1,
            is_postal_in_city           => 1,
            latitude                    => 37.632,
            longitude                   => -122.313,
            distance_to_ip_location     => 15,
            distance_to_billing_address => 22,
            is_in_ip_country            => 1
        },
        ip_location => {
            city => {
                confidence => 76,
                geoname_id => 9876,
                names      => { en => 'Minneapolis' },
            },
            continent => {
                code       => 'NA',
                geoname_id => 42,
                names      => { en => 'North America' },
            },
            country => {
                confidence => 99,
                geoname_id => 1,
                iso_code   => 'US',
                names      => {
                    'de'    => 'Nordamerika',
                    'en'    => 'North America',
                    'ja'    => '北米',
                    'es'    => 'América del Norte',
                    'fr'    => 'Amérique du Nord',
                    'ja'    => '北アメリカ',
                    'pt-BR' => 'América do Norte',
                    'ru'    => 'Северная Америка',
                    'zh-CN' => '北美洲',
                },
            },
            location => {
                accuracy_radius => 1500,
                latitude        => 44.98,
                longitude       => 93.2636,
                metro_code      => 765,
                time_zone       => 'America/Chicago',
            },
            maxmind => {
                queries_remaining => 42,
            },
            postal => {
                code       => '12345',
                confidence => 57,
            },
            registered_country => {
                geoname_id => 2,
                iso_code   => 'CA',
                names      => { en => 'Canada' },
            },
            represented_country => {
                geoname_id => 3,
                iso_code   => 'GB',
                names      => { en => 'United Kingdom' },
            },
            subdivisions => [
                {
                    confidence => 88,
                    geoname_id => 574635,
                    iso_code   => 'MN',
                    names      => { en => 'Minnesota' },
                }
            ],
            traits => {
                autonomous_system_number       => 1234,
                autonomous_system_organization => 'AS Organization',
                domain                         => 'example.com',
                ip_address                     => '1.2.3.4',
                is_satellite_provider          => 1,
                isp                            => 'Comcast',
                organization                   => 'Blorg',
                user_type                      => 'college',
            },
        },
        warnings => [
            {
                code => 'INPUT_INVALID',
                warning =>
                    'Encountered value at /shipping/city that does meet the required constraints',
                input => [ 'shipping', 'city' ],
            },
        ],
    );

    test_model_class( 'WebService::MinFraud::Model::Insights', \%raw );
}

{
    test_model_class_with_empty_record(
        'WebService::MinFraud::Model::Insights');
    test_model_class_with_unknown_keys(
        'WebService::MinFraud::Model::Insights');
}

done_testing();

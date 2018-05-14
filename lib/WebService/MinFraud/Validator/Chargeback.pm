package WebService::MinFraud::Validator::Chargeback;

use Moo;
use namespace::autoclean;

use WebService::MinFraud::Data::Rx::Type::Enum;
use WebService::MinFraud::Data::Rx::Type::IPAddress;

our $VERSION = '1.008000';

extends 'WebService::MinFraud::Validator::Base';

sub _build_rx_plugins {
    Data::Rx->new(
        {
            prefix => {
                maxmind => 'tag:maxmind.com,MAXMIND:rx/',
            },
            type_plugins => [
                qw(
                    WebService::MinFraud::Data::Rx::Type::Enum
                    WebService::MinFraud::Data::Rx::Type::IPAddress
                    )
            ],
        },
    );
}

sub _build_request_schema_definition {
    return {
        type     => '//rec',
        required => {
            ip_address => {
                type => '/maxmind/ip',
            },
        },
        optional => {
            chargeback_code => '//str',
            tag             => {
                type     => '/maxmind/enum',
                contents => {
                    type   => '//str',
                    values => [
                        'not_fraud',
                        'suspected_fraud',
                        'spam_or_abuse',
                        'chargeback',
                    ],
                },
            },
            maxmind_id => {
                type   => '//str',
                length => { 'min' => 8, 'max' => 8 },
            },
            minfraud_id => {
                type   => '//str',
                length => { 'min' => 36, 'max' => 36 },
            },
            transaction_id => '//str',
        },
    };
}

1;

# ABSTRACT: Validation for the minFraud Chargeback

__END__

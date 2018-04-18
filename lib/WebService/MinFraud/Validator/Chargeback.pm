package WebService::MinFraud::Validator::Chargeback;

use Moo;
use namespace::autoclean;

our $VERSION = '1.007001';

extends 'WebService::MinFraud::Validator::Base';

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
                length => { 'min' => 1, 'max' => 8 },
            },
            minfraud_id => {
                type   => '//str',
                length => { 'min' => 1, 'max' => 36 },
            },
            transaction_id => '//str',
        },
    };
}

1;

package WebService::MinFraud::Validator;

use Moo;

our $VERSION = '0.001001';

use Data::Rx;
use Try::Tiny;
use Types::Standard qw( HashRef InstanceOf Object );
use WebService::MinFraud::Data::Rx::Type::DateTime::RFC3339;
use WebService::MinFraud::Data::Rx::Type::Enum;
use WebService::MinFraud::Data::Rx::Type::Hex32;
use WebService::MinFraud::Data::Rx::Type::Hostname;
use WebService::MinFraud::Data::Rx::Type::IPAddress;
use WebService::MinFraud::Data::Rx::Type::WebURI;

has _request_schema_definition => (
    is      => 'lazy',
    isa     => HashRef,
    builder => '_build_request_schema_definition',
);

has _rx => (
    is      => 'lazy',
    isa     => InstanceOf ['Data::Rx'],
    builder => sub {
        Data::Rx->new(
            {
                prefix => {
                    maxmind => 'tag:maxmind.com,MAXMIND:rx/',
                },
                type_plugins => [
                    qw(
                        WebService::MinFraud::Data::Rx::Type::DateTime::RFC3339
                        WebService::MinFraud::Data::Rx::Type::Enum
                        WebService::MinFraud::Data::Rx::Type::Hex32
                        WebService::MinFraud::Data::Rx::Type::Hostname
                        WebService::MinFraud::Data::Rx::Type::IPAddress
                        WebService::MinFraud::Data::Rx::Type::WebURI
                        )
                ],
            }
        );
    },
);

has _schema => (
    is      => 'lazy',
    isa     => Object,
    builder => sub {
        my $self = shift;
        $self->_rx->make_schema( $self->_request_schema_definition );
    },
);

sub _build_request_schema_definition {
    return {
        type     => '//rec',
        required => {
            device => {
                type     => '//rec',
                required => {
                    ip_address => {
                        type => '/maxmind/ip',
                    },
                },
                optional => {
                    user_agent      => '//str',
                    accept_language => '//str',
                },
            }
        },
        optional => {
            account => {
                type     => '//rec',
                optional => {
                    user_id      => '//str',
                    username_md5 => '/maxmind/hex32',
                },
            },
            billing => {
                type     => '//rec',
                optional => {
                    first_name => '//str',
                    last_name  => '//str',
                    company    => '//str',
                    address    => '//str',
                    address_2  => '//str',
                    city       => '//str',
                    region     => {
                        type   => '//str',
                        length => { 'min' => 1, 'max' => 4 },
                    },
                    country => {
                        type   => '//str',
                        length => { 'min' => 2, 'max' => 2 },
                    },
                    postal             => '//str',
                    phone_number       => '//str',
                    phone_country_code => '//int',
                },
            },
            credit_card => {
                type     => '//rec',
                optional => {
                    issuer_id_number => {
                        type   => '//str',
                        length => { 'min' => 6, 'max' => 6 },
                    },
                    last_4_digits => => {
                        type   => '//str',
                        length => { 'min' => 4, 'max' => 4 },
                    },
                    bank_name               => '//str',
                    bank_phone_country_code => '//int',
                    bank_phone_number       => '//str',
                    avs_result              => {
                        type   => '//str',
                        length => { 'min' => 1, 'max' => 1 },
                    },
                    cvv_result => {
                        type   => '//str',
                        length => { 'min' => 1, 'max' => 1 },
                    },
                },
            },
            email => {
                type     => '//rec',
                optional => {
                    address => '//str',
                    domain  => '/maxmind/hostname',
                },
            },
            event => {
                type     => '//rec',
                optional => {
                    transaction_id => '//str',
                    shop_id        => '//str',
                    time           => '/maxmind/datetime/rfc3339',
                    type           => {
                        type     => '/maxmind/enum',
                        contents => {
                            type   => '//str',
                            values => [
                                'account_creation', 'account_login',
                                'purchase',         'recurring_purchase',
                                'referral',         'survey',
                            ],
                        },
                    }
                },
            },
            order => {
                type     => '//rec',
                optional => {
                    amount   => '//num',
                    currency => {
                        type   => '//str',
                        length => { 'min' => 3, 'max' => 3 },
                    },
                    discount_code   => '//str',
                    affiliate_id    => '//str',
                    subaffiliate_id => '//str',
                    referrer_uri    => '/maxmind/weburi',
                },
            },
            payment => {
                type     => '//rec',
                optional => {
                    processor => {
                        type     => '/maxmind/enum',
                        contents => {
                            type   => '//str',
                            values => [
                                'adyen',
                                'altapay',
                                'amazon_payments',
                                'authorizenet',
                                'balanced',
                                'beanstream',
                                'bluepay',
                                'braintree',
                                'chase_paymentech',
                                'cielo',
                                'collector',
                                'compropago',
                                'conekta',
                                'cuentadigital',
                                'dibs',
                                'digital_river',
                                'elavon',
                                'epayeu',
                                'eprocessing_network',
                                'eway',
                                'first_data',
                                'global_payments',
                                'ingenico',
                                'internetsecure',
                                'intuit_quickbooks_payments',
                                'iugu',
                                'mastercard_payment_gateway',
                                'mercadopago',
                                'merchant_esolutions',
                                'mirjeh',
                                'mollie',
                                'moneris_solutions',
                                'nmi',
                                'other',
                                'openpaymx',
                                'optimal_payments',
                                'payfast',
                                'paygate',
                                'payone',
                                'paypal',
                                'paystation',
                                'paytrace',
                                'paytrail',
                                'payture',
                                'payu',
                                'payulatam',
                                'princeton_payment_solutions',
                                'psigate',
                                'qiwi',
                                'raberil',
                                'rede',
                                'redpagos',
                                'rewardspay',
                                'sagepay',
                                'simplify_commerce',
                                'skrill',
                                'smartcoin',
                                'sps_decidir',
                                'stripe',
                                'telerecargas',
                                'towah',
                                'usa_epay',
                                'vindicia',
                                'virtual_card_services',
                                'vme',
                                'worldpay'
                            ],

                        },
                    },
                    was_authorized => {
                        type => '//any',
                        of   => [ '//nil', '//bool', '//int' ]
                    },
                    decline_code => '//str',
                },
            },
            shipping => {
                type     => '//rec',
                optional => {
                    first_name     => '//str',
                    last_name      => '//str',
                    company        => '//str',
                    address        => '//str',
                    address_2      => '//str',
                    city           => '//str',
                    delivery_speed => {
                        type     => '/maxmind/enum',
                        contents => {
                            type   => '//str',
                            values => [
                                'same_day',  'overnight',
                                'expedited', 'standard'
                            ],
                        },
                    },
                    region => {
                        type   => '//str',
                        length => { 'min' => 1, 'max' => 4 },
                    },
                    country => {
                        type   => '//str',
                        length => { 'min' => 2, 'max' => 2 },
                    },
                    postal             => '//str',
                    phone_number       => '//str',
                    phone_country_code => {
                        type   => '//str',
                        length => { 'min' => 1, 'max' => 4 },
                    },
                },
            },
            shopping_cart => {
                type     => '//arr',
                contents => {
                    type     => '//rec',
                    optional => {
                        category => '//str',
                        item_id  => '//str',
                        quantity => '//int',
                        price    => '//num',
                    }
                }
            },
        },
    };
}

sub validate_request {
    my ( $self, $request ) = @_;
    try {
        $self->_schema->assert_valid($request);
    }
    catch {
        my @error_strings
            = map { 'VALUE: ' . $_->value . ' caused ERROR: ' . $_->stringify }
            @{ $_->failures };
        my $all_error_strings = join "\n", @error_strings;
        die $all_error_strings;
    };
}

1;

# ABSTRACT: Validation for the minFraud requests

__END__

=head1 SYNOPSIS

    use WebService::MinFraud::Validator;
    my $validator = WebService::MinFraud::Validator->new;
    my $request = { device => { ip_address => '24.24.24.24' } };
    $validator->validate_request($request);

=head1 DESCRIPTION

This module defines the request schema for the minFraud API.  In addition, it
provides a C<validate_request> method that is used to validate any request
passed to the C<score> or C<insights> methods.

=head1 METHODS

=head2 validate_request

This method takes a minFraud request as a HashRef and validates it against
the minFraud request schema.

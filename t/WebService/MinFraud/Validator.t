use strict;
use warnings;

use JSON::MaybeXS;
use Test::Fatal;
use Test::More 0.88;
use WebService::MinFraud::Validator;

my $validator = WebService::MinFraud::Validator->new;
my $good_request = { device => { ip_address => '24.24.24.24' } };
ok( $validator->validate_request($good_request), 'good request validates' );
my $empty_request = {};
like(
    exception { $validator->validate_request($empty_request); },
    qr/no value given for required entry device/,
    'empty request throws an exception'
);

my $good_username = {
    device  => { ip_address   => '24.24.24.24' },
    account => { username_md5 => 'A' x 32 }
};
ok( $validator->validate_request($good_username), 'good username validates' );
my $bad_username_md5 = {
    device  => { ip_address   => '24.24.24.24' },
    account => { username_md5 => 'A' x 33 },
};
like(
    exception { $validator->validate_request($bad_username_md5); },
    qr/not a 32 digit hexadecimal/,
    'bad username_md5 throws an exception'
);

my $good_last_4_digits = {
    device      => { ip_address    => '24.24.24.24' },
    credit_card => { last_4_digits => '1' x 4 },
};
ok(
    $validator->validate_request($good_last_4_digits),
    'good last 4 digits validates'
);
my $bad_last_4_digits = {
    device      => { ip_address    => '24.24.24.24' },
    credit_card => { last_4_digits => '1' x 3 },
};
like(
    exception { $validator->validate_request($bad_last_4_digits); },
    qr/length of value is outside allowed range/,
    'bad last 4 digits throws an exception'
);

my $good_avs_result = {
    device      => { ip_address => '24.24.24.24' },
    credit_card => { avs_result => 'Y' },
};
ok(
    $validator->validate_request($good_avs_result),
    'good avs result validates'
);
my $bad_avs_result = {
    device      => { ip_address => '24.24.24.24' },
    credit_card => { avs_result => 'YY' },
};
like(
    exception { $validator->validate_request($bad_avs_result); },
    qr/length of value is outside allowed range/,
    'bad avs_result throws an exception'
);

my $good_cvv_result = {
    device      => { ip_address => '24.24.24.24' },
    credit_card => { cvv_result => 'N', avs_result => 'Y' },
};
ok(
    $validator->validate_request($good_cvv_result),
    'good cvv result validates'
);
my $bad_cvv_result = {
    device      => { ip_address => '24.24.24.24' },
    credit_card => { cvv_result => q{} },
};
like(
    exception { $validator->validate_request($bad_cvv_result); },
    qr/length of value is outside allowed range/,
    'bad cvv_result throws an exception'
);

my $good_email_domain = {
    device => { ip_address => '24.24.24.24' },
    email  => { domain     => 'zed.com' },
};
ok(
    $validator->validate_request($good_email_domain),
    'good email domain validates'
);
my $bad_email_domain = {
    device => { ip_address => '24.24.24.24' },
    email  => { domain     => '-X-.com' },
};
like(
    exception { $validator->validate_request($bad_email_domain); },
    qr/not a valid host name/,
    'bad email domain throws an exception'
);

my $good_event_time = {
    device => { ip_address => '24.24.24.24' },
    event  => { time       => '2015-10-10T12:00:00Z' },
};
ok(
    $validator->validate_request($good_event_time),
    'good event time validates'
);
my $bad_event_time = {
    device => { ip_address => '24.24.24.24' },
    event  => { time       => '2015-10-10 12:00:00' },
};
like(
    exception { $validator->validate_request($bad_event_time); },
    qr/ not a RFC3339/,
    'bad event time throws an exception'
);

my $good_event_type = {
    device => { ip_address => '24.24.24.24' },
    event => { type => 'purchase', time => '2015-10-10T12:00:00-07:00' },
};
ok(
    $validator->validate_request($good_event_type),
    'good event type validates'
);
my $bad_event_type = {
    device => { ip_address => '24.24.24.24' },
    event  => { type       => 'estudi' },
};
like(
    exception { $validator->validate_request($bad_event_type); },
    qr/matched none of the available alternative/,
    'bad event type throws an exception'
);

my $good_order_currency = {
    device => { ip_address => '24.24.24.24' },
    order  => { currency   => 'EUR' },
};
ok(
    $validator->validate_request($good_order_currency),
    'good order currency validates'
);
my $bad_order_currency = {
    device => { ip_address => '24.24.24.24' },
    order  => { currency   => '2015-10-10 12:00:00' },
};
like(
    exception { $validator->validate_request($bad_order_currency); },
    qr/length of value is outside allowed range/,
    'bad order currency throws an exception'
);

my $good_referrer = {
    device => { ip_address   => '24.24.24.24' },
    order  => { referrer_uri => 'http://whutsup.org' },
};
ok(
    $validator->validate_request($good_referrer),
    'good order referrer validates'
);
my $bad_referrer = {
    device => { ip_address   => '24.24.24.24' },
    order  => { referrer_uri => 'httpz://whutsup.metge' },
};
like(
    exception { $validator->validate_request($bad_referrer); },
    qr/Found value is not a valid Web URI/,
    'bad order referrer throws an exception'
);

my $good_payment_processor = {
    device  => { ip_address => '24.24.24.24' },
    payment => { processor  => 'redpagos' },
};
ok(
    $validator->validate_request($good_payment_processor),
    'good payment processor validates'
);
my $bad_payment_processor = {
    device  => { ip_address => '24.24.24.24' },
    payment => { processor  => '2015-10-10 12:00:00' },
};
like(
    exception { $validator->validate_request($bad_payment_processor); },
    qr/matched none of the available alternative/,
    'bad payment processor throws an exception'
);

my $good_delivery_speed = {
    device   => { ip_address     => '24.24.24.24' },
    shipping => { delivery_speed => 'same_day' },
};
ok(
    $validator->validate_request($good_delivery_speed),
    'good delivery speed validates'
);
my $bad_delivery_speed = {
    device   => { ip_address     => '24.24.24.24' },
    shipping => { delivery_speed => 'two_day' },
};
like(
    exception { $validator->validate_request($bad_delivery_speed); },
    qr/matched none of the available alternatives/,
    'bad delivery speed throws an exception'
);

my $good_shipping_country = {
    device   => { ip_address => '24.24.24.24' },
    shipping => { country    => 'AD' },
};
ok(
    $validator->validate_request($good_shipping_country),
    'good shipping country validates'
);
my $bad_shipping_country = {
    device   => { ip_address => '24.24.24.24' },
    shipping => { country    => 'USA' },
};
like(
    exception { $validator->validate_request($bad_shipping_country); },
    qr/length of value is outside allowed range/,
    'bad shipping country throws an exception'
);

my $false_boolean = {
    device  => { ip_address => '24.24.24.24' },
    payment => {
        decline_code   => 'invalid number',
        was_authorized => JSON()->false,
        processor      => 'stripe'
    },
};
ok(
    $validator->validate_request($false_boolean),
    'zero as a boolean validates'
);
my $true_boolean = {
    device  => { ip_address => '24.24.24.24' },
    payment => {
        decline_code   => 'invalid number',
        was_authorized => JSON()->true,
        processor      => 'stripe'
    },
};
ok(
    $validator->validate_request($true_boolean),
    'one as a boolean validates'
);
my $undef_boolean = {
    device  => { ip_address => '24.24.24.24' },
    payment => {
        decline_code   => 'invalid number',
        was_authorized => undef,
        processor      => 'stripe'
    },
};

like(
    exception { $validator->validate_request($undef_boolean) },
    qr/found value was not a bool/,
    'undef as a boolean does not validate'
);

done_testing;

use strict;
use warnings;

use Test::More 0.88;

use WebService::MinFraud::Record::CreditCard;

my $cc = WebService::MinFraud::Record::CreditCard->new(
    issuer => { name => 'Bank' },
    country                              => 'US',
    is_issued_in_billing_address_country => 1,
    is_prepaid                           => 1
);

is( $cc->issuer->name, 'Bank', 'credit card issuer name' );
is( $cc->country,      'US',   'credit card country' );
is( $cc->is_prepaid,   1,      'credit card is_prepaid' );
is(
    $cc->is_issued_in_billing_address_country, 1,
    'credit card issued in billing country'
);

done_testing;

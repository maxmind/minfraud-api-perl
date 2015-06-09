use strict;
use warnings;

use Test::More 0.88;

use WebService::MinFraud::Record::CreditCard;

my $cc = WebService::MinFraud::Record::CreditCard->new(
    issuer                               => { name => 'Bank' },
    country                              => 'US',
    is_issued_in_billing_address_country => 1,
    is_prepaid                           => 1
);

is( 'Bank', $cc->issuer->name, 'credit card issuer name' );
is( 'US',   $cc->country,      'credit card country' );
is( 1,      $cc->is_prepaid,   'credit card is_prepaid' );
is(
    1,
    $cc->is_issued_in_billing_address_country,
    'credit card issued in billing country'
);

done_testing();

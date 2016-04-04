use strict;
use warnings;

use Test::More 0.88;

use WebService::MinFraud::Record::CreditCard;

my $cc = WebService::MinFraud::Record::CreditCard->new(
    issuer                               => { name => 'Bank' },
    country                              => 'US',
    is_issued_in_billing_address_country => 1,
    is_prepaid                           => 1,
    brand                                => 'Visa',
    type                                 => 'credit',
);

is( $cc->issuer->name, 'Bank', 'credit card issuer name' );
is( $cc->country,      'US',   'credit card country' );
is( $cc->is_prepaid,   1,      'credit card is_prepaid' );
is(
    $cc->is_issued_in_billing_address_country, 1,
    'credit card issued in billing country'
);
is( $cc->brand, 'Visa',   'credit card brand' );
is( $cc->type,  'credit', 'credit card type' );

my $cc2 = WebService::MinFraud::Record::CreditCard->new(
    brand => 'Visa',
    type  => q{}
);
is( $cc2->type, q{}, 'credit card type empty' );

done_testing;

use strict;
use warnings;

use Test::Fatal qw( exception );
use Test::More;

use WebService::MinFraud::Types qw( SessionID );

ok( SessionID->('foo'),       'foo' );
ok( SessionID->( 'x' x 255 ), '255 chars' );
like(
    exception( sub { SessionID->( 'x' x 256 ) } ), qr{not a valid},
    '256 chars'
);

done_testing;

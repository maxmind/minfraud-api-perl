package WebService::MinFraud::Data::Rx::Type::Hex32;

use 5.010;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '1.007001';

use parent 'Data::Rx::CommonType::EasyNew';

use Role::Tiny::With;

with 'WebService::MinFraud::Role::Data::Rx::Type';

sub assert_valid {
    my ( $self, $value ) = @_;

    return 1 if $value && ( $value =~ m/^[0-9A-Fa-f]{32}$/ );

    $self->fail(
        {
            error   => [qw(type)],
            message => 'Found value is not a 32 digit hexadecimal number.',
            value   => $value,
        }
    );
}

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/hex32';
}

1;

# ABSTRACT: A type to check for a 32 digit hexadecimal

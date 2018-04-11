package WebService::MinFraud::Data::Rx::Type::CCToken;

use 5.010;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '1.007001';

use parent 'Data::Rx::CommonType::EasyNew';

use List::Util qw( all );
use Role::Tiny::With;

with 'WebService::MinFraud::Role::Data::Rx::Type';

sub assert_valid {
    my ( $self, $value ) = @_;

    return 1
        if $value
        && ( length($value) < 256 )
        && ( $value !~ m/^[0-9]{1,19}$/ )
        && ( $value =~ m/^[\x21-\x7E]+$/ );

    $self->fail(
        {
            error => [qw(type)],
            message =>
                'Found value is not considered a valid credit card token.',
            value => $value,
        }
    );
}

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/cctoken';
}

1;

# ABSTRACT: A type to check for what MaxMind considers a valid credit card token

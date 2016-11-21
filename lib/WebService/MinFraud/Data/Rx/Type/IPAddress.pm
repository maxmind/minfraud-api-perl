package WebService::MinFraud::Data::Rx::Type::IPAddress;

use 5.010;

use strict;
use warnings;

our $VERSION = '1.003001';

use Data::Validate::IP;

use parent 'Data::Rx::CommonType::EasyNew';

use Role::Tiny::With;

with 'WebService::MinFraud::Role::Data::Rx::Type';

sub assert_valid {
    my ( $self, $value ) = @_;

    return 1
        if $value
        && ( Data::Validate::IP::is_ipv4($value)
        || Data::Validate::IP::is_ipv6($value) );

    $self->fail(
        {
            error => [qw(type)],
            message =>
                'Found value is not an IP address, neither version 4 nor 6.',
            value => $value,
        }
    );
}

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/ip';
}

1;

# ABSTRACT: A type to check for a valid IP address, version 4 or 6

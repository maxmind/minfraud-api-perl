package WebService::MinFraud::Data::Rx::Type::WebURI;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.003000';

use Data::Validate::URI qw(is_web_uri);

use parent 'Data::Rx::CommonType::EasyNew';

use Role::Tiny::With;

with 'WebService::MinFraud::Role::Data::Rx::Type';

sub assert_valid {
    my ( $self, $value ) = @_;

    my @labels = split /\./, $value;
    return 1
        if $value
        && is_web_uri($value);

    $self->fail(
        {
            error   => [qw(type)],
            message => 'Found value is not a valid Web URI.',
            value   => $value,
        }
    );
}

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/weburi';
}

1;

# ABSTRACT: A type to check for a valid Web URI

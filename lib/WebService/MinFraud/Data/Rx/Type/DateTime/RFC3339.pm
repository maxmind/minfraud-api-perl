package WebService::MinFraud::Data::Rx::Type::DateTime::RFC3339;

use 5.010;

use strict;
use warnings;

our $VERSION = '1.000000';

use Carp ();
use DateTime::Format::RFC3339;

use parent 'Data::Rx::CommonType::EasyNew';

sub assert_valid {
    my ( $self, $value ) = @_;

    return 1 if $value && eval { $self->{dt}->parse_datetime($value); };

    $self->fail(
        {
            error   => [qw(type)],
            message => 'Found value is not a RFC3339 datetime',
            value   => $value,
        }
    );
}

sub guts_from_arg {
    my ( $class, $arg, $rx ) = @_;
    $arg ||= {};

    if ( my @unexpected = keys %$arg ) {
        Carp::croak sprintf 'Unknown arguments %s in constructing %s',
            ( join ',' => @unexpected ), $class->type_uri;
    }

    return { dt => DateTime::Format::RFC3339->new, };
}

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/datetime/rfc3339';
}

1;

# ABSTRACT: A type to check if a string parses as a RFC3339 datetime

package WebService::MinFraud::Data::Rx::Type::Enum;

use 5.010;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '1.004001';

use parent 'Data::Rx::CommonType::EasyNew';

sub assert_valid {
    my ( $self, $value ) = @_;

    $self->{schema}->assert_valid($value);
}

sub guts_from_arg {
    my ( undef, $arg, $rx ) = @_;

    my $meta = $rx->make_schema(
        {
            type     => '//rec',
            required => {
                contents => {
                    type     => '//rec',
                    required => {
                        type => '//str', # e.g. //int or //str. Really we only
                             # want schemas that have a 'value' option
                        values => {
                            type     => '//arr',
                            contents => '//def',

                            # should be of type, as above, but we can't test this,
                            # so we accept any defined value for now, and then test
                            # the values below
                        },
                    },
                },
            },
        }
    );

    $meta->assert_valid($arg);

    my $type   = $arg->{contents}{type};
    my @values = @{ $arg->{contents}{values} };

    # subsequent test that the provided values are acceptable
    $rx->make_schema( { type => '//arr', contents => $type } )
        ->assert_valid( \@values );

    my $schema = $rx->make_schema(
        {
            type => '//any',
            of   => [ map { { type => $type, value => $_ } } @values, ]
        }
    );

    return { schema => $schema, };
}

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/enum';
}

1;

# ABSTRACT: A type that defines an enumeration

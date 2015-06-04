package WebService::MinFraud::Data::Rx::Type::Enum;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use parent 'Data::Rx::CommonType::EasyNew';

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/enum';
}

sub guts_from_arg {
    my ( $class, $arg, $rx ) = @_;

    my $meta = $rx->make_schema(
        {
            type     => '//rec',
            required => {
                contents => {
                    type     => '//rec',
                    required => {
                        type =>
                            '//str', # e.g. //int or //str.  Really we only
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

sub assert_valid {
    my ( $self, $value ) = @_;

    $self->{schema}->assert_valid($value);
}

1;
__END__

=head1 SYNOPSIS

NEED ONE

=head1 DESCRIPTION

A type that defines an enumeration

=head1 METHODS

=head2 assert_valid

=head2 guts_from_arg

=head2 type_uri

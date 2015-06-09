package WebService::MinFraud::Data::Rx::Type::Hex32;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use Carp ();

use parent 'Data::Rx::CommonType::EasyNew';

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/hex32';
}

sub guts_from_arg {
    my ( $class, $arg, $rx ) = @_;
    $arg ||= {};

    if ( my @unexpected = keys %$arg ) {
        Carp::croak sprintf 'Unknown arguments %s in constructing %s',
            ( join ',' => @unexpected ), $class->type_uri;
    }

    return {};
}

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

1;
__END__

=head1 SYNOPSIS

NEED ONE

=head1 DESCRIPTION

A type to check for a 32 digit hexadecimal.

=head1 METHODS

=head2 assert_valid

=head2 guts_from_arg

=head2 type_uri

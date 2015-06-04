package WebService::MinFraud::Data::Rx::Type::Hostname;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use Carp ();
use List::Util qw( all );

use parent 'Data::Rx::CommonType::EasyNew';

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/hostname';
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

    my @labels = split /\./, $value;
    return 1
        if $value
        && ( length($value) < 256
        && ( all { $_ =~ m/^(?!-)[A-Z\d-]{1,63}(?<!-)$/i } @labels ) );

    $self->fail(
        {
            error   => [qw(type)],
            message => 'Found value is not a valid host name.',
            value   => $value,
        }
    );
}

1;
__END__

=head1 SYNOPSIS

NEED ONE

=head1 DESCRIPTION

A type to check if a value is a valid host name

=head1 METHODS

=head2 assert_valid

=head2 guts_from_arg

=head2 type_uri

package WebService::MinFraud::Data::Rx::Type::IPAddress;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use Carp ();
use Data::Validate::IP;

use parent 'Data::Rx::CommonType::EasyNew';

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/ip';
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

    return 1
        if $value
        && ( Data::Validate::IP::is_ipv4($value)
        || Data::Validate::IP::is_ipv6($value) );

    $self->fail(
        {
            error => [qw(type)],
            message =>
                'Found value is not an IP addres, neither version 4 nor 6.',
            value => $value,
        }
    );
}

1;
__END__

=head1 SYNOPSIS

NEED ONE

=head1 DESCRIPTION

A type to check for a valid IP address, version 4 or 6.

=head1 METHODS

=head2 assert_valid

=head2 guts_from_arg

=head2 type_uri

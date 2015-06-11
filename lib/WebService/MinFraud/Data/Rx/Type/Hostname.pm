package WebService::MinFraud::Data::Rx::Type::Hostname;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use Carp ();
use List::Util qw( all );
use Data::Validate::Domain qw( is_domain );

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

    return 1
        if is_domain($value);

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

    email => {
        type     => '//rec',
        optional => {
            address => '//str',
            domain  => '/maxmind/hostname',
        }
    }

=head1 DESCRIPTION

A type to check for a valid host name

=head1 METHODS

These methods are specific to L<Data::Rx>.

=head2 assert_valid

=head2 guts_from_arg

=head2 type_uri

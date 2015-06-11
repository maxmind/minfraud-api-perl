package WebService::MinFraud::Data::Rx::Type::DateTime::RFC3339;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use Carp ();
use DateTime::Format::RFC3339;

use parent 'Data::Rx::CommonType::EasyNew';

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/datetime/rfc3339';
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

1;
__END__

=head1 SYNOPSIS

    event => {
        type     => '//rec',
        optional => {
             time           => '/maxmind/datetime/rfc3339',
        }
    }

=head1 DESCRIPTION

A type to check if a string parses as a RFC3339 datetime

=head1 METHODS

These methods are specific to L<Data::Rx>.

=head2 assert_valid

=head2 guts_from_arg

=head2 type_uri

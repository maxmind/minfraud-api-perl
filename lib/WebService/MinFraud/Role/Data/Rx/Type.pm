package WebService::MinFraud::Role::Data::Rx::Type;

use strict;
use warnings;
use Role::Tiny;
use namespace::autoclean;

our $VERSION = '1.005001';

use Carp ();

requires 'type_uri';

sub guts_from_arg {
    my ( $class, $arg ) = @_;
    $arg ||= {};

    if ( my @unexpected = keys %$arg ) {
        Carp::croak sprintf 'Unknown arguments %s in constructing %s',
            ( join ',' => @unexpected ), $class->type_uri;
    }

    return {};
}

1;

# ABSTRACT: A role that helps build Data::Rx Types

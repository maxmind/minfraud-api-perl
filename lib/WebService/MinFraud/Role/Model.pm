package WebService::MinFraud::Role::Model;

use strict;
use warnings;

our $VERSION = '0.001001';

use WebService::MinFraud::Types qw( HashRef );

use Moo::Role;

has raw => (
    is       => 'ro',
    isa      => HashRef,
    required => 1,
);

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $p = $self->$orig(@_);
    delete $p->{raw};

    # We make a copy to avoid a circular reference
    $p->{raw} = { %{$p} };

    return $p;
};

1;

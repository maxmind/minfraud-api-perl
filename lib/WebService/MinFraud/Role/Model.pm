package WebService::MinFraud::Role::Model;

use Moo::Role;

our $VERSION = '0.002001';

use Types::Standard qw( HashRef );

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

# ABSTRACT: A role for storing there original response in the raw attribute

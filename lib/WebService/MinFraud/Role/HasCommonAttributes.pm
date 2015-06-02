package WebService::MinFraud::Role::HasCommonAttributes;

use strict;
use warnings;

our $VERSION = '0.001001';

use Types::Standard qw( ArrayRef InstanceOf Num Str );
use WebService::MinFraud::Types qw( NonNegativeInt );

use Moo::Role;

requires 'raw';

has id => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
    builder  => sub { my $self = shift; $self->raw->{id} },
);

has risk_score => (
    is       => 'lazy',
    isa      => Num,
    init_arg => undef,
    builder  => sub { my $self = shift; $self->raw->{risk_score} },
);

has credits_remaining => (
    is       => 'lazy',
    isa      => NonNegativeInt,
    init_arg => undef,
    builder  => sub { my $self = shift; $self->raw->{credits_remaining} },
);

has warnings => (
    is  => 'lazy',
    isa => ArrayRef [ InstanceOf ['WebService::MinFraud::Record::Warning'] ],
    init_arg => undef,
    builder  => sub {
        [ map { WebService::MinFraud::Record::Warning->new($_) }
                @{ $_[0]->raw->{warnings} } ];
    },
);

1;

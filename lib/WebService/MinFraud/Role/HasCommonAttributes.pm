package WebService::MinFraud::Role::HasCommonAttributes;

use Moo::Role;

our $VERSION = '0.002001';

use Types::Standard qw( ArrayRef InstanceOf Num Str );
use Types::UUID;
use WebService::MinFraud::Record::Warning;
use WebService::MinFraud::Types qw( NonNegativeInt );

requires 'raw';

has id => (
    is        => 'lazy',
    isa       => Uuid,
    init_arg  => undef,
    builder   => sub { $_[0]->raw->{id} },
    predicate => 1,
);

has risk_score => (
    is        => 'lazy',
    isa       => Num,
    init_arg  => undef,
    builder   => sub { $_[0]->raw->{risk_score} },
    predicate => 1,
);

has credits_remaining => (
    is        => 'lazy',
    isa       => NonNegativeInt,
    init_arg  => undef,
    builder   => sub { $_[0]->raw->{credits_remaining} },
    predicate => 1,
);

has warnings => (
    is  => 'lazy',
    isa => ArrayRef [ InstanceOf ['WebService::MinFraud::Record::Warning'] ],
    init_arg => undef,
    builder  => sub {
        [ map { WebService::MinFraud::Record::Warning->new($_) }
                @{ $_[0]->raw->{warnings} } ];
    },
    predicate => 1,
);

1;

# ABSTRACT: A role for attributes common to both the Insights and Score models

package WebService::MinFraud::Role::HasCommonAttributes;

use Moo::Role;
use namespace::autoclean;

our $VERSION = '1.010000';

use Types::Standard qw( ArrayRef InstanceOf Num Str );
use Types::UUID;
use WebService::MinFraud::Record::Warning;
use WebService::MinFraud::Types qw( NonNegativeInt NonNegativeNum );

requires 'raw';

has funds_remaining => (
    is        => 'lazy',
    isa       => NonNegativeNum,
    init_arg  => undef,
    builder   => sub { $_[0]->raw->{funds_remaining} },
    predicate => 1,
);

has id => (
    is        => 'lazy',
    isa       => Uuid,
    init_arg  => undef,
    builder   => sub { $_[0]->raw->{id} },
    predicate => 1,
);

has queries_remaining => (
    is        => 'lazy',
    isa       => NonNegativeInt,
    init_arg  => undef,
    builder   => sub { $_[0]->raw->{queries_remaining} },
    predicate => 1,
);

has risk_score => (
    is        => 'lazy',
    isa       => Num,
    init_arg  => undef,
    builder   => sub { $_[0]->raw->{risk_score} },
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

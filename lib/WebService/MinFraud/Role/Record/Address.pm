package WebService::MinFraud::Role::Record::Address;

use Moo::Role;

our $VERSION = '0.001001';

use WebService::MinFraud::Types qw( Bool BoolCoercion Num);

has distance_to_ip_location => (
    is        => 'ro',
    isa       => Num,
    predicate => 1,
);

has is_in_ip_country => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
    coerce  => BoolCoercion,
);

has is_postal_in_city => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
    coerce  => BoolCoercion,
);

has latitude => (
    is        => 'ro',
    isa       => Num,
    predicate => 1,
);

has longitude => (
    is        => 'ro',
    isa       => Num,
    predicate => 1,
);

1;

# ABSTRACT: This is an address role that shipping and billing will consume

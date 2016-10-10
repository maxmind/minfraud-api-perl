package WebService::MinFraud::Role::Record::HasRisk;

use Moo::Role;

our $VERSION = '1.001000';

use Types::Standard qw( Num );

has risk => (
    is        => 'ro',
    isa       => Num,
    predicate => 1,
);

1;

# ABSTRACT: A role to add a risk attribute

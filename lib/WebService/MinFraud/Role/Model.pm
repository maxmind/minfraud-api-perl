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

1;

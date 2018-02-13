package WebService::MinFraud::Role::HasLocales;

use Moo::Role;
use namespace::autoclean;

our $VERSION = '1.007000';

use Sub::Quote qw( quote_sub );
use WebService::MinFraud::Types qw( LocalesArrayRef );

has locales => (
    is        => 'ro',
    isa       => LocalesArrayRef,
    default   => quote_sub(q{ ['en'] }),
    predicate => 1,
);

1;

# ABSTRACT: A role for (language) locales

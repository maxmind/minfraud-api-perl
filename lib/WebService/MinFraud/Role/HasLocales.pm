package WebService::MinFraud::Role::HasLocales;

use Moo::Role;

our $VERSION = '0.004001';

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

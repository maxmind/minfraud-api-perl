package WebService::MinFraud::Role::HasLocales;

use strict;
use warnings;

our $VERSION = '0.001001';

use WebService::MinFraud::Types qw( LocalesArrayRef );
use Sub::Quote qw( quote_sub );

use Moo::Role;

has locales => (
    is      => 'ro',
    isa     => LocalesArrayRef,
    default => quote_sub(q{ ['en'] }),
);

1;

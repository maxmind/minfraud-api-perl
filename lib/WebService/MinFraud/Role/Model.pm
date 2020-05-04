package WebService::MinFraud::Role::Model;

use Moo::Role;
use namespace::autoclean;

our $VERSION = '1.010001';

use Sub::Quote qw( quote_sub );
use Types::Standard qw( HashRef );

requires '_has';

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

## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
sub _define_model_attributes {
    my $class  = shift;
    my %models = @_;

    my $has = $class->can('_has');

    for my $key ( keys %models ) {
        my $record_class = "WebService::MinFraud::Record::$models{$key}";

        my $raw_attr = '_raw_' . $key;

        $has->(
            $raw_attr => (
                is       => 'ro',
                isa      => HashRef,
                init_arg => $key,
                default  => quote_sub(q{ {} }),
            ),
        );

        ## no critic (ProhibitCallsToUnexportedSubs, RequireExplicitInclusion)
        $has->(
            $key => (
                is  => 'ro',
                isa => quote_sub(
                    sprintf(
                        q{ WebService::MinFraud::Types::object_isa_type( $_[0], %s ) },
                        B::perlstring($record_class)
                    )
                ),
                init_arg => undef,
                lazy     => 1,
                default  => quote_sub(
                    sprintf(
                        q{ $_[0]->_build_record( %s, %s ) },
                        map { B::perlstring($_) } $record_class, $raw_attr
                    )
                ),
            ),
        );
    }
}
## use critic

sub _build_record {
    my $self         = shift;
    my $record_class = shift;
    my $method       = shift;

    my $raw = $self->$method;

    return $record_class->new( %{$raw}, locales => $self->locales );
}

1;

# ABSTRACT: A role for storing there original response in the raw attribute

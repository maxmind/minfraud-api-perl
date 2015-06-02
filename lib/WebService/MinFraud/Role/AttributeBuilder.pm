package WebService::MinFraud::Role::AttributeBuilder;

use strict;
use warnings;

our $VERSION = '0.001001';

use B;
use Sub::Quote qw( quote_sub );
use Types::Standard qw( ArrayRef HashRef InstanceOf Num Str );
use WebService::MinFraud::Record::BillingAddress;
use WebService::MinFraud::Record::CreditCard;
use WebService::MinFraud::Record::IPLocation;
use WebService::MinFraud::Record::Issuer;
use WebService::MinFraud::Record::ShippingAddress;
use WebService::MinFraud::Record::Warning;
use WebService::MinFraud::Types qw( NonNegativeInt );

use Moo::Role;

with 'WebService::MinFraud::Role::Model',
    'WebService::MinFraud::Role::HasLocales';

requires '_all_record_names';

sub _define_attributes_for_keys {
    my $class = shift;
    my @keys  = @_;

    my $has = $class->can('has');

    for my $key (@keys) {
        my $record_class = __PACKAGE__->_record_class_for_key($key);

        my $raw_attr = '_raw_' . $key;

        $has->(
            $raw_attr => (
                is       => 'ro',
                isa      => HashRef,
                init_arg => $key,
                default  => quote_sub(q{ {} }),
            ),
        );

        ## no critic (Subroutines::ProhibitCallsToUnexportedSubs)
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
                        map { B::perlstring($_) } $key, $raw_attr
                    )
                ),
            ),
        );
        ## use critic
    }
}

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $p = $self->$orig(@_);
    delete $p->{raw};

    # We make a copy to avoid a circular reference
    $p->{raw} = { %{$p} };

    return $p;
};

sub _build_record {
    my $self   = shift;
    my $key    = shift;
    my $method = shift;

    my $raw = $self->$method();

    return $self->_record_class_for_key($key)
        ->new( %{$raw}, locales => $self->locales() );
}

{
    my %key_to_class = (
        billing_address  => 'BillingAddress',
        credit_card      => 'CreditCard',
        ip_location      => 'IPLocation',
        maxmind          => 'MaxMind',
        shipping_address => 'ShippingAddress',
    );

    sub _record_class_for_key {
        my $self = shift;
        my $key  = shift;

        return 'WebService::MinFraud::Record::'
            . ( $key_to_class{$key} || ucfirst $key );
    }
}

has id => (
    is       => 'lazy',
    isa      => Str,
    init_arg => undef,
    builder  => sub { my $self = shift; $self->{raw}->{id} },
);

has risk_score => (
    is       => 'lazy',
    isa      => Num,
    init_arg => undef,
    builder  => sub { my $self = shift; $self->{raw}->{risk_score} },
);

has credits_remaining => (
    is       => 'lazy',
    isa      => NonNegativeInt,
    init_arg => undef,
    builder  => sub { my $self = shift; $self->{raw}->{credits_remaining} },
);

has warnings => (
    is  => 'lazy',
    isa => ArrayRef [ InstanceOf ['WebService::MinFraud::Record::Warning'] ],
    init_arg => undef,
    builder  => sub {
        [ map { WebService::MinFraud::Record::Warning->new($_) }
                @{ $_[0]->{raw}->{warnings} } ];
    },
);

1;

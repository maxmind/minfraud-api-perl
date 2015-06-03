package WebService::MinFraud::Role::AttributeBuilder;

use strict;
use warnings;

our $VERSION = '0.001001';

use B;
use Sub::Quote qw( quote_sub );
use WebService::MinFraud::Record::BillingAddress;
use WebService::MinFraud::Record::CreditCard;
use WebService::MinFraud::Record::IPLocation;
use WebService::MinFraud::Record::Issuer;
use WebService::MinFraud::Record::ShippingAddress;
use WebService::MinFraud::Record::Warning;
use WebService::MinFraud::Types qw( HashRef );

use Moo::Role;

with 'WebService::MinFraud::Role::Model',
    'WebService::MinFraud::Role::HasLocales',
    'WebService::MinFraud::Role::HasCommonAttributes';

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

1;

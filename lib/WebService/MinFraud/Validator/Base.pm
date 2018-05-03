package WebService::MinFraud::Validator::Base;

use Moo;
use namespace::autoclean;

our $VERSION = '1.007001';

use Carp;
use Data::Rx;
use Types::Standard qw( HashRef InstanceOf Object );

has _request_schema_definition => (
    is      => 'lazy',
    isa     => HashRef,
    builder => '_build_request_schema_definition',
);

has _rx => (
    is      => 'lazy',
    isa     => InstanceOf ['Data::Rx'],
    builder => '_build_rx_plugins',
);

has _schema => (
    is      => 'lazy',
    isa     => Object,
    builder => sub {
        my $self = shift;
        $self->_rx->make_schema( $self->_request_schema_definition );
    },
    handles => {
        assert_valid => 'assert_valid',
    },
);

sub _build_request_schema_definition {
    croak 'Abstract Base Class. This method is implemented in subclasses';
}

sub _build_rx_plugins {
    croak 'Abstract Base Class. This method is implemented in subclasses';

}

1;

# ABSTRACT: Abstract Base Validation for the minFraud requests

__END__

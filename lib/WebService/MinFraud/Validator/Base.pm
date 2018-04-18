package WebService::MinFraud::Validator::Base;

use Moo;
use namespace::autoclean;

our $VERSION = '1.007001';

use Data::Delete 0.05;
use Carp;
use Data::Rx;
use Try::Tiny;
use Types::Standard qw( HashRef InstanceOf Object );
use WebService::MinFraud::Data::Rx::Type::CCToken;
use WebService::MinFraud::Data::Rx::Type::CustomInputs;
use WebService::MinFraud::Data::Rx::Type::DateTime::RFC3339;
use WebService::MinFraud::Data::Rx::Type::Enum;
use WebService::MinFraud::Data::Rx::Type::Hex32;
use WebService::MinFraud::Data::Rx::Type::Hostname;
use WebService::MinFraud::Data::Rx::Type::IPAddress;
use WebService::MinFraud::Data::Rx::Type::WebURI;

has _request_schema_definition => (
    is      => 'lazy',
    isa     => HashRef,
    builder => '_build_request_schema_definition',
);

has _rx => (
    is      => 'lazy',
    isa     => InstanceOf ['Data::Rx'],
    builder => sub {
        Data::Rx->new(
            {
                prefix => {
                    maxmind => 'tag:maxmind.com,MAXMIND:rx/',
                },
                type_plugins => [
                    qw(
                        WebService::MinFraud::Data::Rx::Type::CCToken
                        WebService::MinFraud::Data::Rx::Type::CustomInputs
                        WebService::MinFraud::Data::Rx::Type::DateTime::RFC3339
                        WebService::MinFraud::Data::Rx::Type::Enum
                        WebService::MinFraud::Data::Rx::Type::Hex32
                        WebService::MinFraud::Data::Rx::Type::Hostname
                        WebService::MinFraud::Data::Rx::Type::IPAddress
                        WebService::MinFraud::Data::Rx::Type::WebURI
                        )
                ],
            },
        );
    },
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

1;

# ABSTRACT: Validation for the minFraud requests

__END__

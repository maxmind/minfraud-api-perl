package WebService::MinFraud::Role::Error::HTTP;

use Moo::Role;
use namespace::autoclean;

our $VERSION = '1.008000';

use WebService::MinFraud::Types qw( HTTPStatus URIObject );

has http_status => (
    is       => 'ro',
    isa      => HTTPStatus,
    required => 1,
);

has uri => (
    is       => 'ro',
    isa      => URIObject,
    required => 1,
);

1;

# ABSTRACT: An HTTP Error role

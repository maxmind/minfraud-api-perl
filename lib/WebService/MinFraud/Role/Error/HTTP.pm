package WebService::MinFraud::Role::Error::HTTP;

use strict;
use warnings;

our $VERSION = '0.001001';

use WebService::MinFraud::Types qw( HTTPStatus Str URIObject );

use Moo::Role;

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

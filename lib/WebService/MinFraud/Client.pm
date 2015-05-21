package WebService::MinFraud::Client;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use WebService::MinFraud::Error::HTTP;
use WebService::MinFraud::Error::IPAddressNotFound;
use WebService::MinFraud::Error::WebService;
use WebService::MinFraud::Types
    qw( JSONObject MaxMindID MaxMindLicenseKey Str URIObject UserAgentObject );
use JSON;
use LWP::UserAgent;
use Params::Validate qw( validate );
use Scalar::Util qw( blessed );
use Sub::Quote qw( quote_sub );
use Try::Tiny;
use WebService::MinFraud::Model::Insights;
use WebService::MinFraud::Model::Score;

use Moo;

with 'GeoIP2::Role::HasLocales';

has _base_uri => (
    is      => 'lazy',
    isa     => URIObject,
    builder => sub {
        my $self = shift;
        URI->new(
            $self->uri_scheme . '://' . $self->host() . '/minfraud/v2.0' );
    },
);
has host => (
    is      => 'ro',
    isa     => Str,
    default => quote_sub(q{ 'minfraud.maxmind.com' }),
);
has _json => (
    is       => 'ro',
    isa      => JSONObject,
    init_arg => undef,
    default  => quote_sub(q{ JSON->new()->utf8() }),
);
has license_key => (
    is       => 'ro',
    isa      => MaxMindLicenseKey,
    required => 1,
);

#has locales => (
#    is      => 'ro',
#    isa     => Str,
#    default => quote_sub(q{ 'en' }),
#);
has timeout => (
    is      => 'ro',
    isa     => Str,
    default => quote_sub(q{ q{} }),
);
has ua => (
    is      => 'lazy',
    isa     => UserAgentObject,
    builder => sub { LWP::UserAgent->new },
);
has uri_scheme => (
    is      => 'ro',
    isa     => Str,
    default => quote_sub(q{ 'https' }),
);
has user_id => (
    is       => 'ro',
    isa      => MaxMindID,
    required => 1,
);

sub insights {
    my $self = shift;

    return $self->_response_for(
        'insights',
        'WebService::MinFraud::Model::Insights',
        @_,
    );
}

sub score {
    my $self = shift;

    return $self->_response_for(
        'score',
        'WebService::MinFraud::Model::Score',
        @_,
    );
}

my %spec = (
    account => {
        callbacks => {
            'is a shipping address' => sub { 1 }
        }
    },
    billing => {
        callbacks => {
            'is a shipping address' => sub { 1 }
        }
    },
    credit_card => {
        callbacks => {
            'is a shipping address' => sub { 1 }
        }
    },
    device => {
        callbacks => {
            'is a shipping address' => sub { 1 }
        }
    },
    email => {
        callbacks => {
            'is a shipping address' => sub { 1 }
        }
    },
    event => {
        callbacks => {
            'is a shipping address' => sub { 1 }
        }
    },

    #    ip => {
    #        callbacks => {
    #            'is a public IP address or me' => sub {
    #                return defined $_[0]
    #                    && ( $_[0] eq 'me'
    #                    || is_public_ipv4( $_[0] )
    #                    || is_public_ipv6( $_[0] ) );
    #            }
    #        },
    #    },
    order => {
        callbacks => {
            'is a shipping address' => sub { 1 }
        }
    },
    payment => {
        callbacks => {
            'is a shipping address' => sub { 1 }
        }
    },
    shipping => {
        callbacks => {
            'is a shipping address' => sub { 1 }
        }
    },
    shopping_cart => {
        callbacks => {
            'is a shipping address' => sub { 1 }
        }
    },
);

sub _response_for {
    my $self        = shift;
    my $path        = shift;
    my $model_class = shift;

    my %content = validate( @_, \%spec );
    my $uri = $self->_base_uri()->clone();
    $uri->path_segments( $uri->path_segments(), $path );
    my $request = HTTP::Request->new(
        'POST',
        $uri,
        HTTP::Headers->new( Accept => 'application/json' ),
        $self->_json->encode( \%content )
    );

    $request->authorization_basic( $self->user_id(), $self->license_key() );

    my $response = $self->ua()->request($request);

    if ( $response->code() == 200 ) {
        my $body = $self->_handle_success( $response, $uri );
        require Data::Dumper;
        warn Dumper $body;
        return $model_class->new(
            %{$body},
            locales => $self->locales(),
        );
    }
    else {
        # all other error codes throw an exception
        $self->_handle_error_status(
            $response, $uri,
            $content{device}{ip_address}
        );
    }
}

sub _handle_success {
    my $self     = shift;
    my $response = shift;
    my $uri      = shift;

    my $body;
    try {
        $body = $self->_json()->decode( $response->decoded_content() );
    }
    catch {
        WebService::MinFraud::Error::Generic->throw(
            message =>
                "Received a 200 response for $uri but could not decode the response as JSON: $_",
        );
    };

    return $body;
}

sub _handle_error_status {
    my $self     = shift;
    my $response = shift;
    my $uri      = shift;
    my $ip       = shift;

    my $status = $response->code();

    if ( $status =~ /^4/ ) {
        $self->_handle_4xx_status( $response, $status, $uri, $ip );
    }
    elsif ( $status =~ /^5/ ) {
        $self->_handle_5xx_status( $response, $status, $uri );
    }
    else {
        $self->_handle_non_200_status( $response, $status, $uri );
    }
}

sub _handle_4xx_status {
    my $self     = shift;
    my $response = shift;
    my $status   = shift;
    my $uri      = shift;
    my $ip       = shift;

    if ( $status == 404 ) {
        WebService::MinFraud::Error::IPAddressNotFound->throw(
            message    => "No record found for IP address $ip",
            ip_address => $ip,
        );
    }

    my $content = $response->decoded_content();

    my $body = {};

    if ( defined $content && length $content ) {
        if ( $response->content_type() =~ /json/ ) {
            try {
                $body = $self->_json()->decode($content);
                WebService::MinFraud::Error::Generic->throw( message =>
                        'Response contains JSON but it does not specify code or error keys'
                ) unless $body->{code} && $body->{error};
            }
            catch {
                WebService::MinFraud::Error::HTTP->throw(
                    message =>
                        "Received a $status error for $uri but it did not include the expected JSON body: $_",
                    http_status => $status,
                    uri         => $uri,
                );
            };
        }
        else {
            WebService::MinFraud::Error::HTTP->throw(
                message =>
                    "Received a $status error for $uri with the following body: $content",
                http_status => $status,
                uri         => $uri,
            );
        }
    }
    else {
        WebService::MinFraud::Error::HTTP->throw(
            message     => "Received a $status error for $uri with no body",
            http_status => $status,
            uri         => $uri,
        );
    }

    WebService::MinFraud::Error::WebService->throw(
        message => delete $body->{error},
        %{$body},
        http_status => $status,
        uri         => $uri,
    );
}

sub _handle_5xx_status {
    my $self     = shift;
    my $response = shift;
    my $status   = shift;
    my $uri      = shift;

    WebService::MinFraud::Error::HTTP->throw(
        message     => "Received a server error ($status) for $uri",
        http_status => $status,
        uri         => $uri,
    );
}

sub _handle_non_200_status {
    my $self     = shift;
    my $response = shift;
    my $status   = shift;
    my $uri      = shift;

    WebService::MinFraud::Error::HTTP->throw(
        message =>
            "Received a very surprising HTTP status ($status) for $uri",
        http_status => $status,
        uri         => $uri,
    );
}

sub _build_base_uri {
    my $self = shift;

    return URI->new(
        $self->uri_scheme . '://' . $self->host() . '/minfraud/v2.0' );
}

1;

__END__
import requests
from requests.utils import default_user_agent
from voluptuous import MultipleInvalid

import minfraud
from minfraud.errors import MinFraudError, HTTPError, AddressNotFoundError, \
    AuthenticationError, InsufficientFundsError, InvalidRequestError
from minfraud.models import Insights, Score
from minfraud.validation import validate_transaction


class Client(object):
    def __init__(self, user_id, license_key,
                 host='minfraud.maxmind.com',
                 locales=None,
                 timeout=None):
        # pylint: disable=too-many-arguments
        if locales is None:
            locales = ['en']
        self._locales = locales
        self._user_id = user_id
        self._license_key = license_key
        self._base_uri = u'https://{0:s}/minfraud/v2.0'.format(host)
        self._timeout = timeout

    def insights(self, transaction, validate=True):
        return self._response_for('insights', Insights, transaction, validate)

    def score(self, transaction, validate=True):
        return self._response_for('score', Score, transaction, validate)

    def _response_for(self, path, model_class, request, validate):
        if validate:
            try:
                validate_transaction(request)
            except MultipleInvalid as e:
                raise InvalidRequestError(
                    "Invalid transaction data: {0}".format(e))
        uri = '/'.join([self._base_uri, path])
        response = requests.post(
            uri,
            json=request,
            auth=(self._user_id, self._license_key),
            headers={'Accept': 'application/json',
                     'User-Agent': self._user_agent()},
            timeout=self._timeout)
        if response.status_code == 200:
            return self._handle_success(response, uri, model_class)
        else:
            self._handle_error(response, uri)

    def _user_agent(self):
        return 'minFraud-API/%s %s' % (minfraud.__version__,
                                       default_user_agent())

    def _handle_success(self, response, uri, model_class):
        try:
            body = response.json()
        except ValueError as ex:
            raise MinFraudError('Received a 200 response'
                                ' but could not decode the response as '
                                'JSON: {0}'.format(response.content), 200, uri)
        if 'ip_location' in body:
            body['locales'] = self._locales
        return model_class(body)

    def _handle_error(self, response, uri):
        status = response.status_code

        if 400 <= status < 500:
            self._handle_4xx_status(response, status, uri)
        elif 500 <= status < 600:
            self._handle_5xx_status(status, uri)
        else:
            self._handle_non_200_status(status, uri)

    def _handle_4xx_status(self, response, status, uri):
        if not response.content:
            raise HTTPError('Received a {0} error with no body'.format(status),
                            status, uri)
        elif response.headers.get('Content-Type', '').find('json') == -1:
            raise HTTPError('Received a {0} with the following '
                            'body: {1}'.format(status, response.content),
                            status, uri)
        try:
            body = response.json()
        except ValueError as ex:
            raise HTTPError(
                'Received a {status:d} error but it did not include'
                ' the expected JSON body: {content}'
                .format(status=status,
                        uri=uri,
                        content=response.content), status, uri)
        else:
            if 'code' in body and 'error' in body:
                self._handle_web_service_error(body.get('error'),
                                               body.get('code'), status, uri)
            else:
                raise HTTPError(
                    'Error response contains JSON but it does not specify code'
                    ' or error keys: {0}'.format(response.content), status,
                    uri)

    def _handle_web_service_error(self, message, code, status, uri):
        if code in ('IP_ADDRESS_NOT_FOUND', 'IP_ADDRESS_RESERVED'):
            raise AddressNotFoundError(message)
        elif code in ('AUTHORIZATION_INVALID', 'LICENSE_KEY_REQUIRED',
                      'USER_ID_REQUIRED'):
            raise AuthenticationError(message)
        elif code == 'INSUFFICIENT_FUNDS':
            raise InsufficientFundsError(message)

        raise InvalidRequestError(message, code, status, uri)

    def _handle_5xx_status(self, status, uri):
        raise HTTPError(u'Received a server error ({0}) for '
                        u'{1}'.format(status, uri), status, uri)

    def _handle_non_200_status(self, status, uri):
        raise HTTPError(u'Received an unexpected HTTP status '
                        u'({0}) for {1}'.format(status, uri), status, uri)

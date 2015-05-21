package WebService::MinFraud::Client;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use JSON;
use LWP::UserAgent;
use Params::Validate qw( validate );
use Scalar::Util qw( blessed );
use Sub::Quote qw( quote_sub );
use Try::Tiny;
use WebService::MinFraud::Error::HTTP;
use WebService::MinFraud::Error::IPAddressNotFound;
use WebService::MinFraud::Error::WebService;
use WebService::MinFraud::Model::Insights;
use WebService::MinFraud::Model::Score;
use WebService::MinFraud::Types
    qw( JSONObject MaxMindID MaxMindLicenseKey Str URIObject UserAgentObject );

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

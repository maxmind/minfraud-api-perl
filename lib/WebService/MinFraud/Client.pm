package WebService::MinFraud::Client;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use JSON;
use LWP::UserAgent;
use Scalar::Util qw( blessed );
use Sub::Quote qw( quote_sub );
use Try::Tiny;
use Types::Standard qw( InstanceOf );
use WebService::MinFraud::Error::HTTP;
use WebService::MinFraud::Error::IPAddressNotFound;
use WebService::MinFraud::Error::WebService;
use WebService::MinFraud::Model::Insights;
use WebService::MinFraud::Model::Score;
use WebService::MinFraud::Types
    qw( JSONObject MaxMindID MaxMindLicenseKey Str URIObject UserAgentObject );
use WebService::MinFraud::Validator;

use Moo;

with 'WebService::MinFraud::Role::HasLocales';

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

has validator => (
    is      => 'lazy',
    isa     => InstanceOf ['WebService::MinFraud::Validator'],
    builder => sub { WebService::MinFraud::Validator->new },
    handles => [qw( validate_request )],
);

sub insights {
    my $self = shift;

    return $self->_response_for(
        'insights',
        'WebService::MinFraud::Model::Insights', @_,
    );
}

sub score {
    my $self = shift;

    return $self->_response_for(
        'score',
        'WebService::MinFraud::Model::Score', @_,
    );
}

sub _response_for {
    my ( $self, $path, $model_class, $content ) = @_;

    $self->validate_request($content);
    my $uri = $self->_base_uri()->clone();
    $uri->path_segments( $uri->path_segments(), $path );
    my $request = HTTP::Request->new(
        'POST', $uri,
        HTTP::Headers->new( Accept => 'application/json' ),
        $self->_json->encode($content)
    );

    $request->authorization_basic( $self->user_id(), $self->license_key() );

    my $response = $self->ua()->request($request);

    if ( $response->code() == 200 ) {
        my $body = $self->_handle_success( $response, $uri );
        return $model_class->new( %{$body}, locales => $self->locales(), );
    }
    else {
        # all other error codes throw an exception
        $self->_handle_error_status(
            $response, $uri,
            $content->{device}{ip_address}
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

# ABSTRACT: Perl API for the GeoIP2 Precision web services

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  # This creates a Client object that can be reused across requests.
  # Replace "42" with your user id and "abcdef123456" with your license
  # key.
  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  # Replace "insights" with the method score if that's the web service
  # that you are using.
  my $insights = $client->insights( device { ip_address => '24.24.24.24' } );
  say $insights->risk_score;
  my $shipping_address = $insights->shipping_adress;
  say $shipping_address->is_high_risk;

=head1 DESCRIPTION

This class provides a client API for all the minFraud web service end
points. The end points are Score and Insights. The B<Insights> end point returns
additional data about a transaction than the B<Score> end point. See
L<http://dev.maxmind.com/minfraud> for more details.

Each web service end point is represented by a different model class, and
these model classes in turn contain multiple Record classes. The record
classes have attributes which contain data about the transaction or IP address.

If the web service does not return a particular piece of data for a
transaction or IP address, the associated attribute is not populated.

The web service may not return any information for an entire record, in which
case all of the attributes for that record class will be empty.

=head1 SSL

Requests to the minFraud web service are always made with SSL.

=head1 USAGE

The basic API for this class is the same for all of the web service end
points. First you create a web service object with your MaxMind C<user_id> and
C<license_key>, then you call the method corresponding to a specific end
point, passing it the transaction you want analyzed.

If the request succeeds, the method call will return a model class for the end
point you called. This model in turn contains multiple record classes, each of
which represents part of the data returned by the web service.

If the request fails, the client class throws an exception.

=head1 CONSTRUCTOR

This class has a single constructor method:

=head2 WebService::MinFraud::Client->new()

This method creates a new client object. It accepts the following arguments:

=over 4

=item * user_id

Your MaxMind User ID. Go to L<https://www.maxmind.com/en/my_license_key> to see
your MaxMind User ID and license key.

This argument is required.

=item * license_key

Your MaxMind license key. Go to L<https://www.maxmind.com/en/my_license_key> to
see your MaxMind User ID and license key.

This argument is required.

=item * locales

This is an array reference where each value is a string indicating a locale.
This argument will be passed onto record classes to use when their C<name()>
methods are called.

The order of the locales is significant. When a record class has multiple
names (country, city, etc.), its C<name()> method will look at each element of
this array ref and return the first locale for which it has a name.

Note that the only locale which is always present in the minFraud data is "en".
If you do not include this locale, the C<name()> method may end up returning
C<undef> even when the record in question has an English name.

Currently, the valid list of locale codes is:

=over 8

=item * de - German

=item * en - English

English names may still include accented characters if that is the accepted
spelling in English. In other words, English does not mean ASCII.

=item * es - Spanish

=item * fr - French

=item * ja - Japanese

=item * pt-BR - Brazilian Portuguese

=item * ru - Russian

=item * zh-CN - simplified Chinese

=back

Passing any other locale code will result in an error.

The default value for this argument is C<['en']>.

=item * host

The hostname to make a request against. This defaults to
"minfraud.maxmind.com". In most cases, you should not need to set this
explicitly.

=item * ua

This argument allows you to your own L<LWP::UserAgent> object. This is useful
if you cannot use a vanilla LWP object, for example if you need to set proxy
parameters.

This can actually be any object which supports C<agent()> and C<request()>
methods. This method will be called with an L<HTTP::Request> object as its
only argument. This method must return an L<HTTP::Response> object.

=back

=head1 REQUEST METHODS

All of the request methods require a device ip_address.  See
L<http://dev/mamxind.com/minfraud> for details on all the values that can be
part of the request.

=over 4

=item * ip_address

This must be a valid IPv4 or IPv6 address, or the string "me". This is the
address that you want to look up using the GeoIP2 web service.

If you pass the string "me" then the web service returns data on the client
system's IP address. Note that this is the IP address that the web service
sees. If you are using a proxy, the web service will not see the client
system's actual IP address.

=back

=head2 score

This method calls the minFraud Score end point. It returns a
L<WebService::MinFraud::Model::Score> object.

=head2 insights

This method calls the minFraud Insights end point. It returns a
L<WebService::MinFraud::Model::Insights> object.

=head1 User-Agent HEADER

This module will set the User-Agent header to include the package name and
version of this module (or a subclass if you use one), the package name and
version of the user agent object, and the version of Perl.

This is set in order to help us support individual users, as well to determine
support policies for dependencies and Perl itself.

=head1 EXCEPTIONS

For details on the possible errors returned by the web service itself, see
L<http://dev.maxmind.com/minfraud> for the minFraud web service
docs.

If the web service returns an explicit error document, this is thrown as a
L<WebService::MinFraud::Error::WebService> exception object. If some other
sort of error occurs, this is thrown as a L<WebService::MinFraud::Error::HTTP>
object. The difference is that the web service error includes an error message
and error code delivered by the web service. The latter is thrown when some sort
of unanticipated error occurs, such as the web service returning a 500 or an
invalid error document.

If the web service returns any status code besides 200, 4xx, or 5xx, this also
becomes a L<WebService::MinFraud::Error::HTTP> object.

Finally, if the web service returns a 200 but the body is invalid, the client
throws a L<WebService::MinFraud::Error::Generic> object.

All of these error classes have an C<< message >> method and
overload stringification to show that message. This means that if you don't
explicitly catch errors they will ultimately be sent to C<STDERR> with some
sort of (hopefully) useful error message.

=head1 WHAT DATA IS RETURNED?

See L<http://dev.maxmind.com/minfraud> for details on what data each end
point I<may> return.

Every record class attribute has a corresponding predicate method so you can
check to see if the attribute is set.

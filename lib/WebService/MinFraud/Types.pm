package WebService::MinFraud::Types;

use strict;
use warnings;

our $VERSION = '0.001001';

use Data::Validate::IP ();
use GeoIP2::Record::City;
use GeoIP2::Record::Continent;
use GeoIP2::Record::Country;
use GeoIP2::Record::Location;
use GeoIP2::Record::Postal;
use GeoIP2::Record::RepresentedCountry;
use GeoIP2::Record::Subdivision;
use GeoIP2::Record::Traits;
use List::MoreUtils ();
use Scalar::Util    ();
use Sub::Quote qw( quote_sub );
use URI;
use WebService::MinFraud::Error::Type;

use Exporter qw( import );

our @EXPORT_OK = qw(
    ArrayRef
    Bool
    BoolCoercion
    CityCoercion
    ContinentCoercion
    CountryCoercion
    HTTPStatus
    HashRef
    IPAddress
    IssuerObject
    IssuerObjectCoercion
    JSONObject
    LocalesArrayRef
    MaxMindID
    MaxMindLicenseKey
    MaybeStr
    MinFraudCountryCoercion
    MinFraudLocationCoercion
    MostSpecificSubdivisionCoercion
    NameHashRef
    NonNegativeInt
    Num
    PositiveInt
    PostalCoercion
    RepresentedCountryCoercion
    Str
    SubdivisionsCoercion
    TraitsCoercion
    URIObject
    UserAgentObject
    object_can_type
    object_isa_type
);

our %EXPORT_TAGS = ( all => \@EXPORT_OK );

## no critic (NamingConventions::Capitalization, ValuesAndExpressions::ProhibitImplicitNewlines)
sub ArrayRef () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'ArrayRef' )
               unless defined $_[0]
               && ref $_[0]
               && Scalar::Util::reftype( $_[0] ) eq 'ARRAY'
               && ! Scalar::Util::blessed( $_[0] ); }
    );
}

sub Bool () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'Bool' )
              unless ( ( defined $_[0] && !ref $_[0] && $_[0] =~ /^(?:0|1|)$/ )
              || !defined $_[0] ); }
    );
}

sub BoolCoercion () {
    return quote_sub(
        q{ defined $_[0] && Scalar::Util::blessed($_[0])
               && ( $_[0]->isa('JSON::Boolean')
                    || $_[0]->isa('JSON::PP::Boolean')
                    || $_[0]->isa('JSON::XS::Boolean')
                  )
                ? $_[0] + 0 : $_[0] }
    );
}

sub CityCoercion () {
    return quote_sub(
        q{
            defined $_[0]
            && Scalar::Util::blessed($_[0])
            && $_[0]->isa('GeoIP2::Record::City')
            ? $_[0]
            : GeoIP2::Record::City->new($_[0]);
        }
    );
}

sub ContinentCoercion () {
    return quote_sub(
        q{
            defined $_[0]
            && Scalar::Util::blessed($_[0])
            && $_[0]->isa('GeoIP2::Record::Continent')
            ? $_[0]
            : GeoIP2::Record::Continent->new($_[0]);
        }
    );
}

sub CountryCoercion () {
    return quote_sub(
        q{
            defined $_[0]
            && Scalar::Util::blessed($_[0])
            && $_[0]->isa('GeoIP2::Record::Country')
            ? $_[0]
            : GeoIP2::Record::Country->new($_[0]);
        }
    );
}

sub HTTPStatus () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'HTTPStatus' )
               unless defined $_[0]
               && ! ref $_[0]
               && $_[0] =~ /^[2345]\d\d$/ }
    );
}

sub HashRef () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'HashRef' )
               unless defined $_[0]
               && ref $_[0]
               && Scalar::Util::reftype( $_[0] ) eq 'HASH'
               && ! Scalar::Util::blessed( $_[0] ); }
    );
}

sub IPAddress {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'IPAddress' )
               unless Data::Validate::IP::is_ipv4( $_[0] )
               || Data::Validate::IP::is_ipv6( $_[0] ); }
    );
}

sub IssuerObject () {
    return quote_sub(
        q{ WebService::MinFraud::Types::object_isa_type( $_[0], 'WebService::MinFraud::Record::Issuer' ) }
    );
}

sub IssuerObjectCoercion () {
    return quote_sub(
        q{
            defined $_[0]
            && Scalar::Util::blessed($_[0])
            && $_[0]->isa('WebService::MinFraud::Record::Issuer')
            ? $_[0]
            : WebService::MinFraud::Record::Issuer->new($_[0]);
        }
    );
}

sub JSONObject () {
    return quote_sub(
        q{ WebService::MinFraud::Types::object_can_type( $_[0], 'decode' ) });
}

{
    ## no critic (Variables::ProhibitPackageVars)
    our %_SupportedLangs = map { $_ => 1 } qw(
        de
        en
        es
        fr
        ja
        pt-BR
        ru
        zh-CN
    );

    sub LocalesArrayRef () {
        return quote_sub(
            q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'LocalesArrayRef' )
                   unless defined $_[0]
                   && ref $_[0]
                   && Scalar::Util::reftype( $_[0] ) eq 'ARRAY'
                   && !Scalar::Util::blessed( $_[0] )
                   && List::MoreUtils::all(
                   sub { defined $_ && !ref $_ && $WebService::MinFraud::Types::_SupportedLangs{$_} },
                   @{ $_[0] }
                   ); }
        );
    }
}

sub MinFraudLocationCoercion () {
    return quote_sub(
        q{
            defined $_[0]
            && Scalar::Util::blessed($_[0])
            && $_[0]->isa('WebService::MinFraud::Record::Location')
            ? $_[0]
            : WebService::MinFraud::Record::Location->new($_[0]);
        }
    );
}

# Same as PositiveInt
sub MaxMindID () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'MaxMindID' )
               unless defined $_[0]
               && ! ref $_[0]
               && $_[0] =~ /^\d+$/
               && $_[0] > 0; }
    );
}

sub MaxMindLicenseKey () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'MaxMindLicenseKey' )
               unless defined $_[0] && $_[0] =~ /^[a-zA-Z0-9]{12}$/; }
    );
}

sub MaybeStr () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'StrOrUndef' )
               unless !defined $_[0]
               || ( defined $_[0]
               && !ref $_[0] ); }
    );
}

sub MinFraudCountryCoercion () {
    return quote_sub(
        q{
            defined $_[0]
            && Scalar::Util::blessed($_[0])
            && $_[0]->isa('WebService::MinFraud::Record::Country')
            ? $_[0]
            : WebService::MinFraud::Record::Country->new($_[0]);
        }
    );
}

sub MostSpecificSubdivisionCoercion () {
    return quote_sub(
        q{
            GeoIP2::Record::Subdivision->new($_[0])
        }
    );
}

sub NameHashRef () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'NameHashRef' )
               unless defined $_[0]
               && ref $_[0]
               && Scalar::Util::reftype( $_[0] ) eq 'HASH'
               && ! Scalar::Util::blessed( $_[0] )
               && &List::MoreUtils::all( sub { defined $_ && ! ref $_ }, values %{ $_[0] } ); }
    );
}

sub NonNegativeInt () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'NonNegativeInt' )
               unless defined $_[0]
               && ! ref $_[0]
               && $_[0] =~ /^\d+$/
               && $_[0] >= 0; }
    );
}

sub Num () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'Num' )
               unless defined $_[0]
               && ! ref $_[0]
               && $_[0] =~ /^-?\d+(\.\d+)?$/; }
    );
}

sub PositiveInt () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'PositiveInt' )
               unless defined $_[0]
               && ! ref $_[0]
               && $_[0] =~ /^\d+$/
               && $_[0] > 0; }
    );
}

sub PostalCoercion () {
    return quote_sub(
        q{
            defined $_[0]
            && Scalar::Util::blessed($_[0])
            && $_[0]->isa('GeoIP2::Record::Postal')
            ? $_[0]
            : GeoIP2::Record::Postal->new($_[0]);
        }
    );
}

sub RepresentedCountryCoercion () {
    return quote_sub(
        q{
            defined $_[0]
            && Scalar::Util::blessed($_[0])
            && $_[0]->isa('GeoIP2::Record::RepresentedCountry')
            ? $_[0]
            : GeoIP2::Record::RepresentedCountry->new($_[0]);
        }
    );
}

sub Str () {
    return quote_sub(
        q{ WebService::MinFraud::Types::_tc_fail( $_[0], 'Str' )
               unless defined $_[0]
               && ! ref $_[0]; }
    );
}

sub SubdivisionsCoercion () {
    return quote_sub(
        q{
            warn "COERCE!!!";
            [ map { GeoIP2::Record::Subdivision->new($_) }  @{$_[0]} ];
        }
    );
}

sub TraitsCoercion () {
    return quote_sub(
        q{
            defined $_[0]
            && Scalar::Util::blessed($_[0])
            && $_[0]->isa('GeoIP2::Record::Traits')
            ? $_[0]
            : GeoIP2::Record::Traits->new($_[0]);
        }
    );
}

sub URIObject () {
    return quote_sub(
        q{ WebService::MinFraud::Types::object_isa_type( $_[0], 'URI' ) });
}

sub UserAgentObject () {
    return quote_sub(
        q{ WebService::MinFraud::Types::object_can_type( $_[0], 'agent', 'request' ) }
    );
}

## use critic

sub object_can_type {
    my $thing   = shift;
    my @methods = @_;

    _tc_fail( $thing, 'Object' )
        unless defined $thing
        && Scalar::Util::blessed($thing);

    for my $method (@methods) {
        _tc_fail( $thing, "Object which ->can($method)" )
            unless $thing->can($method);
    }
}

sub object_isa_type {
    my $thing = shift;
    my $class = shift;

    _tc_fail( $thing, "$class Object" )
        unless defined $thing
        && Scalar::Util::blessed($thing)
        && $thing->isa($class);
}

sub _tc_fail {
    my $value = shift;
    my $type  = shift;

    $value
        = !defined $value
        ? 'undef'
        : $value;

    WebService::MinFraud::Error::Type->throw(
        message => "$value is not a valid $type",
        type    => $type,
        value   => $value
    );
}

# ABSTRACT: Custom types for the minFraud service

1;

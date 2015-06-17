package WebService::MinFraud::Types;

use strict;
use warnings;

our $VERSION = '0.001001';

use GeoIP2::Record::City;
use GeoIP2::Record::Continent;
use GeoIP2::Record::Country;
use GeoIP2::Record::Postal;
use GeoIP2::Record::RepresentedCountry;
use GeoIP2::Record::Subdivision;
use GeoIP2::Record::Traits;
use GeoIP2::Types qw(
    ArrayRef
    Bool
    BoolCoercion
    HTTPStatus
    HashRef
    IPAddress
    JSONObject
    LocalesArrayRef
    MaxMindID
    MaxMindLicenseKey
    NonNegativeInt
    Num
    Str
    URIObject
    UserAgentObject
    object_isa_type
);
use Sub::Quote qw( quote_sub );
use WebService::MinFraud::Error::Type;

use Exporter qw( import );

our @EXPORT_OK = qw(
    ArrayRef
    Bool
    BoolCoercion
    HTTPStatus
    HashRef
    IPAddress
    IssuerObject
    IssuerObjectCoercion
    JSONObject
    LocalesArrayRef
    MaxMindID
    MaxMindLicenseKey
    MostSpecificSubdivisionCoercion
    NonNegativeInt
    Num
    Str
    SubdivisionsCoercion
    URIObject
    UserAgentObject
    object_isa_type
);

our %EXPORT_TAGS = ( all => \@EXPORT_OK );

## no critic (NamingConventions::Capitalization, ValuesAndExpressions::ProhibitImplicitNewlines)

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

sub MostSpecificSubdivisionCoercion () {
    return quote_sub(
        q{
            GeoIP2::Record::Subdivision->new($_[0])
        }
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

1;

# ABSTRACT: Custom types for the MaxMind minFraud service

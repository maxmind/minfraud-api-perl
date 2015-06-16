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
    MinFraudCountryCoercion
    MinFraudLocationCoercion
    MostSpecificSubdivisionCoercion
    NonNegativeInt
    Num
    PostalCoercion
    RepresentedCountryCoercion
    Str
    SubdivisionsCoercion
    TraitsCoercion
    URIObject
    UserAgentObject
    object_isa_type
);

our %EXPORT_TAGS = ( all => \@EXPORT_OK );

## no critic (NamingConventions::Capitalization, ValuesAndExpressions::ProhibitImplicitNewlines)
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

# ABSTRACT: Custom types for the MaxMind minFraud service

1;

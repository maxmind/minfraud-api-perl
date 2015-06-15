package WebService::MinFraud::Data::Rx::Type::RFC3987;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use IRI;

use parent 'Data::Rx::CommonType::EasyNew';

use Role::Tiny::With;

with 'WebService::MinFraud::Role::Data::Rx::Type';

sub assert_valid {
    my ( $self, $value ) = @_;

    my @labels = split /\./, $value;
    return 1
        if $value
        && eval {
        my $scheme = IRI->new( value => $value )->scheme;
        return ( $scheme eq 'http' || $scheme eq 'https' );
        };

    $self->fail(
        {
            error   => [qw(type)],
            message => 'Found value is not a valid URI (RFC3987).',
            value   => $value,
        }
    );
}

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/rfc3987';
}

1;
__END__

=head1 SYNOPSIS

    order => {
        type     => '//rec',
        optional => {
            referrer_uri    => '/maxmind/rfc3987',
        },
    }

=head1 DESCRIPTION

A type to check for a valid URI per RFC3987

=head1 METHODS

These methods are specific to L<Data::Rx>.

=head2 assert_valid

=head2 guts_from_arg

=head2 type_uri

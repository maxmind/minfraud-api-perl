package WebService::MinFraud::Data::Rx::Type::Hex32;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use parent 'Data::Rx::CommonType::EasyNew';

use Role::Tiny::With;

with 'WebService::MinFraud::Role::Data::Rx::Type';

sub assert_valid {
    my ( $self, $value ) = @_;

    return 1 if $value && ( $value =~ m/^[0-9A-Fa-f]{32}$/ );

    $self->fail(
        {
            error   => [qw(type)],
            message => 'Found value is not a 32 digit hexadecimal number.',
            value   => $value,
        }
    );
}

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/hex32';
}

1;
__END__

=head1 SYNOPSIS

    account => {
        type     => '//rec',
        optional => {
            username_md5 => '/maxmind/hex32',
        }
   }

=head1 DESCRIPTION

A type to check for a 32 digit hexadecimal.

=head1 METHODS

These methods are specific to L<Data::Rx>.

=head2 assert_valid

=head2 guts_from_arg

=head2 type_uri

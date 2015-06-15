package WebService::MinFraud::Data::Rx::Type::Hostname;

use 5.010;

use strict;
use warnings;

our $VERSION = '0.001001';

use Data::Validate::Domain qw( is_domain );

use parent 'Data::Rx::CommonType::EasyNew';

use Role::Tiny::With;

with 'WebService::MinFraud::Role::Data::Rx::Type';

sub assert_valid {
    my ( $self, $value ) = @_;

    return 1
        if is_domain($value);

    $self->fail(
        {
            error   => [qw(type)],
            message => 'Found value is not a valid host name.',
            value   => $value,
        }
    );
}

sub type_uri {
    ## no critic(ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    'tag:maxmind.com,MAXMIND:rx/hostname';
}

1;
__END__

=head1 SYNOPSIS

    email => {
        type     => '//rec',
        optional => {
            address => '//str',
            domain  => '/maxmind/hostname',
        }
    }

=head1 DESCRIPTION

A type to check for a valid host name

=head1 METHODS

These methods are specific to L<Data::Rx>.

=head2 assert_valid

=head2 guts_from_arg

=head2 type_uri

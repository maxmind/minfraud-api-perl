package WebService::MinFraud::Record::Email;

use Moo;

our $VERSION = '0.001004';

use WebService::MinFraud::Types qw( Bool BoolCoercion );

has is_free => (
    is     => 'ro',
    isa    => Bool,
    coerce => BoolCoercion,
);

has is_high_risk => (
    is     => 'ro',
    isa    => Bool,
    coerce => BoolCoercion,
);

1;

# ABSTRACT: Contains data for the email associated with a transaction

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );
  my $request  = { device => { ip_address => '24.24.24.24' } };
  my $insights = $client->insights($request);
  my $email   = $insights->email;
  say $email->is_high_risk;

=head1 DESCRIPTION

This class contains the data for the email associated with a transaction.

=head1 METHODS

This class provides the following methods:

=head2 is_free

Indicates whether the email is considered free or not

=head2 is_high_risk

Indicates whether the email is considered high risk or not

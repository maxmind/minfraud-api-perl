package WebService::MinFraud::Record::Email;

use Moo;
use namespace::autoclean;

our $VERSION = '1.003001';

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

This property is true if MaxMind believes that this email is hosted by a free
email provider such as Gmail or Yahoo! Mail.

=head2 is_high_risk

This field is true if MaxMind believes that this email is likely to be used
for fraud. Note that this is also factored into the overall risk_score in the
response as well.

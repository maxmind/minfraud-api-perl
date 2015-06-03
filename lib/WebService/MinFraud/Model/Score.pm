package WebService::MinFraud::Model::Score;

use strict;
use warnings;

our $VERSION = '0.001001';

use Moo;

with 'WebService::MinFraud::Role::HasCommonAttributes',
    'WebService::MinFraud::Role::HasLocales',
    'WebService::MinFraud::Role::Model';

1;

# ABSTRACT: Model class for minFraud: Score

__END__

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  my $client = WebService::MinFraud::Client->new(
      user_id     => 42,
      license_key => 'abcdef123456',
  );

  my $request = { device => { ip_address => '24.24.24.24'} };
  my $score = $client->score( $request );
  say $score->risk_score;

=head1 DESCRIPTION

This class provides a model for the data returned by the minFraud Score
web service.

The only difference between the Score and Insights model classes is
which fields in each record may be populated. For more details, see
L<http://dev.maxmind.com/minfraud>.

=head1 METHODS

This class provides the following methods:

=head2 credits_remaining

Returns the I<approximate> number of service credits remaining on your account.

=head2 id

Returns a UUID that identifies the minFraud request.  Please use this ID in bug
reports or support requests to MaxMind so that we can easily identify a
particular request.

=head2 risk_score

Returns the risk score, a number between 0.01 and 99. A higher score indicates a
higher risk of fraud.

=head2 warnings

Returns an ArrayRef of L<WebService::MinFraud::Record::Warning> objects.  It is
highly recommended that you check this array for issues when integrating the web
service.

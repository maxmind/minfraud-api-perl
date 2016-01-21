package WebService::MinFraud::Model::Score;

use Moo;

our $VERSION = '0.002001';

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

  my $request = { device => { ip_address => '24.24.24.24' } };
  my $score = $client->score($request);
  say $score->risk_score;

=head1 DESCRIPTION

This class provides a model for the data returned by the minFraud Score
web service.

For more details, see the L<API
documentation|https://dev.maxmind.com/minfraud/minfraud-score-and-insights-api-documentation/>.

=head1 METHODS

This class provides the following methods:

=head2 credits_remaining

Returns the I<approximate> number of service credits remaining on your account.
The service credit counts are near realtime so they may not be exact.

=head2 id

Returns a UUID that identifies the minFraud request.  Please use this UUID in
bug reports or support requests to MaxMind so that we can easily identify a
particular request.

=head2 risk_score

Returns the risk score which is a number between 0.01 and 99.  A higher score
indicates a higher risk of fraud.

=head2 warnings

Returns an ArrayRef of L<WebService::MinFraud::Record::Warning> objects.  It is
B<highly recommended that you check this array> for issues when integrating the
web service.

=head1 PREDICATE METHODS

The following predicate methods are available, which return true if the related
data was present in the response body, false if otherwise:

=head2 has_credits_remaining

=head2 has_id

=head2 has_risk_score

=head2 has_warnings

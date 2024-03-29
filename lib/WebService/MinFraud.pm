package WebService::MinFraud;

use 5.010;
use strict;
use warnings;

our $VERSION = '1.010001';

1;

# ABSTRACT: API for MaxMind's minFraud Score, Insights, and Factors services

__END__

=pod

=head1 SYNOPSIS

  use 5.010;

  use WebService::MinFraud::Client;

  # The Client object can be re-used across several requests.
  # Your MaxMind account_id and license_key are available at
  # https://www.maxmind.com/en/my_license_key
  my $client = WebService::MinFraud::Client->new(
      account_id  => 42,
      license_key => 'abcdef123456',
  );

  # For the fraud services, the request HashRef must contain a 'device' key, with a value that is a
  # HashRef containing an 'ip_address' key with a valid IPv4 or IPv6 address.
  # All other keys/values are optional; see other modules in minFraud Perl API
  # distribution for details.

  my $request = { device => { ip_address => '24.24.24.24' } };

  # Use the 'score', 'insights', or 'factors' client methods, depending on
  # the minFraud web service you are using.

  my $score = $client->score( $request );
  say $score->risk_score;

  my $insights = $client->insights( $request );
  say $insights->shipping_address->is_high_risk;

  my $factors = $client->factors( $request );
  say $factors->subscores->ip_tenure;

  # For the chargeback service, the request HashRef must contain an 'ip_address' key
  # with a valid IPv4 or IPv6 address.
  # All other keys/values are optional; see other modules in minFraud Perl API
  # distribution for details.

  $request = { ip_address => '24.24.24.24' };

  # Use the 'chargeback' method. The chargeback api does not return
  # any content from the server.

  my $chargeback = $client->chargeback( $request );
  if ($chargeback->isa('WebService::MinFraud::Model::Chargeback')) {
    say 'Successfully submitted chargeback';
  }

=head1 DESCRIPTION

This distribution provides an API for the
L<MaxMind minFraud Score, Insights, and Factors web services|https://dev.maxmind.com/minfraud?lang=en>
and the L<MaxMind minFraud Report Transaction web service|https://dev.maxmind.com/minfraud/report-a-transaction?lang=en>.

See L<WebService::MinFraud::Client> for details on using the web service client
API.

=head1 INSTALLATION

The minFraud Perl API and its dependencies can be installed with
L<cpanm|https://metacpan.org/pod/App::cpanminus>. C<< cpanm >> itself has no
dependencies.

  cpanm WebService::MinFraud

=head1 VERSIONING POLICY

The minFraud Perl API uses L<Semantic Versioning|https://semver.org/>.

=head1 PERL VERSION SUPPORT

The minimum required Perl version for the minFraud Perl API is 5.10.0.

The data returned from the minFraud web services includes Unicode characters
in several locales. This may expose bugs in earlier versions of Perl. If
Unicode is important to your work, we recommend that you use the most recent
version of Perl available.

=head1 SUPPORT

This module is deprecated and will only receive fixes for major bugs and
security vulnerabilities. New features and functionality will not be added.

Please report all issues with this distribution using the GitHub issue tracker
at L<https://github.com/maxmind/minfraud-api-perl/issues>.

If you are having an issue with a MaxMind service that is not specific to the
client API please visit L<https://www.maxmind.com/en/support> for details.

=cut

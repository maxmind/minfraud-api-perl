package WebService::MinFraud::Model::Score;

use strict;
use warnings;

our $VERSION = '0.001001';

use Moo;

with 'WebService::MinFraud::Role::AttributeBuilder';

sub _all_record_names {
    return qw(
        maxmind
    );
}

__PACKAGE__->_define_attributes_for_keys( __PACKAGE__->_all_record_names() );

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

=head1 DESCRIPTION

This class provides a model for the data returned by the minFraud Score
web service.

The only difference between the Score and Insights model classes is
which fields in each record may be populated. For more details, see
L<http://dev.maxmind.com/minfraud>.

=head1 METHODS

This class provides the following methods, each of which returns a record
object.

=head2


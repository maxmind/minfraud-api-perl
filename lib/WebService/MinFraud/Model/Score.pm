package WebService::MinFraud::Model::Score;

use strict;
use warnings;

our $VERSION = '0.001001';

#use WebService::MinFraud::Types qw( HashRef object_isa_type );

use Moo;

with 'WebService::MinFraud::Role::AttributeBuilder';

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

This class provides a model for the data returned by the minFraud Insights
web service.

The only difference between the Score and Insights model classes is
which fields in each record may be populated. See
L<http://dev.maxmind.com/minfraud> for more details.

=head1 METHODS

This class provides the following methods, each of which returns a record
object.

=head2 maxmind

Returns a L<WebService::MinFraud::Record::MaxMind> object representing data about your
MaxMind account.


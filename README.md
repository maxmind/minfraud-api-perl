# NAME

WebService::MinFraud - Perl API for MaxMind's minFraud Score and Insights web services

# VERSION

version 0.001001

# SYNOPSIS

    use 5.010;

    use WebService::MinFraud::Client;

    # The Client object can be re-used across several requests.
    # Your MaxMind user_id and license_key are available at
    # https://www.maxmind.com/en/my_license_key
    my $client = WebService::MinFraud::Client->new(
        user_id     => '42',
        license_key => 'abcdef123456',
    );

    # Request hashref must contain a 'device' key, with a value that is a
    # hashref containing an 'ip_address' key with a valid IPv4 or IPv6 address.
    # All other keys/values are optional; see other modules in minFraud perl API
    # distribution for details.

    my $request = { device => { ip_address => '24.24.24.24' } };

    # Use the 'score' or 'insights' client methods, depending on the minFraud
    # web service you are using.

    my $score = $client->score( $request );
    say $score->risk_score;

    my $insights = $client->insights( $request );
    say $insights->shipping_address->is_high_risk;

# DESCRIPTION

This distribution provides an API for the
[MaxMind minFraud Score and Insights web services](http://dev.maxmind.com/minfraud/minfraud-score-and-insights-api-documentation/).

See [WebService::MinFraud::Client](https://metacpan.org/pod/WebService::MinFraud::Client) for details on using the web service client
API.

# INSTALLATION

The minFraud perl API and its dependencies can be installed with
[cpanm](https://metacpan.org/pod/App::cpanminus).  `cpanm` itself has no
dependencies.

    cpanm WebService::MinFraud

# VERSIONING POLICY

The minFraud perl API uses [Semantic Versioning](http://semver.org/).

# PERL VERSION SUPPORT

The minimum required perl version for the minFraud perl API is 5.10.0.

The data returned from the minFraud web services includes Unicode characters
in several locales. This may expose bugs in earlier versions of perl.  If
Unicode is important to your work, we recommend that you use the most recent
version of perl available.

# SUPPORT

Please report all issues with this distribution using the GitHub issue tracker
at [https://github.com/maxmind/minfraud-api-perl/issues](https://github.com/maxmind/minfraud-api-perl/issues).

If you are having an issue with a MaxMind service that is not specific to the
client API please visit [http://www.maxmind.com/en/support](http://www.maxmind.com/en/support) for details.

# AUTHOR

Mateu Hunter <mhunter@maxmind.com>

# CONTRIBUTOR

Andy Jack <ajack@maxmind.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by MaxMind, Inc..

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

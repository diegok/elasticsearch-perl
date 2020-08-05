# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

package Search::Elasticsearch::Client::1_0;

our $VERSION='7.30_1';
use Search::Elasticsearch 7.00 ();

1;

__END__

# ABSTRACT: Thin client with full support for Elasticsearch 1.x APIs

=head1 DESCRIPTION

The L<Search::Elasticsearch::Client::1_0> package provides a client
compatible with Elasticsearch 1.x.  It should be used in conjunction
with L<Search::Elasticsearch> as follows:

    $e = Search::Elasticsearch->new(
        client => "1_0::Direct"
    );

See L<Search::Elasticsearch::Client::1_0::Direct> for documentation
about how to use the client itself.

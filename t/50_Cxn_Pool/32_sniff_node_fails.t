# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

use Test::More;
use Test::Exception;
use Search::Elasticsearch;
use lib 't/lib';
use MockCxn qw(mock_sniff_client);

## Sniff node failures

my $t = mock_sniff_client(
    { nodes => [ 'one', 'two' ] },

    { node => 1, sniff => [ 'one', 'two' ] },
    { node => 2, code  => 200, content => 1 },
    { node => 3, code  => 509, error   => 'Cxn' },
    { node => 2, sniff => ['one'] },
    { node => 4, code  => 200, content => 1 },
    { node => 4, code  => 200, content => 1 },

    # force sniff
    { node => 4, sniff => [ 'one', 'two' ] },
    { node => 5, code => 200, content => 1 },
    { node => 6, code => 200, content => 1 },
);

ok $t->perform_request()
    && $t->perform_request
    && $t->perform_request
    && $t->cxn_pool->schedule_check
    && $t->perform_request
    && $t->perform_request,
    'Sniff after failure';

done_testing;

# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

use Test::More;
use Test::Exception;
use Search::Elasticsearch;
use lib 't/lib';
use MockCxn qw(mock_static_client);

## Nodes initially unavailable

my $t = mock_static_client(
    { nodes => [ 'one', 'two' ] },

    { node => 2, ping => 0 },
    { node => 1, ping => 0 },

    # NoNodes
    { node => 2, ping => 0 },
    { node => 1, ping => 0 },

    # NoNodes
    { node => 1, ping => 1 },
    { node => 1, code => 200, content => 1 },
    { node => 2, ping => 1 },
    { node => 2, code => 200, content => 1 },

);

ok !eval { $t->perform_request }
    && $@ =~ /NoNodes/
    && !eval { $t->perform_request }
    && $@ =~ /NoNodes/
    && $t->perform_request
    && $t->perform_request,
    'Nodes initially unavailable';

done_testing;

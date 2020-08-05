# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

use Test::More;
use Test::Exception;
use Search::Elasticsearch::Async;
use lib 't/lib';
use MockAsyncCxn qw(mock_sniff_client);

## Dynamic max content length

my $response = <<RESPONSE;
{
    "nodes": {
        "one": {
            "http_address": "inet[/one]",
            "http": {
                "max_content_length_in_bytes": 200
            }
        },
        "two": {
            "http_address": "inet[/two]",
            "http": {
                "max_content_length_in_bytes": 509
            }
        },
        "three": {
            "http_address": "inet[/two]"
        }
    }
}
RESPONSE

my $t = mock_sniff_client(
    { nodes => ['one'] },
    { node  => 1, code => 200, content => $response },
    { node  => 2, code => 200, content => 1 },
);

$t->perform_sync_request
    && $t->cxn_pool->next_cxn->then(
    sub {
        is shift()->max_content_length, 200, "Dynamic max content length";
    }
    );

$t = mock_sniff_client(
    { nodes => ['one'], max_content_length => 1000 },
    { node => 1, code => 200, content => $response },
    { node => 2, code => 200, content => 1 },
);

$t->perform_sync_request
    && $t->cxn_pool->next_cxn->then(
    sub {
        is shift()->max_content_length, 1000, "Dynamic max content length";
    }
    );

done_testing;

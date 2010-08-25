use strict;
use warnings;

use Test::More tests => 1;

eval "use Test::Pod::Coverage 1.04";

SKIP: {
    skip( "Test::Pod::Coverage 1.04 required for testing POD coverage", 1 )
      if $@;

    pod_coverage_ok(
        'MooseX::SlurpyConstructor',
        { trustme => [ qw( init_meta ) ] }
    );
}

#!/usr/bin/perl

package SingleUsage;

use Moose;
use MooseX::SlurpyConstructor;

has slurpy => (
    is      => 'ro',
    isa     => 'Maybe[HashRef[Str]]',
    slurpy  => 1,
);

has non_slurpy => (
    is      => 'ro',
    slurpy  => 0,
);

has other => (
    is      => 'ro',
);

1;

package main;

use strict;
use warnings;

use Test::More tests => 6;

my $no_slurpy = SingleUsage->new({
    non_slurpy  => 32,
    other       => 33,
});
ok( defined $no_slurpy,
    "instantiating class with no unknown attributes"
);
is_deeply( $no_slurpy->slurpy,
    {},
    "...slurpy attribute is empty hashref"
);

my $with_slurpy = SingleUsage->new({
    non_slurpy  => 1,
    other       => 2,
    unknown1    => 'a',
    unknown2    => 'b',
    unknown3    => 'c',
});
ok( defined $with_slurpy,
    "instantiating class with unknown attributes"
);
is_deeply( $with_slurpy->slurpy,
    {
        unknown1    => 'a',
        unknown2    => 'b',
        unknown3    => 'c',
    },
    "...expected value for slurpy attribute"
);

my $assigning_slurpy;
eval {
    $assigning_slurpy = SingleUsage->new({
        slurpy  => "a"
    });
};
like( $@,
    qr/Can't assign to 'slurpy', as it's slurpy init_arg/,
    "expected error message when trying to assign to a slurpy parameter"
);

eval {
    SingleUsage->new({
        unknown     => {},
    });
};
like( $@,
    qr/^Attribute \(slurpy\) does not pass the type constraint/,
    'slurpy attributes honour type constraints'
);

1;


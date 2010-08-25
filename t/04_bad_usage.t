#!/usr/bin/perl

use Test::More tests => 3;

package DoubleUsage;

use Test::More;
use Moose;
use MooseX::SlurpyConstructor;

has slurpy => (
    is      => 'ro',
    slurpy  => 1,
);
pass( "adding single slurpy attribute succeeds" );

eval {
    has slurpy2 => (
        is      => 'ro',
        slurpy  => 1,
    );
};
like( $@,
    qr/Can't add mutliple slurpy attributes to a class, attempting to add 'slurpy2', existing slurpy attribute 'slurpy'/,
    "expected error when trying to add two slurpy attributes to a class"
);

package NonUsage;

use Moose;
use MooseX::SlurpyConstructor;

has a => (
    is          => 'ro',
);

package main;

eval {
    NonUsage->new;
};
like( $@,
    qr/^No parameters marked 'slurpy', do you need this module\?/,
    "expected error when trying to instantiate slurpy class with no slurpy attribute"
);

1;

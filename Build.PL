use strict;
use warnings;

require 5.008;

use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'MooseX::SlurpyConstructor',
    license             => 'perl',
    requires            => {
        'Moose'             => '0.74',
        'Test::More'        => '0',
        'Module::Build'     => '0',
    },
    create_makefile_pl  => 'passthrough',
    create_readme       => 1,
);

$builder->create_build_script;

package MooseX::SlurpyConstructor;

our $VERSION = '0.94';

use Moose;
use Moose::Exporter;
use Moose::Util::MetaRole;
use MooseX::SlurpyConstructor::Role::Object;
use MooseX::SlurpyConstructor::Role::Attribute;

Moose::Exporter->setup_import_methods;

sub init_meta {
    my ( undef, %args ) = @_;

    Moose->init_meta( %args );

    my $for_class = $args{ for_class };

    Moose::Util::MetaRole::apply_metaclass_roles(
        for_class               => $for_class,
        attribute_metaclass_roles   => [
            qw( MooseX::SlurpyConstructor::Role::Attribute ),
        ],
    );

    Moose::Util::MetaRole::apply_base_class_roles(
        for_class               => $for_class,
        roles                   => [
            qw( MooseX::SlurpyConstructor::Role::Object )
        ],
    );
    return $for_class->meta;
}

no Moose;

__PACKAGE__->meta->make_immutable;

=pod

=head1 NAME

MooseX::SlurpyConstructor - Assign all unknown arguments to attribute in object constructor.

=head1 SYNOPSIS

    package ASDF;

    use Moose;
    use MooseX::SlurpyConstructor;

    has fixed => (
        is      => 'ro',
    );

    has slurpy => (
        is      => 'ro',
        slurpy  => 1,
    );

    package main;

    ASDF->new({
        fixed => 100, unknown1 => "a", unknown2 => [ 1..3 ]
    })->dump;

    # returns:
    #   $VAR1 = bless( {
    #       'slurpy' => {
    #           'unknown2' => [
    #               1,
    #               2,
    #               3
    #           ],
    #           'unknown1' => 'a'
    #       },
    #       'fixed' => 100
    #   }, 'ASDF' );

=head1 DESCRIPTION

Including this module within Moose-based classes, and declaring an
attribute as 'slurpy' will allow capturing of all unknown constructor
arguments in the given attribute.

When composing a class, an error will be raised if more than one
attribute of the class is marked as 'slurpy'.  Also, at object
instatiation time, an error will be raised if the class being
instantiated uses this one, but does not declare a slurpy attribute.

=head1 SEE ALSO

=over 4

=item MooseX::StrictConstructor

The opposite of this module, making constructors die on unknown arguments.
Note that if both of these are used together, SlurpyConstructor will take
precedence and strict constructor explosions will never occour.

=back

=head1 AUTHOR

Mark Morgan C<< <makk384@gmail.com> >>

Thanks to the folks from moose mailing list and IRC channels for
helping me find my way around some of the Moose bits I didn't
know of before writing this module.

=head1 BUGS

As usual, send bugs or feature requests to
C<bug-moosex-slurpyconstructor@rt.cpan.org> or through web interface
L<http://rt.cpan.org>.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Mark Morgan, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

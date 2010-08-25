package MooseX::SlurpyConstructor::Role::Object;

use Moose::Role;

around new => sub {
    my ( $orig, $class, @incoming ) = @_;

    my $args;
    if ( scalar @incoming == 1 and ref $incoming[ 0 ] eq 'HASH' ) {
        $args = shift @incoming;
    } else {
        $args = { @incoming };
    }

    my @init_args =
      grep { defined }
      map { $_->init_arg }
      $class->meta->get_all_attributes;

    # all args initially
    my %slurpy_args = %$args;

    # remove any that are defined as init_args for any attributes
    delete @slurpy_args{ @init_args };

    my %init_args = map { $_ => $args->{ $_ } } @init_args;

    # find all attributes marked slurpy
    my @slurpy_attrs =
      grep { $_->slurpy }
      $class->meta->get_all_attributes;

    # and ensure that we have one
    my $slurpy_attr = shift @slurpy_attrs;
    if ( not defined $slurpy_attr ) {
        Moose->throw_error( "No parameters marked 'slurpy', do you need this module?" );
    } elsif ( scalar @slurpy_attrs ) {
        # this should never happen, as there should only ever be a single
        # slurpy attribute
        die "Something strange here - There should never be more than a single slurpy argument, please report a bug, with test case";
    }

    my $init_arg = $slurpy_attr->init_arg;
    if ( defined $init_arg and defined $init_args{ $init_arg } ) {
        my $name = $slurpy_attr->name;

        die( "Can't assign to '$init_arg', as it's slurpy init_arg for attribute '$name'" );
    }

    my $self = $class->$orig({
        %init_args
    });

    # go behind the scenes to set the value, in case the slurpy attr
    # is marked read-only.
    $slurpy_attr->set_value( $self, \%slurpy_args );

    return $self;
};

no Moose::Role;

1;

__END__

=pod

=head1 NAME

MooseX::SlurpyConstructor::Role::Object - Internal class for
L<MooseX::SlurpyConstructor>.

=head1 SEE ALSO

=over 4

=item MooseX::StrictConstructor

Main class, with relevant details.

=cut

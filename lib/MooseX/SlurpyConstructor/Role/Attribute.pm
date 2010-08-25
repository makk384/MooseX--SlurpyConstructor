package MooseX::SlurpyConstructor::Role::Attribute;

use Moose::Role;

has slurpy => (
    is          => 'ro',
    isa         => 'Bool',
    default     => 0,
);

before attach_to_class => sub {
    my ( $self, $meta ) = @_;

    return if not $self->slurpy;

    my @slurpy =
      map { $_->name }
      grep { $_->slurpy }
      $meta->get_all_attributes;

    if ( scalar @slurpy ) {
        my $message = sprintf(
            "Can't add mutliple slurpy attributes to a class, attempting to add '%s', existing slurpy attribute '%s'",
            $self->name,
            $slurpy[ 0 ],
        );
        die $message;
    }
};

no Moose::Role;

1;

__END__

=pod

=head1 NAME

MooseX::SlurpyConstructor::Role::Attribute - Internal class for
L<MooseX::SlurpyConstructor>.

=head1 SEE ALSO

=over 4

=item MooseX::SlurpyConstructor

Main class, with relevant details.

=back

=cut



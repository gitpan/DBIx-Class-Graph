package DBIx::Class::ResultSet::Graph;
use strict;
use warnings;

#use Class::C3;
use DBIx::Class::Graph::Wrapper;
use base qw( DBIx::Class::ResultSet Class::Accessor);
__PACKAGE__->mk_accessors(qw(_graph));
__PACKAGE__->mk_accessors(qw(_group_rel));


sub get_graph {
	my $self = shift;
	return $self->_graph if ( $self->_graph );
	my $source = $self->result_class;
	my $rel    = $source->_group_rel;
	my @obj = $self->search( undef, { prefetch => $rel } )->all; #, { prefetch => $rel } 
	#my @obj = $self->search( undef, { prefetch =>  ["parent", "child"] } )->all; #, { prefetch => $rel } 
	$self->set_cache( \@obj );
	my $g      = new DBIx::Class::Graph::Wrapper( refvertexed => 1 );
	$g->_rs($self);
	for (@obj) {
		$g->add_vertex($_);
	}
	foreach my $row (@obj) {
		if($row->has_column($source->_group_column)) {
			my $pre = $row->$rel;
			next unless $pre;
			($pre->can("id") && $source->_connect_by eq "predecessor")
			  ? $g->add_edge( $g->get_vertex( $pre->id ), $row )    
			  : $g->add_edge( $row, $g->get_vertex( $pre->id ) );
		} else {
			#foreach my $pre ( $row->many_parents->all ) {
				#next unless $pre;
				#($pre->parent->can("id") && $source->_connect_by eq "predecessor")
				#  ? $g->add_edge( $pre->parent, $row )    
				#  : $g->add_edge( $row, $pre->parent );
			#}
		}
	}
	return $g;
}
1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

DBIx::Class::ResultSet::Graph

=head1 DESCRIPTION

See L<DBIx::Class::Graph>

=head1 AUTHOR

Moritz Onken, E<lt>mo@apple.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Moritz Onken

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut

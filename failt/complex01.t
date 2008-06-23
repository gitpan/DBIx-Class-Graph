use Test::More tests => 6;

use lib qw(../../lib ../lib t/lib lib);

use TestLib;

my $t = new TestLib;

my $schema = $t->get_schema;

my $rs = $schema->resultset("ComplexMap");

my @obj = $rs->search( undef, { prefetch => ["parent", "child"] } )->all;

is($rs->search({child => 6})->first->parent->id, 3);


my $g = $rs->get_graph;

my $v = $g->get_vertex(5);
is(scalar $v->parents, 2);

foreach my $pre ( $v->many_parents->all ) {
	print $pre->id.$/;
	#$g->add_edge($pre->parent, $v);
}

die;

my $v = $rs->find(6);

is($v->parents->first->id, 3);

$v = $g->get_vertex(6);

is($v->id, 6);

is(scalar $g->all_predecessors($v), 2);

my $v1 = $g->get_vertex(1);
my $v3 = $g->get_vertex(3);
my $v5 = $g->get_vertex(5);

$g->add_edge($v1, $v5);

is(scalar $v5->parents->all, 2);

is(scalar $g->all_successors($v1), 5);

is(scalar $g->successors($v1), 4);

is(scalar $g->all_successors($v3), 2);


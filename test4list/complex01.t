use Test::More tests => 6;
use TestLib;
my $t      = new TestLib;
my $schema = $t->get_schema;
my @rs =
  $schema->resultset("Complex")
  ->search( undef, { prefetch => { parents => "parent" } } );
for (@rs) {
	is( defined $_->parents->first->parent->id, 1 );
}

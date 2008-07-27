use Test::More tests => 6;

use lib qw(../../lib ../lib t/lib lib ../t/lib);

use TestLib;

my $t = new TestLib;

my $schema = $t->get_schema;

my $rs = $schema->resultset("Complex")->search( undef, { prefetch => {parents => "parent"} } );


is($rs->find(3)->parents->first->parent->id, 1);

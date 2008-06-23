package TestLib;
use strict;
use warnings;
use TestLib::Schema;

sub new {
	my $self = shift;
	unlink("t/sqlite.db") if -e "t/sqlite.db";
	my $schema = TestLib::Schema->connect("dbi:SQLite:t/sqlite.db");
	$schema->deploy;
	my $t = $schema->populate(
		"Simple",
		[
			[qw(title parentid id)],
			[ "root",     0, 1 ],
			[ "child",    1, 2 ],
			[ "child",    1, 3 ],
			[ "child",    1, 4 ],
			[ "subchild", 3, 5 ],
			[ "subchild", 3, 6 ]    
		]
	);
	
	$t = $schema->populate(
		"SimpleSucc",
		[
			[qw(title childid id)],
			[ "root",     3, 1 ],
			[ "root",     3, 2 ],
			[ "child",    5, 3 ],
			[ "root",    5, 4 ],
			[ "subchild", 0, 5 ],
			[ "subchild", 0, 6 ]    
		]
	);	
	$t = $schema->populate(
		"Complex",
		[
			[qw(title id)],
			[ "root",     1 ],
			[ "root",     2 ],
			[ "child",    3 ],
			[ "root",    4 ],
			[ "subchild", 5 ],
			[ "subchild", 6 ]    
		]
	);	
	$t = $schema->populate(
		"ComplexMap",
		[
			[qw(parent child)],
			[ 0, 1 ],
			[ 1, 2 ],
			[ 1, 3 ],
			[ 1, 4 ],
			[ 3, 5 ],
			[ 2, 5 ],
			[ 3, 6 ]    
		]
	);
	return bless( { schema => $schema }, $self );
}

sub get_schema {
	my $self = shift;
	return $self->{schema};
}
1;

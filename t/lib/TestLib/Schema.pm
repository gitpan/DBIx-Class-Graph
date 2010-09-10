#
# This file is part of DBIx-Class-Graph
#
# This software is Copyright (c) 2010 by Moritz Onken.
#
# This is free software, licensed under:
#
#   The (three-clause) BSD License
#
package    # hide from PAUSE
  TestLib::Schema;

use base qw/DBIx::Class::Schema/;

__PACKAGE__->load_classes();

1;

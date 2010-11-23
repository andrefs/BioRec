package Bipi::App::DBSchema::Result::PaperSet;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "Core");
__PACKAGE__->table("paper_set");
__PACKAGE__->add_columns(
  "paper_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "pset_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("paper_id", "pset_id");
__PACKAGE__->belongs_to(
  "paper_id",
  "Bipi::App::DBSchema::Result::Paper",
  { id => "paper_id" },
);
__PACKAGE__->belongs_to(
  "pset_id",
  "Bipi::App::DBSchema::Result::Pset",
  { id => "pset_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-07-08 20:38:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ufvwuvU9Yg+FDi3+VxYDjQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;

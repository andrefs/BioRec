package Bipi::App::DBSchema::Result::EntityClass;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "Core");
__PACKAGE__->table("entity_class");
__PACKAGE__->add_columns(
  "entity_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "class_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("entity_id", "class_id");
__PACKAGE__->belongs_to(
  "entity_id",
  "Bipi::App::DBSchema::Result::Entity",
  { id => "entity_id" },
);
__PACKAGE__->belongs_to(
  "class_id",
  "Bipi::App::DBSchema::Result::Class",
  { id => "class_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-07-08 20:38:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LW0DHUR2fbmM/MSFAXapUA


# You can replace this text with custom content, and it will be preserved on regeneration
1;

package Bipi::App::DBSchema::Result::Class;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "Core");
__PACKAGE__->table("class");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "rank",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "name",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "entity_classes",
  "Bipi::App::DBSchema::Result::EntityClass",
  { "foreign.class_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-07-08 20:38:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:W6fGMukRCQ+X41yRPtgtsQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;

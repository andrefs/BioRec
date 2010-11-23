package Bipi::App::DBSchema::Result::Pset;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "Core");
__PACKAGE__->table("pset");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "submission_date",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "paper_sets",
  "Bipi::App::DBSchema::Result::PaperSet",
  { "foreign.pset_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-07-08 20:38:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PtYe8UG3hCSWT8d9SE5tWg
use overload '""' => sub {$_[0]->id}, fallback => 1;
__PACKAGE__->many_to_many('papers', 'paper_sets' => 'paper');
__PACKAGE__->add_columns(
	"submission_date", { data_type => 'datetime', set_on_create => 1 }
);

# You can replace this text with custom content, and it will be preserved on regeneration
1;

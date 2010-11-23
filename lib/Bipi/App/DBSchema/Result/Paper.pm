package Bipi::App::DBSchema::Result::Paper;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "Core");
__PACKAGE__->table("paper");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "pset",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "pmid",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "original_name",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "pdf_path",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "txt_path",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "ner_path",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "bipi_path",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "status",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "lines",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "paragraphs",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "ent_by_par",
  {
    data_type => "FLOAT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "paper_sets",
  "Bipi::App::DBSchema::Result::PaperSet",
  { "foreign.paper_id" => "self.id" },
);
__PACKAGE__->has_many(
  "paper_entities",
  "Bipi::App::DBSchema::Result::PaperEntity",
  { "foreign.paper_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-07-08 20:38:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+kBgts/4WpkdaXo4tZIufQ
use overload '""' => sub {$_[0]->original_name}, fallback => 1;
__PACKAGE__->many_to_many('psets', 'paper_sets' => 'pset_id');
__PACKAGE__->many_to_many('entities', 'paper_entities' => 'entity_id');

sub entity_count{
    my ($self) = @_; 
	return $self->paper_entities->count;
}

sub entities_by_paragraph{
	my ($self) = @_;
	my $var = sprintf "%.3f", $self->ent_by_par;
	return $var;
}
sub entities_by_line{
	my ($self) = @_;
	my $var = sprintf "%.3f", $self->paper_entities->count / $self->lines;
	return $var;
}
# You can replace this text with custom content, and it will be preserved on regeneration
1;

use strict;
use warnings;

package Bipi::App::Controller::Paper;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package Bipi::App::Controller::Paper::PaperForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'Paper' );

#	has_field 'entity_ids' => ( type => 'Select', multiple => 1 );
	has_field 'entity' => ( type => 'Select', multiple => 1 );
    has_field 'psets' => ( type => 'Select', multiple => 1 );
    has_field 'paragraphs' => ( type => 'Text', );
    has_field 'lines' => ( type => 'Text', );
#   has_field 'tags' => ( type => 'Select', multiple => 1 );
#   has_field 'annotated_text' => ( type => 'TextArea', );
#   has_field 'text' => ( type => 'TextArea', );
    has_field 'status' => ( type => 'TextArea', );
#    has_field 'file_path' => ( type => 'TextArea', );
#    has_field 'file_name' => ( type => 'TextArea', );
    has_field 'bipi_path' => ( type => 'Text', );
    has_field 'ner_path' => ( type => 'Text', );
    has_field 'txt_path' => ( type => 'Text', );
    has_field 'pdf_path' => ( type => 'Text', );
    has_field 'original_name' => ( type => 'Text', );
    has_field 'pmid' => ( type => 'Text', );
    has_field 'pset' => ( type => 'Integer', );
    has_field 'submit' => ( widget => 'submit' )
}




__PACKAGE__->config(
    action => {
        list => { Chained => 'base', PathPart => q{}, Args => 0 },
        #view => { Chained => 'base' },
        edit => { Chained => 'base' },
        destroy => { Chained => 'base' },
    },
);

#sub annotated :Local {
#	my ($self, $c, $paper_id) = @_;
#	my $paper = $c->model('DBICSchemamodel::Paper')->find($paper_id);
#	my $path = $paper->bipi_path;
#	open(FILE,$path);
#	my $res = join '',<FILE>;
#	close FILE;
#	$c->stash(text => $res,
#				paper => $paper,
#				template => 'annotated.tt');
#}

sub view :Local {
	my ($self, $c, $paper_id) = @_;
	my $paper = $c->model('DBICSchemamodel::Paper')->find($paper_id);
	my $path = $paper->bipi_path;
	open(FILE,$path);
	my $text = join '',<FILE>;
	close FILE;
	$c->stash(	item => $paper,
				text => $text,
				template => 'paper/view.tt');
}

sub base : Chained('/') PathPart('paper') CaptureArgs(0) {}

1;


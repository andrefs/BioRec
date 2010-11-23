use strict;
use warnings;

package Bipi::App::Controller::PaperEntity;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package Bipi::App::Controller::PaperEntity::PaperEntityForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'PaperEntity' );

    has_field 'entity_id' => ( type => 'Select', );
    has_field 'paper_id' => ( type => 'Select', );
    has_field 'submit' => ( widget => 'submit' )
}




__PACKAGE__->config(
    action => {
        list => { Chained => 'base', PathPart => q{}, Args => 0 },
        view => { Chained => 'base' },
        edit => { Chained => 'base' },
        destroy => { Chained => 'base' },
    },
);

sub base : Chained('/') PathPart('paperentity') CaptureArgs(0) {}

1;


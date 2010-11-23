use strict;
use warnings;

package Bipi::App::Controller::Entity;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package Bipi::App::Controller::Entity::EntityForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'Entity' );

    has_field 'paper_ids' => ( type => 'Select', multiple => 1 );
    has_field 'class_ids' => ( type => 'Select', multiple => 1 );
    has_field 'name' => ( type => 'Text', );
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

sub base : Chained('/') PathPart('entity') CaptureArgs(0) {}

1;


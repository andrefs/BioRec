use strict;
use warnings;

package Bipi::App::Controller::EntityClass;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package Bipi::App::Controller::EntityClass::EntityClassForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'EntityClass' );

    has_field 'entity_id' => ( type => 'Select', );
    has_field 'class_id' => ( type => 'Select', );
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

sub base : Chained('/') PathPart('entityclass') CaptureArgs(0) {}

1;


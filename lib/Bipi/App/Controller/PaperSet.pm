use strict;
use warnings;

package Bipi::App::Controller::PaperSet;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package Bipi::App::Controller::PaperSet::PaperSetForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'PaperSet' );

    has_field 'pset' => ( type => 'Select', );
    has_field 'paper' => ( type => 'Select', );
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

sub base : Chained('/') PathPart('paperset') CaptureArgs(0) {}

1;


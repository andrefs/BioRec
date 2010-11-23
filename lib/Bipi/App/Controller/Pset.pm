use strict;
use warnings;

package Bipi::App::Controller::Pset;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package Bipi::App::Controller::Pset::PsetForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'Pset' );

    has_field 'papers' => ( type => 'Select', multiple => 1 );
    has_field 'submission_date' => ( type => 'TextArea', );
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

sub base : Chained('/') PathPart('pset') CaptureArgs(0) {}

1;


use strict;
use warnings;

package Bipi::App::Controller::PaperTag;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package Bipi::App::Controller::PaperTag::PaperTagForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'PaperTag' );

    has_field 'tag' => ( type => 'Select', );
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

sub base : Chained('/') PathPart('papertag') CaptureArgs(0) {}

1;


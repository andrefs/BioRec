use strict;
use warnings;

package Bipi::App::Controller::Tag;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package Bipi::App::Controller::Tag::TagForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'Tag' );

    has_field 'papers' => ( type => 'Select', multiple => 1 );
    has_field 'description' => ( type => 'TextArea', );
    has_field 'name' => ( type => 'TextArea', );
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

sub base : Chained('/') PathPart('tag') CaptureArgs(0) {}

1;


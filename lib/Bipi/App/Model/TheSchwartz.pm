package Bipi::App::Model::TheSchwartz;
use parent "Catalyst::Model::Adaptor";
__PACKAGE__->config( class => "TheSchwartz" );

sub mangle_arguments { %{$_[1]} }
#sub mangle_arguments {  } # afs

1;


# afs use Moose;
# afs use namespace::autoclean;
# afs 
# afs extends 'Catalyst::Model';
# afs 
# afs =head1 NAME
# afs 
# afs Bipi::App::Model::TheSchwartz - Catalyst Model
# afs 
# afs =head1 DESCRIPTION
# afs 
# afs Catalyst Model.
# afs 
# afs =head1 AUTHOR
# afs 
# afs Andre Santos,,,
# afs 
# afs =head1 LICENSE
# afs 
# afs This library is free software. You can redistribute it and/or modify
# afs it under the same terms as Perl itself.
# afs 
# afs =cut
# afs 
# afs __PACKAGE__->meta->make_immutable;
# afs 

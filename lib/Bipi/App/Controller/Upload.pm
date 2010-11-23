package Bipi::App::Controller::Upload;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Bipi::App::Controller::Upload - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    if ( $c->request->parameters->{form_submit} eq 'yes' ) {
        for my $field ( $c->req->upload ) {
            my $upload   = $c->req->upload($field);
            my $filename = $upload->filename;
            my $target   = "/tmp/upload/$filename";
            unless ( $upload->link_to($target) || $upload->copy_to($target) ) {
                die( "Failed to copy '$filename' to '$target': $!" );
            }
        }
    $c->stash->{template} = 'file_upload.html';
    }
	else {
		$c->stash->{template} = 'upload.tt';
	}
}
sub more :Local :Args(1) {
    my ( $self, $c, $set ) = @_;
    if ( $c->request->parameters->{form_submit} eq 'yes' ) {
        for my $field ( $c->req->upload ) {
            my $upload   = $c->req->upload($field);
            my $filename = $upload->filename;
            my $target   = "/tmp/upload/$filename";
            unless ( $upload->link_to($target) || $upload->copy_to($target) ) {
                die( "Failed to copy '$filename' to '$target': $!" );
            }
        }
    $c->stash->{template} = 'file_upload.html';
    }
	else {
		$c->stash->{template} = 'upload.tt';
	}
}

=head1 AUTHOR

Andre Santos,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;


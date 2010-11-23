package Bipi::App::Controller::Analize;
use strict;
use Catalyst qw( ConfigLoader );
use base 'Catalyst::Controller';
use TheSchwartz::Job;
use DBI;
use File::Copy;
use DateTime;

__PACKAGE__->config('Plugin::ConfigLoader' => { file => 'bipi_app.yml' } );

sub index :Path Args(0) {
    my ( $self, $c ) = @_;
	my $upload_folder = Bipi::App->config->{'folders'}->{uploads};
	my $sets_folder = Bipi::App->config->{'folders'}->{sets};

#open(LOG,'>>/tmp/bipi.log');
#print LOG Bipi::App->config->{name}."\n";
#print LOG Bipi::App->config->{"Controller::Analize"}->{key}."\n";
#close LOG;

	# lidar com o upload request

    if ( $c->request->parameters->{form_submit} eq 'yes' ) {
        for my $field ( $c->req->upload ) {
            my $upload   = $c->req->upload($field);
            my $filename = $upload->filename;
            my $target   = "$upload_folder/$filename";
            unless ( $upload->link_to($target) || $upload->copy_to($target) ) {
				$c->response->body("Upload error!");
                #die( "Failed to copy '$filename' to '$target': $!" );
            }
        }
    }

	# inicio do processamento dos papers

	my $pset_id;
	my @contents = qx{ls $upload_folder};
	if (scalar @contents){

		# criar um set na bd

		my $pset = $c->model('DBICSchemamodel::Pset')->create({ });
		$pset_id = $pset->id;
		mkdir "$sets_folder/$pset_id";
		mkdir "$sets_folder/$pset_id/1_pdfs";
		my $path = qx{pwd};
		chomp $path;
		
		# iterar a criar registos na bd para os ficheiros
		# e para as relacoes paper-set

		foreach my $file_name (@contents){
			chomp $file_name;
			my $pmid = ($file_name =~ /(\d+)\.pdf/) ? $1 : '';
			my $current_filepath = "$path/$upload_folder/$file_name",
			my $pset_folder = "$sets_folder/$pset_id";
			my $new_filepath = "$path/$pset_folder/1_pdfs/$file_name";
			move($current_filepath,$new_filepath);
			#copy($current_filepath,$new_filepath);
			my $paper = $c->model('DBICSchemamodel::Paper')->create({
				pset 			=> $pset_id,
				original_name 	=> $file_name,
				pdf_path 		=> $new_filepath,
				pmid 			=> $pmid,
				status 			=> 'Uploaded',
			});
			my $paper_id = $paper->id;
			my $paper_set = $c->model('DBICSchemamodel::PaperSet')->create({
				paper_id	=> $paper_id,
				pset_id		=> $pset_id
				}
			);
		}
				
		# mandar o set para a jobqueue

		#qx{echo 'Putting job $pset_id in queue now' >> /tmp/bipi.log};	
		my $job = TheSchwartz::Job->new(
		                                funcname => "Bipi::App::Job::Analize",
		                                uniqkey  => $pset_id,
		                                #arg      => 'ola'
		                                );  
		my $job_handle = $c->model("TheSchwartz")->insert($job);
		# Returns undef for duplicate jobs.
		$c->stash(job => $job_handle);
	}
	$c->response->redirect($c->uri_for_action('/pset/view', $pset_id, ));
}

1;


# afs use Moose;
# afs use namespace::autoclean;
# afs 
# afs BEGIN {extends 'Catalyst::Controller'; }
# afs 
# afs sub index :Path :Args(0) {
# afs     my ( $self, $c ) = @_;
# afs 
# afs     $c->response->body('Matched Bipi::App::Controller::Analize in Analize.');
# afs }
# afs 
# afs __PACKAGE__->meta->make_immutable;
# afs 

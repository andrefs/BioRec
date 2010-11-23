package Bipi::App::Job::Analize;
use strict;
use warnings;
no warnings "uninitialized";
use parent qw( TheSchwartz::Worker );
use TheSchwartz::Job;
use Bipi::App::DBSchema;
use Data::Dumper;
use YAML::AppConfig;
use Lingua::EN::Fathom;

my $conf = YAML::AppConfig->new( file => '../bipi_app.yml');
my $uploads_folder = $conf->config->{folders}->{uploads};
my $sets_folder = $conf->config->{folders}->{sets};

#__PACKAGE__->config( 'Plugin::ConfigLoader' => { file => 'bipi_app.yml' } );

my $DEBUG = 1;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;
	my $pset_id = $job->uniqkey;


	mk_dir_tree($pset_id);
	pdfs_to_text($pset_id);
	#clean_txts($pset_id);
	abner($pset_id);
	oscar($pset_id);
	join_ner($pset_id);
	statistics($pset_id);

    $job->completed();
}

# From our parent class we can override these-
sub keep_exit_status_for { 60 * 60 * 24 * 1 }
sub max_retries { 1 }
sub retry_delay { 30 }
sub grab_for { 60 * 3 }

sub mk_dir_tree{
	my $pset_id = shift;
	#mkdir "../$sets_folder/$pset_id/1_pdfs";	# ja foi criada por Controller::Analize
	mkdir "../$sets_folder/$pset_id/2_txts";
	mkdir "../$sets_folder/$pset_id/3_ner";
	mkdir "../$sets_folder/$pset_id/4_join";
	print STDERR "Directory tree created for set $pset_id.\n\n";
}

sub pdfs_to_text{
	my $pset_id = shift;
	my $schema = Bipi::App::DBSchema->connect('dbi:SQLite:../bipi.db');
	my $pset_rs = $schema->resultset('PaperSet')->search( { pset_id => $pset_id });
	my $code_folder = $conf->config->{code_folder};
	my $cleantxt = "../$code_folder/cleantxt";
	my $tohtml = "../$code_folder/tohtml";
	my $analyzer = new Lingua::EN::Fathom;


	my $new_path = qx{dirname "\$(pwd)"};
	chomp $new_path;
	$new_path.= "/$sets_folder/$pset_id/2_txts";

	while(my $pset = $pset_rs->next){
		my $paper = $pset->paper_id;
		#my $cmd = 'pdftotext "'.$paper->pdf_path.q{" - |  sed 's/[^[:print:]]//g' > "}.$new_path.'/'.$paper->id.'.txt"';
		my $cmd1 = 'pdftotext "'.$paper->pdf_path.qq{" - |  $cleantxt |}; #$tohtml > "}.$new_path.'/'.$paper->id.'.txt"';
		open(IN,$cmd1);
		
		my $text = join '',<IN>;

		my $cmd2 = qq{ | $tohtml > "}.$new_path.'/'.$paper->id.'.txt"';
		open(OUT,$cmd2);
		print OUT $text;
		
		close IN;	
		close OUT;	

		$analyzer->analyse_block($text);
		$paper->paragraphs($analyzer->num_paragraphs);
		$paper->lines($analyzer->num_text_lines);

		
		$paper->txt_path($new_path.'/'.$paper->id.'.txt');
		$paper->status('Converted to plain text');
		$paper->update;
		print STDERR "Paper ".$paper->id." converted to plain text.\n";
	}
	print STDERR "Set $pset_id converted to plain text.\n\n";
}

sub abner{
	my $pset_id = shift;
	print STDERR "Starting to process set $pset_id with ABNER...\n";
    my $schema = Bipi::App::DBSchema->connect('dbi:SQLite:../bipi.db');
    my $pset_rs = $schema->resultset('PaperSet')->search( { pset_id => $pset_id });	

	my $new_path = qx{dirname \$(pwd)};
	chomp $new_path;
	$new_path.= "/$sets_folder/$pset_id/3_ner";

	my $code_folder = $conf->config->{code_folder};
	my $abner_pl = "../$code_folder/abner.pl";
	my $norm_abtags = "../$code_folder/norm_abtags";
	while(my $pset = $pset_rs->next){
		my $paper = $pset->paper_id;
		my $cmd = "$abner_pl ".$paper->txt_path." 2>/dev/null | ".$norm_abtags.' > "'.$new_path.'/'.$paper->id.'".ab';

		#print "$cmd\n";
		qx{$cmd};
		$paper->ner_path($new_path);
		$paper->status('Tagged with ABNER');
		$paper->update;
		print STDERR "Paper ".$paper->id." tagged with ABNER.\n";
	}
	print STDERR "Set $pset_id tagged with ABNER.\n\n";
}

sub oscar{
	my $pset_id = shift;
	print STDERR "Starting to process set $pset_id with OSCAR3 (this may take a while)...\n";
    my $schema = Bipi::App::DBSchema->connect('dbi:SQLite:../bipi.db');
    my $pset_rs = $schema->resultset('PaperSet')->search( { pset_id => $pset_id });	

	my $srcf = "../$sets_folder/$pset_id/2_txts";
	my $destf = "../$sets_folder/$pset_id/3_ner";
	my $oscar_folder = $conf->config->{oscar}->{folder};
	my $oscar_jar = $conf->config->{oscar}->{jar};
	my $code_folder = $conf->config->{code_folder};
	my $norm_o3tags = "../$code_folder/norm_o3tags";

	my $cmd = "cd $oscar_folder; java -Xmx512m  -jar $oscar_jar ProcessInto \$OLDPWD/$srcf \$OLDPWD/$destf";# 2>/dev/null";
	#print "$cmd\n";
	qx{$cmd};

	my $sed = 'sed "s/<\/P>/<\/P>\n/g"';
	$cmd = qq{for i in \$(ls -F $destf | grep '/\$' | sed 's/.\$//'); do $sed "$destf/\$i/markedup.xml" | $norm_o3tags > "$destf/\$i.o3" ; rm -r "$destf/\$i/" ; done};
	#print "$cmd\n";
	qx{$cmd};
	
	while(my $pset = $pset_rs->next){
		my $paper = $pset->paper_id;
		$paper->status('Tagged with OSCAR3');
		$paper->update;
		print STDERR "Paper ".$paper->id." tagged with OSCAR3.\n";
	}
	print STDERR "Set $pset_id tagged with OSCAR3.\n\n";
}

sub join_ner{
	my $pset_id = shift;
	print STDERR "Merging the NER files from set $pset_id...\n";
    my $schema = Bipi::App::DBSchema->connect('dbi:SQLite:../bipi.db');
    my $pset_rs = $schema->resultset('PaperSet')->search( { pset_id => $pset_id });	

	my $code_folder = $conf->config->{code_folder};

	my $new_path = qx{dirname \$(pwd)};
	chomp $new_path;
	my $ner_path = "$new_path/$sets_folder/$pset_id/".$conf->config->{folders}->{sets_3_ner};
	$new_path.= "/$sets_folder/$pset_id/4_join";

	while(my $pset = $pset_rs->next){
		my $paper = $pset->paper_id;
		my $paper_id = $paper->id;
		
		#my $cmd = qq{../$code_folder/tagextr -kt -sort $ner_path/$paper_id.ab > $ner_path/$paper_id.ab_ne};
		##print "$cmd\n";
		#qx{$cmd};

		#$cmd = qq{../$code_folder/o3abjoin $ner_path/$paper_id.o3 $ner_path/$paper_id.ab_ne > $new_path/$paper_id.bipi};
		##print "$cmd\n";
		#qx{$cmd};

		my $cmd = qq{../$code_folder/tagextr -kt -sort $ner_path/$paper_id.o3 > $ner_path/$paper_id.o3_ne};
		#print "$cmd\n";
		qx{$cmd};

		$cmd = qq{../$code_folder/abo3join $ner_path/$paper_id.ab $ner_path/$paper_id.o3_ne > $new_path/$paper_id.bipi};
		#print "$cmd\n";
		qx{$cmd};

		$paper->bipi_path("$new_path/$paper_id.bipi");
		$paper->status('NER files merged');
		$paper->update;
		print STDERR "Paper ".$paper->id." NER files merged.\n";
	}
	print STDERR "Set $pset_id NER files merged.\n\n";
}

sub statistics{
	my $pset_id = shift;
	print STDERR "Analyzing entities from set $pset_id...\n";
    my $schema = Bipi::App::DBSchema->connect('dbi:SQLite:../bipi.db');
    my $pset_rs = $schema->resultset('PaperSet')->search( { pset_id => $pset_id });	

	my $code_folder = $conf->config->{code_folder};

	while(my $pset = $pset_rs->next){
		my $paper = $pset->paper_id;
		my $paper_id = $paper->id;
		my $path = $paper->bipi_path;
		
		# Devia fazer-se um teste a ver se a class existe, e adiciona-la caso contrario

		my $cmd = qq{../$code_folder/tagextr -kt }.$path." |";
		open(ENTITIES,$cmd);
		while(<ENTITIES>){
			if(/<ne\s+class="([^"]+)"\s+(?:type="([^"]+)")?[^>]*>([^<]+)<\/ne>/){
				open(LOG,'>> /tmp/bipi.log');
				print LOG "encontrou\n";
				close LOG;

				my ($class_name,$type_name,$entity_name) = ($1,$2,$3);
				
				#Search entity and class in DB

    			my $entity_rs = $schema->resultset('Entity')->search( { name => $entity_name });	
				my $entity = $entity_rs->next;
    			my $class_rs = $schema->resultset('Class')->search( { name => $class_name });	
				my $class = $class_rs->next;

				# If entity was not already defined
				
				unless(defined $entity){
					$entity = $schema->resultset('Entity')->create({ name => $entity_name }); 
					my $entity_class = $schema->resultset('EntityClass')->create({
						entity_id => $entity->id,
						class_id => $class->id
					});
				}

				my $paper_entity = $schema->resultset('PaperEntity')->find_or_create({
					paper_id => $paper_id,
					entity_id => $entity->id
				});
			}
			else{
				open(LOG,'>> /tmp/bipi.log');
				print LOG "nao encontrou\n";
				close LOG;
			}
		}
		my $ent_by_par = $paper->paper_entities->count / $paper->paragraphs;
		$paper->ent_by_par($ent_by_par);
		$paper->update;
					
		print STDERR "Paper ".$paper->id." entities found.\n";
	}
	print STDERR "Set $pset_id NER files entities found.\n\n";
}

1;

__END__

use strict;
use warnings;
no warnings "uninitialized";
use parent qw( TheSchwartz::Worker );
use TheSchwartz::Job;
use MIME::Lite;
use Sys::Hostname "hostname";

my $DEBUG = 0;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;
    my $msg = MIME::Lite
        ->new(
              From    => 'bit-bucket@' . hostname(),
              To      => $job->arg->{email},
              Subject => "Something important!",
              Type    => "text/plain",
              Data    => "This is your reminder to visit again."
             );

    if ( $DEBUG )
    {
        open my $f, ">>", "/tmp/10in10.log" or die $!;
        print $f "Not sending message!\n--\n";
        print $f $msg->as_string, "\n\n";
        close $f;
    }
    else
    {
        $msg->send;
    }
    $job->completed();
}

# From our parent class we can override these-
sub keep_exit_status_for { 60 * 60 * 24 * 1 }
sub max_retries { 1 }
sub retry_delay { 30 }
sub grab_for { 60 * 3 }

1;

#!/usr/bin/perl -ws
use strict; use warnings;
use Inline (
    Java => <<'END_JAVA',

import abner.*;
import java.io.*;

public class RunAbner{
	Tagger t;

	public RunAbner(){
		t = new Tagger();
	}
	public String tag(String text){
		return t.tagSGML(text);
	}
  
}
END_JAVA

    CLASSPATH => '.:abner.jar',
    EXTRA_JAVA_ARGS => '-mx800m'
);

my $text = join '',<>;
my $p = RunAbner->new();
print $p->tag($text)."\n";

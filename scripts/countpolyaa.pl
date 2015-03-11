use strict;
use File::Basename;


# Input paramters

my $aa = "Q";
my $filefullpath = "/files/www/polyq/data/Ptrichocarpa_210_protein.fa";
my $outputdir = "a01-poplarcount";
`mkdir -p $outputdir`;



my($fastafilename, $dir, $ext) = fileparse($filefullpath);
my $allidsfile = $outputdir . "/" . "$fastafilename" . "_allids.txt";
my $primarytranscripts = $outputdir . "/" . "$fastafilename" .  "_primarytranscripts.txt";


&parsefastafilePoplar ($filefullpath, $allidsfile);
&parsePrimaryPoplarTranscripts ($allidsfile, $primarytranscripts);
print "Completed steps\n";








sub parsefastafilePoplar {
# Parses poplar fasta file downloaded from phytozome
	my ($inputfile, $outputfile) = @_;
	my $id;
	my $countidfile;
	my $countidactual;
	my %hash = (); #hash for ids and sequences
		open (FILE, $inputfile) or die ("die:Could not open file $inputfile");
	while (<FILE>){
		if ($_=~/>/){
			$id=$_;
			$id=~s/.PAC.*//; #specific for poplar. This needs to be changed
				$id=~s/>//;
			$id=~s/\s*$//;
			$id=~s/^\s*//;
			next;
		}
		if (!$id){
			next; #just to make sure if the first line is not >id
		}

		$_=~s/\s*$//;
		$hash{$id} .=$_;
	}

	close (FILE);
# Write results in two column id\tsequence
	open (FILEOUT, ">$outputfile") or die ("died:can not open file $outputfile for writing");
	while (my ($id, $sequence) = each (%hash)){
		print FILEOUT "$id\t$sequence\n"; 
	}
	close (FILEOUT);

#Simple tests to see if the parsing went well 
	&testfastaparse ($inputfile, $outputfile);

}


sub testfastaparse {
# Simple test to see if the ids are the same
	my ($inputfile, $outputfile) = @_;
	my $countidactual =0;
	my $countidfile = 0;
#ids should be between length 5 and 20
	my $sampleid = `head -1 $outputfile | cut -f 1`;
	print STDERR "Size of sample id $sampleid is " . length ($sampleid) . "\n";
	if (length($sampleid) < 5 ){
		die ("died:sample id $sampleid is less than 5\n");
	}

	if (length($sampleid) > 25 ){
		die ("died:sample id is greater than 20\n");
	}

#ids in input and output file should be the same
	$countidactual =`grep '>' $inputfile |wc -l`;
	$countidfile =`wc -l $outputfile`;
	if ($countidactual == $countidfile){
		print STDERR "The count in actual $countidactual is same as the count in file $countidfile\n";
	}
	else {
		die ("died:The count in actual $countidactual is different from the count in file $countidfile\n");
	}
}



sub parsePrimaryPoplarTranscripts {
#Parses two column file to keep only primary transcripts
	my ($inputfile, $outputfile) = @_;
	my $countidoutfile = 0;
	my $countidinfile = 0;
	open (FILE, $inputfile) or die ("died:cannot open file $inputfile");
# Write results in two column id\tsequence
	open (FILEOUT, ">$outputfile") or die ("died:can not open file $outputfile for writing");

	while (<FILE>){
		my ($id, $sequence) = split ("\t", $_);
		next if ($id !~/\.1$/); #specific for poplar. This may need to be changed.
			print FILEOUT "$id\t$sequence";
	}
	close (FILE);
	close (FILEOUT);

	$countidoutfile =`wc -l $outputfile`;
	$countidinfile =`wc -l $inputfile`;
	print STDERR "The number of lines in \noutputfile file $outputfile is $countidoutfile \nand inputfile $inputfile is $countidinfile\n";
}





sub countpolyq {

	my ($aa, $size, $file) = @_;
	my $pattern = $aa x $size;
	open (FILE, $file) or die ("died:Could not open file $file");
	while (<FILE>){



	}

}



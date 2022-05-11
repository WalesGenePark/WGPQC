#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Std;
use File::Basename;
use Cwd 'abs_path';
use Term::ANSIColor;

###############################################################################

my %options;
getopts("1:2:o:s:f:r:e:l:t:", \%options);
my $infile1 	= $options{1} or &usage;
my $infile2 	= $options{2} or &usage;
my $outdir 	= $options{o} or &usage;
my $sample 	= $options{s} or &usage;
my $fraction	= $options{f} || 0.1;
my $ref 	= $options{r} or &usage;
my $lane 	= $options{l} or &usage;
my $threads	= $options{t} || 1;
my $encoding 	= $options{e} || 33;
sub usage {die
	"USAGE: " . basename($0) .
	"\n\t [-1 1st fastq.gz file]" .
	"\n\t [-2 2nd fastq.gz file]" .
	"\n\t [-o outdir]" .
	"\n\t [-s sample id]" .
	"\n\t [-e QV encoding (default 33)]" .
	"\n\t [-r ref path to bwa index for reference genome]" .
	"\n\t [-l lane (e.g., lane1, lane2, na)]" .
	"\n\t [-t Number of threads for BWA (default 1)]" .
	"\n\t [-f fraction of data to sample (default, 0.1)].\n";
	}

warn "NOTE: BWA MEM 0.7.17 will be used to map.\n";

if ($lane !~ /^[lL]ane\d+/ && $lane ne "na") {
        die "ERROR: Incorrect lane designation ($lane).\n";
        }

if ($lane =~ /^[lL]ane\d/) {
	$sample = "$sample.$lane";
	}

# Define outfiles
my $r1_fastqFile 	= "$sample.r1.fastq.gz";
my $r2_fastqFile 	= "$sample.r2.fastq.gz";
my $r1_subsetFastqFile 	= "$sample.r1.subset.fastq.gz";
my $r2_subsetFastqFile 	= "$sample.r2.subset.fastq.gz";
my $r1_saiFile		= "$sample.r1.sai";
my $r2_saiFile		= "$sample.r2.sai";
my $samFile		= "$sample.sam";
my $bamFile		= "$sample.bam";
my $markdupBamFile	= "$sample.markdup.bam";
my $resultsFile		= "$sample.results.properties";
my $insertGbFile	= "$sample\_insert.gb";
my $insertHistFile      = "$sample\_insert.hist";
my $insertPngFile	= "$sample\_insert.png";
my $igvFile		= "$sample.igv.jnlp";
my $fastqcDir           = "$sample\_fastqc";
my $r1_rawFastqcDir	= "$sample.r1.subset_fastqc";
my $r2_rawFastqcDir     = "$sample.r2.subset_fastqc";

# Get full paths to input fastq files
my $r1_fastqPath = abs_path($infile1);
my $r2_fastqPath = abs_path($infile2);

# Create and enter output directory
mkdir($outdir);
chdir($outdir) or die "ERROR: could not enter $outdir.\n";

mkdir($sample);
chdir($sample) or die "ERROR: could not enter $sample.\n";

# Create symbolic links to data
if (!-e $r1_fastqFile || !-e $r2_fastqFile) {
	run("ln -s $r1_fastqPath $r1_fastqFile");
	run("ln -s $r2_fastqPath $r2_fastqFile");
	}

if ($fraction == 1) {
	print "Symbolic linking $r1_fastqFile -> $r1_subsetFastqFile\n";
	run("ln -s $r1_fastqFile $r1_subsetFastqFile");
	print "Symbolic linking $r2_fastqFile -> $r2_subsetFastqFile\n";
	run("ln -s $r2_fastqFile $r2_subsetFastqFile");
	}

# Subsample gzipped Fastq files
if (!-e $r1_subsetFastqFile || !-e $r2_subsetFastqFile) {
	run("java -jar /software/WGP-Toolkit/SubsampleFastq.jar -f $fraction -i <(gunzip -c $r1_fastqFile) | gzip > $r1_subsetFastqFile");
	run("java -jar /software/WGP-Toolkit/SubsampleFastq.jar -f $fraction -i <(gunzip -c $r2_fastqFile) | gzip > $r2_subsetFastqFile");
	}

# Map
if (!-e $samFile) {
	my $rgLine = "\@RG\\tID:$sample\\tSM:$sample\\tPL:ILLUMINA";
	run("bwa mem -t$threads -M -R '$rgLine' $ref $r1_subsetFastqFile $r2_subsetFastqFile > $samFile");
	}

# create sorted index bam
if (!-e $bamFile) {
	run("samtools view -bt $ref.fasta.fai $samFile | samtools sort -o $sample.bam - ; samtools index $bamFile");
	}

# mark duplicates
 if (!-e $markdupBamFile) {
                run("java -jar /software/picard.jar MarkDuplicates INPUT=$bamFile OUTPUT=$markdupBamFile METRICS_FILE=markdup.log VALIDATION_STRINGENCY=LENIENT ASSUME_SORTED=true");
                }

# Simple metrics to results.properties file
if (!-e $resultsFile) {

	my %properties;

	# count duplicate reads
	#--------------------------------------------------------------
    my $count = `samtools view -f 1024 -c $markdupBamFile`;
	chomp($count);
	$properties{'dup.read.count'} = $count;
    
    # fastq metrics r1
    #------------------------------------------------------------------------------
	open (PIPE, "bash -c 'java -jar /software/WGP-Toolkit/SimpleFastqStats.jar -e $encoding -f <(gunzip -c $r1_subsetFastqFile) -t $sample.r1.QV -c 20 -p r1 2> /dev/null' |" ) or die "ERROR: could not open pipe. ";
    while (<PIPE>) {
    	chomp;
        	/^(\S+)=([^=]+)$/ or die "ERROR: regex failed with '$_'. ";
            $properties{$1} = $2;
    }
    close (PIPE) or die "ERROR: could not close pipe. ";

	# Create web page for stats images
    #------------------------------------------------------------------------------
    toHtml("r1", $sample);
    
	# fastq metrics r2
    #------------------------------------------------------------------------------
    
    open (PIPE, "bash -c 'java -jar /software/WGP-Toolkit/SimpleFastqStats.jar -e $encoding -f <(gunzip -c $r2_subsetFastqFile) -t $sample.r2.QV -c 20 -p r2 2> /dev/null' |" ) or die "ERROR: could not open pipe. ";
    while (<PIPE>) {
    	chomp;
        	/^(\S+)=([^=]+)$/ or die "ERROR: regex failed with '$_'. ";
            $properties{$1} = $2;
    }
    close (PIPE) or die "ERROR: could not close pipe. ";

	# Create web page for stats images
    #------------------------------------------------------------------------------
    toHtml("r2", $sample);
	
	# BAM metrics
    #------------------------------------------------------------------------------
    open (PIPE, "java -jar /software/WGP-Toolkit/SimpleBAMStats.jar -b $bamFile -p $bamFile -c 20 2> /dev/null |" ) or die "ERROR: could not open pipe. ";
    while (<PIPE>) {
		chomp;
        	/^(\S+)=([^=]+)$/ or die "ERROR: regex failed with '$_'. ";
            $properties{$1} = $2;
    }
    close (PIPE) or die "ERROR: could not close pipe. ";
    

	# insert sizes
	#------------------------------------------------------------------------------
	#run("samtools view -f 64 $bamFile | cut -f 9 | perl -pe 's/-//;' | toHist.pl -i - -b 10 | tail -n +2 | head -n 1000 > $insertHistFile");

	# Bug in above code, corrected by AE 14-09-2016 - actioned by nestor:
	run("samtools view -f 64 $bamFile | cut -f 9 | perl -pe 's/-//;' | toHist.pl -i - -b 10 | head -n 1001 | tail -n +2  > $insertHistFile");

	my $median = `samtools view -f 64 $bamFile | cut -f 9 | perl -pe 's/-//;' | perl -ne 'print if \$_ > 0' | descriptiveStatsAsAline.pl -i - | cut -f6`;
    chomp($median);
	$properties{'insert.median'} = $median;

	open (GB, ">$insertGbFile") or die "ERROR: could not open $insertGbFile.\n";
        print GB "set xrange [-10:1000]\n";
        print GB "set style fill solid border -1\n";
        print GB "unset key\n";
        print GB "set title \"Insert size histogram\"\n";
        print GB "set ticscale 2\n";
		print GB "set tics out\n";
        print GB "set ytics nomirror\n";
        print GB "set xtics nomirror\n";
        print GB "set xlabel \"Insert size (bp)\"\n";
        print GB "set ylabel \"Occurrence\"\n";
        print GB "set terminal png\n";
        print GB "set output \"$insertPngFile\"\n";
        print GB "plot '$insertHistFile' w boxes\n";
        close (GB) or die "ERROR: could not close $insertGbFile.\n";
        run("gnuplot $insertGbFile");
	#------------------------------------------------------------------------------



	# Write to outfile.
        open (OUT, ">$resultsFile") or die "ERROR: could not open $resultsFile.\n";
        	foreach my $key (sort keys %properties) {
                print OUT "$key=$properties{$key}\n";
                }
       	close (OUT) or die "ERROR: could not close $resultsFile.\n";

	}

	#---------------------------------------------------------------------
	# IGV file
	if (!-e $igvFile) {
        	my $bamPath = abs_path($bamFile);
        	$bamPath =~ s/^\/share\/apps\/data/http:\/\/wotan.cf.ac.uk/;
		$bamPath =~ s/^\/state\/partition2/http:\/\/wotan.cf.ac.uk/;
        	run("createIGVLauncher.pl -b $bamPath -r $ref -c chr9 -s 135767062 -e 135795811 > $igvFile");
        	}
	#---------------------------------------------------------------------



	#---------------------------------------------------------------------
        # Generate fastqc from mapped bam
        if (!-e $fastqcDir) {
                run("fastqc -f bam_mapped $bamFile");
                }
        #---------------------------------------------------------------------

        #---------------------------------------------------------------------
        # Generate fastqc from fastq
        if (!-e $r1_rawFastqcDir) {
                run("fastqc -f fastq $r1_subsetFastqFile");
                }

        if (!-e $r2_rawFastqcDir) {
                run("fastqc -f fastq $r2_subsetFastqFile");
                }
        #---------------------------------------------------------------------
        
    # Cleanup
        
	unlink($r1_subsetFastqFile);
	unlink($r2_subsetFastqFile);	
	unlink($samFile);
	unlink($bamFile);
	unlink("$bamFile.bai");

###############################################################################

sub toHtml {

	my $label 	= shift;
	my $sample 	= shift;

	my $tag = "$sample.$label.QV";

	open (HTML, ">$tag.mean.html") or die "ERROR: could not create $tag.mean.html.\n";
        print HTML "<html><head></head><body>";
        print HTML "<img src='$tag.mean.hist.png'>";
        print HTML "<img src='$tag.cumulative.mean.hist.png'>";
        print HTML "</body></html>";
        close(HTML) or die "ERROR: could not close $tag.mean.html.\n";

        open (HTML, ">$tag.bad.html") or die "ERROR: could not create $tag.bad.html.\n";
        print HTML "<html><head></head><body>";
        print HTML "<img src='$tag.bad.hist.png'>";
        print HTML "<img src='$tag.cumulative.bad.hist.png'>";
        print HTML "</body></html>";
        close(HTML) or die "ERROR: could not close $tag.bad.html.\n";

	} # End of method.

###############################################################################

sub run {

        my $cmd = shift;
        print color "green";
        print "$cmd\n";
        print color "reset";
        print color "blue";
        system("bash", "-c", $cmd);
        print color "reset";

        if ($? != 0) {
                print color "red";
                die "ERROR: '$cmd' failed - $!";
                }


        } # End of method.

###############################################################################

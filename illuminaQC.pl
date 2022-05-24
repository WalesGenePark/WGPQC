#!/usr/bin/perl -w

# Original author - Peter Giles

# Update log
# Update 22Feb19 - Initial development started

no warnings 'uninitialized';

use Data::Dumper;
#use File::Find::Rule;
#use File::Path;
#use File::Path qw(make_path);
use Cwd;
use List::MoreUtils qw(uniq);
use Term::ANSIColor;
use Term::ANSIColor qw(:constants);
local $Term::ANSIColor::AUTORESET = 1;
use Getopt::Long;
$|++;


sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text
}

sub mildate {
	$retval = $_[0];
	@months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
	if ($retval =~ /^\d\d\d\d\d\d$/){
		$retval = substr($retval, 4,2) . @months[substr($retval, 2,2)-1] . substr($retval, 0,2);
	}
	return(ucfirst($retval));

}

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Slurm settings
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

$SLURM_PARTITION="c_compute_cg1";
$SLURM_ACCOUNT="scw1179";
$SLURM_CORES=10;
$SLURM_WALLTIME="0-6:00";

$RUNSE="/data09/QC_pipelines/workflow/runSE.sh";
$RUNPE="/data09/QC_pipelines/workflow/runPE.sh";

$QCOUTPUTDIR="/data09/QCtest";

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Process ARGV
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

sub helpmsg {
	print "Usage: $0 -i [illuminadir] -ref [reference]\n";
	print "   -i             Input illumina directory containing fastq files\n";
	print "   -o             Output directory [default = . ] \n";
	print "   -ref/r         Define a single reference for all samples\n";
	print "   -refs          Define different references for each project\n";
	print "                  e.g. '-refs R120:hg19,R100:mm10,S124:hg19,R119:mm10'\n";
	print "   -fraction/f    Fraction of fastq to use for QC [default = 0.1]\n";
	print "   -threads/t     CPU threads for each QC run [default = $threads]\n";
	print "   -nophix        Don't QC samples against phix genome\n";
	print "   -clean/c       Delete previous QC run\n";
	print "   -debug/v		 Verbose debug output\n";
	print "   -help/h        Display help message\n";

	exit(0);
}

$threads = 10;

$singleref=""; $multipleref=""; $fraction=0.1; $outdir="."; $DEBUG=0;

GetOptions (
	'i=s' => \$rundir,
	'r|ref=s' => \$singleref,
	'refs=s' => \$multipleref,
	'f|fraction=s' => \$fraction,
	'o|outdir=s' => \$outdir,
	't|threads=s' => \$threads,
	'nophix' => \$nophix,
	'c|clean' => \$clean,
	'v|debug' => \$verbose,
	'help|h|?' => \$help,
);

# Display help message?
if($help) {
	&helpmsg;
	exit(0);
}

# Check for ARGV input errors
$error = 0;
if($rundir eq "") {
	print RED "[ERROR] No rundir defined\n";
	$error = 1;
}
if($error == 1) { &helpmsg; }

# Verbose output?
if($verbose){
	$DEBUG=1;
}

# Output into local directory?
if($outdir eq "."){
	use Cwd;
    $basedir = $QCOUTPUTDIR;
} else {
    $basedir = $outdir;
}


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Determine specified references
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

#$DEBUG=0;

%refs = ();

# Different references for each project
if($multipleref ne ""){
	@projects = split(/,/,$multipleref);
	for $line (@projects){
		@fields = split(/:/,$line);
		$project = $fields[0];
		$reference = $fields[1];
		if(exists($refs{$project})){
			$refs{$project} = $refs{$project} . "," . $reference;
		} else {
			$refs{$project} = $reference;
		}
	}
} 

#print Dumper(%refs);

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Check input directory is an illumina run directory
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

print "Input directory ... "; print GREEN "$rundir\n";

if (! -d $rundir) {
	print RED "[ERROR] Input directory '$rundir' not found\n";
	exit(1);
}

if($rundir =~ /(\d\d\d\d\d\d)_(\w\d\d\d\d\d)_(\d\d\d\d)_([^_]+)/){
	$rundate = $1;
	$rundate =~ /(\d\d)(\d\d)(\d\d)/;
	$outqcdir = "20" . $1 . "_" . $2 . "_" . $3 . "_QC";
	print "QC output directory ... "; print GREEN "$basedir/$outqcdir\n";
} else {
	print RED "[ERROR] not an Illumina run directory\n";
	exit(1);
}


#190321_M03762_0070_000000000-D4C8N
#190607_K00267_0288_AH7CFJBBXY
if($rundir =~ /(\d\d\d\d\d\d)_(M\d\d\d\d\d)_(\d\d\d\d)_([^-]+)-(D\w\w\w\w)/){
	print "Checking for MiSeq nano ... ";
	print GREEN "Detected\n";
	$fraction = 1;

}
print "Data fraction for QC ... ";
print GREEN $fraction*100 . "%\n";


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Check output directory
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


# Check base directory exists
if (! -d $basedir) {
	print RED "[ERROR] Output directory '$basedir' not found\n";
	exit(1);
}

# Check for a clean run and if not stop if output directory already exists
if ($clean) {
	if (-d "$basedir/$outqcdir") {
		print "Deleting existing QC output directory '$basedir/$outqcdir' ... ";	
		$cmd="rm -R $basedir/$outqcdir";
		if (system($cmd)){ print GREEN "DONE\n"; }
		else { print RED "ERROR\n"; exit(1); }
	}
} else {
	if (-d "$basedir/$outqcdir") {
		print RED "[ERROR] Output directory '$basedir/$outqcdir' already exists\n";
		print RED "        Please run again with the '--clean' flag if you want to delete the existing QC run\n";
		exit(1);
	}
}


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Get list of fastq files
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

print "Finding fastq.gz files in run directory ... ";

# find all the subdirectories of a given directory
#my @subdirs = File::Find::Rule->directory->in( $rundir );

# find all the .fastq.gz files in @subdirs
#my @fqfiles = File::Find::Rule->file()
#          ->name( '*.fastq.gz')
#          ->in( @subdirs );
          
$cmd="find $rundir -name '*.fastq.gz'";
@fqfiles = `$cmd`;
chomp(@fqfiles);
@fqfiles = sort @fqfiles;

$numfq = @fqfiles;
if($numfq gt 0){
	print GREEN "$numfq files\n";
} else {
	print RED "... [ERROR] no fastq.gz files found\n";
}


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Identify dates, samples, projects and lanes
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

$DEBUG=0;

@lanes = ();
@dates = ();
@samples = ();

for $fq (@fqfiles){
	if($DEBUG==1){ print YELLOW "$fq\n"; }
	$fq =~ /\/(\d\d\d\d\d\d)_\w\d\d\d\d\d_\d\d\d\d_[^_]+.*\/([^\/]+)_\w\d+_(\w\d\d\d)_\w\d_\d\d\d.fastq.gz$/;
	push(@dates, $1);
	push(@samples, $2);
	push(@lanes, $3);
	if($DEBUG==1){ print YELLOW "$1\t$2\t$3\n"; }

}

@dates=uniq(@dates);
@samples=uniq(@samples);
@lanes=uniq(@lanes);

@dates=sort(@dates);
@samples=sort(@samples);
@lanes=sort(@lanes);

if($DEBUG==1){
	print "Identifying lanes ... ";
	print GREEN scalar(@lanes)."\n";
	print "Identifying samples ... ";
	print GREEN scalar(@samples)."\n";
}


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Identify projects and references
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

$DEBUG=0;

%info = ();

for $fq (@fqfiles){
	# Get sample and lane info
	$fq =~ /\/(\d\d\d\d\d\d)_\w\d\d\d\d\d_\d\d\d\d_[^_]+.*\/([^\/]+)_\w\d+_(\w\d\d\d)_\w\d_\d\d\d.fastq.gz$/;
	$project = "";
	$sample = $2;
	$lane = $3;

	# Identify project
	if($fq =~ /Project_(\w+)\//){
		$project = $1;
	} elsif($fq =~ /(Undetermined)/){
		$project = $1;
	} elsif($fq =~ /\/(\w\d\d\d)-[AKDMNHQ]-\d\d\d/)	{
		$project = $1;
	} else {
		$project = "Unknown";
	}
	if($DEBUG==1) { print YELLOW "$project\n"; }

	# Identify project reference
	if($multipleref ne ""){
		if(! exists($refs{$project}) && $project ne "Undetermined"){
			print RED "[ERROR] Reference for project '$project' not defined\n";
			exit(1);
		} else {
			$info{$lane}{$sample}{'ref'} = $refs{$project};
			$info{$lane}{$sample}{'project'} = $project;
		}
	} elsif($singleref ne ""){
		$info{$lane}{$sample}{'ref'} = $singleref;
		$info{$lane}{$sample}{'project'} = $project;
		$refs{$project} = $singleref;
	} 
}

# Add references for undetermined

for $lane (sort(keys(%info))){
	@rr = ();
	for $line ($info{$lane}){
		for $sample (sort(keys(%$line))){
			$type = $info{$lane}{$sample}{'type'};
			push @rr, $info{$lane}{$sample}{'ref'};
		}
	}
	@rr = grep defined, @rr;
	@rr = uniq(@rr);
	if(exists($info{$lane}{'Undetermined'})){
		$info{$lane}{'Undetermined'}{'ref'} = join(",",@rr);
	}
}

# Add phiX if required
if(!defined($nophix)){
	for $lane (keys(%info)){
		if(exists($info{$lane}{'Undetermined'})){
			$info{$lane}{'Undetermined'}{'ref'} = "PhiX," . $info{$lane}{'Undetermined'}{'ref'}
		}
	}
}
	

if($DEBUG==1){
	print CYAN Dumper (%info);
	print CYAN Dumper(%refs);
}



# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Single or paired end?
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

#$DEBUG=0;

#%info = ();

for $lane (keys(%info)){
	for $line ($info{$lane}){
		for $sample (keys(%$line)){
			$tmp = $info{$lane}{$sample}{'ref'};
			@samplerefs = split(",",$tmp);

			@matches = grep { /\/\d\d\d\d\d\d_\w\d\d\d\d\d_\d\d\d\d_[^_]+.*\/(\Q$sample\E_\w\d+_\Q$lane\E_\w\d_\d\d\d.fastq.gz)$/ } @fqfiles;
			$numfq = scalar(@matches);

			if($numfq gt 0){
				#if($DEBUG==1) { print CYAN "$sample\t$lane\t$numfq\n"; }

				foreach $ref (@samplerefs){
					if(scalar(@matches) == 1){
						#if($DEBUG==1) { print MAGENTA "$lane:SE:$ref ... "; }
						$info{$lane}{$sample}{'type'} = "SE";
						$info{$lane}{$sample}{'R1'} = $matches[0];

					}
					if(scalar(@matches) == 2){
						#if($DEBUG==1) { print MAGENTA "$lane:PE:$ref ... "; }
						$info{$lane}{$sample}{'type'} = "PE";
						$info{$lane}{$sample}{'R1'} = $matches[0];
						$info{$lane}{$sample}{'R2'} = $matches[1];
					}
				}
			}

		}
		#if($DEBUG==1) { print "\n"; }
	}
}


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Print summary
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

sub get_projects {
	@retval = ();
	for $lane (keys(%info)){
		for $line ($info{$lane}){
			for $sample (keys(%$line)){
				push @retval, $info{$lane}{$sample}{'project'}
			}
		}
	}
	return(@retval);
}

sub get_lanes {
	$search = $_[0];
	@retval = ();
	for $lane (keys(%info)){
		for $line ($info{$lane}){
			for $sample (keys(%$line)){
				if($info{$lane}{$sample}{'project'} eq $search) { push @retval, $lane }
			}
		}
	}
	@retval = uniq(@retval);
	for (@retval) { s/L00//	}
	return(@retval);
}
print "Seqencing run overview:\n";
print '-' x 80; print "\n";
print colored(sprintf("%-2s %-16s %-16s %-16s %-30s\n", '','Project','Lane(s)','Samples','Reference(s)'),"white");
print '-' x 80; print "\n";

@pp = get_projects;

for $project (sort(uniq(@pp))){
	$pnsamp = grep { $_ eq $project  } @pp;
	$planes = join(",",get_lanes($project));
	$pref = $refs{$project};
	if(!defined($nophix) && $project eq "Undetermined") { $pref = "phiX,".$pref; }
	print colored(sprintf("%-2s %-16s %-16s %-16s %-30s\n", '', $project, $planes, $pnsamp, $pref), "white");
}
print '-' x 80; print "\n";


# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Prompt to continue
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

sub prompt {
  my ($query) = @_; # take a prompt string as argument
  local $| = 1; # activate autoflush to immediately show the prompt
  print $query;
  chomp(my $answer = <STDIN>);
  return $answer;
}

sub prompt_yn {
  my ($query) = @_;
  my $answer = prompt("$query (Y/N): ");
  return lc($answer) eq 'y';
}

if (prompt_yn("Please confirm this looks right")){

} else {
	exit(0);
}

# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Kick off QC runs
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

$DEBUG=0;
if($DEBUG==1){
	print CYAN Dumper (%info);
	print CYAN Dumper(%refs);
}

print "Submitting jobs to queue ... ";
if($DEBUG==1) { print "\n"; }

$jobsrun = 0;

$dryrun = 0;

for $lane (sort(keys(%info))){
	for $line ($info{$lane}){
		for $sample (sort(keys(%$line))){
			$type = $info{$lane}{$sample}{'type'};
			$srefs = $info{$lane}{$sample}{'ref'};
			for $ref (split(",",$srefs)){
				if($DEBUG==1) { print CYAN "$lane - $sample - $ref - $type\n"; }

				# Generate job name and lane string in LaneN format
				$jobname = "$lane-$sample-$ref-$type";
				$lanestr = $lane;
				$lanestr =~ s/L0+/Lane/;

				# Setup output directory
				$outputdir = "$basedir/$outqcdir/QC_$ref";
				$cmd = "mkdir -p $outputdir";
				system($cmd);
				
				if( -d $outputdir ){
					chdir($outputdir);
					#if($DEBUG==1) { print CYAN getcwd . "\n"; }
				} else {
					print RED "[ERROR] Unable to create output directory '$outputdir'\n";
					exit(1);
				}
					
				if($type eq "SE"){
					$R1 = $info{$lane}{$sample}{'R1'};
					#$cmd = "queueit.pl -cpus $threads -name $jobname -- QC_map_SE_illumina.pl -1 $R1 -o $outdir -s $sample -l $lanestr -t $threads -r $ref -f $fraction -e 33 >/dev/null 2>&1";
					
					$cmd = "sbatch --account=\"$SLURM_ACCOUNT\" --partition=\"$SLURM_PARTITION\" --nodes=1 --ntasks-per-node=1 --cpus-per-task=$SLURM_CORES --time=\"$SLURM_WALLTIME\" --error=\"$jobname.err\" --output=\"$jobname.out\" --export=\"R1=$R1,outdir=$outputdir,sample=$sample,lanestr=$lanestr,ref=$ref,fraction=$fraction,threads=$SLURM_CORES\" $RUNSE";
					
					if($DEBUG==1) { print MAGENTA "$cmd\n"; }
					if($dryrun == 0){
						if(system($cmd) == 0) { $jobsrun = $jobsrun + 1; }
						else { die "System call '$cmd' failed: $!"; }
					}
				}
				if($type eq "PE"){
					$R1 = $info{$lane}{$sample}{'R1'};
					$R2 = $info{$lane}{$sample}{'R2'};
					#$cmd = "queueit.pl -cpus $threads -name $jobname -- QC_map_PE_illumina.pl -1 $R1 -2 $R2 -o $outdir -s $sample -l $lanestr -t $threads -r $ref -f $fraction -e 33 >/dev/null 2>&1";
					
					$cmd = "sbatch --account=\"$SLURM_ACCOUNT\" --partition=\"$SLURM_PARTITION\" --nodes=1 --ntasks-per-node=1 --cpus-per-task=$SLURM_CORES --time=\"$SLURM_WALLTIME\" --error=\"$jobname.err\" --output=\"$jobname.out\" --export=\"R1=$R1,R2=$R2,outdir=$outputdir,sample=$sample,lanestr=$lanestr,ref=$ref,fraction=$fraction,threads=$SLURM_CORES\" $RUNPE";
					
					if($DEBUG==1) { print MAGENTA "$cmd\n"; }
					if($dryrun == 0){
						if(system($cmd) == 0) { $jobsrun = $jobsrun + 1; }
						else { die "System call '$cmd' failed: $!"; }
					}
				}

			}
		}
	}
}
print "\r"; print ' ' x 80;
print "\rJobs submitted to queue ... ";
print GREEN "$jobsrun\n";

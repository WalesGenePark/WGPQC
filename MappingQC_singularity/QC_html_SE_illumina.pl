#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Std;
use File::Basename;
use Kea::Number;
use Cwd 'abs_path';
my $number = Kea::Number->new;


my %options;
getopts("i:f:r:", \%options);
my $indir 	= $options{i} or &usage;
my $run 	= $options{r} or &usage;
my $fraction 	= $options{f} || 0.1;  # Fraction of data to analyse
sub usage {die "USAGE: " . basename($0) . " [-i input directory] [-r run id] [-f if only fraction of data mapped, specify (default, 0.1)].\n";}

# Get paths to all processed samples in indir (represented by results.properties file) 
my @paths = glob("$indir/*/*.results.properties");

my %data;
foreach my $path (@paths) {

        #----------------------------------------------------------------------
        # Extract relevant info from path.
        $path =~ /^$indir\/(\S+)\/(\S+)\.results\.properties$/ or die "ERROR: Regex failed with '$path'. ";
        my $sample = $1;        # sample id
        #----------------------------------------------------------------------

	# Get properties from results file.
	my $properties = getProperties("$path");

	# Per lane metrics
	$data{$sample}->{r1_total_reads} 			= $properties->{"r1.read.count"};
	$data{$sample}->{r1_total_yield} 			= $properties->{"r1.raw.data.yield"};
	$data{$sample}->{r1_percent_reads_meanqv_15plus}	= $properties->{"r1.percent.reads.meanqv.15plus"};
        $data{$sample}->{r1_percent_reads_meanqv_20plus}	= $properties->{"r1.percent.reads.meanqv.20plus"};
        $data{$sample}->{r1_percent_reads_meanqv_25plus}	= $properties->{"r1.percent.reads.meanqv.25plus"};
        $data{$sample}->{r1_percent_reads_meanqv_30plus}	= $properties->{"r1.percent.reads.meanqv.30plus"};
        $data{$sample}->{r1_percent_reads_badqv_10plus}		= $properties->{"r1.percent.reads.badqv.10plus"};
	$data{$sample}->{r1_raw_fastqc_path}			= "$indir/$sample/$sample.r1.subset_fastqc.html";
#	$data{$sample}->{r1_raw_fastqc_path}                    = "$indir/$sample/$sample.subset_fastqc/fastqc_report.html";
	$data{$sample}->{r1_mean_QV_path}                      	= "$indir/$sample/$sample.r1.QV.mean.html";
        $data{$sample}->{r1_bad_QV_path}      			= "$indir/$sample/$sample.r1.QV.bad.html";

	$data{$sample}->{total_mapped} 				= $properties->{"sam.mapped.read.count"};
	$data{$sample}->{total_mapped_uniquely} 		= $properties->{"sam.unique.read.count"};
	$data{$sample}->{dup_read_count}			= $properties->{"dup.read.count"};
	$data{$sample}->{bam_path} 				= "$indir/$sample/$sample.bam";
	$data{$sample}->{bai_path}                     		= "$indir/$sample/$sample.bam.bai";	
	$data{$sample}->{igv_path} 				= "$indir/$sample/$sample.igv.jnlp";
#	$data{$sample}->{fastqc_path} 				= "$indir/$sample/$sample\_fastqc/fastqc_report.html";
	$data{$sample}->{fastqc_path}                           = "$indir/$sample/$sample\_fastqc.html";

	my $totalReads = $data{$sample}->{r1_total_reads};

	if ($totalReads > 0){$data{$sample}->{percent_total_mapped} 	 		= $data{$sample}->{total_mapped} / $totalReads * 100;}
	else{$data{$sample}->{percent_total_mapped} = 0;}
	
	if ($totalReads > 0){$data{$sample}->{percent_total_mapped_uniquely} 	= $data{$sample}->{total_mapped_uniquely} / $totalReads * 100;}
	else{$data{$sample}->{percent_total_mapped_uniquely} = 0;}
	
	if ($data{$sample}->{total_mapped} > 0){$data{$sample}->{percent_dup_read_count}        	= $data{$sample}->{dup_read_count} / $data{$sample}->{total_mapped} * 100;}
	else{$data{$sample}->{percent_dup_read_count} = 0;}

	$data{$sample}->{insert_path}				= "$indir/$sample/$sample\_insert.png";
	$data{$sample}->{insert_median}				= $properties->{"insert.median"};
	}

#============================================================================== 

# Create html document.

print "<html><head></head><body>\n";
print "<h1>QC metrics for run $run</h1>\n"; 

print "<ul>\n";
print "<li>Analysis performed on <b>r1</b> reads.</li>\n";
print "<li>Analysis based on " . ($fraction * 100) . " % of the available data.</li>\n";
print "</ul>\n";

# Per sample
foreach my $sample (sort keys %data) {

	print "<h2>Sample: $sample</h2>\n";	

	# header
	print "<table border='1' cellspacing='1' cellpadding='5'>\n";
        print "<thead>\n";
        print "<tr style='background-color: rgb(204, 204, 204);'>\n";
        print "<th colspan='1' rowspan='2'>Est. total reads<br>(x 10<sup>6</sup>)</th>\n";

        print "<th colspan='1' rowspan='2'>Total yield<br>(Mb)</th>\n";

        print "<th colspan='2' rowspan='1'>Reads mapped</th>\n";

        print "<th colspan='1' rowspan='2'>Duplicates as<br>% of mapped</th>\n";
        print "<th colspan='4' rowspan='1'>% reads<br>with mean QV</th>\n";

        print "<th colspan='1' rowspan='2'>% reads<br>with &ge; 20<br>bad QVs</th>\n";
        print "<th colspan='1' rowspan='2'>Mapped output</th>\n";
        print "<th colspan='2' rowspan='1'>Fastqc analysis<br>based on</th>\n";
        print "<th colspan='1' rowspan='2'>IGV session</th>\n";
        print "</tr>\n";

        print "<tr style='background-color: rgb(184, 184, 184);'>\n";

        print "<th>Total</th>\n";
        print "<th>Unique</th>\n";

        print "<th>&ge; 15 </th>\n";
        print "<th>&ge; 20 </th>\n";
        print "<th>&ge; 25 </th>\n";
        print "<th>&ge; 30 </th>\n";
        print "<th>Fastq</th>\n";
        print "<th>BAM</th>\n";
        print "</tr>\n";


        print "</thead>\n";
        print "<tbody>\n";


	my $green	= 255;
	my $red		= 255;	
	my $blue 	= 255;	

	print "<tr>";
#	print "<td  style='background-color: rgb(224, 224, 224);'><b>XXX</b></td>";
		
	# Note: if subset of available data used, then read count, and 
	# total yield, need to be modified accordingly.
		
	my $r1_totalReads = ($data{$sample}->{r1_total_reads} / 1000000) / $fraction;
	# uncomment to colour
	# $green =  int( ($r1_totalReads / 25) * 255 );
        # $red = 255 - int(($r1_totalReads / 25) * 255);
	print "<td style='background-color: rgb($red, $green, $blue);'>" . &format($r1_totalReads, 1) . "</td>\n";

	my $r1_totalYield = ($data{$sample}->{r1_total_yield} / 1000000) / $fraction;
	my $totalYield = $r1_totalYield;
	# Uncomment to colour
	#$green =  int( ($totalYield / 2000) * 255 );
	#$red = 255 - int(($totalYield / 2000) * 255);
	print "<td style='background-color: rgb($red, $green, $blue);'>" . &format($totalYield, 1) 		. "</td>\n";

	# Get percentage mapped 
	my $pMapped = $data{$sample}->{percent_total_mapped};
	my $pUnique = $data{$sample}->{percent_total_mapped_uniquely};
	$green =  int( ($pMapped / 90) * 255 );
	$red = 255 - int(($pMapped / 90) * 255);
	print "<td style='background-color: rgb($red, $green, 0);'><b>" . &format($pMapped, 1)  . " %</b></td>\n";
      	print "<td style='background-color: rgb($red, $green, 0);'><b>" . &format($pUnique , 1) . " %</b></td>\n";

	# Percent duplicates 
        my $pMappedDup = $data{$sample}->{percent_dup_read_count};
	$green = 255 - int($pMappedDup / 100 * 255 );
        $red   = int($pMappedDup / 100 * 255);
	print "<td style='background-color: rgb($red, $green, 0);'>" . &format($pMappedDup,  1). " %</td>\n";

	my $r1_pMeanQV = $data{$sample}->{r1_percent_reads_meanqv_15plus}; 
	$green =  int( ( $r1_pMeanQV  / 100) * 255 );
        $red = 255 - int(( $r1_pMeanQV  / 100) * 255);
	print "<td style='background-color: rgb($red, $green, 0);'><a href='$data{$sample}->{r1_mean_QV_path}'>$r1_pMeanQV</a></td>\n"; 

	$r1_pMeanQV = $data{$sample}->{r1_percent_reads_meanqv_20plus};
        $green =  int( ( $r1_pMeanQV  / 100) * 255 );
        $red = 255 - int(( $r1_pMeanQV  / 100) * 255);
        print "<td style='background-color: rgb($red, $green, 0);'><a href='$data{$sample}->{r1_mean_QV_path}'>$r1_pMeanQV</a></td>\n";

	$r1_pMeanQV = $data{$sample}->{r1_percent_reads_meanqv_25plus};
        $green =  int( ( $r1_pMeanQV  / 100) * 255 );
        $red = 255 - int(( $r1_pMeanQV  / 100) * 255);
        print "<td style='background-color: rgb($red, $green, 0);'><a href='$data{$sample}->{r1_mean_QV_path}'>$r1_pMeanQV</a></td>\n";

	$r1_pMeanQV = $data{$sample}->{r1_percent_reads_meanqv_30plus};
        $green =  int( ( $r1_pMeanQV  / 100) * 255 );
        $red = 255 - int(( $r1_pMeanQV  / 100) * 255);
        print "<td style='background-color: rgb($red, $green, 0);'><a href='$data{$sample}->{r1_mean_QV_path}'>$r1_pMeanQV</a></td>\n";

	my $r1_pBadQV = $data{$sample}->{r1_percent_reads_badqv_10plus};
	$green = 255 - int( ($r1_pBadQV  / 100) * 255 );
        $red =  int(($r1_pBadQV  / 100) * 255);	
	print "<td style='background-color: rgb($red, $green, 0)';><a href='$data{$sample}->{r1_bad_QV_path}'>$r1_pBadQV</a></td>\n";		


        
	print "<td><a href='$data{$sample}->{bam_path}'>BAM</a> (<a href='$data{$sample}->{bai_path}'>BAI)</a></td>\n";

	print "<td><b><a href='$data{$sample}->{r1_raw_fastqc_path}'>Report</a></b></td>\n";

	print "<td><b><a href='$data{$sample}->{fastqc_path}'>Report</a></b></td>\n";
	print "<td style='background-color: rgb(153, 255, 153);'><b>	<a href='$data{$sample}->{igv_path}'>Launch IGV</a>	</b></td>\n";
	print "</tr>\n";	


	print "</tbody>\n";
        print "</table>\n";
	}

print "</body></html>\n";



###############################################################################

sub format {

        my $string = shift;
        my $value = shift;

        return $string if $string !~ /^\d*\.{0,1}\d+$/;

        return $number->format($number->roundup($string, $value));


        } # End of method.

###############################################################################

sub getProperties {

        my $infile = shift;

        my %properties;
        open (IN, $infile) or die "ERROR: could not open $infile. ";
        while (<IN>) {
                chomp;
		next if /^\s*$/;
		next if /^#/;
                /^(\S+)=(\S+)$/ or die "ERROR: regex failed with '$_'. ";
                $properties{$1} = $2;
                }
        close (IN) or die "ERROR: Could nopt close $infile.\n";

        return \%properties;

        } # End of method.

###############################################################################
1;

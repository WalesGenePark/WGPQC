#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Std;
use File::Basename;

my %options;
getopts("i:b:p:c:r:m:", \%options);
my $infile = $options{i} or &usage;
my $binsize = $options{b} or &usage;
my $percent = $options{p} || "false";
my $isCum = $options{c} || "false";
my $reverse = $options{r} || "false";
my $max = $options{m} || "null";
sub usage {die "Usage: " . basename($0) . 
	"\n\t[-i data infile] " . 
	"\n\t[-b binsize] " . 
	"\n\t[-p show as percentage, if true (default, false)] " . 
	"\n\t[-c cumulative plot if true (default, false)] " .
	"\n\t[-m max value to be binned (optional)]" .  
	"\n\t[-r reverse cumulative plot if true (default false)]\n"
	;} 


# First store as fine grain histogram (assumes value to be binned as no more than 4 decimal places).
my %map;
open (IN, $infile) or die "ERROR: Could not open $infile.\n";
while (<IN>) {
	chomp;
	next if /^\s*$/;
	next if /^#/; 
	/^([\.\d]+)$/ or die "ERROR: regex failed with '$_'.";
	$map{sprintf("%.4f", $_)}++;
	}
close (IN) or die "ERROR: could not close $infile.\n";


# Now bin according to specified binsize.
my @final;
my $n = 0;
foreach my $x (keys %map) {

	my $bin = int($x/$binsize);
	if ($max ne "null" && $bin >= $max) {
		$bin = $max;
		}

	$final[$bin] += $map{$x};
	$n += $map{$x};
	}

# Print to STDOUT.

if ($isCum =~ /t(rue)*/i && $reverse =~ /t(rue)*/i) {

        my $i = 0;
	my $x = $n;
	if ($percent =~ /t(rue)*/i) {
		$x = 100;
		}
        foreach my $value (@final) {
        
                # If value stored in bin then print
                if (defined $value) {   

                        # If percentage, convert first.
                        $value = $value / $n * 100 if $percent =~ /t(rue)*/i;
                
			$x -= $value;

                        print $binsize*$i . "\t$x\n";

                        }
                # No value associated with bin therefore print same as before.
                else {
                        print $binsize*$i . "\t$x\n";
                        }
                $i++;
                }
	

	}

elsif ($isCum =~ /t(rue)*/i) {
	
	 my $i = 0; 
        my $x = 0;
        foreach my $value (@final) {
        
                # If value stored in bin then print
                if (defined $value) {   

                        # If percentage, convert first.
                        $value = $value / $n * 100 if $percent =~ /t(rue)*/i;
                
                        $x += $value;

                        print $binsize*$i . "\t$x\n";

                        }
                # No value associated with bin therefore print same as before.
                else {
                        print $binsize*$i . "\t$x\n";
                        }
                $i++;
                }
	


	} 


else {

	my $i = 0;
	foreach my $value (@final) {
	
		# If value stored in bin then print
		if (defined $value) {	

			# If percentage, convert first.
			$value = $value / $n * 100 if $percent =~ /t(rue)*/i;

			print $binsize*$i . "\t$value\n";
	
			} 
		# No value associated with bin therefore print zero.
		else {
			print $binsize*$i . "\t0\n";
			}
		$i++;
		}

	}

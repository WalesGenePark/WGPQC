#!/usr/bin/perl -w

use strict;
use warnings;
use POSIX;
use Kea::Number;
use File::Basename;
use Getopt::Std;

my $number = Kea::Number->new;


my %options;
getopts("i:", \%options);
my $infile = $options{i} or &usage;
sub usage {die "USAGE: " . basename($0) . " [-i infile].\n";}

my @data;

open (IN, $infile) or die "ERROR: could not open $infile.\n";
while (<IN>) {
	chomp;
	next if /^#/;
	/^([-\.\d]+)$/ or die "ERROR: regex failed with $_.\n";
	push(@data, $_);
	}
close (IN) or die "ERROR: could not close $infile.\n";

@data = sort {$a <=> $b} @data;


my $n 			= scalar(@data);
my $sum 		= getSum(\@data);
#my $n50 		= getN50(\@data, $sum);
my $mean		= $sum/$n;
my $deviates 		= getDeviates(\@data, $mean);
my $squaredDeviates 	= getSquares($deviates);
my $sumOfSquares 	= getSum($squaredDeviates);
my $popVar		= $sumOfSquares/$n; 
my $popSD 		= sqrt($popVar);
my $sampleVar		= $sumOfSquares/($n-1);
my $sampleSD		= sqrt($sampleVar);	
my $mode 		= getMode(\@data);
my $median		= getMedian(\@data);
# Alternative: calculated with R type 6 (Minitab) quantile method.
#my $median		= getQuantile(\@data, 0.5);
my $q1			= getQuantile(\@data, 0.25);
my $q3			= getQuantile(\@data, 0.75);
my $min			= $data[0];
my $max 		= $data[$n-1];
my $range		= $max-$min;

printf(
	"%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", 
	&format($n, 0),
	&format($sum,0),
	&format($mean, 2),
#	&format($n50,0),
	&format($popSD, 2),
        &format($sampleSD, 2),
	&format($median, 2),
	&format($mode, 2),
	&format($q1,2),
	&format($q3,2),
	&format($min,0),
	&format($max,0),
	&format($range,0)
	);

################################################################################

sub format {
	
	my $string = shift;
	my $value = shift;
	
	return $string if $string !~ /^\d*\.{0,1}\d+$/;

	return $number->format($number->roundup($string, $value));	


	} # End of method.

################################################################################

sub getMode {
	
	my $data = shift;

	my %map;
	foreach (@$data) {
		$map{$_}++;
		}

	my $mode =  (sort {$map{$b} <=> $map{$a}} keys %map)[0];

	if ($map{$mode} == 1) {
		return "na";
		} else {
		return $mode;
		}

	} # End of method.

################################################################################

sub getN50 {
	
	my $data = shift;
	my $sum = shift;

	my $halfSum = $sum / 2;

	for (my $i = @$data-1; $i >= 0; $i--) {
	
		$sum -= $data->[$i];
		return $data->[$i] if $halfSum > $sum;
		}

	die "ERROR: failed to find N50.\n";

	} # End of method.

################################################################################

sub getSum {
	
	my $data = shift;
	
	my $x = 0;
	foreach (@$data) {
		$x += $_;
		}

	return $x;

	} # End of method.

################################################################################

sub getDeviates {
	
	my $data = shift;
	my $mean = shift;

	my @deviates;

	foreach (@$data) {
		push(@deviates, $_ - $mean);
		}
	
	return \@deviates;

	} # End of method.

################################################################################

sub getSquares {
	
	my $data = shift;
	
	my @squares;

	foreach (@$data) {
		push(@squares, $_**2);
		}	

	return \@squares;

	} # End of method.

################################################################################

sub getMedian {
	
	my $data = shift;

	if (@$data % 2) {
		return $data->[@$data/2];
		}
	else {
		return ($data->[@$data/2-1] + $data->[@$data/2]) / 2;
		} 

	} # End of method.

################################################################################

sub getQuantile {
	
	my $data = shift;
	my $quantile = shift;
	
	my $n = @$data;

	# Multiply quantile by number of observations plus 1.
	my $number = $quantile * ($n + 1);
	
	# Next step depends on whether number is a whole number or not.
	my $fraction = getFraction($number);

	if ($fraction == 0) {
		# number is a whole number. Therefore our required value already
		# exists within the observation collection.
		return $data->[$number - 1];
		}
	elsif ($number >= $n) {
		# Number represents largest observation in collection. 
		return $data->[$number - 1];
		}
	elsif ($number <= 0) {
		# Number represents smallest number in collection.
		return $data->[0];
		}
	else {
		# number is a fraction number. Therefore our required value is the
		# weighted average of two values within the observation collection.
		my $x1 = $data->[floor($number) - 1];
		my $x2 = $data->[floor($number)];

		return (1-$fraction) * $x1 + ($fraction) * $x2;
		}

	} # End of method.

################################################################################

sub getFraction {
	
	my $number = shift;
	
	if ($number =~ /^\d+$/) {
		return 0;
		} 
	else {
		$number =~ /\.(\d+)$/;
		return "0.$1";
		}

	} # End of method.

################################################################################
1;

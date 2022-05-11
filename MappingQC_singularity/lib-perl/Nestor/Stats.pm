#!/usr/bin/perl -w

package Nestor::Stats;

use strict;
use warnings;
use POSIX;
use Kea::Number;
#use Kea::Object;
#our @ISA = qw(Kea::Object Nestor::Stats);

my $number = Kea::Number->new;

###############################################################################

sub new {

	my $className = shift;
	my %args = @_;

	my $data	= Kea::Object->check($args{-data});
	
	my $self = {
		_data 		=> $data
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

###############################################################################

sub print {
	my $self = shift;
	my $data = $self->{_data};

	die "ERROR: no data!" if scalar(@$data) == 0;

	my @sorted = sort {$a <=> $b} @$data;


	my $n 			= scalar(@sorted);
	my $sum 		= getSum(\@sorted);
#	my $n50 		= getN50(\@sorted, $sum);
	my $mean		= $sum/$n;
	my $deviates 		= getDeviates(\@sorted, $mean);
	my $squaredDeviates 	= getSquares($deviates);
	my $sumOfSquares 	= getSum($squaredDeviates);
	my $popVar		= $sumOfSquares/$n; 
	my $popSD 		= sqrt($popVar);
	my $sampleVar		= $sumOfSquares/($n-1);
	my $sampleSD		= sqrt($sampleVar);	
	my $mode 		= getMode(\@sorted);
	my $median		= getMedian(\@sorted);
	# Alternative: calculated with R type 6 (Minitab) quantile method.
	#my $median		= getQuantile(\@data, 0.5);
	my $q1			= getQuantile(\@sorted, 0.25);
	my $q3			= getQuantile(\@sorted, 0.75);
	my $min			= $sorted[0];
	my $max 		= $sorted[$n-1];
	my $range		= $max-$min;

	printf(
		"\n\t===============================\n" . 
		"\t%-10s %20s\n" .
		"\t===============================\n" . 
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
	#	"\t%-10s %20s\n" .
	#	"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
        	"\t%-10s %20s\n" .
#		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t%-10s %20s\n" .
		"\t===============================\n",
		"Statistic",	"Value",
		"n", 			&format($n, 0),
		"sum",			&format($sum,0),
		"mean",			&format($mean, 2),
#		"N50",			&format($n50,0),
#		"pop var",		&format($popVar, 2),
		"pop sd",		&format($popSD, 2),
#		"sample var",		&format($sampleVar, 2),
		"sample sd",            &format($sampleSD, 2),
		"median",		&format($median, 2),
		"mode",			&format($mode, 2),
		"q1 (R 6)",		&format($q1,2),
		"q3 (R 6)",		&format($q3,2),
		"min",			&format($min,0),
		"max",			&format($max,0),
		"range",		&format($range,0)
		);
	} # End of method.

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

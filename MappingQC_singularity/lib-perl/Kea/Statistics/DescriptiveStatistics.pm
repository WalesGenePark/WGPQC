#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 
#    Copyright (C) 2008, University of Liverpool.
#    Author: Kevin Ashelford.
#
#    Contact details:
#    Email: k.ashelford@liv.ac.uk
#    Address:  School of Biological Sciences, University of Liverpool, 
#    Biosciences Building, Crown Street, Liverpool, UK. L69 7ZB
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#===============================================================================

# CLASS NAME
package Kea::Statistics::DescriptiveStatistics;
use Kea::Object;
our @ISA =qw(Kea::Object);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Statistics::QuantileCalculator;

################################################################################

# CLASS FIELDS

################################################################################



# CONSTRUCTOR

sub new {
	
	my $className = shift;
	my %args = @_;
	
	
	#ÊGet data
	#===========================================================================
	
	my @data;
	if (exists $args{-data}) {
		@data = @{$args{-data}};
		}
	else {
		Kea::Object->throw("Missing data: use -data flag.");	
		}
	
	if (@data < 3) {
		Kea::Object->throw("Too few data-points: " . @data . ".");	
		}
	
	#===========================================================================
	
	
	
	
	
	
	my $statisticsType = $args{-statisticsType} || "sample";
	
	if ($statisticsType !~ /^(population)|(sample)$/i) {
		Kea::Object->throw(
			"$statisticsType is an unrecognised statistics type.  " .
			"Should be either 'population' or 'sample'"
			);
		} 
	
	# Sort.
	my @sorted = sort {$a <=> $b} @data;
	
	# Size
	my $n = @sorted;
	
	# Sum
	my $sum = 0;
	foreach my $x (@sorted) {
		$sum = $sum + $x;
		}
	
	# Mean
	my $mean = $sum / $n;
	
	# Deviates
	my @deviates;
	foreach my $x (@sorted) {
		push(@deviates, $x - $mean);	
		}
	
	# Squared deviates.
	my @squaredDeviates;
	foreach my $deviate (@deviates) {
		push(@squaredDeviates, $deviate * $deviate);
		}
	
	# Sum of squares.
	my $sumOfSquares = 0;
	foreach my $squaredDeviate (@squaredDeviates) {
		$sumOfSquares = $sumOfSquares + $squaredDeviate;
		}
	
	# Variance.
	my $variance;
	if ($statisticsType eq "population") {
            $variance = $sumOfSquares / $n;
            }
	else {
		$variance = $sumOfSquares / ($n - 1);
		}
	
	# standard deviation.
	my $sd = sqrt($variance);
	
	# Min.
	my $min = $sorted[0];
	
	# Max.
	my $max = $sorted[$n-1];
	
	# Quantiles.
	my $qc = Kea::Statistics::QuantileCalculator->new(@sorted);
	my $median = $qc->getQuantile(0.5);
	my $q1 = $qc->getQuantile(0.25);
	my $q3 = $qc->getQuantile(0.75);
	
	# Range.
	my $range = $max - $min;
	
	
	
	
	my $self = {
		_N => $n,
		_sum => $sum,
		_mean => $mean,
		_min => $min,
		_max => $max,
		_median => $median,
		_Q1 => $q1,
		_Q3 => $q3,
		_range => $range,
		_SD => $sd,
		_variance => $variance,
		_sumOfSquares => $sumOfSquares
		};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

################################################################################

# PUBLIC METHODS

sub getN {return shift->{_N};} # End of method.

sub getSum {return shift->{_sum};} # End of method.

sub getArithmeticMean {return shift->{_mean};} # End of method.

sub getMedian {return shift->{_median};} # End of method.

sub getMinimum {return shift->{_min};} # End of method.

sub getMaximum {return shift->{_max};} # end of method.

sub getRange {return shift->{_range};} # end of method.

sub getQ1 {return shift->{_Q1};} # end of method.

sub getQ3 {return shift->{_Q3};} # end of method.

sub getStandardDeviation {return shift->{_SD};} # End of method

sub getVariance {return shift->{_variance};} # End of method.

sub getSumOfSquares {return shift->{_sumOfSquares};} # End of method.

sub toString {
	
	my $self = shift;
	
	my $n = $self->getN;
	my $sum = $self->getSum;
	my $mean = $self->getArithmeticMean;
	my $median = $self->getMedian;
	my $min = $self->getMinimum;
	my $max = $self->getMaximum;
	my $range = $self->getRange;
	my $q1 = $self->getQ1;
	my $q3 = $self->getQ3;
	my $sd = $self->getStandardDeviation;
	my $variance = $self->getVariance;
	my $sumOfSquares = $self->getSumOfSquares;
	
	return sprintf (
		"N\t= %s\n" .
		"Sum\t= %s\n" .
		"Mean\t= %.2f\n" .
		"Median\t= %s\n" .
		"Min\t= %s\n" .
		"Max\t= %s\n" .
		"Range\t= %s\n" .
		"Q1\t= %s\n" .
		"Q3\t= %s\n" .
		"SD\t= %.2f\n" .
		"Var\t= %.2f\n" .
		"SS\t= %.2f\n",
		$n, $sum, $mean, $median, $min, $max, $range, $q1, $q3, $sd, $variance, $sumOfSquares
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


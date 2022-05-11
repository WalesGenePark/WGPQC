#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 10/02/2008 08:41:36 
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
package Kea::Statistics::Toolkit;
use Kea::Object;
our @ISA = qw(Kea::Object);

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
	my $self = {};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub getN {
	my $self = shift;
	my @data = @_;
	return scalar(@data);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSum {
	my $self = shift;
	my @data = @_;
	my $sum = 0;
	foreach (@data) {
		$sum += $_;
		}
	return $sum;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getArithmeticMean {

	my $self = shift;
	my @data = @_;
	
	return $self->getSum(@data) / $self->getN(@data);

		} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMode {

	my $self 		= shift;
    my $arrayref 	= \@_;
	
    my (%count, @result);

    # Use the %count hash to store how often each element occurs
    foreach (@$arrayref) { $count{$_}++ }

    # Sort the elements according to how often they occur,
    # and loop through the sorted list, keeping the modes.
    foreach (sort { $count{$b} <=> $count{$a} } keys %count) {
        last if @result && $count{$_} != $count{$result[0]};
        push(@result, $_);
    }

    # Uncomment the following line to return undef for nonunique modes.
    # return undef if @result > 1;

    # Return the odd median of the modes.
    return odd_median(\@result);       # odd_median() is defined earlier.
}

# $om = odd_median(\@array) computes the odd median of an array of
# numbers.
#
sub odd_median {
    my $arrayref = shift;
    my @array = sort @$arrayref;
    return $array[(@array - (0,0,1,0)[@array & 3]) / 2];
}

#///////////////////////////////////////////////////////////////////////////////

sub getMedian {

	my $self 	= shift;
	my @sorted 	= sort {$a <=> $b} @_;

	my $qc = Kea::Statistics::QuantileCalculator->new(@sorted);
	return $qc->getQuantile(0.5);

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMinimum {
	
	my $self = shift;
	my @data = @_;
	my @sorted = sort {$a <=> $b} @data;
	return $sorted[0];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMaximum {
	
	my $self = shift;
	my @data = @_;
	my @sorted = sort {$a <=> $b} @data;
	return $sorted[@sorted-1];
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRange {
	
	my $self = shift;
	my @data = @_;
	my @sorted = sort {$a <=> $b} @data;
	return $sorted[@sorted-1] - $sorted[0];
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQ1 {

	my $self 	= shift;
	my @sorted 	= sort {$a <=> $b} @_;

	my $qc = Kea::Statistics::QuantileCalculator->new(@sorted);
	return $qc->getQuantile(0.25);
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQ3 {

	my $self 	= shift;
	my @sorted 	= sort {$a <=> $b} @_;

	my $qc = Kea::Statistics::QuantileCalculator->new(@sorted);
	return $qc->getQuantile(0.75);
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDeviates {
	
	my $self = shift;
	my @data = @_;
	
	my $mean = $self->getArithmeticMean(@data);
	
	# Deviates
	my @deviates;
	foreach my $x (@data) {	
		push(@deviates, $x - $mean);	
		}
	
	return @deviates;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSquaredDeviates {
	
	my $self = shift;
	my @data = @_;
	
	my @deviates = $self->getDeviates(@data);
	
	my @squaredDeviates;
	foreach my $deviate (@deviates) {
		push(@squaredDeviates, $deviate**2);
		}
	
	return @squaredDeviates;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSumOfSquares {
	
	my $self = shift;
	my @data = @_;
	
	my @squaredDeviates = $self->getSquaredDeviates(@data);
	
	my $sumOfSquares = 0;
	foreach my $squaredDeviate (@squaredDeviates) {
		$sumOfSquares += $squaredDeviate;
		}
	
	return $sumOfSquares;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getVariance {
	
	my $self 	= shift;
	my $df		= shift;
	my @data 	= @_;
	
	my $sumOfSquares = $self->getSumOfSquares(@data);
	my $n = @data;
	
	return $sumOfSquares / ($n - $df);
	
	} # End of method.	

#///////////////////////////////////////////////////////////////////////////////

sub getStandardDeviation {
	
	my $self 	= shift;
	my $df		= shift;
	my @data	= @_;
	
	my $variance = $self->getVariance($df, @data);
	
	return sqrt($variance);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub get95ConfidenceInterval {
	
	my $self 	= shift;
	my $df 		= shift;
	my @data 	= @_;
	
	my $mean = $self->getArithmeticMean(@data);
	my $sd = $self->getStandardDeviation($df, @data);
	
	my $lower = $mean - 1.96 * $sd;
	my $upper = $mean + 1.96 * $sd;
	
	return ($lower, $upper);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


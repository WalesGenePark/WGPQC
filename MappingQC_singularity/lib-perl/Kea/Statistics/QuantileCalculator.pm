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
package Kea::Statistics::QuantileCalculator;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;
use POSIX;

use constant TRUE => 1;
use constant FALSE => 0;
use constant MIN_OBSERVATIONS => 3;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className 	= shift;
	my @data 		= @_;
	
	my $n = @data;
	
	# Check size.
	if ($n < MIN_OBSERVATIONS) {
		Kea::Object->throw(
			"Too few observations ($n) passed to QuantileCalculator.  " .
			"Minimum allowed: " . MIN_OBSERVATIONS
			);
		} 
	
	# sort array.
	my @sorted = sort {$a <=> $b} @data;
	
	my $self = {
		_data => \@sorted,
		_N => $n
		};
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

sub getQuantile {
	
	my $self 		= shift;
	my $quantile 	= $self->checkIsNumber(shift);
	
	my $n = $self->{_N};
	my @observations = @{$self->{_data}};
	
	# First check percentage ok.
	if ($quantile < 0 || $quantile > 1) {
		$self->throw("$quantile is not a valid quantile number.");
		}		
	
	# Multiply quantile by number of observations plus 1.
	my $number = $quantile * ($n + 1);
	
	# Next step depends on whether number is a whole number or not.
	my $fraction = $number % 1;
	if ($fraction == 0) {
		# number is a whole number. Therefore our required value already
		# exists within the observation collection.
		return $observations[$number - 1];
		}
	elsif ($number >= $n) {
		# Number represents largest observation in collection. 
		return $observations[$number - 1];
		}
	elsif ($number <= 0) {
		# Number represents smallest number in collection.
		return $observations[0];
		}
	else {
		# number is a fraction number. Therefore our required value is the
		# weighted average of two values within the observation collection.
		my $firstObservation = $observations[floor($number) - 1];
		my $secondObservation = $observations[floor($number)];

		return (1-$fraction) * $firstObservation + ($fraction) * $secondObservation;
		}

	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;
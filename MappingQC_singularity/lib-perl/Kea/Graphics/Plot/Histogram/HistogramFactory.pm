#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 28/05/2008 14:52:21
#    Copyright (C) 2008, University of Liverpool.
#    Author: Kevin Ashelford.
#
#    Contact details:
#    Email:   k.ashelford@liv.ac.uk
#    Address: School of Biological Sciences, University of Liverpool, 
#             Biosciences Building, Crown Street, Liverpool, UK. L69 7ZB
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
package Kea::Graphics::Plot::Histogram::HistogramFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;
use POSIX;
#use diagnostics;
#no warnings "recursion";

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Graphics::Plot::Histogram::_Histogram; 
use Kea::Graphics::Plot::Histogram::_Bin;
use Kea::Graphics::Plot::Histogram::BinCollection;

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

my $fillBins = sub {
	
	my $self 		= shift;
	my $sortedData 	= shift;
	my $start 		= shift;
	my $binSize 	= shift;
	
	my $end = $sortedData->[@$sortedData - 1];
	my $numberOfBins = floor($end/$binSize) + 1;
	
	# Create bins.
	my $binCollection = Kea::Graphics::Plot::Histogram::BinCollection->new("");
	
	my $lowerLimit = $start;
	for (my $i = 0; $i < $numberOfBins; $i++) {
	
		my $bin = Kea::Graphics::Plot::Histogram::_Bin->new(
			-binSize 	=> $binSize,
			-lowerLimit => $lowerLimit 
			);
	
		$binCollection->add($bin);
		$lowerLimit += $binSize;
		
		#print $bin->toString . "\n";
		
		}
	
	# Fill bins
	my @bins = $binCollection->getAll;
	foreach my $value (@$sortedData) {
		
		while (@bins > 0 && $value >= $bins[0]->getUpperLimit) {
			shift(@bins);
			}
		
		if (@bins == 0) {
			$self->throw("Value ($value) too great for available bins.");
			}
		
		if ($value >= $bins[0]->getLowerLimit && $value < $bins[0]->getUpperLimit) {
			$bins[0]->increment;
			}
		else {
			$self->throw(
				"Selected bin (" .
				$bins[0]->getLowerLimit .
				" <= x < " .
				$bins[0]->getUpperLimit . 
				") not appropriate for value ($value).");
			}
		
		}
	
	return $binCollection;
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub createHistogram {

	my $self = shift;
	my %args = @_;
	
	my $data 	= $self->checkIsArrayRef($args{-data});
	my $start 	= $self->checkIsInt($args{-start});
	my $binSize = $self->checkIsNumber($args{-binSize});
	
	my @sortedData = sort {$a <=> $b} @$data;
	
	# Check parameters are sensible.
	if (@$data < 1) {
		$self->throw("Too few data values!");
		}
	if ($binSize <= 0) {
		$self->throw("Bin size too small.");
		}
	if ($start > $sortedData[0]) {
		$self->warn(
			"Requested start (" .
			$start . 
			") is greater than smallest datapoint (" .
			$sortedData[0] . 
			").");
		}
	
	
	# Distribute data into bins with specified bin size.
	my $binCollection = $self->$fillBins(\@sortedData, $start, $binSize);
	
	
	# Return new histogram.
	return Kea::Graphics::Plot::Histogram::_Histogram->new($binCollection);

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

#sub _binData {
#	
#	my $self = shift;
#	my $data 		= shift; 
#	my $binSize 	= shift;
#	my $i 			= shift; 
#	my $lowerLimit 	= shift;
#	my $upperLimit 	= shift; 
#	my $bins 		= shift;
#		
#	# Create new bin and add to array.
#	my $bin = Kea::Graphics::Plot::Histogram::_Bin->new($binSize, $lowerLimit);
#	push(@$bins, $bin); 
#	
#	# Identify those data values that can be binned in currect bin.
#	while ($data->[$i] < $upperLimit) {
#		$bin->increment; 
#		$i++;
#		if ($i >= @$data) {return;} # No values remain, so end recursion.
#		}
#	
#	# If get to this point,data exceeds upper limit of current bin.
#	$lowerLimit = $upperLimit;
#	$upperLimit = $upperLimit + $binSize; # Upper limit for next bin.
#	
#	$self->_binData(
#		$data,
#		$binSize,
#		$i,
#		$lowerLimit,
#		$upperLimit,
#		$bins
#		); # Recursive function.
#
#	
#	
#	} # End of method.
#
##///////////////////////////////////////////////////////////////////////////////
#
#sub _fillBins {
#
#	my $self = shift;
#	my $data = shift;
#	my $start = shift;
#	my $binSize = shift;
#	
#	# Sort data in ascending order.
#	my @sortedData = sort {$a <=> $b} @$data;
#
#	# Distribute data to bins.
#	my $lowerLimit = $start;
#	my $upperLimit = $lowerLimit + $binSize; 		# Get upper limit of first bin.
#	my @bins; 										# Initialise array for storing bins.
#	
#	$self->_binData(
#		$data,
#		$binSize,
#		0,
#		$lowerLimit,
#		$upperLimit,
#		\@bins
#		); # Start recursive function.
#	
#	# Return bins.
#	return \@bins;
#
#	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


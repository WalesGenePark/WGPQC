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

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::Utilities::HomopolymerRepeats;

## Purpose		: 

use strict;
use warnings;
use Carp;

use constant TRUE => 1;
use constant FALSE => 0;
use constant SENSE => "sense";
use constant ANTISENSE => "antisense";

use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
sub new {
	my $className = shift;
	my %args = @_;
	my $self = {_record => $args{-record}};
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

sub getRepeatLocations {
	my $self = shift;
	my %args = @_;
	
	my $minLength = $args{-minLength} || 3;
	
	my $record = $self->{_record};
	
	# Get sequence.
	my $sequence = $record->getSequence;
	
	# Convert to array of bases.
	my @bases = split("", $sequence);
	
	# Identify all repeat locations.
	#===========================================================================
	
	# Will store location of latest repeat. Initially set to first base of sequence.
	my $repeatLocation = Kea::IO::Location->new(1,1);
	
	# Array for storing repeat locations.	
	my @repeatLocations;
	my $base = $bases[0]; #  Initially set to first base.
	for (my $i = 1; $i < @bases; $i++) {
		# Base matches
		if ($base eq $bases[$i]) {
			# modify location object to accommodate this base also.
			$repeatLocation->incrementEnd;
			}
		# Base does not match
		else {
			# Store current repeat location object PROVIDED it is of sufficient
			# length.
			if ($repeatLocation->getLength >= $minLength) {
				push(@repeatLocations, $repeatLocation);
				} 
			
			# ...and reset with position of current base.
			$repeatLocation =
				Kea::IO::Location->new(
					1 + $i, # store absolute position
					1 + $i
					);
			$base = $bases[$i];
			}
		} # End of for loop - no more bases in sequence to process.
	# Store remaining repeat (provided of right length).
	push(@repeatLocations, $repeatLocation) if $repeatLocation->getLength >= $minLength;
	
	# Order repeats in descending order of length.
	@repeatLocations = sort {($b->getLength) <=> ($a->getLength)} @repeatLocations;
	return @repeatLocations;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


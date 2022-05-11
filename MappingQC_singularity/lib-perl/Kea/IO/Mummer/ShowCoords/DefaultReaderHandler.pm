#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 04/06/2008 11:41:40
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
package Kea::IO::Mummer::ShowCoords::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Mummer::ShowCoords::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Mummer::ShowCoords::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Alignment::Mummer::ShowCoords::AlignmentCollection;
use Kea::Alignment::Mummer::ShowCoords::_Alignment;
use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $alignmentCollection =
		Kea::Alignment::Mummer::ShowCoords::AlignmentCollection->new("");
	
	my $self = {
		_alignmentCollection => $alignmentCollection
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $getLocationAndOrientation = sub {

	my $self = shift;
	my $start = shift;
	my $end = shift;

	my $orientation;
	my $location;
	if ($start < $end) {
		$location = Kea::IO::Location->new($start, $end);
		$orientation = SENSE;
		}
	else {
		$location = Kea::IO::Location->new($end, $start);
		$orientation = ANTISENSE;
		}
	
	return ($location, $orientation);
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub _nextLine {

	my (
		$self,
		$subjectStart, 		# S1 - start relative to subject (guide) sequence
		$subjectEnd, 		# E1 - end relative to subject (guide) sequence
		$queryStart, 		# S2
		$queryEnd, 			# E2
		$subjectLength,		# LEN 1
		$queryLength,		# LEN 2
		$percentId,			# % IDY
		$subjectId,			# first TAG
		$queryId			# second TAG - contig id.
		) = @_;
	
	my ($queryLocation, $queryOrientation) =
		$self->$getLocationAndOrientation(
			$queryStart,
			$queryEnd
			);
		
	my ($subjectLocation, $subjectOrientation) = 	
		$self->$getLocationAndOrientation(
			$subjectStart,
			$subjectEnd
			);
		
	if ($queryLocation->getLength != $queryLength) {
		$self->throw("$queryId has inconsistent length: $queryLength.");
		}
	if ($subjectLocation->getLength != $subjectLength) {
		$self->throw("$subjectId has inconsistent length: $subjectLength.");
		}
		
	$self->{_alignmentCollection}->add(
		Kea::Alignment::Mummer::ShowCoords::_Alignment->new(
			-queryId 			=> $queryId,
			-subjectId 			=> $subjectId,
			-percentId 			=> $percentId,
			-queryLocation 		=> $queryLocation,
			-subjectLocation 	=> $subjectLocation,
			-queryOrientation 	=> $queryOrientation,
			-subjectOrientation => $subjectOrientation
			)
		);
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAlignmentCollection {
	return shift->{_alignmentCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


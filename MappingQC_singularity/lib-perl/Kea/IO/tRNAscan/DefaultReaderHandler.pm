#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 15/05/2008 15:44:54
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
package Kea::IO::tRNAscan::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::tRNAscan::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::tRNAscan::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::tRNAscan::tRNAResultCollection;
use Kea::IO::tRNAscan::tRNAResultFactory;
use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my $tRNAResultCollection = Kea::IO::tRNAscan::tRNAResultCollection->new("");
	
	my $self = {
		_tRNAResultCollection => $tRNAResultCollection
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

sub _nextLine {

	my $self 		= shift;
	my $id 			= shift;	# Sequence name
	my $number 		= shift;	# tRNA number
	my $start		= shift;	# tRNA bounds start
	my $end			= shift;	# tRNA bounds end
	my $type		= shift;	# tRNA type
	my $anticodon	= shift;	# Anticodon
	my $intronStart	= shift;	# Intron bounds start
	my $intronEnd	= shift;	# Intron bounds end
	my $coveScore	= shift;	# Cove score
	
	#ÊCreate location objects and ascertain orientation.
	my $orientation = SENSE;
	my $location;
	if ($start > $end) {
		$location = Kea::IO::Location->new($end, $start);
		$orientation = ANTISENSE;
		}
	else {
		$location = Kea::IO::Location->new($start, $end);
		}
	
	
	# Intron location.
	my $intronLocation;
	if ($intronStart > $intronEnd) {
		$intronLocation = Kea::IO::Location->new($intronEnd, $intronStart);
		if ($orientation ne ANTISENSE) {
			$self->warn(
				"intron orientation does not coincide with that of tRNA, " .
				"as ascertained from location information."
				);
			}
		}
	else {
		$intronLocation = Kea::IO::Location->new($intronStart, $intronEnd);
		}
	
	$self->{_tRNAResultCollection}->add(
		Kea::IO::tRNAscan::tRNAResultFactory->createResult(
			-id 			=> $id,
			-number 		=> $number,
			-location 		=> $location,
			-orientation	=> $orientation,
			-type 			=> $type,
			-anticodon		=> $anticodon,
			-intronLocation => $intronLocation,
			-coveScore 		=> $coveScore
			)
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub gettRNAResultCollection {
	return shift->{_tRNAResultCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


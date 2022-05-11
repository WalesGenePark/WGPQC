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
package Kea::IO::Blast::Tabular::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Blast::Tabular::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Blast::Tabular::IReaderHandler);

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE	=> 0;

use Kea::Alignment::Blast::Report::BlastAlignment;
use Kea::Alignment::Blast::Report::BlastAlignmentCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
	my $alignmentCollection =
		Kea::Alignment::Blast::Report::BlastAlignmentCollection->new;
	
	my $self = {
		_blastAlignmentCollection => $alignmentCollection
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

sub _nextAlignment {

	my (
		$self,
		
		$queryId,				# Query id
		$subjectId,				# Subject id
		$percentIdentity,		# % identity
		$alignmentLength,		# alignment length
		$mismatches,			# mismatches
		$gapOpenings,			# gap openings
		$queryStart,			# query start
		$queryEnd,				# query end
		$subjectStart,			# subject start
		$subjectEnd,			# subject end
		$eValue,				# e-value
		$bitScore				# bit score
		
		) = @_;
	
	my $alignment = Kea::Alignment::Blast::Report::BlastAlignment->new(
		-queryId 			=> $queryId,
		-subjectId 			=> $subjectId,
		-percentIdentity 	=> $percentIdentity,
		-alignmentLength 	=> $alignmentLength,
		-mismatches 		=> $mismatches,
		-gapOpenings 		=> $gapOpenings,
		-queryStart 		=> $queryStart,
		-queryEnd 			=> $queryEnd,	
		-subjectStart 		=> $subjectStart,
		-subjectEnd 		=> $subjectEnd,
		-eValue 			=> $eValue,
		-bitScore 			=> $bitScore
		);
	
	$self->{_blastAlignmentCollection}->add($alignment);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBlastAlignmentCollection {
	return shift->{_blastAlignmentCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


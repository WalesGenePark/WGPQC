#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/03/2008 11:54:23 
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
package Kea::IO::Newbler::AllDiffs::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Newbler::AllDiffs::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Newbler::AllDiffs::IReaderHandler);

## Purpose		: 

use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";
use constant PLUS		=> "+";
use constant MINUS		=> "-";

use Kea::Assembly::Newbler::AllDiffs::DiffRegionCollection;
use Kea::Assembly::Newbler::AllDiffs::DiffRegionFactory;
use Kea::Assembly::Newbler::AllDiffs::SummaryLineFactory;
use Kea::Assembly::Newbler::AllDiffs::AlignmentLineFactory; 
use Kea::Assembly::Newbler::AllDiffs::AlignmentLineCollection;
use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $diffRegionCollection =
		Kea::Assembly::Newbler::AllDiffs::DiffRegionCollection->new;
	
	my $self = {
		_diffRegionCollection 						=> $diffRegionCollection,
		_summaryLine 								=> undef,
		_refAlignmentLine							=> undef,
		_readsWithDifferenceAlignmentLineCollection	=> undef,
		_otherReadsAlignmentLineCollection			=> undef,
		_differenceString							=> undef
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $nextAlignmentLine = sub {
	
	my $self = shift;
	
	my $id 			= shift;	# Id of read (or reference sequence).
	my $number		= shift; 	# Number in parenthesis ???
	my $start		= shift;	# Start position within read.
	my $orientation = shift;	# Orientation (+/-).
	my $sequence	= shift;	# Sequence with alignment gaps.
	my $end			= shift;	# End position within read.
		
	my $location;
		
	if ($start <= $end && $orientation eq "+") {
		$location = Kea::IO::Location->new(
			$start,
			$end
			);	
		}
	elsif ($start >= $end && $orientation eq "-") {
		$location = Kea::IO::Location->new(
			$end,
			$start
			);	
		}
	# e.g.
	# 150- ---------------------------------------------------------- 151
	elsif ($sequence =~ /^-+$/) {
		# Ignore contradiction between orientation (-) and positional info.
		$location = Kea::IO::Location->new(
			$start,
			$end
			);	
		}
	else {
		$self->throw(
			"Position information ($start..$end) and orientation " .
			"($orientation) does not match: $id."
			);
		}
	
	#ÊConvert orientation to sense / antisense.
	if ($orientation eq PLUS) {
		$orientation = SENSE;
		}
	elsif ($orientation eq MINUS) {
		$orientation = ANTISENSE;
		}
	else {
		$self->throw("Orientation $orientation is not recognised.");
		}
		
			
	return
		Kea::Assembly::Newbler::AllDiffs::AlignmentLineFactory->createAlignmentLine(
			-id 			=> $id,
			-number 		=> $number,
			-location 		=> $location,
			-orientation 	=> $orientation,
			-sequence 		=> $sequence
			);

	}; # End of method.

################################################################################

# PUBLIC METHODS

sub _nextSummaryLine {
	
	my $self = shift;
	
	my $refId 	= shift; # (Accno) 		Accession number of the reference sequence in which the difference was detected.
	my $start 	= shift; # (Start Pos)	Start position within the reference sequence.
	my $end		= shift; # (End pos) 	Stop position within the reference sequence.
	
	# Variation.
	my $oldSeq	= shift; # (Seq) 		The reference sequence at the difference location.
	my $newSeqs	= shift; # (Seq) 		The differing sequence(s) at the difference location.
	
	# Frequency.
	my $fwd		= shift; # (#fwd)		The number of forward reads that include the difference.
	my $rev		= shift; # (#rev)		The number of reverse reads that include the difference.
	my $var		= shift; # (#Var)		The total number of reads that include the difference.
	my $tot		= shift; # (#Tot)		The total number of reads that fully span the difference location.
	my $percent	= shift; # (%) 			The percentage of different reads versus total reads that fully span the difference location.
	
		
	my $location = Kea::IO::Location->new(
		$start,
		$end
		);
	
	$self->{_summaryLine} =
		Kea::Assembly::Newbler::AllDiffs::SummaryLineFactory->createSummaryLine(
			-refId 		=> $refId,
			-location	=> $location,
			-oldSeq		=> $oldSeq,
			-newSeqs	=> $self->checkIsArrayRef($newSeqs),
			-fwd		=> $fwd,
			-rev		=> $rev,
			-var		=> $var,
			-tot		=> $tot,
			-percent 	=> $percent
			);
	
	# Create new collections for new difference object
	#===================================================================
	$self->{_readsWithDifferenceAlignmentLineCollection} = 
		Kea::Assembly::Newbler::AllDiffs::AlignmentLineCollection->new;
	
	$self->{_otherReadsAlignmentLineCollection} = 
		Kea::Assembly::Newbler::AllDiffs::AlignmentLineCollection->new;
	#===================================================================
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextRefAlignmentLine {
	
	my $self = shift;
	
	my $id 			= shift;	# Id of read (or reference sequence).
	my $number		= shift; 	# Number in parenthesis ???
	my $start		= shift;	# Start position within read.
	my $orientation = shift;	# Orientation (+/-).
	my $sequence	= shift;	# Sequence with alignment gaps.
	my $end			= shift;	# End position within read.
	
	my $alignmentLine = $self->$nextAlignmentLine(
		$id,
		$number,
		$start,
		$orientation,
		$sequence,
		$end
		);
	
	$self->{_refAlignmentLine} = $alignmentLine;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextDifferenceLine {
	
	my $self = shift;
	my $differenceString = shift;
	
	$self->{_differenceString} = $differenceString;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextReadWithDifferenceAlignmentLine {
	
	my $self = shift;
	
	my $id 			= shift;	# Id of read (or reference sequence).
	my $number		= shift; 	# Number in parenthesis ???
	my $start		= shift;	# Start position within read.
	my $orientation = shift;	# Orientation (+/-).
	my $sequence	= shift;	# Sequence with alignment gaps.
	my $end			= shift;	# End position within read.
	
	my $alignmentLine = $self->$nextAlignmentLine(
		$id,
		$number,
		$start,
		$orientation,
		$sequence,
		$end
		);
	
	$self->throw("Alignment line collection not defined.") if
		!defined $self->{_readsWithDifferenceAlignmentLineCollection};
	
	$self->{_readsWithDifferenceAlignmentLineCollection}->add($alignmentLine);
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextOtherReadAlignmentLine {
	
	my $self = shift;
	
	my $id 			= shift;	# Id of read (or reference sequence).
	my $number		= shift; 	# Number in parenthesis ???
	my $start		= shift;	# Start position within read.
	my $orientation = shift;	# Orientation (+/-).
	my $sequence	= shift;	# Sequence with alignment gaps.
	my $end			= shift;	# End position within read.
	
	my $alignmentLine = $self->$nextAlignmentLine(
		$id,
		$number,
		$start,
		$orientation,
		$sequence,
		$end
		);
	
	$self->{_otherReadsAlignmentLineCollection}->add($alignmentLine);
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextAlignmentEnd {
	
	my $self = shift;

	$self->{_diffRegionCollection}->add(
		Kea::Assembly::Newbler::AllDiffs::DiffRegionFactory->createDiffRegion(
			-summaryLine 			=> $self->{_summaryLine},
			-reference		 		=> $self->{_refAlignmentLine},
			-readsWithDifference 	=> $self->{_readsWithDifferenceAlignmentLineCollection},
			-otherReads				=> $self->{_otherReadsAlignmentLineCollection},
			-differenceString		=> $self->{_differenceString}
			)
		);
	
	# Ensure data not stored more than once.
	#===============================================================
	$self->{_summaryLine} 									= undef;
	$self->{_refAlignmentLine} 								= undef;
	$self->{_readsWithDifferenceAlignmentLineCollection} 	= undef;
	$self->{_otherReadsAlignmentLineCollection} 			= undef;
	$self->{_differenceString} 								= undef;
	#===============================================================
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDiffRegionCollection {
	return shift->{_diffRegionCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


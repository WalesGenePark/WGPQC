#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/03/2008 12:54:02 
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
package Kea::Assembly::Newbler::AllDiffs::_DiffRegion;
use Kea::Object;
use Kea::Assembly::Newbler::AllDiffs::IDiffRegion;
our @ISA = qw(Kea::Object Kea::Assembly::Newbler::AllDiffs::IDiffRegion);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Assembly::Newbler::AllDiffs::DiffFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $summaryLine =
		Kea::Object->check(
			shift,
			"Kea::Assembly::Newbler::AllDiffs::ISummaryLine"
			);
	
	my $refAlignmentLine =
		Kea::Object->check(
			shift,
			"Kea::Assembly::Newbler::AllDiffs::IAlignmentLine"
			);
	
	my $readsWithDifferenceAlignmentLineCollection =
		Kea::Object->check(
			shift,
			"Kea::Assembly::Newbler::AllDiffs::AlignmentLineCollection"
			);
		
	my $otherReadsAlignmentLineCollection =
		Kea::Object->check(
			shift,
			"Kea::Assembly::Newbler::AllDiffs::AlignmentLineCollection"
			);	
	
	my $differenceString = Kea::Object->check(shift);
	
	
	my $self = {
		_summaryLine 								=> $summaryLine,
		_refAlignmentLine 							=> $refAlignmentLine,
		_readsWithDifferenceAlignmentLineCollection	=> $readsWithDifferenceAlignmentLineCollection,
		_otherReadsAlignmentLineCollection			=> $otherReadsAlignmentLineCollection,
		_differenceString							=> $differenceString
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

sub getSummaryLine {
	return shift->{_summaryLine};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDifferenceString {
	return shift->{_differenceString};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRefAlignmentLine {
	return shift->{_refAlignmentLine};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getReadsWithDifferenceAlignmentLineCollection {
	return shift->{_readsWithDifferenceAlignmentLineCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOtherReadsAlignmentLineCollection {
	return shift->{_otherReadsAlignmentLineCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasOtherReads {
	
	if (shift->getOtherReadsAlignmentLineCollection->getSize > 0) {
		return TRUE;		
		}
	else {
		return FALSE;
		}
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDiff {
	
	my $self = shift;
	
	$self->getSummaryLine->getLocation;
	
	return Kea::Assembly::Newbler::AllDiffs::DiffFactory->createDiff(
		-before 	=> $self->getSummaryLine->getRefSequenceAtLocation,
		-after 		=> $self->getSummaryLine->getDifferingSequencesAtLocation,
		-location 	=> $self->getSummaryLine->getLocation
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getReadIds {
	
	my $self = shift;
	
	my @alignmentLineCollections;
	
	push(
		@alignmentLineCollections,
		$self->getReadsWithDifferenceAlignmentLineCollection
		);
	
	push(
		@alignmentLineCollections,
		$self->getOtherReadsAlignmentLineCollection
		);
	
	my @readNames;
	foreach my $alignmentLineCollection (@alignmentLineCollections) {
		
		if (defined $alignmentLineCollection) {
		
			for (my $i = 0; $i < $alignmentLineCollection->getSize; $i++) {
				
				my $alignmentLine = $alignmentLineCollection->get($i);
				
				push(
					@readNames,
					$alignmentLine->getId
					);
				
				}
		
			}
		}

	return \@readNames;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAllAlignmentLines {
	
	my $self = shift;
	
	# Add reference alignment line.
	my @alignmentLines;
	push(
		@alignmentLines,
		$self->getRefAlignmentLine
		);
	
	# Add read alignment lines.
	my @alignmentLineCollections;
	push(
		@alignmentLineCollections,
		$self->getReadsWithDifferenceAlignmentLineCollection
		);
	push(
		@alignmentLineCollections,
		$self->getOtherReadsAlignmentLineCollection
		);
	
	foreach my $alignmentLineCollection (@alignmentLineCollections) {
		
		if (defined $alignmentLineCollection) {
		
			for (my $i = 0; $i < $alignmentLineCollection->getSize; $i++) {
				
				push(
					@alignmentLines,
					$alignmentLineCollection->get($i)
					);
				
				}
			}
		}
	
	return \@alignmentLines;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {

	my $self = shift;

	my $text = $self->getSummaryLine->toString . "\n";
	
	$text .= "\nReads with Difference:\n"; 
	$text .= $self->getRefAlignmentLine->toString . "\n";
	$text .= "                                " . $self->getDifferenceString . "\n";
	$text .= $self->getReadsWithDifferenceAlignmentLineCollection->toString . "\n";
	
	$text .= "\nOther Reads:\n";
	$text .= $self->getOtherReadsAlignmentLineCollection->toString;

	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


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
package Kea::Alignment::Aligner::_MuscleAlignerFromSequenceCollection;
use Kea::Object;
use Kea::Alignment::Aligner::IAligner;
our @ISA = qw(Kea::Object Kea::Alignment::Aligner::IAligner);

## Purpose		: Muscle implementation of aligner interface.

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Alignment::Muscle::MuscleFactory;
use Kea::Sequence::SequenceCollection;
use Kea::Sequence::SequenceFactory;
use Kea::Alignment::AlignmentFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
sub new {

	my $className = shift;
	
	my $sequenceCollection =
		Kea::Object->check(shift, "Kea::Sequence::SequenceCollection");
	
	my $self = {
		_sequenceCollection => $sequenceCollection,
		_alignment 			=> undef
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

sub run {
	my $self = shift;
	my %args = @_;
	
	my $cleanup = $args{-cleanup};
	if (!defined $cleanup) {
		$cleanup = TRUE;
		}
	
	my $gapopen 			= $args{-gapopen};	
	my $sequenceCollection 	= $self->{_sequenceCollection};
	
	
	# create alignment.
	my $muscle =
		Kea::Alignment::Muscle::MuscleFactory->createMuscle(
			$sequenceCollection
			);
	
	$muscle->run(
		-cleanup => $cleanup,
		-gapopen => $gapopen
		);
	my $alignment = $muscle->getAlignment;
	
	$alignment->setOverallId(
		$sequenceCollection->getOverallId
		);
	
	# store alignment.
	$self->{_alignment} = $alignment;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAlignment {

	my $self 		= shift;
	my $alignment 	= $self->{_alignment};
	
	if (defined $alignment) {
		return $alignment;
		}
	else {
		$self->throw("No alignment available - have you called run yet?");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub removeGaps {
	
	my $self = shift;
	my %args = @_;
	
	#ÊGet arguments.
	my $alignment = $self->{_alignment} or
		$self->throw("No alignment available - have you called run yet?");
	
	my $cutoff = $args{-cutoff} || 1; # Default is to remove ALL gap sites.
	
	
	if ($cutoff > 1 || $cutoff < 0) {
		$self->throw(
			"Can't have a cutoff of $cutoff.  " .
			"Value must be between 0 and 1, inclusive."
			);
		}
	
	my $newColumnCollection = Kea::Alignment::ColumnCollection->new(
		$alignment->getLabels
		);
	$newColumnCollection->setOverallId($alignment->getOverallId);
	
	# For each column in alignment, assess number of gaps - if exceeds
	# cutoff, delete column.
	my $columnCollection = $alignment->getColumnCollection;
	
	for (my $i = 0; $i < $columnCollection->getSize; $i++) {
		my $column = $columnCollection->get($i);
		my $proportion = $column->getProportionBases;
		# Store in edited collection provided bases exceed cutoff. 
		if ($proportion >= $cutoff) {
			$newColumnCollection->add(
				$column
				);
			}
		}
	
	# create new alignment object from edited column collection.
	$self->{_alignment} =
		Kea::Alignment::AlignmentFactory->createAlignment(
		$newColumnCollection
		);
	
	
	# Set ids.
	$self->{_alignment}->setOverallId(
		$alignment->getOverallId
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub trimEnds {
	
	my $self 		= shift;
	my $alignment 	= $self->{_alignment};
	
	# Old untrimmed alignment represented as a column collection.
	my $columnCollection = $alignment->getColumnCollection;
	
	# New column collection instantiated which will represent new trimmed alignment.
	my $newColumnCollection = Kea::Alignment::ColumnCollection->new(
		$alignment->getLabels
		);

	
	# Will identify start and stop positions within original alignment, defining
	# the new trimmed alignment.
	
	# First determine start position for new column collection.
	my $start;
	for ($start = 0; $start < $columnCollection->getSize; $start++) {
		my $column = $columnCollection->get($start);
		if (!$column->hasGaps) {last;}
		}
	
	# Now determine stop position.
	my $stop;
	for ($stop = $columnCollection->getSize - 1; $stop >= 0; $stop--) {
		my $column = $columnCollection->get($stop);
		if (!$column->hasGaps) {last;}
		}
	
	# Fill new column collection with part of alignment defined by start and stop.
	for (my $i = $start; $i <= $stop; $i++) {
		$newColumnCollection->add(
			$columnCollection->get($i)
			);
		}
	
	# Set new column collection as alignment.
	$self->{_alignment} =
		Kea::Alignment::AlignmentFactory->createAlignment(
			$newColumnCollection
			);
	
		
	# Set ids.
	$self->{_alignment}->setOverallId(
		$alignment->getOverallId
		);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


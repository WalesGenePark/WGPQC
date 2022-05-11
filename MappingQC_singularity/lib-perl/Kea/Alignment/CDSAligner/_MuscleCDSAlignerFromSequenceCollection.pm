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
package Kea::Alignment::CDSAligner::_MuscleCDSAlignerFromSequenceCollection;
use Kea::Object;
use Kea::Alignment::CDSAligner::ICDSAligner;
our @ISA = qw(
	Kea::Object
	Kea::Alignment::CDSAligner::ICDSAligner
	);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Alignment::Muscle::MuscleFactory;
use Kea::Sequence::SequenceCollection;
use Kea::Sequence::SequenceFactory;
use Kea::Alignment::AlignmentFactory;
use Kea::Alignment::CombinedAlignmentFactory;
use Kea::Utilities::CDSUtility;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $sequenceCollection =
		Kea::Object->check(shift, "Kea::Sequence::SequenceCollection");
	
	my $self = {
		_sequenceCollection => $sequenceCollection,
		_dnaAlignment 		=> undef,
		_proteinAlignment 	=> undef
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $createDnaAlignmentFromProteinAlignment = sub {
	
	my $self = shift;
	my $aaAlignment 			= shift;
	my $dnaSequenceCollection 	= shift;
	
	my $af = Kea::Alignment::AlignmentFactory->new;
	return $af->convertAaAlignmentToDna(
		$aaAlignment,
		$dnaSequenceCollection
		);
	
	}; # End of method. 

#///////////////////////////////////////////////////////////////////////////////

my $makeTmpDebuggingFile = sub {
	
	my $self = shift;
	my $filename = shift;
	my $contents = shift;
	
	open(FILE, ">$filename") or $self->throw("Could not create $filename.");
	print FILE $contents;
	close(FILE) or $self->throw("Could not close $filename");
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub run {
	my $self = shift;
	my %args = @_;
	
	my $cleanup = $args{-cleanup};
	if (!defined $cleanup) {
		$cleanup = TRUE;
		}
	
	my $gapopen 				= $args{-gapopen};	
	my $dnaSequenceCollection 	= $self->{_sequenceCollection};
	
	# Create aa sequence collection from dna sequence collection.
	my $utility = Kea::Utilities::CDSUtility->new;
	my $aaSequenceCollection = Kea::Sequence::SequenceCollection->new(
		$dnaSequenceCollection->getOverallId
		);
	for (my $i = 0; $i < $dnaSequenceCollection->getSize; $i++) {
		my $dnaSequence = $dnaSequenceCollection->get($i);
		my $aaString = $utility->getTranslation($dnaSequence->getSequence);
		$aaSequenceCollection->add(
			Kea::Sequence::SequenceFactory->createSequence(
				-id 		=> $dnaSequence->getID,
				-sequence 	=> $aaString
				)
			);
		}
	
	# create aa alignment.
	my $muscle =
		Kea::Alignment::Muscle::MuscleFactory->createMuscle(
			$aaSequenceCollection
			);
	
	$muscle->run(
		-cleanup => $cleanup,
		-gapopen => $gapopen
		);
	my $aaAlignment = $muscle->getAlignment;
	
	# create dna alignment from aa alignment.
	my $dnaAlignment = $self->$createDnaAlignmentFromProteinAlignment(
		$aaAlignment,
		$dnaSequenceCollection
		);
	
	$dnaAlignment->setOverallId($dnaSequenceCollection->getOverallId);
	$aaAlignment->setOverallId($dnaSequenceCollection->getOverallId);
	
	# store alignments.
	$self->{_dnaAlignment} = $dnaAlignment;
	$self->{_proteinAlignment} = $aaAlignment;
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCombinedAlignment {
	my $self = shift;
	my $dnaAlignment = $self->{_dnaAlignment};
	my $proteinAlignment = $self->{_proteinAlignment};
	return Kea::Alignment::CombinedAlignmentFactory->createCombinedAlignment(
		-dnaAlignment => $dnaAlignment,
		-proteinAlignment => $proteinAlignment
		);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDnaAlignment {

	my $self = shift;
	my $alignment = $self->{_dnaAlignment};
	
	if (defined $alignment) {
		return $alignment;
		}
	else {
		$self->throw("No alignment available - have you called run yet?");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getProteinAlignment {
	
	my $self = shift;
	my $alignment = $self->{_proteinAlignment};
	
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
	
	my $dnaAlignment = $self->{_dnaAlignment} or
		$self->throw("No dna alignment! Have you called run yet?");
		
	my $proteinAlignment = $self->{_proteinAlignment} or
		$self->throw("No protein alignment! Have you called run yet?");
	
	my $cutoff = $args{-cutoff} || 1; # Default is delete all gaps.
	
	if ($cutoff > 1 || $cutoff < 0) {
		$self->throw(
			"Can't have a cutoff of $cutoff.  " .
			"Value must be between 0 and 1, inclusive."
			);
		}
	
	
	my $newProteinColumnCollection = Kea::Alignment::ColumnCollection->new(
		$proteinAlignment->getLabels
		);
	$newProteinColumnCollection->setOverallId(
		$proteinAlignment->getOverallId
		);
	
	my $newDnaColumnCollection = Kea::Alignment::ColumnCollection->new(
		$dnaAlignment->getLabels
		);
	$newDnaColumnCollection->setOverallId(
		$dnaAlignment->getOverallId
		);
	
	# For each column in protein alignment, assess number of gaps - if exceeds
	# cutoff, delete column - and corresponding three from D=dna alignment.
	my $proteinColumnCollection = $proteinAlignment->getColumnCollection;
	my $dnaColumnCollection = $dnaAlignment->getColumnCollection;
	
	for (my $i = 0; $i < $proteinColumnCollection->getSize; $i++) {
		my $proteinColumn = $proteinColumnCollection->get($i);
		my @dnaColumns;
		for (my $j = $i*3; $j < ($i*3)+3; $j++) {
			push(@dnaColumns, $dnaColumnCollection->get($j));
			}
		my $proportion = $proteinColumn->getProportionBases;
		# Store in edited collection provided bases exceed cutoff. 
		if ($proportion >= $cutoff) {
			# Protein alignment.
			$newProteinColumnCollection->add(
				$proteinColumn
				);
			#ÊDNA alignment.
			foreach my $column (@dnaColumns) {
				$newDnaColumnCollection->add($column);
				}
			}
		}
	
	# create new alignment object from edited column collection.
	$self->{_proteinAlignment} =
		Kea::Alignment::AlignmentFactory->createAlignment(
		$newProteinColumnCollection
		);
	
	$self->{_dnaAlignment} =
		Kea::Alignment::AlignmentFactory->createAlignment(
		$newDnaColumnCollection
		);
	
	## Set ids.
	#$self->{_proteinAlignment}->setOverallId(
	#	$proteinAlignment->getOverallId
	#	);
	#$self->{_dnaAlignment}->setOverallId(
	#	$dnaAlignment->getOverallId
	#	);
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub trimEnds {
	
	my $self = shift;
	my $dnaAlignment = $self->{_dnaAlignment};
	my $proteinAlignment = $self->{_proteinAlignment};
	
	my $proteinColumnCollection = $proteinAlignment->getColumnCollection;
	my $dnaColumnCollection = $dnaAlignment->getColumnCollection;
	
	my $newProteinColumnCollection = Kea::Alignment::ColumnCollection->new(
		$proteinAlignment->getLabels
		);
	$newProteinColumnCollection->setOverallId(
		$proteinAlignment->getOverallId
		);
	
	my $newDnaColumnCollection = Kea::Alignment::ColumnCollection->new(
		$dnaAlignment->getLabels
		);
	$newDnaColumnCollection->setOverallId(
		$dnaAlignment->getOverallId
		);
	
	
	# First trim left-side.
	my $start;
	for ($start = 0; $start < $proteinColumnCollection->getSize; $start++) {
		my $column = $proteinColumnCollection->get($start);
		if (!$column->hasGaps) {last;}
		}
	
	# Now trim right-side.
	my $stop;
	for ($stop = $proteinColumnCollection->getSize - 1; $stop >= 0; $stop--) {
		my $column = $proteinColumnCollection->get($stop);
		if (!$column->hasGaps) {last;}
		}
	
	for (my $i = $start; $i <= $stop; $i++) {
		$newProteinColumnCollection->add(
			$proteinColumnCollection->get($i)
			);
		}
	
	for (my $i = $start*3; $i <= ($stop*3)+2; $i++) {
		$newDnaColumnCollection->add(
			$dnaColumnCollection->get($i)
			);
		}
	
	
	
	$self->{_proteinAlignment} =
		Kea::Alignment::AlignmentFactory->createAlignment(
			$newProteinColumnCollection
			);
	
	
	$self->{_dnaAlignment} =
		Kea::Alignment::AlignmentFactory->createAlignment(
			$newDnaColumnCollection
			);
		

		
	## Set ids.
	#$self->{_proteinAlignment}->setOverallId(
	#	$proteinAlignment->getOverallId
	#	);
	#$self->{_dnaAlignment}->setOverallId(
	#	$dnaAlignment->getOverallId
	#	);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


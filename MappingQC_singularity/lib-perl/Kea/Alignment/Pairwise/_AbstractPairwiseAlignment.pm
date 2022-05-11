#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 18/02/2008 20:25:56 
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
package Kea::Alignment::Pairwise::_AbstractPairwiseAlignment;
use Kea::Object;
use Kea::Alignment::Pairwise::IPairwiseAlignment;
our @ISA = qw(Kea::Object Kea::Alignment::Pairwise::IPairwiseAlignment);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Alignment::ColumnCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	
	my $className = shift;
	my $sequence1 = Kea::Object->check(shift, "Kea::Sequence::ISequence");
	my $sequence2 = Kea::Object->check(shift, "Kea::Sequence::ISequence");
	
	
	my @bases1 = $sequence1->getBases;
	my @bases2 = $sequence2->getBases;
	
	my $matrix = [
		\@bases1,
		\@bases2
		];
	
	my $labels = [$sequence1->getID, $sequence2->getID];
	
	my $self = {
		_id		=> "pairwise alignment",
		_matrix => $matrix,
		_labels => $labels
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

sub getFirstSequence {
	
	my $self 				= shift;
	my $sequenceCollection 	= $self->getSequenceCollection;
	
	return $sequenceCollection->get(0);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSecondSequence {

	my $self 				= shift;
	my $sequenceCollection 	= $self->getSequenceCollection;
	
	return $sequenceCollection->get(1);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub removeSitesWithGaps {
	
	my $self 				= shift;
	my $columnCollection 	= $self->getColumnCollection;
	
	my $newColumnCollection = Kea::Alignment::ColumnCollection->new(
		$self->getIds
		);
	$newColumnCollection->setOverallId(
		$columnCollection->getOverallId
		);
	
	for (my $i = 0; $i < $columnCollection->getSize; $i++) {
		my $column = $columnCollection->get($i);
		if (!$column->hasGaps) {
			$newColumnCollection->add($column);
			}
		}
	
	$self->setColumnCollection($newColumnCollection);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getMatrix {
	return shift->{_matrix};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {

	my $self 				= shift;
	my $sequenceCollection 	= $self->getSequenceCollection;
	
	return $sequenceCollection->toString;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////



#=====================
# IAlignment methods
#=====================

sub setOverallId {

	my $self 	= shift;
	my $id 		= $self->check(shift);
	
	$self->{_id} = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOverallId {

	my $self = shift;
	
	if ($self->hasOverallId) {
		return $self->{_id};
		}
	else {
		$self->throw("No id set for alignment.");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasOverallId {
	
	my $self = shift;
	
	if (defined $self->{_id}) {return TRUE;}
	else {return FALSE;}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRowCollection {

	my $self = shift;
	
	my $rowCollection = Kea::Alignment::RowCollection->new;
	my $n = $self->getNumberOfRows;
	for (my $i = 0; $i < $n; $i++) {
		$rowCollection->add(
			$self->getRowAt($i)
			);
		}
	
	return $rowCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getColumnCollection {

	my $self = shift;
	
	my @labels = $self->getLabels;
	
	my $columnCollection = Kea::Alignment::ColumnCollection->new(@labels);
	my $n = $self->getNumberOfColumns;
	for (my $i = 0; $i < $n; $i++) {
		$columnCollection->add(
			$self->getColumnAt($i)
			);
		}
	
	$columnCollection->setOverallId($self->getOverallId);
	
	return $columnCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setColumnCollection {
	
	my $self = shift;
	my $columnCollection =
		$self->check(shift, "Kea::Alignment::ColumnCollection");
	
	my @labels = $columnCollection->getLabels;
	my @matrix;
	
	for (my $i = 0; $i < $columnCollection->getSize; $i++) {
		my $column = $columnCollection->get($i);
		
		for (my $j = 0; $j < $column->getSize; $j++) {
			push(
				@{$matrix[$j]},
				$column->getBaseAt($j)
				);
			}
		
		}
	
	$self->{_labels} = \@labels;
	$self->{_matrix} = \@matrix;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRowArrayAt {

	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);
	
	my $matrix = $self->{_matrix};
	my $row = $matrix->[$i];
	return @$row; 
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRowAt {

	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);
	
	my $matrix = $self->{_matrix};
	my $row = $matrix->[$i] or $self->throw("Opps with $i");
	
	return Kea::Alignment::RowFactory->createRow(@$row);

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRowStringAt {

	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);
	
	my @row = $self->getRowArrayAt($i);
	return join("", @row);
	
	} # End of method.

# Convenience method.
sub getSequence {
	
	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);
	
	return $self->getRowStringAt($i);
	
	} # End of method.

sub getUnalignedSequence {
	
	my $self 	= shift;
	my $i		= $self->checkIsInt(shift);
	
	my $sequence = $self->getSequence($i);
	$sequence =~ s/-//g;
	return $sequence; 	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLabel {

	my $self 	= shift;
	my $i		= $self->checkIsInt(shift);
	
	return $self->{_labels}->[$i];
	
	} # End of method.

# Convenience method.
sub getId {

	my $self	= shift;
	my $i		= $self->checkIsInt(shift);
	
	return $self->getLabel($i);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLabels {
	return @{shift->{_labels}};
	} # End of method.

# Convenience method.
sub getIds {
	return @{shift->{_labels}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRowStrings {

	my $self = shift;
	
	my @rowStrings;
	my $n = $self->getNumberOfRows;
	for (my $i = 0; $i < $n; $i++) {
		push(
			@rowStrings,
			$self->getRowStringAt($i)
			);
		}
	return @rowStrings;
	} # End of method.

# Convenience method.
sub getSequences {
	return shift->getRowStrings;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceCollection {

	my $self = shift;
	
	my @sequenceStrings = $self->getSequences;
	my @ids = $self->getIds;
	
	my $sequenceCollection =
		Kea::Sequence::SequenceCollection->new($self->getOverallId);
		
	for (my $i = 0; $i < @ids; $i++) {
		$sequenceCollection->add(
			Kea::Sequence::SequenceFactory->createSequence(
				-id 		=> $ids[$i],
				-sequence 	=> $sequenceStrings[$i]
				)
			);
		}
	
	return $sequenceCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getUnalignedSequenceCollection {
	
	my $self 	= shift;
	my @ids 	= $self->getIds;
	
	my $sequenceCollection =
		Kea::Sequence::SequenceCollection->new($self->getOverallId);
	
	for (my $i = 0; $i < @ids; $i++) {
		$sequenceCollection->add(
			Kea::Sequence::SequenceFactory->createSequence(
				-id 		=> $ids[$i],
				-sequence 	=> $self->getUnalignedSequence($i)
				)
			);
		}
	
	return $sequenceCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getIndexForLabel {

	my $self 	= shift;
	my $label 	= $self->check(shift);
	
	my $labels = $self->{_labels};
	for (my $i = 0; $i < @$labels; $i++) {
		if ($labels->[$i] eq $label) {
			return $i;
			}
		}
	
	$self->throw(
		"'$label' could not be found within alignment.\n" .
		"\tAlignment contains:\n\t@$labels"
		);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRowStringWithLabel {

	my $self 	= shift;
	my $label 	= $self->check(shift);
	
	my $i = $self->getIndexForLabel($label);
	
	return $self->getRowStringAt($i);
	
	} #ÊEnd of method.

# Convenience method.
sub getSequenceWithId {
	
	my $self 	= shift;
	my $id 		= $self->check(shift);
	
	return $self->getRowStringWithLabel($id);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getColumnArrayAt {

	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);
	
	my $matrix = $self->{_matrix};
	
	my @column;
	foreach my $row (@$matrix) {
		push(
			@column,
			$row->[$i]
			);	
		}
	
	return @column;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getColumnAt {
	
	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);
	
	my $matrix = $self->{_matrix};
	
	my @column;
	foreach my $row (@$matrix) {
		push(
			@column,
			$row->[$i]
			);	
		}
	
	return Kea::Alignment::ColumnFactory->createColumn(@column);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getColumnStringAt {

	my $self 	= shift;
	my $i		= $self->checkIsInt(shift);

	return join(
		"",
		$self->getColumnArrayAt($i)
		);
	}

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfRows {
	my $matrix = shift->{_matrix};
	return scalar(@$matrix);
	} #ÊEnd of method.

# Convenience method.
sub getSize {
	return shift->getNumberOfRows;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfColumns {
	my $matrix = shift->{_matrix};
	return scalar(@{$matrix->[0]});
	} # End of method.

sub getNumberOfSites {
	return shift->getNumberOfColumns;
	}

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfIdenticalSites {

	my $self = shift;
	
	my $columnCollection = $self->getColumnCollection;
	my $identical = 0;
	for (my $i = 0; $i < $columnCollection->getSize; $i++) {
		my $column = $columnCollection->get($i);
		if ($column->hasIdenticalBases) {
			$identical++;	
			}
		else {
			
			}
		}
	
	return $identical;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getNumberOfDifferentSites {

	my $self = shift;
	
	my $n = $self->getNumberOfSites;
	my $identical = $self->getNumberOfIdenticalSites;
	
	return $n - $identical;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


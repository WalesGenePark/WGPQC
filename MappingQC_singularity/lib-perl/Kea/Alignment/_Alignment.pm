#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 
#    Copyright (C) 2008, University of Liverpool.
#    Author: Kevin Ashelford.
#
#    Contact details:
#    Email: k.ashelford@liv.ac.uk
#    Address: School of Biological Sciences, University of Liverpool, 
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
package Kea::Alignment::_Alignment;
use Kea::Object;
use Kea::Alignment::IAlignment;
our @ISA = qw(Kea::Object Kea::Alignment::IAlignment); 

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE	=> 0;

use Kea::Alignment::ColumnFactory;
use Kea::Alignment::RowFactory;
use Kea::Alignment::ColumnCollection;
use Kea::Alignment::RowCollection;
use Kea::Sequence::SequenceCollection;
use Kea::Sequence::SequenceFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className 	= shift;
	my $labels 		= Kea::Object->check(shift);
	my $matrix 		= Kea::Object->check(shift);
	
	my $self = {
		_id 	=> undef,
		_labels => $labels,
		_matrix => $matrix
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

sub setOverallId {

	my $self 	= shift;
	my $id 		= $self->check(shift);

	#if (defined $self->{_id}) {
	#	$self->warn(
	#		"Changing overall id of alignment from " .
	#		$self->{_id} . 
	#		" to $id"
	#		);
	#	}
	
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

#///////////////////////////////////////////////////////////////////////////////

sub getMatrix {
	return shift->{_matrix};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAlignmentBlock {
	
	my $self 	= shift;
	my $location = $self->check(shift, "Kea::IO::Location");
	
	my $start 	= $location->getStart;
	my $end 	= $location->getEnd;
	
	my $labels = $self->{_labels};
	my $matrix = $self->{_matrix};
	
	my $newMatrix;
	my $newLabels;
	
	foreach my $row (@$matrix) {
		my $sequence = substr(join("", @$row), $start, $end-$start);
		push(@$newMatrix, [split("", $sequence)]);
		}

	
	my $alignment = Kea::Alignment::_Alignment->new($labels, $newMatrix);
	$alignment->setOverallId("");
	
	return $alignment;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {

	my $self = shift;
	
	my $matrix = $self->{_matrix};
	my $labels = $self->{_labels};
	
	my $text = "Size = " . $self->getSize . "\n";
	foreach my $label (@$labels) {
		$text = $text . ">$label\n" . $self->getRowStringWithLabel($label) . "\n"; 
		}
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


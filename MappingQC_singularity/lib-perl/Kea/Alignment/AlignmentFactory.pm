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
package Kea::Alignment::AlignmentFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

my $GAP			= "-";
my $WHITESPACE 	= " ";
my $DIFF 		= "*";
my $NO_DIFF 	= " ";

use Kea::Alignment::_Alignment;
use Kea::Utilities::AlignmentUtility; 

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new { 
	my $className = shift;
	my $self = {};
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $createAlignmentFromSequenceCollection = sub {
	
	my $self = shift;
	
	my $sequenceCollection =
		$self->check(shift, "Kea::Sequence::SequenceCollection");
	
	
	
	
	
	my @labels;
	my @matrix;
	my $size = $sequenceCollection->get(0)->getSize;
	for (my $i = 0; $i < $sequenceCollection->getSize; $i++) {
		my $sequence = $sequenceCollection->get($i);
		my @array = $sequence->getBases;
		
		
		if ($size != @array) {
		
			$self->throw(
				"Sequence collection does not appear to be aligned" .
				" - unequal sequence lengths!\n\t(" .
				$sequence->getID . 
				", " . 
				$size . 
				", " .
				@array . 
				")\n\n" .
				"\tPerhaps you were trying to align an unaligned file?\n\tUse " .
				"Kea::Alignment::Aligner::AlignerFactory instead."
				);
			}
		push(
			@labels,
			$sequence->getID
			);
		push(
			@matrix,
			\@array
			);
		}
	
	my $alignment = Kea::Alignment::_Alignment->new(\@labels, \@matrix);
	
	my $id = $sequenceCollection->getOverallId;
	
	if (defined $id) {
		$alignment->setOverallId($id);
		}
	
	return $alignment;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $createAlignmentFromColumnCollection = sub {
	
	my $self = shift;
	
	my $columnCollection =
		$self->check(shift, "Kea::Alignment::ColumnCollection");
	
	my @labels = $columnCollection->getLabels;
	my @matrix;
	
	my $n = $columnCollection->getSize;
	for (my $i = 0; $i < $n; $i++) {
		my $column = $columnCollection->get($i);

		for (my $j = 0; $j < $column->getSize; $j++) {
			
			push(
				@{$matrix[$j]},
				$column->getBaseAt($j)
				);
			}
		}
	
	my $alignment =  Kea::Alignment::_Alignment->new(\@labels, \@matrix);
	
	$alignment->setOverallId(
		$columnCollection->getOverallId
		);
	
	return $alignment;
	
	}; # End of method. 

#///////////////////////////////////////////////////////////////////////////////

my $getPadding = sub {
	
	my $self = shift;
	my $n = shift;

	my $padding = "";
	for (1..$n) {
		$padding .= $WHITESPACE;
		}
	return $padding;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $createAlignmentFromContig = sub {
	
	my $self = shift;
	my $contig = $self->check(shift, "Kea::Assembly::IContig");
	
	my @labels;
	my $matrix;
	
	push(@labels, $contig->getName);
	push(@$matrix, [split("", $contig->getPaddedConsensus)]);
	
	my $readCollection = $contig->getReadCollection;
	for (my $i = 0; $i < $readCollection->getSize; $i++) {
		my $read = $readCollection->get($i);
		
		push(@labels, $read->getName);
		
		my $paddedRead = $read->getPaddedRead;
		my $alignClippingStart 	= $read->getAlignClippingStart;
		my $alignClippingEnd 	= $read->getAlignClippingEnd;
		my $paddedStartConsensusPosition =
			$read->getPaddedStartConsensusPosition;
		
		my $n = abs(
			($paddedStartConsensusPosition-1) +
			($alignClippingStart-1)
			);
		
		my $alignmentString = $self->$getPadding($n);
		
		$alignmentString .=
			substr(
				$paddedRead,
				$alignClippingStart-1,
				$alignClippingEnd-$alignClippingStart+1
				);
		
		#ÊAdd extra padding at end of line.
		my $paddingLength = $contig->getPaddedSize - length($alignmentString);
		
		$alignmentString .= $self->$getPadding($paddingLength);
		
		push(
			@$matrix,
			[split("", $alignmentString)]
			);

		
		}
	
	
	
	my $alignment = Kea::Alignment::_Alignment->new(\@labels, $matrix);
	$alignment->setOverallId("");
	
	return $alignment;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $longestStringLength = sub {
	
	my $self = shift;
	my $list = shift;
	
	my $n = 0;
	foreach my $string (@$list) {
		if (length($string) > $n) {$n = length($string);}
		}
	
	return $n;
	
	}; #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

my $createAlignmentFromReadCollection = sub {
	
	my $self = shift;
	my $readCollection = $self->check(shift, "Kea::Assembly::ReadCollection");
	
	my @labels;
	my $matrix;
	
	my @alignmentStrings;
	
	for (my $i = 0; $i < $readCollection->getSize; $i++) {
		my $read = $readCollection->get($i);
		
		push(@labels, $read->getName);
		
		my $paddedRead = $read->getPaddedRead;
		my $alignClippingStart 	= $read->getAlignClippingStart;
		my $alignClippingEnd 	= $read->getAlignClippingEnd;
		my $paddedStartConsensusPosition =
			$read->getPaddedStartConsensusPosition;
		
		my $n = abs(
			($paddedStartConsensusPosition-1) +
			($alignClippingStart-1)
			);
		
		my $alignmentString = $self->$getPadding($n);
		
		$alignmentString .=
			substr(
				$paddedRead,
				$alignClippingStart-1,
				$alignClippingEnd-$alignClippingStart+1
				);
		
		push(@alignmentStrings, $alignmentString);
		}
	

	# Add padding to end of each line.
	my $n = $self->$longestStringLength(\@alignmentStrings);
	foreach my $alignmentString (@alignmentStrings) {
		my $paddingLength = $n - length($alignmentString);
		$alignmentString .= $self->$getPadding($paddingLength);
		}	
	
	# Create matrix from alignment strings.
	foreach my $alignmentString (@alignmentStrings) {
		push(
			@$matrix,
			[split("", $alignmentString)]
			);
		}
	

	
	my $alignment = Kea::Alignment::_Alignment->new(\@labels, $matrix);
	$alignment->setOverallId("");
	
	return $alignment;
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub createAlignment {

	my $self 	= shift;
	my $object 	= $self->check(shift);
	
	if ($object->isa("Kea::Sequence::SequenceCollection")) {
		return $self->$createAlignmentFromSequenceCollection($object);	
		}
	
	elsif ($object->isa("Kea::Alignment::ColumnCollection")) {
		return $self->$createAlignmentFromColumnCollection($object);
		}
	
	elsif ($object->isa("Kea::Assembly::ReadCollection")) {
		return $self->$createAlignmentFromReadCollection($object);
		}
	
	elsif ($object->isa("Kea::Assembly::IContig")) {
		return $self->$createAlignmentFromContig($object);
		}
	
	else {
		$self->throw("Unsupported type - " . ref($object));
		}
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createRelabelledAlignment {

	warn "\nWARN: Relabelling alignment - are you sure you want to do this?\n\n";

	my $self 		= shift;
	my $alignment 	= $self->check(shift, "Kea::Alignment::IAlignment");
	my $idAliases 	= $self->check(shift);  #ÊShould be hash with original ids as keys and aliases as values.
	
	my $columnCollection = $alignment->getColumnCollection;
	
	my @originalLabels = $columnCollection->getLabels;
	
	my @labels;
	foreach my $label (@originalLabels) {
		push(
			@labels,
			$idAliases->{$label}
			);
		}
	
	my @matrix;
	
	my $n = $columnCollection->getSize;
	for (my $i = 0; $i < $n; $i++) {
		my $column = $columnCollection->get($i);

		for (my $j = 0; $j < $column->getSize; $j++) {
			
			push(
				@{$matrix[$j]},
				$column->getBaseAt($j)
				);
			}
		}
	
	return Kea::Alignment::_Alignment->new(\@labels, \@matrix);
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub convertAaAlignmentToDna {

	my $self 					= shift;
	my $aaAlignment 			= $self->check(shift, "Kea::Alignment::IAlignment");
	my $dnaSequenceCollection 	= $self->check(shift, "Kea::Sequence::SequenceCollection");
	
	my $utility = Kea::Utilities::AlignmentUtility->new;
	
	my @labels;
	my @matrix;
	
	for (my $i = 0; $i < $aaAlignment->getSize; $i++) {
		# Get aligned aa sequence.
		my $id = $aaAlignment->getId($i);
		my $alignedAa = $aaAlignment->getSequence($i);
		# Get corresponding unaligned dna sequence.
		my $dna = $dnaSequenceCollection->getSequenceStringWithID($id);
		
		# Map aligned aa onto dna to create aligned dna sequence.
		my $alignedDna = $utility->createDNAAlignmentString(
			-alignedProteinString => $alignedAa,
			-dnaString => $dna
			);
		# add details to labels and matrix.
		push(
			@labels,
			$id
			);
		my @array = split(//, $alignedDna);
		push(
			@matrix,
			\@array
			);
		}
	
	return Kea::Alignment::_Alignment->new(\@labels, \@matrix);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


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
package Kea::IO::Fasta::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Fasta::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Fasta::IReaderHandler);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Sequence::SequenceFactory;
use Kea::Sequence::SequenceCollection;
use Kea::IO::RecordFactory;
use Kea::IO::RecordCollection;
use Kea::Alignment::AlignmentFactory; 

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	my $self = {
		
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

sub _nextHeader {

	my (
		$self,
		$header
		) = @_;
	
	$header =~ /^([\S]+)/;	
	push(@{$self->{_accessions}}, $1);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSequence {
	my ($self, $sequence) = @_;
	push(@{$self->{_sequences}}, $sequence);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAlignment {
	
	my $self = shift;
	
	my $sequenceCollection = $self->getSequenceCollection;
	
	# Check that sequences appear to be aligned.
	my $n = $sequenceCollection->get(0)->getSize;
	for (my $i = 0; $i < $sequenceCollection->getSize; $i++) {
		my $sequence = $sequenceCollection->get($i);
		if ($sequence->getSize != $n) {
			$self->throw("Sequences do not appear to be aligned!");
			}
		}
	
	my $alignment = Kea::Alignment::AlignmentFactory->createAlignment(
		$sequenceCollection
		);
	
	return $alignment;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Assumes only one!
sub getRecord {
	my $self = shift;
	
	my @accessions = @{$self->{_accessions}};
	my @sequences = @{$self->{_sequences}};
	
	if (@accessions > 1) {
		$self->throw(
			"Trying to create a single record object from multiple sequence " .
			"records!"
			);
		}
	
	my $record = Kea::IO::RecordFactory->createRecord($accessions[0]);
	$record->setSequence($sequences[0]);

	$record->setVersion("1");
	$record->setMoleculeType("???");
	$record->setTopology("unknown");
	$record->setTaxonomicDivision("UNC");
	$record->setDataClass("STD");
	
	return $record;
	
	} # End of method
	
#///////////////////////////////////////////////////////////////////////////////
		
sub getRecordCollection {
	
	my $self = shift;
	
	my @accessions = @{$self->{_accessions}};
	my @sequences = @{$self->{_sequences}};
	
	my $recordCollection = Kea::IO::RecordCollection->new;
	for (my $i = 0; $i < @accessions; $i++) {
		
		my $record = Kea::IO::RecordFactory->createRecord($accessions[$i]);
		$record->setSequence($sequences[$i]);
		
		$record->setVersion("1");
		$record->setMoleculeType("???");
		$record->setTopology("unknown");
		$record->setTaxonomicDivision("UNC");
		$record->setDataClass("STD");
	
		$recordCollection->add($record);
		}
	
	return $recordCollection;
	
	} # End of method.
		
#///////////////////////////////////////////////////////////////////////////////

sub getAccessions {
	
	my $self = shift;
	
	if (!exists $self->{_accessions}) {
		$self->throw("No accession data stored!");
		}
	
	
	return @{$self->{_accessions}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequences {
	
	my $self = shift;

	if (!exists $self->{_sequences}) {
		$self->throw("_sequences does not exist");
		}
	
	return @{$self->{_sequences}};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequencesAsHash {
	my $self = shift;
	my @accessions = $self->getAccessions;
	my @sequences = $self->getSequences;
	my %hash;
	for (my $i = 0; $i < scalar(@accessions); $i++) {
		$hash{$accessions[$i]} = $sequences[$i];
		}
	return \%hash;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceObjects {
	my $self = shift;
	
	my @accessions = $self->getAccessions;
	my @sequences = $self->getSequences;
	my $sequenceFactory = Kea::Sequence::SequenceFactory->new;
	
	my @array;
	for (my $i = 0; $i < scalar(@accessions); $i++) {
		my $seqObj =
			$sequenceFactory->createSequence(
				-id => $accessions[$i],
				-sequence => $sequences[$i]
				);
		push(@array, $seqObj);
		}
	return @array;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceCollection {

	my $self = shift;
	
	my @array = $self->getSequenceObjects;
	
	my $sequenceCollection = Kea::Sequence::SequenceCollection->new("unknown");
	foreach my $sequence (@array) {
		$sequenceCollection->add($sequence);
		}
	
	return $sequenceCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasSequence {
	
	my $self = shift;
	my $query = $self->check(shift);
	
	my @accessions = $self->getAccessions();
	foreach my $accession (@accessions) {
		if ($accession eq $query) {
			return TRUE;
			}
		}
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequence {

	my $self = shift;
	my $query = shift;
	
	if (!defined $query) {
		$self->throw("getSequence() expects a sequence id.");
		}
	
	my @accessions = $self->getAccessions();
	my @sequences = $self->getSequences();

	for (my $i = 0; $i < scalar(@accessions); $i++) {
		if ($query eq $accessions[$i]) {
			return $sequences[$i];
			}
		}
	
	$self->throw("Could not find sequence for code '$query'.");
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 14/05/2008 16:42:10
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
package Kea::IO::SwissProt::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::SwissProt::IReaderHandler; 
our @ISA = qw(Kea::Object Kea::IO::SwissProt::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::SwissProt::SwissProtRecordCollection;
use Kea::IO::SwissProt::SwissProtRecordFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $swissProtRecordCollection =
		Kea::IO::SwissProt::SwissProtRecordCollection->new("");
	
	my $self = {
		_swissProtRecordCollection 	=> $swissProtRecordCollection
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

sub _nextIDLine	{
	
	my $self 			= shift;
	my $entryName 		= shift;		#ÊEntry name
	my $dataClass 		= shift;		# Data class
	my $moleculeType 	= shift;	# molecule type
	my $sequenceLength 	= shift;	# Sequence length
	
	$self->{_entryName} 		= $entryName;
	$self->{_dataClass} 		= $dataClass;
	$self->{_moleculeType} 		= $moleculeType;
	$self->{_sequenceLength} 	= $sequenceLength;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextAccessionLine {
	
	my $self = shift;
	my $accessions = shift;
	
	$self->{_accessions} = $accessions;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextDescriptionLine {
	
	my $self = shift;
	my $line = $self->check(shift);
	
	push(@{$self->{_description}}, $line);
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextReferenceLine	{
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextDatabaseCrossReferenceLine	{
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextFeatureLine {
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSequenceLine {
	
	my $self 			= shift;
	my $seqLength 		= $self->check(shift);
	my $molecularWeight = $self->check(shift);
	my $seq64bitCRC 	= $self->check(shift);
	my $sequence 		= $self->check(shift);
	
	
	if (!defined $self->{_entryName}) {
		$self->throw(
			"Missing entry name."
			);
		}
	
	if (!defined $self->{_dataClass}) {
		$self->throw(
			"Missing data class for " . $self->{_entryName} . "."
			);
		}
	
	# Not always present.
	#if (!defined $self->{_moleculeType}) {
	#	$self->throw(
	#		"Missing molecule type for " . $self->{_entryName} . "."
	#		);
	#	}
	
	if (!defined $self->{_sequenceLength}) {
		$self->throw(
			"Missing sequence length for " . $self->{_entryName} . "."
			);
		}
	
	if (!defined $self->{_accessions}) {
		$self->throw(
			"Missing accession(s) for " . $self->{_entryName} . "."
			);
		}
	
	if (!defined $self->{_description}) {
		$self->throw(
			"Missing description for " . $self->{_entryName} . "."
			);
		}
	
	if ($seqLength != $self->{_sequenceLength}) {
		$self->throw(
			"Sequence length from ID line (" . $self->{_sequenceLength} . ") ".
			"does not coincide with that quoted in SQ line ($seqLength).");
		}
	
	if (length($sequence) != $seqLength) {
		$self->throw(
			"Sequence length (" . length($sequence) . 
			") does not match expectation ($seqLength): " .
			$self->{_entryName} . "."
			);
		}
	
	
	
	$self->{_swissProtRecordCollection}->add(
		Kea::IO::SwissProt::SwissProtRecordFactory->createRecord(
			-entryName 			=> $self->{_entryName},
			-dataClass 			=> $self->{_dataClass},
			-moleculeType 		=> $self->{_moleculeType},
			-sequence 			=> $sequence,
			-accessions			=> $self->{_accessions},
			-molecularWeight 	=> $molecularWeight,
			-sequence64bitCRC 	=> $seq64bitCRC,
			-description		=> join(" ", @{$self->{_description}})
			)
		);
	
	# Just in case.
	$self->{_entryName} 		= undef;
	$self->{_dataClass} 		= undef;
	$self->{_moleculeType} 		= undef;
	$self->{_sequenceLength} 	= undef;
	$self->{_accessions}		= undef;
	$self->{_description}		= undef;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSwissProtRecordCollection {
	return shift->{_swissProtRecordCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


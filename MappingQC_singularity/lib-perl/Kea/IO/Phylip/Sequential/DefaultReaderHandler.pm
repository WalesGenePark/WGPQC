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
package Kea::IO::Phylip::Sequential::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Phylip::Sequential::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Phylip::Sequential::IReaderHandler);

## Purpose		: 

use strict;
use warnings;
use Carp;
use Kea::Arg;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

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
	
	my $sequenceCollection = Kea::Sequence::SequenceCollection->new;
	
	my $self = {
		_sequenceCollection => $sequenceCollection
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

sub header {
	my ($self, $numberOfSequences, $alignmentLength) = @_;
	
	} # End of method.

sub nextSequence {
	my ($self, $id, $sequence) = @_;
	
	$self->{_sequenceCollection}->add(
		Kea::Sequence::SequenceFactory->createSequence(
			-id => $id,
			-sequence => $sequence
			)
		);
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAlignment {
	my $self = shift;
	
	my $sequenceCollection = $self->{_sequenceCollection};
	
	my $alignment = Kea::Alignment::AlignmentFactory->createAlignment(
		$sequenceCollection
		);
	
	return $alignment;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


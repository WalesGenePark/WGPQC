#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 17/02/2008 17:31:49 
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
package Kea::IO::Fasta::PairwiseAlignmentReaderHandler;
use Kea::Object;
use Kea::IO::Fasta::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Fasta::IReaderHandler);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Alignment::Pairwise::PairwiseAlignmentFactory;
use Kea::Sequence::SequenceFactory;

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

my $createDNASequenceObjects = sub {

	my $self 		= shift;
	my $ids 		= $self->check($self->{_ids});
	my $sequences 	= $self->check($self->{_sequences});
	
	if (@$ids > 2) {
		$self->warn(
			"More than two sequences detected.  " .
			"Only the first two will be processed."
			);
		}
	
	if (@$ids < 2) {
		$self->throw(
			"Two sequences required for a pairwise alignment; found " .
			@$ids . "."
			);
		}
	
	if (scalar(@$ids) != scalar(@$sequences)) {
		$self->throw(
			"Number of ids (" . @$ids . 
			") and sequences (" . @$sequences .
			") do not match."
			);
		}
	
	if (length($sequences->[0]) != length($sequences->[1])) {
		$self->throw(
			"Sequences are not aligned."
			);
		}
	
	my $sequence1 =
		Kea::Sequence::SequenceFactory->createSequence(
			-id => $ids->[0],
			-sequence => $sequences->[0]
			);
	
	if (!$sequence1->isDNA) {
		$self->throw(
			$sequence1->getID . " is not DNA."	
			);	
		}
	
	my $sequence2 =
		Kea::Sequence::SequenceFactory->createSequence(
			-id => $ids->[1],
			-sequence => $sequences->[1]
			);
	
	if (!$sequence2->isDNA) {
		$self->throw(
			$sequence2->getID . " is not DNA."	
			);	
		}

	return ($sequence1, $sequence2);
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub _nextHeader {
	my (
		$self,
		$header
		) = @_;
	
	$header =~ /^([\S]+)*/;	
	push(@{$self->{_ids}}, $1);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSequence {
	
	my ($self, $sequence) = @_;
	push(@{$self->{_sequences}}, $sequence);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDNAPairwiseAlignment {
	
	my $self = shift;
	
	my @sequences = $self->$createDNASequenceObjects;
	
	return Kea::Alignment::Pairwise::PairwiseAlignmentFactory->
		createDNAPairwiseAlignment(
			-sequence1 => $sequences[0],
			-sequence2 => $sequences[1]
			);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCDSPairwiseAlignment {
	
	my $self = shift;
	
	my @sequences = $self->$createDNASequenceObjects;
	
	foreach (@sequences) {
		$self->throw(
			"Sequence '" . $_->getID . 
			"' is not of CDS length: " . $_->getSize . 
			"bp"
			) if $_->getSize % 3 != 0;
		}
	
	return Kea::Alignment::Pairwise::PairwiseAlignmentFactory->
		createCDSPairwiseAlignment(
			-sequence1 => $sequences[0],
			-sequence2 => $sequences[1]
			);
	
	} #ÊEnd of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


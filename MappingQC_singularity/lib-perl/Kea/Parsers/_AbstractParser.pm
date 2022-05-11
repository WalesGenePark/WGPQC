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
package Kea::Parsers::_AbstractParser;

## Purpose		: 

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

use Kea::Sequence::SequenceFactory;
use Kea::Sequence::SequenceCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR


################################################################################


# METHODS

## Purpose		: Returns array of header lines.
## Returns		: Array of strings.
sub getHeaders {return @{shift->{_headers}};} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns array of codes embedded with header lines (assumes code to be first block of characters separated by whitespace from rest).
## Returns		: Array of strings.
sub getCodes {return @{shift->{_codes}};} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns hashmap with codes as keys, and sequences as values.
## Returns		: Returns hash, with code strings as keys and sequence strings as values.
sub getSequencesAsHash {
	my $self = shift;
	my @codes = $self->getCodes;
	my @sequences = $self->getSequences;
	my %hash;
	for (my $i = 0; $i < scalar(@codes); $i++) {
		$hash{$codes[$i]} = $sequences[$i];
		}
	return %hash;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceObjects {
	my $self = shift;
	
	my @codes = $self->getCodes;
	my @sequences = $self->getSequences;
	my $sequenceFactory = Kea::Sequence::SequenceFactory->new;
	
	my @array;
	for (my $i = 0; $i < scalar(@codes); $i++) {
		my $seqObj = $sequenceFactory->createSequence(-id => $codes[$i], -sequence => $sequences[$i]);
		push(@array, $seqObj);
		}
	return @array;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceCollection {
	my $self = shift;
	
	my @array = $self->getSequenceObjects;
	
	my $sequenceCollection = Kea::Sequence::SequenceCollection->new;
	foreach my $sequence (@array) {
		$sequenceCollection->add($sequence);
		}
	
	return $sequenceCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns array of sequence strings.
## Returns		: Array of strings.
sub getSequences {return @{shift->{_sequences}};} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Checks whether sequence is present corresponding to supplied code (e.g. accession).
##ÊParameter	: Code string (e.g. accession) to check.
##ÊReturns		: Returns true (1) if sequence found, else false (0).
sub hasSequence {
	my ($self, $query) = shift;
	my @codes = $self->getCodes();
	foreach my $code (@codes) {
		if ($code eq $query) {
			return TRUE;
			}
		}
	return FALSE;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

## Purpose		: Returns individual sequence string corresponding to supplied code string.
## Parameter	: Code (e.g. accession) string.
## Returns		: Sequence string.
## Throws		: Dies if no sequence corresponding the supplied code can be found.  If this seems to harsh, try hasSequence() method first!
sub getSequence {
	my ($self, $query) = @_;
	my @codes = $self->getCodes();
	my @sequences = $self->getSequences();

	for (my $i = 0; $i < scalar(@codes); $i++) {
		if ($query eq $codes[$i]) {
			return $sequences[$i];
			}
		}
	die "ERROR: Could not find sequence for code '$query'.";
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


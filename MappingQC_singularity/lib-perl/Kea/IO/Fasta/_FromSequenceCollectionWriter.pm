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
package Kea::IO::Fasta::_FromSequenceCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my $sequenceCollection =
		Kea::Object->check(shift, "Kea::Sequence::SequenceCollection");

	my @codes;
	my @sequences;
	
	my @sequenceObjects = $sequenceCollection->getSequenceObjects;
	if (scalar(@sequenceObjects) == 0) {
		Kea::Object->throw("No sequence objects stored in collection");
		} 
	
	foreach my $seqObject (@sequenceObjects) {
		push(@codes, $seqObject->getID);
		push(@sequences, $seqObject->getSequence);
		}
	
	# Shouldn't happen - but left over from earlier bug hunt!
	if (scalar(@codes) == 0) {
		Kea::Object->throw("No sequence ids could be extracted");
		} 
	
	# Shouldn't happen - but left over from earlier bug hunt!
	if (scalar(@sequences) == 0) {
		Kea::Object->throw("No sequence ids could be extracted");
		}
	
	my $self = {
		_headers => \@codes,
		_sequences => \@sequences
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

sub write {
	
	my $self 		= shift;
	my $FILEHANDLE 	= $self->check(shift);
	
	my @headers = @{$self->{_headers}};
	my @sequences = @{$self->{_sequences}};
	
	for (my $i = 0; $i < scalar(@headers); $i++) {
		
		# Shouldn't happen - but left over from earlier bug hunt!
		if (!defined($headers[$i])) {
			$self->check("No sequence id recorded at index [$i]");
			}
	
		print $FILEHANDLE ">$headers[$i]\n";
		
		# Shouldn't happen - but left over from earlier bug hunt!
		if (!defined($sequences[$i])) {
			$self->check("No sequence recorded at index [$i]");
			}
		
		my $sequence = $sequences[$i];
		$sequence =~ s/\s//g;
		
		# Dice sequence into 60 character chunks
		for (my $j = 0; $j < length($sequence); $j = $j + 60) {
			my $block = substr($sequence, $j, 60);
			print $FILEHANDLE $block . "\n";
			}
		
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;
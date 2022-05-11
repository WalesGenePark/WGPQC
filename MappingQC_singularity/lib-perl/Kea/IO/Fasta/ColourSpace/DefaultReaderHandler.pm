#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 04/08/2008 11:11:18
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
package Kea::IO::Fasta::ColourSpace::DefaultReaderHandler;
use Kea::IO::Fasta::ColourSpace::IReaderHandler;
use Kea::Object;
our @ISA = qw(Kea::Object Kea::IO::Fasta::ColourSpace::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Sequence::ColourSpace::SequenceCollection;
use Kea::Sequence::ColourSpace::SequenceFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $self = {
		_ids		=> undef,
		_sequence	=> undef
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
	
	$header =~ /^([\S]+)*/;	
	push(@{$self->{_ids}}, $1);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextSequence {
	my ($self, $sequence) = @_;
	push(@{$self->{_sequences}}, $sequence);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceCollection {
	
	my $self = shift;
	
	my $ids = $self->{_ids};
	my $sequences = $self->{_sequences};
	
	my $csSequenceCollection =
		Kea::Sequence::ColourSpace::SequenceCollection->new("");
	
	for (my $i = 0; $i < @$ids; $i++) {
		$csSequenceCollection->add(
			Kea::Sequence::ColourSpace::SequenceFactory->createSequence(
				-id 		=> $ids->[$i],
				-sequence	=> $sequences->[$i]
				)
			);
		}
	
	return $csSequenceCollection;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


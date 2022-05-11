#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 17/02/2008 17:16:05 
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
package Kea::Alignment::Pairwise::PairwiseAlignmentFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Alignment::Pairwise::_DNAPairwiseAlignment;
use Kea::Alignment::Pairwise::_CDSPairwiseAlignment;
use Kea::Alignment::Pairwise::_ProteinPairwiseAlignment;
use Kea::Alignment::ColumnCollection;
use Kea::Alignment::ColumnFactory;

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

my $privateMethod = sub {
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub createCDSPairwiseAlignment {
	
	my $self = shift;
	my %args = @_;
	
	my $sequence1 = $self->check($args{-sequence1}, "Kea::Sequence::ISequence");
	my $sequence2 = $self->check($args{-sequence2}, "Kea::Sequence::ISequence");
	
	if ($sequence1->isDNA && $sequence2->isDNA) {
	
		if ($sequence1->getSize % 3 == 0 && $sequence2->getSize % 3 == 0) {
			
			return Kea::Alignment::Pairwise::_CDSPairwiseAlignment->new(
				$sequence1,
				$sequence2
				);
			
			}
		else {
			$self->throw(
				"At least one of the sequences are not of correct CDS length."
				);
			}
	
		
		
		}
	else {
		$self->throw("Sequences do not appear to be DNA.");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createDNAPairwiseAlignment {

	my $self = shift;
	my %args = @_;
	
	my $sequence1 = $self->check($args{-sequence1}, "Kea::Sequence::ISequence");
	my $sequence2 = $self->check($args{-sequence2}, "Kea::Sequence::ISequence");
	
	if ($sequence1->isDNA && $sequence2->isDNA) {
	
		return Kea::Alignment::Pairwise::_DNAPairwiseAlignment->new(
			$sequence1,
			$sequence2
			);
		
		}
	else {
		$self->throw("Sequences do not appear to be DNA.");
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


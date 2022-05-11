#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 20/02/2008 21:01:50 
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
package Kea::Alignment::Pairwise::StatisticsFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Alignment::Pairwise::_DNAStatistics;

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

sub createStatistics {

	my $self = shift;
	my $object =
		$self->check(shift, "Kea::Alignment::Pairwise::IPairwiseAlignment");
	
	#if ($object->isa("Kea::Alignment::Pairwise::_DNAPairwiseAlignment")) {
		return Kea::Alignment::Pairwise::_DNAStatistics->new(
			$object->getMatrix
			);
	#	}
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createDNAStatistics {
	
	my $self = shift;
	my $matrix = $self->check(shift);
	
	return Kea::Alignment::Pairwise::_DNAStatistics->new(
		$matrix
		);
	
		
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


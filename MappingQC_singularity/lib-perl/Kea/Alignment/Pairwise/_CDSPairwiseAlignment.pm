#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 17/02/2008 17:18:37 
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
package Kea::Alignment::Pairwise::_CDSPairwiseAlignment;
use Kea::Object;
use Kea::Alignment::Pairwise::_AbstractPairwiseAlignment;
our @ISA = qw(Kea::Object Kea::Alignment::Pairwise::_AbstractPairwiseAlignment);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR


################################################################################

#ÊPRIVATE METHODS


################################################################################

# PUBLIC METHODS

sub getSizeInCodons {
	
	my $self = shift;
	my $size = $self->getSize;
	
	if ($size % 3 == 0) {
		return $size/3;
		}
	else {
		$self->throw("Alignment not of length expected for cds: $size.");
		}
		
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# Overrides parent class.
sub removeSitesWithGaps {
	
	my $self 				= shift;
	my $columnCollection 	= $self->getColumnCollection;
	
	my $newColumnCollection = Kea::Alignment::ColumnCollection->new(
		$self->getIds
		);
	$newColumnCollection->setOverallId(
		$columnCollection->getOverallId
		);
	
	for (my $i = 0; $i < $columnCollection->getSize; $i = $i+3) {
		
		my @columns;
		$columns[0] = $columnCollection->get($i);
		$columns[1] = $columnCollection->get($i+1);
		$columns[2] = $columnCollection->get($i+2);
		
		if (
			$columns[0]->hasGaps &&
			$columns[1]->hasGaps &&
			$columns[2]->hasGaps
			) {
			next;	
			}
		elsif (
			!$columns[0]->hasGaps &&
			!$columns[1]->hasGaps &&
			!$columns[2]->hasGaps
			) {
			$newColumnCollection->add($columns[0]);
			$newColumnCollection->add($columns[1]);
			$newColumnCollection->add($columns[2]);
			}
		
		else {
			$self->throw("Non-codon-like gaps found.");
			}
		
		}
	
	$self->setColumnCollection($newColumnCollection);
	
	} # End of method.


#///////////////////////////////////////////////////////////////////////////////

sub removeSitesWithDegeneracy {
	
	my $self 				= shift;
	my $columnCollection 	= $self->getColumnCollection;
	
	my $newColumnCollection = Kea::Alignment::ColumnCollection->new(
		$self->getIds
		);
	$newColumnCollection->setOverallId(
		$columnCollection->getOverallId
		);
	
	for (my $i = 0; $i < $columnCollection->getSize; $i = $i+3) {
		
		my @columns;
		$columns[0] = $columnCollection->get($i);
		$columns[1] = $columnCollection->get($i+1);
		$columns[2] = $columnCollection->get($i+2);
		
		if (
			!$columns[0]->hasDegeneracy &&
			!$columns[1]->hasDegeneracy &&
			!$columns[2]->hasDegeneracy
			) {
			$newColumnCollection->add($columns[0]);
			$newColumnCollection->add($columns[1]);
			$newColumnCollection->add($columns[2]);
			}
		
		}
	
	$self->setColumnCollection($newColumnCollection);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


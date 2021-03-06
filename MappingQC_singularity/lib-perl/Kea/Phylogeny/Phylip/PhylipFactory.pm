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
package Kea::Phylogeny::Phylip::PhylipFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE	=> 0;

use Kea::Phylogeny::Phylip::_AlignmentProtDist;
use Kea::Phylogeny::Phylip::_AlignmentDnaDist; 
use Kea::Phylogeny::Phylip::_MatrixNeighbor;
use Kea::Phylogeny::Phylip::_DrawTree;
use Kea::Phylogeny::Phylip::_AlignmentProml;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

## Purpose		: Constructor.
## Parameter	: n/a.
## Throws		: n/a.
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

#?PRIVATE METHODS

my $privateMethod = sub {
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub createDnaDist {
	
	my $self 		= shift;
	my $alignment 	= $self->check(shift, "Kea::Alignment::IAlignment");
	
	return Kea::Phylogeny::Phylip::_AlignmentDnaDist->new($alignment); 
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createProtDist {
	
	my $self 		= shift;
	my $alignment 	= $self->check(shift, "Kea::Alignment::IAlignment");
	
	return Kea::Phylogeny::Phylip::_AlignmentProtDist->new($alignment); 
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createNeighbor {
	
	my $self 		= shift;
	my $matrix 		= $self->check(shift, "Kea::Phylogeny::IMatrix");
	
	return Kea::Phylogeny::Phylip::_MatrixNeighbor->new($matrix);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createProml {
	
	my $self 		= shift;
	my $alignment 	= $self->check(shift, "Kea::Alignment::IAlignment");
	
	return Kea::Phylogeny::Phylip::_AlignmentProml->new($alignment);
	
	} #?End of method.

#///////////////////////////////////////////////////////////////////////////////

sub createDrawTree {
	
	my $self = shift;
	return Kea::Phylogeny::Phylip::_DrawTree->new;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


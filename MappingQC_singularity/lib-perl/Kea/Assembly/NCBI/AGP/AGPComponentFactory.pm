#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 08/05/2008 09:40:58
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
package Kea::Assembly::NCBI::AGP::AGPComponentFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Assembly::NCBI::AGP::_AGPComponent;

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

sub createAGPComponent {
	
	my $self = shift;
	my %args = @_;
	
	return Kea::Assembly::NCBI::AGP::_AGPComponent->new(
	
		# OBIGATORY
		-location 			=> $self->check($args{-location}, "Kea::IO::Location"), 
		-partNumber 		=> $self->check($args{-partNumber}),
		-componentType 		=> $self->check($args{-componentType}),
		
		# TYPE A (component type not N).
		-componentId 		=> $args{-componentId},
		-componentLocation 	=> $args{-componentLocation},
		-orientation 		=> $args{-orientation},
		
		# TYPE B (component type N [gap with specified size]).
		-gapLength			=> $args{-gapLength},
		-gapType		 	=> $args{-gapType},
		-linkage	 		=> $args{-linkage}
		
		);
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


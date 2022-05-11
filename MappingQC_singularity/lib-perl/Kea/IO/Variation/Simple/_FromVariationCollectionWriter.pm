#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 24/04/2008 15:22:51
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
package Kea::IO::Variation::Simple::_FromVariationCollectionWriter;
use Kea::Object;
use Kea::IO::IWriter;
our @ISA = qw(Kea::Object Kea::IO::IWriter);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $variationCollection =
		Kea::Object->check(
			shift,
			"Kea::Alignment::Variation::VariationCollection"
			);
	
	my $self = {
		_variationCollection => $variationCollection
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

	my $self 					= shift;
	my $FILEHANDLE		 		= $self->check(shift);
	my $variationCollection 	= $self->{_variationCollection};
	
	for (my $i = 0; $i < $variationCollection->getSize; $i++) {
		my $variation = $variationCollection->get($i);
		
		my $attributes = "";
		if (!$variation->getAttributes->isEmpty) {
			$attributes = "\t[" . $variation->getAttributes->toString . "]";
			}
		
		printf $FILEHANDLE (
			"%d\t%d\t%s\t%s\t%s\t%s%s\n",
			
			$variation->getBeforeLocation->getStart,
			$variation->getBeforeLocation->getEnd,
			
			$variation->getBeforeId,
			$variation->getAfterId,
			
			$variation->getBefore,
			$variation->getAfter,
		
			$attributes
			
			) or $self->throw("Could not print to outfile.");
			
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


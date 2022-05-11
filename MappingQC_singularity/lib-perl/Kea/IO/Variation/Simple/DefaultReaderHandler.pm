#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 25/04/2008 11:58:18
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
package Kea::IO::Variation::Simple::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Variation::Simple::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Variation::Simple::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::Alignment::Variation::VariationFactory;
use Kea::Alignment::Variation::VariationCollection;
use Kea::IO::Location;
use Kea::Graphics::ColourFactory;
use Kea::AttributesFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $variationCollection =
		Kea::Alignment::Variation::VariationCollection->new("");
	
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

sub _nextLine {

	my $self = shift;
	
	my $beforeStart 	= shift;	# before start position.
	my $beforeEnd		= shift;	# before end position.
	my $beforeId 		= shift;	# before id.
	my $afterId			= shift;	# after id.
	my $before			= shift;	# before allele.
	my $after			= shift;	# after allele.
	my $attributes		= shift;	# Attributes string.
	
	my $variation = Kea::Alignment::Variation::VariationFactory->createVariation(
			-beforeLocation => Kea::IO::Location->new($beforeStart, $beforeEnd),
			-before			=> $before,
			-after			=> $after,
			-beforeId		=> $beforeId,
			-afterId		=> $afterId
			);
	
	if (defined $attributes) {
		$variation->setAttributes(
			Kea::AttributesFactory->createAttributes($attributes)
			);
		}
	
	$self->{_variationCollection}->add($variation);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getVariationCollection {
	return shift->{_variationCollection};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


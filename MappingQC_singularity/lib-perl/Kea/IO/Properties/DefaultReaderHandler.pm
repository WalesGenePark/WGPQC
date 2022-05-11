#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 01/03/2009 13:15:07
#    Copyright (C) 2009, University of Liverpool.
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
package Kea::IO::Properties::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::Properties::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::Properties::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::IO::Properties::PropertyCollection;
use Kea::IO::Properties::_Property;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $propertyCollection = Kea::IO::Properties::PropertyCollection->new("");
	
	my $self = {
		_propertyCollection => $propertyCollection
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

sub _nextProperty {
	
	my $self	= shift;
	my $key		= $self->check(shift);
	my $value	= $self->check(shift);
	
	$self->{_propertyCollection}->add(
		Kea::IO::Properties::_Property->new($key, $value)
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPropertyCollection {
	return shift->{_propertyCollection};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPropertiesAsHash {
	
	my $self = shift;
	
	my %properties;
	my $propertyCollection = $self->getPropertyCollection;
	for (my $i = 0; $i < $propertyCollection->getSize($i); $i++) {
		my $property = $propertyCollection->get($i);
		$properties{$property->getKey} = $property->getValue;
		}
	
	return %properties;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


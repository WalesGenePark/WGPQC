#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 07/05/2008 17:31:45
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
package Kea::IO::NCBI::AGP::DefaultReaderHandler;
use Kea::Object;
use Kea::IO::NCBI::AGP::IReaderHandler;
our @ISA = qw(Kea::Object Kea::IO::NCBI::AGP::IReaderHandler);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;

use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant UNKNOWN	=> "unknown";
use constant NA			=> "not applicable";

use constant GAP		=> "-";

use Kea::Assembly::NCBI::AGP::AGPObjectCollection;
use Kea::Assembly::NCBI::AGP::AGPObjectFactory;
use Kea::Assembly::NCBI::AGP::AGPComponentFactory;
use Kea::IO::Location;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my $agpObjectCollection =
		Kea::Assembly::NCBI::AGP::AGPObjectCollection->new("");
	
	my $self = {
		_agpObjectCollection 	=> $agpObjectCollection,
		_currentAgpObject		=> undef
		};
	
	bless(
		$self,
		$className
		);
	
	return $self;
	
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $storeCurrentObject = sub {
	
	my $self = shift;
	my $currentAgpObject = $self->{_currentAgpObject};
	
	$self->{_agpObjectCollection}->add(
		$currentAgpObject
		);

	# Play safe...
	$self->{_currentAgpObject} = undef;
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub _nextLineA {
	
	my $self = shift;
	
	my $id 				= shift;	# id 	(object)
	
	my $start			= shift;	# start (object_beg)
	my $end				= shift;	# end 	(object_end)
	my $partNumber 		= shift;	# part_number 		- The line count for the components/gaps that make up the object
	my $componentType 	= shift;	# component_type 	- The sequencing status of the component.
	
	my $componentId		= shift;	# component_id		- If column 5 not equal to N: This is a unique identifier for the sequence component contributing to the object described in column 1.
	my $componentStart	= shift;	# component_beg		- If column 5 not equal to N: This column specifies the beginning of the part of the component sequence that contributes to the object in column 1
	my $componentEnd 	= shift;	# component_end		- If column 5 not equal to N: This column specifies the end of the part of the component that contributes to the object in column 1.
	my $orientation		= shift;	# orientation		- If column 5 not equal to N: This column specifies the orientation of the component relative to the object in column 1.
	
	
	# process component orientation.
	my $componentOrientation;
	if 		($orientation eq "+") 	{$componentOrientation = SENSE;}
	elsif 	($orientation eq "-") 	{$componentOrientation = ANTISENSE;}
	elsif 	($orientation eq "0") 	{$componentOrientation = UNKNOWN;}
	elsif 	($orientation eq "na") 	{$componentOrientation = NA;}
	else {
		$self->throw("Unsupported orientation: $orientation.");
		}
	
	
	# Create component.
	my $agpComponent =
		Kea::Assembly::NCBI::AGP::AGPComponentFactory->createAGPComponent(
			
			-location 			=> Kea::IO::Location->new($start, $end), # Location of component within object.
			-partNumber 		=> $partNumber,
			-componentType 		=> $componentType,
			
			-componentId 		=> $componentId,
			-componentLocation 	=> Kea::IO::Location->new($componentStart, $componentEnd),
			-orientation 		=> $componentOrientation
			
			);
	
	
	
	# Get/create agp object in which to store component.
	
	# First object.
	if (!defined $self->{_currentAgpObject}) {
		$self->{_currentAgpObject} =
			Kea::Assembly::NCBI::AGP::AGPObjectFactory->createAGPObject(
				-id => $id
				);
		
		}
	
	# New object.
	if ($id ne $self->{_currentAgpObject}->getId) {
		# Store existing object.
		$self->$storeCurrentObject;
		# Create new object.
		$self->{_currentAgpObject} =
			Kea::Assembly::NCBI::AGP::AGPObjectFactory->createAGPObject(
				-id => $id
				);
		}
	
	# Store component in current object.
	$self->{_currentAgpObject}->getAGPComponentCollection->add(
		$agpComponent
		);
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _nextLineB {

	my $self = shift;
	
	my $id 				= shift;	# id 	(object)
	
	my $start			= shift;	# start (object_beg)
	my $end				= shift;	# end 	(object_end)
	my $partNumber 		= shift;	# part_number 		- The line count for the components/gaps that make up the object
	my $componentType 	= shift;	# component_type 	- The sequencing status of the component - N.
	
	my $gapLength		= shift;	# gap_length		- If column 5 equal to N: This column represents the length of the gap.
	my $gapType 		= shift;	# gap_type			- If column 5 equal to N: This column specifies the gap type.
	my $linkage			= shift;	# linkage			- If column 5 equal to N: This column indicates if there is evidence of linkage between the adjacent lines.
	
	
	# Create component.
	my $agpComponent =
		Kea::Assembly::NCBI::AGP::AGPComponentFactory->createAGPComponent(
		
			-location 			=> Kea::IO::Location->new($start, $end), # Location of component within object.
			-partNumber 		=> $partNumber,
			-componentType 		=> $componentType,
			
			-gapLength			=> $gapLength,
			-gapType		 	=> $gapType,
			-linkage	 		=> $linkage
			
			);
	
	
	
	# Get/create agp object in which to store component.

	# First object.
	if (!defined $self->{_currentAgpObject}) {
		$self->{_currentAgpObject} =
			Kea::Assembly::NCBI::AGP::AGPObjectFactory->createAGPObject(
				-id => $id
				);
		}
	
	# New object.
	if ($id ne $self->{_currentAgpObject}->getId) {
		# Store existing object.
		$self->$storeCurrentObject;
		# Create new object.
		$self->{_currentAgpObject} =
			Kea::Assembly::NCBI::AGP::AGPObjectFactory->createAGPObject(
				-id => $id
				);
		}
	
	# Store component in current object.
	$self->{_currentAgpObject}->getAGPComponentCollection->add(
		$agpComponent
		);
	
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub _endOfFile {
	shift->$storeCurrentObject;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAGPObjectCollection {
	return shift->{_agpObjectCollection};
	} # end of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


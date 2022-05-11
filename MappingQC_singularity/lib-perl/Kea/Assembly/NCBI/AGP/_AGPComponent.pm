#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 08/05/2008 09:38:13
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
package Kea::Assembly::NCBI::AGP::_AGPComponent;
use Kea::Object;
use Kea::Assembly::NCBI::AGP::IAGPComponent;
our @ISA = qw(Kea::Object Kea::Assembly::NCBI::AGP::IAGPComponent);
 
use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;
use constant SENSE 	=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP	=> "-";

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	
	my %args = @_;
	
	my $self = {
	
		# OBIGATORY
		_location 		=> Kea::Object->check($args{-location}, "Kea::IO::Location"), 
		_partNumber 		=> Kea::Object->check($args{-partNumber}),
		_componentType 		=> Kea::Object->check($args{-componentType}),
		
		# TYPE A (component type not N).
		_componentId 		=> $args{-componentId},
		_componentLocation 	=> $args{-componentLocation},
		_orientation 		=> $args{-orientation},
		
		# TYPE B (component type N [gap with specified size]).
		_gapLength			=> $args{-gapLength},
		_gapType		 	=> $args{-gapType},
		_linkage	 		=> $args{-linkage}
		
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

sub getLocation {
	return shift->{_location};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setLocation {
	
	my $self 	= shift;
	my $location 	= $self->check(shift, "Kea::IO::Location");
	
	$self->{_location} = $location;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPartNumber {
	return shift->{_partNumber};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setPartNumber {
	
	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);
	
	$self->{_partNumber} = $i;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getComponentType {
	return shift->{_componentType};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub isComponentTypeW {
	
	my $self = shift;
	
	if ($self->getComponentType eq "W") {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getComponentId {
	
	my $self = shift;
	
	if ($self->{_componentType} =~ /^[NU]$/) {
		$self->throw(
			"Attempting to call id for AGP component of type " .
			$self->{_componentType} . "."
			);
		}
	
	if (!defined $self->{_componentId}) {
		$self->throw("AGP component id is undefined.");
		}
	
	return $self->{_componentId};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setComponentId {
	
	my $self 	= shift;
	my $id 		= $self->check(shift);
	
	$self->{_componentId} = $id;
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getComponentLocation {
	
	my $self = shift;
	
	if ($self->{_componentType} =~ /^[NU]$/) {
		$self->throw(
			"Attempting to call component location for AGP component of type " .
			$self->{_componentType} .
			"."
			);
		}
	
	if (!defined $self->{_componentLocation}) {
		$self->throw("AGP component location is undefined.");
		}
	
	return $self->check($self->{_componentLocation}, "Kea::IO::Location");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrientation {
	
	my $self = shift;
	
	if ($self->{_componentType} =~ /^[NU]$/) {
		$self->throw(
			"Attempting to call orientation for AGP component of type " .
			$self->{_componentType} .
			"."
			);
		}
	
	if (!defined $self->{_orientation}) {
		$self->throw("AGP component orientation is undefined.");
		}
	
	return $self->checkIsOrientation($self->{_orientation});
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOrientation {
	
	my $self = shift;
	my $orientation = $self->checkIsOrientation(shift);
	
	if ($self->{_componentType} =~ /^[NU]$/) {
		$self->throw(
			"Attempting to set orientation for AGP component of type " .
			$self->{_componentType} .
			"."
			);
		}
	
	$self->{_orientation} = $orientation;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGapLength {
	
	my $self = shift;
	
	if ($self->{_componentType} !~ /^[NU]$/) {
		$self->throw(
			"Attempting to call gap length for AGP component of type " .
			$self->{_componentType} . "."
			);
		}
	
	if (!defined $self->{_gapLength}) {
		$self->throw("AGP gap length is undefined.");
		}
	
	return $self->{_gapLength};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGapType {
	
	my $self = shift;
	
	if ($self->{_componentType} !~ /^[NU]$/) {
		$self->throw(
			"Attempting to call gap type for AGP component of type " .
			$self->{_componentType} . "."
			);
		}
	
	if (!defined $self->{_gapType}) {
		$self->throw("AGP gap type is undefined.");
		}
	
	return $self->{_gapType};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLinkage {
	
	my $self = shift;
	
	if ($self->{_componentType} !~ /^[NU]$/) {
		$self->throw(
			"Attempting to call linkage for AGP component of type " .
			$self->{_componentType} . "."
			);
		}
	
	if (!defined $self->{_linkage}) {
		$self->throw("AGP linkage is undefined.");
		}
	
	return $self->{_linkage};
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub clone {
	
	my $self = shift;
	
	return Kea::Assembly::NCBI::AGP::_AGPComponent->new(
		-location 		=> $self->{_location}, 
		-partNumber 		=> $self->{_partNumber},
		-componentType 		=> $self->{_componentType},
		
		# TYPE A (component type not N).
		-componentId 		=> $self->{_componentId},
		-componentLocation 	=> $self->{_componentLocation},
		-orientation 		=> $self->{_orientation},
		
		# TYPE B (component type N [gap with specified size]).
		-gapLength		=> $self->{_gapLength},
		-gapType		=> $self->{_gapType},
		-linkage	 	=> $self->{_linkage}
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self 		= shift;
	my $location		= $self->getLocation->toString;
	my $partNumber		= $self->getPartNumber;
	my $componentType	= $self->getComponentType;
	
	my $gapLength 		= "na";
	my $gapType		= "na";
	my $linkage		= "na";
	
	if ($componentType =~ /^[NU]$/) {
		$gapLength 	= $self->getGapLength;
		$gapType 	= $self->getGapType;
		$linkage	= $self->getLinkage;
		}
	
	my $componentId		= "na";
	my $componentLocation	= "na";
	my $orientation 	= "na";
	if ($componentType eq "W") {
		$componentId 		= $self->getComponentId;
		$componentLocation	= $self->getComponentLocation->toString;
		$orientation		= $self->getOrientation;
		}
	
	return "$location; $partNumber; $componentType; $componentId; $componentLocation; $orientation; $gapLength; $gapType; $linkage";
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 25/04/2008 10:02:44
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
package Kea::Alignment::Variation::_Variation;
use Kea::Object;
use Kea::Alignment::Variation::IVariation;
our @ISA = qw(Kea::Object Kea::Alignment::Variation::IVariation);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";

use Kea::AttributesFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my %args = @_;
	
	my $beforeId	 	= Kea::Object->check($args{-beforeId});
	my $afterId 		= Kea::Object->check($args{-afterId});
	my $before			= Kea::Object->check($args{-before});
	my $after			= Kea::Object->check($args{-after});
	my $beforeLocation 	= Kea::Object->check($args{-beforeLocation}, "Kea::IO::Location");
	
	# May or may not be provided.
	my $attributes;
	if (defined $args{-attributes}) {
		$attributes = Kea::Object->check($args{-attributes}, "Kea::IAttributes");
		}
	else {
		$attributes = Kea::AttributesFactory->createAttributes;
		}
	
	
	my $self = {
	
		_beforeId 		=> $beforeId,
		_afterId		=> $afterId,
		_before			=> $before,
		_after			=> $after,
		_beforeLocation	=> $beforeLocation,
		_attributes 	=> $attributes
		
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

sub getBeforeId {
	return shift->{_beforeId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAfterId {
	return shift->{_afterId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBefore {
	return shift->{_before};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setBefore {
	
	my $self = shift;
	my $before = $self->check(shift);
	$self->{_before} = $before;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAfter {
	return shift->{_after};
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub setAfter {
	
	my $self = shift;
	my $after = $self->check(shift);
	
	$self->{_after} = $after;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getBeforeLocation {
	return shift->{_beforeLocation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAttributes {
	return shift->{_attributes};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setAttributes {
	
	my $self = shift;
	my $attributes = $self->check(shift, "Kea::IAttributes");
	
	$self->{_attributes} = $attributes;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isSnp {
	
	my $self 	= shift;
	my $before 	= $self->getBefore;
	my $after 	= $self->getAfter;
	my $length 	= $self->getBeforeLocation->getLength;
	
	return FALSE if length($before) > 1 || length($after) > 1;
	return FALSE if $before eq GAP || $after eq GAP;
	
	# Passed tests, therefore is a snp.
	return TRUE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $beforeId = $self->getBeforeId;
	my $afterId = $self->getAfterId;
	my $before = $self->getBefore;
	my $after = $self->getAfter;
	my $beforeLocation = $self->getBeforeLocation;
	my $attributesString = $self->getAttributes->toString;
	
	return sprintf(
		"%s %s %s %s %s %s",
		$beforeLocation->toString,
		$beforeId,
		$afterId,
		$before,
		$after,
		$attributesString
		);
		
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


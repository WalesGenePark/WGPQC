#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 22/04/2008 12:02:40
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
package Kea::IO::Gff::_GffFeature;
use Kea::Object;
use Kea::IO::Gff::IGffFeature;
our @ISA = qw(Kea::Object Kea::IO::Gff::IGffFeature);
 
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
	
	my %args = @_;
	
	my $self = {
		_id => $args{-id}
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

sub getId {
	return shift->{_id};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getParent {
	return shift->{_parent};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setParent {
	
	my $self = shift;
	my $parent = $self->check(shift, "Kea::IO::Gff::IGffRecord");
	
	$self->{_parent} = $parent;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSource {
	return shift->{_source};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setSource {
	
	my $self = shift;
	my $source = $self->check(shift);
	
	$self->{_source} = $source;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFeature {
	return shift->{_feature};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setFeature {
	
	my $self = shift;
	my $feature = $self->check(shift);
	
	$self->{_feature} = $feature;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLocation {
	return shift->{_location};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setLocation {
	
	my $self = shift;
	my $location = $self->check(shift, "Kea::IO::Location");
	
	$self->{_location} = $location;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getScore {
	return shift->{_score};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setScore {
	
	my $self = shift;
	my $score = $self->check(shift);
	
	$self->{_score} = $score;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOrientation {
	return shift->{_orientation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOrientation {
	
	my $self = shift;
	my $orientation = $self->checkIsOrientation(shift);
	
	$self->{_orientation} = $orientation;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFrame {
	return shift->{_frame};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setFrame {
	
	my $self = shift;
	my $frame = $self->check(shift);
	
	$self->{_frame} = $frame;
	
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

sub toString {
	
	my $self = shift;
	
	my $id 			= $self->getId;
	my $source 		= $self->getSource;
	my $feature 	= $self->getFeature;
	my $location 	= $self->getLocation;
	my $score 		= $self->getScore;
	my $orientation = $self->getOrientation;
	my $frame 		= $self->getFrame;
	my $attributes 	= $self->getAttributes->toString;
	
	my $text = sprintf(
		"%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
		$id,
		$source,
		$feature,
		$location->getStart,
		$location->getEnd,
		$score,
		$orientation,
		$frame,
		$attributes
		);
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


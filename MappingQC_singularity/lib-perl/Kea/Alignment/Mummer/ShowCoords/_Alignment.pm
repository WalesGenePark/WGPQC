#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 04/06/2008 12:09:38
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
package Kea::Alignment::Mummer::ShowCoords::_Alignment;
use Kea::Object;
use Kea::Alignment::Mummer::ShowCoords::IAlignment;
our @ISA = qw(Kea::Object Kea::Alignment::Mummer::ShowCoords::IAlignment);
 
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
		_queryLocation 		=> $args{-queryLocation},
		_subjectLocation 	=> $args{-subjectLocation},
		_queryId			=> $args{-queryId},
		_subjectId 			=> $args{-subjectId},
		_percentId			=> $args{-percentId},
		_queryOrientation	=> $args{-queryOrientation},
		_subjectOrientation	=> $args{-subjectOrientation}
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

sub getQueryLocation {
	return shift->{_queryLocation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSubjectLocation {
	return shift->{_subjectLocation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQueryOrientation {
	return shift->{_queryOrientation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSubjectOrientation {
	return shift->{_subjectOrientation};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getPercentIdentity {
	return shift->{_percentId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQueryId {
	return shift->{_queryId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSubjectId {
	return shift->{_subjectId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $subjectLocation = $self->getSubjectLocation;
	my $queryLocation = $self->getQueryLocation;
	my $subjectOrientation = $self->getSubjectOrientation;
	my $queryOrientation = $self->getQueryOrientation;
	my $subjectId = $self->getSubjectId;
	my $queryId = $self->getQueryId;
	my $percentId = $self->getPercentIdentity;
	
	my $text =
		sprintf(
			"%s\t%s\t%s\t%s\t%s\t%s\t%s",
			$subjectLocation->toString,
			$queryLocation->toString,
			$subjectOrientation,
			$queryOrientation,
			$subjectId,
			$queryId,
			$percentId
			);

	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 14/02/2008 15:28:22 
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
package Kea::Sequence::_Cluster;
use Kea::Object;
use Kea::Sequence::ICluster;
our @ISA = qw(Kea::Object Kea::Sequence::ICluster);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	
	my %args = @_;
	
	my $overallId = Kea::Object->check($args{-id});
	
	my $sequenceCollection =
		Kea::Object->check(
			$args{-sequenceCollection},
			"Kea::Sequence::SequenceCollection"
			);
	
	my $self = {
		_id 				=> $overallId,
		_sequenceCollection => $sequenceCollection
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

sub getSize {
	return shift->{_sequenceCollection}->getSize;
	} # End of method.

sub getSequenceCollection {
	return shift->{_sequenceCollection};
	} # End of method.

sub getId {
	return shift->{_id};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasSequenceWithId {
	
	my $self 	= shift;
	my $id 		= $self->check(shift);
	
	my $sequenceCollection = $self->getSequenceCollection;
	
	return $sequenceCollection->hasID($id);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceIds {
	
	my $self = shift;
	
	my $sequenceCollection = $self->getSequenceCollection;
	return $sequenceCollection->getIDs;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $id = $self->getId;
	my $sequenceCollection = $self->getSequenceCollection;
	
	return "Cluster $id:\n" . $sequenceCollection->toString;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


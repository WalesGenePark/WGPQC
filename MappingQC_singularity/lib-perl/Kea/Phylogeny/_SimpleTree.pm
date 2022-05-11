#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 
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

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::Phylogeny::_SimpleTree;
use Kea::Object;
use Kea::Phylogeny::ITree;
our @ISA = qw(Kea::Object Kea::Phylogeny::ITree);

## Purpose		: 

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
	my $data = shift;
	
	my $self = {
		_id 	=> undef,
		_data 	=> $data
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

sub getOverallId {

	my $self = shift;
	
	if (defined $self->{_id}) {
		return $self->{_id};	
		}
	
	return $self->warn("No id allocated to tree.");
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOverallId {
	
	my ($self, $id) = @_;
	
	if (defined $self->{_id}) {
		$self->warn(
			"Tree id changed from " .
			$self->{_id} .
			" to $id."
			);
		}
	
	$self->{_id} = $id;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	return shift->{_data};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


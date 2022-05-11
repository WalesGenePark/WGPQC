#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/03/2008 12:56:10 
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
package Kea::Assembly::Newbler::AllDiffs::DiffRegionCollection;
use Kea::Object;
use Kea::ICollection;
our @ISA = qw(Kea::Object Kea::ICollection);

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
	my $id = shift or undef;
	
	my $self = {
		_id 	=> $id,
		_array 	=> []
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
	
	if ($self->hasOverallId) {
		return $self->{_id};
		}
	else {
		$self->throw("No id registered to collection.");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOverallId {

	my $self = shift;
	my $id = $self->check(shift);
	$self->{_id} = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasOverallId {

	my $self = shift;
	
	if (defined $self->{_id}) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub get {
	
	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);
	
	return $self->{_array}->[$i];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAll {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub add {
	
	my $self = shift;
	my $difference = $self->check(shift, "Kea::Assembly::Newbler::AllDiffs::IDiffRegion");
	
	push(@{$self->{_array}}, $difference);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isEmpty {
	
	my $self = shift;
	if (@{$self->{_array}} == 0) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $text = $self->getOverallId . "\n";
	
	my @array = $self->getAll;
	
	foreach my $difference (@array) {
		$text .= $difference->toString;
		}
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


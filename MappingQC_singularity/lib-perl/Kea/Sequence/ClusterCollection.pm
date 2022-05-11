#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 14/02/2008 15:27:52 
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
package Kea::Sequence::ClusterCollection;
use Kea::Object;
use Kea::ICollection;
our @ISA = qw(Kea::Object Kea::ICollection);

## Purpose		: 

use strict;
use warnings;
use Carp;
use Kea::Arg;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
		
	my %args = @_;	
		
	my $self = {
		_id => $args{-id} || undef,
		_array => []
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
	return shift->{_id};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOverallId {
	my $self = shift;
	my $id = Kea::Arg->check(shift);
	$self->{_id} = $id;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub get {
	my $self = shift;
	my $i = Kea::Arg->check(shift);
	
	my $cluster = $self->{_array}->[$i] or $self->throw("No cluster found with index $i.");
	
	return $self->check($cluster, "Kea::Sequence::ICluster");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAll {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub add {
	my $self = shift;
	my $cluster = Kea::Arg->check(shift, "Kea::Sequence::ICluster");
	push(
		@{$self->{_array}},
		$cluster
		);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isEmpty {
	
	my $self = shift;
	
	if (@{$self->{_array}} == 0) {return TRUE;}
	
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	my @clusters = $self->getAll;
	
	if (@clusters == 0) {
		return "Empty cluster collection.";
		}
	
	my $text;
	
	foreach my $cluster (@clusters) {
		$text .= $cluster->toString . "\n";
		}
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 23/04/2008 16:25:39
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
package Kea::_Attributes;
use Kea::Object;
use Kea::IAttributes;
our @ISA = qw(Kea::Object Kea::IAttributes);
 
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
	my $self = {
		_hash => {}
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

sub get {
	my $self = shift;
	my $key = $self->check(shift);
	return $self->{_hash}->{$key};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub set {
	my $self = shift;
	my $key = $self->check(shift);
	my $value = $self->check(shift);
	$self->{_hash}->{$key} = $value;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub has {
	my $self = shift;
	my $key = $self->check(shift);
	
	if (defined $self->{_hash}->{$key}) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	
	} #Êend of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return scalar(keys %{shift->{_hash}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isEmpty {
	
	my $self = shift;
	
	if ($self->getSize == 0) {
		return TRUE;	
		}
	else {
		return FALSE;		
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toArray {
	
	my $self = shift;
	
	my @keys = sort keys %{$self->{_hash}};
	
	my @items;
	foreach my $key (@keys) {
		push(
			@items,
			"$key=" . $self->{_hash}->{$key}
			);
		}	
		
	return \@items;	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my @keys = sort keys %{$self->{_hash}};
	
	my @items;
	foreach my $key (@keys) {
		push(
			@items,
			"$key=" . $self->{_hash}->{$key}
			);
		}	
		
	return join(";", @items);	
		
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


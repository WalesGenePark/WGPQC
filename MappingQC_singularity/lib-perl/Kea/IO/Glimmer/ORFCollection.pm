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

# CLASS NAME
package Kea::IO::Glimmer::ORFCollection;
use Kea::ICollection;
use Kea::Object;
our @ISA = qw(Kea::Object Kea::ICollection);

use strict;
use warnings;

use constant TRUE => 1;
use constant FALSE => 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;

	my %args = @_;
	my $self = {
		_data => [],
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

sub getId {return shift->{_id};} # End of method.

sub getSize {
	return scalar(@{shift->{_data}});
	} # End of method.

sub get {
	my ($self, $i) = @_;
	return $self->{_data}->[$i];
	} # End of method.

sub getAll {
	return @{shift->{_data}};
	} # End of method.

sub add {
	my ($self, $orf) = @_;
	push(@{$self->{_data}}, $orf);
	} # End of method.

sub toString {
	my $self = shift;
	
	my $text = sprintf(
		"ID = %s",
		$self->getId || "Unknown"
		);
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


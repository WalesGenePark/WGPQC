#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 07/03/2008 09:33:20 
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
package Kea::Alignment::Mummer::MummerAlignmentCollection;
use Kea::Object;
use Kea::ICollection;
our @ISA = qw(Kea::Object Kea::ICollection);

## Purpose:
## Representation of MUMmer alignment file as produced by show-aligns script.

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
	my $overallId = shift || "unknown";
	
	my $self = {
		
		_overallId 			=> $overallId,
		_array 				=> [],
		
		_referenceFilePath 	=> undef,
		_queryFilePath		=> undef,
		_referenceId		=> undef,
		_queryId			=> undef
		
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

sub setReferenceFilePath {
	
	my $self = shift;
	my $path = $self->check(shift);
	
	$self->{_referenceFilePath} = $path;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getReferenceFilePath {
	
	my $self = shift;
	
	if (defined $self->{_referenceFilePath}) {
		return $self->{_referenceFilePath}
		}
	else {
		$self->throw("Undefined reference file path.");
		}
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub setQueryFilePath {
	
	my $self = shift;
	my $path = $self->check(shift);
	
	$self->{_queryFilePath} = $path;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQueryFilePath {
	
	my $self = shift;
	
	if (defined $self->{_queryFilePath}) {
		return $self->{_queryFilePath}
		}
	else {
		$self->throw("Undefined query file path.");
		}
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub setReferenceId {
	
	my $self = shift;
	my $id = $self->check(shift);
	
	$self->{_referenceId} = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getReferenceId {
	return shift->{_referenceId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setQueryId {
	
	my $self = shift;
	my $id = $self->check(shift);
	
	$self->{_queryId} = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getQueryId {
	return shift->{_queryId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOverallId {
	return shift->{_overallId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOverallId {

	my $self = shift;
	my $id = $self->check(shift);
	
	$self->{_overallId} = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasOverallId {
	
	my $self = shift;
	
	if (defined $self->{_overallId}) {
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
	my $object = $self->check(shift, "Kea::Alignment::Mummer::IMummerAlignment");
	
	push(
		@{$self->{_array}},
		$object
		);
	
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

sub toString {

	my $self = shift;
	
	my $text = $self->getOverallId . "\n";
	
	foreach my $object (@{$self->{_array}}) {
		$text = $text . $object->toString . "\n";
		}
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


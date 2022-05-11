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
package Kea::Sequence::SequenceCollection;
use Kea::Object;
use Kea::ICollection;
our @ISA = qw(Kea::Object Kea::ICollection);

use strict;
use warnings;
use File::Copy;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Sequence::ISequence;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className 	= shift;
	my $id 			= shift;
	
	if (!defined $id) {
		#Kea::Object->warn("Creating sequence collection without id.");
		$id = "NO_ID_PROVIDED"
		} 
	
	
	#if (!defined $id) {
	#	Kea::Object->warn(
	#		"No id for sequence collection provided. " .
	#		"Will be given default name 'unknown'"
	#		);
	#	$id = "unknown";
	#	}
	
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
		$self->throw("No id set for sequence collection.");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasOverallId {
	
	my $self = shift;
	
	if (defined $self->{_id}) {return TRUE;}
	else {return FALSE;}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOverallId {
	
	my $self 	= shift;
	my $id 		= $self->check(shift);
	
	$self->{_id} = $id;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub add {

	my $self 		= shift;
	my $sequence 	= $self->check(shift, "Kea::Sequence::ISequence");
	
	push(@{$self->{_array}}, $sequence);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub get {

	my $self 	= shift;
	my $i 		= $self->checkIsInt(shift);
	
	$self->throw("No sequence exists for supplied index: $i") if
		!exists $self->{_array}->[$i];
	
	return $self->{_array}->[$i];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasSequenceWithID {
	
	my $self 	= shift;
	my $query 	= $self->check(shift);
	
	foreach my $seq (@{$self->{_array}}) {
		if ($query eq $seq->getID) {
			return TRUE;
			}
		}
	
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceWithID {
	
	my $self 	= shift;
	my $query 	= $self->check(shift);
	
	foreach my $seq (@{$self->{_array}}) {
		if ($query eq $seq->getID) {
			return $seq;
			}
		}
	
	return undef;
	#$self->throw("'$query' does not exist");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceStringWithID {
	
	my $self 	= shift;
	my $query 	= $self->check(shift);
	
	foreach my $seq (@{$self->{_array}}) {
		if ($query eq $seq->getID) {
			return $seq->getSequence;
			}
		}
	
	$self->throw("'$query' does not exist");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getIDs {

	my $self = shift;
	
	my @ids;
	foreach my $sequence (@{$self->{_array}}) {
		push(@ids, $sequence->getID);
		}
	
	$self->warn("No Sequence objects stored!") if !@ids;
	
	return @ids;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceObjects {
	return @{shift->{_array}};
	} # End of method.

sub getAll {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceStrings {

	my $self = shift;
	
	my @sequences;
	foreach my $sequence (@{$self->{_array}}) {
		push(@sequences, $sequence->getSequence);
		}
	
	return @sequences;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasID {

	my $self 	= shift;
	my $id 		= $self->check(shift);
	
	foreach my $seqObj (@{$self->{_array}}) {
		if ($seqObj->getID eq $id) {
			return TRUE;
			}
		}
	return FALSE;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isDNA {
	
	my $self = shift;
	
	my @sequences = $self->getAll;
	
	my $isDNA = $sequences[0]->isDNA;
	# Check all the same.
	foreach my $sequence (@sequences) {
		if ($isDNA != $sequence->isDNA) {
			$self->throw("Not all sequences within collection appear to be DNA.");
			}		
		}
	
	return $isDNA;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceType {
	
	my $self = shift;
	
	my @sequences = $self->getAll;
	
	my $type = $sequences[0]->getSequenceType;
	foreach my $sequence (@sequences) {
		if ($type ne $sequence->getSequenceType) {
			$self->throw(
				"more than one sequence type found in collection: " .
				"$type and " . $sequence->getSequenceType . "."
				);
			}
		}
	
	return $type;
	
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	
	my $self = shift;
	
	my $text = "Size = " . $self->getSize . "\n";
	foreach my $sequence (@{$self->{_array}}) {
		$text .= $sequence->toString . "\n";
		}
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


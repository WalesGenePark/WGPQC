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
package Kea::Assembly::ReadCollection;
use Kea::Object;
use Kea::ICollection;
our @ISA = qw(Kea::Object Kea::ICollection);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE	=> 0;

use Kea::Assembly::ReadFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my $overallId = Kea::Object->check(shift);
	
	my $self = {
	
		_overallId 	=> $overallId,
		_array 		=> []
		
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
	return shift->{_overallId};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub get {
	
	my $self = shift;
	my $arg = $self->check(shift);
	
	my $read = undef;
	
	if ($arg =~ /^\d+$/) {
		$read = $self->{_array}->[$arg];
		}
	
	else {
		$read = $self->getReadWithName($arg);
		}
	
	$self->throw("No read corresponding to $arg.") if !defined $read;
	
	return $read;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub hasReadWithName {
	
	my $self = shift;
	my $name = $self->check(shift);
	
	foreach my $read (@{$self->{_array}}) {
		if ($read->getName eq $name) {
			return TRUE;
			}
		}
	
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getReadWithName {
	
	my $self = shift;
	my $name = $self->check(shift);
	
	foreach my $read (@{$self->{_array}}) {
		if ($read->getName eq $name) {
			return $read;
			}
		}
	
	$self->throw("No read with name '$name'.");
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAll {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub add {

	my $self = shift;
	my $read = $self->check(shift, "Kea::Assembly::IRead");
	
	push(
		@{$self->{_array}},
		$read
		);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

my $mergeReads = sub {
	
	my $self = shift;
	my $masterRead = shift;
	my $duplicates = shift;
	
	# Check all reads have the same charactersistics, if not discard.
	foreach my $duplicate (@$duplicates) {
		if (!$masterRead->equals($duplicate)) {
		
			print $masterRead->toString . "\n";
			print $duplicate->toString . "\n";
		
			$self->throw(
				$duplicate->getName .
				" is not the same as " .
				$masterRead->getName .
				"."
				);
			}	
		}
	
	# All reads confirmed to be identical (except for name...) - therefore can
	# proceed and modify master read before returning..
	$masterRead->setDuplicateReads($duplicates);
	
	return $masterRead;
	
	}; # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSimplifiedReadCollection {
	
	my $self = shift;
	
	# Get array of reads.
	my $reads = $self->{_array};
	
	# Map read objects to sequence strings (taking into account orientation,
	# quality and align clipping info).
	my %hash;
	foreach my $read (@$reads) {
		
		my $key =
			$read->getPaddedRead .
			"-" .
			$read->getOrientation . 
			"-[" .
			$read->getQualClipping->toString .
			"]-[" .
			$read->getAlignClipping->toString  .
			"]";
		
		push(@{$hash{$key}}, $read);
		
		}
	
	# Initialise new read collection.
	my $simplifiedReadCollection = Kea::Assembly::ReadCollection->new("");
	
	# Fill with new reads.
	foreach my $key (keys %hash) {
		
		#ÊGet array of read objects sharing current sequence.
		my $duplicateReads = $hash{$key}; 
		
		# Choose first read to represent remainder.
		my $representativeRead = shift(@$duplicateReads);
		
		#ÊIf only one read associated with sequence, store without further action.
		if (@$duplicateReads == 0) {
			$simplifiedReadCollection->add($representativeRead);
			}
		
		# Otherwise, create new read object which will represent set.
		else {
			$simplifiedReadCollection->add(
				$self->$mergeReads($representativeRead, $duplicateReads)
				);
			}
		}
	
	return $simplifiedReadCollection;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	my $self = shift;
	
	my @reads = $self->getAll;
	
	my $text = "";
	foreach my $read (@reads) {
		$text .= $read->toString . "\n";
		}
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


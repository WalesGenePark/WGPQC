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
package Kea::Alignment::ColumnCollection;
use Kea::Object;
use Kea::ICollection;
our @ISA = qw(Kea::Object Kea::ICollection);

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Sequence::SequenceCollection;
use Kea::Sequence::SequenceFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className 	= shift;
	my @labels 		= @_ or Kea::Object->throw("Expecting label array.");
	
	my $self = {
		_id		=> undef,
		_labels => \@labels,
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

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getOverallId {
	return shift->{_id};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub setOverallId {
	my $self = shift;
	my $id = $self->check(shift);
	$self->{_id} = $id;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub get {

	my $self 	= shift;
	my $i 		= $self->check(shift);

	return $self->{_array}->[$i];

	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getFirst {
	
	my $self = shift;
	my @array = @{$self->{_array}};
	return $array[0];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLast {
	
	my $self = shift;
	my @array = @{$self->{_array}};
	
	return $array[@array-1];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAll {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLabels {
	return @{shift->{_labels}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getLabel {

	my $self	= shift;
	my $i		= $self->check(shift);
	
	return $self->{_labels}->[$i];
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub add {
	my $self 	= shift;
	my $column 	= $self->check(shift, "Kea::Alignment::IColumn");
	push(@{$self->{_array}}, $column);
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

# pops and returns the last column of the collection, shortening the collection
# by one column. 
sub popColumn {
	my $self = shift;
	return pop(@{$self->{_array}});
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

# Removes the first column of collection and returns it, shortening the
# collection by 1 and moving everything down.
sub shiftColumn {
	my $self = shift;
	return shift(@{$self->{_array}});
	}

#///////////////////////////////////////////////////////////////////////////////

sub hasColumns {
	my $self = shift;
	if (@{$self->{_array}} > 0) {
		return TRUE;
		}
	else {
		return FALSE;
		}
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getSequenceCollection {
	
	my $self = shift;
	
	my $sequenceCollection =
		Kea::Sequence::SequenceCollection->new($self->{_id});
	
	my @ids = $self->getLabels;
	my @columns = $self->getAll;
	
	for (my $i = 0; $i < @ids; $i++) {
		
		my $seqString;
		foreach my $column (@columns) {
			$seqString = $seqString . $column->getBaseAt($i);	
			}
		
		$sequenceCollection->add(
			Kea::Sequence::SequenceFactory->createSequence(
				-id 		=> $ids[$i],
				-sequence 	=> $seqString
				)
			);
		
		}
	
	return $sequenceCollection;
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub getUnalignedSequenceCollection {
	
		my $self = shift;
	
	my $sequenceCollection =
		Kea::Sequence::SequenceCollection->new($self->{_id});
	
	my @ids = $self->getLabels;
	my @columns = $self->getAll;
	
	for (my $i = 0; $i < @ids; $i++) {
		
		my $seqString;
		foreach my $column (@columns) {
			my $base = $column->getBaseAt($i);
			if ($base ne "-") {
				$seqString = $seqString . $base;	
				} 
			}
		
		$sequenceCollection->add(
			Kea::Sequence::SequenceFactory->createSequence(
				-id 		=> $ids[$i],
				-sequence 	=> $seqString
				)
			);
		
		}
	
	return $sequenceCollection;
	
	} # end of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	my $self = shift;
	
	my $text = "";
	
	my $array = $self->{_array};
	foreach my $column (@$array) {
		$text = $text . $column->toString . "\n";
		}
	
	return $text;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


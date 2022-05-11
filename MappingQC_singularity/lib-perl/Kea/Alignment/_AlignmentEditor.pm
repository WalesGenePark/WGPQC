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
package Kea::Alignment::_AlignmentEditor;
use Kea::Object;
our @ISA = qw(Kea::Object);


use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant FASTA 		=> "fasta";
use constant EMBL 		=> "embl";
use constant UNKNOWN 	=> "unknown";

use Kea::Alignment::ColumnCollection;
use Kea::Alignment::AlignmentFactory;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className = shift;
	my $alignment = Kea::Object->check(shift, "Kea::Alignment::IAlignment");

	
	my $self = {
		_alignment 			=> $alignment,
		_editedAlignment 	=> $alignment
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

sub trimEnds {
	my $self = shift;
	
	my $alignment = $self->{_editedAlignment};
	
	my $columnCollection = $alignment->getColumnCollection;
	my $newColumnCollection = Kea::Alignment::ColumnCollection->new(
		$alignment->getLabels
		);
	
	# First trim left-side.
	my $start;
	for ($start = 0; $start < $columnCollection->getSize; $start++) {
		my $column = $columnCollection->get($start);
		if (!$column->hasGaps) {last;}
		}
	
	# Now trim right-side.
	my $stop;
	for ($stop = $columnCollection->getSize - 1; $stop >= 0; $stop--) {
		my $column = $columnCollection->get($stop);
		if (!$column->hasGaps) {last;}
		}
	
	for (my $i = $start; $i <= $stop; $i++) {
		$newColumnCollection->add(
			$columnCollection->get($i)
			);
		}
	
	$self->{_editedAlignment} =
		Kea::Alignment::AlignmentFactory->createAlignment(
			$newColumnCollection
			);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub removeGaps {
	my $self = shift;
	my %args = @_ or $self->throw("No arguments.");
	
	my $cutoff = $args{-cutoff} or $self->throw("No cutoff provided.");
	
	if ($cutoff > 1 || $cutoff < 0) {
		$self->throw(
			"Can't have a cutoff of $cutoff.  " .
			"Value must be between 0 and 1, inclusive."
			);
		}
	
	my $alignment = $self->{_editedAlignment};
	
	my $editedColumnCollection = Kea::Alignment::ColumnCollection->new(
		$alignment->getLabels
		);
	
	# For each column in alignment, assess number of gaps - if exceeds cutoff, delete column.
	my $columnCollection = $alignment->getColumnCollection;
	for (my $i = 0; $i < $columnCollection->getSize; $i++) {
		my $column = $columnCollection->get($i);
		my $proportion = $column->getProportionBases;
		# Store in edited collection provided bases exceed cutoff. 
		if ($proportion >= $cutoff) {
			$editedColumnCollection->add(
				$column
				);
			}
		}
	
	# create new alignment object from edited column collection.
	$self->{_editedAlignment} =
		Kea::Alignment::AlignmentFactory->createAlignment(
		$editedColumnCollection
		);
	
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getEditedAlignment {
	my $self = shift;
	
	my $editedAlignment = $self->{_editedAlignment} or
		$self->throw("Edited alignment yet to be produced.");
	
	return $editedAlignment;
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


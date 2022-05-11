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
package Kea::Alignment::Aligner::AlignerFactory;
use Kea::Object;
our @ISA = qw(Kea::Object);

## Purpose		: Creates aligner objects for aligning sequences.

use strict;
use warnings;

use constant TRUE 	=> 1;
use constant FALSE 	=> 0;

use Kea::Alignment::Aligner::_MuscleAlignerFromSequenceCollection;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {
	my $className = shift;
	my $self = {};
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

sub createAligner {

	my $self = shift;
	my %args = @_ or $self->throw("Missing arguments");
	
	my $object = $args{-sequenceCollection} || undef; 	#my $object = $args{-featureCollection} || $args{-sequenceCollection} || undef;
	my $program = $args{-program} or
		$self->throw("Alignment program not specified.");

	# Aligning sequence collection with muscle.
	if (
		$program =~ /^muscle$/i &&
		$object->isa("Kea::Sequence::SequenceCollection")
		) {
		return
			Kea::Alignment::Aligner::_MuscleAlignerFromSequenceCollection->new(
				$object
				);
		}
	
	# Unrecognised object.
	elsif ($program =~ /^muscle$/i) {
		$self->throw("Wrong type - " . ref($object));
		}
	
	# Unrecognised program.
	else{
		$self->throw("Unrecognised program: '$program'");
		}
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


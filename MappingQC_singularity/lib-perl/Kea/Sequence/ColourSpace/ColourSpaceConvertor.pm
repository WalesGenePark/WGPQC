#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 05/08/2008 15:02:47
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
package Kea::Sequence::ColourSpace::ColourSpaceConvertor;
use Kea::Object;
our @ISA = qw(Kea::Object);
 
use strict;
use warnings;

use constant TRUE 		=> 1;
use constant FALSE 		=> 0;
use constant SENSE 		=> "sense";
use constant ANTISENSE 	=> "antisense";
use constant GAP		=> "-";


use Kea::Sequence::ColourSpace::SequenceCollection;
use Kea::Sequence::ColourSpace::SequenceFactory;
use Kea::Sequence::SequenceCollection;
use Kea::Sequence::SequenceFactory;

#                        2nd nucleotide
#                        A       C       G       T
#                A       0       1       2       3
#1st nucleotide  C       1       0       3       2
#                G       2       3       0       1
#                T       3       2       1       0


my $_colours = {
	
	A	=> {A => 0, C => 1, G => 2, T => 3, N => 4},
	C	=> {A => 1, C => 0, G => 3, T => 2, N => 4},
	G	=> {A => 2, C => 3, G => 0, T => 1, N => 4},
	T	=> {A => 3, C => 2, G => 1, T => 0, N => 4},
	N	=> {A => 5, C => 5, G => 5, T => 5, N => 6}
	
	};

my $_reverseColours = {
	
	A	=> {0 => "A", 1 => "C", 2 => "G", 3 => "T", 4 => "N"},
	C	=> {1 => "A", 0 => "C", 3 => "G", 2 => "T", 4 => "N"},
	G	=> {2 => "A", 3 => "C", 0 => "G", 1 => "T", 4 => "N"},
	T 	=> {3 => "A", 2 => "C", 1 => "G", 0 => "T", 4 => "N"}
	
	# Degenerate coding with N - surely - i.e., N5 could be NA, NC, NG, or NT.
	
	};

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

sub toColourSpaceFromString {
	
	my $self = shift;
	my $seqString = $self->check(shift);
	
	my @baseSpace = split("", uc($seqString));
	my @colourSpace;
	
	# Colour space starts with single base to allow decoding of following digits.
	push(@colourSpace, $baseSpace[0]);
 	
	for (my $i = 0; $i < @baseSpace -1; $i++) {
		
		my $firstBase 	= $baseSpace[$i];
		my $secondBase 	= $baseSpace[$i+1];
		
		push(
			@colourSpace,
			$_colours->{$firstBase}->{$secondBase}
			);
		
		}
	
	return join("", @colourSpace);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toColourSpace {

	my $self = shift;
	my $sequence = $self->check(shift, "Kea::Sequence::ISequence");
	
	my @baseSpace = split("", uc($sequence->getSequence));
	my @colourSpace;
	
	# Colour space starts with single base to allow decoding of following digits.
	push(@colourSpace, $baseSpace[0]);
 	
	for (my $i = 0; $i < @baseSpace -1; $i++) {
		
		my $firstBase 	= $baseSpace[$i];
		my $secondBase 	= $baseSpace[$i+1];
		
		push(
			@colourSpace,
			$_colours->{$firstBase}->{$secondBase}
			);
		
		}
	
	
	return
		Kea::Sequence::ColourSpace::SequenceFactory->createSequence(
			-id 		=> $sequence->getID,
			-sequence 	=> join("", @colourSpace)
			);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toBaseSpace {
	
	my $self 		= shift;
	my $csSequence 	= $self->check(shift, "Kea::Sequence::ColourSpace::ISequence");
	
	my @colourSpace = split("", $csSequence->getSequence);
	my @baseSpace;
	
	# identify first base.
	my $firstBase = shift(@colourSpace);
	push(@baseSpace, $firstBase);
	
	for (my $i = 0; $i < @colourSpace; $i++) {
		
		my $nextBase = $_reverseColours->{$firstBase}->{$colourSpace[$i]};
		
		push(
			@baseSpace,
			$nextBase
			);
		
		$firstBase = $nextBase;
		}
	
	return
		Kea::Sequence::SequenceFactory->createSequence(
			-id 		=> $csSequence->getID,
			-sequence 	=> join("", @baseSpace)
			);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toBaseSpaceFromString {
	
	my $self 		= shift;
	my $csSeqString	= shift;
	
	my @colourSpace = split("", $csSeqString);
	my @baseSpace;
	
	# identify first base.
	my $firstBase = shift(@colourSpace);
	push(@baseSpace, $firstBase);
	
	for (my $i = 0; $i < @colourSpace; $i++) {
		
		my $nextBase = $_reverseColours->{$firstBase}->{$colourSpace[$i]};
		
		push(
			@baseSpace,
			$nextBase
			);
		
		$firstBase = $nextBase;
		}
	
	return join("", @baseSpace);
	
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


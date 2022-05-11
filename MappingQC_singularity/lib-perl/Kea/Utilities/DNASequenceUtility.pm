#!/usr/bin/perl -w

#===============================================================================
#
#    Created: 11/02/2008 20:36:52 
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
package Kea::Utilities::DNASequenceUtility;
use Kea::Object;
our @ISA = qw(Kea::Object);

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
	my $sequence = Kea::Arg->check(shift, "Kea::Sequence::ISequence");
	
	if (!$sequence->isDNA) {
		confess "\nERROR: Expecting DNA sequence, not " .
		$sequence->getSequenceType .
		".\n\n";
		}
	
	my $self = {
		_sequence => $sequence->getSequence
		};
	
	bless(
		$self,
		$className
		);
	return $self;
	} # End of constructor.

################################################################################

#ÊPRIVATE METHODS

my $count = sub {
	
	my $self = shift;
	my $base = shift;

	my @bases = split("", uc($self->{_sequence}));
	
	my $counter = 0;
	foreach (@bases) {
		$counter++ if $_ eq $base;	
		}
	return $counter;
	
	}; # End of method.

################################################################################

# PUBLIC METHODS

sub getACount {
	return shift->$count("A");
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCCount {
	return shift->$count("C");
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGCount {
	return shift->$count("G");
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTCount {
	return shift->$count("T");
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAFrequency {
	my $self = shift;
	return $self->getACount / $self->getSize;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getCFrequency {
	my $self = shift;
	return $self->getCCount / $self->getSize;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getGFrequency {
	my $self = shift;
	return $self->getGCount / $self->getSize;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getTFrequency {
	my $self = shift;
	return $self->getTCount / $self->getSize;
	} # End of method.


################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


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

#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////

# CLASS NAME
package Kea::Sequence::CodonCollection;
use Kea::Object;
use Kea::ICollection;
our @ISA = qw(Kea::Object Kea::ICollection);

## Purpose		: 

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE	=> 0;

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

sub getSize {
	return scalar(@{shift->{_array}});
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub get {
	my ($self, $i) = @_;
	
	if (exists $self->{_array}->[$i]) {
		return $self->{_array}->[$i];
		}
	else {
		$self->throw("Index '$i' does not exist");
		}
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getAll {
	return @{shift->{_array}};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub add {
	
	my $self	= shift;
	my $codon 	= $self->check(shift, "Kea::Sequence::ICodon");
	
	push(@{$self->{_array}}, $codon);
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	my $array = shift->{_array};
	my $sequence = "";
	foreach my $codon (@$array) {
		$sequence = $sequence . $codon->toString;
		}
	return $sequence;
	} # End of method.

#===============================================================================

sub hasStopWithinCollection {
	
	my $codons = shift->{_array};
	
	for (my $i = 1; $i < @$codons-1; $i++) {
		if ($codons->[$i]->isStopCodon) {
			return TRUE;
			}
		}
	
	return FALSE;
	
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isOk {
	
	my $self = shift;
	
	my $array = $self->{_array};
	
	# Warn if unusual
	if (!$array->[0]->isStartCodon) {
		$self->warn(
			"Codon collection does not start with a recognised start codon."
			);
		return FALSE;
		}
	
	for (my $i = 1; $i < @$array-1; $i++) {
		if ($array->[$i]->isStopCodon) {
			$self->warn(
				"Codon collection contains stop codons WITHIN collection."
				);
			return FALSE;
			}
		}
	
	if (!$array->[@$array-1]->isStopCodon) {
		$self->warn(
			"Codon collection does not end with a recognised stop codon."
			);
		return FALSE;
		}
	
	return TRUE;
	
	} # end of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;


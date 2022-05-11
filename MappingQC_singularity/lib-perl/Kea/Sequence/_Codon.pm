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
package Kea::Sequence::_Codon;
use Kea::Object;
use Kea::Sequence::ICodon;
our @ISA = qw(Kea::Object Kea::Sequence::ICodon);

use strict;
use warnings;

use constant TRUE	=> 1;
use constant FALSE	=> 0;

################################################################################

# CLASS FIELDS

################################################################################

# CONSTRUCTOR

sub new {

	my $className	= shift;
	my $codon 		= Kea::Object->check(shift);
	my $aa 			= Kea::Object->check(shift);
	
	# Make sure codon is uppercase and rna.
	$codon =~ tr/a-z/A-Z/;
	$codon =~ tr/T/U/;
	
	# Just in case...
	Kea::Object->throw("Not a codon: '$codon'") if length($codon) != 3;
	
	my $self = {
		_codon	=> $codon,
		_aa 	=> $aa
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

sub getAminoAcid {
	return shift->{_aa};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub getDNA {
	my $codon = shift->{_codon};
	$codon =~ tr/U/T/;
	return $codon;
	} #ÊEnd of method.

#///////////////////////////////////////////////////////////////////////////////

sub getRNA {
	return shift->{_codon};
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isStartCodon {
	if (shift->{_codon} =~ /AUG|GUG|UUG/) {
		return TRUE;
		}
	return FALSE;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub isStopCodon {
	if (shift->{_codon} =~ /UAG|UGA|UAA/) {
		return TRUE;
		}
	return FALSE;
	} # End of method.

#///////////////////////////////////////////////////////////////////////////////

sub toString {
	return shift->{_codon};
	} # End of method.

################################################################################
	
#///////////////////////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////////////////////
1;

